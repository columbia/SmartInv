1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title ERC20Basic
33  * @dev Simpler version of ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/179
35  */
36 contract ERC20Basic {
37   uint256 public totalSupply;
38   function balanceOf(address who) constant returns (uint256);
39   function transfer(address to, uint256 value) returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 
44 /**
45  * @title ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/20
47  */
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) constant returns (uint256);
50   function transferFrom(address from, address to, uint256 value) returns (bool);
51   function approve(address spender, uint256 value) returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances. 
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   /**
65   * @dev transfer token for a specified address
66   * @param _to The address to transfer to.
67   * @param _value The amount to be transferred.
68   */
69   function transfer(address _to, uint256 _value) returns (bool) {
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of. 
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) constant returns (uint256 balance) {
82     return balances[_owner];
83   }
84 }
85 
86 
87 /*
88  * Ownable
89  *
90  * Base contract with an owner.
91  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
92  */
93 
94 contract Ownable {
95   address public owner;
96 
97   constructor() public {
98     owner = msg.sender;
99   }
100 
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 }
106 
107 
108 /**
109  * @title Pausable
110  * @dev Base contract which allows children to implement an emergency stop mechanism.
111  */
112 contract Pausable is Ownable {
113   event Pause();
114   event Unpause();
115 
116   bool public paused = false;
117 
118 
119   /**
120    * @dev Modifier to make a function callable only when the contract is not paused.
121    */
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is paused.
129    */
130   modifier whenPaused() {
131     require(paused);
132     _;
133   }
134 
135   /**
136    * @dev called by the owner to pause, triggers stopped state
137    */
138   function pause() public onlyOwner whenNotPaused {
139     paused = true;
140     emit Pause();
141   }
142 
143   /**
144    * @dev called by the owner to unpause, returns to normal state
145    */
146   function unpause() public onlyOwner whenPaused {
147     paused = false;
148     emit Unpause();
149   }
150 }
151 
152 
153 /**
154  * @title Stoppable
155  * @dev Base contract which allows children to implement final irreversible stop mechanism.
156  */
157 contract Stoppable is Pausable {
158   event Stop();
159 
160   bool public stopped = false;
161 
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is not stopped.
165    */
166   modifier whenNotStopped() {
167     require(!stopped);
168     _;
169   }
170 
171   /**
172    * @dev Modifier to make a function callable only when the contract is stopped.
173    */
174   modifier whenStopped() {
175     require(stopped);
176     _;
177   }
178 
179   /**
180    * @dev called by the owner to pause, triggers stopped state
181    */
182   function stop() public onlyOwner whenNotStopped {
183     stopped = true;
184     emit Stop();
185   }
186 }
187 
188 
189 /**
190  * @title Standard ERC20 token
191  *
192  * @dev Implementation of the basic standard token.
193  * @dev https://github.com/ethereum/EIPs/issues/20
194  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
195  */
196 contract StandardToken is ERC20, BasicToken {
197 
198   mapping (address => mapping (address => uint256)) allowed;
199 
200 
201   /**
202    * @dev Transfer tokens from one address to another
203    * @param _from address The address which you want to send tokens from
204    * @param _to address The address which you want to transfer to
205    * @param _value uint256 the amout of tokens to be transfered
206    */
207   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
208     var _allowance = allowed[_from][msg.sender];
209 
210     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
211     // require (_value <= _allowance);
212 
213     balances[_to] = balances[_to].add(_value);
214     balances[_from] = balances[_from].sub(_value);
215     allowed[_from][msg.sender] = _allowance.sub(_value);
216     Transfer(_from, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) returns (bool) {
226 
227     // To change the approve amount you first have to reduce the addresses`
228     //  allowance to zero by calling `approve(_spender, 0)` if it is not
229     //  already 0 to mitigate the race condition described here:
230     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
232 
233     allowed[msg.sender][_spender] = _value;
234     Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifing the amount of tokens still avaible for the spender.
243    */
244   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
245     return allowed[_owner][_spender];
246   }
247 }
248 
249 
250 /**
251  * @title e2pAir Escrow Contract
252  * @dev Contract sends tokens from airdropper's account to receiver on claim.
253  * 
254  * When deploying contract, airdroper provides airdrop parametrs: token, amount 
255  * of tokens and amount of eth should be claimed per link and  airdrop transit 
256  * address and deposits ether needed for the airdrop.
257  * 
258  * Airdrop transit address is used to verify that links are signed by airdropper. 
259  * 
260  * Airdropper generates claim links. Each link contains a private key 
261  * signed by the airdrop transit private key. The link private key can be used 
262  * once to sign receiver's address. Receiver provides signature
263  * to the Relayer Server, which calls smart contract to withdraw tokens. 
264  * 
265  * On claim smart contract verifies, that receiver provided address signed 
266  * by a link private key. 
267  * If everything is correct smart contract sends tokens and ether to receiver.
268  * 
269  * Anytime airdropper can get back unclaimed ether using getEtherBack method.
270  * 
271  */
272 contract e2pAirEscrow is Stoppable {
273   
274   address public TOKEN_ADDRESS; // token to distribute
275   uint public CLAIM_AMOUNT; // tokens claimed per link
276   uint public REFERRAL_AMOUNT; // referral reward
277 
278   uint public CLAIM_AMOUNT_ETH; // ether claimed per link
279   address public AIRDROPPER; // airdropper address, which has tokens to distribute
280   address public AIRDROP_TRANSIT_ADDRESS; // special address, used on claim to verify 
281                                           // that links signed by the airdropper
282   
283 
284   // Mappings of transit address => true if link is used.                                                                                                                                
285   mapping (address => bool) usedTransitAddresses;
286   
287    /**
288    * @dev Contructor that sets airdrop params and receives ether needed for the 
289    * airdrop. 
290    * @param _tokenAddress address Token address to distribute
291    * @param _claimAmount uint tokens (in atomic values) claimed per link
292    * @param _claimAmountEth uint ether (in wei) claimed per link
293    * @param _airdropTransitAddress special address, used on claim to verify that links signed by airdropper
294    */
295   constructor(address _tokenAddress,
296               uint _claimAmount, 
297               uint  _referralAmount, 
298               uint _claimAmountEth,
299               address _airdropTransitAddress) public payable {
300     AIRDROPPER = msg.sender;
301     TOKEN_ADDRESS = _tokenAddress;
302     CLAIM_AMOUNT = _claimAmount;
303     REFERRAL_AMOUNT = _referralAmount;
304     CLAIM_AMOUNT_ETH = _claimAmountEth;
305     AIRDROP_TRANSIT_ADDRESS = _airdropTransitAddress;
306   }
307 
308    /**
309    * @dev Verify that address is signed with needed private key.
310    * @param _transitAddress transit address assigned to transfer
311    * @param _addressSigned address Signed address.
312    * @param _v ECDSA signature parameter v.
313    * @param _r ECDSA signature parameters r.
314    * @param _s ECDSA signature parameters s.
315    * @return True if signature is correct.
316    */
317   function verifyLinkPrivateKey(
318 			   address _transitAddress,
319 			   address _addressSigned,
320 			   address _referralAddress,
321 			   uint8 _v,
322 			   bytes32 _r,
323 			   bytes32 _s)
324     public pure returns(bool success) {
325     bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", _addressSigned, _referralAddress);
326     address retAddr = ecrecover(prefixedHash, _v, _r, _s);
327     return retAddr == _transitAddress;
328   }
329   
330   
331    /**
332    * @dev Verify that address is signed with needed private key.
333    * @param _transitAddress transit address assigned to transfer
334    * @param _addressSigned address Signed address.
335    * @param _v ECDSA signature parameter v.
336    * @param _r ECDSA signature parameters r.
337    * @param _s ECDSA signature parameters s.
338    * @return True if signature is correct.
339    */
340   function verifyReceiverAddress(
341 			   address _transitAddress,
342 			   address _addressSigned,
343 			   uint8 _v,
344 			   bytes32 _r,
345 			   bytes32 _s)
346     public pure returns(bool success) {
347     bytes32 prefixedHash = keccak256("\x19Ethereum Signed Message:\n32", _addressSigned);
348     address retAddr = ecrecover(prefixedHash, _v, _r, _s);
349     return retAddr == _transitAddress;
350   }
351   
352 /**
353    * @dev Verify that claim params are correct and the link key wasn't used before.  
354    * @param _recipient address to receive tokens.
355    * @param _transitAddress transit address provided by the airdropper
356    * @param _keyV ECDSA signature parameter v. Signed by the airdrop transit key.
357    * @param _keyR ECDSA signature parameters r. Signed by the airdrop transit key.
358    * @param _keyS ECDSA signature parameters s. Signed by the airdrop transit key.
359    * @param _recipientV ECDSA signature parameter v. Signed by the link key.
360    * @param _recipientR ECDSA signature parameters r. Signed by the link key.
361    * @param _recipientS ECDSA signature parameters s. Signed by the link key.
362    * @return True if claim params are correct. 
363    */
364   function checkWithdrawal(
365             address _recipient, 
366             address _referralAddress, 
367 		    address _transitAddress,
368 		    uint8 _keyV, 
369 		    bytes32 _keyR,
370 			bytes32 _keyS,
371 			uint8 _recipientV, 
372 		    bytes32 _recipientR,
373 			bytes32 _recipientS) 
374     public view returns(bool success) {
375     
376         // verify that link wasn't used before  
377         require(usedTransitAddresses[_transitAddress] == false);
378 
379         // verifying that key is legit and signed by AIRDROP_TRANSIT_ADDRESS's key
380         require(verifyLinkPrivateKey(AIRDROP_TRANSIT_ADDRESS, _transitAddress, _referralAddress, _keyV, _keyR, _keyS));
381     
382         // verifying that recepients address signed correctly
383         require(verifyReceiverAddress(_transitAddress, _recipient, _recipientV, _recipientR, _recipientS));
384         
385         // verifying that there is enough ether to make transfer
386         require(address(this).balance >= CLAIM_AMOUNT_ETH);
387         
388         return true;
389   }
390   
391   /**
392    * @dev Withdraw tokens to receiver address if withdraw params are correct.
393    * @param _recipient address to receive tokens.
394    * @param _transitAddress transit address provided to receiver by the airdropper
395    * @param _keyV ECDSA signature parameter v. Signed by the airdrop transit key.
396    * @param _keyR ECDSA signature parameters r. Signed by the airdrop transit key.
397    * @param _keyS ECDSA signature parameters s. Signed by the airdrop transit key.
398    * @param _recipientV ECDSA signature parameter v. Signed by the link key.
399    * @param _recipientR ECDSA signature parameters r. Signed by the link key.
400    * @param _recipientS ECDSA signature parameters s. Signed by the link key.
401    * @return True if tokens (and ether) were successfully sent to receiver.
402    */
403   function withdraw(
404 		    address _recipient, 
405 		    address _referralAddress, 
406 		    address _transitAddress,
407 		    uint8 _keyV, 
408 		    bytes32 _keyR,
409 			bytes32 _keyS,
410 			uint8 _recipientV, 
411 		    bytes32 _recipientR,
412 			bytes32 _recipientS
413 		    )
414     public
415     whenNotPaused
416     whenNotStopped
417     returns (bool success) {
418     
419     require(checkWithdrawal(_recipient, 
420     		_referralAddress,
421 		    _transitAddress,
422 		    _keyV, 
423 		    _keyR,
424 			_keyS,
425 			_recipientV, 
426 		    _recipientR,
427 			_recipientS));
428         
429 
430     // save to state that address was used
431     usedTransitAddresses[_transitAddress] = true;
432 
433     // send tokens
434     if (CLAIM_AMOUNT > 0 && TOKEN_ADDRESS != 0x0000000000000000000000000000000000000000) {
435         StandardToken token = StandardToken(TOKEN_ADDRESS);
436         token.transferFrom(AIRDROPPER, _recipient, CLAIM_AMOUNT);
437     }
438     
439     // send tokens to the address who refferred the airdrop 
440     if (REFERRAL_AMOUNT > 0 && _referralAddress != 0x0000000000000000000000000000000000000000) {
441         token.transferFrom(AIRDROPPER, _referralAddress, REFERRAL_AMOUNT);
442     }
443 
444     
445     // send ether (if needed)
446     if (CLAIM_AMOUNT_ETH > 0) {
447         _recipient.transfer(CLAIM_AMOUNT_ETH);
448     }
449     
450     return true;
451   }
452 
453  /**
454    * @dev Get boolean if link is already claimed. 
455    * @param _transitAddress transit address provided to receiver by the airdropper
456    * @return True if the transit address was already used. 
457    */
458   function isLinkClaimed(address _transitAddress) 
459     public view returns (bool claimed) {
460         return usedTransitAddresses[_transitAddress];
461   }
462 
463    /**
464    * @dev Withdraw ether back deposited to the smart contract.  
465    * @return True if ether was withdrawn. 
466    */
467   function getEtherBack() public returns (bool success) { 
468     require(msg.sender == AIRDROPPER);
469       
470     AIRDROPPER.transfer(address(this).balance);
471       
472     return true;
473   }
474 }