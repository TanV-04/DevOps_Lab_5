from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Initialize Chrome driver
driver = webdriver.Chrome()

# Open Google
driver.get("https://www.google.com")

# Find the search box
search_box = driver.find_element(By.NAME, "q")

# Type query and press Enter
search_box.send_keys("Selenium Python")
search_box.send_keys(Keys.RETURN)

# Wait for results to load
time.sleep(2)

# Get the first 5 result titles
results = driver.find_elements(By.CSS_SELECTOR, "h3")[:5]
print("\nTop 5 Google Results:")
for i, result in enumerate(results, start=1):
    print(f"{i}. {result.text}")

# Close browser
driver.quit()