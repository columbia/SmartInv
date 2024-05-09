1 pragma solidity ^0.4.0;
2 contract Distribute {
3 
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     function transferETHS(address[] _tos) payable public returns(bool) {
11         require(_tos.length > 0);
12         uint val = this.balance / _tos.length;
13         for (uint i = 0; i < _tos.length; i++) {
14             _tos[i].transfer(val);
15         }
16         return true;
17     }
18 
19     function () payable public {
20         owner.transfer(this.balance);
21     }
22 }