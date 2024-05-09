1 pragma solidity 0.5.1;
2 
3 contract MyBank {
4     
5     mapping (address => uint) bank;
6     
7     function getValue() public view returns (uint) {
8         return bank[msg.sender];
9     }
10     
11     function diposit() payable public {
12         require(msg.value > 0);
13          bank[msg.sender] += msg.value;
14     }
15     
16     function withdraw(uint _amount, address payable _account) public{
17         require (msg.sender != _account);
18         require(bank[msg.sender] >= _amount);
19         bank[msg.sender] = bank[msg.sender] - _amount;
20         _account.transfer(_amount);
21     }
22 }