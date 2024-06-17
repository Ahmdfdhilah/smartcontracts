const CarInsurance = artifacts.require("CarInsurance");

module.exports = function(deployer) {
  deployer.deploy(CarInsurance, { gas: 6000000 }); 
};
