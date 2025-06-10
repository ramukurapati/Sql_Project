DELIMITER $$

CREATE FUNCTION calculate_adjusted_emi(adjusted_rate FLOAT, principal DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    -- Basic EMI calculation assuming annual rate and 12-month repayment
    RETURN (principal * (adjusted_rate / 100)) / 12;
END$$

DELIMITER ;