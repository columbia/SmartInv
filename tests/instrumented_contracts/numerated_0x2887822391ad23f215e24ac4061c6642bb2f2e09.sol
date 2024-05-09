1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address public owner;
74 
75     /**
76      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77      * account.
78      */
79     constructor() public {
80         owner = msg.sender;
81     }
82 
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92 }
93 
94 /* Required code start */
95 contract MarketplaceProxy {
96     function calculatePlatformCommission(uint256 weiAmount) public view returns (uint256);
97     function payPlatformIncomingTransactionCommission(address clientAddress) public payable;
98     function payPlatformOutgoingTransactionCommission() public payable;
99     function isUserBlockedByContract(address contractAddress) public view returns (bool);
100 }
101 /* Required code end */
102 
103 contract Deposit is Ownable {
104 
105     using SafeMath for uint256;
106 
107     struct ClientDeposit {
108         uint256 balance;
109         // We should reject incoming transactions on payable 
110         // methods that not equals this variable
111         uint256 nextPaymentTotalAmount;
112         uint256 nextPaymentDepositCommission;   // deposit commission stored on contract
113         uint256 nextPaymentPlatformCommission;
114         bool exists;
115         bool isBlocked;
116     }
117     mapping(address => ClientDeposit) public depositsMap;
118 
119     /* Required code start */
120     MarketplaceProxy public mp;
121     event PlatformIncomingTransactionCommission(uint256 amount, address clientAddress);
122     event PlatformOutgoingTransactionCommission(uint256 amount);
123     event Blocked();
124     /* Required code end */
125     event DepositCommission(uint256 amount, address clientAddress);
126 
127     constructor () public {
128         /* Required code start */
129         // NOTE: CHANGE ADDRESS ON PRODUCTION
130         mp = MarketplaceProxy(0x17b38d3779debcf1079506522e10284d3c6b0fef);
131         /* Required code end */
132     }
133 
134     /**
135      * @dev Handles direct clients transactions
136      */
137     function () public payable {
138         handleIncomingPayment(msg.sender, msg.value);
139     }
140 
141     /**
142      * @dev Handles payment gateway transactions
143      * @param clientAddress when payment method is fiat money
144      */
145     function fromPaymentGateway(address clientAddress) public payable {
146         handleIncomingPayment(clientAddress, msg.value);
147     }
148 
149     /**
150      * @dev Send commission to marketplace and increases client balance
151      * @param clientAddress client wallet for deposit
152      * @param amount transaction value (msg.value)
153      */
154     function handleIncomingPayment(address clientAddress, uint256 amount) private {
155         ClientDeposit storage clientDeposit = depositsMap[clientAddress];
156 
157         require(clientDeposit.exists);
158         require(clientDeposit.nextPaymentTotalAmount == amount);
159 
160         /* Required code start */
161         // Send all incoming eth if user blocked
162         if (mp.isUserBlockedByContract(address(this))) {
163             mp.payPlatformIncomingTransactionCommission.value(amount)(clientAddress);
164             emit Blocked();
165         } else {
166             mp.payPlatformIncomingTransactionCommission.value(clientDeposit.nextPaymentPlatformCommission)(clientAddress);
167             emit PlatformIncomingTransactionCommission(clientDeposit.nextPaymentPlatformCommission, clientAddress);
168         }
169         /* Required code end */
170 
171         // Virtually add ETH to client deposit (sended ETH subtract platform and deposit commissions)
172         clientDeposit.balance += amount.sub(clientDeposit.nextPaymentPlatformCommission).sub(clientDeposit.nextPaymentDepositCommission);
173         emit DepositCommission(clientDeposit.nextPaymentDepositCommission, clientAddress);
174     }
175 
176     /**
177      * @dev Owner can add ETH to contract without commission
178      */
179     function addEth() public payable onlyOwner {
180 
181     }
182 
183     /**
184      * @dev Owner can transfer ETH from contract to address
185      * @param to address
186      * @param amount 18 decimals (wei)
187      */
188     function transferEthTo(address to, uint256 amount) public onlyOwner {
189         require(address(this).balance > amount);
190 
191         /* Required code start */
192         // Get commission amount from marketplace
193         uint256 commission = mp.calculatePlatformCommission(amount);
194 
195         require(address(this).balance > amount.add(commission));
196 
197         // Send commission to marketplace
198         mp.payPlatformOutgoingTransactionCommission.value(commission)();
199         emit PlatformOutgoingTransactionCommission(commission);
200         /* Required code end */
201 
202         to.transfer(amount);
203     }
204 
205     /**
206      * @dev Send client's balance to some address on claim
207      * @param from client address
208      * @param to send ETH on this address
209      * @param amount 18 decimals (wei)
210      */
211     function claim(address from, address to, uint256 amount) public onlyOwner{
212         require(depositsMap[from].exists);
213 
214         /* Required code start */
215         // Get commission amount from marketplace
216         uint256 commission = mp.calculatePlatformCommission(amount);
217 
218         require(address(this).balance > amount.add(commission));
219         require(depositsMap[from].balance > amount);
220 
221         // Send commission to marketplace
222         mp.payPlatformOutgoingTransactionCommission.value(commission)();
223         emit PlatformOutgoingTransactionCommission(commission);
224         /* Required code end */
225 
226         // Virtually subtract amount from client deposit
227         depositsMap[from].balance -= amount;
228 
229         to.transfer(amount);
230     }
231 
232     /**
233      * @return bool, client exist or not
234      */
235     function isClient(address clientAddress) public view onlyOwner returns(bool) {
236         return depositsMap[clientAddress].exists;
237     }
238 
239     /**
240      * @dev Add new client to structure
241      * @param clientAddress wallet
242      * @param _nextPaymentTotalAmount reject next incoming payable transaction if it's amount not equal to this variable
243      * @param _nextPaymentDepositCommission deposit commission stored on contract
244      * @param _nextPaymentPlatformCommission marketplace commission to send
245      */
246     function addClient(address clientAddress, uint256 _nextPaymentTotalAmount, uint256 _nextPaymentDepositCommission, uint256 _nextPaymentPlatformCommission) public onlyOwner {
247         require( (clientAddress != address(0)));
248 
249         // Can be called only once for address
250         require(!depositsMap[clientAddress].exists);
251 
252         // Add new element to structure
253         depositsMap[clientAddress] = ClientDeposit(
254             0,                                  // balance
255             _nextPaymentTotalAmount,            // nextPaymentTotalAmount
256             _nextPaymentDepositCommission,      // nextPaymentDepositCommission
257             _nextPaymentPlatformCommission,     // nextPaymentPlatformCommission
258             true,                               // exists
259             false                               // isBlocked
260         );
261     }
262 
263     /**
264      * @return uint256 client balance
265      */
266     function getClientBalance(address clientAddress) public view returns(uint256) {
267         return depositsMap[clientAddress].balance;
268     }
269 
270     /**
271      * @dev Update client payment details
272      * @param clientAddress wallet
273      * @param _nextPaymentTotalAmount reject next incoming payable transaction if it's amount not equal to this variable
274      * @param _nextPaymentDepositCommission deposit commission stored on contract
275      * @param _nextPaymentPlatformCommission marketplace commission to send
276      */
277     function repeatedPayment(address clientAddress, uint256 _nextPaymentTotalAmount, uint256 _nextPaymentDepositCommission, uint256 _nextPaymentPlatformCommission) public onlyOwner {
278         ClientDeposit storage clientDeposit = depositsMap[clientAddress];
279 
280         require(clientAddress != address(0));
281         require(clientDeposit.exists);
282 
283         clientDeposit.nextPaymentTotalAmount = _nextPaymentTotalAmount;
284         clientDeposit.nextPaymentDepositCommission = _nextPaymentDepositCommission;
285         clientDeposit.nextPaymentPlatformCommission = _nextPaymentPlatformCommission;
286     }
287 }