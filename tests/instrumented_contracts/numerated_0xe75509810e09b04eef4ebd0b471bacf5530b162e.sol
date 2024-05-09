1 /*
2  * Ownable
3  *
4  * Base contract with an owner.
5  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
6  */
7 contract Ownable {
8   address public owner;
9 
10   function Ownable() {
11     owner = msg.sender;
12   }
13 
14   modifier onlyOwner() {
15     if (msg.sender != owner) {
16       throw;
17     }
18     _;
19   }
20 
21   function transferOwnership(address newOwner) onlyOwner {
22     if (newOwner != address(0)) {
23       owner = newOwner;
24     }
25   }
26 
27 }
28 
29 
30 /*
31  * Haltable
32  *
33  * Abstract contract that allows children to implement an
34  * emergency stop mechanism. Differs from Pausable by causing a throw
35  * instead of return when in halt mode.
36  *
37  *
38  * Originally envisioned in FirstBlood ICO contract.
39  */
40 contract Haltable is Ownable {
41   bool public halted;
42 
43   modifier stopInEmergency {
44     if (halted) throw;
45     _;
46   }
47 
48   modifier onlyInEmergency {
49     if (!halted) throw;
50     _;
51   }
52 
53   // called by the owner on emergency, triggers stopped state
54   function halt() external onlyOwner {
55     halted = true;
56   }
57 
58   // called by the owner on end of emergency, returns to normal state
59   function unhalt() external onlyOwner onlyInEmergency {
60     halted = false;
61   }
62 
63 }
64 
65 
66 
67 /**
68  * Math operations with safety checks
69  */
70 contract SafeMath {
71   function safeMul(uint a, uint b) internal returns (uint) {
72     uint c = a * b;
73     assert(a == 0 || c / a == b);
74     return c;
75   }
76 
77   function safeDiv(uint a, uint b) internal returns (uint) {
78     assert(b > 0);
79     uint c = a / b;
80     assert(a == b * c + a % b);
81     return c;
82   }
83 
84   function safeSub(uint a, uint b) internal returns (uint) {
85     assert(b <= a);
86     return a - b;
87   }
88 
89   function safeAdd(uint a, uint b) internal returns (uint) {
90     uint c = a + b;
91     assert(c>=a && c>=b);
92     return c;
93   }
94 
95   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
96     return a >= b ? a : b;
97   }
98 
99   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
100     return a < b ? a : b;
101   }
102 
103   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
104     return a >= b ? a : b;
105   }
106 
107   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
108     return a < b ? a : b;
109   }
110 
111   function assert(bool assertion) internal {
112     if (!assertion) {
113       throw;
114     }
115   }
116 }
117 
118 
119 
120 /**
121  * Forward Ethereum payments to another wallet and track them with an event.
122  *
123  * Allows to identify customers who made Ethereum payment for a central token issuance.
124  * Furthermore allow making a payment on behalf of another address.
125  *
126  * Allow pausing to signal the end of the crowdsale.
127  */
128 contract PaymentForwarder is Haltable, SafeMath {
129 
130   /** Who will get all ETH in the end */
131   address public teamMultisig;
132 
133   /** Total incoming money */
134   uint public totalTransferred;
135 
136   /** How many distinct customers we have that have made a payment */
137   uint public customerCount;
138 
139   /** Total incoming money per centrally tracked customer id */
140   mapping(uint128 => uint) public paymentsByCustomer;
141 
142   /** Total incoming money per benefactor address */
143   mapping(address => uint) public paymentsByBenefactor;
144 
145   /** A customer has made a payment. Benefactor is the address where the tokens will be ultimately issued.*/
146   event PaymentForwarded(address source, uint amount, uint128 customerId, address benefactor);
147 
148   /**
149    * @param _teamMultisig Team multisig receives the deposited payments.
150    *
151    * @param _owner Owner is able to pause and resume crowdsale
152    */
153   function PaymentForwarder(address _owner, address _teamMultisig) {
154     teamMultisig = _teamMultisig;
155     owner = _owner;
156   }
157 
158   /**
159    * Pay on a behalf of an address.
160    *
161    * We log the payment event, so that the server can keep tally of the invested amounts
162    * and token receivers.
163    *
164    * The actual payment is forwarded to the team multisig.
165    *
166    * @param customerId Identifier in the central database, UUID v4 - this is used to note customer by email
167    *
168    */
169   function pay(uint128 customerId, address benefactor) public stopInEmergency payable {
170 
171     uint weiAmount = msg.value;
172 
173     if(weiAmount == 0) {
174       throw; // No invalid payments
175     }
176 
177     if(customerId == 0) {
178       throw; // We require to record customer id for the server side processing
179     }
180 
181     if(benefactor == 0) {
182       throw; // Bad payment address
183     }
184 
185     PaymentForwarded(msg.sender, weiAmount, customerId, benefactor);
186 
187     totalTransferred = safeAdd(totalTransferred, weiAmount);
188 
189     if(paymentsByCustomer[customerId] == 0) {
190       customerCount++;
191     }
192 
193     paymentsByCustomer[customerId] = safeAdd(paymentsByCustomer[customerId], weiAmount);
194 
195     // We track benefactor addresses for extra safety;
196     // In the case of central ETH issuance tracking has problems we can
197     // construct ETH contributions solely based on blockchain data
198     paymentsByBenefactor[benefactor] = safeAdd(paymentsByBenefactor[benefactor], weiAmount);
199 
200     // May run out of gas
201     if(!teamMultisig.send(weiAmount)) throw;
202   }
203 
204   /**
205    * Pay on a behalf of the sender.
206    *
207    * @param customerId Identifier in the central database, UUID v4
208    *
209    */
210   function payForMyself(uint128 customerId) public payable {
211     pay(customerId, msg.sender);
212   }
213 
214 }