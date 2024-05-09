1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 
33 contract ERC20Basic {
34     uint256 public totalSupply;
35     function balanceOf(address who) public view returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) public view returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
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
81 contract Ownable {
82     address public owner;
83 
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87 
88     /**
89      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
90      * account.
91      */
92     function Ownable() public {
93         owner = msg.sender;
94     }
95 
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(msg.sender == owner);
102         _;
103     }
104 
105 
106     /**
107      * @dev Allows the current owner to transfer control of the contract to a newOwner.
108      * @param newOwner The address to transfer ownership to.
109      */
110     function transferOwnership(address newOwner) public onlyOwner {
111         require(newOwner != address(0));
112         OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115 
116 }
117 
118 contract StandardToken is ERC20, BasicToken {
119 
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123     /**
124      * @dev Transfer tokens from one address to another
125      * @param _from address The address which you want to send tokens from
126      * @param _to address The address which you want to transfer to
127      * @param _value uint256 the amount of tokens to be transferred
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      *
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param _spender The address which will spend the funds.
149      * @param _value The amount of tokens to be spent.
150      */
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param _owner address The address which owns the funds.
160      * @param _spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address _owner, address _spender) public view returns (uint256) {
164         return allowed[_owner][_spender];
165     }
166 
167     /**
168      * approve should be called when allowed[_spender] == 0. To increment
169      * allowed value is better to use this function to avoid 2 calls (and wait until
170      * the first transaction is mined)
171      * From MonolithDAO Token.sol
172      */
173     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190 }
191 
192 contract BurnableToken is StandardToken {
193 
194     event Burn(address indexed burner, uint256 value);
195 
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param _value The amount of token to be burned.
199      */
200     function burn(uint256 _value) public {
201         require(_value > 0);
202         require(_value <= balances[msg.sender]);
203         // no need to require value <= totalSupply, since that would imply the
204         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
205 
206         address burner = msg.sender;
207         balances[burner] = balances[burner].sub(_value);
208         totalSupply = totalSupply.sub(_value);
209         Burn(burner, _value);
210     }
211 }
212 
213 contract MintableToken is StandardToken, Ownable {
214     event Mint(address indexed to, uint256 amount);
215     event MintFinished();
216 
217     bool public mintingFinished = false;
218 
219 
220     modifier canMint() {
221         require(!mintingFinished);
222         _;
223     }
224 
225     /**
226      * @dev Function to mint tokens
227      * @param _to The address that will receive the minted tokens.
228      * @param _amount The amount of tokens to mint.
229      * @return A boolean that indicates if the operation was successful.
230      */
231     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
232         totalSupply = totalSupply.add(_amount);
233         balances[_to] = balances[_to].add(_amount);
234         Mint(_to, _amount);
235         Transfer(address(0), _to, _amount);
236         return true;
237     }
238 
239     /**
240      * @dev Function to stop minting new tokens.
241      * @return True if the operation was successful.
242      */
243     function finishMinting() onlyOwner canMint public returns (bool) {
244         mintingFinished = true;
245         MintFinished();
246         return true;
247     }
248 }
249 
250 
251 contract HireGoToken is MintableToken, BurnableToken {
252 
253     string public constant name = "HireGo";
254     string public constant symbol = "HGO";
255     uint32 public constant decimals = 18;
256 
257     function HireGoToken() public {
258         totalSupply = 100000000E18;  //100m
259         balances[owner] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
260     }
261 
262 }
263 
264 
265 contract HireGoCrowdsale is Ownable {
266 
267     using SafeMath for uint;
268 
269     HireGoToken public token = new HireGoToken();
270     uint totalSupply = token.totalSupply();
271 
272     bool public isRefundAllowed;
273 
274     uint public icoStartTime;
275     uint public icoEndTime;
276     uint public totalWeiRaised;
277     uint public weiRaised;
278     uint public hardCap; // amount of ETH collected, which marks end of crowd sale
279     uint public tokensDistributed; // amount of bought tokens
280     uint public foundersTokensUnlockTime;
281 
282     /*         Bonus variables          */
283     uint internal baseBonus1 = 135;
284     uint internal baseBonus2 = 130;
285     uint internal baseBonus3 = 125;
286     uint internal baseBonus4 = 115;
287     uint public manualBonus;
288     /* * * * * * * * * * * * * * * * * * */
289 
290     uint public waveCap1;
291     uint public waveCap2;
292     uint public waveCap3;
293     uint public waveCap4;
294 
295     uint public rate; // how many token units a buyer gets per wei
296     uint private icoMinPurchase; // In ETH
297 
298     address[] public investors_number;
299     address private wallet; // address where funds are collected
300 
301     mapping (address => uint) public orderedTokens;
302     mapping (address => uint) contributors;
303 
304     event FundsWithdrawn(address _who, uint256 _amount);
305 
306     modifier hardCapNotReached() {
307         require(totalWeiRaised < hardCap);
308         _;
309     }
310 
311     modifier crowdsaleEnded() {
312         require(now > icoEndTime);
313         _;
314     }
315 
316     modifier foundersTokensUnlocked() {
317         require(now > foundersTokensUnlockTime);
318         _;
319     }
320 
321     modifier crowdsaleInProgress() {
322         bool withinPeriod = (now >= icoStartTime && now <= icoEndTime);
323         require(withinPeriod);
324         _;
325     }
326 
327     function HireGoCrowdsale(uint _icoStartTime, uint _icoEndTime, address _wallet) public {
328         require (
329           _icoStartTime > now &&
330           _icoEndTime > _icoStartTime
331         );
332 
333         icoStartTime = _icoStartTime;
334         icoEndTime = _icoEndTime;
335         foundersTokensUnlockTime = icoEndTime.add(180 days);
336         wallet = _wallet;
337 
338         rate = 250 szabo; // wei per 1 token (0.00025ETH)
339 
340         hardCap = 11836 ether;
341         icoMinPurchase = 50 finney; // 0.05 ETH
342         isRefundAllowed = false;
343 
344         waveCap1 = 2777 ether;
345         waveCap2 = waveCap1.add(2884 ether);
346         waveCap3 = waveCap2.add(4000 ether);
347         waveCap4 = waveCap3.add(2174 ether);
348     }
349 
350     // fallback function can be used to buy tokens
351     function() public payable {
352         buyTokens();
353     }
354 
355     // low level token purchase function
356     function buyTokens() public payable crowdsaleInProgress hardCapNotReached {
357         require(msg.value > 0);
358 
359         // check if the buyer exceeded the funding goal
360         calculatePurchaseAndBonuses(msg.sender, msg.value);
361     }
362 
363     // Returns number of investors
364     function getInvestorCount() public view returns (uint) {
365         return investors_number.length;
366     }
367 
368     // Owner can allow or disallow refunds even if soft cap is reached. Should be used in case KYC is not passed.
369     // WARNING: owner should transfer collected ETH back to contract before allowing to refund, if he already withdrawn ETH.
370     function toggleRefunds() public onlyOwner {
371         isRefundAllowed = true;
372     }
373 
374     // Sends ordered tokens to investors after ICO end if soft cap is reached
375     // tokens can be send only if ico has ended
376     function sendOrderedTokens() public onlyOwner crowdsaleEnded {
377         address investor;
378         uint tokensCount;
379         for(uint i = 0; i < investors_number.length; i++) {
380             investor = investors_number[i];
381             tokensCount = orderedTokens[investor];
382             assert(tokensCount > 0);
383             orderedTokens[investor] = 0;
384             token.transfer(investor, tokensCount);
385         }
386     }
387 
388     // Owner can send back collected ETH if soft cap is not reached or KYC is not passed
389     // WARNING: crowdsale contract should have all received funds to return them.
390     // If you have already withdrawn them, send them back to crowdsale contract
391     function refundInvestors() public onlyOwner {
392         require(now >= icoEndTime);
393         require(isRefundAllowed);
394         require(msg.sender.balance > 0);
395 
396         address investor;
397         uint contributedWei;
398         uint tokens;
399         for(uint i = 0; i < investors_number.length; i++) {
400             investor = investors_number[i];
401             contributedWei = contributors[investor];
402             tokens = orderedTokens[investor];
403             if(contributedWei > 0) {
404                 totalWeiRaised = totalWeiRaised.sub(contributedWei);
405                 weiRaised = weiRaised.sub(contributedWei);
406                 if(weiRaised<0){
407                   weiRaised = 0;
408                 }
409                 contributors[investor] = 0;
410                 orderedTokens[investor] = 0;
411                 tokensDistributed = tokensDistributed.sub(tokens);
412                 investor.transfer(contributedWei); // return funds back to contributor
413             }
414         }
415     }
416 
417     // Owner of contract can withdraw collected ETH by calling this function
418     function withdraw() public onlyOwner {
419         uint to_send = weiRaised;
420         weiRaised = 0;
421         FundsWithdrawn(msg.sender, to_send);
422         wallet.transfer(to_send);
423     }
424 
425     function burnUnsold() public onlyOwner crowdsaleEnded {
426         uint tokensLeft = totalSupply.sub(tokensDistributed);
427         token.burn(tokensLeft);
428     }
429 
430     function finishIco() public onlyOwner {
431         icoEndTime = now;
432     }
433 
434     function distribute_for_founders() public onlyOwner foundersTokensUnlocked {
435         uint to_send = 40000000E18; //40m
436         checkAndMint(to_send);
437         token.transfer(wallet, to_send);
438     }
439 
440     function transferOwnershipToken(address _to) public onlyOwner {
441         token.transferOwnership(_to);
442     }
443 
444     /***************************
445     **  Internal functions    **
446     ***************************/
447 
448     // Calculates purchase conditions and token bonuses
449     function calculatePurchaseAndBonuses(address _beneficiary, uint _weiAmount) internal {
450         if (now >= icoStartTime && now < icoEndTime) require(_weiAmount >= icoMinPurchase);
451 
452         uint cleanWei; // amount of wei to use for purchase excluding change and hardcap overflows
453         uint change;
454         uint _tokens;
455 
456         //check for hardcap overflow
457         if (_weiAmount.add(totalWeiRaised) > hardCap) {
458             cleanWei = hardCap.sub(totalWeiRaised);
459             change = _weiAmount.sub(cleanWei);
460         }
461         else cleanWei = _weiAmount;
462 
463         assert(cleanWei > 4); // 4 wei is a price of minimal fracture of token
464 
465         _tokens = cleanWei.div(rate).mul(1 ether);
466 
467         if (contributors[_beneficiary] == 0) investors_number.push(_beneficiary);
468 
469         _tokens = calculateBonus(_tokens);
470         checkAndMint(_tokens);
471 
472         contributors[_beneficiary] = contributors[_beneficiary].add(cleanWei);
473         weiRaised = weiRaised.add(cleanWei);
474         totalWeiRaised = totalWeiRaised.add(cleanWei);
475         tokensDistributed = tokensDistributed.add(_tokens);
476         orderedTokens[_beneficiary] = orderedTokens[_beneficiary].add(_tokens);
477 
478         if (change > 0) _beneficiary.transfer(change);
479     }
480 
481     // Calculates bonuses based on current stage
482     function calculateBonus(uint _baseAmount) internal returns (uint) {
483         require(_baseAmount > 0);
484 
485         if (now >= icoStartTime && now < icoEndTime) {
486             return calculateBonusIco(_baseAmount);
487         }
488         else return _baseAmount;
489     }
490 
491     // Calculates bonuses, specific for the ICO
492     // Contains date and volume based bonuses
493     function calculateBonusIco(uint _baseAmount) internal returns(uint) {
494         if(totalWeiRaised < waveCap1) {
495             return _baseAmount.mul(baseBonus1).div(100);
496         }
497         else if(totalWeiRaised >= waveCap1 && totalWeiRaised < waveCap2) {
498             return _baseAmount.mul(baseBonus2).div(100);
499         }
500         else if(totalWeiRaised >= waveCap2 && totalWeiRaised < waveCap3) {
501             return _baseAmount.mul(baseBonus3).div(100);
502         }
503         else if(totalWeiRaised >= waveCap3 && totalWeiRaised < waveCap4) {
504             return _baseAmount.mul(baseBonus4).div(100);
505         }
506         else {
507             // No bonus
508             return _baseAmount;
509         }
510     }
511 
512     // Checks if more tokens should be minted based on amount of sold tokens, required additional tokens and total supply.
513     // If there are not enough tokens, mint missing tokens
514     function checkAndMint(uint _amount) internal {
515         uint required = tokensDistributed.add(_amount);
516         if(required > totalSupply) token.mint(this, required.sub(totalSupply));
517     }
518 }