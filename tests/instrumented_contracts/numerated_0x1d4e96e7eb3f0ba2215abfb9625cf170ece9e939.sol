1 pragma solidity 0.4.24;
2 
3 // File: node_modules/@tokenfoundry/sale-contracts/contracts/interfaces/VaultI.sol
4 
5 interface VaultI {
6     function deposit(address contributor) external payable;
7     function saleSuccessful() external;
8     function enableRefunds() external;
9     function refund(address contributor) external;
10     function close() external;
11     function sendFundsToWallet() external;
12 }
13 
14 // File: openzeppelin-solidity/contracts/math/Math.sol
15 
16 /**
17  * @title Math
18  * @dev Assorted math operations
19  */
20 library Math {
21   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
22     return a >= b ? a : b;
23   }
24 
25   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
26     return a < b ? a : b;
27   }
28 
29   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
30     return a >= b ? a : b;
31   }
32 
33   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
34     return a < b ? a : b;
35   }
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
91 
92 /**
93  * @title Ownable
94  * @dev The Ownable contract has an owner address, and provides basic authorization control
95  * functions, this simplifies the implementation of "user permissions".
96  */
97 contract Ownable {
98   address public owner;
99 
100 
101   event OwnershipRenounced(address indexed previousOwner);
102   event OwnershipTransferred(
103     address indexed previousOwner,
104     address indexed newOwner
105   );
106 
107 
108   /**
109    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
110    * account.
111    */
112   constructor() public {
113     owner = msg.sender;
114   }
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124   /**
125    * @dev Allows the current owner to relinquish control of the contract.
126    */
127   function renounceOwnership() public onlyOwner {
128     emit OwnershipRenounced(owner);
129     owner = address(0);
130   }
131 
132   /**
133    * @dev Allows the current owner to transfer control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function transferOwnership(address _newOwner) public onlyOwner {
137     _transferOwnership(_newOwner);
138   }
139 
140   /**
141    * @dev Transfers control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function _transferOwnership(address _newOwner) internal {
145     require(_newOwner != address(0));
146     emit OwnershipTransferred(owner, _newOwner);
147     owner = _newOwner;
148   }
149 }
150 
151 // File: node_modules/@tokenfoundry/sale-contracts/contracts/Vault.sol
152 
153 // Adapted from Open Zeppelin's RefundVault
154 
155 /**
156  * @title Vault
157  * @dev This contract is used for storing funds while a crowdsale
158  * is in progress. Supports refunding the money if crowdsale fails,
159  * and forwarding it if crowdsale is successful.
160  */
161 contract Vault is VaultI, Ownable {
162     using SafeMath for uint256;
163 
164     enum State { Active, Success, Refunding, Closed }
165 
166     // The timestamp of the first deposit
167     uint256 public firstDepositTimestamp; 
168 
169     mapping (address => uint256) public deposited;
170 
171     // The amount to be disbursed to the wallet every month
172     uint256 public disbursementWei;
173     uint256 public disbursementDuration;
174 
175     // Wallet from the project team
176     address public trustedWallet;
177 
178     // The eth amount the team will get initially if the sale is successful
179     uint256 public initialWei;
180 
181     // Timestamp that has to pass before sending funds to the wallet
182     uint256 public nextDisbursement;
183     
184     // Total amount that was deposited
185     uint256 public totalDeposited;
186 
187     // Amount that can be refunded
188     uint256 public refundable;
189 
190     State public state;
191 
192     event Closed();
193     event RefundsEnabled();
194     event Refunded(address indexed contributor, uint256 amount);
195 
196     modifier atState(State _state) {
197         require(state == _state);
198         _;
199     }
200 
201     constructor (
202         address _wallet,
203         uint256 _initialWei,
204         uint256 _disbursementWei,
205         uint256 _disbursementDuration
206     ) 
207         public 
208     {
209         require(_wallet != address(0));
210         require(_disbursementWei != 0);
211         trustedWallet = _wallet;
212         initialWei = _initialWei;
213         disbursementWei = _disbursementWei;
214         disbursementDuration = _disbursementDuration;
215         state = State.Active;
216     }
217 
218     /// @dev Called by the sale contract to deposit ether for a contributor.
219     function deposit(address _contributor) onlyOwner external payable {
220         require(state == State.Active || state == State.Success);
221         if (firstDepositTimestamp == 0) {
222             firstDepositTimestamp = now;
223         }
224         totalDeposited = totalDeposited.add(msg.value);
225         deposited[_contributor] = deposited[_contributor].add(msg.value);
226     }
227 
228     /// @dev Sends initial funds to the wallet.
229     function saleSuccessful()
230         onlyOwner 
231         external 
232         atState(State.Active)
233     {
234         state = State.Success;
235         transferToWallet(initialWei);
236     }
237 
238     /// @dev Called by the owner if the project didn't deliver the testnet contracts or if we need to stop disbursements for any reasone.
239     function enableRefunds() onlyOwner external {
240         require(state != State.Refunding);
241         state = State.Refunding;
242         uint256 currentBalance = address(this).balance;
243         refundable = currentBalance <= totalDeposited ? currentBalance : totalDeposited;
244         emit RefundsEnabled();
245     }
246 
247     /// @dev Refunds ether to the contributors if in the Refunding state.
248     function refund(address _contributor) external atState(State.Refunding) {
249         require(deposited[_contributor] > 0);
250         uint256 refundAmount = deposited[_contributor].mul(refundable).div(totalDeposited);
251         deposited[_contributor] = 0;
252         _contributor.transfer(refundAmount);
253         emit Refunded(_contributor, refundAmount);
254     }
255 
256     /// @dev Called by the owner if the sale has ended.
257     function close() external atState(State.Success) onlyOwner {
258         state = State.Closed;
259         nextDisbursement = now;
260         emit Closed();
261     }
262 
263     /// @dev Sends the disbursement amount to the wallet after the disbursement period has passed. Can be called by anyone.
264     function sendFundsToWallet() external atState(State.Closed) {
265         require(nextDisbursement <= now);
266 
267         if (disbursementDuration == 0) {
268             trustedWallet.transfer(address(this).balance);
269             return;
270         }
271 
272         uint256 numberOfDisbursements = now.sub(nextDisbursement).div(disbursementDuration).add(1);
273 
274         nextDisbursement = nextDisbursement.add(disbursementDuration.mul(numberOfDisbursements));
275 
276         transferToWallet(disbursementWei.mul(numberOfDisbursements));
277     }
278 
279     function transferToWallet(uint256 _amount) internal {
280         uint256 amountToSend = Math.min256(_amount, address(this).balance);
281         trustedWallet.transfer(amountToSend);
282     }
283 }