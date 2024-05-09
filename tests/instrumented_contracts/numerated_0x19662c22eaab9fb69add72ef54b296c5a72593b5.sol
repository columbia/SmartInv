1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 
17         uint256 c = a / b;
18 
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36 
37     address public owner;
38 
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function Ownable() public {
48         owner = msg.sender;
49     }
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 
57 }
58 
59 
60 contract ERC20Basic {
61 
62     uint256 public totalSupply;
63   
64     function balanceOf(address who) public view returns (uint256);
65   
66     function transfer(address to, uint256 value) public returns (bool);
67   
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 contract BasicToken is ERC20Basic {
73     using SafeMath for uint256;
74 
75     mapping(address => uint256) balances;
76 
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) public view returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90 }
91 
92 
93 contract ERC20 is ERC20Basic {
94 
95     function allowance(address owner, address spender) public view returns (uint256);
96 
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98 
99     function approve(address spender, uint256 value) public returns (bool);
100 
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107     mapping (address => mapping (address => uint256)) internal allowed;
108 
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[_from]);
112         require(_value <= allowed[_from][msg.sender]);
113         balances[_from] = balances[_from].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     function approve(address _spender, uint256 _value) public returns (bool) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) public view returns (uint256) {
127         return allowed[_owner][_spender];
128     }
129 
130     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
131         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133         return true;
134     }
135 
136     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
137         uint oldValue = allowed[msg.sender][_spender];
138         if (_subtractedValue > oldValue) {
139             allowed[msg.sender][_spender] = 0;
140         } else {
141             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142         }
143         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144         return true;
145     }
146 }
147 
148 
149 contract ReleasableToken is StandardToken, Ownable {
150 
151     address public releaseAgent;
152 
153     bool public released = false;
154 
155     event Released();
156 
157     event ReleaseAgentSet(address releaseAgent);
158 
159     event TransferAgentSet(address transferAgent, bool status);
160 
161     mapping (address => bool) public transferAgents;
162 
163     modifier canTransfer(address _sender) {
164         require(released || transferAgents[_sender]);
165         _;
166     }
167 
168     modifier inReleaseState(bool releaseState) {
169         require(releaseState == released);
170         _;
171     }
172 
173     modifier onlyReleaseAgent() {
174         require(msg.sender == releaseAgent);
175         _;
176     }
177 
178     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
179         ReleaseAgentSet(addr);
180         releaseAgent = addr;
181     }
182 
183     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
184         TransferAgentSet(addr, state);
185         transferAgents[addr] = state;
186     }
187 
188     function releaseTokenTransfer() public onlyReleaseAgent {
189         Released();
190         released = true;
191     }
192 
193     function transfer(address _to, 
194                       uint _value) public canTransfer(msg.sender) returns (bool success) {
195         return super.transfer(_to, _value);
196     }
197 
198     function transferFrom(address _from, 
199                           address _to, 
200                           uint _value) public canTransfer(_from) returns (bool success) {
201         return super.transferFrom(_from, _to, _value);
202     }
203 }
204 
205 
206 contract TruMintableToken is ReleasableToken {
207     
208     using SafeMath for uint256;
209     using SafeMath for uint;
210 
211     bool public mintingFinished = false;
212 
213     bool public preSaleComplete = false;
214 
215     bool public saleComplete = false;
216 
217     event Minted(address indexed _to, uint256 _amount);
218 
219     event MintFinished(address indexed _executor);
220     
221     event PreSaleComplete(address indexed _executor);
222 
223     event SaleComplete(address indexed _executor);
224 
225     modifier canMint() {
226         require(!mintingFinished);
227         _;
228     }
229 
230     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
231         require(_amount > 0);
232         require(_to != address(0));
233         totalSupply = totalSupply.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         Minted(_to, _amount);
236         Transfer(0x0, _to, _amount);
237         return true;
238     }
239 
240     function finishMinting(bool _presale, bool _sale) public onlyOwner returns (bool) {
241         require(_sale != _presale);
242         if (_presale == true) {
243             preSaleComplete = true;
244             PreSaleComplete(msg.sender);
245             return true;
246         }
247         require(preSaleComplete == true);
248         saleComplete = true;
249         SaleComplete(msg.sender);
250         mintingFinished = true;
251         MintFinished(msg.sender);
252         return true;
253     }
254 }
255 
256 
257 contract UpgradeAgent {
258     
259     uint public originalSupply;
260 
261     function isUpgradeAgent() public pure returns (bool) {
262         return true;
263     }
264 
265     function upgradeFrom(address _from, uint256 _value) public;
266 }
267 
268 
269 contract TruUpgradeableToken is StandardToken {
270 
271     using SafeMath for uint256;
272     using SafeMath for uint;
273 
274     address public upgradeMaster;
275 
276     UpgradeAgent public upgradeAgent;
277 
278     uint256 public totalUpgraded;
279 
280     bool private isUpgradeable = true;
281 
282     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
283 
284     event Upgrade(address indexed from, 
285         address indexed to, 
286         uint256 upgradeValue);
287 
288     event UpgradeAgentSet(address indexed agent, 
289         address indexed executor);
290 
291     event NewUpgradedAmount(uint256 originalBalance, 
292         uint256 newBalance, 
293         address indexed executor);
294     
295     modifier onlyUpgradeMaster() {
296         require(msg.sender == upgradeMaster);
297         _;
298     }
299 
300     function TruUpgradeableToken(address _upgradeMaster) public {
301         require(_upgradeMaster != address(0));
302         upgradeMaster = _upgradeMaster;
303     }
304 
305     function upgrade(uint256 _value) public {
306         UpgradeState state = getUpgradeState();
307         require((state == UpgradeState.ReadyToUpgrade) || (state == UpgradeState.Upgrading));
308         require(_value > 0);
309         require(balances[msg.sender] >= _value);
310         uint256 upgradedAmount = totalUpgraded.add(_value);
311         uint256 senderBalance = balances[msg.sender];
312         uint256 newSenderBalance = senderBalance.sub(_value);      
313         uint256 newTotalSupply = totalSupply.sub(_value);
314         balances[msg.sender] = newSenderBalance;
315         totalSupply = newTotalSupply;        
316         NewUpgradedAmount(totalUpgraded, newTotalSupply, msg.sender);
317         totalUpgraded = upgradedAmount;
318         upgradeAgent.upgradeFrom(msg.sender, _value);
319         Upgrade(msg.sender, upgradeAgent, _value);
320     }
321 
322     function setUpgradeAgent(address _agent) public onlyUpgradeMaster {
323         require(_agent != address(0));
324         require(canUpgrade());
325         require(getUpgradeState() != UpgradeState.Upgrading);
326         UpgradeAgent newUAgent = UpgradeAgent(_agent);
327         require(newUAgent.isUpgradeAgent());
328         require(newUAgent.originalSupply() == totalSupply);
329         UpgradeAgentSet(upgradeAgent, msg.sender);
330         upgradeAgent = newUAgent;
331     }
332 
333     function getUpgradeState() public constant returns(UpgradeState) {
334         if (!canUpgrade())
335             return UpgradeState.NotAllowed;
336         else if (upgradeAgent == address(0))
337             return UpgradeState.WaitingForAgent;
338         else if (totalUpgraded == 0)
339             return UpgradeState.ReadyToUpgrade;
340         else 
341             return UpgradeState.Upgrading;
342     }
343 
344     function setUpgradeMaster(address _master) public onlyUpgradeMaster {
345         require(_master != address(0));
346         upgradeMaster = _master;
347     }
348 
349     function canUpgrade() public constant returns(bool) {
350         return isUpgradeable;
351     }
352 }
353 
354 
355 contract TruReputationToken is TruMintableToken, TruUpgradeableToken {
356 
357     using SafeMath for uint256;
358     
359     using SafeMath for uint;
360 
361     uint8 public constant decimals = 18;
362 
363     string public constant name = "Tru Reputation Token";
364 
365     string public constant symbol = "TRU";
366 
367     address public execBoard = 0x0;
368 
369     event BoardAddressChanged(address indexed oldAddress, 
370         address indexed newAddress, 
371         address indexed executor);
372 
373     modifier onlyExecBoard() {
374         require(msg.sender == execBoard);
375         _;
376     }
377 
378     function TruReputationToken() public TruUpgradeableToken(msg.sender) {
379         execBoard = msg.sender;
380         BoardAddressChanged(0x0, msg.sender, msg.sender);
381     }
382     
383     function changeBoardAddress(address _newAddress) public onlyExecBoard {
384         require(_newAddress != address(0));
385         require(_newAddress != execBoard);
386         address oldAddress = execBoard;
387         execBoard = _newAddress;
388         BoardAddressChanged(oldAddress, _newAddress, msg.sender);
389     }
390 
391     function canUpgrade() public constant returns(bool) {
392         return released && super.canUpgrade();
393     }
394 
395     function setUpgradeMaster(address _master) public onlyOwner {
396         super.setUpgradeMaster(_master);
397     }
398 }
399 
400 
401 contract Haltable is Ownable {
402 
403     bool public halted;
404 
405     event HaltStatus(bool status);
406 
407     modifier stopInEmergency {
408         require(!halted);
409         _;
410     }
411 
412     modifier onlyInEmergency {
413         require(halted);
414         _;
415     }
416 
417     function halt() external onlyOwner {
418         halted = true;
419         HaltStatus(halted);
420     }
421 
422     function unhalt() external onlyOwner onlyInEmergency {
423         halted = false;
424         HaltStatus(halted);
425     }
426 }
427 
428 
429 contract TruSale is Ownable, Haltable {
430     
431     using SafeMath for uint256;
432   
433     TruReputationToken public truToken;
434 
435     uint256 public saleStartTime;
436     
437     uint256 public saleEndTime;
438 
439     uint public purchaserCount = 0;
440 
441     address public multiSigWallet;
442 
443     uint256 public constant BASE_RATE = 1000;
444   
445     uint256 public constant PRESALE_RATE = 1250;
446 
447     uint256 public constant SALE_RATE = 1125;
448 
449     uint256 public constant MIN_AMOUNT = 1 * 10**18;
450 
451     uint256 public constant MAX_AMOUNT = 20 * 10**18;
452 
453     uint256 public weiRaised;
454 
455     uint256 public cap;
456 
457     bool public isCompleted = false;
458 
459     bool public isPreSale = false;
460 
461     bool public isCrowdSale = false;
462 
463     uint256 public soldTokens = 0;
464 
465     mapping(address => uint256) public purchasedAmount;
466 
467     mapping(address => uint256) public tokenAmount;
468 
469     mapping (address => bool) public purchaserWhiteList;
470 
471     event TokenPurchased(
472         address indexed purchaser, 
473         address indexed recipient, 
474         uint256 weiValue, 
475         uint256 tokenAmount);
476 
477     event WhiteListUpdated(address indexed purchaserAddress, 
478         bool whitelistStatus, 
479         address indexed executor);
480 
481     event EndChanged(uint256 oldEnd, 
482         uint256 newEnd, 
483         address indexed executor);
484 
485     event Completed(address indexed executor);
486 
487     modifier onlyTokenOwner(address _tokenOwner) {
488         require(msg.sender == _tokenOwner);
489         _;
490     }
491 
492     function TruSale(uint256 _startTime, 
493         uint256 _endTime, 
494         address _token, 
495         address _saleWallet) public {
496         require(_token != address(0));
497         TruReputationToken tToken = TruReputationToken(_token);
498         address tokenOwner = tToken.owner();
499         createSale(_startTime, _endTime, _token, _saleWallet, tokenOwner);
500     }
501 
502     function buy() public payable stopInEmergency {
503         require(checkSaleValid());
504         validatePurchase(msg.sender);
505     }
506 
507     function updateWhitelist(address _purchaser, uint _status) public onlyOwner {
508         require(_purchaser != address(0));
509         bool boolStatus = false;
510         if (_status == 0) {
511             boolStatus = false;
512         } else if (_status == 1) {
513             boolStatus = true;
514         } else {
515             revert();
516         }
517         WhiteListUpdated(_purchaser, boolStatus, msg.sender);
518         purchaserWhiteList[_purchaser] = boolStatus;
519     }
520 
521     function changeEndTime(uint256 _endTime) public onlyOwner {
522         require(_endTime >= saleStartTime);
523         EndChanged(saleEndTime, _endTime, msg.sender);
524         saleEndTime = _endTime;
525     }
526 
527     function hasEnded() public constant returns (bool) {
528         bool isCapHit = weiRaised >= cap;
529         bool isExpired = now > saleEndTime;
530         return isExpired || isCapHit;
531     }
532     
533     function checkSaleValid() internal constant returns (bool) {
534         bool afterStart = now >= saleStartTime;
535         bool beforeEnd = now <= saleEndTime;
536         bool capNotHit = weiRaised.add(msg.value) <= cap;
537         return afterStart && beforeEnd && capNotHit;
538     }
539 
540     function validatePurchase(address _purchaser) internal stopInEmergency {
541         require(_purchaser != address(0));
542         require(msg.value > 0);
543         buyTokens(_purchaser);
544     }
545 
546     function forwardFunds() internal {
547         multiSigWallet.transfer(msg.value);
548     }
549 
550     function createSale(
551         uint256 _startTime, 
552         uint256 _endTime, 
553         address _token, 
554         address _saleWallet, 
555         address _tokenOwner) 
556         internal onlyTokenOwner(_tokenOwner) 
557     {
558         require(now <= _startTime);
559         require(_endTime >= _startTime);
560         require(_saleWallet != address(0));
561         truToken = TruReputationToken(_token);
562         multiSigWallet = _saleWallet;
563         saleStartTime = _startTime;
564         saleEndTime = _endTime;
565     }
566 
567     function buyTokens(address _purchaser) private {
568         uint256 weiTotal = msg.value;
569         require(weiTotal >= MIN_AMOUNT);
570         if (weiTotal > MAX_AMOUNT) {
571             require(purchaserWhiteList[msg.sender]); 
572         }
573         if (purchasedAmount[msg.sender] != 0 && !purchaserWhiteList[msg.sender]) {
574             uint256 totalPurchased = purchasedAmount[msg.sender];
575             totalPurchased = totalPurchased.add(weiTotal);
576             require(totalPurchased < MAX_AMOUNT);
577         }
578         uint256 tokenRate = BASE_RATE;    
579         if (isPreSale) {
580             tokenRate = PRESALE_RATE;
581         }
582         if (isCrowdSale) {
583             tokenRate = SALE_RATE;
584         }
585         uint256 noOfTokens = weiTotal.mul(tokenRate);
586         weiRaised = weiRaised.add(weiTotal);
587         if (purchasedAmount[msg.sender] == 0) {
588             purchaserCount++;
589         }
590         soldTokens = soldTokens.add(noOfTokens);
591         purchasedAmount[msg.sender] = purchasedAmount[msg.sender].add(msg.value);
592         tokenAmount[msg.sender] = tokenAmount[msg.sender].add(noOfTokens);
593         truToken.mint(_purchaser, noOfTokens);
594         TokenPurchased(msg.sender,
595         _purchaser,
596         weiTotal,
597         noOfTokens);
598         forwardFunds();
599     }
600 }
601 
602 
603 contract TruPreSale is TruSale {
604     
605     using SafeMath for uint256;
606     
607     uint256 public constant PRESALE_CAP = 4000 * 10**18;
608     
609     function TruPreSale(
610         uint256 _startTime, 
611         uint256 _endTime, 
612         address _token,
613         address _saleWallet) public TruSale(_startTime, _endTime, _token, _saleWallet) 
614     {
615         isPreSale = true;
616         isCrowdSale = false;
617         cap = PRESALE_CAP;
618     }
619     
620     function finalise() public onlyOwner {
621         require(!isCompleted);
622         require(hasEnded());
623 
624         completion();
625         Completed(msg.sender);
626 
627         isCompleted = true;
628     }
629 
630     function completion() internal {
631         uint256 poolTokens = truToken.totalSupply();
632         truToken.mint(multiSigWallet, poolTokens);
633         truToken.finishMinting(true, false);
634         truToken.transferOwnership(msg.sender);
635     }
636 }