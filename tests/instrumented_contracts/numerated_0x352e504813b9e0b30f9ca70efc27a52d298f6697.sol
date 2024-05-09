1 pragma solidity ^0.4.25;
2 
3 // Updated for compiler compatibility.
4 contract AmIOnTheFork {
5     function forked() public constant returns(bool);
6 }
7 
8 contract ForkSweeper {
9     bool public isForked;
10     
11     constructor() public {
12       isForked = AmIOnTheFork(0x2BD2326c993DFaeF84f696526064FF22eba5b362).forked();
13     }
14     
15     function redirect(address ethAddress, address etcAddress) public payable {
16         if (isForked) {
17             ethAddress.transfer(msg.value);
18             
19             return;
20         }
21         
22         etcAddress.transfer(msg.value);
23             
24         return;
25     }
26 }