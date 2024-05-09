1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Eliptic curve signature operations
51  *
52  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
53  *
54  * TODO Remove this library once solidity supports passing a signature to ecrecover.
55  * See https://github.com/ethereum/solidity/issues/864
56  *
57  */
58 
59 library ECRecovery {
60 
61   /**
62    * @dev Recover signer address from a message by using their signature
63    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
64    * @param sig bytes signature, the signature is generated using web3.eth.sign()
65    */
66   function recover(bytes32 hash, bytes sig)
67     internal
68     pure
69     returns (address)
70   {
71     bytes32 r;
72     bytes32 s;
73     uint8 v;
74 
75     // Check the signature length
76     if (sig.length != 65) {
77       return (address(0));
78     }
79 
80     // Divide the signature in r, s and v variables
81     // ecrecover takes the signature parameters, and the only way to get them
82     // currently is to use assembly.
83     // solium-disable-next-line security/no-inline-assembly
84     assembly {
85       r := mload(add(sig, 32))
86       s := mload(add(sig, 64))
87       v := byte(0, mload(add(sig, 96)))
88     }
89 
90     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
91     if (v < 27) {
92       v += 27;
93     }
94 
95     // If the version is correct return the signer address
96     if (v != 27 && v != 28) {
97       return (address(0));
98     } else {
99       // solium-disable-next-line arg-overflow
100       return ecrecover(hash, v, r, s);
101     }
102   }
103 
104   /**
105    * toEthSignedMessageHash
106    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
107    * @dev and hash the result
108    */
109   function toEthSignedMessageHash(bytes32 hash)
110     internal
111     pure
112     returns (bytes32)
113   {
114     // 32 is the length in bytes of hash,
115     // enforced by the type signature above
116     return keccak256(
117       "\x19Ethereum Signed Message:\n32",
118       hash
119     );
120   }
121 }
122 
123 /**
124  * @title ERC20Basic
125  * @dev Simpler version of ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/179
127  */
128 contract ERC20Basic {
129   function totalSupply() public view returns (uint256);
130   function balanceOf(address who) public view returns (uint256);
131   function transfer(address to, uint256 value) public returns (bool);
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 /**
136  * @title Basic token
137  * @dev Basic version of StandardToken, with no allowances.
138  */
139 contract BasicToken is ERC20Basic {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143 
144   uint256 totalSupply_;
145 
146   /**
147   * @dev total number of tokens in existence
148   */
149   function totalSupply() public view returns (uint256) {
150     return totalSupply_;
151   }
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     emit Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) public view returns (uint256) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 /**
180  * @title ERC20 interface
181  * @dev see https://github.com/ethereum/EIPs/issues/20
182  */
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/ethereum/EIPs/issues/20
195  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
196  */
197 contract StandardToken is ERC20, BasicToken {
198 
199   mapping (address => mapping (address => uint256)) internal allowed;
200 
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
209     require(_to != address(0));
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212 
213     balances[_from] = balances[_from].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216     emit Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    *
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(address _owner, address _spender) public view returns (uint256) {
243     return allowed[_owner][_spender];
244   }
245 
246   /**
247    * @dev Increase the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To increment
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _addedValue The amount of tokens to increase the allowance by.
255    */
256   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
257     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
258     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To decrement
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _subtractedValue The amount of tokens to decrease the allowance by.
271    */
272   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 /// @title Unidirectional payment channels contract for ERC20 tokens.
286 contract TokenUnidirectional {
287     using SafeMath for uint256;
288 
289     struct PaymentChannel {
290         address sender;
291         address receiver;
292         uint256 value; // Total amount of money deposited to the channel.
293 
294         uint256 settlingPeriod; // How many blocks to wait for the receiver to claim her funds, after sender starts settling.
295         uint256 settlingUntil; // Starting with this block number, anyone can settle the channel.
296         address tokenContract; // Address of ERC20 token contract.
297     }
298 
299     mapping (bytes32 => PaymentChannel) public channels;
300 
301     event DidOpen(bytes32 indexed channelId, address indexed sender, address indexed receiver, uint256 value, address tokenContract);
302     event DidDeposit(bytes32 indexed channelId, uint256 deposit);
303     event DidClaim(bytes32 indexed channelId);
304     event DidStartSettling(bytes32 indexed channelId);
305     event DidSettle(bytes32 indexed channelId);
306 
307     /*** ACTIONS AND CONSTRAINTS ***/
308 
309     /// @notice Open a new channel between `msg.sender` and `receiver`, and do an initial deposit to the channel.
310     /// @param channelId Unique identifier of the channel to be created.
311     /// @param receiver Receiver of the funds, counter-party of `msg.sender`.
312     /// @param settlingPeriod Number of blocks to wait for receiver to `claim` her funds after the sender starts settling period (see `startSettling`).
313     /// After that period is over anyone could call `settle`, and move all the channel funds to the sender.
314     /// @param tokenContract Address of ERC20 token contract.
315     /// @param value Initial channel amount.
316     /// @dev Before opening a channel, the sender should `approve` spending the token by TokenUnidirectional contract.
317     function open(bytes32 channelId, address receiver, uint256 settlingPeriod, address tokenContract, uint256 value) public {
318         require(isAbsent(channelId), "Channel with the same id is present");
319 
320         StandardToken token = StandardToken(tokenContract);
321         require(token.transferFrom(msg.sender, address(this), value), "Unable to transfer token to the contract");
322 
323         channels[channelId] = PaymentChannel({
324             sender: msg.sender,
325             receiver: receiver,
326             value: value,
327             settlingPeriod: settlingPeriod,
328             settlingUntil: 0,
329             tokenContract: tokenContract
330         });
331 
332         emit DidOpen(channelId, msg.sender, receiver, value, tokenContract);
333     }
334 
335     /// @notice Ensure `origin` address can deposit funds into the channel identified by `channelId`.
336     /// @dev Constraint `deposit` call.
337     /// @param channelId Identifier of the channel.
338     /// @param origin Caller of `deposit` function.
339     function canDeposit(bytes32 channelId, address origin) public view returns(bool) {
340         PaymentChannel storage channel = channels[channelId];
341         bool isSender = channel.sender == origin;
342         return isOpen(channelId) && isSender;
343     }
344 
345     /// @notice Add more funds to the contract.
346     /// @param channelId Identifier of the channel.
347     /// @param value Amount to be deposited.
348     function deposit(bytes32 channelId, uint256 value) public {
349         require(canDeposit(channelId, msg.sender), "canDeposit returned false");
350 
351         PaymentChannel storage channel = channels[channelId];
352         StandardToken token = StandardToken(channel.tokenContract);
353         require(token.transferFrom(msg.sender, address(this), value), "Unable to transfer token to the contract");
354         channel.value = channel.value.add(value);
355 
356         emit DidDeposit(channelId, value);
357     }
358 
359     /// @notice Ensure `origin` address can start settling the channel identified by `channelId`.
360     /// @dev Constraint `startSettling` call.
361     /// @param channelId Identifier of the channel.
362     /// @param origin Caller of `startSettling` function.
363     function canStartSettling(bytes32 channelId, address origin) public view returns(bool) {
364         PaymentChannel storage channel = channels[channelId];
365         bool isSender = channel.sender == origin;
366         return isOpen(channelId) && isSender;
367     }
368 
369     /// @notice Sender initiates settling of the contract.
370     /// @dev Actually set `settlingUntil` field of the PaymentChannel structure.
371     /// @param channelId Identifier of the channel.
372     function startSettling(bytes32 channelId) public {
373         require(canStartSettling(channelId, msg.sender), "canStartSettling returned false");
374 
375         PaymentChannel storage channel = channels[channelId];
376         channel.settlingUntil = block.number.add(channel.settlingPeriod);
377 
378         emit DidStartSettling(channelId);
379     }
380 
381     /// @notice Ensure one can settle the channel identified by `channelId`.
382     /// @dev Check if settling period is over by comparing `settlingUntil` to a current block number.
383     /// @param channelId Identifier of the channel.
384     function canSettle(bytes32 channelId) public view returns(bool) {
385         PaymentChannel storage channel = channels[channelId];
386         bool isWaitingOver = block.number >= channel.settlingUntil;
387         return isSettling(channelId) && isWaitingOver;
388     }
389 
390     /// @notice Move the money to sender, and close the channel.
391     /// After the settling period is over, and receiver has not claimed the funds, anyone could call that.
392     /// @param channelId Identifier of the channel.
393     function settle(bytes32 channelId) public {
394         require(canSettle(channelId), "canSettle returned false");
395 
396         PaymentChannel storage channel = channels[channelId];
397         StandardToken token = StandardToken(channel.tokenContract);
398 
399         require(token.transfer(channel.sender, channel.value), "Unable to transfer token to channel sender");
400 
401         delete channels[channelId];
402         emit DidSettle(channelId);
403     }
404 
405     /// @notice Ensure `origin` address can claim `payment` amount on channel identified by `channelId`.
406     /// @dev Check if `signature` is made by sender part of the channel, and is for payment promise (see `paymentDigest`).
407     /// @param channelId Identifier of the channel.
408     /// @param payment Amount claimed.
409     /// @param origin Caller of `claim` function.
410     /// @param signature Signature for the payment promise.
411     function canClaim(bytes32 channelId, uint256 payment, address origin, bytes signature) public view returns(bool) {
412         PaymentChannel storage channel = channels[channelId];
413         bool isReceiver = origin == channel.receiver;
414         bytes32 hash = recoveryPaymentDigest(channelId, payment, channel.tokenContract);
415         bool isSigned = channel.sender == ECRecovery.recover(hash, signature);
416 
417         return isReceiver && isSigned;
418     }
419 
420     /// @notice Claim the funds, and close the channel.
421     /// @dev Can be claimed by channel receiver only. Guarded by `canClaim`.
422     /// @param channelId Identifier of the channel.
423     /// @param payment Amount claimed.
424     /// @param signature Signature for the payment promise.
425     function claim(bytes32 channelId, uint256 payment, bytes signature) public {
426         require(canClaim(channelId, payment, msg.sender, signature), "canClaim returned false");
427 
428         PaymentChannel storage channel = channels[channelId];
429         StandardToken token = StandardToken(channel.tokenContract);
430 
431         if (payment >= channel.value) {
432             require(token.transfer(channel.receiver, channel.value), "Unable to transfer token to channel receiver");
433         } else {
434             require(token.transfer(channel.receiver, payment), "Unable to transfer token to channel receiver");
435             uint256 change = channel.value.sub(payment);
436             require(token.transfer(channel.sender, change), "Unable to transfer token to channel sender");
437         }
438 
439         delete channels[channelId];
440 
441         emit DidClaim(channelId);
442     }
443 
444     /*** CHANNEL STATE ***/
445 
446     /// @notice Check if the channel is not present.
447     /// @param channelId Identifier of the channel.
448     function isAbsent(bytes32 channelId) public view returns(bool) {
449         PaymentChannel storage channel = channels[channelId];
450         return channel.sender == 0;
451     }
452 
453     /// @notice Check if the channel is present: in open or settling state.
454     /// @param channelId Identifier of the channel.
455     function isPresent(bytes32 channelId) public view returns(bool) {
456         return !isAbsent(channelId);
457     }
458 
459     /// @notice Check if the channel is in settling state: waits till the settling period is over.
460     /// @dev It is settling, if `settlingUntil` is set to non-zero.
461     /// @param channelId Identifier of the channel.
462     function isSettling(bytes32 channelId) public view returns(bool) {
463         PaymentChannel storage channel = channels[channelId];
464         return channel.settlingUntil != 0;
465     }
466 
467     /// @notice Check if the channel is open: present and not settling.
468     /// @param channelId Identifier of the channel.
469     function isOpen(bytes32 channelId) public view returns(bool) {
470         return isPresent(channelId) && !isSettling(channelId);
471     }
472 
473     /*** PAYMENT DIGEST ***/
474 
475     /// @return Hash of the payment promise to sign.
476     /// @param channelId Identifier of the channel.
477     /// @param payment Amount to send, and to claim later.
478     /// @param tokenContract Address of ERC20 token contract.
479     function paymentDigest(bytes32 channelId, uint256 payment, address tokenContract) public view returns(bytes32) {
480         return keccak256(abi.encodePacked(address(this), channelId, payment, tokenContract));
481     }
482 
483     /// @return Actually signed hash of the payment promise, considering "Ethereum Signed Message" prefix.
484     /// @param channelId Identifier of the channel.
485     /// @param payment Amount to send, and to claim later.
486     function recoveryPaymentDigest(bytes32 channelId, uint256 payment, address tokenContract) internal view returns(bytes32) {
487         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
488         return keccak256(abi.encodePacked(prefix, paymentDigest(channelId, payment, tokenContract)));
489     }
490 }