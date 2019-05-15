USE QLDIEM
GO
--1. Danh sach sinh vien da co diem thi mon CF.

select a.ClassCode,a.RollNo, a.FullName from Student a inner Join Mark b 
 on a.RollNo = b.RollNo where b.SubjectCode='CF' and b.Mark>0

--2. Danh sach cac mon hoc cung voi so sinh vien da co diem thi tuong ung cua 
--tung mon hoc, theo thu tu tang dan cua ten mon hoc. 

select a.SubjectCode,count(*) as stud_nr from subject a inner join mark b 
 on a.SubjectCode=b.SubjectCode where b.mark>0 group by a.SubjectCode order by a.SubjectCode

--3. Danh sach sinh vien que o  "HT" (Ha Tay), cung voi ten cac mon hoc 
--da thi nhung khong qua (< 10 diem).

select a.RollNo,a.FullName, b.SubjectCode, round(b.Mark,0) as Mark from student a inner join mark b 
 on a.RollNo=b.RollNo where a.Province='HT' and b.mark<10 order by a.FullName

--4. Danh s�ch c�c lop c�ng voi tong so sinh vi�n trong lop.	

select a.ClassCode, count(b.ClassCode) as Stud_nr from Class a inner join Student b
 on a.ClassCode=b.ClassCode group by a.ClassCode 

--5.Danh s�ch c�c sinh vi�n, c�ng voi t�n day du c�c m�n hoc m� sinh vi�n d� d� tham gia thi.

select a.rollNo, a.FullName,b.SubjectCode from Student a inner join Mark b
 on a.RollNo=b.RollNo where b.mark>0 order by a.FullName,b.SubjectCode
 
--6. Danh s�ch c�c sinh vi�n, c�ng voi so lan d� tham gia thi thuc h�nh
--(moi record trong bang MARK c� diem PMark l� mot lan thi).

select a.rollNo, a.FullName,count(b.RollNo) as SoLanThiTH from Student a inner join Mark b
 on a.RollNo=b.RollNo where b.pmark>0 group by a.rollNo, a.FullName 
 order by a.FullName

--7. Danh s�ch c�c tinh, c�ng voi diem trung b�nh tat ca c�c m�n thi cua sinh vi�n 
--qu� o tinh d�. Sap xep theo thu tu giam dan cua diem trung b�nh.

select a.Province,round(avg(b.mark),0) as avgMark from Student a inner join Mark b
 on a.RollNo=b.RollNo group by a.province order by avg(b.mark) desc

--8. Danh s�ch c�c sinh vi�n c� diem trung b�nh tat ca c�c m�n hoc >15

select a.RollNo, a.FullName, avg(b.mark) from student a inner join mark b
 on a.RollNo = b.RollNo group by a.RollNo, a.FullName having avg(b.mark)>15


--C�u 3: Viet Stored Procedure

/*Viet mot script tao stored procedure voi c�c y�u cau sau:
- T�n Procedure: 	procStudentList  
- Tham so: 		pClassCode as varchar(10), pMark  as float
- Xu l�: 
+ Neu tham so pClassCode duoc truyen = '' hoac kh�ng truyen, procedure se liet k� danh s�ch
  ClassCode, RollNo, FullName, SubjectCode, Mark  voi Mark >= pMark.
+ Neu tham so pMark kh�ng truyen th� nhan gi� tri ngam dinh =0.*/

IF EXISTS(SELECT name FROM sysobjects
      WHERE name = 'procStudentList' AND type = 'P')
   DROP PROC procStudentList
GO
CREATE PROCEDURE procStudentList @pClassCode varchar(10)= NULL, @pMark float = NULL
AS 
BEGIN
 if @pMark is NULL
  set @pMark=0
 IF @pClassCode IS NULL
   select a.ClassCode, a.rollNo, a.FullName,b.SubjectCode,b.Mark from Student a 
    inner join Mark b 
    on a.RollNo=b.RollNo where b.mark>@pMark order by a.RollNo
  ELSE
   select a.ClassCode,a.rollNo, a.FullName,b.SubjectCode,b.Mark from Student a 
    inner join Mark b
    on a.RollNo=b.RollNo where b.mark>@pMark and a.ClassCode = @pClassCode 
    order by a.RollNo
END
GO
exec procStudentList 'C0611L',10
exec procStudentList 'C0611L'
exec procStudentList

 