# Elections – מסד נתונים לניהול בחירות

מסד נתונים ב-SQL Server (T-SQL) המדגים ניהול תהליך בחירות: מרשם אוכלוסין,
רישום הצבעות, קלפיות, מפלגות, וחישוב חלוקת המנדטים (כולל שיטת בדר-עופר).

## תוכן

- **טבלאות:** `Parties`, `PollingStations`, `populationRegist`, `Voters`,
  `specialVoters`, `Votes`
- **Views:** `SumVotes` (איחוד המצביעים), `checkIfVoted` (סטטוס הצבעה)
- **פונקציות:** `blockingPercentage`, `mandates1`, `mandate`, `mandates2`,
  `mandates3` – צינור חישוב המנדטים
- **פרוצדורות:** `addParty`, `addPollingStation`, `deleteDoubleVotes`,
  `deleteDoubleVotes1`, `mandates`, `mandatesPartition`, `sendingEmails`

## הרצה

1. פתחו את `Elections-db.sql` ב-SQL Server Management Studio (SSMS).
2. הריצו את הסקריפט על שרת נקי. הוא יוצר את המסד `Elections`, את כל האובייקטים,
   וטוען את נתוני הדוגמה.
3. הרצה חוזרת דורשת מחיקת המסד קודם (`DROP DATABASE Elections`).

## הערות

- הפרוצדורה `sendingEmails` דורשת הגדרת Database Mail ופרופיל מתאים.
- מספר המושבים לחישוב המנדטים מוגדר כ-25 (זמני; בכנסת אמיתית 120).

## דרישות

SQL Server 2016 ומעלה (בשל שימוש ב-`DECLARE ... = value` וכו').
