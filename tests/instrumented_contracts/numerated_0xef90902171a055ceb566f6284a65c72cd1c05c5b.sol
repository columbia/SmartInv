1 pragma solidity ^0.5.9;
2 
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
130  * @dev see https://github.com/ethereum/EIPs/issues/179
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
146 contract Bussiness is Ownable {
147 
148     using SafeMath for uint256;
149     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
150     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
151     // address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
152     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
153     uint256 public Percen = 1000;
154     uint256 public HBWALLETExchange = 21;
155 
156     struct Price {
157         address payable tokenOwner;
158         uint256 price;
159         uint256 fee;
160         uint256 hbfee;
161         uint isHightlight;
162         uint isHightlightByHb;
163     }
164     // new code =======================
165     struct Game {
166         mapping(uint256 => Price) tokenPrice;
167         uint[] tokenIdSale;
168         uint256 ETHFee;
169         uint256 limitETHFee;
170         uint256 limitHBWALLETFee;
171         uint256 hightLightFee;
172     }
173 
174     mapping(address => Game) public Games;
175     address[] public arrGames;
176     constructor() public {
177         arrGames = [
178         // 0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
179         0xdceaf1652a131F32a821468Dc03A92df0edd86Ea,
180         0x273f7F8E6489682Df756151F5525576E322d51A3,
181         0x06012c8cf97BEaD5deAe237070F9587f8E7A266d,
182         0x1276dce965ADA590E42d62B3953dDc1DDCeB0392,
183         0xE60D2325f996e197EEdDed8964227a0c6CA82D0f,
184         0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340,
185         0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b,
186         0xf26A23019b4699068bb54457f32dAFCF22A9D371,
187         0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099,
188         0x6EbeAf8e8E946F0716E6533A6f2cefc83f60e8Ab,
189         0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
190         0xBfdE6246Df72d3ca86419628CaC46a9d2B60393C,
191         0x71C118B00759B0851785642541Ceb0F4CEea0BD5,
192         0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d,
193         0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4,
194         0x31AF195dB332bc9203d758C74dF5A5C5e597cDb7,
195         0x1a94fce7ef36Bc90959E206bA569a12AFBC91ca1
196         ];
197         for(uint i = 0; i< arrGames.length; i++) {
198             if(arrGames[i] == address(0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d)
199             || arrGames[i] == address(0xbc5370374FE08d699cf7fcd2e625A93BF393cCC4)) {
200                 Games[arrGames[i]].ETHFee = 10;
201                 Games[arrGames[i]].limitETHFee = 1000000000000000;
202                 Games[arrGames[i]].limitHBWALLETFee = 1;
203                 Games[arrGames[i]].hightLightFee = 100000000000000;
204             } else {
205                 Games[arrGames[i]].ETHFee = 0;
206                 Games[arrGames[i]].limitETHFee = 0;
207                 Games[arrGames[i]].limitHBWALLETFee = 0;
208                 Games[arrGames[i]].hightLightFee = 30000000000000000;
209             }
210 
211         }
212 
213         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 10;
214         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 1000000000000000;
215         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 1;
216         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 10000000000000000;
217         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
218     }
219 
220     function getTokenPrice(address _game, uint256 _tokenId) public returns (address owner, uint256 price, uint256 fee, uint256 hbfee, uint isHightlight, uint isHBHightlight) {
221         IERC721 erc721Address = IERC721(_game);
222         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner
223         && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
224         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
225         Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee,
226         Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight,
227         Games[_game].tokenPrice[_tokenId].isHightlightByHb);
228     }
229     // new code =======================
230     /**
231      * @dev Throws if called by any account other than the ceo address.
232      */
233     modifier onlyCeoAddress() {
234         require(msg.sender == ceoAddress);
235         _;
236     }
237     modifier isOwnerOf(address _game, uint256 _tokenId) {
238         IERC721 erc721Address = IERC721(_game);
239         require(erc721Address.ownerOf(_tokenId) == msg.sender);
240         _;
241     }
242     event _setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight, uint8 _type);
243     event _resetPrice(address _game, uint256 _tokenId);
244     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
245         IERC721 erc721Address = IERC721(_game);
246         return erc721Address.ownerOf(_tokenId);
247     }
248 
249     function balanceOf() public view returns (uint256){
250         return address(this).balance;
251     }
252 
253     function getApproved(address _game, uint256 _tokenId) public view returns (address){
254         IERC721 erc721Address = IERC721(_game);
255         return erc721Address.getApproved(_tokenId);
256     }
257 
258     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
259         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
260         Games[_game].tokenIdSale.push(_tokenId);
261         bool flag = false;
262         for(uint i = 0; i< arrGames.length; i++) {
263             if(arrGames[i] == _game) flag = true;
264         }
265         if(!flag) arrGames.push(_game);
266     }
267     function calFeeHB(address _game, uint256 _ethPrice) public view returns (uint256){
268         uint256 ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
269         uint256 fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
270         return fee;
271     }
272     function calFee(address _game, uint256 _ethPrice) public view returns (uint256){
273         return _ethPrice.mul(Games[_game].ETHFee).div(Percen);
274     }
275     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view
276     returns(uint256 _ethNeed, uint256 hightLightFee, uint256 _totalFee) {
277         uint256 ethfee;
278         uint256 _hightLightFee = 0;
279         uint256 ethNeed;
280         uint256 totalFee;
281         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
282             _hightLightFee = Games[_game].hightLightFee;
283         }
284         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
285             ethfee = calFee(_game, _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price));
286             totalFee = calFee(_game, _ethPrice);
287             if(Games[_game].tokenPrice[_tokenId].price == 0 && ethfee < Games[_game].limitETHFee) {
288                 ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
289             } else if(Games[_game].tokenPrice[_tokenId].price > 0 && totalFee < Games[_game].limitETHFee) {
290                 ethNeed = _hightLightFee;
291             } else ethNeed = totalFee.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].fee);
292 
293         } else {
294             ethNeed = _hightLightFee;
295         }
296         return (ethNeed, _hightLightFee, totalFee);
297     }
298     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
299         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
300         uint256 ethfee;
301         uint256 _hightLightFee = 0;
302         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
303             _hightLightFee = Games[_game].hightLightFee;
304         }
305         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
306             ethfee = calFee(_game, _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price));
307             uint256 totalFee = calFee(_game, _ethPrice);
308             if(Games[_game].tokenPrice[_tokenId].price == 0 && ethfee < Games[_game].limitETHFee) {
309                 require(msg.value >= Games[_game].limitETHFee.add(_hightLightFee));
310                 ethfee = Games[_game].limitETHFee;
311             } else if(Games[_game].tokenPrice[_tokenId].price > 0 && totalFee < Games[_game].limitETHFee) {
312                 require(msg.value >= _hightLightFee);
313                 ethfee = Games[_game].tokenPrice[_tokenId].fee;
314             } else {
315                 require(msg.value >= ethfee.add(_hightLightFee));
316                 ethfee = totalFee.sub(Games[_game].tokenPrice[_tokenId].fee);
317             }
318 
319         } else {
320             require(msg.value >= _hightLightFee);
321             ethfee = Games[_game].tokenPrice[_tokenId].fee;
322         }
323 
324         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
325         emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 1);
326     }
327 
328     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
329         uint256 fee;
330         uint256 _hightLightFee = 0;
331         uint256 hbNeed;
332         address local_game = _game;
333         uint256 local_tokenId = _tokenId;
334         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
335             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
336         }
337         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
338             fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
339             uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
340             if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
341                 hbNeed = Games[local_game].limitHBWALLETFee.add(_hightLightFee);
342             } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
343                 hbNeed = _hightLightFee;
344             } else hbNeed = totalFeeHB.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].hbfee);
345         } else {
346             hbNeed = _hightLightFee;
347         }
348         return hbNeed;
349     }
350 
351     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
352         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
353         uint fee;
354         uint _hightLightFee = 0;
355         address local_game = _game;
356         uint256 local_tokenId = _tokenId;
357         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
358             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
359         }
360         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
361             fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
362             uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
363             if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
364                 require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
365                 fee = Games[_game].limitHBWALLETFee;
366             } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
367                 require(hbwalletToken.transferFrom(msg.sender, address(this), _hightLightFee));
368                 fee = Games[_game].tokenPrice[_tokenId].hbfee;
369             } else {
370                 require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
371                 fee = totalFeeHB.sub(Games[_game].tokenPrice[_tokenId].hbfee);
372             }
373             fee = fee.add(Games[local_game].tokenPrice[_tokenId].hbfee);
374         } else {
375             require(hbwalletToken.transferFrom(msg.sender, address(this), _hightLightFee));
376             fee = Games[_game].tokenPrice[_tokenId].hbfee;
377         }
378 
379         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
380         emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 2);
381     }
382 
383     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId){
384         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
385         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
386         if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
387             IERC721 erc721Address = IERC721(_game);
388             erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
389         }
390         resetPrice(_game, _tokenId);
391     }
392 
393     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner{
394         require(_HBWALLETExchange >= 1);
395 
396         HBWALLETExchange = _HBWALLETExchange;
397     }
398 
399     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner {
400         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
401         Games[_game].ETHFee = _ethFee;
402         Games[_game].limitETHFee = _ethlimitFee;
403         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
404         Games[_game].hightLightFee = _hightLightFee;
405     }
406 
407     function _withdraw(uint256 amount, uint256 _amountHB) internal {
408         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
409         if(amount > 0) {
410             msg.sender.transfer(amount);
411         }
412         if(_amountHB > 0) {
413             hbwalletToken.transfer(msg.sender, _amountHB);
414         }
415     }
416     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
417         _withdraw(amount, _amountHB);
418     }
419     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
420         IERC721 erc721Address = IERC721(_game);
421         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
422         || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
423 
424             uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
425             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
426             if(eth > 0 && address(this).balance >= eth) {
427                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
428             }
429 
430             uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
431             if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
432             if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
433                 hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
434             }
435             if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
436             resetPrice(_game, _tokenId);
437         }
438     }
439 
440     function cancelBussinessByGame(address _game) private {
441         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
442         for (uint i = 0; i < _arrTokenId.length; i++) {
443             cancelBussinessByGameId(_game, _arrTokenId[i]);
444         }
445 
446     }
447     function cancelBussiness() public onlyCeoAddress {
448         for(uint j = 0; j< arrGames.length; j++) {
449             address _game = arrGames[j];
450             cancelBussinessByGame(_game);
451         }
452         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
453     }
454 
455     function revenue() public view returns (uint256, uint){
456 
457         uint256 ethfee;
458         uint256 hbfee;
459         for(uint j = 0; j< arrGames.length; j++) {
460 
461             address _game = arrGames[j];
462             IERC721 erc721Address = IERC721(arrGames[j]);
463             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
464                 uint256 _tokenId = Games[_game].tokenIdSale[i];
465                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
466 
467                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
468                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
469 
470                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
471                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
472 
473                 }
474             }
475         }
476 
477         uint256 eth = address(this).balance.sub(ethfee);
478         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
479         return (eth, hb);
480     }
481 
482     function changeCeo(address _address) public onlyCeoAddress {
483         require(_address != address(0));
484         ceoAddress = _address;
485 
486     }
487 
488     function buy(address _game, uint256 tokenId) public payable {
489         IERC721 erc721Address = IERC721(_game);
490         require(getApproved(_game, tokenId) == address(this));
491         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
492         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
493         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
494         resetPrice(_game, tokenId);
495     }
496 
497     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
498         IERC721 erc721Address = IERC721(_game);
499         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
500         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
501         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
502         resetPrice(_game, tokenId);
503     }
504 
505     // function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
506     //     IERC721 erc721Address = IERC721(_game);
507     //     require(Games[_game].tokenPrice[_tokenId].price == msg.value);
508     //     require(erc721Address.ownerOf(_tokenId) == address(this));
509     //     erc721Address.transfer(msg.sender, _tokenId);
510     //     Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
511     //     resetPrice(_game, _tokenId);
512     // }
513     function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {
514         IERC721 erc721Address = IERC721(_game);
515         require(Games[_game].tokenPrice[_tokenId].price == msg.value);
516         require(erc721Address.ownerOf(_tokenId) == address(this));
517         erc721Address.transfer(msg.sender, _tokenId);
518         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
519         resetPrice(_game, _tokenId);
520     }
521     // Move the last element to the deleted spot.
522     // Delete the last element, then correct the length.
523     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
524         if (index >= Games[_game].tokenIdSale.length) return;
525 
526         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
527             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
528         }
529         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
530         Games[_game].tokenIdSale.length--;
531     }
532 
533     function resetPrice(address _game, uint256 _tokenId) private {
534         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
535         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
536             if (Games[_game].tokenIdSale[i] == _tokenId) {
537                 _burnArrayTokenIdSale(_game, i);
538             }
539         }
540         emit _resetPrice(_game, _tokenId);
541     }
542 }