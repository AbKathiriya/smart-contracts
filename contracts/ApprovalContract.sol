// SPDX-License-Identifier: MIT
pragma solidity >=0.4.18;

contract ApprovalContract {
    address public sender;
    address payable public receiver;
    address public constant approver = 0x3E2a82D8812947F8Ba67e70c4B498c6858230E1D;

    function deposit(address payable _receiver) external payable {
        require(msg.value > 0);
        sender = msg.sender;
        receiver = _receiver;
    }

    function viewApprovar() external pure returns(address) {
        return(approver);
    }

    function approve() external {
        require(msg.sender == approver);
        receiver.transfer(address(this).balance);
    }
}