1 pragma solidity 0.4.21;
2 
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 is ERC20Basic {
26   function allowance(address owner, address spender) public view returns (uint256);
27   function transferFrom(address from, address to, uint256 value) public returns (bool);
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 
33 
34 /**
35  * @title SafeERC20
36  * @dev Wrappers around ERC20 operations that throw on failure.
37  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
38  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
39  */
40 library SafeERC20 {
41   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
42     assert(token.transfer(to, value));
43   }
44 
45   function safeTransferFrom(
46     ERC20 token,
47     address from,
48     address to,
49     uint256 value)
50     internal
51   {
52     assert(token.transferFrom(from, to, value));
53   }
54 
55   function safeApprove(ERC20 token, address spender, uint256 value) internal {
56     assert(token.approve(spender, value));
57   }
58 }
59 
60 
61 
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83   /**
84    * @dev Throws if called by any account other than the owner.
85    */
86   modifier onlyOwner() {
87     require(msg.sender == owner);
88     _;
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     emit OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 
104 
105 
106 /**
107  * @title Contracts that should be able to recover tokens
108  * @author SylTi
109  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
110  * This will prevent any accidental loss of tokens.
111  */
112 contract CanReclaimToken is Ownable {
113   using SafeERC20 for ERC20Basic;
114 
115   /**
116    * @dev Reclaim all ERC20Basic compatible tokens
117    * @param token ERC20Basic The address of the token contract
118    */
119   function reclaimToken(ERC20Basic token) external onlyOwner {
120     uint256 balance = token.balanceOf(this);
121     token.safeTransfer(owner, balance);
122   }
123 
124 }
125 
126 
127 
128 
129 /**
130  * @title SafeMath
131  * @dev Math operations with safety checks that throw on error
132  */
133 library SafeMath {
134 
135   /**
136   * @dev Multiplies two numbers, throws on overflow.
137   */
138   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139     if (a == 0) {
140       return 0;
141     }
142     uint256 c = a * b;
143     assert(c / a == b);
144     return c;
145   }
146 
147   /**
148   * @dev Integer division of two numbers, truncating the quotient.
149   */
150   function div(uint256 a, uint256 b) internal pure returns (uint256) {
151     // assert(b > 0); // Solidity automatically throws when dividing by 0
152     uint256 c = a / b;
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154     return c;
155   }
156 
157   /**
158   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
159   */
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     assert(b <= a);
162     return a - b;
163   }
164 
165   /**
166   * @dev Adds two numbers, throws on overflow.
167   */
168   function add(uint256 a, uint256 b) internal pure returns (uint256) {
169     uint256 c = a + b;
170     assert(c >= a);
171     return c;
172   }
173 }
174 
175 
176 
177 /// @dev Right now, the Biddable application is responsible for being the arbitrator to all escrows.
178 ///  This means, the Biddable application has to enforce boundaries such that auction houses can
179 ///  only release escrows for users on their platform. This is done via the shared secret that is
180 ///  provisioned for each platform that onboards with the service.
181 contract BiddableEscrow is CanReclaimToken {
182 
183   using SafeMath for uint256;
184 
185   // Mapping of escrows. Key is a UUID generated by Biddable
186   mapping (string => EscrowDeposit) private escrows;
187 
188   // The arbitrator that is responsible for releasing escrow.
189   // At this time this is the Biddable service.
190   // This should be separate key than the one used for the creation of the contract.
191   address public arbitrator;
192 
193   // Gas fees that have accumulated in this contract to reimburse the arbitrator
194   // for paying fees for releasing escrow. These are stored locally to avoid having to
195   // pay additional gas costs for transfer during each release.
196   uint256 public accumulatedGasFees;
197 
198   struct EscrowDeposit {
199     // Used to avoid collisions
200     bool exists;
201 
202     // Address of the bidder
203     address bidder;
204 
205     // Encrypted data of the escrow
206     // This is the ownership data of the escrow in the context of the auction house platform
207     // It holds the platformId, auctionId, and the userId on the platform
208     bytes data;
209 
210     // The amount in the escrow
211     uint256 amount;
212   }
213 
214   modifier onlyArbitrator() {
215     require(msg.sender == arbitrator);
216     _;
217   }
218 
219   /// @dev Constructor for the smart contract
220   /// @param _arbitrator Address for an arbitrator that is responsible for signing the transaction data
221   function BiddableEscrow(address _arbitrator) public {
222     arbitrator = _arbitrator;
223     accumulatedGasFees = 0;
224   }
225 
226   /// @notice Sets a new arbitrator. Only callable by the owner
227   /// @param _newArbitrator Address for the new arbitrator
228   function setArbitrator(address _newArbitrator) external onlyOwner {
229     arbitrator = _newArbitrator;
230   }
231 
232   /// @dev This event is emitted when funds have been deposited into a new escrow.
233   ///  The data is an encrypted blob that contains the user's userId so that the
234   ///  Biddable service can tell the calling platform which user to approve for bidding.
235   event Created(address indexed sender, string id, bytes data);
236 
237   /// @notice Deposit ether into escrow. The data must be signed by the Biddable service.
238   /// @dev We don't use an 'onlyArbitrator' modifier because the transaction itself is sent by the bidder,
239   ///  but the data must be signed by the Biddable service. Thus, the function must be available to call
240   ///  by anyone.
241   /// @param _id Is the unique identifier of the escrow
242   /// @param _depositAmount The deposit required to be in escrow for approval
243   /// @param _data The encrypted deposit data
244   /// @param _v Recovery number
245   /// @param _r First part of the signature
246   /// @param _s Second part of the signature
247   function deposit(
248     string _id,
249     uint256 _depositAmount,
250     bytes _data,
251     uint8 _v,
252     bytes32 _r,
253     bytes32 _s)
254     external payable
255   {
256     // Throw if the amount sent doesn't mean the deposit amount
257     require(msg.value == _depositAmount);
258 
259     // Throw if a deposit with this id already exists
260     require(!escrows[_id].exists);
261 
262     bytes32 hash = keccak256(_id, _depositAmount, _data);
263     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
264 
265     address recoveredAddress = ecrecover(
266       keccak256(prefix, hash),
267       _v,
268       _r,
269       _s
270     );
271 
272     // Throw if the signature wasn't created by the arbitrator
273     require(recoveredAddress == arbitrator);
274 
275     escrows[_id] = EscrowDeposit(
276       true,
277       msg.sender,
278       _data,
279       msg.value);
280 
281     emit Created(msg.sender, _id, _data);
282   }
283 
284   uint256 public constant RELEASE_GAS_FEES = 45989;
285 
286   /// @dev This event is emitted when funds have been released from escrow at which time
287   ///  the escrow will be removed from storage (i.e., destroyed).
288   event Released(address indexed sender, address indexed bidder, uint256 value, string id);
289 
290   /// @notice Release ether from escrow. Only the arbitrator is able to perform this action.
291   /// @param _id Is the unique identifier of the escrow
292   function release(string _id) external onlyArbitrator {
293     // Throw if this deposit doesn't exist
294     require(escrows[_id].exists);
295 
296     EscrowDeposit storage escrowDeposit = escrows[_id];
297 
298     // Shouldn't need to use SafeMath here because this should never cause an overflow
299     uint256 gasFees = RELEASE_GAS_FEES.mul(tx.gasprice);
300     uint256 amount = escrowDeposit.amount.sub(gasFees);
301     address bidder = escrowDeposit.bidder;
302 
303     // Remove the deposit from storage
304     delete escrows[_id];
305 
306     accumulatedGasFees = accumulatedGasFees.add(gasFees);
307     bidder.transfer(amount);
308 
309     emit Released(
310       msg.sender,
311       bidder,
312       amount,
313       _id);
314   }
315 
316   /// @notice Withdraw accumulated gas fees from the arbitratror releasing escrow.
317   ///  Only callable by the owner
318   function withdrawAccumulatedFees(address _to) external onlyOwner {
319     uint256 transferAmount = accumulatedGasFees;
320     accumulatedGasFees = 0;
321 
322     _to.transfer(transferAmount);
323   }
324 
325   /// @dev This accessor method is needed because the compiler is not able to create one with a string mapping
326   /// @notice Gets the EscrowDeposit based on the input id. Throws if the deposit doesn't exist.
327   /// @param _id The unique identifier of the escrow
328   function getEscrowDeposit(string _id) external view returns (address bidder, bytes data, uint256 amount) {
329     // Throw if this deposit doesn't exist
330     require(escrows[_id].exists);
331 
332     EscrowDeposit storage escrowDeposit = escrows[_id];
333 
334     bidder = escrowDeposit.bidder;
335     data = escrowDeposit.data;
336     amount = escrowDeposit.amount;
337   }
338 }