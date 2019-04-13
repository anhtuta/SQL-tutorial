-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema quan_ly_sv_KTX
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema quan_ly_sv_KTX
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `quan_ly_sv_KTX` DEFAULT CHARACTER SET utf8 ;
USE `quan_ly_sv_KTX` ;

-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`ToaNha`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`ToaNha` (
  `tenToaNha` VARCHAR(10) NOT NULL,
  `soLuongPhong` INT NULL,
  `sdt` VARCHAR(15) NULL,
  PRIMARY KEY (`tenToaNha`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`Admin` (
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(20) NULL,
  `name` VARCHAR(45) NULL,
  `sdt` VARCHAR(45) NULL,
  `ToaNha_tenToaNha` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`username`, `ToaNha_tenToaNha`),
  INDEX `fk_Admin_ToaNha1_idx` (`ToaNha_tenToaNha` ASC),
  CONSTRAINT `fk_Admin_ToaNha1`
    FOREIGN KEY (`ToaNha_tenToaNha`)
    REFERENCES `quan_ly_sv_KTX`.`ToaNha` (`tenToaNha`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`Phong`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`Phong` (
  `tenPhong` VARCHAR(10) NOT NULL,
  `loaiPhong` VARCHAR(45) NULL,
  `toaNha` VARCHAR(5) NULL,
  `soLuongCho` INT NULL,
  `soLuongChoTrong` INT NULL,
  `giaThue` FLOAT NULL,
  `ToaNha_tenToaNha` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`tenPhong`, `ToaNha_tenToaNha`),
  INDEX `fk_Phong_ToaNha1_idx` (`ToaNha_tenToaNha` ASC),
  CONSTRAINT `fk_Phong_ToaNha1`
    FOREIGN KEY (`ToaNha_tenToaNha`)
    REFERENCES `quan_ly_sv_KTX`.`ToaNha` (`tenToaNha`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`SinhVien`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`SinhVien` (
  `MSSV` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `birthday` VARCHAR(12) NULL,
  `khoaVien` VARCHAR(45) NULL,
  `khoa` INT NULL,
  `que_quan` VARCHAR(45) NULL,
  `phongTro` VARCHAR(10) NULL,
  `Phong_tenPhong` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`MSSV`, `Phong_tenPhong`),
  INDEX `fk_SinhVien_Phong_idx` (`Phong_tenPhong` ASC),
  CONSTRAINT `fk_SinhVien_Phong`
    FOREIGN KEY (`Phong_tenPhong`)
    REFERENCES `quan_ly_sv_KTX`.`Phong` (`tenPhong`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
