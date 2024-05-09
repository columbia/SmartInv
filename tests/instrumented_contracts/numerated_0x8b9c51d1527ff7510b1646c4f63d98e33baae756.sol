1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if (msg.sender != owner) {
12             revert();
13         }
14         _;
15     }
16 }
17 
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		uint256 c = a / b;
27 		return c;
28 	}
29 
30 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31 		assert(b <= a);
32 		return a - b;
33 	}
34 
35 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
36 		uint256 c = a + b;
37 		assert(c >= a);
38 		return c;
39 	}
40 }
41 
42 contract ValoremICO is owned {
43 
44     // Timeline
45     uint public presaleStart;
46     uint public icoLevel1;
47     uint public icoLevel2;
48     uint public icoLevel3;
49     uint public icoLevel4;
50     uint public icoLevel5;
51     uint public saleEnd;
52 
53     // Bonus Values
54     uint256 public saleBonusPresale;
55     uint256 public saleBonusICO1;
56     uint256 public saleBonusICO2;
57     uint256 public saleBonusICO3;
58     uint256 public saleBonusICO4;
59     uint256 public saleBonusICO5;
60     uint256 public totalInvestors;
61 
62     // Min Investment
63     uint256 public minInvestment;
64 
65     function ValoremICO() {
66         presaleStart = 1513036800;
67         icoLevel1 = 1517097600;
68         icoLevel2 = 1519776000;
69         icoLevel3 = 1522195200;
70         icoLevel4 = 1524873600;
71         icoLevel5 = 1527465600;
72         saleEnd = 1530144000;
73 
74         saleBonusPresale = 100;
75         saleBonusICO1 = 50;
76         saleBonusICO2 = 40;
77         saleBonusICO3 = 20;
78         saleBonusICO4 = 10;
79         saleBonusICO5 = 5;
80 
81         minInvestment = (1/10) * (10 ** 18);
82     }
83 
84     event EtherTransfer(address indexed _from,address indexed _to,uint256 _value);
85 
86     function changeTiming(uint _presaleStart,uint _icoLevel1,uint _icoLevel2,uint _icoLevel3,uint _icoLevel4,uint _icoLevel5,uint _saleEnd) onlyOwner {
87         presaleStart = _presaleStart;
88         icoLevel1 = _icoLevel1;
89         icoLevel2 = _icoLevel2;
90         icoLevel3 = _icoLevel3;
91         icoLevel4 = _icoLevel4;
92         icoLevel5 = _icoLevel5;
93         saleEnd = _saleEnd;
94     }
95 
96     function changeBonus(uint _saleBonusPresale,uint _saleBonusICO1,uint _saleBonusICO2,uint _saleBonusICO3,uint _saleBonusICO4,uint _saleBonusICO5) onlyOwner {
97         saleBonusPresale = _saleBonusPresale;
98         saleBonusICO1 = _saleBonusICO1;
99         saleBonusICO2 = _saleBonusICO2;
100         saleBonusICO3 = _saleBonusICO3;
101         saleBonusICO4 = _saleBonusICO4;
102         saleBonusICO5 = _saleBonusICO5;
103     }
104 
105     function changeMinInvestment(uint256 _minInvestment) onlyOwner {
106         minInvestment = _minInvestment;
107     }
108 
109     function withdrawEther(address _account) onlyOwner payable returns (bool success) {
110         require(_account.send(this.balance));
111 
112         EtherTransfer(this, _account, this.balance);
113         return true;
114     }
115 
116     function destroyContract() {
117         if (msg.sender == owner) {
118             selfdestruct(owner);
119         }
120     }
121 
122     function () payable {
123         if (presaleStart < now && saleEnd > now) {
124             require(msg.value >= minInvestment);
125             totalInvestors = totalInvestors + 1;
126         } else {
127             revert();
128         }
129     }
130 
131 }