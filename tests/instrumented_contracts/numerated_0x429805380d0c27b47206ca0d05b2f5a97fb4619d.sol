1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function balanceOf (address owner) public view returns (uint256);
5   function transfer (address to, uint256 value) public returns (bool);
6 }
7 
8 contract FSTSaleServiceWindowReferral {
9   using Math for uint256;
10 
11   address public owner;
12   address private rf = address(0);
13 
14   bytes32 private secretHash;
15   ERC20 public funderSmartToken;
16   Math.Fraction public fstPrice;
17 
18   uint256 public totalEtherReceived = 0;
19 
20   bool public isEnabled = true;
21   bool public finalized = false;
22 
23   event TokenPurchase(
24     ERC20 indexed token,
25     address indexed buyer,
26     address indexed receiver,
27     uint256 value,
28     uint256 amount
29   );
30   
31   event RFDeclare(address rf);
32   event Finalize(address receiver, address rf, uint256 fstkRevenue);
33 
34   constructor (
35     address _fstAddress,
36     bytes32 _secretHash
37   ) public {
38     owner = msg.sender;
39     secretHash = _secretHash;
40     funderSmartToken = ERC20(_fstAddress);
41     fstPrice.numerator = 1;
42     fstPrice.denominator = 3600;
43   }
44 
45   function () public payable {
46     uint256 available = funderSmartToken.balanceOf(address(this));
47     uint256 revenue;
48     uint256 purchaseAmount = msg.value.div(fstPrice);
49 
50     require(
51       isEnabled &&
52       finalized == false &&
53       available > 0 &&
54       purchaseAmount > 0
55     );
56 
57     if (available >= purchaseAmount) {
58       revenue = msg.value;
59     } else {
60       purchaseAmount = available;
61       revenue = available.mulCeil(fstPrice);
62       isEnabled = false;
63 
64       msg.sender.transfer(msg.value - revenue);
65     }
66 
67     funderSmartToken.transfer(msg.sender, purchaseAmount);
68 
69     emit TokenPurchase(funderSmartToken, msg.sender, msg.sender, revenue, purchaseAmount);
70     
71     totalEtherReceived += revenue;
72   }
73   
74   function declareRF(string _secret) public {
75     require(
76       secretHash == keccak256(abi.encodePacked(_secret)) &&
77       rf == address(0)
78     );
79 
80     rf = msg.sender;
81     
82     emit RFDeclare(rf);
83   }
84 
85   function finalize (address _receiver) public {
86     require(
87       msg.sender == owner &&
88       isEnabled == false &&
89       finalized == false &&
90       rf != address(0)
91     );
92 
93     finalized = true;
94 
95     // 15% referral
96     rf.transfer(address(this).balance * 15 / 100);
97     _receiver.transfer(address(this).balance);
98 
99     uint256 available = funderSmartToken.balanceOf(address(this));
100     if (available > 0) {
101       funderSmartToken.transfer(_receiver, available);
102     }
103 
104     emit Finalize(_receiver, rf, totalEtherReceived * 85 / 100);
105   }
106 
107   function setOwner (address _ownder) public {
108     require(msg.sender == owner);
109     owner = _ownder;
110   }
111 
112   function setFunderSmartToken(address _fstAddress) public {
113     require(msg.sender == owner);
114     funderSmartToken = ERC20(_fstAddress);
115   }
116 
117   function setFSTPrice(uint256 numerator, uint256 denominator) public {
118     require(msg.sender == owner);
119     require(
120       numerator > 0 &&
121       denominator > 0
122     );
123 
124     fstPrice.numerator = numerator;
125     fstPrice.denominator = denominator;
126   }
127 
128   function setEnabled (bool _isEnabled) public {
129     require(msg.sender == owner);
130     isEnabled = _isEnabled;
131   }
132 
133 }
134 
135 library Math {
136 
137   struct Fraction {
138     uint256 numerator;
139     uint256 denominator;
140   }
141 
142   function isPositive(Fraction memory fraction) internal pure returns (bool) {
143     return fraction.numerator > 0 && fraction.denominator > 0;
144   }
145 
146   function mul(uint256 a, uint256 b) internal pure returns (uint256 r) {
147     r = a * b;
148     require((a == 0) || (r / a == b));
149   }
150 
151   function div(uint256 a, uint256 b) internal pure returns (uint256 r) {
152     r = a / b;
153   }
154 
155   function sub(uint256 a, uint256 b) internal pure returns (uint256 r) {
156     require((r = a - b) <= a);
157   }
158 
159   function add(uint256 a, uint256 b) internal pure returns (uint256 r) {
160     require((r = a + b) >= a);
161   }
162 
163   function min(uint256 x, uint256 y) internal pure returns (uint256 r) {
164     return x <= y ? x : y;
165   }
166 
167   function max(uint256 x, uint256 y) internal pure returns (uint256 r) {
168     return x >= y ? x : y;
169   }
170 
171   function mulDiv(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
172     // try mul
173     r = value * m;
174     if (r / value == m) {
175       // if mul not overflow
176       r /= d;
177     } else {
178       // else div first
179       r = mul(value / d, m);
180     }
181   }
182 
183   function mulDivCeil(uint256 value, uint256 m, uint256 d) internal pure returns (uint256 r) {
184     // try mul
185     r = value * m;
186     if (r / value == m) {
187       // mul not overflow
188       if (r % d == 0) {
189         r /= d;
190       } else {
191         r = (r / d) + 1;
192       }
193     } else {
194       // mul overflow then div first
195       r = mul(value / d, m);
196       if (value % d != 0) {
197         r += 1;
198       }
199     }
200   }
201 
202   function mul(uint256 x, Fraction memory f) internal pure returns (uint256) {
203     return mulDiv(x, f.numerator, f.denominator);
204   }
205 
206   function mulCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
207     return mulDivCeil(x, f.numerator, f.denominator);
208   }
209 
210   function div(uint256 x, Fraction memory f) internal pure returns (uint256) {
211     return mulDiv(x, f.denominator, f.numerator);
212   }
213 
214   function divCeil(uint256 x, Fraction memory f) internal pure returns (uint256) {
215     return mulDivCeil(x, f.denominator, f.numerator);
216   }
217 
218   function mul(Fraction memory x, Fraction memory y) internal pure returns (Math.Fraction) {
219     return Math.Fraction({
220       numerator: mul(x.numerator, y.numerator),
221       denominator: mul(x.denominator, y.denominator)
222     });
223   }
224 }