# שימוש ב- Python 3.9 כתמונת בסיס
FROM python:3.9

# הגדרת משתנה סביבה כדי למנוע יצירת קובצי cache מיותרים
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# יצירת תיקייה לקובץ הקוד והמעבר אליה
WORKDIR /app

# העתקת הקבצים לקונטיינר
COPY plant_plots.py /app/plant_plots.py
COPY requirements.txt /app/requirements.txt

# התקנת הספריות הדרושות
RUN pip install --no-cache-dir -r requirements.txt

# יצירת תיקיית output בתוך הקונטיינר
RUN mkdir -p /app/output

# הרצת הקובץ עם אפשרות לקבלת פרמטרים
ENTRYPOINT ["python3", "plant_plots.py"]
