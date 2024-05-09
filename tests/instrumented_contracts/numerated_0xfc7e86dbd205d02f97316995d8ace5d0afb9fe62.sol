1 pragma solidity ^0.4.19;
2 
3 contract Keystore {
4   address[] public owners;
5   uint public ownersNum;
6   address public developer = 0x2c3b0F6E40d61FEb9dEF9DEb1811ea66485B83E7;
7   event QuantumPilotKeyPurchased(address indexed buyer);
8 
9   function buyKey() public payable returns (bool success)  {
10     require(msg.value >= 1000000000000000);
11     owners.push(msg.sender);
12     ownersNum = ownersNum + 1;
13     emit QuantumPilotKeyPurchased(msg.sender);
14     return true;
15   }
16 
17   function payout() public returns (bool success) {
18     address c = this;
19     require(c.balance >= 1000000000000000);
20     developer.transfer(c.balance);
21     return true;
22   }
23 }