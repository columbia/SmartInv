1 contract ERC20Basic {
2     uint256 public totalSupply;
3     function balanceOf(address who) public view returns (uint256);
4     function transfer(address to, uint256 value) public returns (bool);
5     event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 
9 contract ERC20 is ERC20Basic {
10     function allowance(address owner, address spender) public view returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 contract BasicToken is ERC20Basic {
49     using SafeMath for uint256;
50 
51     mapping(address => uint256) balances;
52 
53     /**
54     * @dev transfer token for a specified address
55     * @param _to The address to transfer to.
56     * @param _value The amount to be transferred.
57     */
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[msg.sender]);
61 
62         // SafeMath.sub will throw if there is not enough balance.
63         balances[msg.sender] = balances[msg.sender].sub(_value);
64         balances[_to] = balances[_to].add(_value);
65         Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     /**
70     * @dev Gets the balance of the specified address.
71     * @param _owner The address to query the the balance of.
72     * @return An uint256 representing the amount owned by the passed address.
73     */
74     function balanceOf(address _owner) public view returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78 }
79 
80 
81 
82 contract Ownable {
83     address public owner;
84 
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88 
89     /**
90      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91      * account.
92      */
93     function Ownable() public {
94         owner = msg.sender;
95     }
96 
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(msg.sender == owner);
103         _;
104     }
105 
106 
107     /**
108      * @dev Allows the current owner to transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115     }
116 
117 }
118 
119 
120 
121 contract StandardToken is ERC20, BasicToken {
122 
123     mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param _from address The address which you want to send tokens from
129      * @param _to address The address which you want to transfer to
130      * @param _value uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require(_value <= balances[_from]);
135         require(_value <= allowed[_from][msg.sender]);
136 
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146      *
147      * Beware that changing an allowance with this method brings the risk that someone may use both the old
148      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      * @param _spender The address which will spend the funds.
152      * @param _value The amount of tokens to be spent.
153      */
154     function approve(address _spender, uint256 _value) public returns (bool) {
155         allowed[msg.sender][_spender] = _value;
156         Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     /**
161      * @dev Function to check the amount of tokens that an owner allowed to a spender.
162      * @param _owner address The address which owns the funds.
163      * @param _spender address The address which will spend the funds.
164      * @return A uint256 specifying the amount of tokens still available for the spender.
165      */
166     function allowance(address _owner, address _spender) public view returns (uint256) {
167         return allowed[_owner][_spender];
168     }
169 
170     /**
171      * approve should be called when allowed[_spender] == 0. To increment
172      * allowed value is better to use this function to avoid 2 calls (and wait until
173      * the first transaction is mined)
174      * From MonolithDAO Token.sol
175      */
176     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181 
182     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183         uint oldValue = allowed[msg.sender][_spender];
184         if (_subtractedValue > oldValue) {
185             allowed[msg.sender][_spender] = 0;
186         } else {
187             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188         }
189         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         return true;
191     }
192 
193 }
194 
195 
196 contract MintableToken is StandardToken, Ownable {
197     event Mint(address indexed to, uint256 amount);
198     event MintFinished();
199 
200     bool public mintingFinished = false;
201 
202 
203     modifier canMint() {
204         require(!mintingFinished);
205         _;
206     }
207 
208     /**
209      * @dev Function to mint tokens
210      * @param _to The address that will receive the minted tokens.
211      * @param _amount The amount of tokens to mint.
212      * @return A boolean that indicates if the operation was successful.
213      */
214     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
215         totalSupply = totalSupply.add(_amount);
216         balances[_to] = balances[_to].add(_amount);
217         Mint(_to, _amount);
218         Transfer(address(0), _to, _amount);
219         return true;
220     }
221 
222     /**
223      * @dev Function to stop minting new tokens.
224      * @return True if the operation was successful.
225      */
226     function finishMinting() onlyOwner canMint public returns (bool) {
227         mintingFinished = true;
228         MintFinished();
229         return true;
230     }
231 }
232 
233 
234 
235 contract BurnableToken is StandardToken {
236 
237     event Burn(address indexed burner, uint256 value);
238 
239     /**
240      * @dev Burns a specific amount of tokens.
241      * @param _value The amount of token to be burned.
242      */
243     function burn(uint256 _value) public {
244         require(_value > 0);
245         require(_value <= balances[msg.sender]);
246         // no need to require value <= totalSupply, since that would imply the
247         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
248 
249         address burner = msg.sender;
250         balances[burner] = balances[burner].sub(_value);
251         totalSupply = totalSupply.sub(_value);
252         Burn(burner, _value);
253     }
254 }
255 
256 
257 
258 contract HireGoToken is MintableToken, BurnableToken {
259 
260     string public constant name = "HireGo";
261     string public constant symbol = "HGO";
262     uint32 public constant decimals = 18;
263 
264     function HireGoToken() public {
265         totalSupply = 100000000E18;
266         balances[owner] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
267     }
268 
269 }
270 
271 
272 
273 contract HireGoCrowdsale is Ownable {
274 
275     using SafeMath for uint;
276 
277     HireGoToken public token = new HireGoToken();
278     uint totalSupply = token.totalSupply();
279 
280     bool public isRefundAllowed;
281     bool public newBonus_and_newPeriod;
282     bool public new_bonus_for_next_period;
283 
284     uint public icoStartTime;
285     uint public icoEndTime;
286     uint public totalWeiRaised;
287     uint public weiRaised;
288     uint public hardCap; // amount of ETH collected, which marks end of crowd sale
289     uint public tokensDistributed; // amount of bought tokens
290     uint public bonus_for_add_stage;
291 
292     /*         Bonus variables          */
293     uint internal baseBonus1 = 160;
294     uint internal baseBonus2 = 140;
295     uint internal baseBonus3 = 130;
296     uint internal baseBonus4 = 120;
297     uint internal baseBonus5 = 110;
298 	  uint internal baseBonus6 = 100;
299     uint public manualBonus;
300     /* * * * * * * * * * * * * * * * * * */
301 
302     uint public rate; // how many token units a buyer gets per wei
303     uint private icoMinPurchase; // In ETH
304     uint private icoEndDateIncCount;
305 
306     address[] public investors_number;
307     address private wallet; // address where funds are collected
308 
309     mapping (address => uint) public orderedTokens;
310     mapping (address => uint) contributors;
311 
312     event FundsWithdrawn(address _who, uint256 _amount);
313 
314     modifier hardCapNotReached() {
315         require(totalWeiRaised < hardCap);
316         _;
317     }
318 
319     modifier crowdsaleEnded() {
320         require(now > icoEndTime);
321         _;
322     }
323 
324     modifier crowdsaleInProgress() {
325         bool withinPeriod = (now >= icoStartTime && now <= icoEndTime);
326         require(withinPeriod);
327         _;
328     }
329 
330     function HireGoCrowdsale(uint _icoStartTime, uint _icoEndTime, address _wallet) public {
331         require (
332           _icoStartTime > now &&
333           _icoEndTime > _icoStartTime
334         );
335 
336         icoStartTime = _icoStartTime;
337         icoEndTime = _icoEndTime;
338         wallet = _wallet;
339 
340         rate = 250 szabo; // wei per 1 token (0.00025ETH)
341 
342         hardCap = 11575 ether;
343         icoEndDateIncCount = 0;
344         icoMinPurchase = 50 finney; // 0.05 ETH
345         isRefundAllowed = false;
346     }
347 
348     // fallback function can be used to buy tokens
349     function() public payable {
350         buyTokens();
351     }
352 
353     // low level token purchase function
354     function buyTokens() public payable crowdsaleInProgress hardCapNotReached {
355         require(msg.value > 0);
356 
357         // check if the buyer exceeded the funding goal
358         calculatePurchaseAndBonuses(msg.sender, msg.value);
359     }
360 
361     // Returns number of investors
362     function getInvestorCount() public view returns (uint) {
363         return investors_number.length;
364     }
365 
366     // Owner can allow or disallow refunds even if soft cap is reached. Should be used in case KYC is not passed.
367     // WARNING: owner should transfer collected ETH back to contract before allowing to refund, if he already withdrawn ETH.
368     function toggleRefunds() public onlyOwner {
369         isRefundAllowed = true;
370     }
371 
372     // Moves ICO ending date by one month. End date can be moved only 1 times.
373     // Returns true if ICO end date was successfully shifted
374     function moveIcoEndDateByOneMonth(uint bonus_percentage) public onlyOwner crowdsaleInProgress returns (bool) {
375         if (icoEndDateIncCount < 1) {
376             icoEndTime = icoEndTime.add(30 days);
377             icoEndDateIncCount++;
378             newBonus_and_newPeriod = true;
379             bonus_for_add_stage = bonus_percentage;
380             return true;
381         }
382         else {
383             return false;
384         }
385     }
386 
387     // Owner can send back collected ETH if soft cap is not reached or KYC is not passed
388     // WARNING: crowdsale contract should have all received funds to return them.
389     // If you have already withdrawn them, send them back to crowdsale contract
390     function refundInvestors() public onlyOwner {
391         require(now >= icoEndTime);
392         require(isRefundAllowed);
393         require(msg.sender.balance > 0);
394 
395         address investor;
396         uint contributedWei;
397         uint tokens;
398         for(uint i = 0; i < investors_number.length; i++) {
399             investor = investors_number[i];
400             contributedWei = contributors[investor];
401             tokens = orderedTokens[investor];
402             if(contributedWei > 0) {
403                 totalWeiRaised = totalWeiRaised.sub(contributedWei);
404                 weiRaised = weiRaised.sub(contributedWei);
405                 if(weiRaised<0){
406                   weiRaised = 0;
407                 }
408                 contributors[investor] = 0;
409                 orderedTokens[investor] = 0;
410                 tokensDistributed = tokensDistributed.sub(tokens);
411                 investor.transfer(contributedWei); // return funds back to contributor
412             }
413         }
414     }
415 
416     // Owner of contract can withdraw collected ETH, if soft cap is reached, by calling this function
417     function withdraw() public onlyOwner {
418         uint to_send = weiRaised;
419         weiRaised = 0;
420         FundsWithdrawn(msg.sender, to_send);
421         wallet.transfer(to_send);
422     }
423 
424     // This function should be used to manually reserve some tokens for "big sharks" or bug-bounty program participants
425     function manualReserve(address _beneficiary, uint _amount) public onlyOwner crowdsaleInProgress {
426         require(_beneficiary != address(0));
427         require(_amount > 0);
428         checkAndMint(_amount);
429         tokensDistributed = tokensDistributed.add(_amount);
430         token.transfer(_beneficiary, _amount);
431     }
432 
433     function burnUnsold() public onlyOwner crowdsaleEnded {
434         uint tokensLeft = totalSupply.sub(tokensDistributed);
435         token.burn(tokensLeft);
436     }
437 
438     function finishIco() public onlyOwner {
439         icoEndTime = now;
440     }
441 
442     function distribute_for_founders() public onlyOwner {
443         uint to_send = 40000000000000000000000000; //40m
444         checkAndMint(to_send);
445         token.transfer(wallet, to_send);
446     }
447 
448     function transferOwnershipToken(address _to) public onlyOwner {
449         token.transferOwnership(_to);
450     }
451 
452     /***************************
453     **  Internal functions    **
454     ***************************/
455 
456     // Calculates purchase conditions and token bonuses
457     function calculatePurchaseAndBonuses(address _beneficiary, uint _weiAmount) internal {
458         if (now >= icoStartTime && now < icoEndTime) require(_weiAmount >= icoMinPurchase);
459 
460         uint cleanWei; // amount of wei to use for purchase excluding change and hardcap overflows
461         uint change;
462         uint _tokens;
463 
464         //check for hardcap overflow
465         if (_weiAmount.add(totalWeiRaised) > hardCap) {
466             cleanWei = hardCap.sub(totalWeiRaised);
467             change = _weiAmount.sub(cleanWei);
468         }
469         else cleanWei = _weiAmount;
470 
471         assert(cleanWei > 4); // 4 wei is a price of minimal fracture of token
472 
473         _tokens = cleanWei.div(rate).mul(1 ether);
474 
475         if (contributors[_beneficiary] == 0) investors_number.push(_beneficiary);
476 
477         _tokens = calculateBonus(_tokens);
478         checkAndMint(_tokens);
479 
480         contributors[_beneficiary] = contributors[_beneficiary].add(cleanWei);
481         weiRaised = weiRaised.add(cleanWei);
482         totalWeiRaised = totalWeiRaised.add(cleanWei);
483         tokensDistributed = tokensDistributed.add(_tokens);
484         orderedTokens[_beneficiary] = orderedTokens[_beneficiary].add(_tokens);
485 
486         if (change > 0) _beneficiary.transfer(change);
487 
488         token.transfer(_beneficiary,_tokens);
489     }
490 
491     // Calculates bonuses based on current stage
492     function calculateBonus(uint _baseAmount) internal returns (uint) {
493         require(_baseAmount > 0);
494 
495         if (now >= icoStartTime && now < icoEndTime) {
496             return calculateBonusIco(_baseAmount);
497         }
498         else return _baseAmount;
499     }
500 
501     // Calculates bonuses, specific for the ICO
502     // Contains date and volume based bonuses
503     function calculateBonusIco(uint _baseAmount) internal returns(uint) {
504         if(now >= icoStartTime && now < 1520726399) {//3:55-4
505             // 4-10 Mar - 60% bonus
506             return _baseAmount.mul(baseBonus1).div(100);
507         }
508         else if(now >= 1520726400 && now < 1521331199) {
509             // 11-17 Mar - 40% bonus
510             return _baseAmount.mul(baseBonus2).div(100);
511         }
512         else if(now >= 1521331200 && now < 1521935999) {
513             // 18-24 Mar - 30% bonus
514             return _baseAmount.mul(baseBonus3).div(100);
515         }
516         else if(now >= 1521936000 && now < 1524959999) {
517             // 25 Mar-28 Apr - 20% bonus
518             return _baseAmount.mul(baseBonus4).div(100);
519         }
520         else if(now >= 1524960000 && now < 1526169599) {
521             //29 Apr - 12 May - 10% bonus
522             return _baseAmount.mul(baseBonus5).div(100);
523         }
524         else {
525             //13 May - 26 May - no bonus
526             return _baseAmount;
527         }
528     }
529 
530     // Checks if more tokens should be minted based on amount of sold tokens, required additional tokens and total supply.
531     // If there are not enough tokens, mint missing tokens
532     function checkAndMint(uint _amount) internal {
533         uint required = tokensDistributed.add(_amount);
534         if(required > totalSupply) token.mint(this, required.sub(totalSupply));
535     }
536 }