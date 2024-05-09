1 pragma solidity ^0.4.18;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   function totalSupply() public view returns (uint256);
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 
145 /**
146  * @title Basic token
147  * @dev Basic version of StandardToken, with no allowances.
148  */
149 contract BasicToken is ERC20Basic {
150   using SafeMath for uint256;
151 
152   mapping(address => uint256) balances;
153 
154   uint256 totalSupply_;
155 
156   /**
157   * @dev total number of tokens in existence
158   */
159   function totalSupply() public view returns (uint256) {
160     return totalSupply_;
161   }
162 
163   /**
164   * @dev transfer token for a specified address
165   * @param _to The address to transfer to.
166   * @param _value The amount to be transferred.
167   */
168   function transfer(address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[msg.sender]);
171 
172     // SafeMath.sub will throw if there is not enough balance.
173     balances[msg.sender] = balances[msg.sender].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     Transfer(msg.sender, _to, _value);
176     return true;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param _owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address _owner) public view returns (uint256 balance) {
185     return balances[_owner];
186   }
187 
188 }
189 
190 /**
191  * @title ERC20 interface
192  * @dev see https://github.com/ethereum/EIPs/issues/20
193  */
194 contract ERC20 is ERC20Basic {
195   function allowance(address owner, address spender) public view returns (uint256);
196   function transferFrom(address from, address to, uint256 value) public returns (bool);
197   function approve(address spender, uint256 value) public returns (bool);
198   event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
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
296 /**
297  * @title Pausable token
298  * @dev StandardToken modified with pausable transfers.
299  **/
300 contract PausableToken is StandardToken, Pausable {
301 
302   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
303     return super.transfer(_to, _value);
304   }
305 
306   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
307     return super.transferFrom(_from, _to, _value);
308   }
309 
310   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
311     return super.approve(_spender, _value);
312   }
313 
314   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
315     return super.increaseApproval(_spender, _addedValue);
316   }
317 
318   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
319     return super.decreaseApproval(_spender, _subtractedValue);
320   }
321 }
322 
323 /**
324  * @title Mintable token
325  * @dev Simple ERC20 Token example, with mintable token creation
326  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
327  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
328  */
329 contract MintableToken is StandardToken, Ownable {
330   event Mint(address indexed to, uint256 amount);
331   event MintFinished();
332 
333   bool public mintingFinished = false;
334 
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     totalSupply_ = totalSupply_.add(_amount);
349     balances[_to] = balances[_to].add(_amount);
350     Mint(_to, _amount);
351     Transfer(address(0), _to, _amount);
352     return true;
353   }
354 
355   /**
356    * @dev Function to stop minting new tokens.
357    * @return True if the operation was successful.
358    */
359   function finishMinting() onlyOwner canMint public returns (bool) {
360     mintingFinished = true;
361     MintFinished();
362     return true;
363   }
364 }
365 
366 /**
367    @title ERC827 interface, an extension of ERC20 token standard
368    Interface of a ERC827 token, following the ERC20 standard with extra
369    methods to transfer value and data and execute calls in transfers and
370    approvals.
371  */
372 contract ERC827 is ERC20 {
373 
374   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
375   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
376   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
377 
378 }
379 
380 /**
381    @title ERC827, an extension of ERC20 token standard
382    Implementation the ERC827, following the ERC20 standard with extra
383    methods to transfer value and data and execute calls in transfers and
384    approvals.
385    Uses OpenZeppelin StandardToken.
386  */
387 contract ERC827Token is ERC827, StandardToken {
388 
389   /**
390      @dev Addition to ERC20 token methods. It allows to
391      approve the transfer of value and execute a call with the sent data.
392      Beware that changing an allowance with this method brings the risk that
393      someone may use both the old and the new allowance by unfortunate
394      transaction ordering. One possible solution to mitigate this race condition
395      is to first reduce the spender's allowance to 0 and set the desired value
396      afterwards:
397      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398      @param _spender The address that will spend the funds.
399      @param _value The amount of tokens to be spent.
400      @param _data ABI-encoded contract call to call `_to` address.
401      @return true if the call function was executed successfully
402    */
403   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
404     require(_spender != address(this));
405 
406     super.approve(_spender, _value);
407 
408     require(_spender.call(_data));
409 
410     return true;
411   }
412 
413   /**
414      @dev Addition to ERC20 token methods. Transfer tokens to a specified
415      address and execute a call with the sent data on the same transaction
416      @param _to address The address which you want to transfer to
417      @param _value uint256 the amout of tokens to be transfered
418      @param _data ABI-encoded contract call to call `_to` address.
419      @return true if the call function was executed successfully
420    */
421   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
422     require(_to != address(this));
423 
424     super.transfer(_to, _value);
425 
426     require(_to.call(_data));
427     return true;
428   }
429 
430   /**
431      @dev Addition to ERC20 token methods. Transfer tokens from one address to
432      another and make a contract call on the same transaction
433      @param _from The address which you want to send tokens from
434      @param _to The address which you want to transfer to
435      @param _value The amout of tokens to be transferred
436      @param _data ABI-encoded contract call to call `_to` address.
437      @return true if the call function was executed successfully
438    */
439   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
440     require(_to != address(this));
441 
442     super.transferFrom(_from, _to, _value);
443 
444     require(_to.call(_data));
445     return true;
446   }
447 
448   /**
449    * @dev Addition to StandardToken methods. Increase the amount of tokens that
450    * an owner allowed to a spender and execute a call with the sent data.
451    *
452    * approve should be called when allowed[_spender] == 0. To increment
453    * allowed value is better to use this function to avoid 2 calls (and wait until
454    * the first transaction is mined)
455    * From MonolithDAO Token.sol
456    * @param _spender The address which will spend the funds.
457    * @param _addedValue The amount of tokens to increase the allowance by.
458    * @param _data ABI-encoded contract call to call `_spender` address.
459    */
460   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
461     require(_spender != address(this));
462 
463     super.increaseApproval(_spender, _addedValue);
464 
465     require(_spender.call(_data));
466 
467     return true;
468   }
469 
470   /**
471    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
472    * an owner allowed to a spender and execute a call with the sent data.
473    *
474    * approve should be called when allowed[_spender] == 0. To decrement
475    * allowed value is better to use this function to avoid 2 calls (and wait until
476    * the first transaction is mined)
477    * From MonolithDAO Token.sol
478    * @param _spender The address which will spend the funds.
479    * @param _subtractedValue The amount of tokens to decrease the allowance by.
480    * @param _data ABI-encoded contract call to call `_spender` address.
481    */
482   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
483     require(_spender != address(this));
484 
485     super.decreaseApproval(_spender, _subtractedValue);
486 
487     require(_spender.call(_data));
488 
489     return true;
490   }
491 
492 }
493 
494 contract VanityToken_v3 is MintableToken, PausableToken, ERC827Token {
495 
496     // Metadata
497     string public constant symbol = "VIP";
498     string public constant name = "VipCoin";
499     uint8 public constant decimals = 18;
500     string public constant version = "1.3";
501 
502     function VanityToken_v3() public {
503         pause();
504     }
505 
506     function recoverLost(ERC20Basic token, address loser) public onlyOwner {
507         token.transfer(loser, token.balanceOf(this));
508     }
509 
510     function mintToMany(address[] patricipants, uint[] amounts) public onlyOwner {
511         require(paused);
512         require(patricipants.length == amounts.length);
513 
514         for (uint i = 0; i < patricipants.length; i++) {
515             mint(patricipants[i], amounts[i]);
516         }
517     }
518 
519 }