-- Verificar la tabla
SELECT * FROM student_depression;

-- Revisión de la estructura de la tabla
PRAGMA Table_info (student_depression); 

-- Identificación de valores faltantes
SELECT * 
FROM student_depression
WHERE
    City IS NULL 
    AND Profession IS NULL
	AND "Academic Pressure" IS NULL
    AND "WorK Pressure" IS NULL
    AND "Study Satisfaction" IS NULL
    AND "Job Satisfaction" IS NULL
    AND "Sleep Duration" IS NULL
    AND Depression IS NULL;

-- Renombrar la columna que contiene caracteres especiales (/) (?) para facilitar su uso y consulta, evitando errores:

ALTER TABLE student_depression RENAME COLUMN "Work/Study Hours" TO Work_Study_Hours;

ALTER TABLE student_depression RENAME COLUMN "Have you ever had suicidal thoughts ?" TO Have_you_ever_had_suicidal_thoughts;

ALTER TABLE student_depression RENAME COLUMN "Sleep Duration" TO Sleep_Hours;

-- buscar si existe correlación entre edad, horas de sueño, habitos dietarios y pensamientos suicidas
-- Convertir las horas de sueño en valores númericos representativos ejemplo: "menos de 5 horas" redondearlo a 4 y así sucesivamente.

UPDATE student_depression
SET Sleep_Hours = 
    CASE 
        WHEN Sleep_Hours = 'Less than 5 hours' THEN 4
        WHEN Sleep_Hours = '5-6 hours' THEN 5.5
        WHEN Sleep_Hours = '7-8 hours' THEN 7.5
        WHEN Sleep_Hours = 'More than 8 hours' THEN 9
    END;

--Crear una nueva columna para los valores numéricos de horas de sueño:
ALTER TABLE student_depression
ADD COLUMN Sleep_Hours_Numeric DECIMAL(3,1);

UPDATE student_depression
SET Sleep_Hours_Numeric = 
    CASE 
        WHEN Sleep_Hours_Numeric = 'Less than 5 hours' THEN 4
        WHEN Sleep_Hours_Numeric = '5-6 hours' THEN 5.5
        WHEN Sleep_Hours_Numeric = '7-8 hours' THEN 7.5
        WHEN Sleep_Hours_Numeric = 'More than 8 hours' THEN 9
    END;

-- Calcular el promedio de horas de sueño, habitos dietarios, pensamientos suicidas y proporcion de depresion segun edad y genero 
SELECT 
    Gender,
    Age,
    AVG(CAST(Sleep_Hours AS REAL)) AS Sleep_Hours_AVG,
    AVG(CASE 
        WHEN "Dietary Habits" = 'Healthy' THEN 1
        WHEN "Dietary Habits" = 'Moderate' THEN 0.5
        WHEN "Dietary Habits" = 'Unhealthy' THEN 0
    END) AS Dietary_Habits_AVG,
    AVG(CASE 
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'Yes' THEN 1
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'No' THEN 0
    END) AS suicidal_thougths_proportion,
    AVG(CASE 
        WHEN "Depression" = 1 THEN 1
        WHEN "Depression" = 0 THEN 0
    END) AS depression_proportion
FROM student_depression
GROUP BY Gender, Age
ORDER BY age ASC;

-- Crear tabla con los resultados 
CREATE TABLE student_depression_summary AS
SELECT 
    Gender,
    Age,
    AVG(CAST(Sleep_Hours AS REAL)) AS Sleep_Hours_AVG,
    AVG(CASE 
        WHEN "Dietary Habits" = 'Healthy' THEN 1
        WHEN "Dietary Habits" = 'Moderate' THEN 0.5
        WHEN "Dietary Habits" = 'Unhealthy' THEN 0
    END) AS Dietary_Habits_AVG,
    AVG(CASE 
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'Yes' THEN 1
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'No' THEN 0
    END) AS suicidal_thougths_proportion,
    AVG(CASE 
        WHEN "Depression" = 1 THEN 1
        WHEN "Depression" = 0 THEN 0
    END) AS depression_proportion
FROM student_depression
GROUP BY Gender, Age
ORDER BY depression_proportion ASC;

-- Verificar que la tabla se haya creado correctamente
select * from student_depression_summary
ORDER BY age 

-- Buscar correlacion entre depresión y variables como ()
SELECT 
    "Academic Pressure",
    "Work Pressure",
    "Study Satisfaction",
    "Job Satisfaction",
    AVG("Depression") AS depression_avg
FROM student_depression
GROUP BY "Academic Pressure", "Work Pressure", "Study Satisfaction", "Job Satisfaction";

-- Calcular la relación entre la edad, el género y la proporción de depresión.
SELECT 
    Gender,
    Age,
    AVG(Depression) AS Depression_Proportion
FROM 
    student_depression
GROUP BY 
    Gender, Age
ORDER BY 
    Gender, Age;

-- Crear una nueva tabla con los resultados de la consulta Con el promedio de horas de sueño, habitos dietarios, pensamientos suicidas y proporcion de depresion segun edad y genero 
CREATE TABLE Sleep_Diet_Depression_Stats AS
SELECT 
    Gender,
    Age,
    AVG(CAST(Sleep_Hours AS REAL)) AS Sleep_Hours_AVG,
    AVG(CASE 
        WHEN "Dietary Habits" = 'Healthy' THEN 1
        WHEN "Dietary Habits" = 'Moderate' THEN 0.5
        WHEN "Dietary Habits" = 'Unhealthy' THEN 0
    END) AS Dietary_Habits_AVG,
    AVG(CASE 
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'Yes' THEN 1
        WHEN "Have_you_ever_had_suicidal_thoughts" = 'No' THEN 0
    END) AS suicidal_thougths_proportion,
    AVG(CASE 
        WHEN "Depression" = 1 THEN 1
        WHEN "Depression" = 0 THEN 0
    END) AS depression_proportion
FROM student_depression
GROUP BY Gender, Age
ORDER BY Age ASC;

-- verificar tabla final
select * from Sleep_Diet_Depression_Stats