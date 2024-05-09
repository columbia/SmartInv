1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/ChildToken.sol
223 
224 /**
225  * @title ChildToken
226  * @dev ChildToken is the base contract of child token contracts
227  */
228 contract ChildToken is StandardToken {
229 }
230 
231 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
232 
233 /**
234  * @title Ownable
235  * @dev The Ownable contract has an owner address, and provides basic authorization control
236  * functions, this simplifies the implementation of "user permissions".
237  */
238 contract Ownable {
239   address public owner;
240 
241 
242   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244 
245   /**
246    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
247    * account.
248    */
249   function Ownable() public {
250     owner = msg.sender;
251   }
252 
253   /**
254    * @dev Throws if called by any account other than the owner.
255    */
256   modifier onlyOwner() {
257     require(msg.sender == owner);
258     _;
259   }
260 
261   /**
262    * @dev Allows the current owner to transfer control of the contract to a newOwner.
263    * @param newOwner The address to transfer ownership to.
264    */
265   function transferOwnership(address newOwner) public onlyOwner {
266     require(newOwner != address(0));
267     OwnershipTransferred(owner, newOwner);
268     owner = newOwner;
269   }
270 
271 }
272 
273 // File: contracts/Slogan.sol
274 
275 /**
276  * @title Slogan
277  * @dev Developers and owners can set a slogan in their contract
278  */
279 contract Slogan is Ownable {
280 	string public slogan;
281 
282 	event SloganChanged(string indexed oldSlogan, string indexed newSlogan);
283 
284 	function Slogan(string _slogan) public {
285 		slogan = _slogan;
286 	}
287 
288 	function ownerChangeSlogan(string _slogan) onlyOwner public {
289 		SloganChanged(slogan, _slogan);
290 		slogan = _slogan;
291 	}
292 }
293 
294 /**
295  * @title Bitansuo
296  * @dev Bitansuo is a contract with bitansuo's slogan.
297  */
298 contract Bitansuo is Slogan {
299 	function Bitansuo() Slogan("币探索 (bitansuo.com | bitansuo.eth)") public {
300 	}
301 }
302 
303 // File: contracts/Refundable.sol
304 
305 /**
306  * @title Refundable
307  * @dev Base contract that can refund funds(ETH and tokens) by owner.
308  * @dev Reference TokenDestructible(zeppelinand) TokenDestructible(zeppelin)
309  */
310 contract Refundable is Bitansuo {
311 	event RefundETH(address indexed owner, address indexed payee, uint256 amount);
312 	event RefundERC20(address indexed owner, address indexed payee, address indexed token, uint256 amount);
313 
314 	function Refundable() public payable {
315 	}
316 
317 	function refundETH(address payee, uint256 amount) onlyOwner public {
318 		require(payee != address(0));
319 		require(this.balance >= amount);
320 		assert(payee.send(amount));
321 		RefundETH(owner, payee, amount);
322 	}
323 
324 	function refundERC20(address tokenContract, address payee, uint256 amount) onlyOwner public {
325 		require(payee != address(0));
326 		bool isContract;
327 		assembly {
328 			isContract := gt(extcodesize(tokenContract), 0)
329 		}
330 		require(isContract);
331 
332 		ERC20 token = ERC20(tokenContract);
333 		assert(token.transfer(payee, amount));
334 		RefundERC20(owner, payee, tokenContract, amount);
335 	}
336 }
337 
338 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
339 
340 /**
341  * @title Burnable Token
342  * @dev Token that can be irreversibly burned (destroyed).
343  */
344 contract BurnableToken is BasicToken {
345 
346   event Burn(address indexed burner, uint256 value);
347 
348   /**
349    * @dev Burns a specific amount of tokens.
350    * @param _value The amount of token to be burned.
351    */
352   function burn(uint256 _value) public {
353     require(_value <= balances[msg.sender]);
354     // no need to require value <= totalSupply, since that would imply the
355     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
356 
357     address burner = msg.sender;
358     balances[burner] = balances[burner].sub(_value);
359     totalSupply_ = totalSupply_.sub(_value);
360     Burn(burner, _value);
361   }
362 }
363 
364 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
365 
366 /**
367  * @title Mintable token
368  * @dev Simple ERC20 Token example, with mintable token creation
369  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
370  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
371  */
372 contract MintableToken is StandardToken, Ownable {
373   event Mint(address indexed to, uint256 amount);
374   event MintFinished();
375 
376   bool public mintingFinished = false;
377 
378 
379   modifier canMint() {
380     require(!mintingFinished);
381     _;
382   }
383 
384   /**
385    * @dev Function to mint tokens
386    * @param _to The address that will receive the minted tokens.
387    * @param _amount The amount of tokens to mint.
388    * @return A boolean that indicates if the operation was successful.
389    */
390   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
391     totalSupply_ = totalSupply_.add(_amount);
392     balances[_to] = balances[_to].add(_amount);
393     Mint(_to, _amount);
394     Transfer(address(0), _to, _amount);
395     return true;
396   }
397 
398   /**
399    * @dev Function to stop minting new tokens.
400    * @return True if the operation was successful.
401    */
402   function finishMinting() onlyOwner canMint public returns (bool) {
403     mintingFinished = true;
404     MintFinished();
405     return true;
406   }
407 }
408 
409 // File: contracts/ComplexChildToken.sol
410 
411 /**
412  * @title ComplexChildToken
413  * @dev Complex child token to be generated by TokenFather.
414  */
415 contract ComplexChildToken is ChildToken, Refundable, MintableToken, BurnableToken {
416 	string public name;
417 	string public symbol;
418 	uint8 public decimals;
419 	bool public canBurn;
420 
421 	event Burn(address indexed burner, uint256 value);
422 
423 	function ComplexChildToken(address _owner, string _name, string _symbol, uint256 _initSupply, uint8 _decimals,
424 		bool _canMint, bool _canBurn) public {
425 		require(_owner != address(0));
426 		owner = _owner;
427 		name = _name;
428 		symbol = _symbol;
429 		decimals = _decimals;
430 
431 		uint256 amount = _initSupply;
432 		totalSupply_ = totalSupply_.add(amount);
433 		balances[owner] = balances[owner].add(amount);
434 		Transfer(address(0), owner, amount);
435 
436 		if (!_canMint) {
437 			mintingFinished = true;
438 		}
439 		canBurn = _canBurn;
440 	}
441 
442 	/**
443 	* @dev Burns a specific amount of tokens.
444 	* @param _value The amount of token to be burned.
445 	*/
446 	function burn(uint256 _value) public {
447 		require(canBurn);
448 		BurnableToken.burn(_value);
449 	}
450 
451 	function ownerCanBurn(bool _canBurn) onlyOwner public {
452 		canBurn = _canBurn;
453 	}
454 }