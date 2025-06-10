SELECT
    fico,`int.rate` AS original_rate,
    adjusted_int_rate(fico, `int.rate`) AS new_rate,
    installment AS original_installment,
    (installment * 12) / (`int.rate` / 100) AS estimated_loan_amount,
    calculate_adjusted_emi(
        adjusted_int_rate(fico, `int.rate`),
        (installment * 12) / (`int.rate` / 100)
    ) AS adjusted_emi
FROM
    loan_data
WHERE `int.rate` IS NOT NULL
    AND installment IS NOT NULL
    AND fico IS NOT NULL
