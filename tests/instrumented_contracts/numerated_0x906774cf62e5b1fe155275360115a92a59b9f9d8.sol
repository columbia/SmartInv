1 pragma solidity ^0.4.18;
2 
3 // File: contracts/IEscrow.sol
4 
5 /**
6  * @title Escrow interface
7  *
8  * @dev https://send.sd/token
9  */
10 interface IEscrow {
11 
12   event Created(
13     address indexed sender,
14     address indexed recipient,
15     address indexed arbitrator,
16     uint256 transactionId
17   );
18   event Released(address indexed arbitrator, address indexed sentTo, uint256 transactionId);
19   event Dispute(address indexed arbitrator, uint256 transactionId);
20   event Paid(address indexed arbitrator, uint256 transactionId);
21 
22   function create(
23       address _sender,
24       address _recipient,
25       address _arbitrator,
26       uint256 _transactionId,
27       uint256 _tokens,
28       uint256 _fee,
29       uint256 _expiration
30   ) public;
31 
32   function fund(
33       address _sender,
34       address _arbitrator,
35       uint256 _transactionId,
36       uint256 _tokens,
37       uint256 _fee
38   ) public;
39 
40 }
41 
42 // File: contracts/ISendToken.sol
43 
44 /**
45  * @title ISendToken - Send Consensus Network Token interface
46  * @dev token interface built on top of ERC20 standard interface
47  * @dev see https://send.sd/token
48  */
49 interface ISendToken {
50   function transfer(address to, uint256 value) public returns (bool);
51 
52   function isVerified(address _address) public constant returns(bool);
53 
54   function verify(address _address) public;
55 
56   function unverify(address _address) public;
57 
58   function verifiedTransferFrom(
59       address from,
60       address to,
61       uint256 value,
62       uint256 referenceId,
63       uint256 exchangeRate,
64       uint256 fee
65   ) public;
66 
67   function issueExchangeRate(
68       address _from,
69       address _to,
70       address _verifiedAddress,
71       uint256 _value,
72       uint256 _referenceId,
73       uint256 _exchangeRate
74   ) public;
75 
76   event VerifiedTransfer(
77       address indexed from,
78       address indexed to,
79       address indexed verifiedAddress,
80       uint256 value,
81       uint256 referenceId,
82       uint256 exchangeRate
83   );
84 }
85 
86 // File: zeppelin-solidity/contracts/math/SafeMath.sol
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94     if (a == 0) {
95       return 0;
96     }
97     uint256 c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129   address public owner;
130 
131 
132   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134 
135   /**
136    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137    * account.
138    */
139   function Ownable() public {
140     owner = msg.sender;
141   }
142 
143 
144   /**
145    * @dev Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(msg.sender == owner);
149     _;
150   }
151 
152 
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) public onlyOwner {
158     require(newOwner != address(0));
159     OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 
163 }
164 
165 // File: contracts/Escrow.sol
166 
167 /**
168  * @title Vesting contract for SDT
169  * @dev see https://send.sd/token
170  */
171 contract Escrow is IEscrow, Ownable {
172   using SafeMath for uint256;
173 
174   ISendToken public token;
175 
176   struct Lock {
177     address sender;
178     address recipient;
179     uint256 value;
180     uint256 fee;
181     uint256 expiration;
182     bool paid;
183   }
184 
185   mapping(address => mapping(uint256 => Lock)) internal escrows;
186 
187   function Escrow(address _token) public {
188     token = ISendToken(_token);
189   }
190 
191   modifier tokenRestricted() {
192     require(msg.sender == address(token));
193     _;
194   }
195 
196   /**
197    * @dev Create a record for held tokens
198    * @param _arbitrator Address to be authorized to spend locked funds
199    * @param _transactionId Intenral ID for applications implementing this
200    * @param _tokens Amount of tokens to lock
201    * @param _fee A fee to be paid to arbitrator (may be 0)
202    * @param _expiration After this timestamp, user can claim tokens back.
203    */
204   function create(
205       address _sender,
206       address _recipient,
207       address _arbitrator,
208       uint256 _transactionId,
209       uint256 _tokens,
210       uint256 _fee,
211       uint256 _expiration
212   ) public tokenRestricted {
213 
214     require(_tokens > 0);
215     require(_fee >= 0);
216     require(escrows[_arbitrator][_transactionId].value == 0);
217 
218     escrows[_arbitrator][_transactionId].sender = _sender;
219     escrows[_arbitrator][_transactionId].recipient = _recipient;
220     escrows[_arbitrator][_transactionId].value = _tokens;
221     escrows[_arbitrator][_transactionId].fee = _fee;
222     escrows[_arbitrator][_transactionId].expiration = _expiration;
223 
224     Created(_sender, _recipient, _arbitrator, _transactionId);
225   }
226 
227   /**
228    * @dev Fund escrow record
229    * @param _arbitrator Address to be authorized to spend locked funds
230    * @param _transactionId Intenral ID for applications implementing this
231    * @param _tokens Amount of tokens to lock
232    * @param _fee A fee to be paid to arbitrator (may be 0)
233    */
234   function fund(
235       address _sender,
236       address _arbitrator,
237       uint256 _transactionId,
238       uint256 _tokens,
239       uint256 _fee
240   ) public tokenRestricted {
241 
242     require(escrows[_arbitrator][_transactionId].sender == _sender);
243     require(escrows[_arbitrator][_transactionId].value == _tokens);
244     require(escrows[_arbitrator][_transactionId].fee == _fee);
245     require(escrows[_arbitrator][_transactionId].paid == false);
246 
247     escrows[_arbitrator][_transactionId].paid = true;
248 
249     Paid(_arbitrator, _transactionId);
250   }
251 
252   /**
253    * @dev Transfer a locked amount
254    * @notice Only authorized address
255    * @notice Exchange rate has 18 decimal places
256    * @param _sender Address with locked amount
257    * @param _recipient Address to send funds to
258    * @param _transactionId App/user internal associated ID
259    * @param _exchangeRate Rate to be reported to the blockchain
260    */
261   function release(
262       address _sender,
263       address _recipient,
264       uint256 _transactionId,
265       uint256 _exchangeRate
266   ) public {
267 
268     Lock memory lock = escrows[msg.sender][_transactionId];
269 
270     require(lock.sender == _sender);
271     require(lock.recipient == _recipient || lock.sender == _recipient);
272     require(lock.paid);
273 
274     token.transfer(_recipient, lock.value);
275 
276     if (lock.fee > 0) {
277       token.transfer(msg.sender, lock.fee);
278     }
279 
280     delete escrows[msg.sender][_transactionId];
281 
282     token.issueExchangeRate(
283       _sender,
284       _recipient,
285       msg.sender,
286       lock.value,
287       _transactionId,
288       _exchangeRate
289     );
290     Released(msg.sender, _recipient, _transactionId);
291   }
292 
293   /**
294    * @dev Claim back locked amount after expiration time
295    * @dev Cannot be claimed if expiration == 0
296    * @notice Only works after lock expired
297    * @param _arbitrator Authorized lock address
298    * @param _transactionId transactionId ID from App/user
299    */
300   function claim(
301       address _arbitrator,
302       uint256 _transactionId
303   ) public {
304     Lock memory lock = escrows[_arbitrator][_transactionId];
305 
306     require(lock.sender == msg.sender);
307     require(lock.paid);
308     require(lock.expiration < block.timestamp);
309     require(lock.expiration != 0);
310 
311     delete escrows[_arbitrator][_transactionId];
312 
313     token.transfer(msg.sender, lock.value.add(lock.fee));
314 
315     Released(
316       _arbitrator,
317       msg.sender,
318       _transactionId
319     );
320   }
321 
322   /**
323    * @dev Remove expiration time on a lock
324    * @notice User wont be able to claim tokens back after this is called by arbitrator address
325    * @notice Only authorized address
326    * @param _transactionId App/user internal associated ID
327    */
328   function mediate(
329       uint256 _transactionId
330   ) public {
331     require(escrows[msg.sender][_transactionId].paid);
332 
333     escrows[msg.sender][_transactionId].expiration = 0;
334 
335     Dispute(msg.sender, _transactionId);
336   }
337 
338   /**
339    This function is a way to get other ETC20 tokens
340    back to their rightful owner if sent by mistake
341    */
342   function transferToken(address _tokenAddress, address _transferTo, uint256 _value) public onlyOwner {
343     require(_tokenAddress != address(token));
344 
345     ISendToken erc20Token = ISendToken(_tokenAddress);
346     erc20Token.transfer(_transferTo, _value);
347   }
348 }