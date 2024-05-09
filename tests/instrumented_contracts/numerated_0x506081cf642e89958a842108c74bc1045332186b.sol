1 pragma solidity ^0.4.23;
2 /**
3  * Copyright (C) 2018  Ducatur, LLC
4  *
5  * Licensed under the Apache License, Version 2.0 (the "License").
6  * You may not use this file except in compliance with the License.
7  *
8  * Unless required by applicable law or agreed to in writing, software
9  * distributed under the License is distributed on an "AS IS" BASIS,
10  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11  */
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19   function totalSupply() public view returns (uint256);
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 /**
26  * @title ERC20 interface
27  * @dev see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 is ERC20Basic {
30   function allowance(address owner, address spender)
31     public view returns (uint256);
32 
33   function transferFrom(address from, address to, uint256 value)
34     public returns (bool);
35 
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(
38     address indexed owner,
39     address indexed spender,
40     uint256 value
41   );
42 }
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipRenounced(address indexed previousOwner);
53   event OwnershipTransferred(
54     address indexed previousOwner,
55     address indexed newOwner
56   );
57 
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 }
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     if (a == 0) {
104       return 0;
105     }
106     c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     // uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return a / b;
119   }
120 
121   /**
122   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133     c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 /**
140  * @title Basic token
141  * @dev Basic version of StandardToken, with no allowances.
142  */
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   mapping(address => uint256) balances;
147 
148   uint256 totalSupply_;
149 
150   /**
151   * @dev total number of tokens in existence
152   */
153   function totalSupply() public view returns (uint256) {
154     return totalSupply_;
155   }
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[msg.sender]);
165 
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     emit Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public view returns (uint256) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(
203     address _from,
204     address _to,
205     uint256 _value
206   )
207     public
208     returns (bool)
209   {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    *
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Function to check the amount of tokens that an owner allowed to a spender.
239    * @param _owner address The address which owns the funds.
240    * @param _spender address The address which will spend the funds.
241    * @return A uint256 specifying the amount of tokens still available for the spender.
242    */
243   function allowance(
244     address _owner,
245     address _spender
246    )
247     public
248     view
249     returns (uint256)
250   {
251     return allowed[_owner][_spender];
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval(
265     address _spender,
266     uint _addedValue
267   )
268     public
269     returns (bool)
270   {
271     allowed[msg.sender][_spender] = (
272       allowed[msg.sender][_spender].add(_addedValue));
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To decrement
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _subtractedValue The amount of tokens to decrease the allowance by.
286    */
287   function decreaseApproval(
288     address _spender,
289     uint _subtractedValue
290   )
291     public
292     returns (bool)
293   {
294     uint oldValue = allowed[msg.sender][_spender];
295     if (_subtractedValue > oldValue) {
296       allowed[msg.sender][_spender] = 0;
297     } else {
298       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
299     }
300     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301     return true;
302   }
303 
304 }
305 /**
306  * @title Mintable token
307  * @dev Simple ERC20 Token example, with mintable token creation
308  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
309  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
310  */
311 contract MintableToken is StandardToken, Ownable {
312   event Mint(address indexed to, uint256 amount);
313   event MintFinished();
314 
315   bool public mintingFinished = false;
316 
317 
318   modifier canMint() {
319     require(!mintingFinished);
320     _;
321   }
322 
323   modifier hasMintPermission() {
324     require(msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Function to mint tokens
330    * @param _to The address that will receive the minted tokens.
331    * @param _amount The amount of tokens to mint.
332    * @return A boolean that indicates if the operation was successful.
333    */
334   function mint(
335     address _to,
336     uint256 _amount
337   )
338     hasMintPermission
339     canMint
340     public
341     returns (bool)
342   {
343     totalSupply_ = totalSupply_.add(_amount);
344     balances[_to] = balances[_to].add(_amount);
345     emit Mint(_to, _amount);
346     emit Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350   /**
351    * @dev Function to stop minting new tokens.
352    * @return True if the operation was successful.
353    */
354   function finishMinting() onlyOwner canMint public returns (bool) {
355     mintingFinished = true;
356     emit MintFinished();
357     return true;
358   }
359 }
360 
361 /**
362  * @title Burnable Token
363  * @dev Token that can be irreversibly burned (destroyed).
364  */
365 contract BurnableToken is BasicToken {
366 
367   event Burn(address indexed burner, uint256 value);
368 
369   /**
370    * @dev Burns a specific amount of tokens.
371    * @param _value The amount of token to be burned.
372    */
373   function burn(uint256 _value) public {
374     _burn(msg.sender, _value);
375   }
376 
377   function _burn(address _who, uint256 _value) internal {
378     require(_value <= balances[_who]);
379     // no need to require value <= totalSupply, since that would imply the
380     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
381 
382     balances[_who] = balances[_who].sub(_value);
383     totalSupply_ = totalSupply_.sub(_value);
384     emit Burn(_who, _value);
385     emit Transfer(_who, address(0), _value);
386   }
387 }
388 
389 /**
390  * @title Pausable
391  * @dev Base contract which allows children to implement an emergency stop mechanism.
392  */
393 contract Pausable is Ownable {
394   event Pause();
395   event Unpause();
396 
397   bool public paused = false;
398 
399 
400   /**
401    * @dev Modifier to make a function callable only when the contract is not paused.
402    */
403   modifier whenNotPaused() {
404     require(!paused);
405     _;
406   }
407 
408   /**
409    * @dev Modifier to make a function callable only when the contract is paused.
410    */
411   modifier whenPaused() {
412     require(paused);
413     _;
414   }
415 
416   /**
417    * @dev called by the owner to pause, triggers stopped state
418    */
419   function pause() onlyOwner whenNotPaused public {
420     paused = true;
421     emit Pause();
422   }
423 
424   /**
425    * @dev called by the owner to unpause, returns to normal state
426    */
427   function unpause() onlyOwner whenPaused public {
428     paused = false;
429     emit Unpause();
430   }
431 }
432 /**
433  * @title Pausable token
434  * @dev StandardToken modified with pausable transfers.
435  **/
436 contract PausableToken is StandardToken, Pausable {
437 
438   function transfer(
439     address _to,
440     uint256 _value
441   )
442     public
443     whenNotPaused
444     returns (bool)
445   {
446     return super.transfer(_to, _value);
447   }
448 
449   function transferFrom(
450     address _from,
451     address _to,
452     uint256 _value
453   )
454     public
455     whenNotPaused
456     returns (bool)
457   {
458     return super.transferFrom(_from, _to, _value);
459   }
460 
461   function approve(
462     address _spender,
463     uint256 _value
464   )
465     public
466     whenNotPaused
467     returns (bool)
468   {
469     return super.approve(_spender, _value);
470   }
471 
472   function increaseApproval(
473     address _spender,
474     uint _addedValue
475   )
476     public
477     whenNotPaused
478     returns (bool success)
479   {
480     return super.increaseApproval(_spender, _addedValue);
481   }
482 
483   function decreaseApproval(
484     address _spender,
485     uint _subtractedValue
486   )
487     public
488     whenNotPaused
489     returns (bool success)
490   {
491     return super.decreaseApproval(_spender, _subtractedValue);
492   }
493 }
494 
495 /**
496  * @title Ducatur token
497  * @dev Mintable Burnable Pausable token with a token cap.
498  */
499 contract DucaturToken is MintableToken, BurnableToken, PausableToken {
500 
501   string public constant name = "Ducatur Token";
502   string public constant symbol = "DUCAT";
503   uint8 public constant decimals = 18;
504   uint256 public cap;
505   address public oracle;
506   event BlockchainExchange(
507     address indexed from, 
508     uint256 value, 
509     int newNetwork, 
510     bytes32 adr
511   );
512 
513   constructor(uint256 _cap, address _oracle) public {
514     require(_cap > 0);
515     cap = _cap * 10 ** uint256(decimals);
516     oracle = _oracle;
517   }
518 
519   /**
520    * @dev Throws if called by any account other than the oracle.
521    */
522   modifier onlyOracle() {
523     require(msg.sender == oracle);
524     _;
525   }
526   
527   /**
528    * @dev Function to change oracle
529    * @param _oracle The address of new oracle.
530    */  
531   function changeOracle(address _oracle) external onlyOwner {
532       oracle = _oracle;
533   }
534   
535   /**
536    * @dev Function to mint tokens
537    * @param _to The address that will receive the minted tokens.
538    * @param _amount The amount of tokens to mint.
539    * @return A boolean that indicates if the operation was successful.
540    */
541   function mint(
542     address _to,
543     uint256 _amount
544   )
545     onlyOracle
546     canMint
547     public
548     returns (bool)
549   {
550     _amount = _amount*10**uint256(decimals);
551     require(totalSupply_.add(_amount) <= cap);
552     return super.mint(_to, _amount);
553   }
554   
555     /**
556    * @dev Function to burn tokens and rise event for burn tokens in another network
557    * @param _amount The address that will receive the minted tokens.
558    * @param _network The amount of tokens to mint.
559    * @param _adr The address in new network
560    */
561    function blockchainExchange(
562        uint256 _amount, 
563        int _network, 
564        bytes32 _adr
565        ) public {
566         burn(_amount);
567         cap.sub(_amount);
568         emit BlockchainExchange(msg.sender, _amount, _network, _adr);
569     }
570 
571 }