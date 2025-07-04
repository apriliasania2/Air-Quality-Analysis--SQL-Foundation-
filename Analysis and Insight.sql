# Case Study 1: Ingin diketahui 10 country dengan nilai Air Quality Index (AQI) tertinggi untuk CO
(Karbon Monoksida) dimana juga menampilkan total pengamatan dan rata-rata
konsentrasi CO.

SELECT
  county_name, observation_count, arithmetic_mean, aqi
FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary`
ORDER BY aqi DESC
LIMIT 10;

''' Insight: Query ini menampilkan 10 county dengan nilai AQI tertinggi untuk karbon monoksida, 
  menunjukkan wilayah dengan potensi polusi udara paling serius, disertai jumlah observasi dan rata-
  rata aritmatik untuk menggambarkan representativitas data dan tingkat keparahan polusi.'''
  

# Case Study 2: Ingin diketahui 10 negara bagian dengan jumlah pengamatan kualitas udara terbanyak di
tahun 2023.

SELECT state_name, observation_count
FROM `bigquery-public-data.epa_historical_air_quality.air_quality_annual_summary`
WHERE year = 2023
ORDER BY observation_count DESC
LIMIT 10;


# Case Study 3: Ingin diketahui kategori kualitas udara dibeberapa county yang didefinisikan berdasarkan
nilai AQI.

SELECT 
  county_name, 
  aqi,
  CASE
    WHEN aqi <= 50 THEN 'Baik'
    WHEN aqi > 50 AND aqi <= 100 THEN 'Sedang'
    WHEN aqi > 100 AND aqi <= 150 THEN 'Tidak sehat untuk masyarakat rentan'
    WHEN aqi > 150 AND aqi <= 200 THEN 'Tidak sehat'
    WHEN aqi > 200 AND aqi <= 300 THEN 'Sangat tidak sehat'
    ELSE 'Berbahaya'
  END AS AirQuality_Category
FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary`
LIMIT 10;


# Case Study 4: Ingin diketahui negara bagian dengan rata-rata AQI dibawah 100, berdasarkan data
karbon monoksida (CO) dari dataset EPA Historical Air Quality.

WITH avg_aqi_state AS (
  SELECT 
    state_name, 
    ROUND(AVG(aqi), 2) AS avg_aqi
  FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary`
  GROUP BY 
    state_name
)
SELECT 
  state_name, 
  avg_aqi
FROM 
  avg_aqi_state
WHERE 
  avg_aqi <= 100
ORDER BY
  avg_aqi DESC
LIMIT 10;


# Case Study 5: Ingin diketahui 10 negara bagian dengan nilai AQI tertinggi setelah tahun 2022.

SELECT 
  cs.state_code, 
  aqs.state_name,
  aqs.year, 
  MAX(cs.aqi) AS aqi
FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary` AS cs
JOIN `bigquery-public-data.epa_historical_air_quality.air_quality_annual_summary` AS aqs
  USING (state_code)
WHERE year > 2022
GROUP BY cs.state_code, aqs.state_name, aqs.year
ORDER BY aqi DESC
LIMIT 10;


# Case Study 6: Ingin diketahui 10 negara bagian dengan nilai AQI tertinggi pada tahun 2023, sekaligus
memberikan kategori kualitas udara berdasarkan nilai AQI tersebut.

WITH avg_aqi_state AS (
  SELECT 
    state_name, 
    ROUND(AVG(aqi), 2) AS avg_aqi
  FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary`
  GROUP BY state_name
)
SELECT 
  cs.state_code, 
  aqs.state_name, 
  MAX(cs.aqi) AS aqi,
  CASE
    WHEN MAX(cs.aqi) <= 50 THEN 'Baik'
    WHEN MAX(cs.aqi) > 50 AND MAX(cs.aqi) <= 100 THEN 'Sedang'
    WHEN MAX(cs.aqi) > 100 AND MAX(cs.aqi) <= 150 THEN 'Tidak sehat untuk masyarakat rentan'
    WHEN MAX(cs.aqi) > 150 AND MAX(cs.aqi) <= 200 THEN 'Tidak sehat'
    WHEN MAX(cs.aqi) > 200 AND MAX(cs.aqi) <= 300 THEN 'Sangat tidak sehat'
    ELSE 'Berbahaya'
  END AS AirQuality_Category
FROM `bigquery-public-data.epa_historical_air_quality.co_daily_summary` AS cs
JOIN `bigquery-public-data.epa_historical_air_quality.air_quality_annual_summary` AS aqs
  USING (state_code)
WHERE
  year = 2023
GROUP BY 
  cs.state_code, aqs.state_name
LIMIT 10;
