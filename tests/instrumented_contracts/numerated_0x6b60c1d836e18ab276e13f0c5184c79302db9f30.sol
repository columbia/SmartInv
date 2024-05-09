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
121     event PlatformIncomingTransactionCommission(uint256 amount, address indexed clientAddress);
122     event PlatformOutgoingTransactionCommission(uint256 amount);
123     event Blocked();
124     /* Required code end */
125     event MerchantIncomingTransactionCommission(uint256 amount, address indexed clientAddress);
126     event DepositCommission(uint256 amount, address clientAddress);
127 
128     constructor () public {
129         /* Required code start */
130         // NOTE: CHANGE ADDRESS ON PRODUCTION
131         mp = MarketplaceProxy(0x17b38d3779dEBcF1079506522E10284D3c6b0FEf);
132         /* Required code end */
133     }
134 
135     /**
136      * @dev Handles direct clients transactions
137      */
138     function () public payable {
139         handleIncomingPayment(msg.sender, msg.value);
140     }
141 
142     /**
143      * @dev Handles payment gateway transactions
144      * @param clientAddress when payment method is fiat money
145      */
146     function fromPaymentGateway(address clientAddress) public payable {
147         handleIncomingPayment(clientAddress, msg.value);
148     }
149 
150     /**
151      * @dev Send commission to marketplace and increases client balance
152      * @param clientAddress client wallet for deposit
153      * @param amount transaction value (msg.value)
154      */
155     function handleIncomingPayment(address clientAddress, uint256 amount) private {
156         ClientDeposit storage clientDeposit = depositsMap[clientAddress];
157 
158         require(clientDeposit.exists);
159         require(clientDeposit.nextPaymentTotalAmount == amount);
160 
161         /* Required code start */
162         // Send all incoming eth if user blocked
163         if (mp.isUserBlockedByContract(address(this))) {
164             mp.payPlatformIncomingTransactionCommission.value(amount)(clientAddress);
165             emit Blocked();
166         } else {
167             owner.transfer(clientDeposit.nextPaymentDepositCommission);
168             emit MerchantIncomingTransactionCommission(clientDeposit.nextPaymentDepositCommission, clientAddress);
169             mp.payPlatformIncomingTransactionCommission.value(clientDeposit.nextPaymentPlatformCommission)(clientAddress);
170             emit PlatformIncomingTransactionCommission(clientDeposit.nextPaymentPlatformCommission, clientAddress);
171         }
172         /* Required code end */
173 
174         // Virtually add ETH to client deposit (sended ETH subtract platform and deposit commissions)
175         clientDeposit.balance += amount.sub(clientDeposit.nextPaymentPlatformCommission).sub(clientDeposit.nextPaymentDepositCommission);
176         emit DepositCommission(clientDeposit.nextPaymentDepositCommission, clientAddress);
177     }
178 
179     /**
180      * @dev Owner can add ETH to contract without commission
181      */
182     function addEth() public payable onlyOwner {
183 
184     }
185 
186     /**
187      * @dev Send client's balance to some address on claim
188      * @param from client address
189      * @param to send ETH on this address
190      * @param amount 18 decimals (wei)
191      */
192     function claim(address from, address to, uint256 amount) public onlyOwner{
193         require(depositsMap[from].exists);
194 
195         /* Required code start */
196         // Get commission amount from marketplace
197         uint256 commission = mp.calculatePlatformCommission(amount);
198 
199         require(address(this).balance > amount.add(commission));
200         require(depositsMap[from].balance >= amount);
201 
202         // Send commission to marketplace
203         mp.payPlatformOutgoingTransactionCommission.value(commission)();
204         emit PlatformOutgoingTransactionCommission(commission);
205         /* Required code end */
206 
207         // Virtually subtract amount from client deposit
208         depositsMap[from].balance -= amount;
209 
210         to.transfer(amount);
211     }
212 
213     /**
214      * @return bool, client exist or not
215      */
216     function isClient(address clientAddress) public view onlyOwner returns(bool) {
217         return depositsMap[clientAddress].exists;
218     }
219 
220     /**
221      * @dev Add new client to structure
222      * @param clientAddress wallet
223      * @param _nextPaymentTotalAmount reject next incoming payable transaction if it's amount not equal to this variable
224      * @param _nextPaymentDepositCommission deposit commission stored on contract
225      * @param _nextPaymentPlatformCommission marketplace commission to send
226      */
227     function addClient(address clientAddress, uint256 _nextPaymentTotalAmount, uint256 _nextPaymentDepositCommission, uint256 _nextPaymentPlatformCommission) public onlyOwner {
228         require( (clientAddress != address(0)));
229 
230         // Can be called only once for address
231         require(!depositsMap[clientAddress].exists);
232 
233         // Add new element to structure
234         depositsMap[clientAddress] = ClientDeposit(
235             0,                                  // balance
236             _nextPaymentTotalAmount,            // nextPaymentTotalAmount
237             _nextPaymentDepositCommission,      // nextPaymentDepositCommission
238             _nextPaymentPlatformCommission,     // nextPaymentPlatformCommission
239             true,                               // exists
240             false                               // isBlocked
241         );
242     }
243 
244     /**
245      * @return uint256 client balance
246      */
247     function getClientBalance(address clientAddress) public view returns(uint256) {
248         return depositsMap[clientAddress].balance;
249     }
250 
251     /**
252      * @dev Update client payment details
253      * @param clientAddress wallet
254      * @param _nextPaymentTotalAmount reject next incoming payable transaction if it's amount not equal to this variable
255      * @param _nextPaymentDepositCommission deposit commission stored on contract
256      * @param _nextPaymentPlatformCommission marketplace commission to send
257      */
258     function repeatedPayment(address clientAddress, uint256 _nextPaymentTotalAmount, uint256 _nextPaymentDepositCommission, uint256 _nextPaymentPlatformCommission) public onlyOwner {
259         ClientDeposit storage clientDeposit = depositsMap[clientAddress];
260 
261         require(clientAddress != address(0));
262         require(clientDeposit.exists);
263 
264         clientDeposit.nextPaymentTotalAmount = _nextPaymentTotalAmount;
265         clientDeposit.nextPaymentDepositCommission = _nextPaymentDepositCommission;
266         clientDeposit.nextPaymentPlatformCommission = _nextPaymentPlatformCommission;
267     }
268 }