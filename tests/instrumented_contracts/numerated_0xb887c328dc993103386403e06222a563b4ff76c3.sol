1 pragma solidity ^0.4.24;
2 contract Token {
3     function balanceOf(address guy) public view returns (uint);
4     function transfer(address dst, uint wad) public returns (bool);
5 }
6 
7 contract RecuringInternetPayer{
8     address zac  = 0x1F4E7Db8514Ec4E99467a8d2ee3a63094a904e7A;
9     address josh = 0x650a7762FdB32BF64849345209DeaA8F9574cBC7;
10     Token dai = Token(0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359); //DAI token address
11     uint constant perSecondDaiParticlePayout = 28935185185185 ; // $75 x 10^18 / (60*60*24*30)
12     uint public totalPaid;
13     uint createdAt;
14     
15     constructor() public { createdAt = now; }
16 
17     modifier onlyZacOrJosh(){ require(msg.sender == zac || msg.sender == josh); _; }
18     
19     function payJosh() public{
20         uint currentPayment = perSecondDaiParticlePayout * (now - createdAt) - totalPaid;
21         dai.transfer(josh, currentPayment);
22         totalPaid += currentPayment;
23     }
24     function withdraw() public onlyZacOrJosh{ // discontinue service
25         payJosh();
26         dai.transfer(zac, dai.balanceOf(this));
27     }
28 }