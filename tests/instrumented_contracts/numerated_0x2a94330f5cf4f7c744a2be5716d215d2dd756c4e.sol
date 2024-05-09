1 pragma solidity ^0.4.19;
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
40   address public owner;
41   
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() internal {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 
72 /**
73  * @title Authorizable
74  * @dev The Authorizable contract has authorized addresses, and provides basic authorization control
75  * functions, this simplifies the implementation of "multiple user permissions".
76  */
77 contract Authorizable is Ownable {
78   mapping(address => bool) public authorized;
79   
80   event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);
81 
82   /**
83    * @dev The Authorizable constructor sets the first `authorized` of the contract to the sender
84    * account.
85    */ 
86   function Authorizable() public {
87 	authorized[msg.sender] = true;
88   }
89 
90   /**
91    * @dev Throws if called by any account other than the authorized.
92    */
93   modifier onlyAuthorized() {
94     require(authorized[msg.sender]);
95     _;
96   }
97 
98  /**
99    * @dev Allows the current owner to set an authorization.
100    * @param addressAuthorized The address to change authorization.
101    */
102   function setAuthorized(address addressAuthorized, bool authorization) onlyOwner public {
103     AuthorizationSet(addressAuthorized, authorization);
104     authorized[addressAuthorized] = authorization;
105   }
106   
107 }
108 
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   uint256 public totalSupply;
117   function balanceOf(address who) public constant returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public constant returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   /**
143   * @dev transfer token from an address to another specified address 
144   * @param _sender The address to transfer from.
145   * @param _to The address to transfer to.
146   * @param _value The amount to be transferred.
147   */
148   function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
149     require(_to != address(0));
150     require(_to != address(this));
151     require(_value <= balances[_sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[_sender] = balances[_sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(_sender, _to, _value);
157     return true;
158   }
159   
160   /**
161   * @dev transfer token for a specified address (BasicToken transfer method)
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164 	return transferFunction(msg.sender, _to, _value);
165   }
166   
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public constant returns (uint256 balance) {
173     return balances[_owner];
174   }
175 }
176 
177 contract ERC223TokenCompatible is BasicToken {
178   using SafeMath for uint256;
179   
180   event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
181 
182   // Function that is called when a user or another contract wants to transfer funds .
183 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
184 		require(_to != address(0));
185         require(_to != address(this));
186 		require(_value <= balances[msg.sender]);
187 		// SafeMath.sub will throw if there is not enough balance.
188         balances[msg.sender] = balances[msg.sender].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190 		if( isContract(_to) ) {
191 			_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data);
192 		} 
193 		Transfer(msg.sender, _to, _value, _data);
194 		return true;
195 	}
196 
197 	// Function that is called when a user or another contract wants to transfer funds .
198 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
199 		return transfer( _to, _value, _data, "tokenFallback(address,uint256,bytes)");
200 	}
201 
202 	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
203 	function isContract(address _addr) private view returns (bool is_contract) {
204 		uint256 length;
205 		assembly {
206             //retrieve the size of the code on target address, this needs assembly
207             length := extcodesize(_addr)
208 		}
209 		return (length>0);
210     }
211 }
212 
213 
214 /**
215  * @title Standard ERC20 token
216  *
217  * @dev Implementation of the basic standard token.
218  * @dev https://github.com/ethereum/EIPs/issues/20
219  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  */
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
232   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
233     require(_to != address(0));
234     require(_to != address(this));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    */
277   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
278     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 
297 /**
298  * @title Startable
299  * @dev Base contract which allows owner to implement an start mechanism without ever being stopped more.
300  */
301 contract Startable is Ownable, Authorizable {
302   event Start();
303 
304   bool public started = false;
305 
306   /**
307    * @dev Modifier to make a function callable only when the contract is started.
308    */
309   modifier whenStarted() {
310 	require( started || authorized[msg.sender] );
311     _;
312   }
313 
314   /**
315    * @dev called by the owner to start, go to normal state
316    */
317   function start() onlyOwner public {
318     started = true;
319     Start();
320   }
321 }
322 
323 /**
324  * @title Startable token
325  *
326  * @dev StandardToken modified with startable transfers.
327  **/
328 
329 contract StartToken is Startable, ERC223TokenCompatible, StandardToken {
330 
331   function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
332     return super.transfer(_to, _value);
333   }
334   function transfer(address _to, uint256 _value, bytes _data) public whenStarted returns (bool) {
335     return super.transfer(_to, _value, _data);
336   }
337   function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public whenStarted returns (bool) {
338     return super.transfer(_to, _value, _data, _custom_fallback);
339   }
340 
341   function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
342     return super.transferFrom(_from, _to, _value);
343   }
344 
345   function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
346     return super.approve(_spender, _value);
347   }
348 
349   function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
350     return super.increaseApproval(_spender, _addedValue);
351   }
352 
353   function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
354     return super.decreaseApproval(_spender, _subtractedValue);
355   }
356 }
357 
358 contract HumanStandardToken is StandardToken, StartToken {
359     /* Approves and then calls the receiving contract */
360     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
361         approve(_spender, _value);
362         require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
363         return true;
364     }
365 }
366 
367 contract BurnToken is StandardToken {
368 
369     event Burn(address indexed burner, uint256 value);
370 
371     /**
372      * @dev Function to burn tokens.
373      * @param _burner The address of token holder.
374      * @param _value The amount of token to be burned.
375      */
376     function burnFunction(address _burner, uint256 _value) internal returns (bool) {
377         require(_value > 0);
378 		require(_value <= balances[_burner]);
379         // no need to require value <= totalSupply, since that would imply the
380         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
381 
382         balances[_burner] = balances[_burner].sub(_value);
383         totalSupply = totalSupply.sub(_value);
384         Burn(_burner, _value);
385 		return true;
386     }
387     
388     /**
389      * @dev Burns a specific amount of tokens.
390      * @param _value The amount of token to be burned.
391      */
392 	function burn(uint256 _value) public returns(bool) {
393         return burnFunction(msg.sender, _value);
394     }
395 	
396 	/**
397 	* @dev Burns tokens from one address
398 	* @param _from address The address which you want to burn tokens from
399 	* @param _value uint256 the amount of tokens to be burned
400 	*/
401 	function burnFrom(address _from, uint256 _value) public returns (bool) {
402 		require(_value <= allowed[_from][msg.sender]); // check if it has the budget allowed
403 		burnFunction(_from, _value);
404 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
405 		return true;
406 	}
407 }
408 
409 contract OriginToken is Authorizable, BasicToken, BurnToken {
410     
411     /**
412      * @dev transfer token from tx.orgin to a specified address (onlyAuthorized contract)
413      */ 
414     function originTransfer(address _to, uint256 _value) onlyAuthorized public returns (bool) {
415 	    return transferFunction(tx.origin, _to, _value);
416     }
417     
418     /**
419      * @dev Burns a specific amount of tokens from tx.orgin. (onlyAuthorized contract)
420      * @param _value The amount of token to be burned.
421      */	
422 	function originBurn(uint256 _value) onlyAuthorized public returns(bool) {
423         return burnFunction(tx.origin, _value);
424     }
425 }
426 
427 contract Token is ERC223TokenCompatible, StandardToken, StartToken, HumanStandardToken, BurnToken, OriginToken {
428     uint8 public decimals = 18;
429 
430     string public name = "EolCoin";
431 
432     string public symbol = "EOL";
433 
434     uint256 public initialSupply;
435 
436     function Token() public {
437         totalSupply = 100000000 * 10 ** uint(decimals);  
438         
439         initialSupply = totalSupply;
440         
441         balances[msg.sender] = totalSupply;
442     }
443 }