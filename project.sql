CREATE DATABASE HospitalDB;

USE hospitaldb;

CREATE TABLE Patients(
	patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    emergency_number VARCHAR(15) NOT NULL,
    gender ENUM("Male", "Female", "Other"),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Doctors(
	doctor_ID INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_ID INT,
    phone_number VARCHAR(15),
    email VARCHAR(100),
    specialization VARCHAR(100),
    FOREIGN KEY (department_ID) REFERENCES  Departments(Department_ID)
);
CREATE TABLE Departments(
	Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Department_name VARCHAR(100) NOT NULL,
    Dept_description TEXT
    );
    
ALTEkR TABLE Departments
MODIFY Department_name VARCHAR(100) UNIQUE;

CREATE TABLE Rooms(
	room_ID INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    room_type ENUM('General', 'ICU', 'Operation', 'Emergency', 'Private') DEFAULT 'General',
    status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available'
    
);

CREATE TABLE Appointments(
	appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    patient_ID INT,
    doctor_ID INT,
    appointment_date DATE,
    appointment_time TIME,
    status ENUM ('Scheduled', 'Cancelled', 'Completed') DEFAULT 'Scheduled',
    reason TEXT,
    Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (doctor_ID) REFERENCES  Doctors(Doctor_ID)
);


CREATE TABLE Admissions(
	admission_ID INT PRIMARY KEY AUTO_INCREMENT,
    patient_ID INT NOT NULL,
    room_ID INT NOT NULL,
    admission_date DATE NOT NULL, 
    discharge_date DATE,
    status ENUM('Discharged', 'Admitted') DEFAULT 'Admitted',
    FOREIGN KEY (patient_ID) REFERENCES Patients(patient_ID),
    FOREIGN KEY (room_ID) REFERENCES Rooms(room_ID)
);

CREATE TABLE MedicalReports(
	record_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT NOT NULL,
    doctor_ID INT NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (doctor_ID) REFERENCES Doctors(Doctor_ID)
);


INSERT INTO Patients(first_name, last_name, phone_number, email, emergency_number, gender)
VALUES 
		('Mary', 'Akinyi', '254799837283', 'mary@gmail.com', '254111859373', 'Female'),
        ('Victor', 'Wamalwa', '25478374628', 'victorwamlwa@gmail.com', '254783920832', 'Male'),
        ('Brian', 'Korir', '254783728382', 'korirb@gmail.com', '254117282763', 'Male'),
        ('James', 'Mungi', '254787378237', 'mungij@gmail.com', '254783928918', 'Male'),
        ('Agnes', 'Anne', '254736763562', 'agnesanne@gmail.com', '254113435266', 'Female'),
        ('Salome', 'Muli', '254783647773', 'mulisalome@gmail.com', '254111564536', 'Female'),
        ('Phenny', 'Bet', '254783746288', 'betphenny@gmail.com', '254782938919', 'Female'),
        ('Abraham', 'Lobet', '254783746837', 'korirb@gmail.com', '254781638277', 'Male');
        
SELECT * FROM Patients;


INSERT INTO Departments(Department_name, Dept_description)
VALUES
		('Cardiology', 'Heart and cardiovascular system care'),
        ('Neurology', 'Brain and nervous system disorders'),
        ('Pediatrics', 'Medical care for infants, children, and adolescents'),
        ('Orthopedics', 'Musculoskeletal system injuries and disorders'),
        ('Emergency', 'Emergency medical care');

SELECT * FROM Departments;

INSERT INTO Doctors(first_name, last_name, department_ID, phone_number, email, specialization )
VALUES
		('Mitchel', 'Chepkoech', 2,'254783923838', 'mitchy@gmail.com', 'neurosergion'),
        ('Victor', 'Odhiambo', 1,'254783627817', 'odhiambovictor@gmail.com', 'cardiologist'),
        ('Jalila', 'Adgi', 3,'254787438819', 'adgijalila06@gmail.com', 'pedriologist'),
        ('Hamptone', 'James', 5,'254728918933', 'hamptone03@gmail.com', 'Paramedics'),
        ('Salome', 'Salma', 4,'254783728829', 'salmas@gmail.com', 'Orthopedologist');

SELECT * FROM Doctors;

INSERT INTO Rooms(room_number, room_type, status)
VALUES ('ICU01', 'ICU', 'Occupied'),
		('OP13', 'Operation', 'Available'),
        ('101', 'General', 'Occupied'),
        ('EM01', 'Emergency', 'Occupied'),
        ('102', 'General', 'Occupied'),
        ('121', 'General', 'Available'),
        ('PR021', 'Private', 'Occupied');

SELECT * FROM Rooms;

INSERT INTO Appointments(patient_ID, doctor_ID, appointment_date, appointment_time, reason)
VALUES (2, 2, '2025-10-01', '10:20:00',  'An emergency surgery'),
		(3, 3, '2025-09-01', '08:20:00',  'Child Vaccination'),
        (1, 1, '2025-10-03', '08:00:00', 'Routine heart checkup'),
        (4, 5, '2025-09-02', '11:00:00',  'Migraine treatment'),
        (6, 4, '2025-10-11', '12:00:00',  'Knee pain evaluation');

INSERT INTO Admissions(patient_ID, room_ID, admission_date, discharge_date, status)
VALUES (1, 2, '2025-07-12', NULL, 'Admitted'),
		(1, 2, '2025-07-12', '2025-08-01', 'Discharged'),
		(1, 2, '2025-07-12', NULL, 'Admitted'),
		(1, 2, '2025-07-12', NULL, 'Admitted'),
		(1, 2, '2025-07-12', NULL, 'Admitted'),
		(1, 2, '2025-07-12', NULL, 'Admitted');
        

-- Find all appointments for a specific doctor

SELECT 
		a.appointment_id,
        p.first_name AS patient_first,
        p.last_name AS patient_last,
        a.appointment_date,
        a.appointment_time,
        a.reason
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 1
ORDER BY a.appointment_date, a.appointment_time;

-- List all patients currently admitted in the hospital
SELECT 
        p.patient_id,
        p.first_name,
        p.last_name,
        r.room_number,
        a.admission_date
FROM Admissions a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Rooms r ON a.room_id = r.room_id
WHERE a.status = 'Admitted'
ORDER BY a.admission_date;

-- Get the number of doctors in each department
SELECT 
        d.department_name,
        COUNT(doc.doctor_id) AS num_doctors
FROM Departments d
LEFT JOIN Doctors doc ON d.department_id = doc.department_id
GROUP BY d.department_id, d.department_name;
-- Find all available rooms of a specific type
SELECT 
        room_id,
        room_number,
        room_type
FROM Rooms
WHERE status = 'Available' AND room_type = 'General';
-- Get the medical history of a specific patient
SELECT
        mr.record_id,
        d.first_name AS doctor_first,
        d.last_name AS doctor_last,
        mr.visit_date,
        mr.diagnosis
FROM MedicalReports mr
JOIN Doctors d ON mr.doctor_id = d.doctor_id
WHERE mr.patient_id = 1
ORDER BY mr.visit_date DESC;


-- List all patients along with their assigned doctors
SELECT
        p.patient_id,
        p.first_name AS patient_first,
        p.last_name AS patient_last,
        d.first_name AS doctor_first,
        d.last_name AS doctor_last,
        dep.department_name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Departments dep ON d.department_id = dep.department_id
ORDER BY p.patient_id;

-- Trigger to update rooms on admission and discharge
DELIMITER //
CREATE TRIGGER after_admission_insert
AFTER INSERT ON Admissions
FOR EACH ROW
BEGIN
    UPDATE Rooms
    SET status = 'Occupied'
    WHERE room_id = NEW.room_id;
END;

-- Create a view for patient details with their latest appointment
CREATE OR REPLACE VIEW PatientLatestAppointments AS
SELECT 
        p.patient_id,
        p.first_name AS patient_first,
        p.last_name AS patient_last,
        a.appointment_date,
        a.appointment_time,
        d.first_name AS doctor_first,
        d.last_name AS doctor_last
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Doctors d ON a.doctor_id = d.doctor_id
WHERE a.appointment_date = (
    SELECT MAX(appointment_date)
    FROM Appointments
    WHERE patient_id = p.patient_id
);

