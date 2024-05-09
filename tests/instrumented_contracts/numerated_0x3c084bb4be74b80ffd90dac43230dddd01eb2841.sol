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
252         if(erc721Address.ownerOf(_tokenId) != Games[_game].tokenPrice[_tokenId].tokenOwner 
253         && erc721Address.ownerOf(_tokenId) != address(this)) resetPrice(_game, _tokenId);
254         return (Games[_game].tokenPrice[_tokenId].tokenOwner,
255         Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee,
256         Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight,
257         Games[_game].tokenPrice[_tokenId].isHightlightByHb);
258     }
259     // new code =======================
260     /**
261      * @dev Throws if called by any account other than the ceo address.
262      */
263     modifier onlyCeoAddress() {
264         require(msg.sender == ceoAddress);
265         _;
266     }
267     modifier isOwnerOf(address _game, uint256 _tokenId) {
268         IERC721 erc721Address = IERC721(_game);
269         require(erc721Address.ownerOf(_tokenId) == msg.sender);
270         _;
271     }
272 
273     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
274         IERC721 erc721Address = IERC721(_game);
275         return erc721Address.ownerOf(_tokenId);
276     }
277 
278     function balanceOf() public view returns (uint256){
279         return address(this).balance;
280     }
281 
282     function getApproved(address _game, uint256 _tokenId) public view returns (address){
283         IERC721 erc721Address = IERC721(_game);
284         return erc721Address.getApproved(_tokenId);
285     }
286     
287     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, uint _isHightLight, uint _isHightLightByHb) internal {
288         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight, _isHightLightByHb);
289         Games[_game].tokenIdSale.push(_tokenId);
290         bool flag = false;
291         for(uint i = 0; i< arrGames.length; i++) {
292             if(arrGames[i] == _game) flag = true;
293         }
294         if(!flag) arrGames.push(_game);
295     }
296 
297     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
298         uint256 ethfee;
299         uint256 _hightLightFee = 0;
300         uint256 ethNeed;
301         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
302             _hightLightFee = Games[_game].hightLightFee;
303         }
304         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
305             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
306             if(Games[_game].tokenPrice[_tokenId].price == 0) {
307                 if (ethfee >= Games[_game].limitETHFee) {
308                     ethNeed = ethfee.add(_hightLightFee);
309                 } else {
310                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
311                 }
312             }
313 
314         }
315         return (ethNeed, _hightLightFee);
316     }
317     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
318         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
319         uint256 ethfee;
320         uint256 _hightLightFee = 0;
321         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
322             _hightLightFee = Games[_game].hightLightFee;
323         }
324         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
325             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
326             if(Games[_game].tokenPrice[_tokenId].price == 0) {
327                 if (ethfee >= Games[_game].limitETHFee) {
328                     require(msg.value == ethfee.add(_hightLightFee));
329                 } else {
330                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
331                     ethfee = Games[_game].limitETHFee;
332                 }
333             }
334             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
335         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
336 
337         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight, 0);
338     }
339     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
340         uint fee;
341         uint256 ethfee;
342         uint _hightLightFee = 0;
343         uint hbNeed;
344         address local_game = _game;
345         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
346             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
347             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
348         }
349         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
350             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
351             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
352             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
353             if(Games[_game].tokenPrice[_tokenId].price == 0) {
354                 if (fee >= Games[_game].limitHBWALLETFee) {
355                     hbNeed = fee.add(_hightLightFee);
356                 } else {
357                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
358                 }
359             }
360         }
361         return hbNeed;
362     }
363     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
364         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
365         uint fee;
366         uint256 ethfee;
367         uint _hightLightFee = 0;
368         address local_game = _game;
369         uint256 local_tokenId = _tokenId;
370         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || Games[_game].tokenPrice[_tokenId].isHightlight != 1)) {
371             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
372         }
373         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
374             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
375             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
376             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
377             if(Games[_game].tokenPrice[_tokenId].price == 0) {
378                 if (fee >= Games[_game].limitHBWALLETFee) {
379                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
380                 } else {
381                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
382                     fee = Games[_game].limitHBWALLETFee;
383                 }
384             }
385             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
386         } else {
387             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
388             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
389         }
390 
391         setPrice(_game, _tokenId, _ethPrice, 0, fee, 0, _isHightLight);
392     }
393 
394     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
395         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
396         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
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
450     function cancelBussinessByGame(address _game) private onlyCeoAddress {
451         uint256[] memory _arrTokenId = Games[_game].tokenIdSale;
452         for (uint i = 0; i < _arrTokenId.length; i++) {
453             cancelBussinessByGameId(_game, _arrTokenId[i]);
454         }
455 
456     }
457     function cancelBussiness() public onlyCeoAddress {
458         for(uint j = 0; j< arrGames.length; j++) {
459             address _game = arrGames[j];
460             cancelBussinessByGame(_game);
461         }
462         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
463     }
464     
465     function revenue() public view returns (uint256, uint){
466 
467         uint256 ethfee;
468         uint256 hbfee;
469         for(uint j = 0; j< arrGames.length; j++) {
470 
471             address _game = arrGames[j];
472             IERC721 erc721Address = IERC721(arrGames[j]);
473             for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
474                 uint256 _tokenId = Games[_game].tokenIdSale[i];
475                 if (Games[_game].tokenPrice[_tokenId].tokenOwner == erc721Address.ownerOf(_tokenId)) {
476 
477                     ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
478                     if(Games[_game].tokenPrice[_tokenId].isHightlight == 1) ethfee = ethfee.add(Games[_game].hightLightFee);
479 
480                     hbfee = hbfee.add(Games[_game].tokenPrice[_tokenId].hbfee);
481                     if(Games[_game].tokenPrice[_tokenId].isHightlightByHb == 1) hbfee = hbfee.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
482 
483                 }
484             }
485         }
486 
487         uint256 eth = address(this).balance.sub(ethfee);
488         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
489         return (eth, hb);
490     }
491 
492     function changeCeo(address _address) public onlyCeoAddress {
493         require(_address != address(0));
494         ceoAddress = _address;
495 
496     }
497 
498     function buy(address _game, uint256 tokenId) public payable {
499         IERC721 erc721Address = IERC721(_game);
500         require(getApproved(_game, tokenId) == address(this));
501         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
502         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
503         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
504         resetPrice(_game, tokenId);
505     }
506 
507     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
508         IERC721 erc721Address = IERC721(_game);
509         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
510         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
511         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
512         resetPrice(_game, tokenId);
513     }
514     
515     function buyFromSmartcontract(address _game, uint256 _tokenId) public payable {
516         IERC721 erc721Address = IERC721(_game);
517         require(Games[_game].tokenPrice[_tokenId].price == msg.value);
518         require(erc721Address.ownerOf(_tokenId) == address(this));
519         erc721Address.transfer(msg.sender, _tokenId);
520         Games[_game].tokenPrice[_tokenId].tokenOwner.transfer(msg.value);
521         resetPrice(_game, _tokenId);
522     }
523     // Move the last element to the deleted spot.
524     // Delete the last element, then correct the length.
525     function _burnArrayTokenIdSale(address _game, uint256 index)  internal {
526         if (index >= Games[_game].tokenIdSale.length) return;
527 
528         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
529             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
530         }
531         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
532         Games[_game].tokenIdSale.length--;
533     }
534 
535     function resetPrice(address _game, uint256 _tokenId) private {
536         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, 0, 0);
537         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
538             if (Games[_game].tokenIdSale[i] == _tokenId) {
539                 _burnArrayTokenIdSale(_game, i);
540             }
541         }
542     }
543 }