1 pragma solidity ^0.4.12;
2 
3 
4 
5 /**
6 
7  * @title SafeMath
8 
9  * @dev Math operations with safety checks that throw on error
10 
11  */
12 
13 library SafeMath {
14 
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 
17     uint256 c = a * b;
18 
19     assert(a == 0 || c / a == b);
20 
21     return c;
22 
23   }
24 
25 
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28 
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30 
31     uint256 c = a / b;
32 
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35     return c;
36 
37   }
38 
39 
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42 
43     assert(b <= a);
44 
45     return a - b;
46 
47   }
48 
49 
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52 
53     uint256 c = a + b;
54 
55     assert(c >= a);
56 
57     return c;
58 
59   }
60 
61 }
62 
63 
64 
65 
66 
67 /**
68 
69  * @title Ownable
70 
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72 
73  * functions, this simplifies the implementation of "user permissions".
74 
75  */
76 
77 contract Ownable {
78 
79   address public owner;
80 
81 
82 
83 
84 
85   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87 
88 
89 
90 
91   /**
92 
93    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
94 
95    * account.
96 
97    */
98 
99   function Ownable() {
100 
101     owner = msg.sender;
102 
103   }
104 
105 
106 
107 
108 
109   /**
110 
111    * @dev Throws if called by any account other than the owner.
112 
113    */
114 
115   modifier onlyOwner() {
116 
117     require(msg.sender == owner);
118 
119     _;
120 
121   }
122 
123 
124 
125 
126 
127   /**
128 
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130 
131    * @param newOwner The address to transfer ownership to.
132 
133    */
134 
135   function transferOwnership(address newOwner) onlyOwner public {
136 
137     require(newOwner != address(0));
138 
139     OwnershipTransferred(owner, newOwner);
140 
141     owner = newOwner;
142 
143   }
144 
145 }
146 
147 
148 
149 /**
150 
151  * @title ERC20Basic
152 
153  * @dev Simpler version of ERC20 interface
154 
155  * @dev see https://github.com/ethereum/EIPs/issues/179
156 
157  */
158 
159 contract ERC20Basic {
160 
161   uint256 public totalSupply;
162 
163   function balanceOf(address who) public constant returns (uint256);
164 
165   function transfer(address to, uint256 value) public returns (bool);
166 
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 
169 }
170 
171 
172 
173 
174 
175 /**
176 
177  * @title Basic token
178 
179  * @dev Basic version of StandardToken, with no allowances.
180 
181  */
182 
183 contract BasicToken is ERC20Basic {
184 
185   using SafeMath for uint256;
186 
187 
188 
189   mapping(address => uint256) balances;
190 
191 
192 
193   /*************************************************/
194 
195     mapping(address=>uint256) public indexes;
196 
197     mapping(uint256=>address) public addresses;
198 
199     uint256 public lastIndex = 0;
200 
201   /*************************************************/
202 
203 
204 
205   /**
206 
207   * @dev transfer token for a specified address
208 
209   * @param _to The address to transfer to.
210 
211   * @param _value The amount to be transferred.
212 
213   */
214 
215   function transfer(address _to, uint256 _value) public returns (bool) {
216 
217     require(_to != address(0));
218 
219 
220 
221     // SafeMath.sub will throw if there is not enough balance.
222 
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224 
225     balances[_to] = balances[_to].add(_value);
226 
227     Transfer(msg.sender, _to, _value);
228 
229     if(_value > 0){
230 
231         if(balances[msg.sender] == 0){
232 
233             addresses[indexes[msg.sender]] = addresses[lastIndex];
234 
235             indexes[addresses[lastIndex]] = indexes[msg.sender];
236 
237             indexes[msg.sender] = 0;
238 
239             delete addresses[lastIndex];
240 
241             lastIndex--;
242 
243         }
244 
245         if(indexes[_to]==0){
246 
247             lastIndex++;
248 
249             addresses[lastIndex] = _to;
250 
251             indexes[_to] = lastIndex;
252 
253         }
254 
255     }
256 
257     return true;
258 
259   }
260 
261 
262 
263   /**
264 
265   * @dev Gets the balance of the specified address.
266 
267   * @param _owner The address to query the the balance of.
268 
269   * @return An uint256 representing the amount owned by the passed address.
270 
271   */
272 
273   function balanceOf(address _owner) public constant returns (uint256 balance) {
274 
275     return balances[_owner];
276 
277   }
278 
279 }
280 
281 
282 
283 /**
284 
285  * @title ERC20 interface
286 
287  * @dev see https://github.com/ethereum/EIPs/issues/20
288 
289  */
290 
291 contract ERC20 is ERC20Basic {
292 
293   function allowance(address owner, address spender) public constant returns (uint256);
294 
295   function transferFrom(address from, address to, uint256 value) public returns (bool);
296 
297   function approve(address spender, uint256 value) public returns (bool);
298 
299   event Approval(address indexed owner, address indexed spender, uint256 value);
300 
301 }
302 
303 
304 
305 
306 
307 /**
308 
309  * @title Standard ERC20 token
310 
311  *
312 
313  * @dev Implementation of the basic standard token.
314 
315  * @dev https://github.com/ethereum/EIPs/issues/20
316 
317  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
318 
319  */
320 
321 contract StandardToken is ERC20, BasicToken {
322 
323 
324 
325   mapping (address => mapping (address => uint256)) allowed;
326 
327 
328 
329 
330 
331   /**
332 
333    * @dev Transfer tokens from one address to another
334 
335    * @param _from address The address which you want to send tokens from
336 
337    * @param _to address The address which you want to transfer to
338 
339    * @param _value uint256 the amount of tokens to be transferred
340 
341    */
342 
343   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
344 
345     require(_to != address(0));
346 
347 
348 
349     uint256 _allowance = allowed[_from][msg.sender];
350 
351 
352 
353     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
354 
355     // require (_value <= _allowance);
356 
357 
358 
359     balances[_from] = balances[_from].sub(_value);
360 
361     balances[_to] = balances[_to].add(_value);
362 
363     allowed[_from][msg.sender] = _allowance.sub(_value);
364 
365     Transfer(_from, _to, _value);
366 
367     return true;
368 
369   }
370 
371 
372 
373   /**
374 
375    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
376 
377    *
378 
379    * Beware that changing an allowance with this method brings the risk that someone may use both the old
380 
381    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
382 
383    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
384 
385    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386 
387    * @param _spender The address which will spend the funds.
388 
389    * @param _value The amount of tokens to be spent.
390 
391    */
392 
393   function approve(address _spender, uint256 _value) public returns (bool) {
394 
395     allowed[msg.sender][_spender] = _value;
396 
397     Approval(msg.sender, _spender, _value);
398 
399     return true;
400 
401   }
402 
403 
404 
405   /**
406 
407    * @dev Function to check the amount of tokens that an owner allowed to a spender.
408 
409    * @param _owner address The address which owns the funds.
410 
411    * @param _spender address The address which will spend the funds.
412 
413    * @return A uint256 specifying the amount of tokens still available for the spender.
414 
415    */
416 
417   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
418 
419     return allowed[_owner][_spender];
420 
421   }
422 
423 
424 
425   /**
426 
427    * approve should be called when allowed[_spender] == 0. To increment
428 
429    * allowed value is better to use this function to avoid 2 calls (and wait until
430 
431    * the first transaction is mined)
432 
433    * From MonolithDAO Token.sol
434 
435    */
436 
437   function increaseApproval (address _spender, uint _addedValue)
438 
439     returns (bool success) {
440 
441     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
442 
443     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
444 
445     return true;
446 
447   }
448 
449 
450 
451   function decreaseApproval (address _spender, uint _subtractedValue)
452 
453     returns (bool success) {
454 
455     uint oldValue = allowed[msg.sender][_spender];
456 
457     if (_subtractedValue > oldValue) {
458 
459       allowed[msg.sender][_spender] = 0;
460 
461     } else {
462 
463       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
464 
465     }
466 
467     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
468 
469     return true;
470 
471   }
472 
473 }
474 
475 
476 
477 contract Minaxis  is StandardToken, Ownable {
478 
479 
480 
481     string public constant name = "Minaxis";
482 
483     string public constant symbol = "MIN";
484 
485     uint public constant decimals = 18;
486 
487     uint256 public constant initialSupply = 10000000 * (10 ** uint256(decimals));
488 
489 
490 
491     uint public totalWeiToBeDistributed = 0;
492 
493 
494 
495     // Constructor
496 
497     function Minaxis () {
498 
499         totalSupply = initialSupply;
500 
501         balances[msg.sender] = initialSupply; // Send all tokens to owner
502 
503         /*****************************************/
504 
505         addresses[1] = msg.sender;
506 
507         indexes[msg.sender] = 1;
508 
509         lastIndex = 1;
510 
511         /*****************************************/
512 
513     }
514 
515 
516 
517     function getAddresses() constant returns (address[]){
518 
519         address[] memory addrs = new address[](lastIndex);
520 
521         for(uint i = 0; i < lastIndex; i++){
522 
523             addrs[i] = addresses[i+1];
524 
525         }
526 
527         return addrs;
528 
529     }
530 
531 
532 
533     function setTotalWeiToBeDistributed(uint _totalWei) onlyOwner {
534 
535       totalWeiToBeDistributed = _totalWei;
536 
537     }
538 
539 
540 
541     function distributeEth(uint startIndex, uint endIndex) onlyOwner {
542 
543       for(uint i = startIndex; i < endIndex; ++i){
544 
545         address holder = addresses[i+1];
546 
547         uint reward = (balances[holder]*totalWeiToBeDistributed)/(totalSupply);
548 
549         if(!holder.send(reward)) throw;
550 
551       }
552 
553     }
554 
555 
556 
557     function withdrawEth() onlyOwner {
558 
559       if(!owner.send(this.balance)) throw;
560 
561     }
562 
563 
564 
565     function() payable {}
566 
567 }