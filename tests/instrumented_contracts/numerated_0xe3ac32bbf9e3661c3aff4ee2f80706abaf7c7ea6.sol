1 pragma solidity ^0.4.18;
2 
3 contract Dividend {
4     struct Record {
5         uint balance;
6         uint shares;
7         uint index;
8     }
9 
10     mapping (address => Record) public records;
11     address[] public investors;
12     address public funder;
13     uint public startTime;
14     uint public totalShares;
15     uint public lastInvestmentTime;
16 
17     event Invested(uint indexed timestamp, address indexed from, uint amount, uint shares);
18     event Withdrawn(uint indexed timestamp, address indexed from, uint amount);
19 
20     function Dividend() public payable {
21         records[msg.sender] = Record(msg.value,
22             totalShares = allocateShares(msg.value, 0),
23             investors.push(funder = msg.sender));
24         Invested(startTime = lastInvestmentTime = now, msg.sender, msg.value, totalShares);
25     }
26 
27     function () public payable {
28         if (msg.value > 0) {
29             invest();
30         } else {
31             withdraw();
32         }
33     }
34 
35     function investorCount() public view returns (uint) {
36       return investors.length;
37     }
38 
39     function invest() public payable returns (uint) {
40         uint value = msg.value;
41         uint shares = allocateShares(value, (now - startTime) / 1 hours);
42         if (shares > 0) {
43             for (uint i = investors.length; i > 0; i--) {
44                 Record storage rec = records[investors[i - 1]];
45                 rec.balance += value * rec.shares / totalShares;
46             }
47             address investor = msg.sender;
48             rec = records[investor];
49             if (rec.index > 0) {
50                 rec.shares += shares;
51             } else {
52                 rec.shares = shares;
53                 rec.index = investors.push(investor);
54             }
55             totalShares += shares;
56             Invested(lastInvestmentTime = now, investor, value, shares);
57         }
58         return shares;
59     }
60 
61     function withdraw() public returns (uint) {
62         Record storage rec = records[msg.sender];
63         uint balance = rec.balance;
64         if (balance > 0) {
65             rec.balance = 0;
66             msg.sender.transfer(balance);
67             Withdrawn(now, msg.sender, balance);
68         }
69         if (now - lastInvestmentTime > 4 weeks) {
70             selfdestruct(funder);
71         }
72         return balance;
73     }
74 
75     function allocateShares(uint weis, uint bonus) public pure returns (uint) {
76         return weis * (1000 + bonus) / 1 ether;
77     }
78 }