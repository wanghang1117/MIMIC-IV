# Predictive Model of Acute Kidney Injury in Critically Ill Patients with Acute Pancreatitis

This repository contains the implementation of machine learning models to predict Acute Kidney Injury (AKI) in critically ill patients with Acute Pancreatitis (AP) using the MIMIC-IV database.

## Project Overview

Acute Pancreatitis (AP) is a severe gastrointestinal condition with high morbidity and mortality. Acute Kidney Injury (AKI) affects 10-42% of AP patients and significantly worsens prognosis. This project implements machine learning models to predict AKI risk in AP patients, enabling timely intervention and improved patient outcomes.

## Dataset

This study utilizes the MIMIC-IV database (v3.1), a comprehensive clinical database containing data from intensive care unit (ICU) patients. The dataset includes:

- Patient demographics
- Vital signs
- Laboratory test results
- Medication usage
- Fluid balance
- Survival outcomes
- ICD-9 and ICD-10 codes

### Inclusion Criteria:
- Patients diagnosed with acute pancreatitis (ICD-9: 577.0, ICD-10: K85*)
- Age ≥ 18 years
- ICU stays ≥ 24 hours

### Exclusion Criteria:
- History of renal disease
- For patients with multiple ICU admissions, only data from first admission was used

### Data Extraction
- Structured Query Language (SQL) within PostgreSQL
- 1,083 patients met inclusion criteria
- Split: 70% training (758 patients), 30% validation (325 patients)

## Methods

### Feature Selection
- Initial selection of 50 features
- Refined to 24 features using:
  - Recursive Feature Elimination (RFE)
  - LASSO (Least Absolute Shrinkage and Selection Operator)

### Data Preprocessing
- Removal of implausible/biologically impossible values
- Missing numerical values imputed with median values
- Missing categorical data replaced with mode
- Derived features calculated (max, min, mean) for key clinical variables
- Normalization of continuous variables to standard scale (0-1)

### Models Implemented
- Gradient Boosting Machine (GBM)
- XGBoost
- K-Nearest Neighbors (KNN)
- Logistic Regression (baseline model)
- Naive Bayes
- Neural Network
- Random Forest
- Support Vector Machine (SVM)

## Results

### Model Performance

| Model | Sensitivity | Specificity | AUC | 95% CI |
|-------|------------|------------|-----|--------|
| XGBoost | 0.90 | 0.65 | 0.891 | [0.852, 0.925] |
| Neural Network | 0.85 | 0.71 | 0.865 | [0.816, 0.907] |
| Random Forest | 0.90 | 0.59 | 0.864 | [0.819, 0.903] |
| Gradient Boost | 0.90 | 0.62 | 0.867 | [0.821, 0.909] |
| SVM | 0.76 | 0.83 | 0.880 | [0.833, 0.921] |
| Logistic Regression | 0.90 | 0.63 | 0.877 | [0.832, 0.913] |
| Naive Bayes | 0.52 | 0.90 | 0.834 | [0.781, 0.879] |
| KNN | 0.86 | 0.55 | 0.804 | [0.750, 0.856] |

### Key Findings
- XGBoost demonstrated superior performance with highest AUC (0.891)
- XGBoost achieved 90% accuracy with balanced sensitivity (90%) and improved specificity (65%)
- XGBoost outperformed traditional Logistic Regression (AUC: 0.877)

## Repository Structure

```
├── data/
│   ├── processed/         # Preprocessed data files
│   └── raw/               # Original extracted MIMIC-IV data
├── notebooks/
│   ├── 01_data_extraction.ipynb     # SQL queries for data extraction
│   ├── 02_preprocessing.ipynb       # Data cleaning and preprocessing
│   ├── 03_feature_selection.ipynb   # RFE and LASSO feature selection
│   ├── 04_model_training.ipynb      # Training ML models
│   └── 05_model_evaluation.ipynb    # Performance evaluation
├── src/
│   ├── data/              # Data processing scripts
│   ├── features/          # Feature engineering scripts
│   ├── models/            # Model implementation scripts
│   └── visualization/     # Visualization scripts
├── results/
│   ├── figures/           # Generated figures and plots
│   └── model_metrics/     # Performance metrics
├── requirements.txt       # Required packages
├── setup.py               # Setup script
└── README.md              # This file
```

## Installation and Usage

1. Clone this repository:
```bash
git clone https://github.com/username/aki-prediction-pancreatitis.git
cd aki-prediction-pancreatitis
```

2. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install the required packages:
```bash
pip install -r requirements.txt
```

4. Access to MIMIC-IV database is required (requires credentialing):
   - Instructions for accessing MIMIC-IV: https://mimic.mit.edu/
   - Requires completion of CITI "Data or Specimens Only Research" course

5. Run the notebooks in order or use the implemented models in the `src/` directory

## Feature Importance

The most influential features for AKI prediction in AP patients (based on SHAP values):

1. ICU hospital stay (los_hospital)
2. Maximum creatinine level (creatinine_max)
3. Maximum BUN level (bun_max)
4. Mean SpO2 (spo2_mean)
5. Maximum PT (pt_max)
6. Maximum glucose (glucose_max)
7. Admission type

## Limitations

1. Model interpretability: XGBoost is often considered a "black-box" model
2. Computational complexity: XGBoost can be computationally expensive
3. Sensitivity to hyperparameters: Requires extensive tuning

## Future Work

1. External validation on different clinical datasets
2. Integration of temporal data for dynamic predictions
3. Implementation of Explainable AI techniques to enhance interpretability
4. Extension of this predictive framework to other critical care conditions
5. Development of a clinical decision support tool

## Citation

If you use this code or the findings in your research, please cite:

```
Wang, H., Zhang, Y., Rui, Y., & Cheng, S. (2025). Predictive Model of Acute Kidney Injury 
in Critically Ill Patients with Acute Pancreatitis: A Machine Learning Approach Using the MIMIC-IV Database.
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Beth Israel Deaconess Medical Center and MIT for the MIMIC-IV database
- All researchers and healthcare professionals who contributed to the MIMIC-IV dataset
