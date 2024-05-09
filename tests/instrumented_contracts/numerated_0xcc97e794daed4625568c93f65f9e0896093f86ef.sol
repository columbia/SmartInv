1 pragma solidity 0.4.24;
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
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 }
88 
89 /**
90  * @title Authorizable
91  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
92  * functions, this simplifies the implementation of "multiple user permissions".
93  */
94 contract Authorizable is Ownable {
95   mapping(address => bool) public authorized;
96   
97   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
98 
99   /**
100    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
101    * account.
102    */ 
103   constructor() public {
104 	authorized[msg.sender] = true;
105   }
106 
107   /**
108    * @dev Throws if called by any account other than the authorized.
109    */
110   modifier onlyAuthorized() {
111     require(authorized[msg.sender]);
112     _;
113   }
114 
115  /**
116    * @dev Allows the current owner to set an authorization.
117    * @param addressAuthorized The address to change authorization.
118    */
119   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
120     emit AuthorizationSet(addressAuthorized, authorization);
121     authorized[addressAuthorized] = authorization;
122   }
123   
124 }
125 
126 
127 /**
128  * @title Pausable
129  * @dev Base contract which allows children to implement an emergency stop mechanism.
130  */
131 contract Pausable is Ownable, Authorizable {
132   event Pause();
133   event Unpause();
134 
135   bool public paused = false;
136 
137 
138   /**
139    * @dev Modifier to make a function callable only when the contract is not paused.
140    */
141   modifier whenNotPaused() {
142     require(!paused);
143     _;
144   }
145 
146   /**
147    * @dev Modifier to make a function callable only when the contract is paused.
148    */
149   modifier whenPaused() {
150     require(paused);
151     _;
152   }
153 
154   /**
155    * @dev called by the owner to pause, triggers stopped state
156    */
157   function pause() onlyOwner whenNotPaused public {
158     paused = true;
159     emit Pause();
160   }
161 
162   /**
163    * @dev called by the owner to unpause, returns to normal state
164    */
165   function unpause() onlyOwner whenPaused public {
166     paused = false;
167     emit Unpause();
168   }
169 }
170 
171 
172 
173 contract Token {
174     uint256 public totalSupply;
175     function balanceOf(address _owner) public view returns (uint256 balance);
176     function transfer(address _to, uint256 _value) public returns (bool success);
177     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
178     function approve(address _spender, uint256 _value) public returns (bool success);
179     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
180     event Transfer(address indexed _from, address indexed _to, uint256 _value);
181     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
182 }
183 
184 
185 
186 
187 /**
188  * @title Reference implementation of the ERC220 standard token.
189  */
190 contract StandardToken is Token {
191  
192     function transfer(address _to, uint256 _value) public returns (bool success) {
193        require(balances[msg.sender] >= _value);      
194        balances[msg.sender] -= _value;
195        balances[_to] += _value;
196        emit Transfer(msg.sender, _to, _value);
197        return true;
198     }
199  
200     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
201      	require(balances[msg.sender] >= _value); 
202         require(allowed[_from][msg.sender] >= _value); 
203         balances[_to] += _value;
204         balances[_from] -= _value;
205         allowed[_from][msg.sender] -= _value;
206         emit Transfer(_from, _to, _value);
207         return true;
208     }
209  
210     function balanceOf(address _owner) public view returns (uint256 balance) {
211         return balances[_owner];
212     }
213  
214     function approve(address _spender, uint256 _value) public returns (bool success) {
215         require(_value == 0 || allowed[msg.sender][_spender] == 0);
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220  
221     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
222       return allowed[_owner][_spender];
223     }
224  
225     mapping (address => uint256) public balances;
226     mapping (address => mapping (address => uint256)) public allowed;
227 }
228 
229 contract BurnableToken is StandardToken, Ownable {
230 
231     event Burn(address indexed burner, uint256 amount);
232 
233     /**
234     * @dev Anybody can burn a specific amount of their tokens.
235     * @param _amount The amount of token to be burned.
236     */
237     function burn(uint256 _amount) public {
238         require(_amount > 0);
239         require(_amount <= balances[msg.sender]);
240         // no need to require _amount <= totalSupply, since that would imply the
241         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
242 
243         address burner = msg.sender;
244         balances[burner] = SafeMath.sub(balances[burner],_amount);
245         totalSupply = SafeMath.sub(totalSupply,_amount);
246         emit Transfer(burner, address(0), _amount);
247         emit Burn(burner, _amount);
248     }
249 
250     /**
251     * @dev Owner can burn a specific amount of tokens of other token holders.
252     * @param _from The address of token holder whose tokens to be burned.
253     * @param _amount The amount of token to be burned.
254     */
255     function burnFrom(address _from, uint256 _amount) onlyOwner public {
256         require(_from != address(0));
257         require(_amount > 0);
258         require(_amount <= balances[_from]);
259         balances[_from] = SafeMath.sub(balances[_from],_amount);
260         totalSupply = SafeMath.sub(totalSupply,_amount);
261         emit Transfer(_from, address(0), _amount);
262         emit Burn(_from, _amount);
263     }
264 
265 }
266 
267 contract BlockPausableToken is StandardToken, Pausable,BurnableToken {
268 
269   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
270     return super.transfer(_to, _value);
271   }
272 
273   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
274     return super.transferFrom(_from, _to, _value);
275   }
276 
277   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
278     return super.approve(_spender, _value);
279   }
280 
281  
282 }
283 
284 contract BlockToken is BlockPausableToken {
285  using SafeMath for uint;
286     // metadata
287     string public constant name = "Block66";
288     string public constant symbol = "B66";
289     uint256 public constant decimals = 18;
290     
291    	address private ethFundDeposit;     
292    	
293    	address private bugFundDeposit;      // deposit address for tokens for bug bounty for TGE 
294 	uint256 public constant bugFund = 13.5 * (10**6) * 10**decimals;   // bug reserved
295 			
296 	address private b66AdvisorFundDeposit;       
297 	uint256 public constant b66AdvisorFundDepositAmt = 13.5 * (10**6) * 10**decimals;   
298     	
299 	address private b66ReserveFundDeposit;  
300 	uint256 public constant b66ReserveTokens = 138 * (10**6) * 10**decimals;  
301     	
302 	uint256 public icoTokenExchangeRate = 715; // 715 b66 tokens per 1 ETH
303 	uint256 public tokenCreationCap =  300 * (10**6) * 10**decimals;  
304 	
305 	//address public ;
306 	// crowdsale parameters
307    	bool public tokenSaleActive;              // switched to true in operational state
308 	bool public haltIco;
309 	bool public dead = false;
310 	bool public privateEquityClaimed;
311 	// placeholder to check eth raised amount 
312 	uint256 public ethRaised = 0;
313 	// placeholder variable to check address 
314 	address public checkaddress;
315 
316  
317     // events 
318     event CreateToken(address indexed _to, uint256 _value);
319     event Transfer(address from, address to, uint256 value);
320     event TokenSaleFinished
321       (
322         uint256 totalSupply
323   	);
324     event PrivateEquityReserveBlock(uint256 _value);
325     // constructor
326     constructor (		
327        	address _ethFundDeposit,
328        	address _bugFundDeposit,
329 		address _b66AdvisorFundDeposit,	
330 		address _b66ReserveFundDeposit
331 
332         	) public {
333         	
334 		tokenSaleActive = true;                   
335 		haltIco = true;
336 		privateEquityClaimed=false;	
337 		require(_ethFundDeposit != address(0));
338 		require(_bugFundDeposit != address(0));	
339 		require(_b66AdvisorFundDeposit != address(0));
340 		require(_b66ReserveFundDeposit != address(0));
341 		
342 		ethFundDeposit = _ethFundDeposit;
343 		b66ReserveFundDeposit=_b66ReserveFundDeposit;
344 		bugFundDeposit = _bugFundDeposit;
345 		balances[bugFundDeposit] = bugFund;    // Deposit bug funds
346 		emit CreateToken(bugFundDeposit, bugFund);  // logs bug funds
347 		totalSupply = SafeMath.add(totalSupply, bugFund);  
348 		b66AdvisorFundDeposit = _b66AdvisorFundDeposit;				
349 		balances[b66AdvisorFundDeposit] = b66AdvisorFundDepositAmt;     
350 		emit CreateToken(b66AdvisorFundDeposit, b66AdvisorFundDepositAmt); 
351 		
352 		totalSupply = SafeMath.add(totalSupply, b66AdvisorFundDepositAmt);  				
353 		paused = true;
354     }
355 
356     
357 	
358     /// @dev Accepts ether and creates new tge tokens.
359     function createTokens() payable external {
360       if (!tokenSaleActive) 
361         revert();
362 	  if (haltIco) 
363 	    revert();
364 	  
365       if (msg.value == 0) 
366         revert();
367       uint256 tokens;
368       tokens = SafeMath.mul(msg.value, icoTokenExchangeRate); // check that we're not over totals
369       uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
370  
371       // return money if something goes wrong
372       if (tokenCreationCap < checkedSupply) 
373         revert();  // odd fractions won't be found
374  
375       totalSupply = checkedSupply;
376       balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
377       emit CreateToken(msg.sender, tokens);  // logs token creation
378     }  
379 	 
380 	
381     function mint(address _privSaleAddr,uint _privFundAmt) onlyAuthorized external {
382     	  require(tokenSaleActive == true);
383 	  uint256 privToken = _privFundAmt*10**decimals;
384           uint256 checkedSupply = SafeMath.add(totalSupply, privToken);     
385           // return money if something goes wrong
386           if (tokenCreationCap < checkedSupply) 
387             revert();  // odd fractions won't be found     
388           totalSupply = checkedSupply;
389           balances[_privSaleAddr] += privToken;  // safeAdd not needed; bad semantics to use here		  
390           emit CreateToken (_privSaleAddr, privToken);  // logs token creation
391     }
392     
393   
394     
395     function setIcoTokenExchangeRate (uint _icoTokenExchangeRate) onlyOwner external {		
396     	icoTokenExchangeRate = _icoTokenExchangeRate;            
397     }
398         
399 
400     function setHaltIco(bool _haltIco) onlyOwner external {
401 	haltIco = _haltIco;            
402     }
403 
404 	// 5760 blocks in a day : 2102400 blocks in a year:: locked till 9/1/2019
405      function vestPartnerEquityReserve() onlyOwner external {
406         emit  PrivateEquityReserveBlock(block.number);
407         require(!privateEquityClaimed);
408         //TODO need to put the right block number
409      	require(block.number > 8357500);
410 	balances[b66ReserveFundDeposit] = b66ReserveTokens;     
411     	emit CreateToken(b66ReserveFundDeposit, b66ReserveTokens);          
412     	totalSupply = SafeMath.add(totalSupply, b66ReserveTokens);  // logs token creation  
413     	privateEquityClaimed=true;
414     }
415     
416     function setReserveFundDepositAddress(address _b66ReserveFundDeposit) onlyOwner external {
417     	  require(_b66ReserveFundDeposit != address(0));
418           b66ReserveFundDeposit=_b66ReserveFundDeposit;
419     } 
420     
421      /// @dev Ends the funding period and sends the ETH home
422     function sendFundHome() onlyOwner external {  // move to operational
423       if (!ethFundDeposit.send(address(this).balance)) 
424         revert();  // send the eth to tge International
425     } 
426 	
427     function sendFundHomeAmt(uint _amt) onlyOwner external {
428       if (!ethFundDeposit.send(_amt*10**decimals)) 
429         revert();  // send the eth to tge International
430     }    
431     
432       function toggleDead()
433           external
434           onlyOwner
435           returns (bool)
436         {
437           dead = !dead;
438       }
439      
440         function endIco() onlyOwner external { // end ICO
441           // ensure that sale is active. is set to false at the end. can only be performed once.
442           require(tokenSaleActive == true);
443           tokenSaleActive = false;
444     	 // dispatch event showing sale is finished
445     	    emit TokenSaleFinished(
446     	      totalSupply
447         );
448         }  
449     
450      // fallback function - do not allow any eth transfers to this contract
451       function()
452         external
453       {
454         revert();
455   	}
456   	
457   	
458 	/// @dev Ends the funding period and sends the ETH home
459 	function checkEthRaised() onlyAuthorized external returns(uint256 balance) {
460 	ethRaised = address(this).balance;
461 	return ethRaised;  
462 	} 
463 	 
464 
465 	/// @dev Ends the funding period and sends the ETH home
466 	function checkEthFundDepositAddress() onlyAuthorized external returns(address) {
467 	  checkaddress = ethFundDeposit;
468 	  return checkaddress;  
469 	} 
470 }