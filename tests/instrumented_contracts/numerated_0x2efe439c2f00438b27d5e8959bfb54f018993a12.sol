1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40 	address public owner;
41 	address public newOwner;
42 
43 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
44 
45 	constructor() public {
46 		owner = msg.sender;
47 		newOwner = address(0);
48 	}
49 
50 	modifier onlyOwner() {
51 		require(msg.sender == owner, "msg.sender == owner");
52 		_;
53 	}
54 
55 	function transferOwnership(address _newOwner) public onlyOwner {
56 		require(address(0) != _newOwner, "address(0) != _newOwner");
57 		newOwner = _newOwner;
58 	}
59 
60 	function acceptOwnership() public {
61 		require(msg.sender == newOwner, "msg.sender == newOwner");
62 		emit OwnershipTransferred(owner, msg.sender);
63 		owner = msg.sender;
64 		newOwner = address(0);
65 	}
66 }
67 
68 
69 /**
70  * @title Authorizable
71  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
72  * functions, this simplifies the implementation of "multiple user permissions".
73  */
74 contract Authorizable is Ownable {
75   mapping(address => bool) public authorized;
76 
77   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
78 
79   /**
80    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84 	authorized[msg.sender] = true;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the authorized.
89    */
90   modifier onlyAuthorized() {
91     require(authorized[msg.sender]);
92     _;
93   }
94 
95  /**
96    * @dev Allows the current owner to set an authorization.
97    * @param addressAuthorized The address to change authorization.
98    */
99   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
100     emit AuthorizationSet(addressAuthorized, authorization);
101     authorized[addressAuthorized] = authorization;
102   }
103 
104 }
105 
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic {
113   uint256 public totalSupply;
114   function balanceOf(address who) public constant returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public constant returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   /**
140   * @dev transfer token from an address to another specified address
141   * @param _sender The address to transfer from.
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
146     require(_to != address(0));
147     require(_to != address(this));
148     require(_value <= balances[_sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[_sender] = balances[_sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     emit Transfer(_sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev transfer token for a specified address (BasicToken transfer method)
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161 	return transferFunction(msg.sender, _to, _value);
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public constant returns (uint256 balance) {
170     return balances[_owner];
171   }
172 }
173 
174 contract ERC223TokenCompatible is BasicToken {
175   using SafeMath for uint256;
176 
177   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
178 
179   // Function that is called when a user or another contract wants to transfer funds .
180 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
181 		require(_to != address(0));
182         require(_to != address(this));
183 		require(_value <= balances[msg.sender]);
184 		// SafeMath.sub will throw if there is not enough balance.
185         balances[msg.sender] = balances[msg.sender].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187 		if( isContract(_to) ) {
188 			require(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
189 		}
190 		emit Transfer(msg.sender, _to, _value, _data);
191 		return true;
192 	}
193 
194 	// Function that is called when a user or another contract wants to transfer funds .
195 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
196 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
197 	}
198 
199 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
200 	function isContract(address _addr) private view returns (bool is_contract) {
201 		uint256 length;
202 		assembly {
203             //retrieve the size of the code on target address, this needs assembly
204             length := extcodesize(_addr)
205 		}
206 		return (length>0);
207     }
208 }
209 
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_to != address(this));
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     emit Transfer(_from, _to, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    *
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param _spender The address which will spend the funds.
250    * @param _value The amount of tokens to be spent.
251    */
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     allowed[msg.sender][_spender] = _value;
254     emit Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    */
274   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
275     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
281     uint oldValue = allowed[msg.sender][_spender];
282     if (_subtractedValue > oldValue) {
283       allowed[msg.sender][_spender] = 0;
284     } else {
285       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286     }
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291 }
292 
293 
294 /**
295  * @title Startable
296  * @dev Base contract which allows owner to implement an start mechanism without ever being stopped more.
297  */
298 contract Startable is Ownable, Authorizable {
299   event Start();
300 
301   bool public started = false;
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is started.
305    */
306   modifier whenStarted() {
307 	require( started || authorized[msg.sender] );
308     _;
309   }
310 
311   /**
312    * @dev called by the owner to start, go to normal state
313    */
314   function start() onlyOwner public {
315     started = true;
316     emit Start();
317   }
318 }
319 
320 /**
321  * @title Startable token
322  *
323  * @dev StandardToken modified with startable transfers.
324  **/
325 
326 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
327 
328   /** ******************************** */
329   /** START: ADDED BY HORIZON GLOBEX   */
330   /** ******************************** */
331   
332   
333     // KYC submission hashes accepted by KYC service provider for AML/KYC review.
334     bytes32[] public kycHashes;
335 
336     // All users that have passed the external KYC verification checks.
337     address[] public kycValidated;
338 
339 	
340     /**
341      * The hash for all Know Your Customer information is calculated outside but stored here.
342      * This storage will be cleared once the ICO completes, see closeIco().
343      *
344      * ---- ICO-Platform Note ----
345      * The horizon-globex.com ICO platform's KYC app will register a hash of the Contributors
346      * KYC submission on the blockchain. Our Swiss financial-intermediary KYC provider will be 
347      * notified of the submission and retrieve the Contributor data for formal review.
348      *
349      * All Contributors must successfully complete our ICO KYC review prior to being allowed on-board.
350      * -- End ICO-Platform Note --
351      *
352      * @param sha   The hash of the customer data.
353     */
354     function setKycHash(bytes32 sha) public onlyOwner {
355         kycHashes.push(sha);
356     }
357 
358     /**
359      * A user has passed KYC verification, store them on the blockchain in the order it happened.
360      * This will be cleared once the ICO completes, see closeIco().
361      *
362      * ---- ICO-Platform Note ----
363      * The horizon-globex.com ICO platform's registered KYC provider submits their approval
364      * for this Contributor to particpate using the ICO-Platform portal. 
365      *
366      * Each Contributor will then be sent the Ethereum, Bitcoin and IBAN account numbers to
367      * deposit their Approved Contribution in exchange for VOX Tokens.
368      * -- End ICO-Platform Note --
369      *
370      * @param who   The user's address.
371      */
372     function kycApproved(address who) public onlyOwner {
373         require(who != 0x0, "Cannot approve a null address.");
374         kycValidated.push(who);
375     }
376 
377 	
378     /**
379      * Retrieve the KYC hash from the specified index.
380      *
381      * @param   index   The index into the array.
382      */
383     function getKycHash(uint256 index) public view returns (bytes32) {
384         return kycHashes[index];
385     }
386 
387     /**
388      * Retrieve the validated KYC address from the specified index.
389      *
390      * @param   index   The index into the array.
391      */
392     function getKycApproved(uint256 index) public view returns (address) {
393         return kycValidated[index];
394     }
395 
396 	
397     /**
398      * During the ICO phase the owner will allocate tokens once KYC completes and funds are deposited.
399      *
400      * ---- ICO-Platform Note ----
401      * The horizon-globex.com ICO platform's portal shall issue VOX Token to Contributors on receipt of 
402      * the Approved Contribution funds at the KYC providers Escrow account/wallets.
403      * Only after VOX Tokens are issued to the Contributor can the Swiss KYC provider allow the transfer
404      * of funds from their Escrow to Company.
405      *
406      * -- End ICO-Platform Note --
407      *
408      * @param to       The recipient of the tokens.
409      * @param value    The number of tokens to send.
410      */
411     function icoTransfer(address to, uint256 value) public onlyOwner {
412         // If an attempt is made to transfer more tokens than owned, transfer the remainder.
413         uint256 toTransfer = (value > (balances[msg.sender])) ? (balances[msg.sender]) : value;
414         
415         transferFunction(msg.sender, to, toTransfer);
416     }
417 
418 	/** ******************************** */
419 	/** END: ADDED BY HORIZON GLOBEX     */
420 	/** ******************************** */
421   
422   
423   function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
424     return super.transfer(_to, _value);
425   }
426   function transfer(address _to, uint256 _value, bytes _data) public whenStarted returns (bool) {
427     return super.transfer(_to, _value, _data);
428   }
429   function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenStarted returns (bool) {
430     return super.transfer(_to, _value, _data, _custom_fallback);
431   }
432 
433   function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
434     return super.transferFrom(_from, _to, _value);
435   }
436 
437   function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
438     return super.approve(_spender, _value);
439   }
440 
441   function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
442     return super.increaseApproval(_spender, _addedValue);
443   }
444 
445   function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
446     return super.decreaseApproval(_spender, _subtractedValue);
447   }
448 }
449 
450 contract HumanStandardToken is StandardToken, StartToken {
451     /* Approves and then calls the receiving contract */
452     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
453         approve(_spender, _value);
454         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
455         return true;
456     }
457 }
458 
459 contract BurnToken is StandardToken {
460     uint256 public initialSupply;
461 
462     event Burn(address indexed burner, uint256 value);
463 
464     /**
465      * @dev Function to burn tokens.
466      * @param _burner The address of token holder.
467      * @param _value The amount of token to be burned.
468      */
469     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
470         require(_value > 0);
471 		require(_value <= balances[_burner]);
472         // no need to require value <= totalSupply, since that would imply the
473         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
474 
475         balances[_burner] = balances[_burner].sub(_value);
476         totalSupply = totalSupply.sub(_value);
477         emit Burn(_burner, _value);
478 		return true;
479     }
480 
481     /**
482      * @dev Burns a specific amount of tokens.
483      * @param _value The amount of token to be burned.
484      */
485 	function burn(uint256 _value) public returns(bool) {
486         return burnFunction(msg.sender, _value);
487     }
488 
489 	/**
490 	* @dev Burns tokens from one address
491 	* @param _from address The address which you want to burn tokens from
492 	* @param _value uint256 the amount of tokens to be burned
493 	*/
494 	function burnFrom(address _from, uint256 _value) public returns (bool) {
495 		require(_value <= allowed[_from][msg.sender]); // check if it has the budget allowed
496 		burnFunction(_from, _value);
497 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
498 		return true;
499 	}
500 }
501 
502 contract Token is ERC223TokenCompatible, StandardToken, StartToken, HumanStandardToken  {
503     string public name;
504     string public symbol;
505     uint8 public decimals;
506     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
507         name = _name;
508         symbol = _symbol;
509         decimals = _decimals;
510         totalSupply = _totalSupply;
511         balances[msg.sender] = totalSupply;
512     }
513 }
514 
515 contract TokenBurn is Token, BurnToken {
516     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
517     Token(_name, _symbol, _decimals, _totalSupply) {
518         initialSupply = totalSupply;
519     }
520 }