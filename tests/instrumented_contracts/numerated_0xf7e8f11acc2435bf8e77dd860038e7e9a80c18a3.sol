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
147     address public ceoAddress = address(0x2076A228E6eB670fd1C604DE574d555476520DB7);
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
164         uint256[] tokenIdSale;
165         uint256 ETHFee;
166         uint256 limitETHFee;
167         uint256 limitHBWALLETFee;
168         uint256 hightLightFee;
169     }
170     
171     mapping(address => Game) public Games;
172     
173     constructor() public {
174         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].ETHFee = 0;
175         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitETHFee = 0;
176         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].limitHBWALLETFee = 0;
177         Games[address(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B)].hightLightFee = 30000000000000000;
178         
179         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].ETHFee = 0;
180         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitETHFee = 0;
181         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].limitHBWALLETFee = 0;
182         Games[address(0xdceaf1652a131F32a821468Dc03A92df0edd86Ea)].hightLightFee = 30000000000000000;
183         
184         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].ETHFee = 0;
185         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitETHFee = 0;
186         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].limitHBWALLETFee = 0;
187         Games[address(0x273f7F8E6489682Df756151F5525576E322d51A3)].hightLightFee = 30000000000000000;
188         
189         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].ETHFee = 0;
190         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitETHFee = 0;
191         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].limitHBWALLETFee = 0;
192         Games[address(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d)].hightLightFee = 30000000000000000;
193         
194         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].ETHFee = 0;
195         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitETHFee = 0;
196         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].limitHBWALLETFee = 0;
197         Games[address(0x1276dce965ADA590E42d62B3953dDc1DDCeB0392)].hightLightFee = 30000000000000000;
198         
199         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].ETHFee = 0;
200         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitETHFee = 0;
201         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].limitHBWALLETFee = 0;
202         Games[address(0xE60D2325f996e197EEdDed8964227a0c6CA82D0f)].hightLightFee = 30000000000000000;
203         
204         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].ETHFee = 0;
205         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitETHFee = 0;
206         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].limitHBWALLETFee = 0;
207         Games[address(0x617913Dd43dbDf4236B85Ec7BdF9aDFD7E35b340)].hightLightFee = 30000000000000000;
208         
209         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].ETHFee = 0;
210         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitETHFee = 0;
211         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].limitHBWALLETFee = 0;
212         Games[address(0xECd6b4A2f82b0c9FB283A4a8a1ef5ADf555f794b)].hightLightFee = 30000000000000000;
213         
214         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].ETHFee = 0;
215         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitETHFee = 0;
216         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].limitHBWALLETFee = 0;
217         Games[address(0xf26A23019b4699068bb54457f32dAFCF22A9D371)].hightLightFee = 30000000000000000;
218         
219         // Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].ETHFee = 0;
220         // Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitETHFee = 0;
221         // Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].limitHBWALLETFee = 0;
222         // Games[address(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099)].hightLightFee = 30000000000000000;
223     }
224     // function addTokenPrice(address _game, uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public {
225     //     Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
226     //     Games[_game].tokenIdSale.push(_tokenId);
227     // }
228     function getTokenPrice(address _game, uint256 _tokenId) public view returns (address, uint256, uint256, uint256, bool) {
229         return (Games[_game].tokenPrice[_tokenId].tokenOwner, Games[_game].tokenPrice[_tokenId].price, Games[_game].tokenPrice[_tokenId].fee, Games[_game].tokenPrice[_tokenId].hbfee, Games[_game].tokenPrice[_tokenId].isHightlight);
230     }
231     // new code =======================
232     /**
233      * @dev Throws if called by any account other than the ceo address.
234      */
235     modifier onlyCeoAddress() {
236         require(msg.sender == ceoAddress);
237         _;
238     }
239     modifier isOwnerOf(address _game, uint256 _tokenId) {
240         IERC721 erc721Address = IERC721(_game);
241         require(erc721Address.ownerOf(_tokenId) == msg.sender);
242         _;
243     }
244     // Move the last element to the deleted spot.
245     // Delete the last element, then correct the length.
246     function _burnArrayTokenIdSale(address _game, uint8 index)  internal {
247         if (index >= Games[_game].tokenIdSale.length) return;
248 
249         for (uint i = index; i<Games[_game].tokenIdSale.length-1; i++){
250             Games[_game].tokenIdSale[i] = Games[_game].tokenIdSale[i+1];
251         }
252         delete Games[_game].tokenIdSale[Games[_game].tokenIdSale.length-1];
253         Games[_game].tokenIdSale.length--;
254     }
255 
256     function _burnArrayTokenIdSaleByArr(address _game, uint8[] memory arr) internal {
257         for(uint8 i; i<arr.length; i++){
258             _burnArrayTokenIdSale(_game, i);
259         }
260 
261     }
262     function ownerOf(address _game, uint256 _tokenId) public view returns (address){
263         IERC721 erc721Address = IERC721(_game);
264         return erc721Address.ownerOf(_tokenId);
265     }
266 
267     function balanceOf() public view returns (uint256){
268         return address(this).balance;
269     }
270 
271     function getApproved(address _game, uint256 _tokenId) public view returns (address){
272         IERC721 erc721Address = IERC721(_game);
273         return erc721Address.getApproved(_tokenId);
274     }
275 
276     function setPrice(address _game, uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {
277         Games[_game].tokenPrice[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
278         Games[_game].tokenIdSale.push(_tokenId);
279     }
280 
281     function calPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
282         uint256 ethfee;
283         uint256 _hightLightFee = 0;
284         uint256 ethNeed;
285         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
286             _hightLightFee = Games[_game].hightLightFee;
287         }
288         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
289             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
290             if(Games[_game].tokenPrice[_tokenId].price == 0) {
291                 if (ethfee >= Games[_game].limitETHFee) {
292                     ethNeed = ethfee.add(_hightLightFee);
293                 } else {
294                     ethNeed = Games[_game].limitETHFee.add(_hightLightFee);
295                 }
296             }
297 
298         }
299         return (ethNeed, _hightLightFee);
300     }
301     function setPriceFeeEth(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_game, _tokenId) {
302         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
303         uint256 ethfee;
304         uint256 _hightLightFee = 0;
305         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
306             _hightLightFee = Games[_game].hightLightFee;
307         }
308         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
309             ethfee = _ethPrice.sub(Games[_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
310             if(Games[_game].tokenPrice[_tokenId].price == 0) {
311                 if (ethfee >= Games[_game].limitETHFee) {
312                     require(msg.value == ethfee.add(_hightLightFee));
313                 } else {
314                     require(msg.value == Games[_game].limitETHFee.add(_hightLightFee));
315                     ethfee = Games[_game].limitETHFee;
316                 }
317             }
318             ethfee = ethfee.add(Games[_game].tokenPrice[_tokenId].fee);
319         } else ethfee = _ethPrice.mul(Games[_game].ETHFee).div(Percen);
320 
321         setPrice(_game, _tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);
322     }
323     function calPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
324         uint fee;
325         uint256 ethfee;
326         uint _hightLightFee = 0;
327         uint hbNeed;
328         address local_game = _game;
329         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
330             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
331             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
332         }
333         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
334             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[_tokenId].price).mul(Games[_game].ETHFee).div(Percen);
335             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
336             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
337             if(Games[_game].tokenPrice[_tokenId].price == 0) {
338                 if (fee >= Games[_game].limitHBWALLETFee) {
339                     hbNeed = fee.add(_hightLightFee);
340                 } else {
341                     hbNeed = Games[_game].limitHBWALLETFee.add(_hightLightFee);
342                 }
343             }
344         }
345         return hbNeed;
346     }
347     function setPriceFeeHBWALLET(address _game, uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_game, _tokenId) {
348         require(Games[_game].tokenPrice[_tokenId].price != _ethPrice);
349         uint fee;
350         uint256 ethfee;
351         uint _hightLightFee = 0;
352         address local_game = _game;
353         uint256 local_tokenId = _tokenId;
354         if (_isHightLight == 1 && (Games[_game].tokenPrice[_tokenId].price == 0 || !Games[_game].tokenPrice[_tokenId].isHightlight)) {
355             _hightLightFee = Games[local_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
356         }
357         if (Games[_game].tokenPrice[_tokenId].price < _ethPrice) {
358             ethfee = _ethPrice.sub(Games[local_game].tokenPrice[local_tokenId].price).mul(Games[local_game].ETHFee).div(Percen);
359             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
360             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
361             if(Games[_game].tokenPrice[_tokenId].price == 0) {
362                 if (fee >= Games[_game].limitHBWALLETFee) {
363                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
364                 } else {
365                     require(hbwalletToken.transferFrom(msg.sender, address(this), Games[local_game].limitHBWALLETFee.add(_hightLightFee)));
366                     fee = Games[_game].limitHBWALLETFee;
367                 }
368             }
369             fee = fee.add(Games[_game].tokenPrice[_tokenId].hbfee);
370         } else {
371             ethfee = _ethPrice.mul(Games[local_game].ETHFee).div(Percen);
372             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
373         }
374 
375         setPrice(_game, _tokenId, _ethPrice, 0, fee, _isHightLight == 1);
376     }
377 
378     function removePrice(address _game, uint256 _tokenId) public isOwnerOf(_game, _tokenId) returns (uint256){
379         if (Games[_game].tokenPrice[_tokenId].fee > 0) msg.sender.transfer(Games[_game].tokenPrice[_tokenId].fee);
380         else if (Games[_game].tokenPrice[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, Games[_game].tokenPrice[_tokenId].hbfee);
381         resetPrice(_game, _tokenId);
382         return Games[_game].tokenPrice[_tokenId].price;
383     }
384 
385     function setHBWALLETExchange(uint _HBWALLETExchange) public onlyOwner returns (uint){
386         require(_HBWALLETExchange >= 1);
387         
388         HBWALLETExchange = _HBWALLETExchange;
389         
390         return (HBWALLETExchange);
391     }
392 
393     function setLimitFee(address _game, uint256 _ethFee, uint256 _ethlimitFee, uint _hbWalletlimitFee, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256, uint256){
394         require(_ethFee >= 0 && _ethlimitFee >= 0 && _hbWalletlimitFee >= 0 && _hightLightFee >= 0);
395         Games[_game].ETHFee = _ethFee;
396         Games[_game].limitETHFee = _ethlimitFee;
397         Games[_game].limitHBWALLETFee = _hbWalletlimitFee;
398         Games[_game].hightLightFee = _hightLightFee;
399         return (Games[_game].ETHFee, Games[_game].limitETHFee, Games[_game].limitHBWALLETFee, Games[_game].hightLightFee);
400     }
401 
402     function _withdraw(uint256 amount, uint256 _amountHB) internal {
403         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
404         if(amount > 0) {
405             msg.sender.transfer(amount);
406         }
407         if(_amountHB > 0) {
408             hbwalletToken.transfer(msg.sender, _amountHB);
409         }
410     }
411     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
412         _withdraw(amount, _amountHB);
413     }
414     function cancelBussiness(address _game) public onlyCeoAddress {
415         IERC721 erc721Address = IERC721(_game);
416         uint256[] memory arr = Games[_game].tokenIdSale;
417         uint length = Games[_game].tokenIdSale.length;
418         for (uint i = 0; i < length; i++) {
419             if (Games[_game].tokenPrice[arr[i]].tokenOwner == erc721Address.ownerOf(arr[i])) {
420                 if (Games[_game].tokenPrice[arr[i]].fee > 0) {
421                     uint256 eth = Games[_game].tokenPrice[arr[i]].fee;
422                     if(Games[_game].tokenPrice[arr[i]].isHightlight) eth = eth.add(Games[_game].hightLightFee);
423                     if(address(this).balance >= eth) {
424                         Games[_game].tokenPrice[arr[i]].tokenOwner.transfer(eth);
425                     }
426                 }
427                 else if (Games[_game].tokenPrice[arr[i]].hbfee > 0) {
428                     uint hb = Games[_game].tokenPrice[arr[i]].hbfee;
429                     if(Games[_game].tokenPrice[arr[i]].isHightlight) hb = hb.add(Games[_game].hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
430                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
431                         hbwalletToken.transfer(Games[_game].tokenPrice[arr[i]].tokenOwner, hb);
432                     }
433                 }
434                 resetPrice(_game, arr[i]);
435             }
436         }
437         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
438     }
439 
440     function revenue(address _game) public view returns (uint256, uint){
441         IERC721 erc721Address = IERC721(_game);
442         uint256 ethfee = 0;
443         uint256 hbfee = 0;
444         for (uint i = 0; i < Games[_game].tokenIdSale.length; i++) {
445             if (Games[_game].tokenPrice[Games[_game].tokenIdSale[i]].tokenOwner == erc721Address.ownerOf(Games[_game].tokenIdSale[i])) {
446                 if (Games[_game].tokenPrice[Games[_game].tokenIdSale[i]].fee > 0) {
447                     ethfee = ethfee.add(Games[_game].tokenPrice[Games[_game].tokenIdSale[i]].fee);
448                 }
449                 else if (Games[_game].tokenPrice[Games[_game].tokenIdSale[i]].hbfee > 0) {
450                     hbfee = hbfee.add(Games[_game].tokenPrice[Games[_game].tokenIdSale[i]].hbfee);
451                 }
452             }
453         }
454         uint256 eth = address(this).balance.sub(ethfee);
455         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
456         return (eth, hb);
457     }
458 
459     function changeCeo(address _address) public onlyCeoAddress {
460         require(_address != address(0));
461         ceoAddress = _address;
462 
463     }
464 
465     function buy(address _game, uint256 tokenId) public payable {
466         IERC721 erc721Address = IERC721(_game);
467         require(getApproved(_game, tokenId) == address(this));
468         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
469         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
470         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
471         resetPrice(_game, tokenId);
472     }
473 
474     function buyWithoutCheckApproved(address _game, uint256 tokenId) public payable {
475         IERC721 erc721Address = IERC721(_game);
476         require(Games[_game].tokenPrice[tokenId].price > 0 && Games[_game].tokenPrice[tokenId].price == msg.value);
477         erc721Address.transferFrom(Games[_game].tokenPrice[tokenId].tokenOwner, msg.sender, tokenId);
478         Games[_game].tokenPrice[tokenId].tokenOwner.transfer(msg.value);
479         resetPrice(_game, tokenId);
480     }
481 
482     function resetPrice(address _game, uint256 _tokenId) private {
483         Games[_game].tokenPrice[_tokenId] = Price(address(0), 0, 0, 0, false);
484         for (uint8 i = 0; i < Games[_game].tokenIdSale.length; i++) {
485             if (Games[_game].tokenIdSale[i] == _tokenId) {
486                 _burnArrayTokenIdSale(_game, i);
487             }
488         }
489     }
490 }