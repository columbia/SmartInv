1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4 
5   function balanceOf(address who) public constant returns (uint256);
6 
7   function transfer(address to, uint256 value) public returns (bool);
8 
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 
11 }
12 
13 contract ERC20 is ERC20Basic {
14 
15   function allowance(address owner, address spender) public constant returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value) public returns (bool);
18 
19   function approve(address spender, uint256 value) public returns (bool);
20 
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23 }
24 
25 contract ERC223 is ERC20 {
26 
27 
28 
29     function name() constant returns (string _name);
30 
31     function symbol() constant returns (string _symbol);
32 
33     function decimals() constant returns (uint8 _decimals);
34 
35 
36 
37     function transfer(address to, uint256 value, bytes data) returns (bool);
38 
39 
40 
41 }
42 
43 contract ERC223ReceivingContract {
44 
45     function tokenFallback(address _from, uint256 _value, bytes _data);
46 
47 }
48 
49 contract KnowledgeTokenInterface is ERC223{
50 
51     event Mint(address indexed to, uint256 amount);
52 
53 
54 
55     function changeMinter(address newAddress) returns (bool);
56 
57     function mint(address _to, uint256 _amount) returns (bool);
58 
59 }
60 
61 contract Ownable {
62 
63   address public owner;
64 
65 
66 
67 
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71 
72 
73 
74 
75   /**
76 
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78 
79    * account.
80 
81    */
82 
83   function Ownable() {
84 
85     owner = msg.sender;
86 
87   }
88 
89 
90 
91 
92 
93   /**
94 
95    * @dev Throws if called by any account other than the owner.
96 
97    */
98 
99   modifier onlyOwner() {
100 
101     require(msg.sender == owner);
102 
103     _;
104 
105   }
106 
107 
108 
109 
110 
111   /**
112 
113    * @dev Allows the current owner to transfer control of the contract to a newOwner.
114 
115    * @param newOwner The address to transfer ownership to.
116 
117    */
118 
119   function transferOwnership(address newOwner) onlyOwner public {
120 
121     require(newOwner != address(0));
122 
123     OwnershipTransferred(owner, newOwner);
124 
125     owner = newOwner;
126 
127   }
128 
129 
130 
131 }
132 
133 library SafeMath {
134 
135   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
136 
137     uint256 c = a * b;
138 
139     assert(a == 0 || c / a == b);
140 
141     return c;
142 
143   }
144 
145 
146 
147   function div(uint256 a, uint256 b) internal constant returns (uint256) {
148 
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150 
151     uint256 c = a / b;
152 
153     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155     return c;
156 
157   }
158 
159 
160 
161   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
162 
163     assert(b <= a);
164 
165     return a - b;
166 
167   }
168 
169 
170 
171   function add(uint256 a, uint256 b) internal constant returns (uint256) {
172 
173     uint256 c = a + b;
174 
175     assert(c >= a);
176 
177     return c;
178 
179   }
180 
181 }
182 
183 contract ERC20BasicToken is ERC20Basic {
184 
185   using SafeMath for uint256;
186 
187 
188 
189   mapping(address => uint256) balances;
190 
191   uint256 public totalSupply;
192 
193 
194 
195   /**
196 
197   * @dev transfer token for a specified address
198 
199   * @param _to The address to transfer to.
200 
201   * @param _value The amount to be transferred.
202 
203   */
204 
205   function transfer(address _to, uint256 _value) public returns (bool) {
206 
207     require(_to != address(0));
208 
209 
210 
211     // SafeMath.sub will throw if there is not enough balance.
212 
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214 
215     balances[_to] = balances[_to].add(_value);
216 
217     Transfer(msg.sender, _to, _value);
218 
219     return true;
220 
221   }
222 
223 
224 
225   /**
226 
227   * @dev Gets the balance of the specified address.
228 
229   * @param _owner The address to query the the balance of.
230 
231   * @return An uint256 representing the amount owned by the passed address.
232 
233   */
234 
235   function balanceOf(address _owner) public constant returns (uint256 balance) {
236 
237     return balances[_owner];
238 
239   }
240 
241 
242 
243   function totalSupply() constant returns (uint256 _totalSupply) {
244 
245     return totalSupply;
246 
247   }
248 
249 
250 
251 }
252 
253 contract ERC20Token is ERC20, ERC20BasicToken {
254 
255 
256 
257   mapping (address => mapping (address => uint256)) allowed;
258 
259 
260 
261   /**
262 
263    * @dev Transfer tokens from one address to another
264 
265    * @param _from address The address which you want to send tokens from
266 
267    * @param _to address The address which you want to transfer to
268 
269    * @param _value uint256 the amount of tokens to be transferred
270 
271    */
272 
273   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
274 
275     require(_to != address(0));
276 
277 
278 
279     uint256 _allowance = allowed[_from][msg.sender];
280 
281 
282 
283     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
284 
285     // require (_value <= _allowance);
286 
287 
288 
289     balances[_from] = balances[_from].sub(_value);
290 
291     balances[_to] = balances[_to].add(_value);
292 
293     allowed[_from][msg.sender] = _allowance.sub(_value);
294 
295     Transfer(_from, _to, _value);
296 
297     return true;
298 
299   }
300 
301 
302 
303   /**
304 
305    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306 
307    *
308 
309    * Beware that changing an allowance with this method brings the risk that someone may use both the old
310 
311    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
312 
313    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
314 
315    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
316 
317    * @param _spender The address which will spend the funds.
318 
319    * @param _value The amount of tokens to be spent.
320 
321    */
322 
323   function approve(address _spender, uint256 _value) public returns (bool) {
324 
325     allowed[msg.sender][_spender] = _value;
326 
327     Approval(msg.sender, _spender, _value);
328 
329     return true;
330 
331   }
332 
333 
334 
335   /**
336 
337    * @dev Function to check the amount of tokens that an owner allowed to a spender.
338 
339    * @param _owner address The address which owns the funds.
340 
341    * @param _spender address The address which will spend the funds.
342 
343    * @return A uint256 specifying the amount of tokens still available for the spender.
344 
345    */
346 
347   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
348 
349     return allowed[_owner][_spender];
350 
351   }
352 
353 
354 
355   /**
356 
357    * approve should be called when allowed[_spender] == 0. To increment
358 
359    * allowed value is better to use this function to avoid 2 calls (and wait until
360 
361    * the first transaction is mined)
362 
363    * From MonolithDAO Token.sol
364 
365    */
366 
367   function increaseApproval (address _spender, uint _addedValue)
368 
369     returns (bool success) {
370 
371     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
372 
373     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374 
375     return true;
376 
377   }
378 
379 
380 
381   function decreaseApproval (address _spender, uint _subtractedValue)
382 
383     returns (bool success) {
384 
385     uint oldValue = allowed[msg.sender][_spender];
386 
387     if (_subtractedValue > oldValue) {
388 
389       allowed[msg.sender][_spender] = 0;
390 
391     } else {
392 
393       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
394 
395     }
396 
397     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398 
399     return true;
400 
401   }
402 
403 
404 
405 }
406 
407 contract ERC223Token is ERC223, ERC20Token {
408 
409     using SafeMath for uint256;
410 
411 
412 
413     string public name;
414 
415 
416 
417     string public symbol;
418 
419 
420 
421     uint8 public decimals;
422 
423 
424 
425 
426 
427     // Function to access name of token .
428 
429     function name() constant returns (string _name) {
430 
431         return name;
432 
433     }
434 
435     // Function to access symbol of token .
436 
437     function symbol() constant returns (string _symbol) {
438 
439         return symbol;
440 
441     }
442 
443     // Function to access decimals of token .
444 
445     function decimals() constant returns (uint8 _decimals) {
446 
447         return decimals;
448 
449     }
450 
451 
452 
453 
454 
455     // Function that is called when a user or another contract wants to transfer funds .
456 
457     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
458 
459         if (isContract(_to)) {
460 
461             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
462 
463             receiver.tokenFallback(msg.sender, _value, _data);
464 
465         }
466 
467         return super.transfer(_to, _value);
468 
469     }
470 
471 
472 
473     // Standard function transfer similar to ERC20 transfer with no _data .
474 
475     // Added due to backwards compatibility reasons .
476 
477     function transfer(address _to, uint256 _value) returns (bool success) {
478 
479         if (isContract(_to)) {
480 
481             bytes memory empty;
482 
483             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
484 
485             receiver.tokenFallback(msg.sender, _value, empty);
486 
487         }
488 
489         return super.transfer(_to, _value);
490 
491     }
492 
493 
494 
495     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
496 
497     function isContract(address _addr) private returns (bool is_contract) {
498 
499         uint length;
500 
501         assembly {
502 
503             length := extcodesize(_addr)
504 
505         }
506 
507         return (length > 0);
508 
509     }
510 
511 
512 
513 }
514 
515 contract KnowledgeToken is KnowledgeTokenInterface, Ownable, ERC223Token {
516 
517 
518 
519     address public minter;
520 
521 
522 
523     modifier onlyMinter() {
524 
525         // Only minter is allowed to proceed.
526 
527         require (msg.sender == minter);
528 
529         _;
530 
531     }
532 
533 
534 
535     function mint(address _to, uint256 _amount) onlyMinter public returns (bool) {
536 
537         totalSupply = totalSupply.add(_amount);
538 
539         balances[_to] = balances[_to].add(_amount);
540 
541         Transfer(0x0, _to, _amount);
542 
543         Mint(_to, _amount);
544 
545         return true;
546 
547     }
548 
549 
550 
551     function changeMinter(address newAddress) public onlyOwner returns (bool)
552 
553     {
554 
555         minter = newAddress;
556 
557     }
558 
559 }
560 
561 contract WitCoin is KnowledgeToken{
562 
563 
564 
565     function WitCoin() {
566 
567         totalSupply = 0;
568 
569         name = "Witcoin";
570 
571         symbol = "WIT";
572 
573         decimals = 8;
574 
575     }
576 
577 
578 
579 }