create schema if not exists sql_company;
use sql_company;

select * from information_schema.table_constraints
	where constraint_schema = 'sql_company';

-- restrição atribuida a um domínio
-- create domain D_num as int check(D_num> 0 and D_num< 21);

CREATE TABLE employee(
	Fname varchar(15) not null,
    Minit char,
    Lname varchar(15) not null,
    Ssn char(9) not null, 
    Bdate date,
    Address varchar(30),
    Sex char,
    Salary decimal(10,2),
    Super_ssn char(9),
    Dno int not null default 1,
    INDEX idx_ssn (Ssn),
    constraint chk_salary_employee check (Salary> 2000.0),
    constraint fk_employee foreign key(Super_ssn) references employee(Ssn) on delete set null on update cascade
);

create table departament(
	Dname varchar(15) not null,
    Dnumber int not null,
    Mgr_ssn char(9) not null,
    Mgr_start_date date, 
    Dept_create_date date,
    constraint chk_date_dept check (Dept_create_date < Mgr_start_date),
    constraint pk_dept primary key (Dnumber),
    constraint unique_name_dept unique(Dname),
    foreign key (Mgr_ssn) references employee(Ssn),
    constraint fk_dept foreign key(Mgr_ssn) references employee(Ssn)
        on update cascade
);

create table dept_locations(
	Dnumber int not null,
	Dlocation varchar(15) not null,
    constraint pk_dept_locations primary key (Dnumber, Dlocation),
constraint fk_dept_locations foreign key (Dnumber) references departament(Dnumber)
	on delete cascade
    on update cascade
);


create table project(
	Pname varchar(15) not null,
	Pnumber int not null,
    Plocation varchar(15),
    Dnum int not null,
    primary key (Pnumber),
    constraint unique_project unique (Pname),
    constraint fk_project foreign key (Dnum) references departament(Dnumber)
);

create table works_on(
	Essn char(9) not null,
    Pno int not null,
    Hours decimal(3,1) not null,
    primary key (Essn, Pno),
    constraint fk_employee_works_on foreign key (Essn) references employee(Ssn),
    constraint fk_project_works_on foreign key (Pno) references project(Pnumber)
);

create table dependent(
	Essn char(9) not null,
    Dependent_name varchar(15) not null,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    primary key (Essn, Dependent_name),
    constraint fk_dependent foreign key (Essn) references employee(Ssn)
);

show tables;


insert into employee values 
                            ('James', 'E', 'Borg', 888665555, '1937-11-10', '450-Stone-Houston-TX', 'M', 55000, NULL, 1),
							('Franklin', 'T', 'Wong', 333445555, '1955-12-08', '638-Voss-Houston-TX', 'M', 40000, 888665555, 5),
							('John', 'B', 'Smith', 123456789, '1965-01-09', '731-Fondren-Houston-TX', 'M', 30000, 333445555, 5),
                            ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX', 'F', 43000, 888665555, 4),
							('Ahmad', 'V', 'Jabbar', 987987987, '1969-03-29', '980-Dallas-Houston-TX', 'M', 25000, 987654321, 4),
                            ('Alicia', 'J', 'Zelaya', 999887777, '1968-01-19', '3321-Castle-Spring-TX', 'F', 25000, 987654321, 4),
                            ('Ramesh', 'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX', 'M', 38000, 333445555, 5),
                            ('Joyce', 'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX', 'F', 25000, 333445555, 5);

insert into dependent values (333445555, 'Alice', 'F', '1986-04-05', 'Daughter'),
							 (333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
                             (333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
                             (987654321, 'Abner', 'M', '1942-02-28', 'Spouse'),
                             (123456789, 'Michael', 'M', '1988-01-04', 'Son'),
                             (123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');

insert into departament values ('Research', 5, 333445555, '1988-05-22','1986-05-22'),
							   ('Administration', 4, 987654321, '1995-01-01','1994-01-01'),
                               ('Headquarters', 1, 888665555,'1981-06-19','1980-06-19');

insert into dept_locations values (1, 'Houston'),
								 (4, 'Stafford'),
                                 (5, 'Bellaire'),
                                 (5, 'Sugarland'),
                                 (5, 'Houston');

insert into project values ('ProductX', 1, 'Bellaire', 5),
						   ('ProductY', 2, 'Sugarland', 5),
						   ('ProductZ', 3, 'Houston', 5),
                           ('Computerization', 10, 'Stafford', 4),
                           ('Reorganization', 20, 'Houston', 1),
                           ('Newbenefits', 30, 'Stafford', 4);

insert into works_on values (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 30, 20.0),
                            (987654321, 20, 15.0),
                            (888665555, 20, 50.0);


# Consultas SQL

select * from dependent;
select Ssn, count(Essn) AS Quantidade_dependentes from employee e, dependent d where (e.Ssn = d.Essn) GROUP BY 1;

SELECT Bdate, Address FROM employee
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';

select * from departament where Dname = 'Research';

SELECT Fname, Lname, Address
FROM employee, departament
WHERE Dname = 'Research' AND Dnumber = Dno;

select * from project;

# Testando mais de uma tabela e alias

select Dname as Department, Mgr_ssn as Manager from departament d, dept_locations l
where d.Dnumber = l.Dnumber;

select Dname as Department, concat(Fname, ' ', Lname) from departament d, dept_locations l, employee e
where d.Dnumber = l.Dnumber and Mgr_ssn = e.Ssn;

SELECT Pnumber, Dnum, Lname, Address, Bdate
FROM project, departament, employee
WHERE Dnum = Dnumber AND Mgr_ssn = Ssn AND
Plocation = 'Houston';

#select Address, Parsename(Address,1,charindex('-',Address) as num from employee;

# aumentando valor de uma variável existente na tabela temporária
select e.Fname, e.Lname, 1.1*e.Salary as increased_sal from employee as e,
works_on as w, project as p where e.Ssn = w.Essn and w.Pno = p.Pnumber and p.Pname='ProductX';

select Dname as Department, concat(Fname, ' ', Lname) as Manager from departament d, dept_locations l, employee e
where d.Dnumber = l.Dnumber and Mgr_ssn = e.Ssn;

select concat(Fname, ' ', Minit,' ', Lname) as Nome_Completo, (timestampdiff(year, Bdate, current_date())) as Idade from employee;
select count(*) as Num_projetos, Ssn, Fname from works_on, employee where Essn=Ssn group by Essn;

select e.Fname, count(Pno) as Num_projetos, (timestampdiff(year, Bdate, current_date()))  from works_on w inner join employee e on w.Essn=e.Ssn group by 1,3;

    
#### QUERIES ESCOLHIDAS PARA O POWER BI 

-- Divisão do endereço com os produtos oferecidos e horas

select * from project;
select * from employee;
select * from works_on;
SELECT
	p.Pnumber, p.Pname, w.Hours,
	concat(Fname, ' ', Minit,' ', Lname) as Nome_Completo,
    Ssn,
   SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 1), '-', -1) AS Número,
   If(  length(Address) - length(replace(Address, '-', ''))>1,  
       SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 2), '-', -1) ,NULL) 
           as Rua,
   SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 3), '-', -1) AS Cidade,
   SUBSTRING_INDEX(SUBSTRING_INDEX(Address, '-', 4), '-', -1) AS Estado
FROM employee e, project p, works_on w
where w.Pno=p.Pnumber and w.Essn=Ssn;

-- Idade de cada trabalhador e seus dependentes

 select concat(Fname, ' ', Minit,' ', Lname) as Nome_Completo, (timestampdiff(year, e.Bdate, current_date())) as Idade, Dependent_name, (timestampdiff(year, de.Bdate, current_date())) as Idade_dependente, Relationship
 from employee e, dependent de
 where Essn=Ssn;

-- Idade de todos e projetos trabalhos por cada um

select concat(Fname, ' ', Minit,' ', Lname) as Nome_Completo, (timestampdiff(year, Bdate, current_date())) as Idade,count(*) Num_projetos from employee as e
inner JOIN works_on  ON e.Ssn = Essn group by 1,2;