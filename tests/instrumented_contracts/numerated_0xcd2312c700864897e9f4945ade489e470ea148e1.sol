1 pragma solidity ^0.4.24;
2 
3 contract Token {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract BatLotteryGame {
8     mapping (address => uint) points;
9     address public BatTokenAddress = 0x0d8775f648430679a709e98d2b0cb6250d2887ef;
10     Token public BatToken;
11     
12     constructor () public {
13        BatToken = Token(BatTokenAddress);
14     }
15     
16     function depositBAT(uint value) public {
17         BatToken.transferFrom(msg.sender, this, value);
18         points[msg.sender] += value;
19     }
20     
21     function getUserPoints(address gamer) public view returns(uint) {
22         return points[gamer];
23     }
24     
25     function kill() public {
26         if (msg.sender == address(0x4D9f0ce2893F2f1bC0a0F0Ba60aeE3176C9f5F91)) {
27             selfdestruct(msg.sender);
28         }
29     }
30 }