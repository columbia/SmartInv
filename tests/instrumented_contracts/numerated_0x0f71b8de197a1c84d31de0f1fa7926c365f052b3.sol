1 pragma solidity ^0.4.21;
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
75     require(releaseTime[msg.sender] == 0 || now > releaseTime[msg.sender]); //finishSale + releasedays * 1 days
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
87     emit Transfer(msg.sender, _to, _value);
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
101   function checkReleaseAt(address _owner) public constant returns (uint256 date) {
102     return releaseTime[_owner];
103   }
104 
105   // change restricted releaseXX account
106   function changeReleaseAccount(address _owner, address _newowner) internal returns (bool) {
107     require(balances[_newowner] == 0);
108     require(releaseTime[_owner] != 0 );
109     require(releaseTime[_newowner] == 0 );
110     balances[_newowner] = balances[_owner];
111     releaseTime[_newowner] = releaseTime[_owner];
112     balances[_owner] = 0;
113     releaseTime[_owner] = 0;
114     return true;
115   }
116 
117   // release Customer's account after KYC
118   function releaseAccount(address _owner) internal returns (bool) {
119     releaseTime[_owner] = now;
120     return true;
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(mintingFinished);
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 /**
221  * @title Ownable
222  * @dev The Ownable contract has an owner address, and provides basic authorization control
223  * functions, this simplifies the implementation of "user permissions".
224  */
225 contract Ownable {
226     
227   address public owner;
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   function Ownable() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     owner = newOwner;
252   }
253 
254 }
255 
256 /**
257  * @title Mintable token
258  * @dev Simple ERC20 Token example, with mintable token creation
259  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
260  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
261  */
262 
263 contract MintableToken is StandardToken, Ownable {
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will recieve the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @param _releaseTime The (optional) freeze time - KYC & bounty accounts.
275    * @return A boolean that indicates if the operation was successful.
276    */
277   function mint(address _to, uint256 _amount, uint256 _releaseTime) internal canMint returns (bool) {
278     totalSupply = totalSupply.add(_amount);
279     balances[_to] = balances[_to].add(_amount);
280     if ( _releaseTime > 0 ) {
281         releaseTime[_to] = _releaseTime;
282     }
283     emit Transfer(0x0, _to, _amount);
284     return true;
285   }
286 
287   // drain tokens
288   function unMint(address _from) internal returns (bool) {
289     totalSupply = totalSupply.sub(balances[_from]);
290     emit Transfer(_from, 0x0, balances[_from]);
291     balances[_from] = 0;
292     return true;
293   }
294  
295 }
296   
297    
298 contract ArconaToken is MintableToken {
299 
300     string public constant name = "Arcona Distribution Contract";
301     string public constant symbol = "ARCONA";
302     uint8 public constant decimals = 18;
303    
304     using SafeMath for uint;
305     
306     address public multisig;
307     address public restricted;
308     address public registerbot;
309     address public certbot;
310     address public release6m;
311     address public release12m;
312     address public release18m;
313 
314     mapping (address => bool) registered;
315     mapping (address => address) referral;
316     mapping (string => address) certificate;
317 
318     uint restrictedPercent = 40;
319     uint refererPercent = 55; // 5.5%
320     uint first24Percent = 50; // 50%
321     uint auctionPercent = 5; // 5%
322     uint bonusPeriod = 21; // 21 days (20 + 1st day whitelist sale)
323 
324     uint public startSale;
325     uint public finishSale;
326     bool public isGlobalPause=false;
327     uint public minTokenSale = 10*10**18; // min 10 tokens
328     uint public totalWeiSale = 2746*10**18; // softcap reached on preICO:  0x516130856e743090af9d7fd95d6fc94c8743a4e1
329     bool public isFinished=false;
330 
331     uint public startAuction;
332     uint public finishAuction;
333     uint public hardcap = 25*10**6; // USD
334     uint public rateSale = 400*10**18; // 1ETH = 400 ARN
335     uint public rateUSD = 500; // ETH Course in USD
336 
337     // constructor
338     function ArconaToken(uint256 _startSale,uint256 _finishSale,address _multisig,address _restricted,address _registerbot,address _certbot, address _release6m, address _release12m, address _release18m) public  {
339         multisig = _multisig;
340         restricted = _restricted;
341         registerbot = _registerbot;
342         certbot = _certbot;
343         release6m = _release6m;
344         release12m = _release12m;
345         release18m = _release18m;
346         startSale = _startSale;
347         finishSale = _finishSale;
348     }
349 
350     modifier isRegistered() {
351         require (registered[msg.sender]);
352         _;
353     }
354 
355     modifier anySaleIsOn() {
356         require(now > startSale && now < finishSale && !isGlobalPause);
357         _;
358     }
359 
360     modifier isUnderHardCap() {
361         uint totalUsdSale = rateUSD.mul(totalWeiSale).div(1 ether);
362         require(totalUsdSale <= hardcap);
363         _;
364     }
365 
366     function changefirst24Percent(uint _percent) public onlyOwner {
367         first24Percent = _percent;
368     }
369 
370     function changeCourse(uint _usd) public onlyOwner {
371         rateUSD = _usd;
372     }
373 
374     function changeMultisig(address _new) public onlyOwner {
375         multisig = _new;
376     }
377 
378     function changeRegisterBot(address _new) public onlyOwner {
379         registerbot = _new;
380     }
381 
382     function changeCertBot(address _new) public onlyOwner {
383         certbot = _new;
384     }
385 
386     function changeRestricted(address _new) public onlyOwner {
387         if (isFinished) {
388             changeReleaseAccount(restricted,_new);
389         }
390         restricted = _new;
391     }
392 
393     function proceedKYC(address _customer) public {
394         require(msg.sender == registerbot || msg.sender == owner);
395         require(_customer != address(0));
396        releaseAccount(_customer);
397     }
398 
399     function changeRelease6m(address _new) public onlyOwner {
400         if (isFinished) {
401             changeReleaseAccount(release6m,_new);
402         }
403         release6m = _new;
404     }
405 
406     function changeRelease12m(address _new) public onlyOwner {
407         if (isFinished) {
408             changeReleaseAccount(release12m,_new);
409         }
410         release12m = _new;
411     }
412 
413     function changeRelease18m(address _new) public onlyOwner {
414         if (isFinished) {
415             changeReleaseAccount(release18m,_new);
416         }
417         release18m = _new;
418     }
419 
420     function addCertificate(string _id,  address _owner) public {
421         require(msg.sender == certbot || msg.sender == owner);
422         require(certificate[_id] == address(0));
423         if (_owner != address(0)) {
424             certificate[_id] = _owner;
425         } else {
426             certificate[_id] = owner;
427         }    
428     }
429 
430     function editCertificate(string _id,  address _newowner) public {
431         require(certificate[_id] != address(0));
432         require(msg.sender == certificate[_id] || msg.sender == certbot || msg.sender == owner );
433         certificate[_id] = _newowner;
434     }
435 
436     function checkCertificate(string _id) public view returns (address) {
437         return certificate[_id];
438     }
439 
440     function deleteCertificate(string _id) public  {
441         require(msg.sender == certbot || msg.sender == owner);
442         delete certificate[_id];
443     }
444 
445     function registerCustomer(address _customer, address _referral) public {
446         require(msg.sender == registerbot || msg.sender == owner);
447         require(_customer != address(0));
448         registered[_customer] = true;
449         if (_referral != address(0) && _referral != _customer) {
450             referral[_customer] = _referral;
451         }
452     }
453 
454     function checkCustomer(address _customer) public view returns (bool, address) {
455         return ( registered[_customer], referral[_customer]);
456     }
457 
458     // import preICO customers from 0x516130856e743090af9d7fd95d6fc94c8743a4e1
459     function importCustomer(address _customer, address _referral, uint _tokenAmount) public {
460         require(msg.sender == registerbot || msg.sender == owner);
461         require(_customer != address(0));
462         require(now < startSale); // before ICO starts
463         registered[_customer] = true;
464         if (_referral != address(0) && _referral != _customer) {
465             referral[_customer] = _referral;
466         }
467         mint(_customer, _tokenAmount, now + 99 * 1 years); // till KYC is completed
468     }
469 
470     function deleteCustomer(address _customer) public {
471         require(msg.sender == registerbot || msg.sender == owner);
472         require(_customer!= address(0));
473         delete registered[_customer];
474         delete referral[_customer];
475         // Drain tokens
476         unMint(_customer);
477     }
478 
479     function globalPause(bool _state) public onlyOwner {
480         isGlobalPause = _state;
481     }
482 
483     function changeRateSale(uint _tokenAmount) public onlyOwner {
484         require(isGlobalPause || (now > startSale && now < finishSale));
485         rateSale = _tokenAmount;
486     }
487 
488     function changeStartSale(uint256 _ts) public onlyOwner {
489         startSale = _ts;
490     }
491 
492     function changeMinTokenSale(uint256 _ts) public onlyOwner {
493         minTokenSale = _ts;
494     }
495 
496     function changeFinishSale(uint256 _ts) public onlyOwner {
497         finishSale = _ts;
498     }
499 
500     function setAuction(uint256 _startAuction, uint256 _finishAuction, uint256 _auctionPercent) public onlyOwner {
501         require(_startAuction < _finishAuction);
502         require(_auctionPercent > 0);
503         require(_startAuction > startSale);
504         require(_finishAuction <= finishSale);
505         finishAuction = _finishAuction;
506         startAuction = _startAuction;
507         auctionPercent = _auctionPercent;
508     }
509 
510     function finishMinting() public onlyOwner {
511         require(!isFinished);
512         isFinished=true;
513         uint issuedTokenSupply = totalSupply;
514         // 40% restricted + 60% issuedTokenSupply = 100%
515         uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
516         issuedTokenSupply = issuedTokenSupply.add(restrictedTokens);
517         // 13% - 11% for any purpose and 2% bounty
518         mint(restricted, issuedTokenSupply.mul(13).div(100), now);
519         // 27% - freezed founds to team & adwisers
520         mint(release6m, issuedTokenSupply.mul(85).div(1000), now + 180 * 1 days); // 8.5 %
521         mint(release12m, issuedTokenSupply.mul(85).div(1000), now + 365 * 1 days); // 8.5 %
522         mint(release18m, issuedTokenSupply.mul(10).div(100), now + 545 * 1 days); // 10 %
523         mintingFinished=true;
524     }
525 
526     function foreignBuyTest(uint256 _weiAmount, uint256 _rate) public pure returns (uint tokenAmount) {
527         require(_weiAmount > 0);
528         require(_rate > 0);
529         return _rate.mul(_weiAmount).div(1 ether);
530     }
531     
532     // BTC external payments
533     function foreignBuy(address _holder, uint256 _weiAmount, uint256 _rate) public {
534         require(msg.sender == registerbot || msg.sender == owner);
535         require(_weiAmount > 0);
536         require(_rate > 0);
537         registered[_holder] = true;
538         uint tokens = _rate.mul(_weiAmount).div(1 ether);
539         mint(_holder, tokens, now + 99 * 1 years); // till KYC is completed
540         totalWeiSale = totalWeiSale.add(_weiAmount);
541     }
542 
543     function createTokens() public isRegistered anySaleIsOn isUnderHardCap payable {
544         uint tokens = rateSale.mul(msg.value).div(1 ether);
545         require(tokens >= minTokenSale); // min 10 tokens
546         multisig.transfer(msg.value);
547         uint percent = 0;
548         uint bonusTokens = 0;
549         uint finishBonus = startSale + (bonusPeriod * 1 days);
550         if ( now < finishBonus ) {
551             if ( now <= startSale + 1 days ) {
552                 percent = first24Percent;   // 1st day: 50% (for registered whitelist only)
553            } else {        // 25% total:
554                percent = (finishBonus - now).div(1 days); // last 15days -1% every day
555                if ( percent >= 15 ) {  //  first 5days, -1% every 12h
556                   percent = 27 - (now - startSale).div(1 hours).div(12);
557                } else {
558                   percent = percent.add(1);
559                }				
560           }
561         } else {
562             if ( now >= startAuction && now < finishAuction ) {
563                 percent = auctionPercent;
564             }
565         }
566         if ( percent > 0 ) {
567             bonusTokens = tokens.mul(percent).div(100);
568             tokens = tokens.add(bonusTokens);
569         }
570 
571         totalWeiSale = totalWeiSale.add(msg.value);
572         mint(msg.sender, tokens, now + 99 * 1 years); // till KYC is completed
573 
574         if ( referral[msg.sender] != address(0) ) {
575             uint refererTokens = tokens.mul(refererPercent).div(1000);
576             mint(referral[msg.sender], refererTokens, now + 99 * 1 years);
577         }
578     }
579 
580     function() external isRegistered anySaleIsOn isUnderHardCap payable {
581         createTokens();
582     }
583     
584 }