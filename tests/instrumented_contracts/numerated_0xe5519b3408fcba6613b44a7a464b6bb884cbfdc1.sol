1 pragma solidity ^0.4.21;
2 /*
3 from: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
4 
5 Parts of this code has been audited by OpenZeppelin and published under MIT Licenses 
6 
7 The MIT License (MIT)
8 
9 Copyright (c) 2016 Smart Contract Solutions, Inc.
10 
11 Permission is hereby granted, free of charge, to any person obtaining
12 a copy of this software and associated documentation files (the
13 "Software"), to deal in the Software without restriction, including
14 without limitation the rights to use, copy, modify, merge, publish,
15 distribute, sublicense, and/or sell copies of the Software, and to
16 permit persons to whom the Software is furnished to do so, subject to
17 the following conditions:
18 
19 The above copyright notice and this permission notice shall be included
20 in all copies or substantial portions of the Software.
21 */ 
22 
23 library SafeMath {
24     int256 constant private INT256_MIN = -2**255;
25 
26     /**
27     * @dev Multiplies two unsigned integers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Multiplies two signed integers, reverts on overflow.
45     */
46     function mul(int256 a, int256 b) internal pure returns (int256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
55 
56         int256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
76     */
77     function div(int256 a, int256 b) internal pure returns (int256) {
78         require(b != 0); // Solidity only automatically asserts when dividing by 0
79         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
80 
81         int256 c = a / b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
88     */
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b <= a);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97     * @dev Subtracts two signed integers, reverts on overflow.
98     */
99     function sub(int256 a, int256 b) internal pure returns (int256) {
100         int256 c = a - b;
101         require((b >= 0 && c <= a) || (b < 0 && c > a));
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two unsigned integers, reverts on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117     * @dev Adds two signed integers, reverts on overflow.
118     */
119     function add(int256 a, int256 b) internal pure returns (int256) {
120         int256 c = a + b;
121         require((b >= 0 && c >= a) || (b < 0 && c < a));
122 
123         return c;
124     }
125 
126     /**
127     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
128     * reverts when dividing by zero.
129     */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b != 0);
132         return a % b;
133     }
134 }
135 
136 contract Ownable {
137     address private _owner;
138 
139     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
140 
141     /**
142      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
143      * account.
144      */
145     constructor () internal {
146         _owner = msg.sender;
147         emit OwnershipTransferred(address(0), _owner);
148     }
149 
150     /**
151      * @return the address of the owner.
152      */
153     function owner() public view returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(isOwner());
162         _;
163     }
164 
165     /**
166      * @return true if `msg.sender` is the owner of the contract.
167      */
168     function isOwner() public view returns (bool) {
169         return msg.sender == _owner;
170     }
171 
172     /**
173      * @dev Allows the current owner to relinquish control of the contract.
174      * @notice Renouncing to ownership will leave the contract without an owner.
175      * It will not be possible to call the functions with the `onlyOwner`
176      * modifier anymore.
177      */
178     function renounceOwnership() public onlyOwner {
179         emit OwnershipTransferred(_owner, address(0));
180         _owner = address(0);
181     }
182 
183     /**
184      * @dev Allows the current owner to transfer control of the contract to a newOwner.
185      * @param newOwner The address to transfer ownership to.
186      */
187     function transferOwnership(address newOwner) public onlyOwner {
188         _transferOwnership(newOwner);
189     }
190 
191     /**
192      * @dev Transfers control of the contract to a newOwner.
193      * @param newOwner The address to transfer ownership to.
194      */
195     function _transferOwnership(address newOwner) internal {
196         require(newOwner != address(0));
197         emit OwnershipTransferred(_owner, newOwner);
198         _owner = newOwner;
199     }
200 }
201 
202 ///taken from OpenZeppelin in August 2018
203 contract StandardToken is Ownable{
204     
205   using SafeMath for uint256;
206 
207   mapping(address => uint256) internal balances;
208   
209   event Approval(
210     address indexed owner,
211     address indexed spender,
212     uint256 value
213   );
214   
215   
216   event Transfer(
217       address indexed from,
218       address indexed to,
219       uint256 value
220     );
221 
222   uint256 internal totalSupply_;
223 
224   /**
225   * @dev Total number of tokens in existence
226   */
227   function totalSupply() public view returns (uint256) {
228     return totalSupply_;
229   }
230 
231   /**
232   * @dev Transfer token for a specified address
233   * @param _to The address to transfer to.
234   * @param _value The amount to be transferred.
235   */
236   function transfer(address _to, uint256 _value) public returns (bool) {
237     require(_value <= balances[msg.sender]);
238     require(_to != address(0));
239 
240     balances[msg.sender] = balances[msg.sender].sub(_value);
241     balances[_to] = balances[_to].add(_value);
242     emit Transfer(msg.sender, _to, _value);
243     return true;
244   }
245 
246   /**
247   * @dev Gets the balance of the specified address.
248   * @param _owner The address to query the the balance of.
249   * @return An uint256 representing the amount owned by the passed address.
250   */
251   function balanceOf(address _owner) public view returns (uint256) {
252     return balances[_owner];
253   }
254 
255 
256   mapping (address => mapping (address => uint256)) internal allowed;
257 
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param _from address The address which you want to send tokens from
262    * @param _to address The address which you want to transfer to
263    * @param _value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(
266     address _from,
267     address _to,
268     uint256 _value
269   )
270     public
271     returns (bool)
272   {
273     require(_value <= balances[_from]);
274     require(_value <= allowed[_from][msg.sender]);
275     require(_to != address(0));
276 
277     balances[_from] = balances[_from].sub(_value);
278     balances[_to] = balances[_to].add(_value);
279     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
280     emit Transfer(_from, _to, _value);
281     return true;
282   }
283 
284   /**
285    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
286    * @param _spender The address which will spend the funds.
287    * @param _value The amount of tokens to be spent.
288    */
289   function approve(address _spender, uint256 _value) public returns (bool) {
290     allowed[msg.sender][_spender] = _value;
291     emit Approval(msg.sender, _spender, _value);
292     return true;
293   }
294 
295   /**
296    * @dev Function to check the amount of tokens that an owner allowed to a spender.
297    * @param _owner address The address which owns the funds.
298    * @param _spender address The address which will spend the funds.
299    * @return A uint256 specifying the amount of tokens still available for the spender.
300    */
301   function allowance(
302     address _owner,
303     address _spender
304    )
305     public
306     view
307     returns (uint256)
308   {
309     return allowed[_owner][_spender];
310   }
311 
312   /**
313    * @dev Increase the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed[_spender] == 0. To increment
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * @param _spender The address which will spend the funds.
318    * @param _addedValue The amount of tokens to increase the allowance by.
319    */
320   function increaseApproval(
321     address _spender,
322     uint256 _addedValue
323   )
324     public
325     returns (bool)
326   {
327     allowed[msg.sender][_spender] = (
328       allowed[msg.sender][_spender].add(_addedValue));
329     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
330     return true;
331   }
332 
333   /**
334    * @dev Decrease the amount of tokens that an owner allowed to a spender.
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(
343     address _spender,
344     uint256 _subtractedValue
345   )
346     public
347     returns (bool)
348   {
349     uint256 oldValue = allowed[msg.sender][_spender];
350     if (_subtractedValue >= oldValue) {
351       allowed[msg.sender][_spender] = 0;
352     } else {
353       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
354     }
355     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
356     return true;
357   }
358 
359 }
360 
361 //taken from OpenZeppelin in August 2018, added Locking functionalities
362 contract PausableToken is StandardToken{
363 
364   event TokensAreLocked(address _from, uint256 _timeout);
365   event Paused(address account);
366   event Unpaused(address account);
367 
368   bool private _paused = false; 
369   mapping (address => uint256) lockups;
370 
371   
372 
373   /**
374    * @return true if the contract is paused, false otherwise.
375    */
376   function paused() public view returns(bool) {
377     return _paused;
378   }
379 
380   /**
381    * @dev Modifier to make a function callable only when the contract is not paused.
382    */
383   modifier whenNotPaused() {
384     require(!_paused);
385     _;
386   }
387 
388   /**
389    * @dev Modifier to make a function callable only when the contract is paused.
390    */
391   modifier whenPaused() {
392     require(_paused);
393     _;
394   }
395 
396   /**
397    * @dev Modifier to make a function callable only if tokens are not locked
398    */
399   modifier ifNotLocked(address _from){
400         if (lockups[_from] != 0) {
401             require(now >= lockups[_from]);
402         }
403         _;
404   }
405 
406   /**
407    * @dev called by the owner to pause, triggers stopped state
408    */
409   function pause() public onlyOwner whenNotPaused {
410     _paused = true;
411     emit Paused(msg.sender);
412   }
413 
414   /**
415    * @dev called by the owner to unpause, returns to normal state
416    */
417   function unpause() public onlyOwner whenPaused {
418     _paused = false;
419     emit Unpaused(msg.sender);
420   }
421     
422 
423     
424  /**
425  * @dev function to lock tokens utill a given block.timestamp
426  * @param _holders array of adress to lock the tokens from
427  * @param _timeouts array of timestamps untill which tokens are blocked
428  * NOTE: _holders[i] gets _timeouts[i]
429  */
430  function lockTokens(address[] _holders, uint256[] _timeouts) public onlyOwner {
431      require(_holders.length == _timeouts.length);
432      require(_holders.length < 255);
433 
434      for (uint8 i = 0; i < _holders.length; i++) {
435         address holder = _holders[i];
436         uint256 timeout = _timeouts[i];
437 
438         // make sure lockup period can not be overwritten
439         require(lockups[holder] == 0);
440 
441         lockups[holder] = timeout;
442         emit TokensAreLocked(holder, timeout);
443      }
444  }
445 
446 
447   function transfer(address _to, uint256 _value) public whenNotPaused ifNotLocked(msg.sender)  returns (bool)
448   {
449     return super.transfer(_to, _value);
450   }
451 
452   function transferFrom(address _from,address _to,uint256 _value)public whenNotPaused ifNotLocked(_from) returns (bool)
453   {
454     return super.transferFrom(_from, _to, _value);
455   }
456 
457   function approve(
458     address _spender,
459     uint256 _value
460   )
461     public
462     whenNotPaused
463     returns (bool)
464   {
465     return super.approve(_spender, _value);
466   }
467 
468   function increaseApproval(
469     address _spender,
470     uint _addedValue
471   )
472     public
473     whenNotPaused
474     returns (bool success)
475   {
476     return super.increaseApproval(_spender, _addedValue);
477   }
478 
479 
480   function decreaseApproval(
481     address _spender,
482     uint _subtractedValue
483   )
484     public
485     whenNotPaused
486     returns (bool success)
487   {
488     return super.decreaseApproval(_spender, _subtractedValue);
489   }
490   
491 }
492 
493 //taken from OpenZeppelin in August 2018
494 contract BurnableToken is StandardToken{
495 
496   event Burn(address indexed burner, uint256 value);
497     
498     /**
499     * @dev Burns a specific amount of tokens.
500     * @param _from address from which the tokens are burned
501     * @param _value The amount of token to be burned.
502     */
503     function burnFrom(address _from, uint256 _value) public onlyOwner{
504     
505         require(_value <= balances[_from]);
506         // no need to require value <= totalSupply, since that would imply the
507         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
508         
509         balances[_from] = balances[_from].sub(_value);
510         totalSupply_ = totalSupply_.sub(_value);
511         emit Burn(_from, _value);
512         emit Transfer(_from, address(0), _value);
513     }
514 }
515 
516 //taken from OpenZeppelin in August 2018
517 contract MintableToken is StandardToken{
518   event Mint(address indexed to, uint256 amount);
519   event MintFinished();
520 
521   bool public mintingFinished = false;
522 
523 
524   modifier canMint() {
525     require(!mintingFinished);
526     _;
527   }
528 
529   modifier hasMintPermission() {
530     require(msg.sender == owner());
531     _;
532   }
533 
534   /**
535    * @dev Function to mint tokens
536    * @param _to The address that will receive the minted tokens.
537    * @param _amount The amount of tokens to mint.
538    * @return A boolean that indicates if the operation was successful.
539    */
540   function mint(
541     address _to,
542     uint256 _amount
543   )
544     hasMintPermission
545     canMint
546     public
547     returns (bool)
548   {
549     require(_to != address(0));
550     totalSupply_ = totalSupply_.add(_amount);
551     balances[_to] = balances[_to].add(_amount);
552     emit Mint(_to, _amount);
553     emit Transfer(address(0), _to, _amount);
554     return true;
555   }
556 
557   /**
558    * @dev Function to stop minting new tokens.
559    * @return True if the operation was successful.
560    */
561   function finishMinting() onlyOwner canMint public returns (bool) {
562     mintingFinished = true;
563     emit MintFinished();
564     return true;
565   }
566 }
567 
568 contract DividendPayingToken is PausableToken, BurnableToken, MintableToken{
569     
570     event PayedDividendEther(address receiver, uint256 amount);
571     event PayedDividendFromReserve(address receiver, uint256 amount);
572     
573     uint256 EligibilityThreshold;
574     
575     address TokenReserveAddress;
576     
577     
578     modifier isEligible(address _receiver){
579         balanceOf(_receiver) >= EligibilityThreshold;
580         _;
581     }
582     
583     function setEligibilityThreshold(uint256 _value) public onlyOwner returns(bool) {
584         EligibilityThreshold = _value;
585         return true;
586     }
587     
588     function setTokenReserveAddress(address _newAddress) public onlyOwner returns(bool) {
589         TokenReserveAddress = _newAddress;
590         return true;
591     }
592     
593     function approvePayoutFromReserve(uint256 _value) public onlyOwner returns(bool) {
594         allowed[TokenReserveAddress][msg.sender] = _value;
595         emit Approval(TokenReserveAddress,msg.sender, _value);
596         return true;
597     }
598     
599     function payDividentFromReserve(address _to, uint256 _amount) public onlyOwner isEligible(_to) returns(bool){
600         emit PayedDividendFromReserve(_to, _amount);
601         return transferFrom(TokenReserveAddress,_to, _amount);
602     } 
603     
604     function payDividendInEther(address _to, uint256 _amount) public onlyOwner isEligible(_to) returns(bool){
605         require(address(this).balance >= _amount );
606         _to.transfer(_amount);
607         emit PayedDividendEther(_to, _amount);
608         return true;
609     }
610     
611     function depositEtherForDividends(uint256 _amount) public payable onlyOwner returns(bool){
612         require(msg.value == _amount);
613         return true;
614     }
615     
616     function withdrawEther(uint256 _amount) public onlyOwner returns(bool){
617         require(address(this).balance >= _amount );
618         owner().transfer(_amount);
619         return true;
620     }
621     
622     
623     
624 }
625 
626 contract SET is DividendPayingToken{
627     
628     string public name = "Securosys";
629     string public symbol = "SET";
630     uint8 public decimals = 18;
631 }