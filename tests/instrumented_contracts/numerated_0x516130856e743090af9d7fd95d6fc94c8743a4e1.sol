1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32  
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public constant returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, require mintingFinished before start transfers
63  */
64 contract BasicToken is ERC20Basic {
65     
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69   bool public mintingFinished = false;
70 
71   mapping(address => uint256) releaseTime;
72   // Only after finishMinting and checks for bounty accounts time restrictions
73   modifier timeAllowed() {
74     require(mintingFinished);
75     require(now > releaseTime[msg.sender]); //finishSale + releasedays * 1 days
76     _;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public timeAllowed returns (bool) {
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of. 
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   // release time of freezed account
101   function releaseAt(address _owner) public constant returns (uint256 date) {
102     return releaseTime[_owner];
103   }
104   // change restricted releaseXX account
105   function changeReleaseAccount(address _owner, address _newowner) public returns (bool) {
106     require(releaseTime[_owner] != 0 );
107     require(releaseTime[_newowner] == 0 );
108     balances[_newowner] = balances[_owner];
109     releaseTime[_newowner] = releaseTime[_owner];
110     balances[_owner] = 0;
111     releaseTime[_owner] = 0;
112     return true;
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(mintingFinished);
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) public timeAllowed returns (bool) {
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
159 
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifing the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183     
184   address public owner;
185 
186   /**
187    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
188    * account.
189    */
190   function Ownable() public {
191     owner = msg.sender;
192   }
193 
194   /**
195    * @dev Throws if called by any account other than the owner.
196    */
197   modifier onlyOwner() {
198     require(msg.sender == owner);
199     _;
200   }
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) public onlyOwner {
207     require(newOwner != address(0));
208     owner = newOwner;
209   }
210 
211 }
212 
213 /**
214  * @title Mintable token
215  * @dev Simple ERC20 Token example, with mintable token creation
216  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
217  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
218  */
219 
220 contract MintableToken is StandardToken, Ownable {
221     
222   event Mint(address indexed to, uint256 amount);
223   event UnMint(address indexed from, uint256 amount);
224   event MintFinished();
225 
226   modifier canMint() {
227     require(!mintingFinished);
228     _;
229   }
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will recieve the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @param _releaseTime The (optional) freeze time for bounty accounts.
236    * @return A boolean that indicates if the operation was successful.
237    */
238   function mint(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint returns (bool) {
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     if ( _releaseTime > 0 ) {
242         releaseTime[_to] = _releaseTime;
243     }
244     Mint(_to, _amount);
245     return true;
246   }
247   // drain tokens with refund
248   function unMint(address _from) public onlyOwner returns (bool) {
249     totalSupply = totalSupply.sub(balances[_from]);
250     UnMint(_from, balances[_from]);
251     balances[_from] = 0;
252     return true;
253   }
254 
255   /**
256    * @dev Function to stop minting new tokens.
257    * @return True if the operation was successful.
258    */
259   function finishMinting() public onlyOwner returns (bool) {
260     mintingFinished = true;
261     MintFinished();
262     return true;
263   }
264   
265 }
266 
267 
268 contract ArconaToken is MintableToken {
269     
270     string public constant name = "Arcona Distribution Contract";
271     string public constant symbol = "Arcona";
272     uint32 public constant decimals = 3; // 0.001
273    
274 }
275 
276 contract Crowdsale is Ownable {
277     
278     using SafeMath for uint;
279     
280     address public multisig;
281     address public restricted;
282     address public registerbot;
283     address public release6m;
284     address public release12m;
285     address public release18m;
286 
287     mapping (address => uint) public weiBalances;
288     mapping (address => bool) registered;
289     mapping (address => address) referral;
290     mapping (string => address) certificate;
291 
292     uint restrictedPercent;
293     uint refererPercent = 55; // 5.5%
294     uint bonusPeriod = 10; // 10 days
295 
296     ArconaToken public token = new ArconaToken();
297     uint public startPreSale;
298     uint public finishPreSale;
299     uint public startSale;
300     uint public finishSale;
301     bool public isGlobalPause=false;
302     uint public tokenTotal;   
303     uint public totalWeiSale=0;
304     bool public isFinished=false;
305 
306     uint public hardcap;
307     uint public softcap;
308 
309     uint public ratePreSale = 400*10**3; // 1ETH = 400 ARN
310     uint public rateSale = 400*10**3; // 1ETH = 400 ARN
311 
312     function Crowdsale(uint256 _startPreSale,uint256 _finishPreSale,uint256 _startSale,uint256 _finishSale,address _multisig,address _restricted,address _registerbot, address _release6m, address _release12m, address _release18m) public {
313         multisig = _multisig;
314         restricted = _restricted;
315         registerbot = _registerbot;
316         release6m = _release6m;
317         release12m = _release12m;
318         release18m = _release18m;
319         startSale=_startSale;
320         finishSale=_finishSale;
321         startPreSale=_startPreSale;
322         finishPreSale=_finishPreSale;
323         restrictedPercent = 40;
324         hardcap = 135000*10**18;
325         softcap = 2746*10**18;
326     }
327 
328     modifier isRegistered() {
329         require (registered[msg.sender]);
330         _;
331     }
332 
333     modifier preSaleIsOn() {
334         require(now > startPreSale && now < finishPreSale && !isGlobalPause);
335         _;
336     }
337 
338     modifier saleIsOn() {
339         require(now > startSale && now < finishSale && !isGlobalPause);
340         _;
341     }
342 
343     modifier anySaleIsOn() {
344         require((now > startPreSale && now < finishPreSale && !isGlobalPause) || (now > startSale && now < finishSale && !isGlobalPause));
345         _;
346     }
347 
348     modifier isUnderHardCap() {
349         require(totalWeiSale <= hardcap);
350         _;
351     }
352 
353     function changeMultisig(address _new) public onlyOwner {
354         multisig = _new;
355     }
356 
357     function changeRegisterBot(address _new) public onlyOwner {
358         registerbot = _new;
359     }
360 
361     function changeRestricted(address _new) public onlyOwner {
362         if (isFinished) {
363             require(token.releaseAt(_new) == 0);
364             token.changeReleaseAccount(restricted,_new);
365         }
366         restricted = _new;
367     }
368 
369     function changeRelease6m(address _new) public onlyOwner {
370         if (isFinished) {
371             require(token.releaseAt(_new) == 0);
372             token.changeReleaseAccount(release6m,_new);
373         }
374         release6m = _new;
375     }
376 
377     function changeRelease12m(address _new) public onlyOwner {
378         if (isFinished) {
379             require(token.releaseAt(_new) == 0);
380             token.changeReleaseAccount(release12m,_new);
381         }
382         release12m = _new;
383     }
384 
385     function changeRelease18m(address _new) public onlyOwner {
386         if (isFinished) {
387             require(token.releaseAt(_new) == 0);
388             token.changeReleaseAccount(release18m,_new);
389         }
390         release18m = _new;
391     }
392 
393     function addCertificate(string _id,  address _owner) public onlyOwner {
394         require(certificate[_id] == address(0));
395         if (_owner != address(0)) {
396             certificate[_id] = _owner;
397         } else {
398             certificate[_id] = owner;
399         }    
400     }
401 
402     function editCertificate(string _id,  address _newowner) public {
403         require(certificate[_id] != address(0));
404         require(msg.sender == certificate[_id] || msg.sender == owner);
405         certificate[_id] = _newowner;
406     }
407 
408     function checkCertificate(string _id) public view returns (address) {
409         return certificate[_id];
410     }
411 
412     function deleteCertificate(string _id) public onlyOwner {
413         delete certificate[_id];
414     }
415 
416     function registerCustomer(address _customer, address _referral) public {
417         require(msg.sender == registerbot || msg.sender == owner);
418         require(_customer != address(0));
419         registered[_customer] = true;
420         if (_referral != address(0) && _referral != _customer) {
421             referral[_customer] = _referral;
422         }
423     }
424 
425     function checkCustomer(address _customer) public view returns (bool, address) {
426         return ( registered[_customer], referral[_customer]);
427     }
428     function checkReleaseAt(address _owner) public constant returns (uint256 date) {
429         return token.releaseAt(_owner);
430     }
431 
432     function deleteCustomer(address _customer) public onlyOwner {
433         require(_customer!= address(0));
434         delete registered[_customer];
435         delete referral[_customer];
436         // return Wei && Drain tokens
437         token.unMint(_customer);
438         if ( weiBalances[_customer] > 0 ) {
439             _customer.transfer(weiBalances[_customer]);
440             weiBalances[_customer] = 0;
441         }
442     }
443 
444     function globalPause(bool _state) public onlyOwner {
445         isGlobalPause = _state;
446     }
447 
448     function changeRateSale(uint _tokenAmount) public onlyOwner {
449         require(isGlobalPause || (now > startSale && now < finishSale));
450         rateSale = _tokenAmount;
451     }
452 
453     function changeRatePreSale(uint _tokenAmount) public onlyOwner {
454         require(isGlobalPause || (now > startPreSale && now < finishPreSale));
455         ratePreSale = _tokenAmount;
456     }
457 
458     function changeStartPreSale(uint256 _ts) public onlyOwner {
459         startPreSale = _ts;
460     }
461 
462     function changeFinishPreSale(uint256 _ts) public onlyOwner {
463         finishPreSale = _ts;
464     }
465 
466     function changeStartSale(uint256 _ts) public onlyOwner {
467         startSale = _ts;
468     }
469 
470     function changeFinishSale(uint256 _ts) public onlyOwner {
471         finishSale = _ts;
472     }
473 
474     function finishMinting() public onlyOwner {
475         require(totalWeiSale >= softcap);
476         require(!isFinished);
477         multisig.transfer(this.balance);
478         uint issuedTokenSupply = token.totalSupply();
479         // 40% restricted + 60% issuedTokenSupply = 100%
480         uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
481         issuedTokenSupply = issuedTokenSupply.add(restrictedTokens);
482         // 13% - 11% for any purpose and 2% bounty
483         token.mint(restricted, issuedTokenSupply.mul(13).div(100), now);
484         // 27% - freezed founds to team & adwisers
485         token.mint(release6m, issuedTokenSupply.mul(85).div(1000), now + 180 * 1 days); // 8.5 %
486         token.mint(release12m, issuedTokenSupply.mul(85).div(1000), now + 365 * 1 days); // 8.5 %
487         token.mint(release18m, issuedTokenSupply.mul(10).div(100), now + 545 * 1 days); // 10 %
488         tokenTotal=token.totalSupply();
489         token.finishMinting();
490         isFinished=true;
491     }
492 
493     function foreignBuyTest(uint256 _weiAmount, uint256 _rate) public pure returns (uint tokenAmount) {
494         require(_weiAmount > 0);
495         require(_rate > 0);
496         return _rate.mul(_weiAmount).div(1 ether);
497     }
498 
499     function foreignBuy(address _holder, uint256 _weiAmount, uint256 _rate) public isUnderHardCap preSaleIsOn onlyOwner {
500         require(_weiAmount > 0);
501         require(_rate > 0);
502         registered[_holder] = true;
503         uint tokens = _rate.mul(_weiAmount).div(1 ether);
504         token.mint(_holder, tokens, 0);
505         tokenTotal = token.totalSupply();
506         totalWeiSale = totalWeiSale.add(_weiAmount);
507     }
508 
509     // Refund Either && Drain tokens
510     function refund() public {
511         require(totalWeiSale <= softcap && now >= finishSale);
512         require(weiBalances[msg.sender] > 0);
513         token.unMint(msg.sender);
514         msg.sender.transfer(weiBalances[msg.sender]);
515         totalWeiSale = totalWeiSale.sub(weiBalances[msg.sender]);
516         tokenTotal = token.totalSupply();
517         weiBalances[msg.sender] = 0;
518     }
519 
520     function buyTokensPreSale() public isRegistered isUnderHardCap preSaleIsOn payable {
521         uint tokens = ratePreSale.mul(msg.value).div(1 ether);
522         require(tokens >= 10000); // min 10 tokens
523         multisig.transfer(msg.value);
524         uint bonusValueTokens = 0;
525         uint saleEther = (msg.value).mul(10).div(1 ether);
526         if (saleEther >= 125 && saleEther < 375 ) { // 12,5 ETH
527             bonusValueTokens = tokens.mul(15).div(100);
528         } else if (saleEther >= 375 && saleEther < 750 ) { // 37,5 ETH
529             bonusValueTokens = tokens.mul(20).div(100);
530         } else if (saleEther >= 750 && saleEther < 1250 ) { // 75 ETH
531             bonusValueTokens=tokens.mul(25).div(100);
532         } else if (saleEther >= 1250  ) { // 125 ETH
533             bonusValueTokens = tokens.mul(30).div(100);
534         }
535         tokens = tokens.add(bonusValueTokens);
536         totalWeiSale = totalWeiSale.add(msg.value); 
537         token.mint(msg.sender, tokens, 0);
538         if ( referral[msg.sender] != address(0) ) {
539             uint refererTokens = tokens.mul(refererPercent).div(1000);
540             token.mint(referral[msg.sender], refererTokens, 0);
541         }
542         tokenTotal=token.totalSupply();
543     }
544 
545     function createTokens() public isRegistered isUnderHardCap saleIsOn payable {
546         uint tokens = rateSale.mul(msg.value).div(1 ether);
547         require(tokens >= 10000); // min 10 tokens
548         uint bonusTokens = 0;
549         if ( now < startSale + (bonusPeriod * 1 days) ) {
550             uint percent = bonusPeriod - (now - startSale).div(1 days);
551             if ( percent > 0 ) {
552                 bonusTokens = tokens.mul(percent).div(100);
553             }
554         }
555         tokens=tokens.add(bonusTokens);
556         totalWeiSale = totalWeiSale.add(msg.value);
557         token.mint(msg.sender, tokens, 0);
558         if ( referral[msg.sender] != address(0) ) {
559             uint refererTokens = tokens.mul(refererPercent).div(1000);
560             token.mint(referral[msg.sender], refererTokens, 0);
561         }
562         tokenTotal=token.totalSupply();
563         weiBalances[msg.sender] = weiBalances[msg.sender].add(msg.value);
564     }
565 
566     function createTokensAnySale() public isUnderHardCap anySaleIsOn payable {
567         if ((now > startPreSale && now < finishPreSale) && !isGlobalPause) {
568             buyTokensPreSale();
569         } else if ((now > startSale && now < finishSale) && !isGlobalPause) {
570             createTokens();
571         } else {
572             revert();
573         }
574     }
575 
576     function() external anySaleIsOn isUnderHardCap payable {
577         createTokensAnySale();
578     }
579     
580 }