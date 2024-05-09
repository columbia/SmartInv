1 pragma solidity ^0.4.19;
2 
3 /**
4  * HauroPay Presale. More info www.hauropay.com. 
5  * Designed by www.coincrowd.it.
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a * b;
15     assert(a == 0 || c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46   
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() internal {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 
77 /**
78  * @title Authorizable
79  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
80  * functions, this simplifies the implementation of "multiple user permissions".
81  */
82 contract Authorizable is Ownable {
83   mapping(address => bool) public authorized;
84   
85   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
86 
87   /**
88    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
89    * account.
90    */ 
91   function Authorizable() public {
92 	authorized[msg.sender] = true;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the authorized.
97    */
98   modifier onlyAuthorized() {
99     require(authorized[msg.sender]);
100     _;
101   }
102 
103  /**
104    * @dev Allows the current owner to set an authorization.
105    * @param addressAuthorized The address to change authorization.
106    */
107   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
108     AuthorizationSet(addressAuthorized, authorization);
109     authorized[addressAuthorized] = authorization;
110   }
111   
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   uint256 public totalSupply;
122   function balanceOf(address who) public constant returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public constant returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 /**
139  * @title Basic token
140  * @dev Basic version of StandardToken, with no allowances.
141  */
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token from an address to another specified address 
149   * @param _sender The address to transfer from.
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
154     require(_to != address(0));
155     require(_to != address(this));
156     require(_value <= balances[_sender]);
157 
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[_sender] = balances[_sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     Transfer(_sender, _to, _value);
162     return true;
163   }
164   
165   /**
166   * @dev transfer token for a specified address (BasicToken transfer method)
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169 	return transferFunction(msg.sender, _to, _value);
170   }
171   
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public constant returns (uint256 balance) {
178     return balances[_owner];
179   }
180 }
181 
182 contract ERC223TokenCompatible is BasicToken {
183   using SafeMath for uint256;
184   
185   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
186 
187   // Function that is called when a user or another contract wants to transfer funds .
188 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
189 		require(_to != address(0));
190         require(_to != address(this));
191 		require(_value <= balances[msg.sender]);
192 		// SafeMath.sub will throw if there is not enough balance.
193         balances[msg.sender] = balances[msg.sender].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195 		if( isContract(_to) ) {
196 			_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data);
197 		} 
198 		Transfer(msg.sender, _to, _value, _data);
199 		return true;
200 	}
201 
202 	// Function that is called when a user or another contract wants to transfer funds .
203 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
204 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
205 	}
206 
207 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
208 	function isContract(address _addr) private view returns (bool is_contract) {
209 		uint256 length;
210 		assembly {
211             //retrieve the size of the code on target address, this needs assembly
212             length := extcodesize(_addr)
213 		}
214 		return (length>0);
215     }
216 }
217 
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_to != address(this));
240     require(_value <= balances[_from]);
241     require(_value <= allowed[_from][msg.sender]);
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    *
253    * Beware that changing an allowance with this method brings the risk that someone may use both the old
254    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint256 _value) public returns (bool) {
261     allowed[msg.sender][_spender] = _value;
262     Approval(msg.sender, _spender, _value);
263     return true;
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens that an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint256 specifying the amount of tokens still available for the spender.
271    */
272   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
273     return allowed[_owner][_spender];
274   }
275 
276   /**
277    * approve should be called when allowed[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    */
282   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
289     uint oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue > oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 
302 /**
303  * @title Startable
304  * @dev Base contract which allows owner to implement an start mechanism without ever being stopped more.
305  */
306 contract Startable is Ownable, Authorizable {
307   event Start();
308 
309   bool public started = false;
310 
311   /**
312    * @dev Modifier to make a function callable only when the contract is started.
313    */
314   modifier whenStarted() {
315 	require( started || authorized[msg.sender] );
316     _;
317   }
318 
319   /**
320    * @dev called by the owner to start, go to normal state
321    */
322   function start() onlyOwner public {
323     started = true;
324     Start();
325   }
326 }
327 
328 /**
329  * @title Startable token
330  *
331  * @dev StandardToken modified with startable transfers.
332  **/
333 
334 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
335 
336   function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
337     return super.transfer(_to, _value);
338   }
339   function transfer(address _to, uint256 _value, bytes _data) public whenStarted returns (bool) {
340     return super.transfer(_to, _value, _data);
341   }
342   function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenStarted returns (bool) {
343     return super.transfer(_to, _value, _data, _custom_fallback);
344   }
345 
346   function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
347     return super.transferFrom(_from, _to, _value);
348   }
349 
350   function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
351     return super.approve(_spender, _value);
352   }
353 
354   function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
355     return super.increaseApproval(_spender, _addedValue);
356   }
357 
358   function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
359     return super.decreaseApproval(_spender, _subtractedValue);
360   }
361 }
362 
363 contract HumanStandardToken is StandardToken, StartToken {
364     /* Approves and then calls the receiving contract */
365     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
366         approve(_spender, _value);
367         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
368         return true;
369     }
370 }
371 
372 contract BurnToken is StandardToken {
373 
374     event Burn(address indexed burner, uint256 value);
375 
376     /**
377      * @dev Function to burn tokens.
378      * @param _burner The address of token holder.
379      * @param _value The amount of token to be burned.
380      */
381     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
382         require(_value > 0);
383 		require(_value <= balances[_burner]);
384         // no need to require value <= totalSupply, since that would imply the
385         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
386 
387         balances[_burner] = balances[_burner].sub(_value);
388         totalSupply = totalSupply.sub(_value);
389         Burn(_burner, _value);
390 		return true;
391     }
392     
393     /**
394      * @dev Burns a specific amount of tokens.
395      * @param _value The amount of token to be burned.
396      */
397 	function burn(uint256 _value) public returns(bool) {
398         return burnFunction(msg.sender, _value);
399     }
400 	
401 	/**
402 	* @dev Burns tokens from one address
403 	* @param _from address The address which you want to burn tokens from
404 	* @param _value uint256 the amount of tokens to be burned
405 	*/
406 	function burnFrom(address _from, uint256 _value) public returns (bool) {
407 		require(_value <= allowed[_from][msg.sender]); // check if it has the budget allowed
408 		burnFunction(_from, _value);
409 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
410 		return true;
411 	}
412 }
413 
414 contract OriginToken is Authorizable, BasicToken, BurnToken {
415     
416     /**
417      * @dev transfer token from tx.orgin to a specified address (onlyAuthorized contract)
418      */ 
419     function originTransfer(address _to, uint256 _value) onlyAuthorized public returns (bool) {
420 	    return transferFunction(tx.origin, _to, _value);
421     }
422     
423     /**
424      * @dev Burns a specific amount of tokens from tx.orgin. (onlyAuthorized contract)
425      * @param _value The amount of token to be burned.
426      */	
427 	function originBurn(uint256 _value) onlyAuthorized public returns(bool) {
428         return burnFunction(tx.origin, _value);
429     }
430 }
431 
432 contract Token is ERC223TokenCompatible, StandardToken, StartToken, HumanStandardToken, BurnToken, OriginToken {
433 	uint256 public totalSupply;
434 	uint256 public initialSupply;
435 	uint8 public decimals;
436     string public name;
437     string public symbol;
438 
439     function Token(uint256 _totalSupply, uint8 _decimals, string _name, string _symbol) public {
440         decimals = _decimals;
441         totalSupply = _totalSupply * 10 ** uint(decimals);  
442         initialSupply = totalSupply;
443 		name = _name;
444 		symbol = _symbol;
445         balances[msg.sender] = totalSupply;
446         Transfer(0, msg.sender, totalSupply);
447     }
448 }
449 
450 contract Presale is Ownable {
451     using SafeMath for uint256;
452     Token public tokenContract;
453     
454 	uint8 public decimals;
455     uint256 public tokenValue;  // 1 Token in wei
456     uint256 public centToken; // euro cents value of 1 token 
457 
458     uint256 public endTime;  // seconds from 1970-01-01T00:00:00Z
459     uint256 public startTime;  // seconds from 1970-01-01T00:00:00Z
460 
461     function Presale() public {
462         //Configuration
463         centToken = 25; // Euro cents value of 1 token 
464         
465         tokenValue = 402693728269933; // centToken in wei of ether 04/12/2017
466         startTime = 1513625400; // 18/12/2017 20:30 UTC+1
467         endTime = 1516476600; // 20/01/2018 20:30 UTC+1
468 		
469 		uint256 totalSupply = 12000000; // 12.000.000 * 0.25€ = 3.000.000€ CAPPED
470 		decimals = 18;
471 		string memory name = "MethaVoucher";
472 		string memory symbol = "MTV";
473 		
474 		//End Configuration
475 		
476         tokenContract = new Token(totalSupply, decimals, name, symbol);
477 		//tokenContract.setAuthorized(this, true); // Authorizable constructor set msg.sender to true
478 		tokenContract.transferOwnership(msg.sender);
479     }
480 
481     address public updater;  // account in charge of updating the token value
482     event UpdateValue(uint256 newValue);
483 
484     function updateValue(uint256 newValue) public {
485         require(msg.sender == updater || msg.sender == owner);
486         tokenValue = newValue;
487         UpdateValue(newValue);
488     }
489 
490     function updateUpdater(address newUpdater) public onlyOwner {
491         updater = newUpdater;
492     }
493 
494     function updateTime(uint256 _newStart, uint256 _newEnd) public onlyOwner {
495         if ( _newStart != 0 ) startTime = _newStart;
496         if ( _newEnd != 0 ) endTime = _newEnd;
497     }
498     
499     event Buy(address buyer, uint256 value);
500 
501     function buy(address _buyer) public payable returns(uint256) {
502         require(now > startTime); // check if started
503         require(now < endTime); // check if ended
504         require(msg.value > 0);
505 		
506 		uint256 remainingTokens = tokenContract.balanceOf(this);
507         require( remainingTokens > 0 ); // Check if there are any remaining tokens 
508         
509         uint256 oneToken = 10 ** uint256(decimals);
510         uint256 tokenAmount = msg.value.mul(oneToken).div(tokenValue);
511         
512         if ( remainingTokens < tokenAmount ) {
513             uint256 refund = (tokenAmount - remainingTokens).mul(tokenValue).div(oneToken);
514             tokenAmount = remainingTokens;
515             owner.transfer(msg.value-refund);
516 			remainingTokens = 0; // set remaining token to 0
517              _buyer.transfer(refund);
518         } else {
519 			remainingTokens = remainingTokens.sub(tokenAmount); // update remaining token without bonus
520             owner.transfer(msg.value);
521         }
522         
523         tokenContract.transfer(_buyer, tokenAmount);
524         Buy(_buyer, tokenAmount);
525 		
526         return tokenAmount; 
527     }
528 
529     function withdraw(address to, uint256 value) public onlyOwner {
530         to.transfer(value);
531     }
532     
533     function updateTokenContract(address _tokenContract) public onlyOwner {
534         tokenContract = Token(_tokenContract);
535     }
536 
537     function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
538         return tokenContract.transfer(to, value);
539     }
540 
541     function () public payable {
542         buy(msg.sender);
543     }
544 }