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
28         invest();
29     }
30 
31     function investorCount() public view returns (uint) {
32       return investors.length;
33     }
34 
35     function invest() public payable returns (uint) {
36         uint value = msg.value;
37         uint shares = allocateShares(value, (now - startTime) / 1 hours);
38         if (shares > 0) {
39             for (uint i = investors.length; i > 0; i--) {
40                 Record storage rec = records[investors[i - 1]];
41                 rec.balance += value * rec.shares / totalShares;
42             }
43             address investor = msg.sender;
44             rec = records[investor];
45             if (rec.index > 0) {
46                 rec.shares += shares;
47             } else {
48                 rec.shares = shares;
49                 rec.index = investors.push(investor);
50             }
51             totalShares += shares;
52             Invested(lastInvestmentTime = now, investor, value, shares);
53         }
54         return shares;
55     }
56 
57     function withdraw() public returns (uint) {
58         Record storage rec = records[msg.sender];
59         uint balance = rec.balance;
60         if (balance > 0) {
61             rec.balance = 0;
62             msg.sender.transfer(balance);
63             Withdrawn(now, msg.sender, balance);
64         }
65         if (now - lastInvestmentTime > 4 weeks) {
66             selfdestruct(funder);
67         }
68         return balance;
69     }
70 
71     function allocateShares(uint weis, uint bonus) public pure returns (uint) {
72         return weis * (1000 + bonus) / 1 ether;
73     }
74 }