1 pragma solidity ^0.4.21;
2 
3 // File: contracts/zeppelin-solidity/SafeMath.sol
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
51 // File: contracts/zeppelin-solidity/ERC20/ERC20Basic.sol
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
65 // File: contracts/zeppelin-solidity/ERC20/BasicToken.sol
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
112 // File: contracts/zeppelin-solidity/ERC20/BurnableToken.sol
113 
114 /**
115  * @title Burnable Token
116  * @dev Token that can be irreversibly burned (destroyed).
117  */
118 contract BurnableToken is BasicToken {
119 
120   event Burn(address indexed burner, uint256 value);
121 
122   /**
123    * @dev Burns a specific amount of tokens.
124    * @param _value The amount of token to be burned.
125    */
126   function burn(uint256 _value) public {
127     require(_value <= balances[msg.sender]);
128     // no need to require value <= totalSupply, since that would imply the
129     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
130 
131     address burner = msg.sender;
132     balances[burner] = balances[burner].sub(_value);
133     totalSupply_ = totalSupply_.sub(_value);
134     Burn(burner, _value);
135     Transfer(burner, address(0), _value);
136   }
137 }
138 
139 // File: contracts/zeppelin-solidity/Ownable.sol
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147   address public owner;
148 
149 
150   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152 
153   /**
154    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
155    * account.
156    */
157   function Ownable() public {
158     owner = msg.sender;
159   }
160 
161   /**
162    * @dev Throws if called by any account other than the owner.
163    */
164   modifier onlyOwner() {
165     require(msg.sender == owner);
166     _;
167   }
168 
169   /**
170    * @dev Allows the current owner to transfer control of the contract to a newOwner.
171    * @param newOwner The address to transfer ownership to.
172    */
173   function transferOwnership(address newOwner) public onlyOwner {
174     require(newOwner != address(0));
175     OwnershipTransferred(owner, newOwner);
176     owner = newOwner;
177   }
178 
179 }
180 
181 // File: contracts/zeppelin-solidity/ERC20/ERC20.sol
182 
183 /**
184  * @title ERC20 interface
185  * @dev see https://github.com/ethereum/EIPs/issues/20
186  */
187 contract ERC20 is ERC20Basic {
188   function allowance(address owner, address spender) public view returns (uint256);
189   function transferFrom(address from, address to, uint256 value) public returns (bool);
190   function approve(address spender, uint256 value) public returns (bool);
191   event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 // File: contracts/zeppelin-solidity/ERC20/StandardToken.sol
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
215     require(_to != address(0));
216     require(_value <= balances[_from]);
217     require(_value <= allowed[_from][msg.sender]);
218 
219     balances[_from] = balances[_from].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222     Transfer(_from, _to, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
228    *
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) public returns (bool) {
237     allowed[msg.sender][_spender] = _value;
238     Approval(msg.sender, _spender, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Function to check the amount of tokens that an owner allowed to a spender.
244    * @param _owner address The address which owns the funds.
245    * @param _spender address The address which will spend the funds.
246    * @return A uint256 specifying the amount of tokens still available for the spender.
247    */
248   function allowance(address _owner, address _spender) public view returns (uint256) {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
263     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To decrement
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _subtractedValue The amount of tokens to decrease the allowance by.
277    */
278   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
279     uint oldValue = allowed[msg.sender][_spender];
280     if (_subtractedValue > oldValue) {
281       allowed[msg.sender][_spender] = 0;
282     } else {
283       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
284     }
285     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289 }
290 
291 // File: contracts/zeppelin-solidity/ERC20/MintableToken.sol
292 
293 /**
294  * @title Mintable token
295  * @dev Simple ERC20 Token example, with mintable token creation
296  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
297  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
298  */
299 contract MintableToken is StandardToken, Ownable {
300   event Mint(address indexed to, uint256 amount);
301   event MintFinished();
302 
303   bool public mintingFinished = false;
304 
305 
306   modifier canMint() {
307     require(!mintingFinished);
308     _;
309   }
310 
311   /**
312    * @dev Function to mint tokens
313    * @param _to The address that will receive the minted tokens.
314    * @param _amount The amount of tokens to mint.
315    * @return A boolean that indicates if the operation was successful.
316    */
317   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_to] = balances[_to].add(_amount);
320     Mint(_to, _amount);
321     Transfer(address(0), _to, _amount);
322     return true;
323   }
324 
325   /**
326    * @dev Function to stop minting new tokens.
327    * @return True if the operation was successful.
328    */
329   function finishMinting() onlyOwner canMint public returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 // File: contracts/zeppelin-solidity/ERC20/CappedToken.sol
337 
338 /**
339  * @title Capped token
340  * @dev Mintable token with a token cap.
341  */
342 contract CappedToken is MintableToken {
343 
344   uint256 public cap;
345 
346   function CappedToken(uint256 _cap) public {
347     require(_cap > 0);
348     cap = _cap;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
358     require(totalSupply_.add(_amount) <= cap);
359 
360     return super.mint(_to, _amount);
361   }
362 
363 }
364 
365 // File: contracts/zeppelin-solidity/ERC827/ERC827.sol
366 
367 /**
368    @title ERC827 interface, an extension of ERC20 token standard
369 
370    Interface of a ERC827 token, following the ERC20 standard with extra
371    methods to transfer value and data and execute calls in transfers and
372    approvals.
373  */
374 contract ERC827 is ERC20 {
375 
376   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
377   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
378   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
379 
380 }
381 
382 // File: contracts/zeppelin-solidity/ERC827/ERC827Token.sol
383 
384 /**
385    @title ERC827, an extension of ERC20 token standard
386 
387    Implementation the ERC827, following the ERC20 standard with extra
388    methods to transfer value and data and execute calls in transfers and
389    approvals.
390    Uses OpenZeppelin StandardToken.
391  */
392 contract ERC827Token is ERC827, StandardToken {
393 
394   /**
395      @dev Addition to ERC20 token methods. It allows to
396      approve the transfer of value and execute a call with the sent data.
397 
398      Beware that changing an allowance with this method brings the risk that
399      someone may use both the old and the new allowance by unfortunate
400      transaction ordering. One possible solution to mitigate this race condition
401      is to first reduce the spender's allowance to 0 and set the desired value
402      afterwards:
403      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404 
405      @param _spender The address that will spend the funds.
406      @param _value The amount of tokens to be spent.
407      @param _data ABI-encoded contract call to call `_to` address.
408 
409      @return true if the call function was executed successfully
410    */
411   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
412     require(_spender != address(this));
413 
414     super.approve(_spender, _value);
415 
416     require(_spender.call(_data));
417 
418     return true;
419   }
420 
421   /**
422      @dev Addition to ERC20 token methods. Transfer tokens to a specified
423      address and execute a call with the sent data on the same transaction
424 
425      @param _to address The address which you want to transfer to
426      @param _value uint256 the amout of tokens to be transfered
427      @param _data ABI-encoded contract call to call `_to` address.
428 
429      @return true if the call function was executed successfully
430    */
431   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
432     require(_to != address(this));
433 
434     super.transfer(_to, _value);
435 
436     require(_to.call(_data));
437     return true;
438   }
439 
440   /**
441      @dev Addition to ERC20 token methods. Transfer tokens from one address to
442      another and make a contract call on the same transaction
443 
444      @param _from The address which you want to send tokens from
445      @param _to The address which you want to transfer to
446      @param _value The amout of tokens to be transferred
447      @param _data ABI-encoded contract call to call `_to` address.
448 
449      @return true if the call function was executed successfully
450    */
451   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
452     require(_to != address(this));
453 
454     super.transferFrom(_from, _to, _value);
455 
456     require(_to.call(_data));
457     return true;
458   }
459 
460   /**
461    * @dev Addition to StandardToken methods. Increase the amount of tokens that
462    * an owner allowed to a spender and execute a call with the sent data.
463    *
464    * approve should be called when allowed[_spender] == 0. To increment
465    * allowed value is better to use this function to avoid 2 calls (and wait until
466    * the first transaction is mined)
467    * From MonolithDAO Token.sol
468    * @param _spender The address which will spend the funds.
469    * @param _addedValue The amount of tokens to increase the allowance by.
470    * @param _data ABI-encoded contract call to call `_spender` address.
471    */
472   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
473     require(_spender != address(this));
474 
475     super.increaseApproval(_spender, _addedValue);
476 
477     require(_spender.call(_data));
478 
479     return true;
480   }
481 
482   /**
483    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
484    * an owner allowed to a spender and execute a call with the sent data.
485    *
486    * approve should be called when allowed[_spender] == 0. To decrement
487    * allowed value is better to use this function to avoid 2 calls (and wait until
488    * the first transaction is mined)
489    * From MonolithDAO Token.sol
490    * @param _spender The address which will spend the funds.
491    * @param _subtractedValue The amount of tokens to decrease the allowance by.
492    * @param _data ABI-encoded contract call to call `_spender` address.
493    */
494   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
495     require(_spender != address(this));
496 
497     super.decreaseApproval(_spender, _subtractedValue);
498 
499     require(_spender.call(_data));
500 
501     return true;
502   }
503 
504 }
505 
506 // File: contracts/QuintessenceToken.sol
507 
508 contract AbstractQuintessenceToken is CappedToken, ERC827Token, BurnableToken {
509   string public name = "Quintessence Token";
510   string public symbol = "QST";
511 
512   function AbstractQuintessenceToken(uint256 initial_supply, uint256 _cap)
513         CappedToken(_cap) public {
514     mint(msg.sender, initial_supply);
515   }
516 }
517 
518 contract QuintessenceToken is AbstractQuintessenceToken {
519   uint256 public constant decimals = 18;
520   uint256 public constant TOKEN_CAP = 56000000 * (10 ** decimals);
521   // Allocate 4% of TOKEN_CAP to the team.
522   uint256 public constant TEAM_SUPPLY = (TOKEN_CAP * 4) / 100;
523 
524   function QuintessenceToken() AbstractQuintessenceToken(TEAM_SUPPLY, TOKEN_CAP) public {
525   }
526 }