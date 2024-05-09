1 pragma solidity ^0.5.8;
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
119     function transferFrom(address from, address to, uint256 tokenId) public;
120 
121     function safeTransferFrom(address from, address to, uint256 tokenId) public;
122 
123     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
124 }
125 /**
126  * @title ERC20Basic
127  * @dev Simpler version of ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/179
129  */
130 contract ERC20BasicInterface {
131     function totalSupply() public view returns (uint256);
132 
133     function balanceOf(address who) public view returns (uint256);
134 
135     function transfer(address to, uint256 value) public returns (bool);
136 
137     function transferFrom(address from, address to, uint256 value) public returns (bool);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     uint8 public decimals;
142 }
143 
144 contract Bussiness is Ownable {
145 
146     using SafeMath for uint256;
147     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
148     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
149     uint256 public Percen = 1000;
150     uint256 public HBWALLETExchange = 21;
151     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
152     // uint256 public hightLightFee = 30000000000000000;
153 
154     struct Price {
155         address payable tokenOwner;
156         uint256 price;
157         uint256 fee;
158         uint256 hbfee;
159         bool isHightlight;
160     }
161     // new code =======================
162     struct Game {
163         mapping(uint256 => Price) tokenPrice;
164         uint[] tokenIdSale;
165         uint256 ETHFee;
166         uint256 limitETHFee;
167         uint256 limitHBWALLETFee;
168         uint256 hightLightFee;
169     }
170 
171     mapping(address => Game) public Games;
172     address[] arrGames;
173     constructor() public {
174         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
175         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
176         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
177         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
178         arrGames.push(address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B));
179 
180         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
181         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
182         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
183         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
184         arrGames.push(address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea));
185 
186         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
187         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
188         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
189         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
190         arrGames.push(address(0x273f7F8E6489682Df756151F5525576E322d51A3));
191 
192         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
193         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
194         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
195         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
196         arrGames.push(address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d));
197 
198         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
199         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
200         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
201         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
202         arrGames.push(address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392));
203 
204         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
205         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
206         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
207         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
208         arrGames.push(address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f));
209 
210         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
211         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
212         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
213         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
214         arrGames.push(address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340));
215 
216         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
217         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
218         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
219         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
220         arrGames.push(address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b));
221 
222         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
223         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
224         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
225         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
226         arrGames.push(address(0xf26A23019b4699068bb54457f32dAFCF22A9D371));
227 
228         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
229         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
230         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
231         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
232         arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
233     }
234     
235     function getTokenPrice(address _game, uint256 _tokenId) public view returns (address, uint256, uint256, uint256, bool) {
236         return (Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee, Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight);
237     }
238     // new code =======================
239     /**
240      * @dev Throws if called by any account other than the ceo address.
241      */
242     modifier onlyCeoAddress() {
243         require(msg.sender == ceoAddress);
244         _;
245     }
246     modifier isOwnerOf(address _game, uint256 _tokenId) {
247         IERC721 erc721Address = IERC721(_game);
248         require(erc721Address.ownerOf(_tokenId) == msg.sender);
249         _;
250     }
251     
252     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
253         IERC721 erc721Address = IERC721(_game);
254         return erc721Address.ownerOf(_tokenId);
255     }
256 
257     function balanceOf() public view returns (uint256){
258         return address(this).balance;
259     }
260 
261     function getApproved(address _game, uint256 _tokenId) public view returns (address){
262         IERC721 erc721Address = IERC721(_game);
263         return erc721Address.getApproved(_tokenId);
264     }
265 
266     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {
267         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
268         Games[_game].tokenIdSale.push(_tokenId);
269         bool flag = false;
270         for(uint i = 0; i< arrGames.length; i++) {
271             if(arrGames[i] == address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)) flag = true;
272         }
273         if(!flag) arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
274     }
275 
276     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
277         uint256 ethfee;
278         uint256 _hightLightFee = 0;
279         uint256 ethNeed;
280         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
281             _hightLightFee = Games[_game].hightLightFee;
282         }
283         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
284             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
285             if(Games[_game].tokenPrice[_tokenId].price == 0) {
286                 if (ethfee >= Games[_game].limitETHFee) {
287                     ethNeed = ethfee.add(_hightLightFee);
288                 } else {
289                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
290                 }
291             }
292 
293         }
294         return (ethNeed, _hightLightFee);
295     }
296     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
297         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
298         uint256 ethfee;
299         uint256 _hightLightFee = 0;
300         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
301             _hightLightFee = Games[_game].hightLightFee;
302         }
303         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
304             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
305             if(Games[_game].tokenPrice[_tokenId].price == 0) {
306                 if (ethfee >= Games[_game].limitETHFee) {
307                     require(msg.value == ethfee.add(_hightLightFee));
308                 } else {
309                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
310                     ethfee = Games[_game].limitETHFee;
311                 }
312             }
313             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
314         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
315 
316         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);
317     }
318     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
319         uint fee;
320         uint256 ethfee;
321         uint _hightLightFee = 0;
322         uint hbNeed;
323         address local_game = _game;
324         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
325             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
326             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
327         }
328         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
329             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
330             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
331             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
332             if(Games[_game].tokenPrice[_tokenId].price == 0) {
333                 if (fee >= Games[_game].limitHBWALLETFee) {
334                     hbNeed = fee.add(_hightLightFee);
335                 } else {
336                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
337                 }
338             }
339         }
340         return hbNeed;
341     }
342     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
343         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
344         uint fee;
345         uint256 ethfee;
346         uint _hightLightFee = 0;
347         address local_game = _game;
348         uint256 local_tokenId = _tokenId;
349         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
350             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
351         }
352         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
353             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
354             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
355             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
356             if(Games[_game].tokenPrice[_tokenId].price == 0) {
357                 if (fee >= Games[_game].limitHBWALLETFee) {
358                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
359                 } else {
360                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
361                     fee = Games[_game].limitHBWALLETFee;
362                 }
363             }
364             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
365         } else {
366             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
367             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
368         }
369 
370         setPrice(_game, _tokenId, _ethPrice, 0, fee, _isHightLight == 1);
371     }
372 
373     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
374         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
375         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
376         resetPrice(_game, _tokenId);
377         return Games[_game].tokenPrice[_tokenId].price;
378     }
379 
380     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
381         require(_HBWALLETExchange >= 1);
382 
383         HBWALLETExchange = _HBWALLETExchange;
384 
385         return (HBWALLETExchange);
386     }
387 
388     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
389         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
390         Games[_game].ETHFee = _ethFee;
391         Games[_game].limitETHFee = _ethlimitFee;
392         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
393         Games[_game].hightLightFee = _hightLightFee;
394         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
395     }
396 
397     function _withdraw(uint256 amount, uint256 _amountHB) internal {
398         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
399         if(amount > 0) {
400             msg.sender.transfer(amount);
401         }
402         if(_amountHB > 0) {
403             hbwalletToken.transfer(msg.sender, _amountHB);
404         }
405     }
406     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
407         _withdraw(amount, _amountHB);
408     }
409     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
410         IERC721 erc721Address = IERC721(_game);
411         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
412             if (Games[_game].tokenPrice[_tokenId].fee > 0) {
413                 uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
414                 if(Games[_game].tokenPrice[_tokenId].isHightlight == true) eth = eth.add(Games[_game].hightLightFee);
415                 if(address(this).balance >= eth) {
416                     Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
417                 }
418             }
419             else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) {
420                 uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
421                 if(Games[_game].tokenPrice[_tokenId].isHightlight == true) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
422                 if(hbwalletToken.balanceOf(address(this)) >= hb) {
423                     hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
424                 }
425             }
426         }
427     }
428     function cancelBussinessByGame(address _game) private onlyCeoAddress {
429         for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
430             cancelBussinessByGameId(_game, Games[_game].tokenIdSale[i]);
431         }
432         resetPriceByArr(_game, Games[_game].tokenIdSale);
433     }
434     function cancelBussiness() public onlyCeoAddress {
435         for(uint j = 0; j< arrGames.length; j++) {
436             address _game = arrGames[j];
437             cancelBussinessByGame(_game);
438         }
439         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
440     }
441 
442     function revenue() public view returns (uint256, uint){
443 
444         uint256 ethfee = 0;
445         uint256 hbfee = 0;
446         for(uint j = 0; j< arrGames.length; j++) {
447 
448             address _game = arrGames[j];
449             IERC721 erc721Address = IERC721(arrGames[j]);
450             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
451                 uint256 _tokenId = Games[_game].tokenIdSale[i];
452                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
453                     if (Games[_game].tokenPrice[_tokenId].fee > 0) {
454                         ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
455                         if(Games[_game].tokenPrice[_tokenId].isHightlight == true) ethfee = ethfee.add(Games[_game].hightLightFee);
456                     }
457                     else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) {
458                         hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
459                         if(Games[_game].tokenPrice[_tokenId].isHightlight == true) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
460                     }
461                 }
462             }
463         }
464 
465         uint256 eth = address(this).balance.sub(ethfee);
466         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
467         return (eth, hb);
468     }
469 
470     function changeCeo(address _address) public onlyCeoAddress {
471         require(_address != address(0));
472         ceoAddress = _address;
473 
474     }
475 
476     function buy(address _game, uint256 tokenId) public payable {
477         IERC721 erc721Address = IERC721(_game);
478         require(getApproved(_game, tokenId) == address(this));
479         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
480         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
481         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
482         resetPrice(_game, tokenId);
483     }
484 
485     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
486         IERC721 erc721Address = IERC721(_game);
487         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
488         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
489         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
490         resetPrice(_game, tokenId);
491     }
492     // Move the last element to the deleted spot.
493     // Delete the last element, then correct the length.
494     function _burnArrayTokenIdSale(address _game, uint8 index)  internal {
495         if (index >= Games[_game].tokenIdSale.length) return;
496 
497         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
498             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
499         }
500         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
501         Games[_game].tokenIdSale.length--;
502     }
503     function resetPriceByArr(address _game, uint256[] memory _arrTokenId) private {
504         for (uint8 i = 0; i < _arrTokenId.length; i++) {
505             Games[_game].tokenPrice[_arrTokenId[i]] = Price(address(0), 0, 0, 0, false);
506             if (Games[_game].tokenIdSale[i] == _arrTokenId[i]) {
507                 _burnArrayTokenIdSale(_game, i);
508             }
509         }
510     }
511     function resetPrice(address _game, uint256 _tokenId) private {
512         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, false);
513         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
514             if (Games[_game].tokenIdSale[i] == _tokenId) {
515                 _burnArrayTokenIdSale(_game, i);
516             }
517         }
518     }
519 }