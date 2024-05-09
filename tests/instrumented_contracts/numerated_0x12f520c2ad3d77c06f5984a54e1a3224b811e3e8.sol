1 pragma solidity ^0.4.0;
2 
3 contract Marvin {
4     address owner;
5     string flag = "9KByjrJNbaRuux4tPd8868";
6     bytes32 hashedflag = 0x44ad5cdba0469b29dd12b95d69bcf3b82bb7e2519a4e24b8ce0473028273d5c6;
7     
8     event statusCode(int32 code);
9 
10     function Marvin() payable {
11         owner = msg.sender;
12     }
13 
14     function freeBeerOnMe(string sha512flag) {
15         if (hashedflag == keccak256(sha512flag)){
16             msg.sender.transfer(this.balance);
17             statusCode(42);
18         }
19         else{
20             statusCode(-1);
21         }
22     }
23 
24 }