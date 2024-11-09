CREATE TABLE assets (
	asset_id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	brand VARCHAR(50) NOT NULL,
	picture VARCHAR(256), --stores file path to asset img
	owner VARCHAR(64),
	status VARCHAR(32) NOT NULL,
	date_acquisition DATE NOT NULL,
	cost_acquisition DECIMAL(10, 2) NOT NULL
);

DROP TABLE assets CASCADE;

CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	student_id INT UNIQUE,
	username VARCHAR(16) UNIQUE NOT NULL,
	email VARCHAR(32) UNIQUE NOT NULL,
	password CHAR(128) NOT NULL, -- use SHA-512
	first_name VARCHAR(64) NOT NULL, 
	middle_name VARCHAR(64) NOT NULL, 
	last_name VARCHAR(64) NOT NULL,
	emergency_contact VARCHAR(64),
	emergency_contact_number VARCHAR(64),
	user_type VARCHAR(16) NOT NULL,
	course_id VARCHAR(16) NOT NULL,
	 CHECK (
        (user_type = 'student' AND student_id IS NOT NULL) 
        OR (user_type <> 'student' AND student_id IS NULL)
   )
);

DROP TABLE users CASCADE;

CREATE TABLE work_orders (
	work_orders_id SERIAL PRIMARY KEY,
	asset_id INT,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	work_order_type VARCHAR(32) UNIQUE NOT NULL,
	work_order_cost DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (asset_id) REFERENCES assets(asset_id)
);

DROP TABLE work_orders CASCADE;

CREATE TABLE courses (
	course_id SERIAL PRIMARY KEY,
	name VARCHAR(64) NOT NULL,
	description VARCHAR(128)
);

DROP TABLE courses CASCADE;

CREATE TABLE semesters (
	semester_id SERIAL PRIMARY KEY,
	name VARCHAR(64) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);

DROP TABLE semesters CASCADE;

CREATE TABLE classes (
	class_id SERIAL PRIMARY KEY,
	course_id INT NOT NULL,
	semester_id INT NOT NULL,
	name VARCHAR(32) NOT NULL,
	FOREIGN KEY (course_id) REFERENCES courses(course_id),
	FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
);

DROP TABLE classes CASCADE;

CREATE TABLE groups (
	group_id SERIAL PRIMARY KEY,
	class_id INT,
	date_created DATE NOT NULL,
	is_internal BOOLEAN NOT NULL,
	FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- 

CREATE TABLE groups_members (
	group_id SERIAL PRIMARY KEY,
	user_id SERIAL UNIQUE NOT NULL,
	date_created DATE NOT NULL
);

-- 

CREATE TABLE reservations (
	reservation_id SERIAL PRIMARY KEY,
	group_id INT,
	asset_id INT,
	semester_id INT,
	reservation_date DATE NOT NULL,
	start_time TIME NOT NULL,
	end_time TIME NOT NULL,
	approval BOOLEAN NOT NULL,
	FOREIGN KEY (group_id) REFERENCES groups_members(group_id),
	FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
	FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
);

DROP TABLE reservations CASCADE;

CREATE TABLE class_members (
	class_member_id SERIAL PRIMARY KEY,
	class_id INT NOT NULL,
	user_id INT NOT NULL,
	is_instructor BOOLEAN NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

--

CREATE TABLE class_reservation (
	class_reservation_id SERIAL PRIMARY KEY,
	asset_id SERIAL NOT NULL,
	class_id SERIAL NOT NULL,
	FOREIGN KEY (asset_id) REFERENCES assets(asset_id),
	FOREIGN KEY (class_id) REFERENCES classes(class_id)
);