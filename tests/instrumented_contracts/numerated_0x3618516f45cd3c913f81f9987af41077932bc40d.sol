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
84 library SafeERC20 {
85   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
86     assert(token.transfer(to, value));
87   }
88 
89   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
90     assert(token.transferFrom(from, to, value));
91   }
92 
93   function safeApprove(ERC20 token, address spender, uint256 value) internal {
94     assert(token.approve(spender, value));
95   }
96 }
97 
98 library SafeMath {
99   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
100     uint256 c = a * b;
101     assert(a == 0 || c / a == b);
102     return c;
103   }
104 
105   function div(uint256 a, uint256 b) internal constant returns (uint256) {
106     // assert(b > 0); // Solidity automatically throws when dividing by 0
107     uint256 c = a / b;
108     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109     return c;
110   }
111 
112   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   function add(uint256 a, uint256 b) internal constant returns (uint256) {
118     uint256 c = a + b;
119     assert(c >= a);
120     return c;
121   }
122 }
123 
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
136     require(_to != address(0));
137 
138     uint256 _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // require (_value <= _allowance);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * approve should be called when allowed[_spender] == 0. To increment
178    * allowed value is better to use this function to avoid 2 calls (and wait until
179    * the first transaction is mined)
180    * From MonolithDAO Token.sol
181    */
182   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
189     uint oldValue = allowed[msg.sender][_spender];
190     if (_subtractedValue > oldValue) {
191       allowed[msg.sender][_spender] = 0;
192     } else {
193       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194     }
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199 }
200 
201 contract BurnableToken is StandardToken {
202 
203     event Burn(address indexed burner, uint256 value);
204 
205     /**
206      * @dev Burns a specific amount of tokens.
207      * @param _value The amount of token to be burned.
208      */
209     function burn(uint256 _value) public {
210         require(_value > 0);
211         require(_value <= balances[msg.sender]);
212         // no need to require value <= totalSupply, since that would imply the
213         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
214 
215         address burner = msg.sender;
216         balances[burner] = balances[burner].sub(_value);
217         totalSupply = totalSupply.sub(_value);
218         Burn(burner, _value);
219     }
220 }
221 
222 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
223 
224 	/*Variables about the old token contract */	
225 	PeculiumOld public peculOld; // The old Peculium token
226 	address public peculOldAdress = 0x53148Bb4551707edF51a1e8d7A93698d18931225; // The address of the old Peculium contract
227 
228 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
229 	using SafeERC20 for ERC20Basic; 
230 
231     	/* Public variables of the token for ERC20 compliance */
232 	string public name = "Peculium"; //token name 
233     	string public symbol = "PCL"; // token symbol
234     	uint256 public decimals = 8; // token number of decimal
235     	
236     	/* Public variables specific for Peculium */
237         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
238 
239 	mapping(address => bool) public balancesCannotSell; // The boolean variable, to frost the tokens
240 
241 
242     	/* Event for the freeze of account */
243 	event ChangedTokens(address changedTarget,uint256 amountToChanged);
244 	event FrozenFunds(address address_target, bool bool_canSell);
245 
246    
247 	//Constructor
248 	function Peculium() public {
249 		totalSupply = MAX_SUPPLY_NBTOKEN;
250 		balances[address(this)] = totalSupply; // At the beginning, the contract has all the tokens. 
251 		peculOld = PeculiumOld(peculOldAdress);	
252 	}
253 	
254 	/*** Public Functions of the contract ***/	
255 				
256 	function transfer(address _to, uint256 _value) public returns (bool) 
257 	{ // We overright the transfer function to allow freeze possibility
258 	
259 		require(balancesCannotSell[msg.sender]==false);
260 		return BasicToken.transfer(_to,_value);
261 	
262 	}
263 	
264 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
265 	{ // We overright the transferFrom function to allow freeze possibility
266 	
267 		require(balancesCannotSell[msg.sender]==false);	
268 		return StandardToken.transferFrom(_from,_to,_value);
269 	
270 	}
271 
272 	/***  Owner Functions of the contract ***/	
273 
274    	function ChangeLicense(address target, bool canSell) public onlyOwner
275    	{
276         
277         	balancesCannotSell[target] = canSell;
278         	FrozenFunds(target, canSell);
279     	
280     	}
281     	
282     		function UpgradeTokens() public
283 	{
284 	// Use this function to swap your old peculium against new ones (the new ones don't need defrost to be transfered)
285 	// Old peculium are burned
286 		require(peculOld.totalSupply()>0);
287 		uint256 amountChanged = peculOld.allowance(msg.sender,address(this));
288 		require(amountChanged>0);
289 		peculOld.transferFrom(msg.sender,address(this),amountChanged);
290 		peculOld.burn(amountChanged);
291 
292 		balances[address(this)] = balances[address(this)].sub(amountChanged);
293     		balances[msg.sender] = balances[msg.sender].add(amountChanged);
294 		Transfer(address(this), msg.sender, amountChanged);
295 		ChangedTokens(msg.sender,amountChanged);
296 		
297 	}
298 
299 	/*** Others Functions of the contract ***/	
300 	
301 	/* Approves and then calls the receiving contract */
302 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
303 		allowed[msg.sender][_spender] = _value;
304 		Approval(msg.sender, _spender, _value);
305 
306 		require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
307         	return true;
308     }
309 
310   	function getBlockTimestamp() public constant returns (uint256)
311   	{
312         	return now;
313   	}
314 
315   	function getOwnerInfos() public constant returns (address ownerAddr, uint256 ownerBalance)  
316   	{ // Return info about the public address and balance of the account of the owner of the contract
317     	
318     		ownerAddr = owner;
319 		ownerBalance = balanceOf(ownerAddr);
320   	
321   	}
322 
323 }
324 
325 contract PeculiumOld is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
326 
327 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
328 	using SafeERC20 for ERC20Basic; 
329 
330     	/* Public variables of the token for ERC20 compliance */
331 	string public name = "Peculium"; //token name 
332     	string public symbol = "PCL"; // token symbol
333     	uint256 public decimals = 8; // token number of decimal
334     	
335     	/* Public variables specific for Peculium */
336         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
337 
338 	uint256 public dateStartContract; // The date of the deployment of the token
339 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
340 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
341 
342 
343     	/* Event for the freeze of account */
344  	event FrozenFunds(address target, bool frozen);     	 
345      	event Defroze(address msgAdd, bool freeze);
346 	
347 
348 
349    
350 	//Constructor
351 	function PeculiumOld() {
352 		totalSupply = MAX_SUPPLY_NBTOKEN;
353 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
354 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
355 		
356 		dateStartContract=now;
357 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
358 
359 	}
360 
361 	/*** Public Functions of the contract ***/	
362 	
363 	function defrostToken() public 
364 	{ // Function to defrost your own token, after the date of the defrost
365 	
366 		require(now>dateDefrost);
367 		balancesCanSell[msg.sender]=true;
368 		Defroze(msg.sender,true);
369 	}
370 				
371 	function transfer(address _to, uint256 _value) public returns (bool) 
372 	{ // We overright the transfer function to allow freeze possibility
373 	
374 		require(balancesCanSell[msg.sender]);
375 		return BasicToken.transfer(_to,_value);
376 	
377 	}
378 	
379 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
380 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
381 	
382 		require(balancesCanSell[msg.sender]);	
383 		return StandardToken.transferFrom(_from,_to,_value);
384 	
385 	}
386 
387 	/***  Owner Functions of the contract ***/	
388 
389    	function freezeAccount(address target, bool canSell) onlyOwner 
390    	{
391         
392         	balancesCanSell[target] = canSell;
393         	FrozenFunds(target, canSell);
394     	
395     	}
396 
397 
398 	/*** Others Functions of the contract ***/	
399 	
400 	/* Approves and then calls the receiving contract */
401 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
402 		allowed[msg.sender][_spender] = _value;
403 		Approval(msg.sender, _spender, _value);
404 
405 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
406         	return true;
407     }
408 
409   	function getBlockTimestamp() constant returns (uint256)
410   	{
411         
412         	return now;
413   	
414   	}
415 
416   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
417   	{ // Return info about the public address and balance of the account of the owner of the contract
418     	
419     		ownerAddr = owner;
420 		ownerBalance = balanceOf(ownerAddr);
421   	
422   	}
423 
424 }