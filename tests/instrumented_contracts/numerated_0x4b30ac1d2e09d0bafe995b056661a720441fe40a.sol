1 pragma solidity 0.5.11;
2 pragma experimental ABIEncoderV2;
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, reverts on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10         // benefit is lost if 'b' is also tested.
11         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0); // Solidity only automatically asserts when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68     address public owner;
69 
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73 
74     /**
75      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76      * account.
77      */
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     /**
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     /**
91      * @dev Allows the current owner to transfer control of the contract to a newOwner.
92      * @param newOwner The address to transfer ownership to.
93      */
94     function transferOwnership(address newOwner) public onlyOwner {
95         require(newOwner != address(0));
96         emit OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98     }
99 
100 }
101 
102 contract IERC721 {
103     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
105     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
106 
107     function balanceOf(address owner) public view returns (uint256 balance);
108 
109     function ownerOf(uint256 tokenId) public view returns (address owner);
110 
111     function approve(address to, uint256 tokenId) public;
112 
113     function getApproved(uint256 tokenId) public view returns (address operator);
114 
115     function setApprovalForAll(address operator, bool _approved) public;
116 
117     function isApprovedForAll(address owner, address operator) public view returns (bool);
118 
119     function transfer(address to, uint256 tokenId) public;
120 
121     function transferFrom(address from, address to, uint256 tokenId) public;
122 
123     function safeTransferFrom(address from, address to, uint256 tokenId) public;
124 
125     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
126 }
127 /**
128  * @title ERC20Basic
129  * @dev Simpler version of ERC20 interface
130  * @dev see https://github.com/ereum/EIPs/issues/179
131  */
132 contract ERC20BasicInterface {
133     function totalSupply() public view returns (uint256);
134 
135     function balanceOf(address who) public view returns (uint256);
136 
137     function transfer(address to, uint256 value) public returns (bool);
138 
139     function transferFrom(address from, address to, uint256 value) public returns (bool);
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     uint8 public decimals;
144 }
145 
146 contract BuyNFT is Ownable {
147 
148     using SafeMath for uint256;
149     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
150     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
151     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
152     uint256 public Percen = 1000;
153     uint256 public hightLightFee = 27 finney;
154     struct Price {
155         address payable tokenOwner;
156         uint256 Price;
157         uint256 fee;
158         uint isHightlight;
159     }
160     struct Game {
161         mapping(uint256 => Price) tokenPrice;
162         uint[] tokenIdSale;
163         uint256 Fee;
164         uint256 PercenDiscountOnHBWallet;
165         uint256 limitHBWALLETForDiscount;
166         uint256 limitFee;
167     }
168 
169     mapping(address => Game) public Games;
170     address[] public arrGames;
171     constructor() public {
172         arrGames = [
173         0x06012c8cf97BEaD5deAe237070F9587f8E7A266d,
174         0x1276dce965ADA590E42d62B3953dDc1DDCeB0392,
175         0xE60D2325f996e197EEdDed8964227a0c6CA82D0f,
176         0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b,
177         0xf26A23019b4699068bb54457f32dAFCF22A9D371,
178         0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099,
179         0x6EbeAf8e8E946F0716E6533A6f2cefc83f60e8Ab,
180         0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
181         0xBfdE6246Df72d3ca86419628CaC46a9d2B60393C,
182         0x543EcFB0d28fA40D639494957e7cBA52460F490E,
183         0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d,
184         0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4,
185         0x31AF195dB332bc9203d758C74dF5A5C5e597cDb7,
186         0x1a94fce7ef36Bc90959E206bA569a12AFBC91ca1,
187         0x30a2fA3c93Fb9F93D1EFeFfd350c6A6BB62ba000,
188         0x69A1d45318dE72d6Add20D4952398901E0E4a8e5,
189         0x4F41d10F7E67fD16bDe916b4A6DC3Dd101C57394
190         ];
191         for(uint i = 0; i< arrGames.length; i++) {
192             Games[arrGames[i]].Fee = 50;
193             Games[arrGames[i]].PercenDiscountOnHBWallet = 25;
194             Games[arrGames[i]].limitHBWALLETForDiscount = 200;
195             Games[arrGames[i]].limitFee = 1 finney;
196         }
197 
198         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].Fee = 50;
199         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].PercenDiscountOnHBWallet = 25;
200         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETForDiscount = 200;
201         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitFee = 1 finney;
202         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
203     }
204 
205     function getTokenPrice(address _game, uint256 _tokenId) public
206     returns (address _tokenOwner, uint256 _Price, uint256 _fee, uint _isHightlight) {
207         IERC721 erc721Address = IERC721(_game);
208         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner
209         && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
210         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
211         Games[_game].tokenPrice[_tokenId].Price,
212         Games[_game].tokenPrice[_tokenId].fee,
213         Games[_game].tokenPrice[_tokenId].isHightlight);
214     }
215     function getArrGames() public view returns(address[] memory){
216         return arrGames;
217     }
218     /**
219      * @dev Throws if called by any account other than the ceo address.
220      */
221     modifier onlyCeoAddress() {
222         require(msg.sender == ceoAddress);
223         _;
224     }
225     modifier isOwnerOf(address _game, uint256 _tokenId) {
226         IERC721 erc721Address = IERC721(_game);
227         require(erc721Address.ownerOf(_tokenId) == msg.sender);
228         _;
229     }
230     event _setPrice(address _game, uint256 _tokenId, uint256 _Price, uint _isHightLight, uint8 _type);
231     event _resetPrice(address _game, uint256 _tokenId);
232     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
233         IERC721 erc721Address = IERC721(_game);
234         return erc721Address.ownerOf(_tokenId);
235     }
236 
237     function balanceOf() public view returns (uint256){
238         return address(this).balance;
239     }
240 
241     function getApproved(address _game, uint256 _tokenId) public view returns (address){
242         IERC721 erc721Address = IERC721(_game);
243         return erc721Address.getApproved(_tokenId);
244     }
245 
246     function setPrice(address _game, uint256 _tokenId, uint256 _price, uint256 _fee, uint _isHightLight) internal {
247         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _price, _fee, _isHightLight);
248         Games[_game].tokenIdSale.push(_tokenId);
249         bool flag = false;
250         for(uint i = 0; i< arrGames.length; i++) {
251             if(arrGames[i] == _game) flag = true;
252         }
253         if(!flag) arrGames.push(_game);
254     }
255 
256     function calFee(address _game, uint256 _price) public view returns (uint256){
257         uint256 senderHBBalance = hbwalletToken.balanceOf(msg.sender);
258         uint256 fee =_price.mul(Games[_game].Fee).div(Percen);
259         if(senderHBBalance >= Games[_game].limitHBWALLETForDiscount) fee = _price.mul(Games[_game].PercenDiscountOnHBWallet).div(Percen);
260         return fee;
261     }
262     function calFeeHightLight(address _game, uint256 _tokenId, uint _isHightLight) public view returns (uint256){
263         uint256 _hightLightFee = 0;
264         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].Price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
265             _hightLightFee = hightLightFee;
266         }
267         return _hightLightFee;
268     }
269     function calPrice(address _game, uint256 _tokenId, uint256 _Price, uint _isHightLight) public view
270     returns(uint256 _Need) {
271         uint256 fee;
272         uint256 _hightLightFee = calFeeHightLight(_game, _tokenId, _isHightLight);
273         uint256 Need;
274         uint256 totalFee;
275         if (Games[_game].tokenPrice[_tokenId].Price < _Price) {
276             fee = calFee(_game, _Price.sub(Games[_game].tokenPrice[_tokenId].Price));
277             totalFee = calFee(_game, _Price);
278             if(Games[_game].tokenPrice[_tokenId].Price == 0 && fee < Games[_game].limitFee) {
279                 Need = Games[_game].limitFee.add(_hightLightFee);
280             } else if(Games[_game].tokenPrice[_tokenId].Price > 0 && totalFee < Games[_game].limitFee) {
281                 Need = _hightLightFee;
282             } else {
283                 if(totalFee.add(_hightLightFee) < Games[_game].tokenPrice[_tokenId].fee) Need = 0;
284                 else Need = totalFee.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].fee);
285             }
286 
287         } else {
288             Need = _hightLightFee;
289         }
290         return Need;
291     }
292     function setPriceFee(address _game, uint256 _tokenId, uint256 _Price, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
293         require(Games[_game].tokenPrice[_tokenId].Price != _Price);
294         uint256 Need = calPrice(_game, _tokenId, _Price, _isHightLight);
295 
296         require(msg.value >= Need);
297         uint256 _hightLightFee = calFeeHightLight(_game, _tokenId, _isHightLight);
298         uint256 fee;
299         if (Games[_game].tokenPrice[_tokenId].Price < _Price) {
300             fee = calFee(_game, _Price.sub(Games[_game].tokenPrice[_tokenId].Price));
301             uint256 totalFee = calFee(_game, _Price);
302 
303             if(Games[_game].tokenPrice[_tokenId].Price == 0 && fee < Games[_game].limitFee) {
304 
305                 fee = Games[_game].limitFee;
306             } else if(Games[_game].tokenPrice[_tokenId].Price > 0 && totalFee < Games[_game].limitFee) {
307 
308                 fee = 0;
309             } else {
310                 if(totalFee.add(_hightLightFee) < Games[_game].tokenPrice[_tokenId].fee) fee = 0;
311                 else fee = totalFee.sub(Games[_game].tokenPrice[_tokenId].fee);
312             }
313             fee = fee.add(Games[_game].tokenPrice[_tokenId].fee);
314         } else {
315 
316             fee = Games[_game].tokenPrice[_tokenId].fee;
317         }
318 
319         setPrice(_game, _tokenId, _Price, fee, _isHightLight);
320         emit _setPrice(_game, _tokenId, _Price, _isHightLight, 1);
321     }
322 
323     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId){
324         msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
325         if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
326             IERC721 erc721Address = IERC721(_game);
327             erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
328         }
329         resetPrice(_game, _tokenId);
330     }
331 
332     function setLimitFee(address _game, uint256 _Fee, uint256 _limitFee, uint256 _hightLightFee,
333         uint256 _PercenDiscountOnHBWallet, uint256  _limitHBWALLETForDiscount) public onlyOwner {
334         require(_Fee >= 0 && _limitFee >= 0 && _hightLightFee >= 0);
335         Games[_game].Fee = _Fee;
336         Games[_game].limitFee = _limitFee;
337         Games[_game].PercenDiscountOnHBWallet = _PercenDiscountOnHBWallet;
338         Games[_game].limitHBWALLETForDiscount = _limitHBWALLETForDiscount;
339         hightLightFee = _hightLightFee;
340     }
341     function setLimitFeeAll(address[] memory _game, uint256[] memory _Fee, uint256[] memory _limitFee, uint256 _hightLightFee,
342         uint256[] memory _PercenDiscountOnHBWallet, uint256[]  memory _limitHBWALLETForDiscount) public onlyOwner {
343         require(_game.length == _Fee.length);
344         for(uint i = 0; i < _game.length; i++){
345             require(_Fee[i] >= 0 && _limitFee[i] >= 0);
346             Games[_game[i]].Fee = _Fee[i];
347             Games[_game[i]].limitFee = _limitFee[i];
348             Games[_game[i]].PercenDiscountOnHBWallet = _PercenDiscountOnHBWallet[i];
349             Games[_game[i]].limitHBWALLETForDiscount = _limitHBWALLETForDiscount[i];
350         }
351 
352         hightLightFee = _hightLightFee;
353     }
354     function _withdraw(uint256 amount) internal {
355         require(address(this).balance >= amount);
356         if(amount > 0) {
357             msg.sender.transfer(amount);
358         }
359     }
360     function withdraw(uint256 amount) public onlyCeoAddress {
361         _withdraw(amount);
362     }
363     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
364         IERC721 erc721Address = IERC721(_game);
365         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
366         || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
367 
368             uint256 amount = Games[_game].tokenPrice[_tokenId].fee;
369             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) amount = amount.add(hightLightFee);
370             if( amount > 0 && address(this).balance >= amount) {
371                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(amount);
372             }
373             if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
374             resetPrice(_game, _tokenId);
375         }
376     }
377 
378     function cancelBussinessByGame(address _game) private {
379         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
380         for (uint i = 0; i < _arrTokenId.length; i++) {
381             cancelBussinessByGameId(_game, _arrTokenId[i]);
382         }
383 
384     }
385     function cancelBussiness() public onlyCeoAddress {
386         for(uint j = 0; j< arrGames.length; j++) {
387             address _game = arrGames[j];
388             cancelBussinessByGame(_game);
389         }
390         _withdraw(address(this).balance);
391     }
392 
393     function revenue() public view returns (uint256){
394         uint256 fee;
395         for(uint j = 0; j< arrGames.length; j++) {
396             address _game = arrGames[j];
397             IERC721 erc721Address = IERC721(arrGames[j]);
398             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
399                 uint256 _tokenId = Games[_game].tokenIdSale[i];
400                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
401 
402                     fee = fee.add(Games[_game].tokenPrice[_tokenId].fee);
403                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) fee = fee.add(hightLightFee);
404                 }
405             }
406         }
407 
408         uint256 amount = address(this).balance.sub(fee);
409         return amount;
410     }
411 
412     function changeCeo(address _address) public onlyCeoAddress {
413         require(_address != address(0));
414         ceoAddress = _address;
415 
416     }
417 
418     function buy(address _game, uint256 tokenId) public payable {
419         IERC721 erc721Address = IERC721(_game);
420         require(erc721Address.getApproved(tokenId) == address(this));
421         require(Games[_game].tokenPrice[tokenId].Price > 0 && Games[_game].tokenPrice[tokenId].Price == msg.value);
422         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
423         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
424         resetPrice(_game, tokenId);
425     }
426 
427     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
428         IERC721 erc721Address = IERC721(_game);
429         require(Games[_game].tokenPrice[tokenId].Price > 0 && Games[_game].tokenPrice[tokenId].Price == msg.value);
430         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
431         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
432         resetPrice(_game, tokenId);
433     }
434 
435     function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {
436         IERC721 erc721Address = IERC721(_game);
437         require(Games[_game].tokenPrice[_tokenId].Price == msg.value);
438         require(erc721Address.ownerOf(_tokenId) == address(this));
439         erc721Address.transfer(msg.sender, _tokenId);
440         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
441         resetPrice(_game, _tokenId);
442     }
443     // Move the last element to the deleted spot.
444     // Delete the last element, then correct the length.
445     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
446         if (index >= Games[_game].tokenIdSale.length) return;
447 
448         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
449             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
450         }
451         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
452         Games[_game].tokenIdSale.length--;
453     }
454 
455     function resetPrice(address _game, uint256 _tokenId) private {
456         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0);
457         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
458             if (Games[_game].tokenIdSale[i] == _tokenId) {
459                 _burnArrayTokenIdSale(_game, i);
460             }
461         }
462         emit _resetPrice(_game, _tokenId);
463     }
464 }