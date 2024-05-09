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
151     // address public ceoAddress = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);
152     // ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0x91013928b1C4dbd0D5cB21BA5b052BfD840A7a7F);
153     uint256 public Percen = 1000;
154     uint256 public HBWALLETExchange = 21;
155     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
156     // uint256 public hightLightFee = 30000000000000000;
157 
158     struct Price {
159         address payable tokenOwner;
160         uint256 price;
161         uint256 fee;
162         uint256 hbfee;
163         uint isHightlight;
164         uint isHightlightByHb;
165     }
166     // new code =======================
167     struct Game {
168         mapping(uint256 => Price) tokenPrice;
169         uint[] tokenIdSale;
170         uint256 ETHFee;
171         uint256 limitETHFee;
172         uint256 limitHBWALLETFee;
173         uint256 hightLightFee;
174     }
175 
176     mapping(address => Game) public Games;
177     address[] public arrGames;
178     constructor() public {
179         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
180         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
181         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
182         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
183         arrGames.push(address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B));
184 
185         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
186         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
187         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
188         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
189         arrGames.push(address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea));
190 
191         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
192         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
193         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
194         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
195         arrGames.push(address(0x273f7F8E6489682Df756151F5525576E322d51A3));
196 
197         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
198         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
199         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
200         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
201         arrGames.push(address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d));
202 
203         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
204         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
205         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
206         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
207         arrGames.push(address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392));
208 
209         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
210         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
211         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
212         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
213         arrGames.push(address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f));
214 
215         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
216         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
217         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
218         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
219         arrGames.push(address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340));
220 
221         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
222         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
223         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
224         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
225         arrGames.push(address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b));
226 
227         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
228         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
229         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
230         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
231         arrGames.push(address(0xf26A23019b4699068bb54457f32dAFCF22A9D371));
232 
233         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
234         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
235         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
236         Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
237         arrGames.push(address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099));
238 
239         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].ETHFee = 0;
240         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitETHFee = 0;
241         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].limitHBWALLETFee = 0;
242         // Games[address(0xac9D8D6dB95828259069226456DDe98d8E296c5f)].hightLightFee = 30000000000000000;
243         // arrGames.push(address(0xac9D8D6dB95828259069226456DDe98d8E296c5f));
244     }
245 
246     function getTokenPrice(address _game, uint256 _tokenId) public returns (address owner, uint256 price, uint256 fee, uint256 hbfee, uint isHightlight, uint isHBHightlight) {
247         IERC721 erc721Address = IERC721(_game);
248         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner 
249         && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
250         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
251         Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee,
252         Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight,
253         Games[_game].tokenPrice[_tokenId].isHightlightByHb);
254     }
255     // new code =======================
256     /**
257      * @dev Throws if called by any account other than the ceo address.
258      */
259     modifier onlyCeoAddress() {
260         require(msg.sender == ceoAddress);
261         _;
262     }
263     modifier isOwnerOf(address _game, uint256 _tokenId) {
264         IERC721 erc721Address = IERC721(_game);
265         require(erc721Address.ownerOf(_tokenId) == msg.sender);
266         _;
267     }
268 
269     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
270         IERC721 erc721Address = IERC721(_game);
271         return erc721Address.ownerOf(_tokenId);
272     }
273 
274     function balanceOf() public view returns (uint256){
275         return address(this).balance;
276     }
277 
278     function getApproved(address _game, uint256 _tokenId) public view returns (address){
279         IERC721 erc721Address = IERC721(_game);
280         return erc721Address.getApproved(_tokenId);
281     }
282     
283     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
284         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
285         Games[_game].tokenIdSale.push(_tokenId);
286         bool flag = false;
287         for(uint i = 0; i< arrGames.length; i++) {
288             if(arrGames[i] == _game) flag = true;
289         }
290         if(!flag) arrGames.push(_game);
291     }
292 
293     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
294         uint256 ethfee;
295         uint256 _hightLightFee = 0;
296         uint256 ethNeed;
297         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
298             _hightLightFee = Games[_game].hightLightFee;
299         }
300         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
301             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
302             if(Games[_game].tokenPrice[_tokenId].price == 0) {
303                 if (ethfee >= Games[_game].limitETHFee) {
304                     ethNeed = ethfee.add(_hightLightFee);
305                 } else {
306                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
307                 }
308             }
309 
310         }
311         return (ethNeed, _hightLightFee);
312     }
313     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
314         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
315         uint256 ethfee;
316         uint256 _hightLightFee = 0;
317         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
318             _hightLightFee = Games[_game].hightLightFee;
319         }
320         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
321             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
322             if(Games[_game].tokenPrice[_tokenId].price == 0) {
323                 if (ethfee >= Games[_game].limitETHFee) {
324                     require(msg.value == ethfee.add(_hightLightFee));
325                 } else {
326                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
327                     ethfee = Games[_game].limitETHFee;
328                 }
329             }
330             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
331         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
332 
333         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
334     }
335     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
336         uint fee;
337         uint256 ethfee;
338         uint _hightLightFee = 0;
339         uint hbNeed;
340         address local_game = _game;
341         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
342             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
343             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
344         }
345         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
346             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
347             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
348             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
349             if(Games[_game].tokenPrice[_tokenId].price == 0) {
350                 if (fee >= Games[_game].limitHBWALLETFee) {
351                     hbNeed = fee.add(_hightLightFee);
352                 } else {
353                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
354                 }
355             }
356         }
357         return hbNeed;
358     }
359     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
360         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
361         uint fee;
362         uint256 ethfee;
363         uint _hightLightFee = 0;
364         address local_game = _game;
365         uint256 local_tokenId = _tokenId;
366         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
367             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
368         }
369         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
370             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
371             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
372             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
373             if(Games[_game].tokenPrice[_tokenId].price == 0) {
374                 if (fee >= Games[_game].limitHBWALLETFee) {
375                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
376                 } else {
377                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
378                     fee = Games[_game].limitHBWALLETFee;
379                 }
380             }
381             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
382         } else {
383             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
384             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
385         }
386 
387         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
388     }
389 
390     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
391         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
392         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
393         if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
394             IERC721 erc721Address = IERC721(_game);
395             erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
396         }
397         resetPrice(_game, _tokenId);
398         return Games[_game].tokenPrice[_tokenId].price;
399     }
400 
401     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
402         require(_HBWALLETExchange >= 1);
403 
404         HBWALLETExchange = _HBWALLETExchange;
405 
406         return (HBWALLETExchange);
407     }
408 
409     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
410         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
411         Games[_game].ETHFee = _ethFee;
412         Games[_game].limitETHFee = _ethlimitFee;
413         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
414         Games[_game].hightLightFee = _hightLightFee;
415         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
416     }
417 
418     function _withdraw(uint256 amount, uint256 _amountHB) internal {
419         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
420         if(amount > 0) {
421             msg.sender.transfer(amount);
422         }
423         if(_amountHB > 0) {
424             hbwalletToken.transfer(msg.sender, _amountHB);
425         }
426     }
427     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
428         _withdraw(amount, _amountHB);
429     }
430     function cancelBussinessByGameId(address _game, uint256 _tokenId) private {
431         IERC721 erc721Address = IERC721(_game);
432         if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)
433         || Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) {
434 
435             uint256 eth = Games[_game].tokenPrice[_tokenId].fee;
436             if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) eth = eth.add(Games[_game].hightLightFee);
437             if(eth > 0 && address(this).balance >= eth) {
438                 Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(eth);
439             }
440 
441             uint256 hb = Games[_game].tokenPrice[_tokenId].hbfee;
442             if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
443             if(hb > 0 && hbwalletToken.balanceOf(address(this)) >= hb) {
444                 hbwalletToken.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, hb);
445             }
446             if(Games[_game].tokenPrice[_tokenId].tokenOwner == address(this)) erc721Address.transfer(Games[_game].tokenPrice[_tokenId].tokenOwner, _tokenId);
447             resetPrice(_game, _tokenId);
448         }
449     }
450     
451     function cancelBussinessByGame(address _game) private onlyCeoAddress {
452         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
453         for (uint i = 0; i < _arrTokenId.length; i++) {
454             cancelBussinessByGameId(_game, _arrTokenId[i]);
455         }
456 
457     }
458     function cancelBussiness() public onlyCeoAddress {
459         for(uint j = 0; j< arrGames.length; j++) {
460             address _game = arrGames[j];
461             cancelBussinessByGame(_game);
462         }
463         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
464     }
465     
466     function revenue() public view returns (uint256, uint){
467 
468         uint256 ethfee;
469         uint256 hbfee;
470         for(uint j = 0; j< arrGames.length; j++) {
471 
472             address _game = arrGames[j];
473             IERC721 erc721Address = IERC721(arrGames[j]);
474             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
475                 uint256 _tokenId = Games[_game].tokenIdSale[i];
476                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
477 
478                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
479                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
480 
481                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
482                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
483 
484                 }
485             }
486         }
487 
488         uint256 eth = address(this).balance.sub(ethfee);
489         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
490         return (eth, hb);
491     }
492 
493     function changeCeo(address _address) public onlyCeoAddress {
494         require(_address != address(0));
495         ceoAddress = _address;
496 
497     }
498 
499     function buy(address _game, uint256 tokenId) public payable {
500         IERC721 erc721Address = IERC721(_game);
501         require(getApproved(_game, tokenId) == address(this));
502         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
503         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
504         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
505         resetPrice(_game, tokenId);
506     }
507 
508     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
509         IERC721 erc721Address = IERC721(_game);
510         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
511         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
512         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
513         resetPrice(_game, tokenId);
514     }
515     
516     function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
517         IERC721 erc721Address = IERC721(_game);
518         require(Games[_game].tokenPrice[_tokenId].price == msg.value);
519         require(erc721Address.ownerOf(_tokenId) == address(this));
520         erc721Address.transfer(msg.sender, _tokenId);
521         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
522         resetPrice(_game, _tokenId);
523     }
524     function buyFromSmartcontractViaTransfer(address _game, uint256 _tokenId) public payable {
525         IERC721 erc721Address = IERC721(_game);
526         require(Games[_game].tokenPrice[_tokenId].price == msg.value);
527         require(erc721Address.ownerOf(_tokenId) == address(this));
528         erc721Address.transfer(msg.sender, _tokenId);
529         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
530         resetPrice(_game, _tokenId);
531     }
532     // Move the last element to the deleted spot.
533     // Delete the last element, then correct the length.
534     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
535         if (index >= Games[_game].tokenIdSale.length) return;
536 
537         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
538             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
539         }
540         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
541         Games[_game].tokenIdSale.length--;
542     }
543 
544     function resetPrice(address _game, uint256 _tokenId) private {
545         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
546         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
547             if (Games[_game].tokenIdSale[i] == _tokenId) {
548                 _burnArrayTokenIdSale(_game, i);
549             }
550         }
551     }
552 }