SELECT
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
;
SELECT
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
    
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END
ORDER BY
    gender
;
SELECT
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END AS age_band,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END
ORDER BY
    age_band
;
SELECT
    imd_decile,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END
ORDER BY
    ethnic_category
;
SELECT
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END AS no_of_ltcs,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'hip_replacement'
GROUP BY
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END
ORDER BY
    no_of_ltcs
;
SELECT
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
;
SELECT
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END AS gender,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    CASE
        WHEN d.gender IN('Other', 'Unknown')
            THEN 'Other/Unknown'
        ELSE IFNULL(d.gender, 'Other/Unknown')
        END
ORDER BY
    gender
;
SELECT
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END AS age_band,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    CASE
        WHEN d.age BETWEEN 0 AND 10
            THEN '00-10'
        WHEN d.age BETWEEN 11 AND 17
            THEN '11-17'
        WHEN d.age BETWEEN 18 AND 24
            THEN '18-24'
        WHEN d.age BETWEEN 25 AND 34
            THEN '25-34'
        WHEN d.age BETWEEN 35 AND 44
            THEN '35-44'
        WHEN d.age BETWEEN 45 AND 54
            THEN '45-54'
        WHEN d.age BETWEEN 55 AND 64
            THEN '55-64'
        WHEN d.age BETWEEN 65 AND 74
            THEN '65-74'
        WHEN d.age BETWEEN 75 AND 84
            THEN '75-84'
        WHEN d.age >= 85
            THEN '85+'
        ELSE 'Unknown'
        END
ORDER BY
    age_band
;
SELECT
    imd_decile,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    imd_decile
ORDER BY
    imd_decile
;
SELECT
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END AS ethnic_category,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    CASE
        WHEN ethnicity_description = 'Not stated'
            THEN 'Not stated'
        ELSE IFNULL(ethnic_category, 'UNKNOWN')
        END
ORDER BY
    ethnic_category
;
SELECT
    IFNULL(efi_category, 'Unknown') AS efi_category,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    IFNULL(efi_category, 'Unknown')
ORDER BY
    efi_category
;
SELECT
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END AS no_of_ltcs,
    SUM(1) AS pathways,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 >= 6
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 18
            THEN 1
        END) AS wks00_18,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 18
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 30
            THEN 1
        END) AS wks19_30,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 30
            AND DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 <= 42
            THEN 1
        END) AS wks31_42,
    SUM(CASE
        WHEN
            DATEDIFF(DAY, c.rtt_start_date, c.rtt_end_date) / 7.0 > 42
            THEN 1
        END) AS wks43
FROM
    did_sandbox_ndl.ndl.t5_pt_list_causal_final AS c
    LEFT JOIN did_sandbox_ndl.ndl.t5_pt_demographics AS d ON d.patient_key = c.patient_key
        AND d.rtt_start_date = c.rtt_start_date
        AND IFNULL(d.rtt_end_date, GETDATE()) = IFNULL(c.rtt_end_date, GETDATE())
WHERE
    c.procedure = 'cardiothoracic'
GROUP BY
    CASE
        WHEN d.no_of_ltcs = 0
            THEN '0 LTCs'
        WHEN d.no_of_ltcs = 1
            THEN '1 LTCs'
        WHEN d.no_of_ltcs = 2
            THEN '2 LTCs'
        WHEN d.no_of_ltcs >= 3
            THEN '3+ LTCs'
        ELSE 'Unknown'
        END
ORDER BY
    no_of_ltcs
;