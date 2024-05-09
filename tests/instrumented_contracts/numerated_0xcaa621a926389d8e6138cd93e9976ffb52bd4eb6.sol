1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8 
9   function mul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal returns (uint) {
16     return a / b;
17   }
18 
19   function sub(uint a, uint b) internal returns (uint) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint a, uint b) internal returns (uint) {
25     uint c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46   function assertTrue(bool val) internal {
47     assert(val);
48   }
49 
50   function assertFalse(bool val) internal {
51     assert(!val);
52   }
53 }
54 
55 
56 /*
57  * Ownable
58  *
59  * Base contract with an owner.
60  *
61  * Provides onlyOwner modifier, which prevents function from running
62  * if it is called by anyone other than the owner.
63  */
64 contract Ownable {
65 
66   address public owner;
67 
68   function Ownable() {
69     owner = msg.sender;
70   }
71 
72   modifier onlyOwner() {
73     if (msg.sender != owner) {
74       revert();
75     }
76     _;
77   }
78 
79   function transferOwnership(address newOwner) onlyOwner {
80     if (newOwner != address(0)) {
81       owner = newOwner;
82     }
83   }
84 }
85 
86 
87 /*
88  * Haltable
89  *
90  * Abstract contract that allows children to implement a halt mechanism.
91  */
92 contract Haltable is Ownable {
93 
94   bool public halted;
95 
96   modifier revertIfHalted {
97     if (halted) revert();
98     _;
99   }
100 
101   modifier onlyIfHalted {
102     if (!halted) revert();
103     _;
104   }
105 
106   function halt() external onlyOwner {
107     halted = true;
108   }
109 
110   function unhalt() external onlyOwner onlyIfHalted {
111     halted = false;
112   }
113 }
114 
115 
116 /**
117  * Forward ETH payments associated with the Provide (PRVD)
118  * token sale and track them with an event.
119  *
120  * Associates purchasers who made payment for token issuance with an identifier.
121  * Enables the ability to make a purchase on behalf of another address.
122  *
123  * Allows the sale to be halted upon completion.
124  */
125 contract ProvideSale is Haltable {
126   using SafeMath for uint;
127 
128   /** Multisig to which all ETH is forwarded. */
129   address public multisig;
130 
131   /** Total ETH raised (in wei). */
132   uint public totalTransferred;
133 
134   /** Total number of distinct purchasers. */
135   uint public purchaserCount;
136 
137   /** Total incoming ETH (in wei) per centrally tracked purchaser. */
138   mapping (uint128 => uint) public paymentsByPurchaser;
139 
140   /** Total incoming ETH (in wei) per benefactor address. */
141   mapping (address => uint) public paymentsByBenefactor;
142 
143   /** Emitted when a purchase is made; benefactor is the address where the tokens will be ultimately issued. */
144   event PaymentForwarded(address source, uint amount, uint128 identifier, address benefactor);
145 
146   /**
147    * @param _owner Owner is able to pause and resume crowdsale
148    * @param _multisig Multisig to which all ETH is forwarded
149    */
150   function ProvideSale(address _owner, address _multisig) {
151     owner = _owner;
152     multisig = _multisig;
153   }
154 
155   /**
156    * Purchase on a behalf of a benefactor.
157    *
158    * The payment event is logged so interested parties can keep tally of the invested amounts
159    * and token recipients.
160    *
161    * The actual payment is forwarded to the multisig.
162    *
163    * @param identifier Identifier in the centralized database - UUID v4
164    * @param benefactor Address who will receive the tokens
165    */
166   function purchaseFor(uint128 identifier, address benefactor) public revertIfHalted payable {
167     uint weiAmount = msg.value;
168 
169     if (weiAmount == 0) {
170       revert(); // no invalid payments
171     }
172 
173     if (benefactor == 0) {
174       revert(); // bad payment address
175     }
176 
177     PaymentForwarded(msg.sender, weiAmount, identifier, benefactor);
178 
179     totalTransferred = totalTransferred.add(weiAmount);
180 
181     if (paymentsByPurchaser[identifier] == 0) {
182       purchaserCount++;
183     }
184 
185     paymentsByPurchaser[identifier] = paymentsByPurchaser[identifier].add(weiAmount);
186     paymentsByBenefactor[benefactor] = paymentsByBenefactor[benefactor].add(weiAmount);
187 
188     if (!multisig.send(weiAmount)) revert(); // may run out of gas
189   }
190 
191   /**
192    * Purchase on a behalf of the sender.
193    *
194    * @param identifier Identifier of the purchaser - UUID v4
195    */
196   function purchase(uint128 identifier) public payable {
197     purchaseFor(identifier, msg.sender);
198   }
199 
200   /**
201    * Purchase on a behalf of the sender, but uses a nil identifier.
202    */
203   function() public payable {
204     purchase(0);
205   }
206 }