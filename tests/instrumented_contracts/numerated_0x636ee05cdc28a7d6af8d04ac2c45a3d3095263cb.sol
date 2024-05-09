1 pragma solidity 0.4.24;
2           
3           //------ busniness plan ------
4 
5 
6         // Cyber trust.money business plan
7         // Packages
8         // S.No	Packages	Levels
9         // 1	0.22 eth	 Pool-1
10         // 2	0.50 eth	Pool-2
11         // 3	1.00 eth	Pool-3
12         // 4	3.00 eth	Pool-4
13         // 5	5.00 eth	Pool-5
14         
15         // Pool-1
16         // Level	Member	ETH	Income
17         // 1	3	0.01	0.03
18         // 2	9	0.01	0.09
19         // 3	27	0.01	0.27
20         // 4	81	0.01	0.81
21         // 5	243	0.01	2.43
22         // 6	729	0.01	7.29
23         // 7	2187	0.01	21.87
24         // 8	6567	0.01	65.61
25         // 9	19683	0.01	196.83
26         // 10	59049	0.01	590.49
27         
28         // Pool-2
29         // Level	Member	ETH	Income
30         // 1	3	0.03	0.9
31         // 2	9	0.03	0.27
32         // 3	27	0.03	0.81
33         // 4	81	0.03	2.43
34         // 5	243	0.03	7.29
35         // 6	729	0.03	21.87
36         // 7	2187	0.03	65.61
37         // 8	6567	0.03	196.83
38         // 9	19683	0.03	590.49
39         // 10	59049	0.03	1771.47
40         
41         
42         
43         
44         // Pool-3
45         // Level	Member	ETH	Income
46         // 1	3	0.06	0.18
47         // 2	9	0.06	0.54
48         // 3	27	0.06	1.62
49         // 4	81	0.06	4.86
50         // 5	243	0.06	14.58
51         // 6	729	 0.06 43.74
52         // 7	2187	0.06	131.22
53         // 8	6567	0.06	393.66
54         // 9	19683	0.06	1180.98
55         // 10	59049	0.06	3542.94
56         // Pool-4
57         // Level	Member	ETH	Income
58         // 1	3	0.18	0.54
59         // 2	9	0.18	1.62
60         // 3	27	0.18	4.86
61         // 4	81	0.18	14.58
62         // 5	243	0.18	43.74
63         // 6	729	0.18	131.22
64         // 7	2187	0.18	393.66
65         // 8	6567	0.18	1180.98
66         // 9	19683	0.18	3542.94
67         // 10	59049	0.18	10628.82
68         
69         // Pool-5
70         // Level	Member	ETH	Income
71         // 1	3	0.30	0.9
72         // 2	9	0.30	2.7
73         // 3	27	0.30	8.1
74         // 4	81	0.30	24.3
75         // 5	243	0.30	72.9
76         // 6	729	0.30	218.7
77         // 7	2187	0.30	656.1
78         // 8	6567	0.30	1968.3
79         // 9	19683	0.30	5904.9
80         // 10	59049	0.30	17714.7
81         			
82         
83         
84         // Direct sponcer income
85         // Pool one sponser income 0.10
86         // Pool Two sponcer income 0.15
87         // Pool three sponcer income 0.30
88         // Pool four sponser income 0.90
89         // Pool five sponcer income 1.50
90         // Company maintenance
91         
92         // Pool 1   0.02
93         
94         // Pool 2    0.05
95         
96         // Pool 3    0.10
97         
98         // Pool 4    0.30
99         
100         // Pool 5     0.50
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     if (a == 0) {
112       return 0;
113     }
114     uint256 c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   /**
120   * @dev Integer division of two numbers, truncating the quotient.
121   */
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return c;
127   }
128 
129   /**
130   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131   */
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   /**
138   * @dev Adds two numbers, throws on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a); 
143     return c;
144   }
145 }
146 contract CyberTrustMoney {
147     event Multisended(uint256 value , address sender);
148     using SafeMath for uint256;
149 
150     function multisendEther(address[] _contributors, uint256[] _balances) public payable {
151         uint256 total = msg.value;
152         uint256 i = 0;
153         for (i; i < _contributors.length; i++) {
154             require(total >= _balances[i] );
155             total = total.sub(_balances[i]);
156             _contributors[i].transfer(_balances[i]);
157         }
158         emit Multisended(msg.value, msg.sender);
159     }
160 }