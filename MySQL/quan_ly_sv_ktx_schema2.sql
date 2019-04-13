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
  `idToaNha` VARCHAR(10) NOT NULL,
  `soLuongPhong` INT NULL,
  `sdt` VARCHAR(15) NULL,
  PRIMARY KEY (`idToaNha`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`Admin` (
  `idAdmin` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NULL,
  `username` VARCHAR(45) NULL,
  `password` VARCHAR(20) NULL,
  `ToaNha_idToaNha` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idAdmin`, `ToaNha_idToaNha`),
  INDEX `fk_Admin_ToaNha1_idx` (`ToaNha_idToaNha` ASC),
  CONSTRAINT `fk_Admin_ToaNha1`
    FOREIGN KEY (`ToaNha_idToaNha`)
    REFERENCES `quan_ly_sv_KTX`.`ToaNha` (`idToaNha`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`Phong`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`Phong` (
  `idPhong` VARCHAR(10) NOT NULL,
  `loaiPhong` VARCHAR(45) NULL,
  `toaNha` VARCHAR(5) NULL,
  `soLuongCho` INT NULL,
  `soLuongChoTrong` INT NULL,
  `giaThue` FLOAT NULL,
  `ToaNha_idToaNha` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idPhong`, `ToaNha_idToaNha`),
  INDEX `fk_Phong_ToaNha_idx` (`ToaNha_idToaNha` ASC),
  CONSTRAINT `fk_Phong_ToaNha`
    FOREIGN KEY (`ToaNha_idToaNha`)
    REFERENCES `quan_ly_sv_KTX`.`ToaNha` (`idToaNha`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `quan_ly_sv_KTX`.`SinhVien`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `quan_ly_sv_KTX`.`SinhVien` (
  `idSinhVien` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `khoaVien` VARCHAR(45) NULL,
  `birthday` VARCHAR(12) NULL,
  `khoa` INT NULL,
  `que_quan` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `sdt` VARCHAR(15) NULL,
  `phongTro` VARCHAR(10) NULL,
  `Phong_idPhong` VARCHAR(10) NOT NULL,
  `Phong_ToaNha_idToaNha` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idSinhVien`, `Phong_idPhong`, `Phong_ToaNha_idToaNha`),
  INDEX `fk_SinhVien_Phong1_idx` (`Phong_idPhong` ASC, `Phong_ToaNha_idToaNha` ASC),
  CONSTRAINT `fk_SinhVien_Phong1`
    FOREIGN KEY (`Phong_idPhong` , `Phong_ToaNha_idToaNha`)
    REFERENCES `quan_ly_sv_KTX`.`Phong` (`idPhong` , `ToaNha_idToaNha`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
