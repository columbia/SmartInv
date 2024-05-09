1 pragma solidity ^0.4.24;
2 
3 //==============================================================================
4 // struct
5 //==============================================================================
6 library ArtChainData {
7     struct ArtItem {
8         uint256 id;
9         uint256 price;
10         uint256 lastTransPrice;
11         address owner;
12         uint256 buyYibPrice;
13         uint256 buyTime;
14         uint256 annualRate;
15         uint256 lockDuration;
16         bool isExist;
17     }
18 
19     struct Player {
20         uint256 id;     // player id
21         address addr;   // player address
22         bytes32 name;   // player name
23         uint256 laffId;   // affiliate id
24 
25         uint256[] ownItemIds;
26     }
27 }
28 
29 contract ArtChainEvents {
30     // event onNewPlayer
31     // (
32     //     uint256 indexed playerID,
33     //     address indexed playerAddress,
34     //     bytes32 indexed playerName,
35     //     uint256 affiliateID,
36     //     address affiliateAddress,
37     //     uint256 timeStamp
38     // );
39 
40     event onTransferItem
41     (
42         address from,
43         address to,
44         uint256 itemId,
45         uint256 price,
46         uint256 yibPrice,
47         uint256 timeStamp
48     );
49 }
50 
51 contract ArtChain is ArtChainEvents {
52     using SafeMath for *;
53     using NameFilter for string;
54 
55     YbTokenInterface private YbTokenContract = YbTokenInterface(0x71F04062E5794e0190fDca9A2bF1F196C41C3e6e);
56 
57     //****************
58     // constant
59     //****************
60     address private ceo;
61     
62     string constant public name = "artChain";
63     string constant public symbol = "artChain";  
64 
65     //****************
66     // var
67     //****************
68     address private coo;
69 
70     bool public paused = false;
71 
72 //    uint256 public priceGainPercentPerYear = 8;
73 
74     uint256 public affPercentCut = 3;  
75 
76     uint256 pIdCount = 0;
77 
78     //****************
79     // DATA MAP
80     //****************
81     mapping(uint256 => ArtChainData.ArtItem) public artItemMap;
82     uint256[] public itemIds;
83 
84     mapping (address => uint256) public pIDxAddr;          
85     mapping (uint256 => ArtChainData.Player) public playerMap;    
86 
87     //==============================================================================
88     // init
89     //==============================================================================
90     constructor() public {
91         ceo = msg.sender;
92 
93         pIdCount++;
94         playerMap[pIdCount].id = pIdCount;
95         playerMap[pIdCount].addr = 0xe27c188521248a49adfc61090d3c8ab7c3754e0a;
96         playerMap[pIdCount].name = "matt";
97         pIDxAddr[0xe27c188521248a49adfc61090d3c8ab7c3754e0a] = pIdCount;
98     }
99 
100     //==============================================================================
101     // checks
102     //==============================================================================
103     modifier onlyCeo() {
104         require(msg.sender == ceo,"msg sender is not ceo");
105         _;
106     }
107 
108     modifier onlyCoo() {
109         require(msg.sender == coo,"msg sender is not coo");
110         _;
111     }
112 
113     modifier onlyCLevel() {
114         require(
115             msg.sender == coo || msg.sender == ceo
116             ,"msg sender is not c level"
117         );
118         _;
119     }
120 
121     modifier whenNotPaused() {
122         require(!paused);
123         _;
124     }
125 
126     modifier whenPaused {
127         require(paused);
128         _;
129     }
130 
131     modifier isHuman() {
132         address _addr = msg.sender;
133         uint256 _codeLength;
134 
135         assembly {_codeLength := extcodesize(_addr)}
136         require(_codeLength == 0, "sorry humans only");
137         _;
138     }
139 
140     //==============================================================================
141     // admin
142     //==============================================================================
143     function pause() public onlyCLevel whenNotPaused {
144         paused = true;
145     }
146 
147     function unpause() public onlyCeo whenPaused {
148         paused = false;
149     }
150 
151     function transferYbToNewContract(address _newAddr, uint256 _yibBalance) public onlyCeo {
152         bool _isSuccess = YbTokenContract.transfer(_newAddr, _yibBalance);
153     }
154 
155     function setYbContract(address _newAddr) public onlyCeo {
156         YbTokenContract = YbTokenInterface(_newAddr);
157     }
158 
159     function setCoo(address _newCoo) public onlyCeo {
160         require(_newCoo != address(0));
161         coo = _newCoo;
162     }
163 
164 //    function setPriceGainRate(uint256 _newRate) public onlyCLevel {
165 //        priceGainPercentPerYear = _newRate;
166 //    }
167 
168     function addNewItem(uint256 _tokenId, uint256 _price, uint256 _annualRate, uint256 _lockDuration) public onlyCLevel {
169         require(artItemMap[_tokenId].isExist == false);
170 
171         ArtChainData.ArtItem memory _item = ArtChainData.ArtItem({
172             id: _tokenId,
173             price: _price,
174             lastTransPrice: 0,
175             buyYibPrice: 0,
176             buyTime: 0,
177             annualRate: _annualRate,
178             lockDuration: _lockDuration.mul(4 weeks),
179             owner: this,
180             isExist: true
181         });
182         itemIds.push(_tokenId);
183 
184         artItemMap[_tokenId] = _item;
185     }
186 
187     function deleteItem(uint256 _tokenId) public onlyCLevel {
188         require(artItemMap[_tokenId].isExist, "item not exist");
189 
190         for(uint256 i = 0; i < itemIds.length; i++) {
191             if(itemIds[i] == _tokenId) {
192                 itemIds[i] = itemIds[itemIds.length - 1];
193                 break;
194             }
195         }
196         itemIds.length --;
197         delete artItemMap[_tokenId];
198     }
199 
200     function setItemPrice(uint256 _tokenId, uint256 _price) public onlyCLevel {
201         require(artItemMap[_tokenId].isExist == true);
202         //require(isItemSell(_tokenId) == false);
203         
204         artItemMap[_tokenId].price = _price;
205     }
206 
207     function setItemAnnualRate(uint256 _tokenId, uint256 _annualRate) public onlyCLevel {
208         require(artItemMap[_tokenId].isExist == true);
209         //require(isItemSell(_tokenId) == false);
210 
211         artItemMap[_tokenId].annualRate = _annualRate;
212     }
213 
214     function setItemLockDuration(uint256 _tokenId, uint256 _lockDuration) public onlyCLevel {
215         require(artItemMap[_tokenId].isExist == true);
216         //require(isItemSell(_tokenId) == false);
217 
218         artItemMap[_tokenId].lockDuration = _lockDuration.mul(4 weeks);
219     }
220 
221 //    function updateSellItemPriceDaily() public onlyCLevel {
222 //        for(uint256 i = 0; i < itemIds.length; i++) {
223 //            if(isItemSell(itemIds[i])) {
224 //                uint256 _price = artItemMap[itemIds[i]].price;
225 //                artItemMap[itemIds[i]].price = _price.mul(priceGainPercentPerYear).div(100).div(365).add(_price);
226 //            }
227 //        }
228 //    }
229 
230     //==============================================================================
231     // query
232     //==============================================================================
233     function isPaused()
234         public
235         view
236         returns (bool)
237     {
238         return paused;
239     }
240 
241     function isItemExist(uint256 _tokenId)
242         public
243         view
244         returns (bool)
245     {
246         return artItemMap[_tokenId].isExist;
247     }
248 
249     function isItemSell(uint256 _tokenId) 
250         public
251         view
252         returns (bool)
253     {
254         require(artItemMap[_tokenId].isExist == true, "item not exist");
255 
256         return artItemMap[_tokenId].owner != address(this);
257     }
258 
259     function getItemPrice(uint256 _tokenId)
260         public
261         view
262         returns (uint256)
263     {
264         require(artItemMap[_tokenId].isExist == true, "item not exist");
265 
266         return artItemMap[_tokenId].price;
267     }
268 
269     function getPlayerItems(uint256 _pId)
270         public
271         returns (uint256[])
272     {
273         require(_pId > 0 && _pId < pIdCount, "player not exist");
274         return playerMap[_pId].ownItemIds;
275     }
276 
277     //==============================================================================
278     // public
279     //==============================================================================
280     function buyItem(address _buyer, uint256 _tokenId, uint256 _affCode)
281         whenNotPaused()
282         external
283     {
284         uint256 _pId = determinePID(_buyer, _affCode);
285 
286         require(artItemMap[_tokenId].isExist == true, "item not exist");
287         require(isItemSell(_tokenId) == false, "item already sold");
288 
289         bool _isSuccess = YbTokenContract.transferFrom(_buyer, address(this), artItemMap[_tokenId].price);
290         require(_isSuccess, "yb transfer from failed");
291 
292         artItemMap[_tokenId].owner = _buyer;
293         artItemMap[_tokenId].lastTransPrice = artItemMap[_tokenId].price;
294 
295         artItemMap[_tokenId].buyYibPrice = YbTokenContract.getCurrentPrice();
296         artItemMap[_tokenId].buyTime = now;
297 
298         playerMap[_pId].ownItemIds.push(_tokenId);
299 
300         if(playerMap[_pId].laffId != 0) {
301             uint256 _affCut = (artItemMap[_tokenId].price).mul(affPercentCut).div(100);
302             address _affAddr = playerMap[playerMap[_pId].laffId].addr;
303             YbTokenContract.transfer(_affAddr, _affCut);
304         }
305         
306         emit ArtChainEvents.onTransferItem ({
307             from: this,
308             to: _buyer,
309             itemId: _tokenId,
310             price: artItemMap[_tokenId].price,
311             yibPrice: artItemMap[_tokenId].buyYibPrice,
312             timeStamp: now
313         });
314     }
315 
316     function sellItem(uint256 _tokenId) 
317         whenNotPaused()
318         isHuman()
319         public
320     {
321         require(artItemMap[_tokenId].isExist == true, "item not exist");
322         require(artItemMap[_tokenId].owner == msg.sender,"player not own this item");
323         require(artItemMap[_tokenId].buyTime + artItemMap[_tokenId].lockDuration <= now,"the item still lock");
324 
325         uint256 _sellPrice = (artItemMap[_tokenId].price).mul(artItemMap[_tokenId].annualRate).div(100).add(artItemMap[_tokenId].price);
326         bool _isSuccess = YbTokenContract.transfer(msg.sender, _sellPrice);
327         require(_isSuccess,"yb transfer failed");
328 
329         artItemMap[_tokenId].owner = this;
330         artItemMap[_tokenId].lastTransPrice = artItemMap[_tokenId].price;
331 
332         removePlayerOwnItem(_tokenId);
333 
334         emit ArtChainEvents.onTransferItem ({
335             from: msg.sender,
336             to: this,
337             itemId: _tokenId,
338             price: artItemMap[_tokenId].price,
339             yibPrice: artItemMap[_tokenId].buyYibPrice,
340             timeStamp: now
341         });
342     }
343 
344     function removePlayerOwnItem(uint256 _tokenId)
345         private
346     {
347         uint256 _pId = pIDxAddr[msg.sender];
348         uint _itemIndex;
349         bool _isFound = false;
350         for (uint i = 0; i < playerMap[_pId].ownItemIds.length; i++) {
351             if(playerMap[_pId].ownItemIds[i] == _tokenId)
352             {
353                 _itemIndex = i;
354                 _isFound = true;
355                 break;
356             }
357         }
358         if(_isFound) {
359             playerMap[_pId].ownItemIds[_itemIndex] = playerMap[_pId].ownItemIds[playerMap[_pId].ownItemIds.length - 1];
360             playerMap[_pId].ownItemIds.length--;
361         }
362     }
363 
364     function registerPlayer(string _nameString, uint256 _affCode) 
365         whenNotPaused()
366         isHuman()
367         public
368     {
369         uint256 _pId = determinePID(msg.sender, _affCode);
370         bytes32 _name = _nameString.nameFilter();
371         playerMap[_pId].name = _name;
372     }
373 
374     //==============================================================================
375     // private
376     //==============================================================================
377 
378     function determinePID(address _addr, uint256 _affCode)
379         private
380         returns(uint256)
381     {
382         if (pIDxAddr[_addr] == 0)
383         {
384             pIdCount++;
385             pIDxAddr[_addr] = pIdCount;
386 
387             playerMap[pIdCount].id = pIdCount;
388             playerMap[pIdCount].addr = _addr;
389         } 
390         uint256 _pId = pIDxAddr[_addr];
391         playerMap[_pId].laffId = _affCode;
392         return _pId;
393     }
394 
395 }
396 
397 //==============================================================================
398 // interface
399 //==============================================================================
400 interface YbTokenInterface {
401     function transferFrom(address from, address to, uint256 value) external returns (bool);
402     function transfer(address to, uint256 value) external returns (bool);
403     function balanceOf(address addr) external view returns (uint256);
404     function getCurrentPrice() external view returns (uint256);
405 }
406 
407 
408 library NameFilter {
409 
410     function nameFilter(string _input)
411         internal
412         pure
413         returns(bytes32)
414     {
415         bytes memory _temp = bytes(_input);
416         uint256 _length = _temp.length;
417 
418         //sorry limited to 32 characters
419         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
420         // make sure it doesnt start with or end with space
421         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
422         // make sure first two characters are not 0x
423         if (_temp[0] == 0x30)
424         {
425             require(_temp[1] != 0x78, "string cannot start with 0x");
426             require(_temp[1] != 0x58, "string cannot start with 0X");
427         }
428 
429         // create a bool to track if we have a non number character
430         bool _hasNonNumber;
431 
432         // convert & check
433         for (uint256 i = 0; i < _length; i++)
434         {
435             // if its uppercase A-Z
436             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
437             {
438                 // convert to lower case a-z
439                 _temp[i] = byte(uint(_temp[i]) + 32);
440 
441                 // we have a non number
442                 if (_hasNonNumber == false)
443                     _hasNonNumber = true;
444             } else {
445                 require
446                 (
447                     // require character is a space
448                     _temp[i] == 0x20 ||
449                     // OR lowercase a-z
450                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
451                     // or 0-9
452                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
453                     "string contains invalid characters"
454                 );
455                 // make sure theres not 2x spaces in a row
456                 if (_temp[i] == 0x20)
457                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
458 
459                 // see if we have a character other than a number
460                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
461                     _hasNonNumber = true;
462             }
463         }
464 
465         require(_hasNonNumber == true, "string cannot be only numbers");
466 
467         bytes32 _ret;
468         assembly {
469             _ret := mload(add(_temp, 32))
470         }
471         return (_ret);
472     }
473 }
474 
475 library SafeMath 
476 {
477     /**
478     * @dev Multiplies two numbers, reverts on overflow.
479     */
480     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
481         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
482         // benefit is lost if 'b' is also tested.
483         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
484         if (_a == 0) {
485             return 0;
486         }
487 
488         uint256 c = _a * _b;
489         require(c / _a == _b);
490 
491         return c;
492     }
493 
494     /**
495     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
496     */
497     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
498         require(_b > 0); // Solidity only automatically asserts when dividing by 0
499         uint256 c = _a / _b;
500         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
501 
502         return c;
503     }
504 
505     /**
506     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
507     */
508     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
509         require(_b <= _a);
510         uint256 c = _a - _b;
511 
512         return c;
513     }
514 
515     /**
516     * @dev Adds two numbers, reverts on overflow.
517     */
518     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
519         uint256 c = _a + _b;
520         require(c >= _a);
521 
522         return c;
523     }
524 
525     /**
526     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
527     * reverts when dividing by zero.
528     */
529     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
530         require(b != 0);
531         return a % b;
532     }
533 }