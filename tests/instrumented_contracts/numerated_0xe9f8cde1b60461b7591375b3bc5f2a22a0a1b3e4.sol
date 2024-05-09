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
196   function getStatus(address _arbitrator, uint256 _transactionId) 
197       public view returns(address, address, uint256, uint256, uint256, bool) {
198     return(
199       escrows[_arbitrator][_transactionId].sender,
200       escrows[_arbitrator][_transactionId].recipient,
201       escrows[_arbitrator][_transactionId].value,
202       escrows[_arbitrator][_transactionId].fee,
203       escrows[_arbitrator][_transactionId].expiration,
204       escrows[_arbitrator][_transactionId].paid
205     );
206   }
207 
208   function isUnlocked(address _arbitrator, uint256 _transactionId) public view returns(bool) {
209     return escrows[_arbitrator][_transactionId].expiration == 1;
210   }
211 
212   /**
213    * @dev Create a record for held tokens
214    * @param _arbitrator Address to be authorized to spend locked funds
215    * @param _transactionId Intenral ID for applications implementing this
216    * @param _tokens Amount of tokens to lock
217    * @param _fee A fee to be paid to arbitrator (may be 0)
218    * @param _expiration After this timestamp, user can claim tokens back.
219    */
220   function create(
221       address _sender,
222       address _recipient,
223       address _arbitrator,
224       uint256 _transactionId,
225       uint256 _tokens,
226       uint256 _fee,
227       uint256 _expiration
228   ) public tokenRestricted {
229 
230     require(_tokens > 0);
231     require(_fee >= 0);
232     require(escrows[_arbitrator][_transactionId].value == 0);
233 
234     escrows[_arbitrator][_transactionId].sender = _sender;
235     escrows[_arbitrator][_transactionId].recipient = _recipient;
236     escrows[_arbitrator][_transactionId].value = _tokens;
237     escrows[_arbitrator][_transactionId].fee = _fee;
238     escrows[_arbitrator][_transactionId].expiration = _expiration;
239 
240     Created(_sender, _recipient, _arbitrator, _transactionId);
241   }
242 
243   /**
244    * @dev Fund escrow record
245    * @param _arbitrator Address to be authorized to spend locked funds
246    * @param _transactionId Intenral ID for applications implementing this
247    * @param _tokens Amount of tokens to lock
248    * @param _fee A fee to be paid to arbitrator (may be 0)
249    */
250   function fund(
251       address _sender,
252       address _arbitrator,
253       uint256 _transactionId,
254       uint256 _tokens,
255       uint256 _fee
256   ) public tokenRestricted {
257 
258     require(escrows[_arbitrator][_transactionId].sender == _sender);
259     require(escrows[_arbitrator][_transactionId].value == _tokens);
260     require(escrows[_arbitrator][_transactionId].fee == _fee);
261     require(escrows[_arbitrator][_transactionId].paid == false);
262 
263     escrows[_arbitrator][_transactionId].paid = true;
264 
265     Paid(_arbitrator, _transactionId);
266   }
267 
268   /**
269    * @dev Transfer a locked amount
270    * @notice Only authorized address
271    * @notice Exchange rate has 18 decimal places
272    * @param _sender Address with locked amount
273    * @param _recipient Address to send funds to
274    * @param _transactionId App/user internal associated ID
275    * @param _exchangeRate Rate to be reported to the blockchain
276    */
277   function release(
278       address _sender,
279       address _recipient,
280       uint256 _transactionId,
281       uint256 _exchangeRate
282   ) public {
283 
284     Lock memory lock = escrows[msg.sender][_transactionId];
285 
286     require(lock.expiration != 1);
287     require(lock.sender == _sender);
288     require(lock.recipient == _recipient || lock.sender == _recipient);
289     require(lock.paid);
290 
291     if (lock.fee > 0 && lock.recipient == _recipient) {
292       token.transfer(_recipient, lock.value);
293       token.transfer(msg.sender, lock.fee);
294     } else {
295       token.transfer(_recipient, lock.value.add(lock.fee));
296     }
297 
298     delete escrows[msg.sender][_transactionId];
299 
300     token.issueExchangeRate(
301       _sender,
302       _recipient,
303       msg.sender,
304       lock.value,
305       _transactionId,
306       _exchangeRate
307     );
308     Released(msg.sender, _recipient, _transactionId);
309   }
310 
311   /**
312    * @dev Transfer a locked amount for timeless escrow
313    * @notice Only authorized address
314    * @notice Exchange rate has 18 decimal places
315    * @param _sender Address with locked amount
316    * @param _recipient Address to send funds to
317    * @param _transactionId App/user internal associated ID
318    * @param _exchangeRate Rate to be reported to the blockchain
319    */
320   function releaseUnlocked(
321       address _sender,
322       address _recipient,
323       uint256 _transactionId,
324       uint256 _exchangeRate
325   ) public {
326 
327     Lock memory lock = escrows[msg.sender][_transactionId];
328 
329     require(lock.expiration == 1);
330     require(lock.sender == _sender);
331     require(lock.paid);
332 
333     if (lock.fee > 0 && lock.sender != _recipient) {
334       token.transfer(_recipient, lock.value);
335       token.transfer(msg.sender, lock.fee);
336     } else {
337       token.transfer(_recipient, lock.value.add(lock.fee));
338     }
339 
340     delete escrows[msg.sender][_transactionId];
341 
342     token.issueExchangeRate(
343       _sender,
344       _recipient,
345       msg.sender,
346       lock.value,
347       _transactionId,
348       _exchangeRate
349     );
350     Released(msg.sender, _recipient, _transactionId);
351   }
352 
353   /**
354    * @dev Claim back locked amount after expiration time
355    * @dev Cannot be claimed if expiration == 0 or expiration == 1
356    * @notice Only works after lock expired
357    * @param _arbitrator Authorized lock address
358    * @param _transactionId transactionId ID from App/user
359    */
360   function claim(
361       address _arbitrator,
362       uint256 _transactionId
363   ) public {
364     Lock memory lock = escrows[_arbitrator][_transactionId];
365 
366     require(lock.sender == msg.sender);
367     require(lock.paid);
368     require(lock.expiration < block.timestamp);
369     require(lock.expiration != 0);
370     require(lock.expiration != 1);
371 
372     delete escrows[_arbitrator][_transactionId];
373 
374     token.transfer(msg.sender, lock.value.add(lock.fee));
375 
376     Released(
377       _arbitrator,
378       msg.sender,
379       _transactionId
380     );
381   }
382 
383   /**
384    * @dev Remove expiration time on a lock
385    * @notice User wont be able to claim tokens back after this is called by arbitrator address
386    * @notice Only authorized address
387    * @param _transactionId App/user internal associated ID
388    */
389   function mediate(
390       uint256 _transactionId
391   ) public {
392     require(escrows[msg.sender][_transactionId].paid);
393     require(escrows[msg.sender][_transactionId].expiration != 0);
394     require(escrows[msg.sender][_transactionId].expiration != 1);
395 
396     escrows[msg.sender][_transactionId].expiration = 0;
397 
398     Dispute(msg.sender, _transactionId);
399   }
400 
401   /**
402    This function is a way to get other ETC20 tokens
403    back to their rightful owner if sent by mistake
404    */
405   function transferToken(address _tokenAddress, address _transferTo, uint256 _value) public onlyOwner {
406     require(_tokenAddress != address(token));
407 
408     ISendToken erc20Token = ISendToken(_tokenAddress);
409     erc20Token.transfer(_transferTo, _value);
410   }
411 }