1 pragma solidity ^0.4.18;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure
14         returns (uint256)
15     {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure
21         returns (uint256)
22     {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure
28         returns (uint256)
29     {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title OwnableToken
38  * @dev The OwnableToken contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract OwnableToken
42 {
43     address owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev The OwnableToken constructor sets the original `owner` of the contract to the sender
49      * account.
50      */
51     function OwnableToken() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 }
73 
74 
75 interface tokenRecipient
76 {
77     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
78 }
79 
80 /**
81  * @title ERC20
82  * @dev eip20 token implementation
83  */
84 contract ERC20 is OwnableToken
85 {
86     using SafeMath for uint;
87 
88     uint256 constant MAX_UINT256 = 2**256 - 1;
89 
90     // Public variables of the token
91     string public name;
92     string public symbol;
93     uint256 public decimals = 8;
94     uint256 DEC = 10 ** uint256(decimals);
95     uint256 public totalSupply;
96     uint256 public price = 0 wei;
97 
98     // This creates an array with all balances
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowance;
101 
102     // This generates a public event on the blockchain that will notify clients
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Burn(address indexed from, uint256 value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107     /**
108      * Constrctor function
109      *
110      * Initializes contract with initial supply tokens to the creator of the contract
111      */
112     function ERC20(
113         uint256 initialSupply,
114         string tokenName,
115         string tokenSymbol
116     ) public
117     {
118         totalSupply = initialSupply.mul(DEC);  // Update total supply with the decimal amount
119         balances[msg.sender] = totalSupply;         // Give the creator all initial tokens
120         name = tokenName;                      // Set the name for display purposes
121         symbol = tokenSymbol;                  // Set the symbol for display purposes
122     }
123 
124     /**
125      * Internal transfer, only can be called by this contract
126      *
127      * @param _from - address of the contract
128      * @param _to - address of the investor
129      * @param _value - tokens for the investor
130      */
131     function _transfer(address _from, address _to, uint256 _value) internal
132     {
133         // Prevent transfer to 0x0 address. Use burn() instead
134         require(_to != 0x0);
135         // Check if the sender has enough
136         require(balances[_from] >= _value);
137         // Check for overflows
138         require(balances[_to].add(_value) > balances[_to]);
139         // Save this for an assertion in the future
140         uint previousBalances = balances[_from].add(balances[_to]);
141         // Subtract from the sender
142         balances[_from] = balances[_from].sub(_value);
143         // Add the same to the recipient
144         balances[_to] = balances[_to].add(_value);
145 
146         Transfer(_from, _to, _value);
147         // Asserts are used to use static analysis to find bugs in your code. They should never fail
148         assert(balances[_from].add(balances[_to]) == previousBalances);
149     }
150 
151     /**
152      * Transfer tokens
153      *
154      * Send `_value` tokens to `_to` from your account
155      *
156      * @param _to The address of the recipient
157      * @param _value the amount to send
158      */
159     function transfer(address _to, uint256 _value) public
160     {
161         _transfer(msg.sender, _to, _value);
162     }
163 
164     /**
165      * Balance show
166      *
167      * @param _holder current holder balance
168      */
169     function balanceOf(address _holder) view public
170         returns (uint256 balance)
171     {
172         return balances[_holder];
173     }
174 
175     /**
176      * Transfer tokens from other address
177      *
178      * Send `_value` tokens to `_to` in behalf of `_from`
179      *
180      * @param _from The address of the sender
181      * @param _to The address of the recipient
182      * @param _value the amount to send
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public
185         returns (bool success)
186     {
187         require(_value <= allowance[_from][msg.sender]);     // Check allowance
188 
189         if (allowance[_from][msg.sender] < MAX_UINT256) {
190             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
191         }
192 
193         _transfer(_from, _to, _value);
194 
195         return true;
196     }
197 
198     /**
199      * Set allowance for other address
200      *
201      * Allows `_spender` to spend no more than `_value` tokens in your behalf
202      *
203      * @param _spender The address authorized to spend
204      * @param _value the max amount they can spend
205      */
206     function approve(address _spender, uint256 _value) public
207         returns (bool success)
208     {
209         allowance[msg.sender][_spender] = _value;
210 
211         return true;
212     }
213 
214     /**
215      * Set allowance for other address and notify
216      *
217      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
218      *
219      * @param _spender The address authorized to spend
220      * @param _value the max amount they can spend
221      * @param _extraData some extra information to send to the approved contract
222      */
223     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner
224         returns (bool success)
225     {
226         tokenRecipient spender = tokenRecipient(_spender);
227 
228         if (approve(_spender, _value)) {
229             spender.receiveApproval(msg.sender, _value, this, _extraData);
230 
231             return true;
232         }
233     }
234 
235     /**
236      * approve should be called when allowed[_spender] == 0. To increment
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      */
241     function increaseApproval (address _spender, uint _addedValue) public
242         returns (bool success)
243     {
244         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
245 
246         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
247 
248         return true;
249     }
250 
251     function decreaseApproval (address _spender, uint _subtractedValue) public
252         returns (bool success)
253     {
254         uint oldValue = allowance[msg.sender][_spender];
255 
256         if (_subtractedValue > oldValue) {
257             allowance[msg.sender][_spender] = 0;
258         } else {
259             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260         }
261 
262         Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
263 
264         return true;
265     }
266 
267     /**
268      * Destroy tokens
269      *
270      * Remove `_value` tokens from the system irreversibly
271      *
272      * @param _value the amount of money to burn
273      */
274     function burn(uint256 _value) public onlyOwner
275         returns (bool success)
276     {
277         require(balances[msg.sender] >= _value);   // Check if the sender has enough
278 
279         balances[msg.sender] = balances[msg.sender].sub(_value);  // Subtract from the sender
280         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
281 
282         Burn(msg.sender, _value);
283 
284         return true;
285     }
286 
287     /**
288      * Destroy tokens from other account
289      *
290      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
291      *
292      * @param _from the address of the sender
293      * @param _value the amount of money to burn
294      */
295     function burnFrom(address _from, uint256 _value) public onlyOwner
296         returns (bool success)
297     {
298         require(balances[_from] >= _value);                // Check if the targeted balance is enough
299         require(_value <= allowance[_from][msg.sender]);    // Check allowance
300 
301         balances[_from] = balances[_from].sub(_value);    // Subtract from the targeted balance
302         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);    // Subtract from the sender's allowance
303         totalSupply = totalSupply.sub(_value);              // Update totalSupply
304 
305         Burn(_from, _value);
306 
307         return true;
308     }
309 }
310 
311 contract PausebleToken is ERC20
312 {
313     event EPause(address indexed owner, string indexed text);
314     event EUnpause(address indexed owner, string indexed text);
315 
316     bool public paused = true;
317 
318     modifier isPaused()
319     {
320         require(paused);
321         _;
322     }
323 
324     function pause() public onlyOwner
325     {
326         paused = true;
327         EPause(owner, 'sale is paused');
328     }
329 
330     function pauseInternal() internal
331     {
332         paused = true;
333         EPause(owner, 'sale is paused');
334     }
335 
336     function unpause() public onlyOwner
337     {
338         paused = false;
339         EUnpause(owner, 'sale is unpaused');
340     }
341 
342     function unpauseInternal() internal
343     {
344         paused = false;
345         EUnpause(owner, 'sale is unpaused');
346     }
347 }
348 
349 contract ERC20Extending is ERC20
350 {
351     using SafeMath for uint;
352 
353     /**
354     * Function for transfer ethereum from contract to any address
355     *
356     * @param _to - address of the recipient
357     * @param amount - ethereum
358     */
359     function transferEthFromContract(address _to, uint256 amount) public onlyOwner
360     {
361         _to.transfer(amount);
362     }
363 
364     /**
365     * Function for transfer tokens from contract to any address
366     *
367     */
368     function transferTokensFromContract(address _to, uint256 _value) public onlyOwner
369     {
370         _transfer(this, _to, _value);
371     }
372 }
373 
374 contract CrowdsaleContract is PausebleToken
375 {
376     using SafeMath for uint;
377 
378     uint256 public receivedEther;  // how many weis was raised on crowdsale
379 
380     event CrowdSaleFinished(address indexed owner, string indexed text);
381 
382     struct sale {
383         uint256 tokens;   // Tokens in crowdsale
384         uint startDate;   // Date when crowsale will be starting, after its starting that property will be the 0
385         uint endDate;     // Date when crowdsale will be stop
386     }
387 
388     sale public Sales;
389 
390     uint8 public discount;  // Discount
391 
392     /*
393     * Function confirm autofund
394     *
395     */
396     function confirmSell(uint256 _amount) internal view
397         returns(bool)
398     {
399         if (Sales.tokens < _amount) {
400             return false;
401         }
402 
403         return true;
404     }
405 
406     /*
407     *  Make discount
408     */
409     function countDiscount(uint256 amount) internal view
410         returns(uint256)
411     {
412         uint256 _amount = (amount.mul(DEC)).div(price);
413         _amount = _amount.add(withDiscount(_amount, discount));
414 
415         return _amount;
416     }
417 
418     /** +
419     * Function for change discount if need
420     *
421     */
422     function changeDiscount(uint8 _discount) public onlyOwner
423         returns (bool)
424     {
425         discount = _discount;
426         return true;
427     }
428 
429     /**
430     * Function for adding discount
431     *
432     */
433     function withDiscount(uint256 _amount, uint _percent) internal pure
434         returns (uint256)
435     {
436         return (_amount.mul(_percent)).div(100);
437     }
438 
439     /**
440     * Expanding of the functionality
441     *
442     * @param _price in weis
443     */
444     function changePrice(uint256 _price) public onlyOwner
445         returns (bool success)
446     {
447         require(_price != 0);
448         price = _price;
449         return true;
450     }
451 
452     /*
453     * Seles manager
454     *
455     */
456     function paymentManager(uint256 value) internal
457     {
458         uint256 _value = (value * 10 ** uint256(decimals)) / 10 ** uint256(18);
459         uint256 discountValue = countDiscount(_value);
460         bool conf = confirmSell(discountValue);
461 
462         // transfer all ether to the contract
463 
464         if (conf) {
465 
466             Sales.tokens = Sales.tokens.sub(_value);
467             receivedEther = receivedEther.add(value);
468 
469             if (now >= Sales.endDate) {
470                 pauseInternal();
471                 CrowdSaleFinished(owner, 'crowdsale is finished');
472             }
473 
474         } else {
475 
476             Sales.tokens = Sales.tokens.sub(Sales.tokens);
477             receivedEther = receivedEther.add(value);
478 
479             pauseInternal();
480             CrowdSaleFinished(owner, 'crowdsale is finished');
481         }
482     }
483 
484     function transfertWDiscount(address _spender, uint256 amount) public onlyOwner
485         returns(bool)
486     {
487         uint256 _amount = (amount.mul(DEC)).div(price);
488         _amount = _amount.add(withDiscount(_amount, discount));
489         transfer(_spender, _amount);
490 
491         return true;
492     }
493 
494     /*
495     * Function for start crowdsale (any)
496     *
497     * @param _tokens - How much tokens will have the crowdsale - amount humanlike value (10000)
498     * @param _startDate - When crowdsale will be start - unix timestamp (1512231703 )
499     * @param _endDate - When crowdsale will be end - humanlike value (7) same as 7 days
500     */
501     function startCrowd(uint256 _tokens, uint _startDate, uint _endDate) public onlyOwner
502     {
503         Sales = sale (_tokens * DEC, _startDate, _startDate + _endDate * 1 days);
504         unpauseInternal();
505     }
506 
507 }
508 
509 contract TokenContract is ERC20Extending, CrowdsaleContract
510 {
511     /* Constructor */
512     function TokenContract() public
513         ERC20(10000000000, "Debit Coin", "DEBC") {}
514 
515     /**
516     * Function payments handler
517     *
518     */
519     function () public payable
520     {
521         assert(msg.value >= 1 ether / 100);
522         require(now >= Sales.startDate);
523 
524         if (paused == false) {
525             paymentManager(msg.value);
526         } else {
527             revert();
528         }
529     }
530 }