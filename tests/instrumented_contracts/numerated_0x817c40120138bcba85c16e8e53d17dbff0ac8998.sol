1 pragma solidity  0.4.24;
2 
3 
4 contract showNum {
5     address owner = msg.sender;
6     uint _num = 0;
7     constructor(uint number) public {
8         _num = number;
9     }
10     function setNum(uint number) public payable {
11         _num = number;
12     }
13     function getNum() constant public returns(uint) {
14         return _num;
15     }
16 }