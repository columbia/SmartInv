1 pragma solidity ^0.4.13;
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
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69 
70   /**
71    * @dev modifier to allow actions only when the contract IS paused
72    */
73   modifier whenNotPaused() {
74     require(!paused);
75     _;
76   }
77 
78   /**
79    * @dev modifier to allow actions only when the contract IS NOT paused
80    */
81   modifier whenPaused {
82     require(paused);
83     _;
84   }
85 
86   /**
87    * @dev called by the owner to pause, triggers stopped state
88    */
89   function pause() onlyOwner whenNotPaused returns (bool) {
90     paused = true;
91     Pause();
92     return true;
93   }
94 
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused returns (bool) {
99     paused = false;
100     Unpause();
101     return true;
102   }
103 }
104 
105 contract ERC20Basic {
106   uint256 public totalSupply;
107   function balanceOf(address who) constant returns (uint256);
108   function transfer(address to, uint256 value) returns (bool);
109   event Transfer(address indexed from, address indexed to, uint256 value);
110 }
111 
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) returns (bool) {
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of. 
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) constant returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) returns (bool);
143   function approve(address spender, uint256 value) returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amout of tokens to be transfered
157    */
158   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
159     var _allowance = allowed[_from][msg.sender];
160 
161     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162     // require (_value <= _allowance);
163 
164     balances[_to] = balances[_to].add(_value);
165     balances[_from] = balances[_from].sub(_value);
166     allowed[_from][msg.sender] = _allowance.sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) returns (bool) {
177 
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 contract PausableToken is StandardToken, Pausable {
202 
203   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
204     return super.transfer(_to, _value);
205   }
206 
207   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
208     return super.transferFrom(_from, _to, _value);
209   }
210 }
211 
212 contract Factory {
213 
214     // address public mainnetPresaleContractAddress = 0x6a5B0fa01590ec2F03682023192C95A2EBd8e3B9;
215     // address[] public mainnetPresaleBuyers = [
216     //     0x00010bd8606a84b1bbad0f2c70b13cce44a46910,
217     //     0x00a109ab01028056768469aa11328c8f9d3db45b,
218     //     0x01e2f9ba53b6cb91e7f158090d24ebbcadf0c564,
219     //     0x0347297c8c1f278c739ff8d76550a3386cf88b60,
220     //     0x09b467499cfa5b094aa96eea80fa7095a2508731,
221     //     0x0cea3e5c3663f8634b623327a635ca8c2e0ca276,
222     //     0x0f659b838270390aaa6bf16e0b9d01ad15d43f00,
223     //     0x188cac349c6a156476711a2357779706cfed403f,
224     //     0x18ea39b27b1dd0e53a46a90f544a3ee6e16f94c4,
225     //     0x1b3b36b36a64aaef71354ef655bffd577ba0276c,
226     //     0x1e74a46e968bc0472d09533bf93da27a6c21b079,
227     //     0x20abf65634219512c6c98a64614c43220ca2085b,
228     //     0x2195fe76d358acd2dc7e804f60bb5f4d53d9f907,
229     //     0x23cdcdfcf58a593ed16cf8ff5516a37fee1d48d8,
230     //     0x2471ceb7520b926ba02d876cd032fd020237e413,
231     //     0x249f600fd158ccd81a418db93a5d3d1b3c420b13,
232     //     0x267be1c1d684f78cb4f6a176c4911b741e4ffdc0,
233     //     0x2c02d03f53489bd2774f9e360ea393a6c6329bdb,
234     //     0x330c63a5b737b5542be108a74b3fef6272619585,
235     //     0x358c39cc0aba5fcc0689d840024c4caeb06f85c0,
236     //     0x36ca1322f23209703d7bfc4663d2267b07a4cbe8,
237     //     0x3833f8dbdbd6bdcb6a883ff209b869148965b364,
238     //     0x387fa411fae6769e4fcedcba838d22ea2dd9ffed,
239     //     0x3d6f29c67f571cad827bb512c7949b0a1c0b9899,
240     //     0x3eb0aefabec429149dd0d4ae560238fb0b68976e,
241     //     0x3f04b7101708b7e4a2c693270254ef8a32977b36,
242     //     0x41e8374286aacb2b85189cc74b4d1c0362d4fc80,
243     //     0x4644c88b98dd5dda0cb6040366df2b4f37e6b50f,
244     //     0x4a83cee7d83c28891d851910f7a240a4c2c4d9eb,
245     //     0x4b0250098cf3f62f4595be93d8c0afcfe0bd63f1,
246     //     0x4f813b5cf2750a59a45f3c5e50397d6ac02b64f9,
247     //     0x5030baf58fab3c95799edc9e6cd08abfde5f1e5a,
248     //     0x51072c4f9bca88bc9b3b2327fb44b1272ba115c0,
249     //     0x532cbc68f66bb7482086a15972fa20ee3aca21c4,
250     //     0x53564581a45a5520243083ce050f76ef933a1e66,
251     //     0x55c86e80fbe2db0d81ff856110556b1df1713899,
252     //     0x598f65c344b3644a9b6bd23a99860cd8d0c3e20a,
253     //     0x5f2bdf26f6528ce05aac77d7fa52bac7a836ef66,
254     //     0x63e0d8753480ffcc6ce65ec46f9efb06778e819c,
255     //     0x66294a00e801db524b215952bf60e85e1a945895,
256     //     0x6771bb70d84bedeb60166df47ebb9056169d7a0d,
257     //     0x67adfab056edc1a03602139b8ac36a06fc62f1bb,
258     //     0x72df894c334a0b8a58b7d220b72d29a50521d9a4,
259     //     0x72f084f5ed9384194870b855c22b0065961305b4,
260     //     0x75360cbe8c7cb8174b1b623a6d9aacf952c117e3,
261     //     0x75e7f640bf6968b6f32c47a3cd82c3c2c9dcae68,
262     //     0x76d3451bec571316cfe096b1ab64681286b078d5,
263     //     0x783bd8a6077d02eeecbfc142929d71ff4aa2762d,
264     //     0x7c01113c3c382d9c1c39e3daa9262e27787a02ee,
265     //     0x7ed1e469fcb3ee19c0366d829e291451be638e59,
266     //     0x7fec3afb1075d3ee2ca6bd685a9895290ad917df,
267     //     0x83e09aee382c74ac0c3094d4a99a45d607590c28,
268     //     0x86a392b40c6b33fdbb142eae4c40ff05d3daa82f,
269     //     0x87b10daf0522e54cd4cdd3029eac0fdd306f644e,
270     //     0x87b325cf000e426b64518d50bf3fb11c28eee89e,
271     //     0x8c46dc82995d3bad337418df9a111b289fd50abc,
272     //     0x93fb7bea36d788bcb87ba92094b72c6c43586bdb,
273     //     0x952aa202f9656eca051ef36ce66925a0d0e34723,
274     //     0x9903322124677c2aaf289eec5117bfa8aeac3f42,
275     //     0x993841ab5028ee74245d350edd3c89405d4212ea,
276     //     0x9ac0233a97b0005462f7d65943b8cf6d7d074280,
277     //     0x9d8d17d134be89c832559e1653f8e15d6b8bb05a,
278     //     0xa102d39f4aa67f458e9536b04da9b80847c04a57,
279     //     0xa163d40de9dc681d7850ed24564d1805414ac468,
280     //     0xa263327200a9648c063ef1d9f0746a50b23caa56,
281     //     0xaefb5464fadc9293700a9c4bc4fbefb4d768931d,
282     //     0xaf302aa751058797c6ab5249cb83547a6357763a,
283     //     0xb37e62dce9daee5a2de41e4475c8262f5bb9edae,
284     //     0xb93b6e8816091ceb78cca35f7022b477e44c490a,
285     //     0xb94142f522bfe77b1075527d8e6a11cbcd901e26,
286     //     0xbb4e6fdfbc01b1f2b52272d998fcaa274d7f1651,
287     //     0xbdf9b5bda53c709cce44a073067b3e26afe1d816,
288     //     0xcd73fd5deec3670926d0cd29b634f6c2938b1df6,
289     //     0xcf1996c3b7f9ff891ebf94067b6d0edfa1b181f0,
290     //     0xd1f670779246349931ba76ffdf8c90de70946cac,
291     //     0xd2e3c4856d25a71fa777769b5dc9596890568026,
292     //     0xd4cb7fd8e2b214596c1cbd4ba0f1c701fbf2bcb8,
293     //     0xd5742c05e6ae9ea99af45a7c7d1517ce6c042d25,
294     //     0xe41ce247756d757e3060ec361c201be019bd54f6,
295     //     0xe702afb99a46f9a6e15d3565823867b8b40c499c,
296     //     0xec30eacdb39705ec281e10891d605cb0be41e094,
297     //     0xee55181386d9b743064c570601014df163d5554c,
298     //     0xee8ce6f0ebef4231068db3705fadff5ef9a1f45e,
299     //     0xef58321032cf693fa7e39f31e45cbc32f2092cb3,
300     //     0xef9a1b20384989f79f73fd5a261e270d6d1888d3,
301     //     0xf656d04f13b7bdf09410b8b5cb75bbe3ac5a37e7,
302     //     0xf6dc43ba328affec2afebda472ac6977200da957,
303     //     0xf6edf5dcdfba55f3cecee2a430bb6c2d30a4a1a8,
304     //     0xf8ac3740622308414a41619af0648328f69b6fc0,
305     //     0xf8f337c518b4979f12348c279696a5b7754f662e,
306     //     0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98,
307     //     0xfc7d5e499f869d8ee0b17c61b0f6f83bbac2fbc2,
308     //     0xffca1e2e0e50faf10cd4a8e1d5bd2f5db57a0771
309     // ];
310 
311     // address public testnetPresaleContractAddress = 0x6fb8A63800a00141052Ea524f415398188879086;
312     // address[] public testnetPresaleBuyers = [
313     //     0xf6c6fac8b78e3196eced61df42a0d37cfddbf3f8  
314     // ];
315 
316     function createContract(
317         address newWallet,
318         address newMarketingWallet,
319         address newLiquidityReserveWallet,
320         uint256 newIcoEtherMinCap,
321         uint256 newIcoEtherMaxCap,
322         uint256 totalPresaleRaised) returns(address created)
323     {
324         return new SomaIco(
325                         newWallet,
326                         newMarketingWallet,
327                         newLiquidityReserveWallet,
328                         newIcoEtherMinCap * 1 ether,
329                         newIcoEtherMaxCap * 1 ether,
330                         totalPresaleRaised
331         );
332     }
333 
334     function createTestNetContract(
335         address wallet,
336         address marketingWallet,
337         address liquidityReserveWallet,
338         uint256 newIcoEtherMinCap,
339         uint256 newIcoEtherMaxCap,
340         uint256 totalPresaleRaised) returns(address created)
341     {
342     
343      /*
344      Contract Admin/Owner: 0x695CA2a93A53f81a7bc48E2c92801A9c0D489a4C
345      Funds Wallet: 0x114189928020641C388cBD6126E615f8328A7409
346      Marketing wallet: 0x114189928020641C388cBD6126E615f8328A7409
347      Liquidity reserve 0x0873D8c478A2E80C5467374661e903c121c3A8C4
348      Presale total supply: 2007500000000000000000
349      */
350      
351         address contractAddress = createContract(
352             wallet,
353             marketingWallet,
354             liquidityReserveWallet,
355             newIcoEtherMinCap,
356             newIcoEtherMaxCap,
357             totalPresaleRaised
358         );
359 
360         //migratePresaleBalances(contractAddress, testnetPresaleContractAddress, testnetPresaleBuyers);
361 
362         //transferOwnership(owner, contractAddress);
363 
364         return contractAddress;
365     }
366 
367     function createMainNetContract(
368         uint256 newIcoEtherMinCap,
369         uint256 newIcoEtherMaxCap) returns(address created)
370     {
371         //address owner = 0x1025376b8991ACAFBc7d84Fa1a56a63DcfBF04CB; // mainnet admin
372         address wallet = 0x22c6731A21aD946Bcd934f62f04B2D06EBFbedC9; // mainnet funds
373         address marketingWallet = 0x4A5467431b54C152E404EB702242E78030972DE7; // marketing wallet
374         address liquidityReserveWallet = 0xdf398E0bE9e0Da2D8F8D687FD6B2c9082eEFC29a;
375 
376         uint256 totalPresaleRaised = 258405312277978624000;
377 
378         address contractAddress = createContract(
379             wallet,
380             marketingWallet,
381             liquidityReserveWallet,
382             newIcoEtherMinCap,
383             newIcoEtherMaxCap,
384             totalPresaleRaised
385         );
386 
387         //migratePresaleBalances(contractAddress, mainnetPresaleContractAddress, mainnetPresaleBuyers);
388 
389         //transferOwnership(owner, contractAddress);
390 
391         return contractAddress;
392     }
393 
394     function transferOwnership(address owner, address contractAddress) public {
395         Ownable ownableContract = Ownable(contractAddress);
396         ownableContract.transferOwnership(owner);
397     }
398 
399     function migratePresaleBalances(
400         address icoContractAddress,
401         address presaleContractAddress,
402         address[] buyers) public
403     {
404         SomaIco icoContract = SomaIco(icoContractAddress);
405         ERC20Basic presaleContract = ERC20Basic(presaleContractAddress);
406         for (uint i = 0; i < buyers.length; i++) {
407             address buyer = buyers[i];
408             if (icoContract.balanceOf(buyer) > 0) {
409                 continue;
410             }
411             uint256 balance = presaleContract.balanceOf(buyer);
412             if (balance > 0) {
413                 icoContract.manuallyAssignTokens(buyer, balance);
414             }
415         }
416     }
417 }
418 
419 contract SomaIco is PausableToken {
420     using SafeMath for uint256;
421 
422     string public name = "Soma Community Token";
423     string public symbol = "SCT";
424     uint8 public decimals = 18;
425 
426     address public liquidityReserveWallet; // address where liquidity reserve tokens will be delivered
427     address public wallet; // address where funds are collected
428     address public marketingWallet; // address which controls marketing token pool
429 
430     uint256 public icoStartTimestamp; // ICO start timestamp
431     uint256 public icoEndTimestamp; // ICO end timestamp
432 
433     uint256 public totalRaised = 0; // total amount of money raised in wei
434     uint256 public totalSupply; // total token supply with decimals precisoin
435     uint256 public marketingPool; // marketing pool with decimals precisoin
436     uint256 public tokensSold = 0; // total number of tokens sold
437 
438     bool public halted = false; //the owner address can set this to true to halt the crowdsale due to emergency
439 
440     uint256 public icoEtherMinCap; // should be specified as: 8000 * 1 ether
441     uint256 public icoEtherMaxCap; // should be specified as: 120000 * 1 ether
442     uint256 public rate = 450; // standard SCT/ETH rate
443 
444     event Burn(address indexed burner, uint256 value);
445 
446     function SomaIco(
447         address newWallet,
448         address newMarketingWallet,
449         address newLiquidityReserveWallet,
450         uint256 newIcoEtherMinCap,
451         uint256 newIcoEtherMaxCap,
452         uint256 totalPresaleRaised
453     ) {
454         require(newWallet != 0x0);
455         require(newMarketingWallet != 0x0);
456         require(newLiquidityReserveWallet != 0x0);
457         require(newIcoEtherMinCap <= newIcoEtherMaxCap);
458         require(newIcoEtherMinCap > 0);
459         require(newIcoEtherMaxCap > 0);
460 
461         pause();
462 
463         icoEtherMinCap = newIcoEtherMinCap;
464         icoEtherMaxCap = newIcoEtherMaxCap;
465         wallet = newWallet;
466         marketingWallet = newMarketingWallet;
467         liquidityReserveWallet = newLiquidityReserveWallet;
468 
469         // calculate marketingPool and totalSupply based on the max cap:
470         // totalSupply = rate * icoEtherMaxCap + marketingPool
471         // marketingPool = 10% * totalSupply
472         // hence:
473         // totalSupply = 10/9 * rate * icoEtherMaxCap
474         totalSupply = icoEtherMaxCap.mul(rate).mul(10).div(9);
475         marketingPool = totalSupply.div(10);
476 
477         // account for the funds raised during the presale
478         totalRaised = totalRaised.add(totalPresaleRaised);
479 
480         // assign marketing pool to marketing wallet
481         assignTokens(marketingWallet, marketingPool);
482     }
483 
484     /// fallback function to buy tokens
485     function () nonHalted nonZeroPurchase acceptsFunds payable {
486         address recipient = msg.sender;
487         uint256 weiAmount = msg.value;
488 
489         uint256 amount = weiAmount.mul(rate);
490 
491         assignTokens(recipient, amount);
492         totalRaised = totalRaised.add(weiAmount);
493 
494         forwardFundsToWallet();
495     }
496 
497     modifier acceptsFunds() {
498         bool hasStarted = icoStartTimestamp != 0 && now >= icoStartTimestamp;
499         require(hasStarted);
500 
501         // ICO is continued over the end date until the min cap is reached
502         bool isIcoInProgress = now <= icoEndTimestamp
503                 || (icoEndTimestamp == 0) // before dates are set
504                 || totalRaised < icoEtherMinCap;
505         require(isIcoInProgress);
506 
507         bool isBelowMaxCap = totalRaised < icoEtherMaxCap;
508         require(isBelowMaxCap);
509 
510         _;
511     }
512 
513     modifier nonHalted() {
514         require(!halted);
515         _;
516     }
517 
518     modifier nonZeroPurchase() {
519         require(msg.value > 0);
520         _;
521     }
522 
523     function forwardFundsToWallet() internal {
524         wallet.transfer(msg.value); // immediately send Ether to wallet address, propagates exception if execution fails
525     }
526 
527     function assignTokens(address recipient, uint256 amount) internal {
528         balances[recipient] = balances[recipient].add(amount);
529         tokensSold = tokensSold.add(amount);
530 
531         // sanity safeguard
532         if (tokensSold > totalSupply) {
533             // there is a chance that tokens are sold over the supply:
534             // a) when: total presale bonuses > (maxCap - totalRaised) * rate
535             // b) when: last payment goes over the maxCap
536             totalSupply = tokensSold;
537         }
538 
539         Transfer(0x0, recipient, amount);
540     }
541 
542     function setIcoDates(uint256 newIcoStartTimestamp, uint256 newIcoEndTimestamp) public onlyOwner {
543         require(newIcoStartTimestamp < newIcoEndTimestamp);
544         require(!isIcoFinished());
545         icoStartTimestamp = newIcoStartTimestamp;
546         icoEndTimestamp = newIcoEndTimestamp;
547     }
548 
549     function setRate(uint256 _rate) public onlyOwner {
550         require(!isIcoFinished());
551         rate = _rate;
552     }
553 
554     function haltFundraising() public onlyOwner {
555         halted = true;
556     }
557 
558     function unhaltFundraising() public onlyOwner {
559         halted = false;
560     }
561 
562     function isIcoFinished() public constant returns (bool icoFinished) {
563         return (totalRaised >= icoEtherMinCap && icoEndTimestamp != 0 && now > icoEndTimestamp) ||
564                (totalRaised >= icoEtherMaxCap);
565     }
566 
567     function prepareLiquidityReserve() public onlyOwner {
568         require(isIcoFinished());
569         
570         uint256 unsoldTokens = totalSupply.sub(tokensSold);
571         // make sure there are any unsold tokens to be assigned
572         require(unsoldTokens > 0);
573 
574         // try to allocate up to 10% of total sold tokens to Liquidity Reserve fund:
575         uint256 liquidityReserveTokens = tokensSold.div(10);
576         if (liquidityReserveTokens > unsoldTokens) {
577             liquidityReserveTokens = unsoldTokens;
578         }
579         assignTokens(liquidityReserveWallet, liquidityReserveTokens);
580         unsoldTokens = unsoldTokens.sub(liquidityReserveTokens);
581 
582         // if there are still unsold tokens:
583         if (unsoldTokens > 0) {
584             // decrease  (burn) total supply by the number of unsold tokens:
585             totalSupply = totalSupply.sub(unsoldTokens);
586         }
587 
588         // make sure there are no tokens left
589         assert(tokensSold == totalSupply);
590     }
591 
592     function manuallyAssignTokens(address recipient, uint256 amount) public onlyOwner {
593         require(tokensSold < totalSupply);
594         assignTokens(recipient, amount);
595     }
596 
597     /**
598      * @dev Burns a specific amount of tokens.
599      * @param _value The amount of token to be burned.
600      */
601     function burn(uint256 _value) public whenNotPaused {
602         require(_value > 0);
603 
604         address burner = msg.sender;
605         balances[burner] = balances[burner].sub(_value);
606         totalSupply = totalSupply.sub(_value);
607         Burn(burner, _value);
608     }
609 
610 }