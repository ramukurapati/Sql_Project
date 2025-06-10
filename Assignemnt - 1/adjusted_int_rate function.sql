DELIMITER $$

CREATE FUNCTION adjusted_int_rate(fico_score INT, current_rate FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE new_rate FLOAT;

    IF fico_score >= 750 THEN
        SET new_rate = current_rate;
    ELSEIF fico_score BETWEEN 700 AND 749 THEN
        SET new_rate = current_rate + 0.5;
    ELSEIF fico_score BETWEEN 600 AND 699 THEN
        SET new_rate = current_rate + 0.8;
    ELSE
        SET new_rate = current_rate + 1.3;
    END IF;

    RETURN new_rate;
END$$

DELIMITER ;