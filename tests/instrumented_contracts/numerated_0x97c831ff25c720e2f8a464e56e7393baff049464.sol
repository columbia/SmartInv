1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 23, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.8;
6 
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0); // Solidity only automatically asserts when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72     address public owner;
73 
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         require(newOwner != address(0));
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102     }
103 
104 }
105 
106 contract IERC721 {
107     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
108     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
110 
111     function balanceOf(address owner) public view returns (uint256 balance);
112 
113     function ownerOf(uint256 tokenId) public view returns (address owner);
114 
115     function approve(address to, uint256 tokenId) public;
116 
117     function getApproved(uint256 tokenId) public view returns (address operator);
118 
119     function setApprovalForAll(address operator, bool _approved) public;
120 
121     function isApprovedForAll(address owner, address operator) public view returns (bool);
122     
123     function transfer(address to, uint256 tokenId) public;
124 
125     function transferFrom(address from, address to, uint256 tokenId) public;
126 
127     function safeTransferFrom(address from, address to, uint256 tokenId) public;
128 
129     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
130 }
131 /**
132  * @title ERC20Basic
133  * @dev Simpler version of ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/179
135  */
136 contract ERC20BasicInterface {
137     function totalSupply() public view returns (uint256);
138 
139     function balanceOf(address who) public view returns (uint256);
140 
141     function transfer(address to, uint256 value) public returns (bool);
142 
143     function transferFrom(address from, address to, uint256 value) public returns (bool);
144 
145     event Transfer(address indexed from, address indexed to, uint256 value);
146 
147     uint8 public decimals;
148 }
149 
150 contract Bussiness is Ownable {
151 
152     using SafeMath for uint256;
153     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
154     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
155     // address public ceoAddress = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);
156     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
157     uint256 public Percen = 1000;
158     uint256 public HBWALLETExchange = 21;
159     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
160     // uint256 public hightLightFee = 30000000000000000;
161 
162     struct Price {
163         address payable tokenOwner;
164         uint256 price;
165         uint256 fee;
166         uint256 hbfee;
167         uint isHightlight;
168         uint isHightlightByHb;
169     }
170     // new code =======================
171     struct Game {
172         mapping(uint256 => Price) tokenPrice;
173         uint[] tokenIdSale;
174         uint256 ETHFee;
175         uint256 limitETHFee;
176         uint256 limitHBWALLETFee;
177         uint256 hightLightFee;
178     }
179 
180     mapping(address => Game) public Games;
181     address[] arrGames;
182     constructor() public {
183         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
184         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
185         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
186         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
187         arrGames.push(address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B));
188 
189         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
190         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
191         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
192         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
193         arrGames.push(address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea));
194 
195         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
196         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
197         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
198         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
199         arrGames.push(address(0x273f7F8E6489682Df756151F5525576E322d51A3));
200 
201         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
202         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
203         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
204         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
205         arrGames.push(address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d));
206 
207         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
208         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
209         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
210         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
211         arrGames.push(address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392));
212 
213         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
214         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
215         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
216         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
217         arrGames.push(address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f));
218 
219         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
220         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
221         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
222         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
223         arrGames.push(address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340));
224 
225         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
226         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
227         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
228         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
229         arrGames.push(address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b));
230 
231         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
232         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
233         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
234         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
235         arrGames.push(address(0xf26A23019b4699068bb54457f32dAFCF22A9D371));
236 
237         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
238         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
239         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
240         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
241         arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
242 
243         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 0;
244         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 0;
245         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 0;
246         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 30000000000000000;
247         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
248     }
249 
250     function getTokenPrice(address _game, uint256 _tokenId) public returns (address owner, uint256 price, uint256 fee, uint256 hbfee, uint isHightlight, uint isHBHightlight) {
251         IERC721 erc721Address = IERC721(_game);
252         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner) resetPrice(_game, _tokenId);
253         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
254         Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee,
255         Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight,
256         Games[_game].tokenPrice[_tokenId].isHightlightByHb);
257     }
258     // new code =======================
259     /**
260      * @dev Throws if called by any account other than the ceo address.
261      */
262     modifier onlyCeoAddress() {
263         require(msg.sender == ceoAddress);
264         _;
265     }
266     modifier isOwnerOf(address _game, uint256 _tokenId) {
267         IERC721 erc721Address = IERC721(_game);
268         require(erc721Address.ownerOf(_tokenId) == msg.sender);
269         _;
270     }
271 
272     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
273         IERC721 erc721Address = IERC721(_game);
274         return erc721Address.ownerOf(_tokenId);
275     }
276 
277     function balanceOf() public view returns (uint256){
278         return address(this).balance;
279     }
280 
281     function getApproved(address _game, uint256 _tokenId) public view returns (address){
282         IERC721 erc721Address = IERC721(_game);
283         return erc721Address.getApproved(_tokenId);
284     }
285     function addGame(address _game, uint256 _ETHFee, uint256 _limitETHFee, uint256 _limitHBWALLETFee, uint256 _hightLightFee) public {
286         Games[_game].ETHFee = _ETHFee;
287         Games[_game].limitETHFee = _limitETHFee;
288         Games[_game].limitHBWALLETFee = _limitHBWALLETFee;
289         Games[_game].hightLightFee = _hightLightFee;
290         arrGames.push(_game);
291     }
292     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
293         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
294         Games[_game].tokenIdSale.push(_tokenId);
295         bool flag = false;
296         for(uint i = 0; i< arrGames.length; i++) {
297             if(arrGames[i] == _game) flag = true;
298         }
299         if(!flag) arrGames.push(_game);
300     }
301 
302     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
303         uint256 ethfee;
304         uint256 _hightLightFee = 0;
305         uint256 ethNeed;
306         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
307             _hightLightFee = Games[_game].hightLightFee;
308         }
309         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
310             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
311             if(Games[_game].tokenPrice[_tokenId].price == 0) {
312                 if (ethfee >= Games[_game].limitETHFee) {
313                     ethNeed = ethfee.add(_hightLightFee);
314                 } else {
315                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
316                 }
317             }
318 
319         }
320         return (ethNeed, _hightLightFee);
321     }
322     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
323         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
324         uint256 ethfee;
325         uint256 _hightLightFee = 0;
326         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
327             _hightLightFee = Games[_game].hightLightFee;
328         }
329         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
330             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
331             if(Games[_game].tokenPrice[_tokenId].price == 0) {
332                 if (ethfee >= Games[_game].limitETHFee) {
333                     require(msg.value == ethfee.add(_hightLightFee));
334                 } else {
335                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
336                     ethfee = Games[_game].limitETHFee;
337                 }
338             }
339             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
340         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
341 
342         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
343     }
344     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
345         uint fee;
346         uint256 ethfee;
347         uint _hightLightFee = 0;
348         uint hbNeed;
349         address local_game = _game;
350         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
351             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
352             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
353         }
354         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
355             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
356             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
357             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
358             if(Games[_game].tokenPrice[_tokenId].price == 0) {
359                 if (fee >= Games[_game].limitHBWALLETFee) {
360                     hbNeed = fee.add(_hightLightFee);
361                 } else {
362                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
363                 }
364             }
365         }
366         return hbNeed;
367     }
368     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
369         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
370         uint fee;
371         uint256 ethfee;
372         uint _hightLightFee = 0;
373         address local_game = _game;
374         uint256 local_tokenId = _tokenId;
375         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
376             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
377         }
378         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
379             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
380             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
381             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
382             if(Games[_game].tokenPrice[_tokenId].price == 0) {
383                 if (fee >= Games[_game].limitHBWALLETFee) {
384                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
385                 } else {
386                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
387                     fee = Games[_game].limitHBWALLETFee;
388                 }
389             }
390             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
391         } else {
392             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
393             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
394         }
395 
396         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
397     }
398 
399     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
400         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
401         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
402         resetPrice(_game, _tokenId);
403         return Games[_game].tokenPrice[_tokenId].price;
404     }
405 
406     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
407         require(_HBWALLETExchange >= 1);
408 
409         HBWALLETExchange = _HBWALLETExchange;
410 
411         return (HBWALLETExchange);
412     }
413 
414     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
415         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
416         Games[_game].ETHFee = _ethFee;
417         Games[_game].limitETHFee = _ethlimitFee;
418         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
419         Games[_game].hightLightFee = _hightLightFee;
420         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
421     }
422 
423     function _withdraw(uint256 amount, uint256 _amountHB) internal {
424         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
425         if(amount > 0) {
426             msg.sender.transfer(amount);
427         }
428         if(_amountHB > 0) {
429             hbwalletToken.transfer(msg.sender, _amountHB);
430         }
431     }
432     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
433         _withdraw(amount, _amountHB);
434     }
435     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
436         IERC721 erc721Address = IERC721(_game);
437         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
438 
439             uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
440             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
441             if(eth > 0 && address(this).balance >= eth) {
442                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
443             }
444 
445             uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
446             if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
447             if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
448                 hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
449             }
450             resetPrice(_game, _tokenId);
451         }
452     }
453     function cancelBussinessByGame(address _game) private onlyCeoAddress {
454         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
455         for (uint i = 0; i < _arrTokenId.length; i++) {
456             cancelBussinessByGameId(_game, _arrTokenId[i]);
457         }
458 
459     }
460     function cancelBussiness() public onlyCeoAddress {
461         for(uint j = 0; j< arrGames.length; j++) {
462             address _game = arrGames[j];
463             cancelBussinessByGame(_game);
464         }
465         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
466     }
467     
468     function revenue() public view returns (uint256, uint){
469 
470         uint256 ethfee;
471         uint256 hbfee;
472         for(uint j = 0; j< arrGames.length; j++) {
473 
474             address _game = arrGames[j];
475             IERC721 erc721Address = IERC721(arrGames[j]);
476             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
477                 uint256 _tokenId = Games[_game].tokenIdSale[i];
478                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
479 
480                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
481                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
482 
483                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
484                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
485 
486                 }
487             }
488         }
489 
490         uint256 eth = address(this).balance.sub(ethfee);
491         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
492         return (eth, hb);
493     }
494 
495     function changeCeo(address _address) public onlyCeoAddress {
496         require(_address != address(0));
497         ceoAddress = _address;
498 
499     }
500 
501     function buy(address _game, uint256 tokenId) public payable {
502         IERC721 erc721Address = IERC721(_game);
503         require(getApproved(_game, tokenId) == address(this));
504         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
505         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
506         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
507         resetPrice(_game, tokenId);
508     }
509 
510     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
511         IERC721 erc721Address = IERC721(_game);
512         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
513         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
514         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
515         resetPrice(_game, tokenId);
516     }
517     
518     function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
519         IERC721 erc721Address = IERC721(_game);
520         require(Games[_game].tokenPrice[_tokenId].price > 0 && Games[_game].tokenPrice[_tokenId].price == msg.value);
521         require(erc721Address.ownerOf(_tokenId) == address(this));
522         erc721Address.transfer(msg.sender, _tokenId);
523         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
524         resetPrice(_game, _tokenId);
525     }
526     // Move the last element to the deleted spot.
527     // Delete the last element, then correct the length.
528     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
529         if (index >= Games[_game].tokenIdSale.length) return;
530 
531         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
532             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
533         }
534         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
535         Games[_game].tokenIdSale.length--;
536     }
537 
538     function resetPrice(address _game, uint256 _tokenId) private {
539         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
540         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
541             if (Games[_game].tokenIdSale[i] == _tokenId) {
542                 _burnArrayTokenIdSale(_game, i);
543             }
544         }
545     }
546 }