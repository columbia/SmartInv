1 pragma solidity 0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  *  @title TokenSale
35  *  @dev Martin Halford, CTO, BlockGrain (AgriChain Pty Ltd) - April 2018
36  */
37 contract TokenSale {
38   using SafeMath for uint256;
39 
40   // Address of owner
41   address public owner;
42 
43   // Address where funds are collected
44   address public wallet;
45 
46   // Amount of raised (in Wei)
47   uint256 public amountRaised;
48 
49   // Upper limit of the amount to be collected
50   uint256 public saleLimit = 25000 ether;
51 
52   // Minimum contribution permitted
53   uint256 public minContribution = 0.5 ether;
54 
55   // Maximum contribution permitted
56   uint256 public maxContribution = 500 ether;
57 
58   // Flag to accept or reject payments
59   bool public isAcceptingPayments;
60 
61   // List of admins who can edit the whitelist
62   mapping (address => bool) public tokenSaleAdmins;
63 
64   // List of addresses that are whitelisted for private sale
65   mapping (address => bool) public whitelist;
66 
67   // List of addresses that have made payments (in Wei)
68   mapping (address => uint256) public amountPaid;
69 
70   // modifier to check owner
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   // modifier to check whitelist admin status
77   modifier onlyAdmin() {
78     require(tokenSaleAdmins[msg.sender]);
79     _;
80   }
81 
82   // modifier to check if whitelisted address
83   modifier isWhitelisted() {
84     require(whitelist[msg.sender]);
85     _;
86   }
87 
88   // modifier to check if payments being accepted
89   modifier acceptingPayments() {
90     require(isAcceptingPayments);
91     _;
92   }
93 
94   /**
95    * Constructor
96    * @param _wallet Address where collected funds will be forwarded to
97    */
98   constructor(address _wallet) public {
99     require(_wallet != address(0));
100     owner = msg.sender;
101     wallet = _wallet;
102     tokenSaleAdmins[msg.sender] = true;
103   }
104 
105   /**
106    * @dev fallback function
107    */
108   function () isWhitelisted acceptingPayments payable public {
109     uint256 _contribution = msg.value;
110     require(_contribution >= minContribution);
111     require(_contribution <= maxContribution);
112     require(msg.sender != address(0));
113 
114     // add to sender's amountPaid record
115     amountPaid[msg.sender] += _contribution;
116 
117     // add to amount raised
118     amountRaised = amountRaised.add(_contribution);
119 
120     // handle edge case where amountRaised exceeds saleLimit
121     if (amountRaised > saleLimit) {
122       uint256 _refundAmount = amountRaised.sub(saleLimit);
123       msg.sender.transfer(_refundAmount);
124       _contribution = _contribution.sub(_refundAmount);
125       _refundAmount = 0;
126       amountRaised = saleLimit;
127       isAcceptingPayments = false;
128     }
129 
130     // transfer funds to external wallet
131     wallet.transfer(_contribution);
132   }
133 
134   /**
135    * @dev Start accepting payments
136    */
137   function acceptPayments() onlyAdmin public  {
138     isAcceptingPayments = true;
139   }
140 
141   /**
142    * @dev Stop accepting payments
143    */
144   function rejectPayments() onlyAdmin public  {
145     isAcceptingPayments = false;
146   }
147 
148   /**
149    *  @dev Add a user to the whitelist admins
150    */
151   function addAdmin(address _admin) onlyOwner public {
152     tokenSaleAdmins[_admin] = true;
153   }
154 
155   /**
156    *  @dev Remove a user from the whitelist admins
157    */
158   function removeAdmin(address _admin) onlyOwner public {
159     tokenSaleAdmins[_admin] = false;
160   }
161 
162   /**
163    * @dev Add an address to the whitelist
164    * @param _contributor The address of the contributor
165    */
166   function whitelistAddress(address _contributor) onlyAdmin public  {
167     whitelist[_contributor] = true;
168   }
169 
170   /**
171    * @dev Add multiple addresses to the whitelist
172    * @param _contributors The addresses of the contributor
173    */
174   function whitelistAddresses(address[] _contributors) onlyAdmin public {
175     for (uint256 i = 0; i < _contributors.length; i++) {
176       whitelist[_contributors[i]] = true;
177     }
178   }
179 
180   /**
181    * @dev Remove an addresses from the whitelist
182    * @param _contributor The addresses of the contributor
183    */
184   function unWhitelistAddress(address _contributor) onlyAdmin public  {
185     whitelist[_contributor] = false;
186   }
187 
188   /**
189    * @dev Remove multiple addresses from the whitelist
190    * @param _contributors The addresses of the contributor
191    */
192   function unWhitelistAddresses(address[] _contributors) onlyAdmin public {
193     for (uint256 i = 0; i < _contributors.length; i++) {
194       whitelist[_contributors[i]] = false;
195     }
196   }
197 
198   /**
199    * @dev Update the sale limit
200    * @param _saleLimit The updated sale limit value
201    */
202   function updateSaleLimit(uint256 _saleLimit) onlyAdmin public {
203     saleLimit = _saleLimit;
204   }
205 
206   /**
207     * @dev Update the minimum contribution
208     * @param _minContribution The updated minimum contribution value
209     */
210   function updateMinContribution(uint256 _minContribution) onlyAdmin public {
211     minContribution = _minContribution;
212   }
213 
214   /**
215     * @dev Update the maximum contribution
216     * @param _maxContribution The updated maximum contribution value
217     */
218   function updateMaxContribution(uint256 _maxContribution) onlyAdmin public {
219     maxContribution = _maxContribution;
220   }
221 
222 }