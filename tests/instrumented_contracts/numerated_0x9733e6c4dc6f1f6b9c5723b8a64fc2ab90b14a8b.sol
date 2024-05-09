1 pragma solidity ^0.4.18;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9 
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure
16         returns (uint256)
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure
25         returns (uint256)
26     {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure
33         returns (uint256)
34     {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable
49 {
50     address owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 }
80 
81 interface tokenRecipient
82 {
83     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
84 }
85 
86 contract TokenERC20 is Ownable
87 {
88     using SafeMath for uint;
89 
90     // Public variables of the token
91     string public name;
92     string public symbol;
93     uint256 public decimals = 18;
94     uint256 DEC = 10 ** uint256(decimals);
95     uint256 public totalSupply;
96     uint256 public avaliableSupply;
97     uint256 public buyPrice = 1000000000000000000 wei;
98 
99     // This creates an array with all balances
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     // This generates a public event on the blockchain that will notify clients
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Burn(address indexed from, uint256 value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 
108     /**
109      * Constrctor function
110      *
111      * Initializes contract with initial supply tokens to the creator of the contract
112      */
113     function TokenERC20(
114         uint256 initialSupply,
115         string tokenName,
116         string tokenSymbol
117     ) public
118     {
119         totalSupply = initialSupply.mul(DEC);  // Update total supply with the decimal amount
120         balanceOf[this] = totalSupply;         // Give the creator all initial tokens
121         avaliableSupply = balanceOf[this];     // Show how much tokens on contract
122         name = tokenName;                      // Set the name for display purposes
123         symbol = tokenSymbol;                  // Set the symbol for display purposes
124     }
125 
126     /**
127      * Internal transfer, only can be called by this contract
128      *
129      * @param _from - address of the contract
130      * @param _to - address of the investor
131      * @param _value - tokens for the investor
132      */
133     function _transfer(address _from, address _to, uint256 _value) internal
134     {
135         // Prevent transfer to 0x0 address. Use burn() instead
136         require(_to != 0x0);
137         // Check if the sender has enough
138         require(balanceOf[_from] >= _value);
139         // Check for overflows
140         require(balanceOf[_to].add(_value) > balanceOf[_to]);
141         // Save this for an assertion in the future
142         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
143         // Subtract from the sender
144         balanceOf[_from] = balanceOf[_from].sub(_value);
145         // Add the same to the recipient
146         balanceOf[_to] = balanceOf[_to].add(_value);
147 
148         Transfer(_from, _to, _value);
149         // Asserts are used to use static analysis to find bugs in your code. They should never fail
150         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
151     }
152 
153     /**
154      * Transfer tokens
155      *
156      * Send `_value` tokens to `_to` from your account
157      *
158      * @param _to The address of the recipient
159      * @param _value the amount to send
160      */
161     function transfer(address _to, uint256 _value) public
162     {
163         _transfer(msg.sender, _to, _value);
164     }
165 
166     /**
167      * Transfer tokens from other address
168      *
169      * Send `_value` tokens to `_to` in behalf of `_from`
170      *
171      * @param _from The address of the sender
172      * @param _to The address of the recipient
173      * @param _value the amount to send
174      */
175     function transferFrom(address _from, address _to, uint256 _value) public
176         returns (bool success)
177     {
178         require(_value <= allowance[_from][msg.sender]);     // Check allowance
179 
180         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
181         _transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186     /**
187      * Set allowance for other address
188      *
189      * Allows `_spender` to spend no more than `_value` tokens in your behalf
190      *
191      * @param _spender The address authorized to spend
192      * @param _value the max amount they can spend
193      */
194     function approve(address _spender, uint256 _value) public
195         returns (bool success)
196     {
197         allowance[msg.sender][_spender] = _value;
198 
199         return true;
200     }
201 
202     /**
203      * Set allowance for other address and notify
204      *
205      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
206      *
207      * @param _spender The address authorized to spend
208      * @param _value the max amount they can spend
209      * @param _extraData some extra information to send to the approved contract
210      */
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner
212         returns (bool success)
213     {
214         tokenRecipient spender = tokenRecipient(_spender);
215 
216         if (approve(_spender, _value)) {
217             spender.receiveApproval(msg.sender, _value, this, _extraData);
218 
219             return true;
220         }
221     }
222 
223     /**
224      * approve should be called when allowed[_spender] == 0. To increment
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      */
229     function increaseApproval (address _spender, uint _addedValue) public
230         returns (bool success)
231     {
232         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
233 
234         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
235 
236         return true;
237     }
238 
239     function decreaseApproval (address _spender, uint _subtractedValue) public
240         returns (bool success)
241     {
242         uint oldValue = allowance[msg.sender][_spender];
243 
244         if (_subtractedValue > oldValue) {
245             allowance[msg.sender][_spender] = 0;
246         } else {
247             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248         }
249 
250         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
251 
252         return true;
253     }
254 
255     /**
256      * Destroy tokens
257      *
258      * Remove `_value` tokens from the system irreversibly
259      *
260      * @param _value the amount of money to burn
261      */
262     function burn(uint256 _value) public onlyOwner
263         returns (bool success)
264     {
265         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
266 
267         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
268         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
269         avaliableSupply = avaliableSupply.sub(_value);
270 
271         Burn(msg.sender, _value);
272 
273         return true;
274     }
275 
276     /**
277      * Destroy tokens from other account
278      *
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _value the amount of money to burn
283      */
284     function burnFrom(address _from, uint256 _value) public onlyOwner
285         returns (bool success)
286     {
287         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
288         require(_value <= allowance[_from][msg.sender]);    // Check allowance
289 
290         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
291         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);    // Subtract from the sender's allowance
292         totalSupply = totalSupply.sub(_value);              // Update totalSupply
293         avaliableSupply = avaliableSupply.sub(_value);
294 
295         Burn(_from, _value);
296 
297         return true;
298     }
299 }
300 
301 contract Pauseble is TokenERC20
302 {
303     event EPause();
304     event EUnpause();
305 
306     bool public paused = true;
307     uint public startIcoDate = 0;
308 
309     modifier whenNotPaused()
310     {
311         require(!paused);
312         _;
313     }
314 
315     modifier whenPaused()
316     {
317         require(paused);
318         _;
319     }
320 
321     function pause() public onlyOwner
322     {
323         paused = true;
324         EPause();
325     }
326 
327     function pauseInternal() internal
328     {
329         paused = true;
330         EPause();
331     }
332 
333     function unpause() public onlyOwner
334     {
335         paused = false;
336         EUnpause();
337     }
338 
339     function unpauseInternal() internal
340     {
341         paused = false;
342         EUnpause();
343     }
344 }
345 
346 contract ERC20Extending is TokenERC20
347 {
348     using SafeMath for uint;
349 
350     /**
351     * Function for transfer ethereum from contract to any address
352     *
353     * @param _to - address of the recipient
354     * @param amount - ethereum
355     */
356     function transferEthFromContract(address _to, uint256 amount) public onlyOwner
357     {
358         _to.transfer(amount);
359     }
360 
361     /**
362     * Function for transfer tokens from contract to any address
363     *
364     */
365     function transferTokensFromContract(address _to, uint256 _value) public onlyOwner
366     {
367         avaliableSupply = avaliableSupply.sub(_value);
368         _transfer(this, _to, _value);
369     }
370 }
371 
372 contract StreamityCrowdsale is Pauseble
373 {
374     using SafeMath for uint;
375 
376     uint public stage = 0;
377     uint256 public weisRaised;  // how many weis was raised on crowdsale
378 
379     event CrowdSaleFinished(string info);
380 
381     struct Ico {
382         uint256 tokens;             // Tokens in crowdsale
383         uint startDate;             // Date when crowsale will be starting, after its starting that property will be the 0
384         uint endDate;               // Date when crowdsale will be stop
385         uint8 discount;             // Discount
386         uint8 discountFirstDayICO;  // Discount. Only for first stage ico
387     }
388 
389     Ico public ICO;
390 
391     /*
392     * Function confirm autosell
393     *
394     */
395     function confirmSell(uint256 _amount) internal view
396         returns(bool)
397     {
398         if (ICO.tokens < _amount) {
399             return false;
400         }
401 
402         return true;
403     }
404 
405     /*
406     *  Make discount
407     */
408     function countDiscount(uint256 amount) internal
409         returns(uint256)
410     {
411         uint256 _amount = (amount.mul(DEC)).div(buyPrice);
412 
413         if (1 == stage) {
414             _amount = _amount.add(withDiscount(_amount, ICO.discount));
415         }
416         else if (2 == stage)
417         {
418             if (now <= ICO.startDate + 1 days)
419             {
420                 if (0 == ICO.discountFirstDayICO) {
421                     ICO.discountFirstDayICO = 20;
422                 }
423                 _amount = _amount.add(withDiscount(_amount, ICO.discountFirstDayICO));
424             }
425             else
426             {
427                 _amount = _amount.add(withDiscount(_amount, ICO.discount));
428             }
429         }
430         else if (3 == stage) {
431             _amount = _amount.add(withDiscount(_amount, ICO.discount));
432         }
433 
434         return _amount;
435     }
436 
437     /**
438     * Function for change discount if need
439     *
440     */
441     function changeDiscount(uint8 _discount) public onlyOwner
442         returns (bool)
443     {
444         ICO = Ico (ICO.tokens, ICO.startDate, ICO.endDate, _discount, ICO.discountFirstDayICO);
445         return true;
446     }
447 
448     /**
449     * Expanding of the functionality
450     *
451     * @param _numerator - Numerator - value (10000)
452     * @param _denominator - Denominator - value (10000)
453     *
454     * example: price 1000 tokens by 1 ether = changeRate(1, 1000)
455     */
456     function changeRate(uint256 _numerator, uint256 _denominator) public onlyOwner
457         returns (bool success)
458     {
459         if (_numerator == 0) _numerator = 1;
460         if (_denominator == 0) _denominator = 1;
461 
462         buyPrice = (_numerator.mul(DEC)).div(_denominator);
463 
464         return true;
465     }
466 
467     /*
468     * Function show in contract what is now
469     *
470     */
471     function crowdSaleStatus() internal constant
472         returns (string)
473     {
474         if (1 == stage) {
475             return "Pre-ICO";
476         } else if(2 == stage) {
477             return "ICO first stage";
478         } else if (3 == stage) {
479             return "ICO second stage";
480         } else if (4 >= stage) {
481             return "feature stage";
482         }
483 
484         return "there is no stage at present";
485     }
486 
487     /*
488     * Seles manager
489     *
490     */
491     function paymentManager(address sender, uint256 value) internal
492     {
493         uint256 discountValue = countDiscount(value);
494         bool conf = confirmSell(discountValue);
495 
496         if (conf) {
497 
498             sell(sender, discountValue);
499 
500             weisRaised = weisRaised.add(value);
501 
502             if (now >= ICO.endDate) {
503                 pauseInternal();
504                 CrowdSaleFinished(crowdSaleStatus()); // if time is up
505             }
506 
507         } else {
508 
509             sell(sender, ICO.tokens); // sell tokens which has been accessible
510 
511             weisRaised = weisRaised.add(value);
512 
513             pauseInternal();
514             CrowdSaleFinished(crowdSaleStatus());  // if tokens sold
515         }
516     }
517 
518     /*
519     * Function for selling tokens in crowd time.
520     *
521     */
522     function sell(address _investor, uint256 _amount) internal
523     {
524         ICO.tokens = ICO.tokens.sub(_amount);
525         avaliableSupply = avaliableSupply.sub(_amount);
526 
527         _transfer(this, _investor, _amount);
528     }
529 
530     /*
531     * Function for start crowdsale (any)
532     *
533     * @param _tokens - How much tokens will have the crowdsale - amount humanlike value (10000)
534     * @param _startDate - When crowdsale will be start - unix timestamp (1512231703 )
535     * @param _endDate - When crowdsale will be end - humanlike value (7) same as 7 days
536     * @param _discount - Discount for the crowd - humanlive value (7) same as 7 %
537     * @param _discount - Discount for the crowds first day - humanlive value (7) same as 7 %
538     */
539     function startCrowd(uint256 _tokens, uint _startDate, uint _endDate, uint8 _discount, uint8 _discountFirstDayICO) public onlyOwner
540     {
541         require(_tokens * DEC <= avaliableSupply);  // require to set correct tokens value for crowd
542         ICO = Ico (_tokens * DEC, _startDate, _startDate + _endDate * 1 days , _discount, _discountFirstDayICO);
543         stage = stage.add(1);
544         unpauseInternal();
545     }
546 
547     /**
548     * Function for web3js, should be call when somebody will buy tokens from website. This function only delegator.
549     *
550     * @param _investor - address of investor (who payed)
551     * @param _amount - ethereum
552     */
553     function transferWeb3js(address _investor, uint256 _amount) external onlyOwner
554     {
555         sell(_investor, _amount);
556     }
557 
558     /**
559     * Function for adding discount
560     *
561     */
562     function withDiscount(uint256 _amount, uint _percent) internal pure
563         returns (uint256)
564     {
565         return (_amount.mul(_percent)).div(100);
566     }
567 }
568 
569 contract StreamityContract is ERC20Extending, StreamityCrowdsale
570 {
571     /* Streamity tokens Constructor */
572     function StreamityContract() public TokenERC20(186000000, "Streamity", "STM") {} //change before send !!!
573 
574     /**
575     * Function payments handler
576     *
577     */
578     function () public payable
579     {
580         assert(msg.value >= 1 ether / 10);
581         require(now >= ICO.startDate);
582 
583         if (paused == false) {
584             paymentManager(msg.sender, msg.value);
585         } else {
586             revert();
587         }
588     }
589 }