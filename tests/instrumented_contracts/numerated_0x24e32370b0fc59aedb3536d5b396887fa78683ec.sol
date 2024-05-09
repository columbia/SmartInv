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
149     // address public ceoAddress = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);
150     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
151     uint256 public Percen = 1000;
152     uint256 public HBWALLETExchange = 21;
153     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
154     // uint256 public hightLightFee = 30000000000000000;
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
175     address[] arrGames;
176     constructor() public {
177         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
178         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
179         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
180         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
181         arrGames.push(address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B));
182 
183         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
184         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
185         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
186         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
187         arrGames.push(address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea));
188 
189         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
190         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
191         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
192         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
193         arrGames.push(address(0x273f7F8E6489682Df756151F5525576E322d51A3));
194 
195         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
196         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
197         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
198         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
199         arrGames.push(address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d));
200 
201         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
202         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
203         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
204         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
205         arrGames.push(address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392));
206 
207         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
208         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
209         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
210         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
211         arrGames.push(address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f));
212 
213         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
214         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
215         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
216         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
217         arrGames.push(address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340));
218 
219         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
220         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
221         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
222         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
223         arrGames.push(address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b));
224 
225         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
226         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
227         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
228         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
229         arrGames.push(address(0xf26A23019b4699068bb54457f32dAFCF22A9D371));
230 
231         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
232         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
233         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
234         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
235         arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
236         
237         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 0;
238         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 0;
239         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 0;
240         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 30000000000000000;
241         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
242     }
243     
244     function getTokenPrice(address _game, uint256 _tokenId) public view returns (address, uint256, uint256, uint256, uint, uint) {
245         return (Games[_game].tokenPrice[_tokenId].tokenOwner, 
246         Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee, 
247         Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight, 
248         Games[_game].tokenPrice[_tokenId].isHightlightByHb);
249     }
250     // new code =======================
251     /**
252      * @dev Throws if called by any account other than the ceo address.
253      */
254     modifier onlyCeoAddress() {
255         require(msg.sender == ceoAddress);
256         _;
257     }
258     modifier isOwnerOf(address _game, uint256 _tokenId) {
259         IERC721 erc721Address = IERC721(_game);
260         require(erc721Address.ownerOf(_tokenId) == msg.sender);
261         _;
262     }
263     
264     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
265         IERC721 erc721Address = IERC721(_game);
266         return erc721Address.ownerOf(_tokenId);
267     }
268 
269     function balanceOf() public view returns (uint256){
270         return address(this).balance;
271     }
272 
273     function getApproved(address _game, uint256 _tokenId) public view returns (address){
274         IERC721 erc721Address = IERC721(_game);
275         return erc721Address.getApproved(_tokenId);
276     }
277 
278     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
279         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
280         Games[_game].tokenIdSale.push(_tokenId);
281         bool flag = false;
282         for(uint i = 0; i< arrGames.length; i++) {
283             if(arrGames[i] == address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)) flag = true;
284         }
285         if(!flag) arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
286     }
287 
288     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
289         uint256 ethfee;
290         uint256 _hightLightFee = 0;
291         uint256 ethNeed;
292         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
293             _hightLightFee = Games[_game].hightLightFee;
294         }
295         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
296             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
297             if(Games[_game].tokenPrice[_tokenId].price == 0) {
298                 if (ethfee >= Games[_game].limitETHFee) {
299                     ethNeed = ethfee.add(_hightLightFee);
300                 } else {
301                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
302                 }
303             }
304 
305         }
306         return (ethNeed, _hightLightFee);
307     }
308     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
309         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
310         uint256 ethfee;
311         uint256 _hightLightFee = 0;
312         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
313             _hightLightFee = Games[_game].hightLightFee;
314         }
315         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
316             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
317             if(Games[_game].tokenPrice[_tokenId].price == 0) {
318                 if (ethfee >= Games[_game].limitETHFee) {
319                     require(msg.value == ethfee.add(_hightLightFee));
320                 } else {
321                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
322                     ethfee = Games[_game].limitETHFee;
323                 }
324             }
325             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
326         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
327 
328         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
329     }
330     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
331         uint fee;
332         uint256 ethfee;
333         uint _hightLightFee = 0;
334         uint hbNeed;
335         address local_game = _game;
336         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
337             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
338             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
339         }
340         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
341             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
342             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
343             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
344             if(Games[_game].tokenPrice[_tokenId].price == 0) {
345                 if (fee >= Games[_game].limitHBWALLETFee) {
346                     hbNeed = fee.add(_hightLightFee);
347                 } else {
348                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
349                 }
350             }
351         }
352         return hbNeed;
353     }
354     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
355         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
356         uint fee;
357         uint256 ethfee;
358         uint _hightLightFee = 0;
359         address local_game = _game;
360         uint256 local_tokenId = _tokenId;
361         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
362             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
363         }
364         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
365             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
366             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
367             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
368             if(Games[_game].tokenPrice[_tokenId].price == 0) {
369                 if (fee >= Games[_game].limitHBWALLETFee) {
370                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
371                 } else {
372                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
373                     fee = Games[_game].limitHBWALLETFee;
374                 }
375             }
376             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
377         } else {
378             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
379             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
380         }
381 
382         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
383     }
384 
385     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
386         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
387         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
388         resetPrice(_game, _tokenId);
389         return Games[_game].tokenPrice[_tokenId].price;
390     }
391 
392     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
393         require(_HBWALLETExchange >= 1);
394 
395         HBWALLETExchange = _HBWALLETExchange;
396 
397         return (HBWALLETExchange);
398     }
399 
400     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
401         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
402         Games[_game].ETHFee = _ethFee;
403         Games[_game].limitETHFee = _ethlimitFee;
404         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
405         Games[_game].hightLightFee = _hightLightFee;
406         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
407     }
408 
409     function _withdraw(uint256 amount, uint256 _amountHB) internal {
410         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
411         if(amount > 0) {
412             msg.sender.transfer(amount);
413         }
414         if(_amountHB > 0) {
415             hbwalletToken.transfer(msg.sender, _amountHB);
416         }
417     }
418     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
419         _withdraw(amount, _amountHB);
420     }
421     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
422         IERC721 erc721Address = IERC721(_game);
423         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
424             
425             uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
426             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
427             if(eth > 0 && address(this).balance >= eth) {
428                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
429             }
430              
431             uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
432             if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
433             if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
434                 hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
435             }
436             
437         }
438     }
439     function cancelBussinessByGame(address _game) private onlyCeoAddress {
440         for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
441             cancelBussinessByGameId(_game, Games[_game].tokenIdSale[i]);
442         }
443             
444     }
445     function cancelBussiness() public onlyCeoAddress {
446         for(uint j = 0; j< arrGames.length; j++) {
447             address _game = arrGames[j];
448             cancelBussinessByGame(_game);
449         }
450         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
451     }
452     function removePriceByCeo() public onlyCeoAddress {
453         for(uint j = 0; j< arrGames.length; j++) {
454             resetPriceByArr(arrGames[j]);
455         }
456         
457     }
458     // function testrevenue(address _game) public view returns (uint256, bool, bool, uint256){
459     //     uint256 ethfee;
460     //     uint256 hbfee;
461     //     address local_game = _game;
462         
463     //     IERC721 erc721Address = IERC721(_game);
464     //     for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
465     //         uint256 _tokenId = Games[_game].tokenIdSale[i];
466     //         if (Games[local_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
467     //             if (Games[local_game].tokenPrice[_tokenId].fee >= 0) {
468     //                 ethfee = ethfee.add(Games[local_game].tokenPrice[_tokenId].fee);
469     //                 if(Games[local_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[local_game].hightLightFee);
470     //             }
471     //             else if (Games[local_game].tokenPrice[_tokenId].hbfee >= 0) {
472     //                 hbfee = hbfee.add(Games[local_game].tokenPrice[_tokenId].hbfee);
473     //                 if(Games[local_game].tokenPrice[_tokenId].isHightlight == 1) hbfee = hbfee.add(Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
474     //             }
475     //         }
476     //         if(i== Games[local_game].tokenIdSale.length-1) {
477     //             uint256 eth = address(this).balance;
478     //             uint256 hb = hbwalletToken.balanceOf(address(this));
479     //             return (ethfee, Games[local_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId), 
480     //             Games[local_game].tokenPrice[_tokenId].fee >= 0, ethfee.add(Games[local_game].hightLightFee));
481     //         }
482     //     }
483         
484     // }
485     function revenue() public view returns (uint256, uint){
486 
487         uint256 ethfee;
488         uint256 hbfee;
489         for(uint j = 0; j< arrGames.length; j++) {
490 
491             address _game = arrGames[j];
492             IERC721 erc721Address = IERC721(arrGames[j]);
493             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
494                 uint256 _tokenId = Games[_game].tokenIdSale[i];
495                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
496                     
497                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
498                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
499 
500                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
501                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
502 
503                 }
504             }
505         }
506 
507         uint256 eth = address(this).balance.sub(ethfee);
508         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
509         return (eth, hb);
510     }
511 
512     function changeCeo(address _address) public onlyCeoAddress {
513         require(_address != address(0));
514         ceoAddress = _address;
515 
516     }
517 
518     function buy(address _game, uint256 tokenId) public payable {
519         IERC721 erc721Address = IERC721(_game);
520         require(getApproved(_game, tokenId) == address(this));
521         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
522         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
523         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
524         resetPrice(_game, tokenId);
525     }
526 
527     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
528         IERC721 erc721Address = IERC721(_game);
529         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
530         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
531         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
532         resetPrice(_game, tokenId);
533     }
534     // Move the last element to the deleted spot.
535     // Delete the last element, then correct the length.
536     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
537         if (index >= Games[_game].tokenIdSale.length) return;
538 
539         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
540             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
541         }
542         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
543         Games[_game].tokenIdSale.length--;
544     }
545     function resetPriceByArr(address _game) private {
546         for (uint256 i = 0; i < Games[_game].tokenIdSale.length; i++) {
547             Games[_game].tokenPrice[Games[_game].tokenIdSale[i]] = Price(address(0), 0, 0, 0, 0, 0);
548             if(i<Games[_game].tokenIdSale.length) {
549                 for (uint j = i; j<Games[_game].tokenIdSale.length-1; j++){
550                     Games[_game].tokenIdSale[j] = Games[_game].tokenIdSale[j+1];
551                 }
552                 delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
553                 Games[_game].tokenIdSale.length--;
554             }
555         }
556     }
557     function resetPrice(address _game, uint256 _tokenId) private {
558         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
559         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
560             if (Games[_game].tokenIdSale[i] == _tokenId) {
561                 _burnArrayTokenIdSale(_game, i);
562             }
563         }
564     }
565 }