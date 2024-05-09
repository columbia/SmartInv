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
84 contract MultiSend is Ownable {
85 	using SafeMath for uint256;
86 
87 
88 	Peculium public pecul; // token Peculium
89 	address public peculAdress = 0x3618516f45cd3c913f81f9987af41077932bc40d; // The address of the old Peculium contract	
90 	uint256 public decimals; // decimal of the token
91 	
92 		//Constructor
93 	function MultiSend() public{
94 		pecul = Peculium(peculAdress);	
95 		decimals = pecul.decimals();
96 	}
97 
98 	function Send(address[] _vaddr, uint256[] _vamounts) onlyOwner 
99 	{
100 	
101 	
102 		require ( _vaddr.length == _vamounts.length );
103 	
104 		uint256 amountToSendTotal = 0;
105 		
106 		for (uint256 indexTest=0; indexTest<_vaddr.length; indexTest++) // We first test that we have enough token to send
107 		{
108 		
109 			amountToSendTotal = amountToSendTotal + _vamounts[indexTest]; 
110 		
111 		}
112 		require(amountToSendTotal*10**decimals<=pecul.balanceOf(this)); // If no enough token, cancel the send 
113 		
114 		
115 		for (uint256 index=0; index<_vaddr.length; index++) 
116 		{
117 			address toAddress = _vaddr[index];
118 			uint256 amountTo_Send = _vamounts[index]*10**decimals;
119 		
120 	                pecul.transfer(toAddress,amountTo_Send);
121 		}
122 	}
123 	
124 	
125 	
126 }
127 
128 library SafeERC20 {
129   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
130     assert(token.transfer(to, value));
131   }
132 
133   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
134     assert(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(ERC20 token, address spender, uint256 value) internal {
138     assert(token.approve(spender, value));
139   }
140 }
141 
142 library SafeMath {
143   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
144     uint256 c = a * b;
145     assert(a == 0 || c / a == b);
146     return c;
147   }
148 
149   function div(uint256 a, uint256 b) internal constant returns (uint256) {
150     // assert(b > 0); // Solidity automatically throws when dividing by 0
151     uint256 c = a / b;
152     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153     return c;
154   }
155 
156   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   function add(uint256 a, uint256 b) internal constant returns (uint256) {
162     uint256 c = a + b;
163     assert(c >= a);
164     return c;
165   }
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
180     require(_to != address(0));
181 
182     uint256 _allowance = allowed[_from][msg.sender];
183 
184     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
185     // require (_value <= _allowance);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = _allowance.sub(_value);
190     Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    */
226   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
227     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
228     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229     return true;
230   }
231 
232   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 contract BurnableToken is StandardToken {
246 
247     event Burn(address indexed burner, uint256 value);
248 
249     /**
250      * @dev Burns a specific amount of tokens.
251      * @param _value The amount of token to be burned.
252      */
253     function burn(uint256 _value) public {
254         require(_value > 0);
255         require(_value <= balances[msg.sender]);
256         // no need to require value <= totalSupply, since that would imply the
257         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
258 
259         address burner = msg.sender;
260         balances[burner] = balances[burner].sub(_value);
261         totalSupply = totalSupply.sub(_value);
262         Burn(burner, _value);
263     }
264 }
265 
266 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
267 
268 	/*Variables about the old token contract */	
269 	PeculiumOld public peculOld; // The old Peculium token
270 	address public peculOldAdress = 0x53148Bb4551707edF51a1e8d7A93698d18931225; // The address of the old Peculium contract
271 
272 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
273 	using SafeERC20 for ERC20Basic; 
274 
275     	/* Public variables of the token for ERC20 compliance */
276 	string public name = "Peculium"; //token name 
277     	string public symbol = "PCL"; // token symbol
278     	uint256 public decimals = 8; // token number of decimal
279     	
280     	/* Public variables specific for Peculium */
281         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
282 
283 	mapping(address => bool) public balancesCannotSell; // The boolean variable, to frost the tokens
284 
285 
286     	/* Event for the freeze of account */
287 	event ChangedTokens(address changedTarget,uint256 amountToChanged);
288 	event FrozenFunds(address address_target, bool bool_canSell);
289 
290    
291 	//Constructor
292 	function Peculium() public {
293 		totalSupply = MAX_SUPPLY_NBTOKEN;
294 		balances[address(this)] = totalSupply; // At the beginning, the contract has all the tokens. 
295 		peculOld = PeculiumOld(peculOldAdress);	
296 	}
297 	
298 	/*** Public Functions of the contract ***/	
299 				
300 	function transfer(address _to, uint256 _value) public returns (bool) 
301 	{ // We overright the transfer function to allow freeze possibility
302 	
303 		require(balancesCannotSell[msg.sender]==false);
304 		return BasicToken.transfer(_to,_value);
305 	
306 	}
307 	
308 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
309 	{ // We overright the transferFrom function to allow freeze possibility
310 	
311 		require(balancesCannotSell[msg.sender]==false);	
312 		return StandardToken.transferFrom(_from,_to,_value);
313 	
314 	}
315 
316 	/***  Owner Functions of the contract ***/	
317 
318    	function ChangeLicense(address target, bool canSell) public onlyOwner
319    	{
320         
321         	balancesCannotSell[target] = canSell;
322         	FrozenFunds(target, canSell);
323     	
324     	}
325     	
326     		function UpgradeTokens() public
327 	{
328 	// Use this function to swap your old peculium against new ones (the new ones don't need defrost to be transfered)
329 	// Old peculium are burned
330 		require(peculOld.totalSupply()>0);
331 		uint256 amountChanged = peculOld.allowance(msg.sender,address(this));
332 		require(amountChanged>0);
333 		peculOld.transferFrom(msg.sender,address(this),amountChanged);
334 		peculOld.burn(amountChanged);
335 
336 		balances[address(this)] = balances[address(this)].sub(amountChanged);
337     		balances[msg.sender] = balances[msg.sender].add(amountChanged);
338 		Transfer(address(this), msg.sender, amountChanged);
339 		ChangedTokens(msg.sender,amountChanged);
340 		
341 	}
342 
343 	/*** Others Functions of the contract ***/	
344 	
345 	/* Approves and then calls the receiving contract */
346 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
347 		allowed[msg.sender][_spender] = _value;
348 		Approval(msg.sender, _spender, _value);
349 
350 		require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
351         	return true;
352     }
353 
354   	function getBlockTimestamp() public constant returns (uint256)
355   	{
356         	return now;
357   	}
358 
359   	function getOwnerInfos() public constant returns (address ownerAddr, uint256 ownerBalance)  
360   	{ // Return info about the public address and balance of the account of the owner of the contract
361     	
362     		ownerAddr = owner;
363 		ownerBalance = balanceOf(ownerAddr);
364   	
365   	}
366 
367 }
368 
369 contract PeculiumOld is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
370 
371 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
372 	using SafeERC20 for ERC20Basic; 
373 
374     	/* Public variables of the token for ERC20 compliance */
375 	string public name = "Peculium"; //token name 
376     	string public symbol = "PCL"; // token symbol
377     	uint256 public decimals = 8; // token number of decimal
378     	
379     	/* Public variables specific for Peculium */
380         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
381 
382 	uint256 public dateStartContract; // The date of the deployment of the token
383 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
384 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
385 
386 
387     	/* Event for the freeze of account */
388  	event FrozenFunds(address target, bool frozen);     	 
389      	event Defroze(address msgAdd, bool freeze);
390 	
391 
392 
393    
394 	//Constructor
395 	function PeculiumOld() {
396 		totalSupply = MAX_SUPPLY_NBTOKEN;
397 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
398 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
399 		
400 		dateStartContract=now;
401 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
402 
403 	}
404 
405 	/*** Public Functions of the contract ***/	
406 	
407 	function defrostToken() public 
408 	{ // Function to defrost your own token, after the date of the defrost
409 	
410 		require(now>dateDefrost);
411 		balancesCanSell[msg.sender]=true;
412 		Defroze(msg.sender,true);
413 	}
414 				
415 	function transfer(address _to, uint256 _value) public returns (bool) 
416 	{ // We overright the transfer function to allow freeze possibility
417 	
418 		require(balancesCanSell[msg.sender]);
419 		return BasicToken.transfer(_to,_value);
420 	
421 	}
422 	
423 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
424 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
425 	
426 		require(balancesCanSell[msg.sender]);	
427 		return StandardToken.transferFrom(_from,_to,_value);
428 	
429 	}
430 
431 	/***  Owner Functions of the contract ***/	
432 
433    	function freezeAccount(address target, bool canSell) onlyOwner 
434    	{
435         
436         	balancesCanSell[target] = canSell;
437         	FrozenFunds(target, canSell);
438     	
439     	}
440 
441 
442 	/*** Others Functions of the contract ***/	
443 	
444 	/* Approves and then calls the receiving contract */
445 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
446 		allowed[msg.sender][_spender] = _value;
447 		Approval(msg.sender, _spender, _value);
448 
449 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
450         	return true;
451     }
452 
453   	function getBlockTimestamp() constant returns (uint256)
454   	{
455         
456         	return now;
457   	
458   	}
459 
460   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
461   	{ // Return info about the public address and balance of the account of the owner of the contract
462     	
463     		ownerAddr = owner;
464 		ownerBalance = balanceOf(ownerAddr);
465   	
466   	}
467 
468 }