/*query to extract data*/

WITH pancreatitis_patients AS (
  SELECT DISTINCT subject_id, hadm_id
  FROM physionet-data.mimiciv_3_1_hosp.diagnoses_icd
  WHERE (
    (icd_code = '5770' AND icd_version = 9) OR
    (icd_code LIKE 'K85%' AND icd_version = 10)
  )
),
creatinine_data AS (
  SELECT 
    kc.hadm_id,
    MAX(kc.creat) AS max_creatinine,
    baseline.scr_baseline AS baseline_creatinine,
    CASE
      WHEN MAX(kc.creat) >= baseline.scr_baseline * 1.5 OR
           MAX(kc.creat) - MIN(kc.creat_low_past_48hr) >= 0.3 THEN 1
      ELSE 0
    END AS creatinine_aki
  FROM physionet-data.mimiciv_derived.kdigo_creatinine kc
  JOIN physionet-data.mimiciv_derived.creatinine_baseline baseline
    ON kc.hadm_id = baseline.hadm_id
  GROUP BY kc.hadm_id, baseline.scr_baseline
),
urine_output_data AS (
  SELECT
    kuo.stay_id,
    MIN(kuo.weight) AS weight,
    SUM(kuo.urineoutput_6hr) AS total_urine_output,
    CASE
      WHEN SUM(kuo.urineoutput_6hr) < (0.5 * MIN(kuo.weight) / 6) THEN 1
      ELSE 0
    END AS urine_aki
  FROM physionet-data.mimiciv_derived.kdigo_uo kuo
  GROUP BY kuo.stay_id
)
SELECT DISTINCT icu.subject_id,
       adm.admission_type,
       adm.insurance,
       adm.race,
       icu.los_hospital,
       age_data.age,
       vitals.glucose_mean,
       vitals.heart_rate_mean,
       vitals.sbp_mean,
       vitals.dbp_mean,
       vitals.mbp_mean,
       vitals.resp_rate_mean,
       vitals.temperature_mean,
       vitals.spo2_mean,
       lab.hematocrit_max,
       lab.hemoglobin_max,
       lab.platelets_max,
       lab.wbc_max,
       lab.aniongap_min,
       lab.bicarbonate_max,
       lab.bun_max,
       lab.calcium_max,
       lab.chloride_max,
       lab.creatinine_max,
       lab.glucose_max,
       lab.sodium_max,
       lab.potassium_max,
       lab.inr_max,
       lab.pt_max,
       lab.ptt_max,
       lab.alt_max,
       lab.alp_max,
       lab.ast_max,
       lab.bilirubin_total_max,
       charlson.myocardial_infarct,
       charlson.congestive_heart_failure,
       charlson.peripheral_vascular_disease,
       charlson.dementia,
       charlson.cerebrovascular_disease,
       charlson.chronic_pulmonary_disease,
       charlson.rheumatic_disease,
       charlson.peptic_ulcer_disease,
       charlson.mild_liver_disease,
       charlson.diabetes_without_cc,
       charlson.paraplegia,
       charlson.malignant_cancer,
       charlson.severe_liver_disease,
       charlson.metastatic_solid_tumor,
       charlson.aids,
       sepsis.sepsis3,
       urine_output.urineoutput,
       CASE
         WHEN (creat.creatinine_aki = 1 OR urine.urine_aki = 1) THEN 1
         ELSE 0
       END AS AKI
FROM pancreatitis_patients pp
JOIN physionet-data.mimiciv_derived.icustay_detail icu
  ON pp.subject_id = icu.subject_id AND pp.hadm_id = icu.hadm_id
JOIN physionet-data.mimiciv_3_1_hosp.admissions adm
  ON icu.subject_id = adm.subject_id AND icu.hadm_id = adm.hadm_id
LEFT JOIN creatinine_data creat
  ON pp.hadm_id = creat.hadm_id
LEFT JOIN urine_output_data urine
  ON icu.stay_id = urine.stay_id
JOIN physionet-data.mimiciv_derived.first_day_vitalsign vitals
  ON icu.subject_id = vitals.subject_id AND icu.stay_id = vitals.stay_id
JOIN physionet-data.mimiciv_derived.first_day_lab lab
  ON icu.subject_id = lab.subject_id AND icu.stay_id = lab.stay_id
JOIN physionet-data.mimiciv_derived.charlson charlson
  ON icu.subject_id = charlson.subject_id AND icu.hadm_id = charlson.hadm_id
JOIN physionet-data.mimiciv_derived.sepsis3 sepsis
  ON icu.subject_id = sepsis.subject_id AND icu.stay_id = sepsis.stay_id
JOIN physionet-data.mimiciv_derived.age age_data
  ON icu.subject_id = age_data.subject_id AND icu.hadm_id = age_data.hadm_id
LEFT JOIN physionet-data.mimiciv_derived.first_day_urine_output urine_output
  ON icu.subject_id = urine_output.subject_id AND icu.stay_id = urine_output.stay_id
WHERE icu.los_hospital > 1;