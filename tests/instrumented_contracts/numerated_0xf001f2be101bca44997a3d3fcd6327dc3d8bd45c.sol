1 pragma solidity > 0.4.99 <0.6.0;
2 
3 interface IERC20Token {
4     function balanceOf(address owner) external returns (uint256);
5     function transfer(address to, uint256 amount) external returns (bool);
6     function burn(uint256 _value) external returns (bool);
7     function decimals() external returns (uint256);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
10 }
11 
12 contract Ownable {
13   address payable public _owner;
14 
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20   /**
21   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22   * account.
23   */
24   constructor() internal {
25     _owner = tx.origin;
26     emit OwnershipTransferred(address(0), _owner);
27   }
28 
29   /**
30   * @return the address of the owner.
31   */
32   function owner() public view returns(address) {
33     return _owner;
34   }
35 
36   /**
37   * @dev Throws if called by any account other than the owner.
38   */
39   modifier onlyOwner() {
40     require(isOwner());
41     _;
42   }
43 
44   /**
45   * @return true if `msg.sender` is the owner of the contract.
46   */
47   function isOwner() public view returns(bool) {
48     return msg.sender == _owner;
49   }
50 
51   /**
52   * @dev Allows the current owner to relinquish control of the contract.
53   * @notice Renouncing to ownership will leave the contract without an owner.
54   * It will not be possible to call the functions with the `onlyOwner`
55   * modifier anymore.
56   */
57   function renounceOwnership() public onlyOwner {
58     emit OwnershipTransferred(_owner, address(0));
59     _owner = address(0);
60   }
61 
62   /**
63   * @dev Allows the current owner to transfer control of the contract to a newOwner.
64   * @param newOwner The address to transfer ownership to.
65   */
66   function transferOwnership(address payable newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   /**
71   * @dev Transfers control of the contract to a newOwner.
72   * @param newOwner The address to transfer ownership to.
73   */
74   function _transferOwnership(address payable newOwner) internal {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(_owner, newOwner);
77     _owner = newOwner;
78   }
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, throws on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     if (a == 0) {
92       return 0;
93     }
94     uint256 c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 contract PayeeShare is Ownable{
128     
129     struct Payee {
130         address payable payee;
131         uint payeePercentage;
132     }
133     
134     Payee[] public payees;
135     
136     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
137     
138     IERC20Token public tokenContract;
139     
140     bool processingPayout = false;
141     
142     uint256 public payeePartsLeft = 100;
143     uint256 public payeePartsToSell = 0;
144     uint256 public payeePricePerPart = 0;
145     
146     uint256 public lockedToken;
147     uint256 public lockedTokenTime;
148     uint256 minTokenTransfer = 1;
149     
150     using SafeMath for uint256;
151     
152     event TokenPayout(address receiver, uint256 value, string memberOf);
153     event EtherPayout(address receiver, uint256 value, string memberOf);
154     event PayeeAdded(address payee, uint256 partsPerFull);
155     event LockedTokensUnlocked();
156     
157     constructor(address _tokenContract, uint256 _lockedToken, uint256 _lockedTokenTime) public {
158         tokenContract = IERC20Token(_tokenContract);
159         lockedToken = _lockedToken;
160         lockedTokenTime = _lockedTokenTime;
161     }
162     
163     function changePayee(uint256 _payeeId, address payable _payee, uint256 _percentage) public onlyOwner {
164       require(payees.length >= _payeeId);
165       Payee storage myPayee = payees[_payeeId];
166       myPayee.payee = _payee;
167       myPayee.payeePercentage = _percentage;
168     }
169   
170     function getPayeeLenght() public view returns (uint256) {
171         return payees.length;
172     }
173     
174      function getLockedToken() public view returns (uint256) {
175         return lockedToken;
176     }
177     
178     function addPayee(address payable _address, uint _payeePercentage) public payable {
179         if (msg.sender == _owner) {
180         require(payeePartsLeft >= _payeePercentage);
181         payeePartsLeft = payeePartsLeft.sub(_payeePercentage);
182         payees.push(Payee(_address, _payeePercentage));
183         emit PayeeAdded(_address, _payeePercentage);
184         }
185         else if (msg.value == _payeePercentage.mul(payeePricePerPart)) {
186         if (address(this).balance > 0) {
187           etherPayout();
188         }
189         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 1) {
190           tokenPayout();
191         }
192             require(payeePartsLeft >= _payeePercentage);
193             require(payeePartsToSell >= _payeePercentage);
194             require(tx.origin == msg.sender);
195             payeePartsToSell = payeePartsToSell.sub(_payeePercentage);
196             payeePartsLeft = payeePartsLeft.sub(_payeePercentage);
197             payees.push(Payee(tx.origin, _payeePercentage));
198             emit PayeeAdded(tx.origin, _payeePercentage);
199         } else revert();
200     } 
201     
202     function setPartsToSell(uint256 _parts, uint256 _price) public onlyOwner {
203         require(payeePartsLeft >= _parts);
204         payeePartsToSell = _parts;
205         payeePricePerPart = _price;
206     }
207     
208     function etherPayout() public {
209         require(processingPayout == false);
210         processingPayout = true;
211         uint256 receivedValue = address(this).balance;
212         uint counter = 0;
213         for (uint i = 0; i < payees.length; i++) {
214            Payee memory myPayee = payees[i];
215            myPayee.payee.transfer((receivedValue.mul(myPayee.payeePercentage).div(100)));
216            emit EtherPayout(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100), "Shareholder");
217             counter++;
218           }
219         if(address(this).balance > 0) {
220             _owner.transfer(address(this).balance);
221             emit EtherPayout(_owner, address(this).balance, "Owner");
222         }
223         processingPayout = false;
224     }
225     
226      function tokenPayout() public payable {
227         require(processingPayout == false);
228         require(tokenContract.balanceOf(address(this)) >= lockedToken.add((minTokenTransfer.mul(10 ** tokenContract.decimals()))));
229         processingPayout = true;
230         uint256 receivedValue = tokenContract.balanceOf(address(this)).sub(lockedToken);
231         uint counter = 0;
232         for (uint i = 0; i < payees.length; i++) {
233            Payee memory myPayee = payees[i];
234            tokenContract.transfer(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100));
235            emit TokenPayout(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100), "Shareholder");
236             counter++;
237           } 
238         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 0) {
239             tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)).sub(lockedToken));
240             emit TokenPayout(_owner, tokenContract.balanceOf(address(this)).sub(lockedToken), "Owner");
241         }
242         processingPayout = false;
243     }
244     
245     function payoutLockedToken() public payable onlyOwner {
246         require(processingPayout == false);
247         require(now > lockedTokenTime);
248         require(tokenContract.balanceOf(address(this)) >= lockedToken);
249         lockedToken = 0;
250         if (address(this).balance > 0) {
251           etherPayout();
252         }
253         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 1) {
254           tokenPayout();
255         }
256         processingPayout = true;
257         emit LockedTokensUnlocked();
258         tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)));
259         processingPayout = false;
260     }
261     
262     function() external payable {
263     }
264 }
265 
266 contract ShareManager is Ownable{
267     using SafeMath for uint256;
268 
269     IERC20Token public tokenContract;
270     
271     struct Share {
272         address payable share;
273         uint sharePercentage;
274     }
275     
276     Share[] public shares;
277     
278     mapping (uint => address) public sharesToManager;
279     mapping (address => uint) ownerShareCount;
280     
281     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
282     
283     bool processingPayout = false;
284     bool processingShare = false;
285     
286     PayeeShare payeeShareContract;
287     
288     uint256 public sharesMaxLength;
289     uint256 public sharesSold;
290     uint256 public percentagePerShare;
291     uint256 public tokenPerShare;
292     uint256 public tokenLockDays;
293     address payable ownerAddress;
294     
295     event TokenPayout(address receiver, uint256 value, string memberOf);
296     event EtherPayout(address receiver, uint256 value, string memberOf);
297     event ShareSigned(address shareOwner, address shareContract, uint256 lockTime);
298     
299     constructor(address _tokenContract, uint256 _tokenPerShare, address payable _contractOwner, uint _ownerPercentage, uint _percentagePerShare) public {
300         tokenContract = IERC20Token(_tokenContract);
301         shares.push(Share(_contractOwner, _ownerPercentage));
302         sharesMaxLength = (uint256(100).sub(_ownerPercentage)).div(_percentagePerShare);
303         percentagePerShare = _percentagePerShare;
304         tokenPerShare = _tokenPerShare;
305         ownerAddress = _owner;
306         tokenLockDays = 100;
307     }
308     
309     function tokenPayout() public payable {
310         require(processingPayout == false);
311         require(tokenContract.balanceOf(address(this)) >= uint256(1).mul(10 ** tokenContract.decimals()));
312         processingPayout = true;
313         uint256 receivedValue = tokenContract.balanceOf(address(this));
314         uint counter = 0;
315         for (uint i = 0; i < shares.length; i++) {
316            Share memory myShare = shares[i];
317            if (i > 0) {
318                payeeShareContract = PayeeShare(myShare.share);
319                if (payeeShareContract.getLockedToken() == tokenPerShare.mul(10 ** tokenContract.decimals())) {
320                  tokenContract.transfer(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100));
321                  emit TokenPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Shareholder");
322                }
323            } else {
324                tokenContract.transfer(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100));
325                emit TokenPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Owner");
326            }
327            
328             counter++;
329           } 
330         if(tokenContract.balanceOf(address(this)) > 0) {
331             tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)));
332             emit TokenPayout(_owner, tokenContract.balanceOf(address(this)), "Owner - left from shares");
333         }
334         processingPayout = false;
335     }
336     
337     function etherPayout() public payable {
338         require(address(this).balance > uint256(1).mul(10 ** 18).div(100));
339         require(processingPayout == false);
340         processingPayout = true;
341         uint256 receivedValue = address(this).balance;
342         uint counter = 0;
343         for (uint i = 0; i < shares.length; i++) {
344            Share memory myShare = shares[i];
345            if (i > 0) {
346            payeeShareContract = PayeeShare(myShare.share);
347                if (payeeShareContract.getLockedToken() == tokenPerShare.mul(10 ** tokenContract.decimals())) {
348                  myShare.share.transfer((receivedValue.mul(myShare.sharePercentage).div(100)));
349                  emit EtherPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Shareholder");
350                }
351            } else {
352                myShare.share.transfer((receivedValue.mul(myShare.sharePercentage).div(100)));
353                emit EtherPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Owner");
354            }
355             counter++;
356           }
357         if(address(this).balance > 0) {
358             _owner.transfer(address(this).balance);
359             emit EtherPayout(_owner, address(this).balance, "Owner - left from shares");
360         }
361         processingPayout = false;
362     }
363     function() external payable {
364      
365     }
366     
367     function newShare() public payable returns (address) {
368         require(shares.length <= sharesMaxLength);
369         require(tokenContract.balanceOf(msg.sender) >= tokenPerShare.mul((10 ** tokenContract.decimals())));
370         if (address(this).balance > uint256(1).mul(10 ** 18).div(100)) {
371             etherPayout();
372         }
373         if (tokenContract.balanceOf(address(this)) >= uint256(1).mul(10 ** tokenContract.decimals())) {
374             tokenPayout();
375         }
376         require(processingShare == false);
377         uint256 lockedUntil = now.add((tokenLockDays).mul(1 days));
378         processingShare = true;
379         PayeeShare c = (new PayeeShare)(address(tokenContract), tokenPerShare.mul(10 ** tokenContract.decimals()), lockedUntil); 
380         require(tokenContract.transferFrom(msg.sender, address(c), tokenPerShare.mul(10 ** tokenContract.decimals())));
381         uint id = shares.push(Share(address(c), percentagePerShare)).sub(1);
382         sharesToManager[id] = msg.sender;
383         ownerShareCount[msg.sender] = ownerShareCount[msg.sender].add(1);
384         emit ShareSigned(msg.sender, address(c), lockedUntil);
385         if (tokenLockDays > 0) {
386         tokenLockDays = tokenLockDays.sub(1);
387         }
388         sharesSold = sharesSold.add(1);
389         processingShare = false;
390         return address(c);
391     }
392     
393     function getSharesByShareOwner(address _shareOwner) external view returns (uint[] memory) {
394     uint[] memory result = new uint[](ownerShareCount[_shareOwner]);
395     uint counter = 0;
396     for (uint i = 0; i < shares.length; i++) {
397       if (sharesToManager[i] == _shareOwner) {
398         result[counter] = i;
399         counter++;
400       }
401     }
402     return result;
403   }
404   
405 }
406 
407 contract AssetSplitShare is Ownable {
408         struct AssetFactory {
409         address contractAddress;
410         address contractCreator;
411         string contractType;
412     }
413     
414     AssetFactory[] public contracts;
415     
416     mapping (uint => address) public contractToOwner;
417     mapping (uint => address) public contractToContract;
418     
419     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
420     
421     IERC20Token public tokenContract;
422     
423     event ContractCreated(address contractAddress, address contractCreator, string contractType);
424     
425     uint256 priceInEther = 3 ether;
426     uint256 shareManagerPrice = 15;
427 
428     using SafeMath for uint256;
429     
430     constructor(address _tokenContract) public {
431         tokenContract = IERC20Token(_tokenContract);
432     }
433     
434  /*
435     function purchaseShareContract(address _tokenContractAddress) public payable returns (address) {
436         if (msg.value >= priceInEther) {
437             address c = newShare(_tokenContractAddress);
438             _owner.transfer(address(this).balance);
439             return c;
440         } else {
441             require(tokenContract.balanceOf(msg.sender) >= shareContractPrice.mul(10 ** tokenContract.decimals()));
442             require(tokenContract.transferFrom(msg.sender, _owner, shareContractPrice.mul(10 ** tokenContract.decimals())));
443             address c = newShare(_tokenContractAddress);
444             return address(c);
445         }
446     }
447     */
448     function purchaseShareManager(address _tokenContract, uint256 _pricePerShare, address payable _contractOwner, uint _ownerPercentage, uint _percentagePerShare) public payable returns (address) {
449         if (msg.value >= priceInEther) {
450             address c = newShareManager(_tokenContract, _pricePerShare, _contractOwner, _ownerPercentage, _percentagePerShare);
451             _owner.transfer(address(this).balance);
452             return address(c);
453         } else {
454             require(tokenContract.balanceOf(msg.sender) >= shareManagerPrice.mul(10 ** tokenContract.decimals()));
455             require(tokenContract.transferFrom(msg.sender, _owner, shareManagerPrice.mul(10 ** tokenContract.decimals())));
456             address c = newShareManager(_tokenContract, _pricePerShare, _contractOwner, _ownerPercentage, _percentagePerShare);
457             return address(c);
458         }
459         
460     }
461 
462     function newShareManager(address _tokenContract, uint256 _pricePerShare, address payable _contractOwner, uint _ownerPercentage, uint _percentagePerShare) internal returns (address) {
463         ShareManager c = (new ShareManager)(_tokenContract, _pricePerShare, _contractOwner, _ownerPercentage, _percentagePerShare);
464         uint id = contracts.push(AssetFactory(address(c), tx.origin, "ShareManager")).sub(1);
465         contractToOwner[id] = tx.origin;
466         emit ContractCreated(address(c), tx.origin, "ShareManager");
467         return address(c);
468     }
469    
470     function newShare(address _tokenContractAddress) internal returns (address) {
471         PayeeShare c = (new PayeeShare)(_tokenContractAddress, 0, 0);
472         uint id = contracts.push(AssetFactory(address(c), tx.origin, "Share")).sub(1);
473         contractToContract[id] = msg.sender;
474         emit ContractCreated(address(c), tx.origin, "Share");
475         return address(c);
476     } 
477     
478     function() external payable {
479         
480     } 
481 }