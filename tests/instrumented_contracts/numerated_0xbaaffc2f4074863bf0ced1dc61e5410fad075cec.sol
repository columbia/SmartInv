1 // sendlimiter
2 // limit funds held on a contract
3 // @authors:
4 // Cody Burns <dontpanic@codywburns.com>
5 // license: Apache 2.0
6 // version:
7 
8 pragma solidity ^0.4.19;
9 
10 // Intended use:  
11 // cross deploy to limit funds on a chin identifier
12 // Status: functional
13 // still needs:
14 // submit pr and issues to https://github.com/realcodywburns/
15 //version 0.1.0
16 
17 
18 contract sendlimiter{
19  function () public payable {
20      require(this.balance + msg.value < 100000000);}
21 }