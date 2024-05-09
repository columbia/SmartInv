1 pragma solidity ^0.4.13;
2 
3 interface tokenRecipient { 
4 
5     function receiveApproval(
6 
7         address _from, 
8 
9         uint256 _value,
10 
11         address _token, 
12 
13         bytes _extraData
14 
15     ) public; 
16 
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 contract Ownable {
49   address public owner;
50 
51 
52   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55   /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59   function Ownable() public {
60     owner = msg.sender;
61   }
62 
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) public onlyOwner {
78     require(newOwner != address(0));
79     OwnershipTransferred(owner, newOwner);
80     owner = newOwner;
81   }
82 
83 }
84 
85 contract Pausable is Ownable {
86   event Pause();
87   event Unpause();
88 
89   bool public paused = false;
90 
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is not paused.
94    */
95   modifier whenNotPaused() {
96     require(!paused);
97     _;
98   }
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is paused.
102    */
103   modifier whenPaused() {
104     require(paused);
105     _;
106   }
107 
108   /**
109    * @dev called by the owner to pause, triggers stopped state
110    */
111   function pause() onlyOwner whenNotPaused public {
112     paused = true;
113     Pause();
114   }
115 
116   /**
117    * @dev called by the owner to unpause, returns to normal state
118    */
119   function unpause() onlyOwner whenPaused public {
120     paused = false;
121     Unpause();
122   }
123 }
124 
125 contract ERC20Basic {
126   uint256 public totalSupply;
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 contract BasicToken is ERC20Basic {
133   using SafeMath for uint256;
134 
135   mapping(address => uint256) balances;
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     // SafeMath.sub will throw if there is not enough balance.
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 contract BurnableToken is BasicToken {
165 
166     event Burn(address indexed burner, uint256 value);
167 
168     /**
169      * @dev Burns a specific amount of tokens.
170      * @param _value The amount of token to be burned.
171      */
172     function burn(uint256 _value) public {
173         require(_value <= balances[msg.sender]);
174         // no need to require value <= totalSupply, since that would imply the
175         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
176 
177         address burner = msg.sender;
178         balances[burner] = balances[burner].sub(_value);
179         totalSupply = totalSupply.sub(_value);
180         Burn(burner, _value);
181     }
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
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
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amounts of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amounts of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amounts of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amounts of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amounts of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amounts of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amounts of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amounts of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply = totalSupply.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327     return super.approve(_spender, _value);
328   }
329 
330   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331     return super.increaseApproval(_spender, _addedValue);
332   }
333 
334   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335     return super.decreaseApproval(_spender, _subtractedValue);
336   }
337 }
338 
339 contract DRCTestToken is BurnableToken, MintableToken, PausableToken {    
340 
341     string public name = 'DRC Test Token';
342 
343     string public symbol = 'DRCT';
344 
345     uint8 public decimals = 18;
346 
347     uint public INITIAL_SUPPLY = 250000000;
348 
349     uint public SECOND_SUPPLY = 450000000;
350 
351     uint public THIRD_SUPPLY = 300000000;
352 
353     uint8 public phase = 1;
354 
355 
356 
357     /**
358 
359      * constructs the token by total amount 
360 
361      *
362 
363      * there are 3 phases for releasing the tokens, initial balance is set. 
364 
365      */
366 
367     function DRCTestToken() public {
368 
369         totalSupply = INITIAL_SUPPLY + SECOND_SUPPLY + THIRD_SUPPLY;
370 
371         balances[msg.sender] = INITIAL_SUPPLY;
372 
373     }
374 
375 
376 
377     /**
378 
379      * start the second release phase 
380 
381      *
382 
383      * the second phase will use second supply amount of tokens 
384 
385      */
386 
387     function startSecondPhase() public {
388 
389         balances[msg.sender] = balances[msg.sender].add(SECOND_SUPPLY);
390 
391         phase = 2;
392 
393     }
394 
395 
396 
397     /**
398 
399      * start the third release phase 
400 
401      *
402 
403      * the third phase will use third supply amount of tokens 
404 
405      */
406 
407     function startThirdPhase() public {
408 
409         balances[msg.sender] = balances[msg.sender].add(THIRD_SUPPLY);
410 
411         phase = 3;
412 
413     }
414 
415 
416 
417     /**
418 
419      * get the first phase total supply
420 
421      */
422 
423     function getFirstPhaseCap() public view returns (uint256 firstSupply) {
424 
425         return INITIAL_SUPPLY;
426 
427     }
428 
429 
430 
431     /**
432 
433      * get the second phase total supply
434 
435      */
436 
437     function getSecondPhaseCap() public view returns (uint256 secondSupply) {
438 
439         return SECOND_SUPPLY;
440 
441     }
442 
443 
444 
445     /**
446 
447      * get the third phase total supply
448 
449      */
450 
451     function getThirdPhaseCap() public view returns (uint256 thirdSupply) {
452 
453         return THIRD_SUPPLY;
454 
455     }
456 
457 
458 
459     /**
460 
461      * get the phase number
462 
463      */
464 
465     function getPhase() public view returns (uint8 phaseNumber) {
466 
467         return phase;
468 
469     }
470 
471 
472 
473     /**
474 
475      * Destroy tokens from other accounts
476 
477      *
478 
479      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
480 
481      *
482 
483      * @param _from the address of the sender
484 
485      * @param _value the amount of money to burn
486 
487      */
488 
489     function burnFrom(address _from, uint256 _value) public returns (bool success) {
490 
491         require(balances[_from] >= _value);                // Check if the targeted balance is enough
492 
493         require(_value <= allowed[_from][msg.sender]);    // Check allowance
494 
495         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
496 
497         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
498 
499         totalSupply = totalSupply.sub(_value);
500 
501         Burn(_from, _value);
502 
503         return true;
504 
505     }
506 
507     
508 
509     /**
510 
511      * Set allowance for other address and notify
512 
513      *
514 
515      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
516 
517      *
518 
519      * @param _spender The address authorized to spend
520 
521      * @param _value the max amount they can spend
522 
523      * @param _extraData some extra information to send to the approved contract
524 
525      */
526 
527     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
528 
529         tokenRecipient spender = tokenRecipient(_spender);
530 
531         if (approve(_spender, _value)) {
532 
533             spender.receiveApproval(msg.sender, _value, this, _extraData);
534 
535             return true;
536 
537         }
538 
539     }
540 
541 }