1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5 		uint256 c = a * b;
6 		assert(a == 0 || c / a == b);
7 		return c;
8 	}
9 
10 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
11 		uint256 c = a / b;
12 		return c;
13 	}
14 
15 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16 		assert(b <= a);
17 		return a - b;
18 	}
19 
20 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
21 		uint256 c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 }
26 
27 
28 contract owned {
29     address public owner;
30 
31     function owned() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         if (msg.sender != owner) {
37             revert();
38         }
39         _;
40     }
41 }
42 
43 contract Presale is owned {
44 
45     uint public presaleStart;
46     uint public stage1Start;
47     uint public stage2Start;
48     uint public stage3Start;
49     uint public stage4Start;
50     uint public saleEnd;
51 
52     uint256 public presaleBonus;
53     uint256 public stage1Bonus;
54     uint256 public stage2Bonus;
55     uint256 public stage3Bonus;
56     uint256 public stage4Bonus;
57 
58     uint256 public buyingPrice;
59 
60     function Presale() {
61         presaleStart = 1508112000; // 16 Oct
62         stage1Start = 1511179200; // 20 Nov
63         stage2Start = 1512043200; // 30 Nov
64         stage3Start = 1512907200; // 10 Dec
65         stage4Start = 1513771200; // 20 Dec
66         saleEnd = 1514635200; // 30 Dec
67 
68         presaleBonus = 50;
69         stage1Bonus = 25;
70         stage2Bonus = 20;
71         stage3Bonus = 15;
72         stage4Bonus = 10;
73 
74         buyingPrice = 5000000000000000; // 1 ETH = 200 VLR
75     }
76 
77     event EtherTransfer(address indexed _from,address indexed _to,uint256 _value);
78 
79     function changeTiming(uint _presaleStart,uint _stage1Start,uint _stage2Start,uint _stage3Start,uint _stage4Start,uint _saleEnd) onlyOwner {
80         presaleStart = _presaleStart;
81         stage1Start = _stage1Start;
82         stage2Start = _stage2Start;
83         stage3Start = _stage3Start;
84         stage4Start = _stage4Start;
85         saleEnd = _saleEnd;
86     }
87 
88     function changeBonus(uint256 _presaleBonus,uint256 _stage1Bonus,uint256 _stage2Bonus,uint256 _stage3Bonus,uint256 _stage4Bonus) onlyOwner {
89         presaleBonus = _presaleBonus;
90         stage1Bonus = _stage1Bonus;
91         stage2Bonus = _stage2Bonus;
92         stage3Bonus = _stage3Bonus;
93         stage4Bonus = _stage4Bonus;
94     }
95 
96     function changeBuyingPrice(uint256 _buyingPrice) onlyOwner {
97         buyingPrice = _buyingPrice;
98     }
99 
100     function withdrawEther() onlyOwner payable returns (bool success) {
101         require(owner.send(this.balance));
102 
103         EtherTransfer(this, msg.sender, this.balance);
104         return true;
105     }
106 
107     function destroyContract() {
108         if (msg.sender == owner) {
109             selfdestruct(owner);
110         }
111     }
112 
113     function () payable {
114         uint256 tokens = msg.value / buyingPrice;
115 
116         if (presaleStart < now && stage1Start > now) {
117             require(msg.value >= 30 ether);
118         } else if (stage1Start < now && saleEnd > now) {
119             require(tokens >= 20);
120         } else {
121             revert();
122         }
123 
124         EtherTransfer(msg.sender, owner, msg.value);
125     }
126 
127 }