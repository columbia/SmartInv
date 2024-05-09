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
178         0x5D00d312e171Be5342067c09BaE883f9Bcb2003B,
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
309                 require(msg.value <= Games[_game].limitETHFee.add(_hightLightFee));
310                 ethfee = Games[_game].limitETHFee;
311             } else if(Games[_game].tokenPrice[_tokenId].price > 0 && totalFee < Games[_game].limitETHFee) {
312                 ethfee = _hightLightFee;
313                 require(msg.value <= ethfee);
314             } else {
315                 ethfee = totalFee.sub(Games[_game].tokenPrice[_tokenId].fee);
316                 require(msg.value <= ethfee.add(_hightLightFee));
317             }
318             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
319         } else ethfee = Games[_game].tokenPrice[_tokenId].fee.add(_hightLightFee);
320 
321         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
322         emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 1);
323     }
324 
325     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
326         uint256 fee;
327         uint256 _hightLightFee = 0;
328         uint256 hbNeed;
329         address local_game = _game;
330         uint256 local_tokenId = _tokenId;
331         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
332             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
333         }
334         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
335             fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
336             uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
337             if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
338                 hbNeed = Games[local_game].limitHBWALLETFee.add(_hightLightFee);
339             } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
340                 hbNeed = _hightLightFee;
341             } else hbNeed = totalFeeHB.add(_hightLightFee).sub(Games[_game].tokenPrice[_tokenId].hbfee);
342         } else {
343             hbNeed = _hightLightFee;
344         }
345         return hbNeed;
346     }
347 
348     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
349         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
350         uint fee;
351         uint _hightLightFee = 0;
352         address local_game = _game;
353         uint256 local_tokenId = _tokenId;
354         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlightByHb != 1)) {
355             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
356         }
357         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
358             fee = calFeeHB(_game, _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price));
359             uint256 totalFeeHB = calFeeHB(_game, _ethPrice);
360             if(fee < Games[local_game].limitHBWALLETFee && Games[local_game].tokenPrice[_tokenId].price == 0) {
361                 require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
362                 fee = Games[_game].limitHBWALLETFee;
363             } else if(Games[local_game].tokenPrice[_tokenId].price > 0 && totalFeeHB < Games[_game].limitHBWALLETFee) {
364                 fee = _hightLightFee;
365                 require(hbwalletToken.transferFrom(msg.sender, address(this), fee));
366             } else {
367                 fee = totalFeeHB.sub(Games[_game].tokenPrice[_tokenId].hbfee);
368                 require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
369             }
370             fee = fee.add(Games[local_game].tokenPrice[_tokenId].hbfee);
371         } else {
372             fee = Games[_game].tokenPrice[_tokenId].hbfee.add(_hightLightFee);
373         }
374 
375         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
376         emit _setPrice(_game, _tokenId, _ethPrice, _isHightLight, 2);
377     }
378 
379     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId){
380         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
381         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
382         if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
383             IERC721 erc721Address = IERC721(_game);
384             erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
385         }
386         resetPrice(_game, _tokenId);
387     }
388 
389     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner{
390         require(_HBWALLETExchange >= 1);
391 
392         HBWALLETExchange = _HBWALLETExchange;
393     }
394 
395     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner {
396         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
397         Games[_game].ETHFee = _ethFee;
398         Games[_game].limitETHFee = _ethlimitFee;
399         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
400         Games[_game].hightLightFee = _hightLightFee;
401     }
402 
403     function _withdraw(uint256 amount, uint256 _amountHB) internal {
404         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
405         if(amount > 0) {
406             msg.sender.transfer(amount);
407         }
408         if(_amountHB > 0) {
409             hbwalletToken.transfer(msg.sender, _amountHB);
410         }
411     }
412     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
413         _withdraw(amount, _amountHB);
414     }
415     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
416         IERC721 erc721Address = IERC721(_game);
417         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
418         || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
419 
420             uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
421             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
422             if(eth > 0 && address(this).balance >= eth) {
423                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
424             }
425 
426             uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
427             if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
428             if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
429                 hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
430             }
431             if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
432             resetPrice(_game, _tokenId);
433         }
434     }
435 
436     function cancelBussinessByGame(address _game) private onlyCeoAddress {
437         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
438         for (uint i = 0; i < _arrTokenId.length; i++) {
439             cancelBussinessByGameId(_game, _arrTokenId[i]);
440         }
441 
442     }
443     function cancelBussiness() public onlyCeoAddress {
444         for(uint j = 0; j< arrGames.length; j++) {
445             address _game = arrGames[j];
446             cancelBussinessByGame(_game);
447         }
448         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
449     }
450 
451     function revenue() public view returns (uint256, uint){
452 
453         uint256 ethfee;
454         uint256 hbfee;
455         for(uint j = 0; j< arrGames.length; j++) {
456 
457             address _game = arrGames[j];
458             IERC721 erc721Address = IERC721(arrGames[j]);
459             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
460                 uint256 _tokenId = Games[_game].tokenIdSale[i];
461                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
462 
463                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
464                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
465 
466                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
467                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
468 
469                 }
470             }
471         }
472 
473         uint256 eth = address(this).balance.sub(ethfee);
474         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
475         return (eth, hb);
476     }
477 
478     function changeCeo(address _address) public onlyCeoAddress {
479         require(_address != address(0));
480         ceoAddress = _address;
481 
482     }
483 
484     function buy(address _game, uint256 tokenId) public payable {
485         IERC721 erc721Address = IERC721(_game);
486         require(getApproved(_game, tokenId) == address(this));
487         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
488         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
489         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
490         resetPrice(_game, tokenId);
491     }
492 
493     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
494         IERC721 erc721Address = IERC721(_game);
495         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
496         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
497         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
498         resetPrice(_game, tokenId);
499     }
500 
501     // function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
502     //     IERC721 erc721Address = IERC721(_game);
503     //     require(Games[_game].tokenPrice[_tokenId].price == msg.value);
504     //     require(erc721Address.ownerOf(_tokenId) == address(this));
505     //     erc721Address.transfer(msg.sender, _tokenId);
506     //     Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
507     //     resetPrice(_game, _tokenId);
508     // }
509     function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {
510         IERC721 erc721Address = IERC721(_game);
511         require(Games[_game].tokenPrice[_tokenId].price == msg.value);
512         require(erc721Address.ownerOf(_tokenId) == address(this));
513         erc721Address.transfer(msg.sender, _tokenId);
514         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
515         resetPrice(_game, _tokenId);
516     }
517     // Move the last element to the deleted spot.
518     // Delete the last element, then correct the length.
519     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
520         if (index >= Games[_game].tokenIdSale.length) return;
521 
522         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
523             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
524         }
525         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
526         Games[_game].tokenIdSale.length--;
527     }
528 
529     function resetPrice(address _game, uint256 _tokenId) private {
530         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
531         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
532             if (Games[_game].tokenIdSale[i] == _tokenId) {
533                 _burnArrayTokenIdSale(_game, i);
534             }
535         }
536         emit _resetPrice(_game, _tokenId);
537     }
538 }