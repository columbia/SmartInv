1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14   /**
15   * @dev transfer token for a specified address
16   * @param _to The address to transfer to.
17   * @param _value The amount to be transferred.
18   */
19   function transfer(address _to, uint256 _value) public returns (bool) {
20     require(_to != address(0));
21 
22     // SafeMath.sub will throw if there is not enough balance.
23     balances[msg.sender] = balances[msg.sender].sub(_value);
24     balances[_to] = balances[_to].add(_value);
25     Transfer(msg.sender, _to, _value);
26     return true;
27   }
28 
29   /**
30   * @dev Gets the balance of the specified address.
31   * @param _owner The address to query the the balance of.
32   * @return An uint256 representing the amount owned by the passed address.
33   */
34   function balanceOf(address _owner) public constant returns (uint256 balance) {
35     return balances[_owner];
36   }
37 
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public constant returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   function Ownable() {
59     owner = msg.sender;
60   }
61 
62 
63   /**
64    * @dev Throws if called by any account other than the owner.
65    */
66   modifier onlyOwner() {
67     require(msg.sender == owner);
68     _;
69   }
70 
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) onlyOwner public {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 contract LockedSecretChallenge is Ownable  {
85 	using SafeMath for uint256;
86 
87 	
88 	/*Variables about the token contract */	
89 	Peculium public pecul; // The Peculium token
90 	uint256 decimals;
91 	bool public initPecul; // boolean to know if the Peculium token address has been init
92 	event InitializedToken(address contractToken);
93 
94 	uint256 startdate;
95 	uint256 degeldate;
96 
97 
98 	address[10] challengeAddress;
99 	uint256[10] challengeAmount;
100 	bool public initChallenge;
101 	event InitializedChallengeAddress(address[10] challengeA, uint256[10] challengeT);
102 	
103 	//Constructor
104 	constructor() {
105 		startdate = now;
106 		degeldate = 1551890520; // timestamp for 6 March 2019 : 17h42:00
107 		}
108 	
109 	
110 	/***  Functions of the contract ***/
111 	
112 	function InitPeculiumAdress(address peculAdress) public onlyOwner 
113 	{ // We init the address of the token
114 	
115 		pecul = Peculium(peculAdress);
116 		decimals = pecul.decimals();
117 		initPecul = true;
118 		emit InitializedToken(peculAdress);
119 	
120 	}
121 	
122 	function InitChallengeAddress(address[] addressC) public onlyOwner Initialize {
123 	
124 		for(uint256 i=0; i<challengeAddress.length;i++){
125 			challengeAddress[i] = addressC[i];
126 			challengeAmount[i] = 1000000;
127 		}
128 		emit InitializedChallengeAddress(challengeAddress,challengeAmount);
129 	}
130 		
131 	function transferFinal() public onlyOwner Initialize InitializeChallengeAddress
132 	{ // Transfer pecul for the Bounty manager
133 		
134 		require(now >= degeldate);
135 		require ( challengeAddress.length == challengeAmount.length );
136 		
137 		for(uint256 i=0; i<challengeAddress.length;i++){
138 			require(challengeAddress[i]!=0x0);
139 		}
140 		uint256 amountToSendTotal = 0;
141 		
142 		for (uint256 indexTest=0; indexTest<challengeAmount.length; indexTest++) // We first test that we have enough token to send
143 		{
144 		
145 			amountToSendTotal = amountToSendTotal + challengeAmount[indexTest]; 
146 		
147 		}
148 		require(amountToSendTotal*10**decimals<=pecul.balanceOf(this)); // If no enough token, cancel the send 
149 		
150 		
151 		for (uint256 index=0; index<challengeAddress.length; index++) 
152 		{
153 			address toAddress = challengeAddress[index];
154 			uint256 amountTo_Send = challengeAmount[index]*10**decimals;
155 		
156 	                pecul.transfer(toAddress,amountTo_Send);
157 		}
158 
159 				
160 	}
161 	
162 	function emergency() public onlyOwner 
163 	{ // In case of bug or emergency, resend all tokens to initial sender
164 		pecul.transfer(owner,pecul.balanceOf(this));
165 	}
166 	
167 		/***  Modifiers of the contract ***/
168 	modifier InitializeChallengeAddress { // We need to initialize first the token contract
169 		require (initChallenge==true);
170 		_;
171     	}
172 
173 	
174 	modifier Initialize { // We need to initialize first the token contract
175 		require (initPecul==true);
176 		_;
177     	}
178 
179 }
180 
181 library SafeERC20 {
182   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
183     assert(token.transfer(to, value));
184   }
185 
186   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
187     assert(token.transferFrom(from, to, value));
188   }
189 
190   function safeApprove(ERC20 token, address spender, uint256 value) internal {
191     assert(token.approve(spender, value));
192   }
193 }
194 
195 library SafeMath {
196   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
197     uint256 c = a * b;
198     assert(a == 0 || c / a == b);
199     return c;
200   }
201 
202   function div(uint256 a, uint256 b) internal constant returns (uint256) {
203     // assert(b > 0); // Solidity automatically throws when dividing by 0
204     uint256 c = a / b;
205     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206     return c;
207   }
208 
209   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
210     assert(b <= a);
211     return a - b;
212   }
213 
214   function add(uint256 a, uint256 b) internal constant returns (uint256) {
215     uint256 c = a + b;
216     assert(c >= a);
217     return c;
218   }
219 }
220 
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225 
226   /**
227    * @dev Transfer tokens from one address to another
228    * @param _from address The address which you want to send tokens from
229    * @param _to address The address which you want to transfer to
230    * @param _value uint256 the amount of tokens to be transferred
231    */
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
233     require(_to != address(0));
234 
235     uint256 _allowance = allowed[_from][msg.sender];
236 
237     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
238     // require (_value <= _allowance);
239 
240     balances[_from] = balances[_from].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     allowed[_from][msg.sender] = _allowance.sub(_value);
243     Transfer(_from, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    *
250    * Beware that changing an allowance with this method brings the risk that someone may use both the old
251    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
252    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
253    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254    * @param _spender The address which will spend the funds.
255    * @param _value The amount of tokens to be spent.
256    */
257   function approve(address _spender, uint256 _value) public returns (bool) {
258     allowed[msg.sender][_spender] = _value;
259     Approval(msg.sender, _spender, _value);
260     return true;
261   }
262 
263   /**
264    * @dev Function to check the amount of tokens that an owner allowed to a spender.
265    * @param _owner address The address which owns the funds.
266    * @param _spender address The address which will spend the funds.
267    * @return A uint256 specifying the amount of tokens still available for the spender.
268    */
269   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    */
279   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296 }
297 
298 contract BurnableToken is StandardToken {
299 
300     event Burn(address indexed burner, uint256 value);
301 
302     /**
303      * @dev Burns a specific amount of tokens.
304      * @param _value The amount of token to be burned.
305      */
306     function burn(uint256 _value) public {
307         require(_value > 0);
308         require(_value <= balances[msg.sender]);
309         // no need to require value <= totalSupply, since that would imply the
310         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
311 
312         address burner = msg.sender;
313         balances[burner] = balances[burner].sub(_value);
314         totalSupply = totalSupply.sub(_value);
315         Burn(burner, _value);
316     }
317 }
318 
319 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
320 
321 	/*Variables about the old token contract */	
322 	PeculiumOld public peculOld; // The old Peculium token
323 	address public peculOldAdress = 0x53148Bb4551707edF51a1e8d7A93698d18931225; // The address of the old Peculium contract
324 
325 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
326 	using SafeERC20 for ERC20Basic; 
327 
328     	/* Public variables of the token for ERC20 compliance */
329 	string public name = "Peculium"; //token name 
330     	string public symbol = "PCL"; // token symbol
331     	uint256 public decimals = 8; // token number of decimal
332     	
333     	/* Public variables specific for Peculium */
334         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
335 
336 	mapping(address => bool) public balancesCannotSell; // The boolean variable, to frost the tokens
337 
338 
339     	/* Event for the freeze of account */
340 	event ChangedTokens(address changedTarget,uint256 amountToChanged);
341 	event FrozenFunds(address address_target, bool bool_canSell);
342 
343    
344 	//Constructor
345 	function Peculium() public {
346 		totalSupply = MAX_SUPPLY_NBTOKEN;
347 		balances[address(this)] = totalSupply; // At the beginning, the contract has all the tokens. 
348 		peculOld = PeculiumOld(peculOldAdress);	
349 	}
350 	
351 	/*** Public Functions of the contract ***/	
352 				
353 	function transfer(address _to, uint256 _value) public returns (bool) 
354 	{ // We overright the transfer function to allow freeze possibility
355 	
356 		require(balancesCannotSell[msg.sender]==false);
357 		return BasicToken.transfer(_to,_value);
358 	
359 	}
360 	
361 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
362 	{ // We overright the transferFrom function to allow freeze possibility
363 	
364 		require(balancesCannotSell[msg.sender]==false);	
365 		return StandardToken.transferFrom(_from,_to,_value);
366 	
367 	}
368 
369 	/***  Owner Functions of the contract ***/	
370 
371    	function ChangeLicense(address target, bool canSell) public onlyOwner
372    	{
373         
374         	balancesCannotSell[target] = canSell;
375         	FrozenFunds(target, canSell);
376     	
377     	}
378     	
379     		function UpgradeTokens() public
380 	{
381 	// Use this function to swap your old peculium against new ones (the new ones don't need defrost to be transfered)
382 	// Old peculium are burned
383 		require(peculOld.totalSupply()>0);
384 		uint256 amountChanged = peculOld.allowance(msg.sender,address(this));
385 		require(amountChanged>0);
386 		peculOld.transferFrom(msg.sender,address(this),amountChanged);
387 		peculOld.burn(amountChanged);
388 
389 		balances[address(this)] = balances[address(this)].sub(amountChanged);
390     		balances[msg.sender] = balances[msg.sender].add(amountChanged);
391 		Transfer(address(this), msg.sender, amountChanged);
392 		ChangedTokens(msg.sender,amountChanged);
393 		
394 	}
395 
396 	/*** Others Functions of the contract ***/	
397 	
398 	/* Approves and then calls the receiving contract */
399 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
400 		allowed[msg.sender][_spender] = _value;
401 		Approval(msg.sender, _spender, _value);
402 
403 		require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
404         	return true;
405     }
406 
407   	function getBlockTimestamp() public constant returns (uint256)
408   	{
409         	return now;
410   	}
411 
412   	function getOwnerInfos() public constant returns (address ownerAddr, uint256 ownerBalance)  
413   	{ // Return info about the public address and balance of the account of the owner of the contract
414     	
415     		ownerAddr = owner;
416 		ownerBalance = balanceOf(ownerAddr);
417   	
418   	}
419 
420 }
421 
422 contract PeculiumOld is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
423 
424 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
425 	using SafeERC20 for ERC20Basic; 
426 
427     	/* Public variables of the token for ERC20 compliance */
428 	string public name = "Peculium"; //token name 
429     	string public symbol = "PCL"; // token symbol
430     	uint256 public decimals = 8; // token number of decimal
431     	
432     	/* Public variables specific for Peculium */
433         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
434 
435 	uint256 public dateStartContract; // The date of the deployment of the token
436 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
437 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
438 
439 
440     	/* Event for the freeze of account */
441  	event FrozenFunds(address target, bool frozen);     	 
442      	event Defroze(address msgAdd, bool freeze);
443 	
444 
445 
446    
447 	//Constructor
448 	function PeculiumOld() {
449 		totalSupply = MAX_SUPPLY_NBTOKEN;
450 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
451 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
452 		
453 		dateStartContract=now;
454 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
455 
456 	}
457 
458 	/*** Public Functions of the contract ***/	
459 	
460 	function defrostToken() public 
461 	{ // Function to defrost your own token, after the date of the defrost
462 	
463 		require(now>dateDefrost);
464 		balancesCanSell[msg.sender]=true;
465 		Defroze(msg.sender,true);
466 	}
467 				
468 	function transfer(address _to, uint256 _value) public returns (bool) 
469 	{ // We overright the transfer function to allow freeze possibility
470 	
471 		require(balancesCanSell[msg.sender]);
472 		return BasicToken.transfer(_to,_value);
473 	
474 	}
475 	
476 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
477 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
478 	
479 		require(balancesCanSell[msg.sender]);	
480 		return StandardToken.transferFrom(_from,_to,_value);
481 	
482 	}
483 
484 	/***  Owner Functions of the contract ***/	
485 
486    	function freezeAccount(address target, bool canSell) onlyOwner 
487    	{
488         
489         	balancesCanSell[target] = canSell;
490         	FrozenFunds(target, canSell);
491     	
492     	}
493 
494 
495 	/*** Others Functions of the contract ***/	
496 	
497 	/* Approves and then calls the receiving contract */
498 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
499 		allowed[msg.sender][_spender] = _value;
500 		Approval(msg.sender, _spender, _value);
501 
502 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
503         	return true;
504     }
505 
506   	function getBlockTimestamp() constant returns (uint256)
507   	{
508         
509         	return now;
510   	
511   	}
512 
513   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
514   	{ // Return info about the public address and balance of the account of the owner of the contract
515     	
516     		ownerAddr = owner;
517 		ownerBalance = balanceOf(ownerAddr);
518   	
519   	}
520 
521 }