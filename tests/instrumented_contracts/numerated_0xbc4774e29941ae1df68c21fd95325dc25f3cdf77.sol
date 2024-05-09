1 pragma solidity ^0.4.0;
2 
3 contract Lime7 {
4     
5     address public creatorad;
6 
7     function Lime7() {
8         creatorad = msg.sender;
9     }
10 
11     function feedme(uint256 amount) payable returns(bool success) {
12         return true;
13     }
14     
15     function payback(uint256 _amts) returns (string) {
16         creatorad.transfer(_amts);
17         return "good";
18     }
19     
20     function get () constant returns (uint) {
21         return this.balance;
22     }
23 
24 }