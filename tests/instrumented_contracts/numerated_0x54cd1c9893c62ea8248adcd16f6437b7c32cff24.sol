1 pragma solidity 0.5.13;
2 library SafeMath {
3 
4     /**
5     * @dev Multiplies two numbers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b > 0); // Solidity only automatically asserts when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28 
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b <= a);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42     /**
43     * @dev Adds two numbers, reverts on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
54     * reverts when dividing by zero.
55     */
56     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b != 0);
58         return a % b;
59     }
60 }
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67     address public owner;
68 
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73     /**
74      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75      * account.
76      */
77     constructor() public {
78         owner = msg.sender;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function transferOwnership(address newOwner) public onlyOwner {
94         require(newOwner != address(0));
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97     }
98 
99 }
100 
101 contract IERC721 {
102     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
103     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
104     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
105 
106     function balanceOf(address owner) public view returns (uint256 balance);
107 
108     function ownerOf(uint256 tokenId) public view returns (address owner);
109 
110     function approve(address to, uint256 tokenId) public;
111 
112     function getApproved(uint256 tokenId) public view returns (address operator);
113 
114     function setApprovalForAll(address operator, bool _approved) public;
115 
116     function isApprovedForAll(address owner, address operator) public view returns (bool);
117 
118     function transfer(address to, uint256 tokenId) public;
119 
120     function transferFrom(address from, address to, uint256 tokenId) public;
121 
122     function safeTransferFrom(address from, address to, uint256 tokenId) public;
123 
124     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
125 }
126 /**
127  * @title ERC20Basic
128  * @dev Simpler version of ERC20 interface
129  * @dev see https://github.com/ereum/EIPs/issues/179
130  */
131 contract ERC20BasicInterface {
132     function totalSupply() public view returns (uint256);
133 
134     function balanceOf(address who) public view returns (uint256);
135 
136     function transfer(address to, uint256 value) public returns (bool);
137 
138     function transferFrom(address from, address to, uint256 value) public returns (bool);
139 
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     uint8 public decimals;
143 }
144 
145 contract BuyNFTByStableCoin is Ownable {
146 
147     using SafeMath for uint256;
148     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
149     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
150     ERC20BasicInterface public erc20 = ERC20BasicInterface(0x6B175474E89094C44Da98b954EedeAC495271d0F); // DAI
151 
152     // ERC20BasicInterface public erc20 = ERC20BasicInterface(0xCfB13a54919250f6d3458E304a9ABFDc77cc87f2); // rinkeby
153     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F); // rinkeby
154     // ERC20BasicInterface public erc20 = ERC20BasicInterface(0xC4375B7De8af5a38a93548eb8453a498222C4fF2); // kovan
155     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x614F3262c6df42b174cF8544454D6Dc39A9768D2); //kovan
156 
157     uint256 public Percen = 1000;
158     uint256 public hightLightFee = 5 ether;
159     struct Price {
160         address payable tokenOwner;
161         uint256 Price;
162         uint256 fee;
163         uint isHightlight;
164     }
165     struct Game {
166         mapping(uint256 => Price) tokenPrice;
167         uint[] tokenIdSale;
168         uint256 Fee;
169         uint256 PercenDiscountOnHBWallet;
170         uint256 limitHBWALLETForDiscount;
171         uint256 limitFee;
172     }
173 
174     mapping(address => Game) public Games;
175     address[] public arrGames;
176     constructor() public {
177         arrGames = [
178         0x06012c8cf97BEaD5deAe237070F9587f8E7A266d,
179         0x1276dce965ADA590E42d62B3953dDc1DDCeB0392,
180         0xE60D2325f996e197EEdDed8964227a0c6CA82D0f,
181         0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b,
182         0xf26A23019b4699068bb54457f32dAFCF22A9D371,
183         0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099,
184         0x6EbeAf8e8E946F0716E6533A6f2cefc83f60e8Ab,
185         0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
186         0xBfdE6246Df72d3ca86419628CaC46a9d2B60393C,
187         0x543EcFB0d28fA40D639494957e7cBA52460F490E,
188         0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d,
189         0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4,
190         0x31AF195dB332bc9203d758C74dF5A5C5e597cDb7,
191         0x1a94fce7ef36Bc90959E206bA569a12AFBC91ca1,
192         0x30a2fA3c93Fb9F93D1EFeFfd350c6A6BB62ba000,
193         0x69A1d45318dE72d6Add20D4952398901E0E4a8e5,
194         0x4F41d10F7E67fD16bDe916b4A6DC3Dd101C57394
195         ];
196         for(uint i = 0; i< arrGames.length; i++) {
197             Games[arrGames[i]].Fee = 50;
198             Games[arrGames[i]].PercenDiscountOnHBWallet = 25;
199             Games[arrGames[i]].limitHBWALLETForDiscount = 200;
200             Games[arrGames[i]].limitFee = 250 finney;
201         }
202 
203         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].Fee = 50;
204         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].PercenDiscountOnHBWallet = 25;
205         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETForDiscount = 200;
206         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitFee = 250 finney;
207         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
208     }
209 
210     function getTokenPrice(address _game, uint256 _tokenId) public
211     returns (address _tokenOwner, uint256 _Price, uint256 _fee, uint _isHightlight) {
212         IERC721 erc721Address = IERC721(_game);
213         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner
214         && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
215         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
216         Games[_game].tokenPrice[_tokenId].Price,
217         Games[_game].tokenPrice[_tokenId].fee,
218         Games[_game].tokenPrice[_tokenId].isHightlight);
219     }
220     function getArrGames() public view returns(address[] memory){
221         return arrGames;
222     }
223     /**
224      * @dev Throws if called by any account other than the ceo address.
225      */
226     modifier onlyCeoAddress() {
227         require(msg.sender == ceoAddress);
228         _;
229     }
230     modifier isOwnerOf(address _game, uint256 _tokenId) {
231         IERC721 erc721Address = IERC721(_game);
232         require(erc721Address.ownerOf(_tokenId) == msg.sender);
233         _;
234     }
235     event _setPrice(address _game, uint256 _tokenId, uint256 _Price, uint _isHightLight, uint8 _type);
236     event _resetPrice(address _game, uint256 _tokenId);
237     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
238         IERC721 erc721Address = IERC721(_game);
239         return erc721Address.ownerOf(_tokenId);
240     }
241 
242     function balanceOf() public view returns (uint256){
243         return address(this).balance;
244     }
245 
246     function getApproved(address _game, uint256 _tokenId) public view returns (address){
247         IERC721 erc721Address = IERC721(_game);
248         return erc721Address.getApproved(_tokenId);
249     }
250 
251     function setPrice(address _game, uint256 _tokenId, uint256 _price, uint256 _fee, uint _isHightLight) internal {
252         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _price, _fee, _isHightLight);
253         Games[_game].tokenIdSale.push(_tokenId);
254         bool flag = false;
255         for(uint i = 0; i< arrGames.length; i++) {
256             if(arrGames[i] == _game) flag = true;
257         }
258         if(!flag) arrGames.push(_game);
259     }
260 
261     function calFee(address _game, uint256 _price) public view returns (uint256){
262         uint256 senderHBBalance = hbwalletToken.balanceOf(msg.sender);
263         uint256 fee =_price.mul(Games[_game].Fee).div(Percen);
264         if(senderHBBalance >= Games[_game].limitHBWALLETForDiscount) fee = _price.mul(Games[_game].PercenDiscountOnHBWallet).div(Percen);
265         return fee;
266     }
267     function calFeeHightLight(address _game, uint256 _tokenId, uint _isHightLight) public view returns (uint256){
268         uint256 _hightLightFee = 0;
269         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].Price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
270             _hightLightFee = hightLightFee;
271         }
272         return _hightLightFee;
273     }
274     function calPrice(address _game, uint256 _tokenId, uint256 _Price, uint _isHightLight) public view
275     returns(uint256 _Need) {
276         uint256 fee;
277         uint256 _hightLightFee = calFeeHightLight(_game, _tokenId, _isHightLight);
278         uint256 Need;
279         uint256 totalFee;
280         if (Games[_game].tokenPrice[_tokenId].Price < _Price) {
281             fee = calFee(_game, _Price.sub(Games[_game].tokenPrice[_tokenId].Price));
282             totalFee = calFee(_game, _Price);
283             if(Games[_game].tokenPrice[_tokenId].Price == 0 && fee < Games[_game].limitFee) {
284                 Need = Games[_game].limitFee.add(_hightLightFee);
285             } else if(Games[_game].tokenPrice[_tokenId].Price > 0 && totalFee < Games[_game].limitFee) {
286                 Need = _hightLightFee;
287             } else {
288                 if(totalFee.add(_hightLightFee) < Games[_game].tokenPrice[_tokenId].fee) Need = 0;
289                 else Need = totalFee.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].fee);
290             }
291 
292         } else {
293             Need = _hightLightFee;
294         }
295         return Need;
296     }
297 
298     function setPriceFee(address _game, uint256 _tokenId, uint256 _price, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
299         require(Games[_game].tokenPrice[_tokenId].Price != _price);
300         uint256 Need = calPrice(_game, _tokenId, _price, _isHightLight);
301         require(erc20.transferFrom(msg.sender, address(this), Need));
302 
303         uint256 _hightLightFee = calFeeHightLight(_game, _tokenId, _isHightLight);
304         uint fee;
305         if (Games[_game].tokenPrice[_tokenId].Price < _price) {
306             fee = calFee(_game, _price.sub(Games[_game].tokenPrice[_tokenId].Price));
307             uint256 totalFee = calFee(_game, _price);
308             if(Games[_game].tokenPrice[_tokenId].Price == 0 && fee < Games[_game].limitFee) {
309 
310                 fee = Games[_game].limitFee;
311             } else if(Games[_game].tokenPrice[_tokenId].Price > 0 && totalFee < Games[_game].limitFee) {
312 
313                 fee = 0;
314             } else {
315                 if(totalFee.add(_hightLightFee) < Games[_game].tokenPrice[_tokenId].fee) fee = 0;
316                 else fee = totalFee.sub(Games[_game].tokenPrice[_tokenId].fee);
317             }
318             fee = fee.add(Games[_game].tokenPrice[_tokenId].fee);
319         } else {
320             fee = Games[_game].tokenPrice[_tokenId].fee;
321         }
322 
323         setPrice(_game, _tokenId, _price, fee, _isHightLight);
324         emit _setPrice(_game, _tokenId, _price, _isHightLight, 1);
325     }
326     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId){
327         erc20.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].fee);
328         if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
329             IERC721 erc721Address = IERC721(_game);
330             erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
331         }
332         resetPrice(_game, _tokenId);
333     }
334 
335     function setLimitFee(address _game, uint256 _Fee, uint256 _limitFee, uint256 _hightLightFee,
336         uint256 _PercenDiscountOnHBWallet, uint256  _limitHBWALLETForDiscount) public onlyOwner {
337         require(_Fee >= 0 && _limitFee >= 0 && _hightLightFee >= 0);
338         Games[_game].Fee = _Fee;
339         Games[_game].limitFee = _limitFee;
340         Games[_game].PercenDiscountOnHBWallet = _PercenDiscountOnHBWallet;
341         Games[_game].limitHBWALLETForDiscount = _limitHBWALLETForDiscount;
342         hightLightFee = _hightLightFee;
343     }
344     function setLimitFeeAll(address[] memory _game, uint256[] memory _Fee, uint256[] memory _limitFee, uint256 _hightLightFee,
345         uint256[] memory _PercenDiscountOnHBWallet, uint256[]  memory _limitHBWALLETForDiscount) public onlyOwner {
346         require(_game.length == _Fee.length);
347         for(uint i = 0; i < _game.length; i++){
348             require(_Fee[i] >= 0 && _limitFee[i] >= 0);
349             Games[_game[i]].Fee = _Fee[i];
350             Games[_game[i]].limitFee = _limitFee[i];
351             Games[_game[i]].PercenDiscountOnHBWallet = _PercenDiscountOnHBWallet[i];
352             Games[_game[i]].limitHBWALLETForDiscount = _limitHBWALLETForDiscount[i];
353         }
354 
355         hightLightFee = _hightLightFee;
356     }
357     function withdraw(uint256 amount) public onlyCeoAddress {
358         _withdraw(amount);
359     }
360     function _withdraw(uint256 amount) internal {
361         require(erc20.balanceOf(address(this)) >= amount);
362         if(amount > 0) {
363             erc20.transfer(msg.sender, amount);
364         }
365     }
366 
367     function cancelBusinessByGameId(address _game, uint256 _tokenId) private {
368         IERC721 erc721Address = IERC721(_game);
369         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
370         || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
371 
372             uint256 amount = Games[_game].tokenPrice[_tokenId].fee;
373             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) amount = amount.add(hightLightFee);
374             if( amount > 0 && erc20.balanceOf(address(this)) >= amount) {
375                 erc20.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, amount);
376             }
377             if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
378             resetPrice(_game, _tokenId);
379         }
380     }
381 
382     function cancelBusinessByGame(address _game) private {
383         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
384         for (uint i = 0; i < _arrTokenId.length; i++) {
385             cancelBusinessByGameId(_game, _arrTokenId[i]);
386         }
387 
388     }
389     function cancelBussiness() public onlyCeoAddress {
390         for(uint j = 0; j< arrGames.length; j++) {
391             address _game = arrGames[j];
392             cancelBusinessByGame(_game);
393         }
394         _withdraw(address(this).balance);
395     }
396 
397     function revenue() public view returns (uint256){
398         uint256 fee;
399         for(uint j = 0; j< arrGames.length; j++) {
400             address _game = arrGames[j];
401             IERC721 erc721Address = IERC721(arrGames[j]);
402             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
403                 uint256 _tokenId = Games[_game].tokenIdSale[i];
404                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
405 
406                     fee = fee.add(Games[_game].tokenPrice[_tokenId].fee);
407                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) fee = fee.add(hightLightFee);
408                 }
409             }
410         }
411 
412         uint256 amount = erc20.balanceOf(address(this)).sub(fee);
413         return amount;
414     }
415 
416     function changeCeo(address _address) public onlyCeoAddress {
417         require(_address != address(0));
418         ceoAddress = _address;
419 
420     }
421 
422     function buy(address _game, uint256 tokenId) public payable {
423         IERC721 erc721Address = IERC721(_game);
424         require(erc721Address.getApproved(tokenId) == address(this));
425         require(Games[_game].tokenPrice[tokenId].Price > 0);
426         require(erc20.transferFrom(msg.sender, Games[_game].tokenPrice[tokenId].tokenOwner, Games[_game].tokenPrice[tokenId].Price));
427 
428         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
429         resetPrice(_game, tokenId);
430     }
431 
432     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
433         IERC721 erc721Address = IERC721(_game);
434         require(Games[_game].tokenPrice[tokenId].Price > 0);
435         require(erc20.transferFrom(msg.sender, Games[_game].tokenPrice[tokenId].tokenOwner, Games[_game].tokenPrice[tokenId].Price));
436 
437         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
438         resetPrice(_game, tokenId);
439     }
440 
441     function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {
442         IERC721 erc721Address = IERC721(_game);
443         require(erc721Address.ownerOf(_tokenId) == address(this));
444         require(erc20.transferFrom(msg.sender, Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].Price));
445 
446         erc721Address.transfer(msg.sender, _tokenId);
447         resetPrice(_game, _tokenId);
448     }
449     // Move the last element to the deleted spot.
450     // Delete the last element, then correct the length.
451     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
452         if (index >= Games[_game].tokenIdSale.length) return;
453 
454         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
455             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
456         }
457         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
458         Games[_game].tokenIdSale.length--;
459     }
460 
461     function resetPrice(address _game, uint256 _tokenId) private {
462         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0);
463         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
464             if (Games[_game].tokenIdSale[i] == _tokenId) {
465                 _burnArrayTokenIdSale(_game, i);
466             }
467         }
468         emit _resetPrice(_game, _tokenId);
469     }
470 }