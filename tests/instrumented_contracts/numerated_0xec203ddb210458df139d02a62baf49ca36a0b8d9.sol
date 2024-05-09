1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract ERC20Basic {
67   uint256 public totalSupply;
68   function balanceOf(address who) public constant returns (uint256);
69   function transfer(address to, uint256 value) public returns (bool);
70   event Transfer(address indexed from, address indexed to, uint256 value);
71 }
72 
73 contract BasicToken is ERC20Basic {
74   using SafeMath for uint256;
75 
76   mapping(address => uint256) balances;
77 
78   /**
79   * @dev transfer token for a specified address
80   * @param _to The address to transfer to.
81   * @param _value The amount to be transferred.
82   */
83   function transfer(address _to, uint256 _value) public returns (bool) {
84     require(_to != address(0));
85 
86     // SafeMath.sub will throw if there is not enough balance.
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of.
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98   function balanceOf(address _owner) public constant returns (uint256 balance) {
99     return balances[_owner];
100   }
101 
102 }
103 
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public constant returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue)
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue)
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 contract MintableToken is StandardToken, Ownable {
191   event Mint(address indexed to, uint256 amount);
192   event MintFinished();
193 
194   bool public mintingFinished = false;
195 
196 
197   modifier canMint() {
198     require(!mintingFinished);
199     _;
200   }
201 
202   /**
203    * @dev Function to mint tokens
204    * @param _to The address that will receive the minted tokens.
205    * @param _amount The amount of tokens to mint.
206    * @return A boolean that indicates if the operation was successful.
207    */
208   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 
227 contract MultiOwners {
228 
229     event AccessGrant(address indexed owner);
230     event AccessRevoke(address indexed owner);
231     
232     mapping(address => bool) owners;
233 
234     function MultiOwners() {
235         owners[msg.sender] = true;
236     }
237 
238     modifier onlyOwner() { 
239         require(owners[msg.sender] == true);
240         _; 
241     }
242 
243     function isOwner() constant returns (bool) {
244         return owners[msg.sender] ? true : false;
245     }
246 
247     function checkOwner(address maybe_owner) constant returns (bool) {
248         return owners[maybe_owner] ? true : false;
249     }
250 
251 
252     function grant(address _owner) onlyOwner {
253         owners[_owner] = true;
254         AccessGrant(_owner);
255     }
256 
257     function revoke(address _owner) onlyOwner {
258         require(msg.sender != _owner);
259         owners[_owner] = false;
260         AccessRevoke(_owner);
261     }
262 }
263 
264 contract Sale is MultiOwners {
265     // Minimal possible cap in ethers
266     uint256 public softCap;
267 
268     // Maximum possible cap in ethers
269     uint256 public hardCap;
270 
271     // totalEthers received
272     uint256 public totalEthers;
273 
274     // Ssale token
275     Token public token;
276 
277     // Withdraw wallet
278     address public wallet;
279 
280     // Maximum available to sell tokens
281     uint256 public maximumTokens;
282 
283     // Minimal ether
284     uint256 public minimalEther;
285 
286     // Token per ether
287     uint256 public weiPerToken;
288 
289     // start and end timestamp where investments are allowed (both inclusive)
290     uint256 public startTime;
291     uint256 public endTime;
292 
293     // refund if softCap is not reached
294     bool public refundAllowed;
295 
296     // 
297     mapping(address => uint256) public etherBalances;
298 
299     // 
300     mapping(address => uint256) public whitelist;
301 
302     // bounty tokens
303     uint256 public bountyReward;
304 
305     // team tokens
306     uint256 public teamReward;
307 
308     // founder tokens
309     uint256 public founderReward;
310 
311 
312     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
313     event Whitelist(address indexed beneficiary, uint256 value);
314 
315     modifier validPurchase(address contributor) {
316         bool withinPeriod = ((now >= startTime || checkWhitelist(contributor, msg.value)) && now <= endTime);
317         bool nonZeroPurchase = msg.value != 0;
318         require(withinPeriod && nonZeroPurchase);
319 
320         _;        
321     }
322 
323     modifier isStarted() {
324         require(now >= startTime);
325 
326         _;        
327     }
328 
329     modifier isExpired() {
330         require(now > endTime);
331 
332         _;        
333     }
334 
335     function Sale(uint256 _startTime, address _wallet) {
336         require(_startTime >=  now);
337         require(_wallet != 0x0);
338 
339         token = new Token();
340 
341         wallet = _wallet;
342         startTime = _startTime;
343 
344         minimalEther = 1e16; // 0.01 ether
345         endTime = _startTime + 28 days;
346         weiPerToken = 1e18 / 100e8; // token price
347         hardCap = 57142e18;
348         softCap = 3350e18;
349 
350     
351         // We love our Pre-ITO backers
352         token.mint(0x992066a964C241eD4996E750284d039B14A19fA5, 11199999999860);
353         token.mint(0x1F4df63B8d32e54d94141EF8475c55dF4db2a02D, 9333333333170);
354         token.mint(0xce192Be11DdE37630Ef842E3aF5fBD7bEA15C6f9, 2799999999930);
355         token.mint(0x18D2AD9DFC0BA35E124E105E268ebC224323694a, 1120000000000);
356         token.mint(0x4eD1db98a562594CbD42161354746eAafD1F9C44, 933333333310);
357         token.mint(0x00FEbfc7be373f8088182850FeCA034DDA8b7a67, 896000000000);
358         token.mint(0x86850f5f7D035dD96B07A75c484D520cff13eb58, 634666666620);
359         token.mint(0x08750DA30e952B6ef3D034172904ca7Ec1ab133A, 616000000000);
360         token.mint(0x4B61eDe41e7C8034d6bdF1741cA94910993798aa, 578666666620);
361         token.mint(0xdcb018EAD6a94843ef2391b3358294020791450b, 560000000000);
362         token.mint(0xb62E27446079c2F2575C79274cd905Bf1E1e4eDb, 560000000000);
363         token.mint(0xFF37732a268a2ED27627c14c45f100b87E17fFDa, 560000000000);
364         token.mint(0x7bDeD0D5B6e2F9a44f59752Af633e4D1ed200392, 80000000000);
365         token.mint(0x995516bb1458fa7b192Bb4Bab0635Fc9Ab447FD1, 48000000000);
366         token.mint(0x95a7BEf91A5512d954c721ccbd6fC5402667FaDe, 32000000000);
367         token.mint(0x3E10553fff3a5Ac28B9A7e7f4afaFB4C1D6Efc0b, 24000000000);
368         token.mint(0x7C8E7d9BE868673a1bfE0686742aCcb6EaFFEF6F, 17600000000);
369 
370         maximumTokens = token.totalSupply() + 8000000e8;
371 
372         // Also we like KYC
373         whitelist[0xBd7dC4B22BfAD791Cd5d39327F676E0dC3c0C2D0] = 2000 ether;
374         whitelist[0xebAd12E50aDBeb3C7b72f4a877bC43E7Ec03CD60] = 200 ether;
375         whitelist[0xcFC9315cee88e5C650b5a97318c2B9F632af6547] = 200 ether;
376         whitelist[0xC6318573a1Eb70B7B3d53F007d46fcEB3CFcEEaC] = 200 ether;
377         whitelist[0x9d4096117d7FFCaD8311A1522029581D7BF6f008] = 150 ether;
378         whitelist[0xfa99b733fc996174CE1ef91feA26b15D2adC3E31] = 100 ether;
379         whitelist[0xdbb70fbedd2661ef3b6bdf0c105e62fd1c61da7c] = 100 ether;
380         whitelist[0xa16fd60B82b81b4374ac2f2734FF0da78D1CEf3f] = 100 ether;
381         whitelist[0x8c950B58dD54A54E90D9c8AD8bE87B10ad30B59B] = 100 ether;
382         whitelist[0x5c32Bd73Afe16b3De78c8Ce90B64e569792E9411] = 100 ether;
383         whitelist[0x4Daf690A5F8a466Cb49b424A776aD505d2CD7B7d] = 100 ether;
384         whitelist[0x3da7486DF0F343A0E6AF8D26259187417ed08EC9] = 100 ether;
385         whitelist[0x3ac05aa1f06e930640c485a86a831750a6c2275e] = 100 ether;
386         whitelist[0x009e02b21aBEFc7ECC1F2B11700b49106D7D552b] = 100 ether;
387         whitelist[0xCD540A0cC5260378fc818CA815EC8B22F966C0af] = 85 ether;
388         whitelist[0x6e8b688CB562a028E5D9Cb55ac1eE43c22c96995] = 60 ether;
389         whitelist[0xe6D62ec63852b246d3D348D4b3754e0E72F67df4] = 50 ether;
390         whitelist[0xE127C0c9A2783cBa017a835c34D7AF6Ca602c7C2] = 50 ether;
391         whitelist[0xD933d531D354Bb49e283930743E0a473FC8099Df] = 50 ether;
392         whitelist[0x8c3C524A2be451A670183Ee4A2415f0d64a8f1ae] = 50 ether;
393         whitelist[0x7e0fb316Ac92b67569Ed5bE500D9A6917732112f] = 50 ether;
394         whitelist[0x738C090D87f6539350f81c0229376e4838e6c363] = 50 ether;
395         // anothers KYC will be added using addWhitelists
396     }
397 
398     function hardCapReached() constant public returns (bool) {
399         return ((hardCap * 999) / 1000) <= totalEthers;
400     }
401 
402     function softCapReached() constant public returns(bool) {
403         return totalEthers >= softCap;
404     }
405 
406     /*
407      * @dev fallback for processing ether
408      */
409     function() payable {
410         return buyTokens(msg.sender);
411     }
412 
413     /*
414      * @dev calculate amount
415      * @param  _value - ether to be converted to tokens
416      * @param  at - current time
417      * @return token amount that we should send to our dear investor
418      */
419     function calcAmountAt(uint256 _value, uint256 at) public constant returns (uint256) {
420         uint rate;
421 
422         if(startTime + 2 days >= at) {
423             rate = 140;
424         } else if(startTime + 7 days >= at) {
425             rate = 130;
426         } else if(startTime + 14 days >= at) {
427             rate = 120;
428         } else if(startTime + 21 days >= at) {
429             rate = 110;
430         } else {
431             rate = 105;
432         }
433         return ((_value * rate) / weiPerToken) / 100;
434     }
435 
436     /*
437      * @dev check contributor is whitelisted or not for buy token 
438      * @param contributor
439      * @param amount â how much ethers contributor wants to spend
440      * @return true if access allowed
441      */
442     function checkWhitelist(address contributor, uint256 amount) internal returns (bool) {
443         return etherBalances[contributor] + amount <= whitelist[contributor];
444     }
445 
446     /*
447      * @dev grant backer until first 24 hours
448      * @param contributor address
449      */
450     function addWhitelist(address contributor, uint256 amount) onlyOwner public returns (bool) {
451         Whitelist(contributor, amount);
452         whitelist[contributor] = amount;
453         return true;
454     }
455 
456 
457     /*
458      * @dev grant backers until first 24 hours
459      * @param contributor address
460      */
461     function addWhitelists(address[] contributors, uint256[] amounts) onlyOwner public returns (bool) {
462         address contributor;
463         uint256 amount;
464 
465         require(contributors.length == amounts.length);
466 
467         for (uint i = 0; i < contributors.length; i++) {
468             contributor = contributors[i];
469             amount = amounts[i];
470             require(addWhitelist(contributor, amount));
471         }
472         return true;
473     }
474 
475     /*
476      * @dev sell token and send to contributor address
477      * @param contributor address
478      */
479     function buyTokens(address contributor) payable validPurchase(contributor) public {
480         uint256 amount = calcAmountAt(msg.value, block.timestamp);
481   
482         require(contributor != 0x0) ;
483         require(minimalEther <= msg.value);
484         require(token.totalSupply() + amount <= maximumTokens);
485 
486         token.mint(contributor, amount);
487         TokenPurchase(contributor, msg.value, amount);
488 
489         if(softCapReached()) {
490             totalEthers = totalEthers + msg.value;
491         } else if (this.balance >= softCap) {
492             totalEthers = this.balance;
493         } else {
494             etherBalances[contributor] = etherBalances[contributor] + msg.value;
495         }
496 
497         require(totalEthers <= hardCap);
498     }
499 
500     // @withdraw to wallet
501     function withdraw() onlyOwner public {
502         require(softCapReached());
503         require(this.balance > 0);
504 
505         wallet.transfer(this.balance);
506     }
507 
508     // @withdraw token to wallet
509     function withdrawTokenToFounder() onlyOwner public {
510         require(token.balanceOf(this) > 0);
511         require(softCapReached());
512         require(startTime + 1 years < now);
513 
514         token.transfer(wallet, token.balanceOf(this));
515     }
516 
517     // @refund to backers, if softCap is not reached
518     function refund() isExpired public {
519         require(refundAllowed);
520         require(!softCapReached());
521         require(etherBalances[msg.sender] > 0);
522         require(token.balanceOf(msg.sender) > 0);
523 
524         uint256 current_balance = etherBalances[msg.sender];
525         etherBalances[msg.sender] = 0;
526  
527         token.burn(msg.sender);
528         msg.sender.transfer(current_balance);
529     }
530 
531     function finishCrowdsale() onlyOwner public {
532         require(now > endTime || hardCapReached());
533         require(!token.mintingFinished());
534 
535         bountyReward = token.totalSupply() * 3 / 83; 
536         teamReward = token.totalSupply() * 7 / 83; 
537         founderReward = token.totalSupply() * 7 / 83; 
538 
539         if(softCapReached()) {
540             token.mint(wallet, bountyReward);
541             token.mint(wallet, teamReward);
542             token.mint(this, founderReward);
543 
544             token.finishMinting(true);
545         } else {
546             refundAllowed = true;
547             token.finishMinting(false);
548         }
549    }
550 
551     // @return true if crowdsale event has ended
552     function running() public constant returns (bool) {
553         return now >= startTime && !(now > endTime || hardCapReached());
554     }
555 }
556 
557 contract Token is MintableToken {
558 
559     string public constant name = 'Privatix';
560     string public constant symbol = 'PRIX';
561     uint8 public constant decimals = 8;
562     bool public transferAllowed;
563 
564     event Burn(address indexed from, uint256 value);
565     event TransferAllowed(bool);
566 
567     modifier canTransfer() {
568         require(mintingFinished && transferAllowed);
569         _;        
570     }
571     
572     function transferFrom(address from, address to, uint256 value) canTransfer returns (bool) {
573         return super.transferFrom(from, to, value);
574     }
575 
576     function transfer(address to, uint256 value) canTransfer returns (bool) {
577         return super.transfer(to, value);
578     }
579 
580     function finishMinting(bool _transferAllowed) onlyOwner returns (bool) {
581         transferAllowed = _transferAllowed;
582         TransferAllowed(_transferAllowed);
583         return super.finishMinting();
584     }
585 
586     function burn(address from) onlyOwner returns (bool) {
587         Transfer(from, 0x0, balances[from]);
588         Burn(from, balances[from]);
589 
590         balances[0x0] += balances[from];
591         balances[from] = 0;
592     }
593 }