const ApprovalContract = artifacts.require("ApprovalContract");
const BallotContract = artifacts.require("Ballot");

module.exports = function (deployer) {
  deployer.deploy(ApprovalContract);
  deployer.deploy(BallotContract, ['0x9F4318540968B63937b62eAB21999D6DA3019ACf', '0xf1F688702f1589F305Bf5DdfDCd04ba32C14eB99', '0xB5810265f730649EdfaD312AC6F5394092f80Dcd']);
};