1 pragma solidity ^0.4.17;
2 
3 contract Owned {
4     address public owner;
5     function Owned() { owner = msg.sender; }
6     modifier onlyOwner { if (msg.sender != owner) revert(); _; }
7 }
8 
9 contract PasswordRecoverableWallet is Owned {
10     event Deposit(address from, uint amount);
11     event Withdrawal(address from, uint amount);
12     address public owner = msg.sender;
13     bytes32 recoveryHash;
14     uint256 recoveryValue;
15 
16     function() public payable {
17         Deposit(msg.sender, msg.value);
18     }
19 
20     function setRecoveryInfo(bytes32 hash, uint256 value) public onlyOwner {
21         recoveryHash = hash;
22         recoveryValue = value;
23     }
24 
25     function recover(bytes32 password) public payable {
26         if ((sha256(password) == recoveryHash) && (msg.value == recoveryValue)) owner = msg.sender;
27     }
28 
29     function withdraw(uint amount) public onlyOwner {
30         msg.sender.transfer(amount);
31         Withdrawal(msg.sender, amount);
32     }
33 }