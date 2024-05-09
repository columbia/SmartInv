1 pragma solidity ^0.4.23;
2 
3 
4 
5 library Percent {
6   // Solidity automatically throws when dividing by 0
7   struct percent {
8     uint num;
9     uint den;
10   }
11   function mul(percent storage p, uint a) internal view returns (uint) {
12     if (a == 0) {
13       return 0;
14     }
15     return a*p.num/p.den;
16   }
17 
18   function div(percent storage p, uint a) internal view returns (uint) {
19     return a/p.num*p.den;
20   }
21 
22   function sub(percent storage p, uint a) internal view returns (uint) {
23     uint b = mul(p, a);
24     if (b >= a) return 0; // solium-disable-line lbrace
25     return a - b;
26   }
27 
28   function add(percent storage p, uint a) internal view returns (uint) {
29     return a + mul(p, a);
30   }
31 }
32 
33 contract InvestorsStorage {
34   function investorFullInfo(address addr) public view returns(uint, uint, uint, uint);
35   function investorBaseInfo(address addr) public view returns(uint, uint, uint);
36   function investorShortInfo(address addr) public view returns(uint, uint);
37   function keyFromIndex(uint i) public view returns (address);
38   function size() public view returns (uint);
39   function iterStart() public pure returns (uint);
40 }
41 
42 contract Revolution {
43   function dividendsPercent() public view returns(uint numerator, uint denominator);
44   function latestPayout() public view returns(uint timestamp) ;
45 }
46 
47 contract RevolutionInfo {
48   using Percent for Percent.percent;
49   address private owner;
50   Revolution public revolution;
51   InvestorsStorage public investorsStorage;
52   Percent.percent public dividendsPercent;
53   
54   modifier onlyOwner() {
55     require(msg.sender == owner, "access denied");
56     _;
57   }
58   
59   constructor() public {
60     owner = msg.sender;
61   }
62   
63   function info() public view returns(uint totalInvl, uint debt, uint dailyWithdraw) {
64     uint i = investorsStorage.iterStart();
65     uint size = investorsStorage.size();
66     address addr;
67     uint inv;
68     uint time;
69     uint ref;
70     uint latestPayout = revolution.latestPayout();
71     
72     for (i; i < size; i++) {
73       addr = investorsStorage.keyFromIndex(i);
74       (inv, time, ref) = investorsStorage.investorBaseInfo(addr);
75       if (time == 0) {
76         time = latestPayout;
77       }
78       totalInvl += inv;
79       debt += ((now - time) / 24 hours) * dividendsPercent.mul(inv) + ref;
80     }
81     dailyWithdraw = dividendsPercent.mul(totalInvl);
82   }
83   
84   function setRevolution(address addr) public onlyOwner {
85     revolution = Revolution(addr);
86     (uint num, uint den) = revolution.dividendsPercent();
87     dividendsPercent = Percent.percent(num, den);
88   }
89   
90   function setInvestorsStorage(address addr) public onlyOwner{
91     investorsStorage = InvestorsStorage(addr);
92   }
93 }