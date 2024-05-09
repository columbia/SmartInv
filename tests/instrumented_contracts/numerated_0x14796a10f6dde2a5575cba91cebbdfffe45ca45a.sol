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
163     function getPayeeLenght() public view returns (uint256) {
164         return payees.length;
165     }
166     
167      function getLockedToken() public view returns (uint256) {
168         return lockedToken;
169     }
170     
171     function addPayee(address payable _address, uint _payeePercentage) public payable {
172         if (msg.sender == _owner) {
173         require(payeePartsLeft >= _payeePercentage);
174         payeePartsLeft = payeePartsLeft.sub(_payeePercentage);
175         payees.push(Payee(_address, _payeePercentage));
176         emit PayeeAdded(_address, _payeePercentage);
177         }
178         else if (msg.value == _payeePercentage.mul(payeePricePerPart)) {
179         if (address(this).balance > 0) {
180           etherPayout();
181         }
182         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 1) {
183           tokenPayout();
184         }
185             require(payeePartsLeft >= _payeePercentage);
186             require(payeePartsToSell >= _payeePercentage);
187             require(tx.origin == msg.sender);
188             payeePartsToSell = payeePartsToSell.sub(_payeePercentage);
189             payeePartsLeft = payeePartsLeft.sub(_payeePercentage);
190             payees.push(Payee(tx.origin, _payeePercentage));
191             emit PayeeAdded(tx.origin, _payeePercentage);
192         } else revert();
193     } 
194     
195     function setPartsToSell(uint256 _parts, uint256 _price) public onlyOwner {
196         require(payeePartsLeft >= _parts);
197         payeePartsToSell = _parts;
198         payeePricePerPart = _price;
199     }
200     
201     function etherPayout() public {
202         require(processingPayout == false);
203         processingPayout = true;
204         uint256 receivedValue = address(this).balance;
205         uint counter = 0;
206         for (uint i = 0; i < payees.length; i++) {
207            Payee memory myPayee = payees[i];
208            myPayee.payee.transfer((receivedValue.mul(myPayee.payeePercentage).div(100)));
209            emit EtherPayout(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100), "Shareholder");
210             counter++;
211           }
212         if(address(this).balance > 0) {
213             _owner.transfer(address(this).balance);
214             emit EtherPayout(_owner, address(this).balance, "Owner");
215         }
216         processingPayout = false;
217     }
218     
219      function tokenPayout() public payable {
220         require(processingPayout == false);
221         require(tokenContract.balanceOf(address(this)) >= lockedToken.add((minTokenTransfer.mul(10 ** tokenContract.decimals()))));
222         processingPayout = true;
223         uint256 receivedValue = tokenContract.balanceOf(address(this)).sub(lockedToken);
224         uint counter = 0;
225         for (uint i = 0; i < payees.length; i++) {
226            Payee memory myPayee = payees[i];
227            tokenContract.transfer(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100));
228            emit TokenPayout(myPayee.payee, receivedValue.mul(myPayee.payeePercentage).div(100), "Shareholder");
229             counter++;
230           } 
231         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 0) {
232             tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)).sub(lockedToken));
233             emit TokenPayout(_owner, tokenContract.balanceOf(address(this)).sub(lockedToken), "Owner");
234         }
235         processingPayout = false;
236     }
237     
238     function payoutLockedToken() public payable onlyOwner {
239         require(processingPayout == false);
240         require(now > lockedTokenTime);
241         require(tokenContract.balanceOf(address(this)) >= lockedToken);
242         lockedToken = 0;
243         if (address(this).balance > 0) {
244           etherPayout();
245         }
246         if (tokenContract.balanceOf(address(this)).sub(lockedToken) > 1) {
247           tokenPayout();
248         }
249         processingPayout = true;
250         emit LockedTokensUnlocked();
251         tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)));
252         processingPayout = false;
253     }
254     
255     function() external payable {
256     }
257 }
258 
259 contract ShareManager is Ownable{
260     using SafeMath for uint256;
261 
262     IERC20Token public tokenContract;
263     
264     struct Share {
265         address payable share;
266         uint sharePercentage;
267     }
268     
269     Share[] public shares;
270     
271     mapping (uint => address) public sharesToManager;
272     mapping (address => uint) ownerShareCount;
273     
274     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
275     
276     bool processingPayout = false;
277     bool processingShare = false;
278     
279     PayeeShare payeeShareContract;
280     
281     uint256 public sharesMaxLength;
282     uint256 public sharesSold;
283     uint256 public percentagePerShare;
284     uint256 public tokenPerShare;
285     uint256 public tokenLockDays;
286     address payable ownerAddress;
287     
288     event TokenPayout(address receiver, uint256 value, string memberOf);
289     event EtherPayout(address receiver, uint256 value, string memberOf);
290     event ShareSigned(address shareOwner, address shareContract, uint256 lockTime);
291     
292     constructor(address _tokenContract, uint256 _tokenPerShare, address payable _contractOwner, uint _ownerPercentage, uint _percentagePerShare) public {
293         tokenContract = IERC20Token(_tokenContract);
294         shares.push(Share(_contractOwner, _ownerPercentage));
295         sharesMaxLength = (uint256(100).sub(_ownerPercentage)).div(_percentagePerShare);
296         percentagePerShare = _percentagePerShare;
297         tokenPerShare = _tokenPerShare;
298         ownerAddress = _owner;
299         tokenLockDays = 100;
300     }
301     
302     function tokenPayout() public payable {
303         require(processingPayout == false);
304         require(tokenContract.balanceOf(address(this)) >= uint256(1).mul(10 ** tokenContract.decimals()));
305         processingPayout = true;
306         uint256 receivedValue = tokenContract.balanceOf(address(this));
307         uint counter = 0;
308         for (uint i = 0; i < shares.length; i++) {
309            Share memory myShare = shares[i];
310            if (i > 0) {
311                payeeShareContract = PayeeShare(myShare.share);
312                if (payeeShareContract.getLockedToken() == tokenPerShare.mul(10 ** tokenContract.decimals())) {
313                  tokenContract.transfer(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100));
314                  emit TokenPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Shareholder");
315                }
316            } else {
317                tokenContract.transfer(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100));
318                emit TokenPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Owner");
319            }
320            
321             counter++;
322           } 
323         if(tokenContract.balanceOf(address(this)) > 0) {
324             tokenContract.transfer(_owner, tokenContract.balanceOf(address(this)));
325             emit TokenPayout(_owner, tokenContract.balanceOf(address(this)), "Owner - left from shares");
326         }
327         processingPayout = false;
328     }
329     
330     function etherPayout() public payable {
331         require(address(this).balance > uint256(1).mul(10 ** 18).div(100));
332         require(processingPayout == false);
333         processingPayout = true;
334         uint256 receivedValue = address(this).balance;
335         uint counter = 0;
336         for (uint i = 0; i < shares.length; i++) {
337            Share memory myShare = shares[i];
338            if (i > 0) {
339            payeeShareContract = PayeeShare(myShare.share);
340                if (payeeShareContract.getLockedToken() == tokenPerShare.mul(10 ** tokenContract.decimals())) {
341                  myShare.share.transfer((receivedValue.mul(myShare.sharePercentage).div(100)));
342                  emit EtherPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Shareholder");
343                }
344            } else {
345                myShare.share.transfer((receivedValue.mul(myShare.sharePercentage).div(100)));
346                emit EtherPayout(myShare.share, receivedValue.mul(myShare.sharePercentage).div(100), "Owner");
347            }
348             counter++;
349           }
350         if(address(this).balance > 0) {
351             _owner.transfer(address(this).balance);
352             emit EtherPayout(_owner, address(this).balance, "Owner - left from shares");
353         }
354         processingPayout = false;
355     }
356     function() external payable {
357      
358     }
359     
360     function newShare() public payable returns (address) {
361         require(shares.length <= sharesMaxLength);
362         require(tokenContract.balanceOf(msg.sender) >= tokenPerShare.mul((10 ** tokenContract.decimals())));
363         if (address(this).balance > uint256(1).mul(10 ** 18).div(100)) {
364             etherPayout();
365         }
366         if (tokenContract.balanceOf(address(this)) >= uint256(1).mul(10 ** tokenContract.decimals())) {
367             tokenPayout();
368         }
369         require(processingShare == false);
370         uint256 lockedUntil = now.add((tokenLockDays).mul(1 days));
371         processingShare = true;
372         PayeeShare c = (new PayeeShare)(address(tokenContract), tokenPerShare.mul(10 ** tokenContract.decimals()), lockedUntil); 
373         require(tokenContract.transferFrom(msg.sender, address(c), tokenPerShare.mul(10 ** tokenContract.decimals())));
374         uint id = shares.push(Share(address(c), percentagePerShare)).sub(1);
375         sharesToManager[id] = msg.sender;
376         ownerShareCount[msg.sender] = ownerShareCount[msg.sender].add(1);
377         emit ShareSigned(msg.sender, address(c), lockedUntil);
378         if (tokenLockDays > 0) {
379         tokenLockDays = tokenLockDays.sub(1);
380         }
381         sharesSold = sharesSold.add(1);
382         processingShare = false;
383         return address(c);
384     }
385     
386     function getSharesByShareOwner(address _shareOwner) external view returns (uint[] memory) {
387     uint[] memory result = new uint[](ownerShareCount[_shareOwner]);
388     uint counter = 0;
389     for (uint i = 0; i < shares.length; i++) {
390       if (sharesToManager[i] == _shareOwner) {
391         result[counter] = i;
392         counter++;
393       }
394     }
395     return result;
396   }
397   
398 }