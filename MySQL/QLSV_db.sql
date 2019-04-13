-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema QLSV_db
-- -----------------------------------------------------
-- Đây là CSDL quản lý SV trường BKHN

-- -----------------------------------------------------
-- Schema QLSV_db
--
-- Đây là CSDL quản lý SV trường BKHN
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `QLSV_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
USE `QLSV_db` ;

-- -----------------------------------------------------
-- Table `QLSV_db`.`Faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Faculty` (
  `id` TINYINT NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'Tên khoa/viện',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Department` (
  `id` TINYINT NOT NULL,
  `name` VARCHAR(45) NOT NULL COMMENT 'Tên bộ môn (trong 1 khoa)',
  `Faculty_id` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `MaKhoa_d_idx` (`Faculty_id` ASC),
  CONSTRAINT `MaKhoa_d`
    FOREIGN KEY (`Faculty_id`)
    REFERENCES `QLSV_db`.`Faculty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Teacher` (
  `id` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `password` VARCHAR(15) NOT NULL,
  `Department_id` TINYINT NOT NULL,
  `email` VARCHAR(45) NULL,
  `phone` VARCHAR(15) NULL,
  `workplace` VARCHAR(45) NULL,
  `website` VARCHAR(45) NULL,
  `photo` BLOB NULL,
  PRIMARY KEY (`id`),
  INDEX `MaBoMon_t_idx` (`Department_id` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC),
  CONSTRAINT `MaBoMon_t`
    FOREIGN KEY (`Department_id`)
    REFERENCES `QLSV_db`.`Department` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`SVClass`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`SVClass` (
  `id` VARCHAR(20) NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `numOfStudent` INT NOT NULL,
  `monitor_id` INT NULL,
  `Teacher_id` VARCHAR(10) NULL,
  `Faculty_id` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `LopTruong_svc_idx` (`monitor_id` ASC),
  INDEX `GVChuNhiem_svc_idx` (`Teacher_id` ASC),
  INDEX `Khoa_svc_idx` (`Faculty_id` ASC),
  CONSTRAINT `LopTruong_svc`
    FOREIGN KEY (`monitor_id`)
    REFERENCES `QLSV_db`.`Student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `GVChuNhiem_svc`
    FOREIGN KEY (`Teacher_id`)
    REFERENCES `QLSV_db`.`Teacher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Khoa_svc`
    FOREIGN KEY (`Faculty_id`)
    REFERENCES `QLSV_db`.`Faculty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Student` (
  `id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `password` VARCHAR(15) NOT NULL,
  `address` VARCHAR(45) NULL,
  `email` VARCHAR(30) NULL,
  `phone` VARCHAR(13) NULL,
  `photo` BLOB NULL,
  `SVClass_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Student_SVClass_idx` (`SVClass_id` ASC),
  UNIQUE INDEX `emai_s_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC),
  CONSTRAINT `fk_Student_SVClass`
    FOREIGN KEY (`SVClass_id`)
    REFERENCES `QLSV_db`.`SVClass` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Subject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Subject` (
  `id` CHAR(10) NOT NULL COMMENT 'Mã học phần',
  `name` VARCHAR(45) NOT NULL,
  `credit` TINYINT NOT NULL COMMENT 'số tín chỉ',
  `feeCredit` FLOAT(2,1) NOT NULL COMMENT 'tín chỉ học phý',
  `weight` FLOAT(2,1) NOT NULL COMMENT 'trọng số (VD: 0.7)',
  `teachingWeight` VARCHAR(10) NOT NULL COMMENT 'khối lượng giảng dạy (VD: 3-1-0-6)',
  `Faculty_id` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `MaKhoa_sj_idx` (`Faculty_id` ASC),
  CONSTRAINT `MaKhoa_sj`
    FOREIGN KEY (`Faculty_id`)
    REFERENCES `QLSV_db`.`Faculty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Course` (
  `id` INT NOT NULL COMMENT 'Mã lớp học',
  `Subject_id` CHAR(10) NOT NULL,
  `term` SMALLINT NOT NULL COMMENT 'Học kỳ',
  `courseType` VARCHAR(10) NOT NULL COMMENT 'Loại lớp học (LT, BT, TH)',
  `time` VARCHAR(30) NOT NULL COMMENT 'Giờ học trong ngày',
  `dayOfWeek` TINYINT NOT NULL COMMENT 'Ngày học trong tuần',
  `week` VARCHAR(15) NOT NULL COMMENT 'Các tuần học',
  `room` VARCHAR(10) NOT NULL COMMENT 'Phòng học',
  `Teacher_id` VARCHAR(10) NULL COMMENT 'GV dạy',
  PRIMARY KEY (`id`, `dayOfWeek`),
  INDEX `MaHP_c_idx` (`Subject_id` ASC),
  INDEX `Lecturer_c_idx` (`Teacher_id` ASC),
  CONSTRAINT `MaHP_c`
    FOREIGN KEY (`Subject_id`)
    REFERENCES `QLSV_db`.`Subject` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Lecturer_c`
    FOREIGN KEY (`Teacher_id`)
    REFERENCES `QLSV_db`.`Teacher` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`ScoreBoard`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`ScoreBoard` (
  `Student_id` INT NOT NULL,
  `Course_id` INT NOT NULL,
  `processScore` FLOAT(3,1) NOT NULL,
  `finalScore` FLOAT(3,1) NOT NULL,
  `overall` FLOAT(3,1) NOT NULL,
  `letterScore` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`Student_id`, `Course_id`),
  INDEX `MaLopHoc_idx` (`Course_id` ASC),
  CONSTRAINT `MSSV`
    FOREIGN KEY (`Student_id`)
    REFERENCES `QLSV_db`.`Student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MaLopHoc`
    FOREIGN KEY (`Course_id`)
    REFERENCES `QLSV_db`.`Course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`ExamSchedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`ExamSchedule` (
  `id` SMALLINT NOT NULL COMMENT 'Mã lớp thi',
  `Course_id` INT NOT NULL COMMENT 'Mã lớp học',
  `room` VARCHAR(10) NOT NULL COMMENT 'Phòng thi',
  `kip` TINYINT NOT NULL COMMENT 'Kíp thi',
  `day` DATE NOT NULL COMMENT 'Ngày thi (yyyy/MM/dd)',
  PRIMARY KEY (`id`),
  INDEX `MaLopHoc_es_idx` (`Course_id` ASC),
  CONSTRAINT `MaLopHoc_es`
    FOREIGN KEY (`Course_id`)
    REFERENCES `QLSV_db`.`Course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`Fee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`Fee` (
  `Student_id` INT NOT NULL,
  `term` SMALLINT NOT NULL,
  `numOfCredit` TINYINT NOT NULL COMMENT 'số tín chỉ bình thường',
  `extraNumOfCredit` TINYINT NOT NULL COMMENT 'số lượng tín chỉ đb (x1.5)',
  `creditFee` FLOAT NOT NULL COMMENT 'giá mỗi tín chỉ',
  `extraFee` FLOAT NOT NULL COMMENT 'Phụ phý',
  `total` FLOAT NOT NULL COMMENT 'tổng học phí',
  PRIMARY KEY (`Student_id`, `term`),
  CONSTRAINT `MSSV_f`
    FOREIGN KEY (`Student_id`)
    REFERENCES `QLSV_db`.`Student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`TimeTable`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`TimeTable` (
  `Course_id` INT NOT NULL COMMENT 'Mã lớp học',
  `Student_id` INT NOT NULL COMMENT 'Mã sinh viên',
  INDEX `MaLopHoc_tt_idx` (`Course_id` ASC),
  INDEX `MSSV_tt_idx` (`Student_id` ASC),
  PRIMARY KEY (`Course_id`, `Student_id`),
  CONSTRAINT `MaLopHoc_tt`
    FOREIGN KEY (`Course_id`)
    REFERENCES `QLSV_db`.`Course` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `MSSV_tt`
    FOREIGN KEY (`Student_id`)
    REFERENCES `QLSV_db`.`Student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`AcademicStaff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`AcademicStaff` (
  `id` CHAR(10) NOT NULL COMMENT 'Mã số giáo vụ',
  `name` VARCHAR(35) NOT NULL COMMENT 'Tên của giáo vụ',
  `password` VARCHAR(15) NOT NULL,
  `email` VARCHAR(30) NULL,
  `phone` VARCHAR(15) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`availableterm`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`availableterm` (
  `term` SMALLINT NOT NULL,
  PRIMARY KEY (`term`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `QLSV_db`.`CPA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `QLSV_db`.`CPA` (
  `Student_id` INT NOT NULL,
  `term` SMALLINT NOT NULL,
  `credits` TINYINT NOT NULL COMMENT 'Số tín chỉ học trong 1 kỳ',
  `accumulatedCredits` SMALLINT NOT NULL COMMENT 'Tổng số tín chỉ tích lũy từ đầu năm tới học kỳ đó',
  `GPA` FLOAT(3,2) NOT NULL,
  `CPA` FLOAT(3,2) NOT NULL,
  PRIMARY KEY (`Student_id`, `term`),
  CONSTRAINT `MaSV`
    FOREIGN KEY (`Student_id`)
    REFERENCES `QLSV_db`.`Student` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `QLSV_db`;

DELIMITER $$
USE `QLSV_db`$$
CREATE TRIGGER Student_AFTER_INSERT AFTER INSERT ON `Student` FOR EACH ROW
BEGIN
    UPDATE SVClass SET numOfStudent = numOfStudent + 1 WHERE id = NEW.SVClass_id;
END;$$

USE `QLSV_db`$$
CREATE TRIGGER Student_AFTER_UPDATE AFTER UPDATE ON `Student` FOR EACH ROW
BEGIN
	UPDATE SVClass SET numOfStudent = numOfStudent + 1 WHERE id = NEW.SVClass_id;
    UPDATE SVClass SET numOfStudent = numOfStudent - 1 WHERE id = OLD.SVClass_id;
END;$$

USE `QLSV_db`$$
CREATE TRIGGER Student_AFTER_DELETE AFTER DELETE ON `Student` FOR EACH ROW
BEGIN
	UPDATE SVClass SET numOfStudent = numOfStudent - 1 WHERE id = OLD.SVClass_id;
END;$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
