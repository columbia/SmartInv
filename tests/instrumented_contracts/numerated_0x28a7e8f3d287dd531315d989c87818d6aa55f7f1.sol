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
159         uint isHightlight;
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
233         
234         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 0;
235         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 0;
236         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 0;
237         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 30000000000000000;
238         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
239     }
240     
241     function getTokenPrice(address _game, uint256 _tokenId) public view returns (address, uint256, uint256, uint256, uint) {
242         return (Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee, Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight);
243     }
244     // new code =======================
245     /**
246      * @dev Throws if called by any account other than the ceo address.
247      */
248     modifier onlyCeoAddress() {
249         require(msg.sender == ceoAddress);
250         _;
251     }
252     modifier isOwnerOf(address _game, uint256 _tokenId) {
253         IERC721 erc721Address = IERC721(_game);
254         require(erc721Address.ownerOf(_tokenId) == msg.sender);
255         _;
256     }
257     
258     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
259         IERC721 erc721Address = IERC721(_game);
260         return erc721Address.ownerOf(_tokenId);
261     }
262 
263     function balanceOf() public view returns (uint256){
264         return address(this).balance;
265     }
266 
267     function getApproved(address _game, uint256 _tokenId) public view returns (address){
268         IERC721 erc721Address = IERC721(_game);
269         return erc721Address.getApproved(_tokenId);
270     }
271 
272     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight) internal {
273         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
274         Games[_game].tokenIdSale.push(_tokenId);
275         bool flag = false;
276         for(uint i = 0; i< arrGames.length; i++) {
277             if(arrGames[i] == address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)) flag = true;
278         }
279         if(!flag) arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
280     }
281 
282     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
283         uint256 ethfee;
284         uint256 _hightLightFee = 0;
285         uint256 ethNeed;
286         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
287             _hightLightFee = Games[_game].hightLightFee;
288         }
289         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
290             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
291             if(Games[_game].tokenPrice[_tokenId].price == 0) {
292                 if (ethfee >= Games[_game].limitETHFee) {
293                     ethNeed = ethfee.add(_hightLightFee);
294                 } else {
295                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
296                 }
297             }
298 
299         }
300         return (ethNeed, _hightLightFee);
301     }
302     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
303         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
304         uint256 ethfee;
305         uint256 _hightLightFee = 0;
306         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
307             _hightLightFee = Games[_game].hightLightFee;
308         }
309         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
310             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
311             if(Games[_game].tokenPrice[_tokenId].price == 0) {
312                 if (ethfee >= Games[_game].limitETHFee) {
313                     require(msg.value == ethfee.add(_hightLightFee));
314                 } else {
315                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
316                     ethfee = Games[_game].limitETHFee;
317                 }
318             }
319             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
320         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
321 
322         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight);
323     }
324     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
325         uint fee;
326         uint256 ethfee;
327         uint _hightLightFee = 0;
328         uint hbNeed;
329         address local_game = _game;
330         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
331             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
332             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
333         }
334         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
335             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
336             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
337             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
338             if(Games[_game].tokenPrice[_tokenId].price == 0) {
339                 if (fee >= Games[_game].limitHBWALLETFee) {
340                     hbNeed = fee.add(_hightLightFee);
341                 } else {
342                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
343                 }
344             }
345         }
346         return hbNeed;
347     }
348     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
349         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
350         uint fee;
351         uint256 ethfee;
352         uint _hightLightFee = 0;
353         address local_game = _game;
354         uint256 local_tokenId = _tokenId;
355         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
356             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
357         }
358         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
359             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
360             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
361             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
362             if(Games[_game].tokenPrice[_tokenId].price == 0) {
363                 if (fee >= Games[_game].limitHBWALLETFee) {
364                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
365                 } else {
366                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
367                     fee = Games[_game].limitHBWALLETFee;
368                 }
369             }
370             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
371         } else {
372             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
373             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
374         }
375 
376         setPrice(_game, _tokenId, _ethPrice, 0, fee, _isHightLight);
377     }
378 
379     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
380         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
381         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
382         resetPrice(_game, _tokenId);
383         return Games[_game].tokenPrice[_tokenId].price;
384     }
385 
386     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
387         require(_HBWALLETExchange >= 1);
388 
389         HBWALLETExchange = _HBWALLETExchange;
390 
391         return (HBWALLETExchange);
392     }
393 
394     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
395         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
396         Games[_game].ETHFee = _ethFee;
397         Games[_game].limitETHFee = _ethlimitFee;
398         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
399         Games[_game].hightLightFee = _hightLightFee;
400         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
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
417         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
418             if (Games[_game].tokenPrice[_tokenId].fee >= 0) {
419                 uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
420                 if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
421                 if(address(this).balance >= eth) {
422                     Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
423                 }
424             }
425             else if (Games[_game].tokenPrice[_tokenId].hbfee >= 0) {
426                 uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
427                 if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
428                 if(hbwalletToken.balanceOf(address(this)) >= hb) {
429                     hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
430                 }
431             }
432         }
433     }
434     function cancelBussinessByGame(address _game) private onlyCeoAddress {
435         for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
436             cancelBussinessByGameId(_game, Games[_game].tokenIdSale[i]);
437         }
438         resetPriceByArr(_game, Games[_game].tokenIdSale);
439             
440     }
441     function cancelBussiness() public onlyCeoAddress {
442         for(uint j = 0; j< arrGames.length; j++) {
443             address _game = arrGames[j];
444             cancelBussinessByGame(_game);
445         }
446         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
447     }
448     // function testrevenue(address _game) public view returns (uint256, bool, bool, uint256){
449     //     uint256 ethfee;
450     //     uint256 hbfee;
451     //     address local_game = _game;
452         
453     //     IERC721 erc721Address = IERC721(_game);
454     //     for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
455     //         uint256 _tokenId = Games[_game].tokenIdSale[i];
456     //         if (Games[local_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
457     //             if (Games[local_game].tokenPrice[_tokenId].fee >= 0) {
458     //                 ethfee = ethfee.add(Games[local_game].tokenPrice[_tokenId].fee);
459     //                 if(Games[local_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[local_game].hightLightFee);
460     //             }
461     //             else if (Games[local_game].tokenPrice[_tokenId].hbfee >= 0) {
462     //                 hbfee = hbfee.add(Games[local_game].tokenPrice[_tokenId].hbfee);
463     //                 if(Games[local_game].tokenPrice[_tokenId].isHightlight == 1) hbfee = hbfee.add(Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
464     //             }
465     //         }
466     //         if(i== Games[local_game].tokenIdSale.length-1) {
467     //             uint256 eth = address(this).balance;
468     //             uint256 hb = hbwalletToken.balanceOf(address(this));
469     //             return (ethfee, Games[local_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId), 
470     //             Games[local_game].tokenPrice[_tokenId].fee >= 0, ethfee.add(Games[local_game].hightLightFee));
471     //         }
472     //     }
473         
474     // }
475     function revenue() public view returns (uint256, uint){
476 
477         uint256 ethfee;
478         uint256 hbfee;
479         for(uint j = 0; j< arrGames.length; j++) {
480 
481             address _game = arrGames[j];
482             IERC721 erc721Address = IERC721(arrGames[j]);
483             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
484                 uint256 _tokenId = Games[_game].tokenIdSale[i];
485                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
486                     if (Games[_game].tokenPrice[_tokenId].fee >= 0) {
487                         ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
488                         if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
489                     }
490                     else if (Games[_game].tokenPrice[_tokenId].hbfee >= 0) {
491                         hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
492                         if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
493                     }
494                 }
495             }
496         }
497 
498         uint256 eth = address(this).balance.sub(ethfee);
499         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
500         return (eth, hb);
501     }
502 
503     function changeCeo(address _address) public onlyCeoAddress {
504         require(_address != address(0));
505         ceoAddress = _address;
506 
507     }
508 
509     function buy(address _game, uint256 tokenId) public payable {
510         IERC721 erc721Address = IERC721(_game);
511         require(getApproved(_game, tokenId) == address(this));
512         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
513         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
514         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
515         resetPrice(_game, tokenId);
516     }
517 
518     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
519         IERC721 erc721Address = IERC721(_game);
520         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
521         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
522         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
523         resetPrice(_game, tokenId);
524     }
525     // Move the last element to the deleted spot.
526     // Delete the last element, then correct the length.
527     function _burnArrayTokenIdSale(address _game, uint8 index)  internal {
528         if (index >= Games[_game].tokenIdSale.length) return;
529 
530         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
531             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
532         }
533         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
534         Games[_game].tokenIdSale.length--;
535     }
536     function resetPriceByArr(address _game, uint256[] memory _arrTokenId) private {
537         for (uint8 i = 0; i < _arrTokenId.length; i++) {
538             Games[_game].tokenPrice[_arrTokenId[i]] = Price(address(0), 0, 0, 0, 0);
539             if (Games[_game].tokenIdSale[i] == _arrTokenId[i]) {
540                 _burnArrayTokenIdSale(_game, i);
541             }
542         }
543     }
544     function resetPrice(address _game, uint256 _tokenId) private {
545         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0);
546         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
547             if (Games[_game].tokenIdSale[i] == _tokenId) {
548                 _burnArrayTokenIdSale(_game, i);
549             }
550         }
551     }
552 }