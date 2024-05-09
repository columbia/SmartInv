1 // CryptoGods Copyright (c) 2018. All rights reserved.
2 
3 pragma solidity ^0.4.20;
4 
5 library SafeMath {
6     function add(uint x, uint y) internal pure returns (uint z) {
7         require((z = x + y) >= x);
8     }
9     function sub(uint x, uint y) internal pure returns (uint z) {
10         require((z = x - y) <= x);
11     }
12     function mul(uint x, uint y) internal pure returns (uint z) {
13         require(y == 0 || (z = x * y) / y == x);
14     }
15 }
16 contract Owned {
17     address public ceoAddress;
18     address public cooAddress;
19     address private newCeoAddress;
20     address private newCooAddress;
21     function Owned() public {
22         ceoAddress = msg.sender;
23         cooAddress = msg.sender;
24     }
25     modifier onlyCEO() {
26         require(msg.sender == ceoAddress);
27         _;
28     }
29     modifier onlyCOO() {
30         require(msg.sender == cooAddress);
31         _;
32     }
33     modifier onlyCLevel() {
34         require(
35             msg.sender == ceoAddress ||
36             msg.sender == cooAddress
37         );
38         _;
39     }
40     function setCEO(address _newCEO) public onlyCEO {
41         require(_newCEO != address(0));
42         newCeoAddress = _newCEO;
43     }
44     function setCOO(address _newCOO) public onlyCEO {
45         require(_newCOO != address(0));
46         newCooAddress = _newCOO;
47     }
48     function acceptCeoOwnership() public {
49         require(msg.sender == newCeoAddress);
50         require(address(0) != newCeoAddress);
51         ceoAddress = newCeoAddress;
52         newCeoAddress = address(0);
53     }
54     function acceptCooOwnership() public {
55         require(msg.sender == newCooAddress);
56         require(address(0) != newCooAddress);
57         cooAddress = newCooAddress;
58         newCooAddress = address(0);
59     }
60 }
61 contract ERC20Interface {
62     function totalSupply() public constant returns (uint);
63     function balanceOf(address tokenOwner) public constant returns (uint balance);
64     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 contract ApproveAndCallFallBack {
73     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
74 }
75 contract ERC20 is ERC20Interface, Owned {
76     using SafeMath for uint;
77 
78     string public constant symbol = "GPC";
79     string public constant name = "God Power Coin";
80     uint8 public constant decimals = 18;
81     uint constant WAD = 10 ** 18;
82     uint public _totalSupply = (10 ** 9) * WAD;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86     
87     function totalSupply() public constant returns (uint) {
88         return _totalSupply  - balances[address(0)];
89     }
90     function balanceOf(address tokenOwner) public constant returns (uint balance) {
91         return balances[tokenOwner];
92     }
93     function transfer(address to, uint tokens) public returns (bool success) {
94         balances[msg.sender] = balances[msg.sender].sub(tokens);
95         balances[to] = balances[to].add(tokens);
96         Transfer(msg.sender, to, tokens);
97         return true;
98     }
99     function approve(address spender, uint tokens) public returns (bool success) {
100         allowed[msg.sender][spender] = tokens;
101         Approval(msg.sender, spender, tokens);
102         return true;
103     }
104     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
105         balances[from] = balances[from].sub(tokens);
106         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
107         balances[to] = balances[to].add(tokens);
108         Transfer(from, to, tokens);
109         return true;
110     }
111     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
112         return allowed[tokenOwner][spender];
113     }
114     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         Approval(msg.sender, spender, tokens);
117         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
118         return true;
119     }
120     function () public payable {
121         revert();
122     }
123     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyCLevel returns (bool success) {
124         return ERC20Interface(tokenAddress).transfer(ceoAddress, tokens);
125     }
126     
127     // Payout
128     function payout(uint amount) public onlyCLevel {
129         if (amount > this.balance)
130             amount = this.balance;
131         ceoAddress.transfer(amount);
132     }
133 }
134 
135 contract ERC721 is ERC20 {
136 
137     function _addressNotNull(address _to) private pure returns(bool) {
138         return _to != address(0);
139     }
140     function _approved(address _to, uint _tokenId) private view returns(bool) {
141         return token[_tokenId].approved == _to;
142     }
143     function _ownsToken(address user, uint _tokenId) public view returns(bool) {
144         return user == token[_tokenId].owner;
145     }
146     function _transferToken(address _from, address _to, uint _tokenId) internal {
147         token[_tokenId].owner = _to;
148         token[_tokenId].approved = address(0);
149         TransferToken(_from, _to, _tokenId);
150     }
151 
152     uint[] public tokenList;
153     
154     struct TOKEN {
155         
156         address owner;
157         address approved;
158         
159         uint price;
160         uint lastPrice;
161         
162         uint mSpeed;
163 
164         uint mLastPayoutBlock;
165     }
166 
167     mapping(uint => TOKEN) public token;
168     
169     event Birth(uint indexed tokenId, uint startPrice);
170     event TokenSold(uint indexed tokenId, uint price, address indexed prevOwner, address indexed winner);
171     event TransferToken(address indexed from, address indexed to, uint indexed tokenId);
172     event ApprovalToken(address indexed owner, address indexed approved, uint indexed tokenId);
173     
174     function approveToken(address _to, uint _tokenId) public {
175         require(_ownsToken(msg.sender, _tokenId));
176         token[_tokenId].approved = _to;
177         ApprovalToken(msg.sender, _to, _tokenId);
178     }
179     function getTotalTokenSupply() public view returns(uint) {
180         return tokenList.length;
181     }
182     function ownerOf(uint _tokenId) public view returns (address owner) {
183         owner = token[_tokenId].owner;
184     }
185     function priceOf(uint _tokenId) public view returns (uint price) {
186         price = token[_tokenId].price;
187     }
188     function takeOwnership(uint _tokenId) public {
189         address newOwner = msg.sender;
190         address oldOwner = token[_tokenId].owner;
191 
192         require(_addressNotNull(newOwner));
193         require(_approved(newOwner, _tokenId));
194 
195         _transferToken(oldOwner, newOwner, _tokenId);
196     }
197     function transferToken(address _to, uint _tokenId) public {
198         require(_ownsToken(msg.sender, _tokenId));
199         require(_addressNotNull(_to));
200         _transferToken(msg.sender, _to, _tokenId);
201     }
202     function transferTokenFrom(address _from, address _to, uint _tokenId) public {
203         require(_ownsToken(_from, _tokenId));
204         require(_approved(_to, _tokenId));
205         require(_addressNotNull(_to));
206         _transferToken(_from, _to, _tokenId);
207     }
208     function tokenBalanceOf(address _owner) public view returns(uint result) {
209         uint totalTokens = tokenList.length;
210         uint tokenIndex;
211         uint tokenId;
212         result = 0;
213         for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
214             tokenId = tokenList[tokenIndex];
215             if (token[tokenId].owner == _owner) {
216                 result = result.add(1);
217             }
218         }
219         return result;
220     }
221     function tokensOfOwner(address _owner) public view returns(uint[] ownerTokens) {
222         uint tokenCount = tokenBalanceOf(_owner);
223         
224         if (tokenCount == 0) return new uint[](0);
225 
226         uint[] memory result = new uint[](tokenCount);
227         uint totalTokens = tokenList.length;
228         uint resultIndex = 0;
229         uint tokenIndex;
230         uint tokenId;
231         
232         for (tokenIndex = 0; tokenIndex < totalTokens; tokenIndex++) {
233             tokenId = tokenList[tokenIndex];
234             if (token[tokenId].owner == _owner) {
235                 result[resultIndex] = tokenId;
236                 resultIndex = resultIndex.add(1);
237             }
238         }
239         return result;
240     }
241     function getTokenIds() public view returns(uint[]) {
242         return tokenList;
243     }
244 
245     // MIN(A * PRICE, MAX(B * PRICE, 100*PRICE + C)) / 100
246     
247     uint public priceFactorA = 200;
248     uint public priceFactorB = 120;
249     uint public priceFactorC = 16 * (10**18);
250     
251     function changePriceFactor(uint a_, uint b_, uint c_) public onlyCLevel {
252         priceFactorA = a_;
253         priceFactorB = b_;
254         priceFactorC = c_;
255     }
256     
257     function getMaxPrice(uint _tokenId) public view returns (uint) {
258         uint price = token[_tokenId].lastPrice.mul(priceFactorB);
259         uint priceLow = token[_tokenId].lastPrice.mul(100).add(priceFactorC);
260         uint priceHigh = token[_tokenId].lastPrice.mul(priceFactorA);
261         if (price < priceLow)
262             price = priceLow;
263         if (price > priceHigh)
264             price = priceHigh;
265             
266         price = price / (10**18);
267         price = price.mul(10**16); // round to x.xx ETH
268         
269         return price;
270     }
271     
272     function changeTokenPrice(uint newPrice, uint _tokenId) public {
273         require(
274             (_ownsToken(msg.sender, _tokenId))
275             || 
276             ((_ownsToken(address(0), _tokenId)) && ((msg.sender == ceoAddress) || (msg.sender == cooAddress)))
277         );
278         
279         newPrice = newPrice / (10**16);
280         newPrice = newPrice.mul(10**16); // round to x.xx ETH
281         
282         require(newPrice > 0);
283 
284         require(newPrice <= getMaxPrice(_tokenId));
285         token[_tokenId].price = newPrice;
286     }
287 }
288 
289 contract GodPowerCoin is ERC721 {
290     
291     function GodPowerCoin() public {
292         balances[msg.sender] = _totalSupply;
293         Transfer(address(0), msg.sender, _totalSupply);
294     }
295     
296     uint public divCutPool = 0;
297     uint public divCutMaster = 10; // to master card
298     uint public divCutAdmin = 30;
299     
300     uint public divPoolAmt = 0;
301     uint public divMasterAmt = 0;
302     
303     mapping(address => uint) public dividend;
304     
305     function withdrawDividend() public {
306         require(dividend[msg.sender] > 0);
307         msg.sender.transfer(dividend[msg.sender]);
308         dividend[msg.sender] = 0;
309     }
310     
311     function setCut(uint admin_, uint pool_, uint master_) public onlyCLevel {
312         divCutAdmin = admin_;
313         divCutPool = pool_;
314         divCutMaster = master_;
315     }
316     
317     function purchase(uint _tokenId, uint _newPrice) public payable {
318         address oldOwner = token[_tokenId].owner;
319         uint sellingPrice = token[_tokenId].price;
320         
321         require(oldOwner != msg.sender);
322         require(msg.sender != address(0));
323 
324         require(sellingPrice > 0); // can't purchase unreleased token
325 
326         require(msg.value >= sellingPrice);
327         uint purchaseExcess = msg.value.sub(sellingPrice);
328 
329         payoutMining(_tokenId); // must happen before owner change!!
330 
331         uint payment = sellingPrice.mul(1000 - divCutPool - divCutAdmin - divCutMaster) / 1000;
332         if (divCutPool > 0)
333             divPoolAmt = divPoolAmt.add(sellingPrice.mul(divCutPool) / 1000);
334         
335         divMasterAmt = divMasterAmt.add(sellingPrice.mul(divCutMaster) / 1000);
336         
337         token[_tokenId].lastPrice = sellingPrice;
338 
339         uint maxPrice = getMaxPrice(_tokenId);
340         if ((_newPrice > maxPrice) || (_newPrice == 0))
341             _newPrice = maxPrice;
342             
343         token[_tokenId].price = _newPrice;
344 
345         _transferToken(oldOwner, msg.sender, _tokenId);
346         
347         if (_tokenId % 10000 > 0) {
348             address MASTER = token[(_tokenId / 10000).mul(10000)].owner;
349             dividend[MASTER] = dividend[MASTER].add(sellingPrice.mul(divCutMaster) / 1000);
350         }
351         
352         oldOwner.transfer(payment);
353 
354         if (purchaseExcess > 0)
355             msg.sender.transfer(purchaseExcess);
356 
357         TokenSold(_tokenId, sellingPrice, oldOwner, msg.sender);
358     }
359     
360     function _createToken(uint tokenId, uint _price, address _owner, uint _mBaseSpeed) internal {
361         
362         token[tokenId].owner = _owner;
363         token[tokenId].price = _price;
364         token[tokenId].lastPrice = _price;
365         
366         token[tokenId].mSpeed = _mBaseSpeed;
367 
368         token[tokenId].mLastPayoutBlock = block.number;
369         
370         mSumRawSpeed = mSumRawSpeed.add(getMiningRawSpeed(tokenId));
371         
372         Birth(tokenId, _price);
373         tokenList.push(tokenId);
374     }
375     function createToken(uint tokenId, uint _price, address _owner, uint _mBaseSpeed) public onlyCLevel {
376         require(_price != 0);
377         if (_owner == address(0))
378             _owner = ceoAddress;
379 
380         require(token[tokenId].price == 0);
381         _createToken(tokenId, _price, _owner, _mBaseSpeed);
382         TransferToken(0, _owner, tokenId);
383     }
384     function createSimilarTokens(uint[] tokenId, uint _price, address _owner, uint _mBaseSpeed) public onlyCLevel {
385         require(_price != 0);
386         if (_owner == address(0))
387             _owner = ceoAddress;
388 
389         for (uint i = 0; i < tokenId.length; i++) {
390             require(token[tokenId[i]].price == 0);
391             _createToken(tokenId[i], _price, _owner, _mBaseSpeed);
392             TransferToken(0, _owner, tokenId[i]);
393         }
394     }
395     function createMultipleTokens(uint[] tokenId, uint[] _price, address _owner, uint[] _mBaseSpeed) public onlyCLevel {
396         if (_owner == address(0))
397             _owner = ceoAddress;
398 
399         for (uint i = 0; i < tokenId.length; i++) {
400             require(_price[i] != 0);
401             require(token[tokenId[i]].price == 0);
402             _createToken(tokenId[i], _price[i], _owner, _mBaseSpeed[i]);
403             TransferToken(0, _owner, tokenId[i]);
404         }
405     }
406     
407     event MiningUpgrade(address indexed sender, uint indexed token, uint newLevelSpeed);
408 
409     // ETH: 6000 blocks per day, 5 ETH per block
410     
411     uint public mSumRawSpeed = 0;
412 
413     uint public mCoinPerBlock = 50;
414     
415     uint public mUpgradeCostFactor = mCoinPerBlock * 6000 * WAD;
416     uint public mUpgradeSpeedup = 1040; // = * 1.04
417     
418     function adminSetMining(uint mCoinPerBlock_, uint mUpgradeCostFactor_, uint mUpgradeSpeedup_) public onlyCLevel {
419         mCoinPerBlock = mCoinPerBlock_;
420         mUpgradeCostFactor = mUpgradeCostFactor_;
421         mUpgradeSpeedup = mUpgradeSpeedup_;
422     }
423     
424     function getMiningRawSpeed(uint id) public view returns (uint) {
425         return token[id].mSpeed;
426     }
427     function getMiningRealSpeed(uint id) public view returns (uint) {
428         return getMiningRawSpeed(id).mul(mCoinPerBlock) / mSumRawSpeed;
429     }
430     function getMiningUpgradeCost(uint id) public view returns (uint) {
431         return getMiningRawSpeed(id).mul(mUpgradeCostFactor) / mSumRawSpeed;
432     }
433     function upgradeMining(uint id) public {
434         uint cost = getMiningUpgradeCost(id);
435         balances[msg.sender] = balances[msg.sender].sub(cost);
436         _totalSupply = _totalSupply.sub(cost);
437         
438         mSumRawSpeed = mSumRawSpeed.sub(getMiningRawSpeed(id));
439         token[id].mSpeed = token[id].mSpeed.mul(mUpgradeSpeedup) / 1000;
440         mSumRawSpeed = mSumRawSpeed.add(getMiningRawSpeed(id));
441         
442         MiningUpgrade(msg.sender, id, token[id].mSpeed);
443     }
444     function upgradeMiningMultipleTimes(uint id, uint n) public {
445         for (uint i = 0; i < n; i++) {
446             uint cost = getMiningUpgradeCost(id);
447             balances[msg.sender] = balances[msg.sender].sub(cost);
448             _totalSupply = _totalSupply.sub(cost);
449         
450             mSumRawSpeed = mSumRawSpeed.sub(getMiningRawSpeed(id));
451             token[id].mSpeed = token[id].mSpeed.mul(mUpgradeSpeedup) / 1000;
452             mSumRawSpeed = mSumRawSpeed.add(getMiningRawSpeed(id));
453         }
454         MiningUpgrade(msg.sender, id, token[id].mSpeed);
455     }
456     function payoutMiningAll(address owner, uint[] list) public {
457         uint sum = 0;
458         for (uint i = 0; i < list.length; i++) {
459             uint id = list[i];
460             require(token[id].owner == owner);
461             uint blocks = block.number.sub(token[id].mLastPayoutBlock);
462             token[id].mLastPayoutBlock = block.number;
463             sum = sum.add(getMiningRawSpeed(id).mul(mCoinPerBlock).mul(blocks).mul(WAD) / mSumRawSpeed); // mul WAD !
464         }
465         balances[owner] = balances[owner].add(sum);
466         _totalSupply = _totalSupply.add(sum);
467     }
468     function payoutMining(uint id) public {
469         require(token[id].mLastPayoutBlock > 0);
470         uint blocks = block.number.sub(token[id].mLastPayoutBlock);
471         token[id].mLastPayoutBlock = block.number;
472         address owner = token[id].owner;
473         uint coinsMined = getMiningRawSpeed(id).mul(mCoinPerBlock).mul(blocks).mul(WAD) / mSumRawSpeed; // mul WAD !
474         
475         balances[owner] = balances[owner].add(coinsMined);
476         _totalSupply = _totalSupply.add(coinsMined);
477     }
478 }