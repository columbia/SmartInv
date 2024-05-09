1 pragma solidity ^0.4.0;
2 contract Distribute {
3 
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     //批量转账  
11     function transferETHS(address[] _tos) payable public returns(bool) {
12         require(_tos.length > 0);
13         uint val = this.balance / _tos.length;
14         for (uint32 i = 0; i < _tos.length; i++) {
15             _tos[i].transfer(val);
16         }
17         return true;
18     }
19 
20     function () payable public {
21         owner.transfer(this.balance);
22     }
23 }