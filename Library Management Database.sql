---------------------------------------Library Management Database------------------------------

use Library

--1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name.{1 Point}
Select Concat(E.Fname,' ' , Lname)
From Employee E
where LEN(E.Fname)>3

----------------

--2. Write a query to display the total number of Programming books
--available in the library with alias name ‘NO OF PROGRAMMING
--BOOKS’ {1 Point}

Select COUNT(B.Id)  as [NO OF PROGRAMMING BOOKS]
from Book B, Category C
where C.Id=B.Cat_id and C.Cat_name= 'Programming'

----------------

--3. Write a query to display the number of books published by
--(HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point}

Select COUNT(B.Id)   'NO_OF_BOOKS'
from Book B, Publisher P
where P.Id=B.Publisher_id and P.Name= 'HarperCollins'

----------------

--4. Write a query to display the User SSN and name, date of borrowing and
--due date of the User whose due date is before July 2022. {1 Point}

Select U.SSN [User SSN], U.User_Name [User Name], Borrow_date [date of borrowing] , Borr.Due_date [due date]
from Users U , Borrowing Borr
where U.SSN=Borr.User_ssn and Borr.Due_date < '2022-07-01'

----------------


--5. Write a query to display book title, author name and display in the
--following format,
--' [Book Title] is written by [Author Name]. {2 Points}

Select CONCAT ('[',B.Title, ']',' is written by [', A.Name,']')
from Book B, Author A, Book_Author BA
where B.Id=BA.Book_id and A.Id= BA.Author_id 

----------------


--6. Write a query to display the name of users who have letter 'A' in their
--names. {1 Point}

Select U.User_Name
from Users U
where U.User_Name like '%A%'
----------------


--7. Write a query that display user SSN who makes the most borrowing{2
--Points}
Select  Top (1) B.User_ssn  --, COUNT(B.User_ssn) 
from Borrowing B
Group by B.User_ssn
order by COUNT(B.User_ssn) desc

----------------


--8. Write a query that displays the total amount of money that each user paid
--for borrowing books. {2 Points}

Select B.User_ssn, Sum(B.Amount)[Amount of money paid ]
from Borrowing B
Group by B.User_ssn



----------------

--9. write a query that displays the category which has the book that has the
--minimum amount of money for borrowing. {2 Points}

--Category which has the book that has the minimum amount of money for borrowing.

Select top (1) Bk.Cat_id [Category ID ],C.Cat_name [Category Name ]--, Borr.Amount
from Borrowing Borr , Book Bk ,  Category C
where  Bk.Id=Borr.Book_id and  C.Id=Bk.Cat_id
order by Borr.Amount

-- Category that has minmum amonut of borrowing
-- ******including zero money******
Select top(1) Bk.Cat_id,C.Cat_name
from Borrowing Borr
full join Book Bk
on  Bk.Id=Borr.Book_id
full join Category C
on C.Id=Bk.Cat_id
Group by Bk.Cat_id,C.Cat_name
order by Sum(Borr.Amount)

----------------

--10.write a query that displays the email of an employee if it's not found,
--display address if it's not found, display date of birthday. {1 Point}
select COALESCE(E.Email, E.Address, Cast (E.DOB as varchar)) [Emp info]
from Employee E

----------------


--11. Write a query to list the category and number of books in each category
--with the alias name 'Count Of Books'. {1 Point}

Select C.Id,C.Cat_name, COUNT(B.Id) [Count Of Books]
From Category C left join Book B --To display Category even if it has no books
on C.Id=B.Cat_id  
group by C.Id , C.Cat_name


----------------------------------

----------------

--12. Write a query that display books id which is not found in floor num = 1
--and shelf-code = A1.{2 Points}

Select B.Id
from Book B, Floor F, Shelf S
where S.Code=  B.Shelf_code  and S.Code!= 'A1' and F.Number = S.Floor_num and F.Number !=1

----------------


--13.Write a query that displays the floor number , Number of Blocks and
--number of employees working on that floor.{2 Points}

Select F.Number, F.Num_blocks, COUNT(E.Id) [Number Of employees]
from Floor F left join Employee E
on F.Number = E.Floor_no
Group by F.Number,F.Num_blocks


----------------


--14.Display Book Title and User Name to designate Borrowing that occurred
--within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points} 


Select B.Title , U.User_Name
from Borrowing BR, Users U, Book B
where B.Id= Br.Book_id and U.SSN= BR.User_ssn and BR.Borrow_date between '3/1/2022' and '10/1/2022'


----------------


--15.Display Employee Full Name and Name Of his/her Supervisor as
--Supervisor Name.{2 Points}

Select CONCAT(Emp.Fname,' ',Emp.Lname) [Employee Full Name], CONCAT(Sup.Fname,' ',Sup.Lname) [Supervisor Name]
from Employee Emp , Employee Sup
where Sup.Id= Emp.Super_id

----------------


--16.Select Employee name and his/her salary but if there is no salary display
--Employee bonus. {2 Points}


Select CONCAT(Emp.Fname,' ',Emp.Lname) [Employee Full Name],Coalesce(Emp.Salary,Emp.Bouns)[Employee Salary]
from Employee Emp

----------------


--17.Display max and min salary for Employees {2 Points}

Select min(Emp.Salary)[min salary],MAX(Emp.Salary) [max salary]
from Employee Emp

----------------


--18.Write a function that take Number and display if it is even or odd {2 Points}

create or alter function F_Even_OR_ODD (@num int)
returns varchar(50)
begin
	if @num%2=0
		return Concat(@num,' is Even Number' )
		

	return Concat(@num,' is odd Number' )
end

print dbo.F_Even_OR_ODD(8)
print dbo.F_Even_OR_ODD(9)
print dbo.F_Even_OR_ODD(1001)
----------------


--19.write a function that take category name and display Title of books in that
--category {2 Points}
create or alter function F_DipBookTitle(@CatName varchar(50))
returns Table
as 
return (
Select B.Title
from Book B ,Category C
where C.Id=B.Cat_id and C.Cat_name=@CatName

)

select * from dbo.F_DipBookTitle('Mathematics')
----------------

--20. write a function that takes the phone of the user and displays Book Title ,
--user-name, amount of money and due-date. {2 Points}
create or alter function F_DispByPhone(@PhoneNo varchar(11))
returns Table
as 
return ( --use Distinct because user can has more than one phone no
Select Distinct BK .Title, U.User_Name,BR.Amount, BR.Due_date -- ,UP.User_ssn
from User_phones UP, Users U, Book BK, Borrowing BR
where  U.SSN =UP.User_ssn and U.SSN=BR.User_ssn and BK.Id= BR.Book_id  and UP.Phone_num=@PhoneNO
)


Select * from dbo.F_DispByPhone('0123654789')
Select * from dbo.F_DispByPhone('0102354545')
----------------


--21.Write a function that take user name and check if it's duplicated
--return Message in the following format ([User Name] is Repeated

--[Count] times) if it's not duplicated display msg with this format [user
--name] is not duplicated,if it's not Found Return [User Name] is Not
--Found {2 Points}

create or alter function F_UNameDuplication(@userName varchar(20))
returns varchar (max)
as
begin 
declare @numOFRepetiton int
select  @numOFRepetiton = count (U.User_Name)
from Users U
where U.User_Name=@userName

if @numOFRepetiton=1

	return Concat ('[ ',@userName,' ] ',' is not duplicated')
	
if @numOFRepetiton=0 
	
	return Concat ('[ ',@userName,' ] ',' is Not Found')
if @numOFRepetiton > 1 
	
	return  Concat ('[ ',@userName,' ] ', 'is Repeated '  ,@numOFRepetiton ,' times')
	
return 'Fail'
end


print dbo.F_UNameDuplication('Amr Ahmed')
print dbo.F_UNameDuplication('Laila Tarek')
print dbo.F_UNameDuplication('Hagar Hossam')
----------------


--22.Create a scalar function that takes date and Format to return Date With
--That Format. {2 Points}

create or alter function DateWithFormat (@date date , @format varchar(50))
returns varchar(50)
begin 
return Format (@date,@format)
end

print dbo.DateWithFormat(GetDAte(),'MMMM')
print dbo.DateWithFormat(GetDAte(),'yyyy')
print dbo.DateWithFormat(GetDAte(),'dddd/MMMM-yyyy')

----------------


--23.Create a stored procedure to show the number of books per Category.{2
--Points}


create or alter procedure SP_BooksPerCat
as 
select C.Id,C.Cat_name,Count(B.Id) [Number of Books]
from Book B right join Category C
on C.Id= B.Cat_id
Group by C.Id,C.Cat_name

exec SP_BooksPerCat


----------------


--24.Create a stored procedure that will be used in case there is an old manager
--who has left the floor and a new one becomes his replacement. The
--procedure should take 3 parameters (old Emp.id, new Emp.id and the
--floor number) and it will be used to update the floor table. {3 Points}

-- If he left the floor as a mangaer but he still employee
create or alter procedure SP_ReplcaeManager @OldMG_ID int,  @NewMG_ID int, @floorNo int
as
Update Floor
set MG_ID= @NewMG_ID
where Number= @floorNo  and MG_ID= @OldMG_ID

exec  SP_ReplcaeManager 3,11,1

----------------------------------------


--25.Create a view AlexAndCairoEmp that displays Employee data for users
--who live in Alex or Cairo. {2 Points}


create or alter view V_EmpCairoAlex
as
Select *
from Employee
where Address in ('Cairo','Alex')
--
Select * from V_EmpCairoAlex

----------------

--26.create a view "V2" That displays number of books per shelf {2 Points}
create or alter view V2
as
select B.Shelf_code, count(B.Id) [number of books per shelf]
from Book B
group by B.Shelf_code
--
Select * from V2

----------------

--27.create a view "V3" That display the shelf code that have maximum
--number of books using the previous view "V2" {2 Points}
create or alter View V3
as 
Select top(1)* from V2 
order by 2 desc -- Order by second Column
--
Select * from V3

----------------

--28.Create a table named ‘ReturnedBooks’ With the Following Structure :
--User SSN Book Id Due Date Return
--Date
--fees

-- 28. P1


create Table ReturnedBooks
(User_SSN varchar(50) references Users (SSN) ,
Book_ID int references Book (id) ,
DueDate date,
Returned_Date date,
fees int default 0
--primary key (Book_ID,DueDate)
)
---

--then create A trigger that instead of inserting the data of returned book
--checks if the return date is the due date or not if not so the user must pay
--a fee and it will be 20% of the amount that was paid before. {3 Points}

-- 28. P2

Create or Alter Trigger TR_ReturnedBook on ReturnedBooks
instead of insert 
as
Declare @DueDate date
Declare @ReturnDate date

Select @DueDate = DueDate, @ReturnDate= Returned_Date
from inserted


if @ReturnDate> @DueDate
	insert into ReturnedBooks
	Select I.User_SSN,I.Book_ID,I.DueDate,I.Returned_Date,B.Amount*0.2
	from inserted I , Borrowing B
	where  I.User_SSN= B.User_ssn and I.Book_ID= B.Book_id and I.DueDate= B.Due_date

else
	insert into ReturnedBooks
	Select I.User_SSN,I.Book_ID,I.DueDate,I.Returned_Date,0
	from inserted I , Borrowing B
	where  I.User_SSN= B.User_ssn and I.Book_ID= B.Book_id and I.DueDate= B.Due_date
----
insert into ReturnedBooks
values(1,3,'2021-02-27','2021-01-27',0) -- No fees, Row not inserted

insert into ReturnedBooks
values(2,3,'2022-03-24','2022-03-27',0) -- there's Fees , Row will be insert

----------------

--29.In the Floor table insert new Floor With Number of blocks 2 , employee
--with SSN = 20 as a manager for this Floor,The start date for this manager is Now.
insert into Floor
values(7,2,20,GETDATE())

-- Do what is required if you know that : Mr.Omar Amr(SSN=5)
--moved to be the manager of the new Floor (id = 6),
--and they give Mr. Ali
--Mohamed(his SSN =12) His position . {3 Points}

-- Mohammed take omar position first
Update Floor
Set MG_ID=12
where MG_ID=5

Update Floor
Set MG_ID=5
where Number=7 and MG_ID=20 --NEW floor Number is 7

----------------

--30.Create view name (v_2006_check) that will display Manager id, Floor
--Number where he/she works , Number of Blocks and the Hiring Date
--which must be from the first of March and the May of December
--2022.this view will be used to insert data so make sure that the coming
--new data must match the condition then try to insert this 2 rows and
--Mention What will happen {3 Point}

Create or alter View v_2006_check
as

Select F.MG_ID [Manager ID],F.Number[Floor he manages] ,F.Num_blocks[Number of Blocks], F.Hiring_Date
from Floor F 
where Hiring_Date between '2022-03-01' and '2022-12-30'
with check option

insert into v_2006_check
values (2, 6, 2,' 7-8-2023') -- Duplicate PK

insert into v_2006_check
values (2, 8, 2,' 7-8-2023') -- Failed , The hiring date not in the range

insert into v_2006_check
values (7, 7, 1,' 4-8-2022')-- Duplicate PK

insert into v_2006_check
values (7, 9, 10,' 4-8-2022')-- Sucess , The hiring date  in the range


----------------

--31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
--the Employee table ( Display a message for user to tell him that he can’t
--take any action with this Table) {3 Point}
Create Or Alter Trigger TR_PreventEmpModification
ON Employee
instead of insert, Update, Delete
as 
    print ' You can’t take any action with this Table'

-- Test
Delete from Employee
where Id=10

update Employee
set Fname='Hagar'
where Id=10

insert into Employee
Values('Hagar','Hossam,','01147722852','HagarHossam@gmail.com',	'Cairo','2000-08-03',10000,2000,3,1)

----------------

---********
--32.Testing Referential Integrity , Mention What Will Happen When:


--A. Add a new User Phone Number with User_SSN = 50 in
--User_Phones Table {1 Point}

insert into User_phones
values ('50','01177442480') 

-- Will not inserted because there no user with ssn = 50 ,
--as User phone table has a foriegn key  (User_SSN Col) references to  PK in User Table (SSN Col)
--  A new user must be inserted into the users table with ssn=50 first
---------

--B. Modify the employee id 20 in the employee table to 21 {1 Point}

update Employee
set Id=21
where Id=20
-- We can't do it because of  Trigger TR_PreventEmpModification that prevent any Modification on employee table
-- We can drop it and try
drop  Trigger TR_PreventEmpModification

update Employee
set Id=21
where Id=20
-- but also we couldn't do it as the id column is an **identity column**  and we cannot update identity column
-- even if it's not identity  , we can't update it if it has dependencies in other tables (FK depends on PK )
--  Therefore, it must be deleted or replaced in these tables first, if it exists
-- Employee Table Super_id Col
--Floor Table MG_ID Col
-- Users Table Emp_id Col
-- Borrowing Table Emp_id Col

-- It exists in the  Floor Table (MG_ID Col), Users Table (Emp_id Col) and Borrowing (Emp_id Col)
-------------------------------

--C. Delete the employee with id 1 {1 Point}

Delete from Employee
where id=1

 --We can't do it because of  Trigger TR_PreventEmpModification that prevent any Modification on employee table
-- We can drop it and try
drop  Trigger TR_PreventEmpModification
Delete from Employee
where id=1

--we can't delete it if it has dependencies in other tables (FK depend on PK )
--  Therefore, it must be deleted or replaced in these tables first, if it exists
-- Employee Table Super_id Col
--Floor Table MG_ID Col
-- Users Table Emp_id Col
-- Borrowing Table Emp_id Col

-- It exists in the  Employee Table (Super_id Col) , Floor Table (MG_ID Col), Users Table (Emp_id Col) and Borrowing (Emp_id Col)


---------------------

--D. Delete the employee with id 12 {1 Point}   --****-- Same as the Above one****--
 --We can't do it because of  Trigger TR_PreventEmpModification that prevent any Modification on employee table
-- We can drop it and try
drop  Trigger TR_PreventEmpModification
Delete from Employee
where id=12

--we can't delete it if it has dependencies in other tables (FK depend on PK )
--  Therefore, it must be deleted or replaced in these tables first, if it exists
-- Employee Table Super_id Col
--Floor Table MG_ID Col
-- Users Table Emp_id Col 
-- Borrowing Table Emp_id Col

-- It exists in the (Emp_id Col) *users table* only

-------------
--E. Create an index on column (Salary) that allows you to cluster the
--data in table Employee. {1 Point}
Create  NonClustered  index IX_EmpSalaryNonClus
on Employee(Salary)

-- Will Create Non unique and non clustered index
--Non unique -> Salary Column Not unique
-- Non Clusterd ->  each Table has only one Clusterd Column which already exist in employee Table(PK-  ID Col)

---********
----------------

--33.Try to Create Login With Your Name And give yourself access Only to
--Employee and Floor tables then allow this login to select and insert data
--into tables and deny Delete and update (Don't Forget To take screenshot
--to every step) {5 Points}

Create Schema HagarSchema

Alter Schema HagarSchema 
Transfer Employee

Alter Schema HagarSchema 
Transfer Floor


----------**  using Code **----------
CREATE LOGIN HagarLoginC WITH PASSWORD = 'H123456'

Create USER HagarUserC FOR LOGIN RouteStudent

GRANT SELECT, INSERT ON HagarSchema.Floor TO HagarUserC
GRANT SELECT, INSERT ON HagarSchema.Employee TO HagarUserC
DENY DELETE, UPDATE ON HagarSchema.Floor  TO HagarUserC
DENY DELETE, UPDATE ON HagarSchema.Employee TO HagarUserC