1 pragma solidity ^0.4.18;
2 
3 /**
4  * CoinCrowd Token (XCC). More info www.coincrowd.it
5  */
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45   
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() internal {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 
76 /**
77  * @title Authorizable
78  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
79  * functions, this simplifies the implementation of "multiple user permissions".
80  */
81 contract Authorizable is Ownable {
82   mapping(address => bool) public authorized;
83   
84   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
85 
86   /**
87    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
88    * account.
89    */ 
90   function Authorizable() public {
91 	authorized[msg.sender] = true;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the authorized.
96    */
97   modifier onlyAuthorized() {
98     require(authorized[msg.sender]);
99     _;
100   }
101 
102  /**
103    * @dev Allows the current owner to set an authorization.
104    * @param addressAuthorized The address to change authorization.
105    */
106   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
107     AuthorizationSet(addressAuthorized, authorization);
108     authorized[addressAuthorized] = authorization;
109   }
110   
111 }
112 
113 
114 /**
115  * @title ERC20Basic
116  * @dev Simpler version of ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/179
118  */
119 contract ERC20Basic {
120   uint256 public totalSupply;
121   function balanceOf(address who) public constant returns (uint256);
122   function transfer(address to, uint256 value) public returns (bool);
123   event Transfer(address indexed from, address indexed to, uint256 value);
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public constant returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   /**
147   * @dev transfer token from an address to another specified address 
148   * @param _sender The address to transfer from.
149   * @param _to The address to transfer to.
150   * @param _value The amount to be transferred.
151   */
152   function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
153     require(_to != address(0));
154     require(_to != address(this));
155     require(_value <= balances[_sender]);
156 
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[_sender] = balances[_sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(_sender, _to, _value);
161     return true;
162   }
163   
164   /**
165   * @dev transfer token for a specified address (BasicToken transfer method)
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168 	return transferFunction(msg.sender, _to, _value);
169   }
170   
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public constant returns (uint256 balance) {
177     return balances[_owner];
178   }
179 }
180 
181 contract ERC223TokenCompatible is BasicToken {
182   using SafeMath for uint256;
183   
184   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
185 
186   // Function that is called when a user or another contract wants to transfer funds .
187 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
188 		require(_to != address(0));
189         require(_to != address(this));
190 		require(_value <= balances[msg.sender]);
191 		// SafeMath.sub will throw if there is not enough balance.
192         balances[msg.sender] = balances[msg.sender].sub(_value);
193         balances[_to] = balances[_to].add(_value);
194 		if( isContract(_to) ) {
195 			_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data);
196 		} 
197 		Transfer(msg.sender, _to, _value, _data);
198 		return true;
199 	}
200 
201 	// Function that is called when a user or another contract wants to transfer funds .
202 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
203 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
204 	}
205 
206 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
207 	function isContract(address _addr) private view returns (bool is_contract) {
208 		uint256 length;
209 		assembly {
210             //retrieve the size of the code on target address, this needs assembly
211             length := extcodesize(_addr)
212 		}
213 		return (length>0);
214     }
215 }
216 
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * @dev https://github.com/ethereum/EIPs/issues/20
223  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237     require(_to != address(0));
238     require(_to != address(this));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * approve should be called when allowed[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    */
281   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 
301 /**
302  * @title Startable
303  * @dev Base contract which allows owner to implement an start mechanism without ever being stopped more.
304  */
305 contract Startable is Ownable, Authorizable {
306   event Start();
307 
308   bool public started = false;
309 
310   /**
311    * @dev Modifier to make a function callable only when the contract is started.
312    */
313   modifier whenStarted() {
314 	require( started || authorized[msg.sender] );
315     _;
316   }
317 
318   /**
319    * @dev called by the owner to start, go to normal state
320    */
321   function start() onlyOwner public {
322     started = true;
323     Start();
324   }
325 }
326 
327 /**
328  * @title Startable token
329  *
330  * @dev StandardToken modified with startable transfers.
331  **/
332 
333 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
334 
335   function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
336     return super.transfer(_to, _value);
337   }
338   function transfer(address _to, uint256 _value, bytes _data) public whenStarted returns (bool) {
339     return super.transfer(_to, _value, _data);
340   }
341   function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenStarted returns (bool) {
342     return super.transfer(_to, _value, _data, _custom_fallback);
343   }
344 
345   function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
346     return super.transferFrom(_from, _to, _value);
347   }
348 
349   function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
350     return super.approve(_spender, _value);
351   }
352 
353   function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
354     return super.increaseApproval(_spender, _addedValue);
355   }
356 
357   function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
358     return super.decreaseApproval(_spender, _subtractedValue);
359   }
360 }
361 
362 contract HumanStandardToken is StandardToken, StartToken {
363     /* Approves and then calls the receiving contract */
364     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
365         approve(_spender, _value);
366         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
367         return true;
368     }
369 }
370 
371 contract BurnToken is StandardToken {
372 
373     event Burn(address indexed burner, uint256 value);
374 
375     /**
376      * @dev Function to burn tokens.
377      * @param _burner The address of token holder.
378      * @param _value The amount of token to be burned.
379      */
380     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
381         require(_value > 0);
382 		require(_value <= balances[_burner]);
383         // no need to require value <= totalSupply, since that would imply the
384         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
385 
386         balances[_burner] = balances[_burner].sub(_value);
387         totalSupply = totalSupply.sub(_value);
388         Burn(_burner, _value);
389 		return true;
390     }
391     
392     /**
393      * @dev Burns a specific amount of tokens.
394      * @param _value The amount of token to be burned.
395      */
396 	function burn(uint256 _value) public returns(bool) {
397         return burnFunction(msg.sender, _value);
398     }
399 	
400 	/**
401 	* @dev Burns tokens from one address
402 	* @param _from address The address which you want to burn tokens from
403 	* @param _value uint256 the amount of tokens to be burned
404 	*/
405 	function burnFrom(address _from, uint256 _value) public returns (bool) {
406 		require(_value <= allowed[_from][msg.sender]); // check if it has the budget allowed
407 		burnFunction(_from, _value);
408 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
409 		return true;
410 	}
411 }
412 
413 contract OriginToken is Authorizable, BasicToken, BurnToken {
414     
415     /**
416      * @dev transfer token from tx.orgin to a specified address (onlyAuthorized contract)
417      */ 
418     function originTransfer(address _to, uint256 _value) onlyAuthorized public returns (bool) {
419 	    return transferFunction(tx.origin, _to, _value);
420     }
421     
422     /**
423      * @dev Burns a specific amount of tokens from tx.orgin. (onlyAuthorized contract)
424      * @param _value The amount of token to be burned.
425      */	
426 	function originBurn(uint256 _value) onlyAuthorized public returns(bool) {
427         return burnFunction(tx.origin, _value);
428     }
429 }
430 
431 contract CoinCrowdToken is ERC223TokenCompatible, StandardToken, StartToken, HumanStandardToken, BurnToken, OriginToken {
432     uint8 public decimals = 18;
433 
434     string public name = "CoinCrowd";
435 
436     string public symbol = "XCC";
437 
438     uint256 public initialSupply;
439 
440     function CoinCrowdToken() public {
441         totalSupply = 100000000 * 10 ** uint(decimals);  
442         
443         initialSupply = totalSupply;
444         
445         balances[msg.sender] = totalSupply;
446     }
447 }