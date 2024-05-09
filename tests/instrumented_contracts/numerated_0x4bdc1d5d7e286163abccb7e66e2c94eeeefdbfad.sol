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
148     IERC721 public erc721Address = IERC721(0x8c9b261Faef3b3C2e64ab5E58e04615F8c788099);
149     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
150     uint256 public ETHFee = 0; // 25 = 2,5 %
151     uint256 public Percen = 1000;
152     uint256 public HBWALLETExchange = 21;
153     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
154     uint256 public limitETHFee = 0;
155     uint256 public limitHBWALLETFee = 0;
156     uint256 public hightLightFee = 30000000000000000;
157     constructor() public {}
158     struct Price {
159         address payable tokenOwner;
160         uint256 price;
161         uint256 fee;
162         uint256 hbfee;
163         bool isHightlight;
164     }
165 
166     uint256[] public arrayTokenIdSale;
167     mapping(uint256 => Price) public prices;
168 
169     /**
170      * @dev Throws if called by any account other than the ceo address.
171      */
172     modifier onlyCeoAddress() {
173         require(msg.sender == ceoAddress);
174         _;
175     }
176     modifier isOwnerOf(uint256 _tokenId) {
177         require(erc721Address.ownerOf(_tokenId) == msg.sender);
178         _;
179     }
180     // Move the last element to the deleted spot.
181     // Delete the last element, then correct the length.
182     function _burnArrayTokenIdSale(uint8 index)  internal {
183         if (index >= arrayTokenIdSale.length) return;
184 
185         for (uint i = index; i<arrayTokenIdSale.length-1; i++){
186             arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
187         }
188         delete arrayTokenIdSale[arrayTokenIdSale.length-1];
189         arrayTokenIdSale.length--;
190     }
191 
192     function _burnArrayTokenIdSaleByArr(uint8[] memory arr) internal {
193         for(uint8 i; i<arr.length; i++){
194             _burnArrayTokenIdSale(i);
195         }
196 
197     }
198     function ownerOf(uint256 _tokenId) public view returns (address){
199         return erc721Address.ownerOf(_tokenId);
200     }
201 
202     function balanceOf() public view returns (uint256){
203         return address(this).balance;
204     }
205 
206     function getApproved(uint256 _tokenId) public view returns (address){
207         return erc721Address.getApproved(_tokenId);
208     }
209 
210     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint _hbfee, bool _isHightLight) internal {
211         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
212         arrayTokenIdSale.push(_tokenId);
213     }
214 
215     function calPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
216         uint256 ethfee;
217         uint256 _hightLightFee = 0;
218         uint256 ethNeed;
219         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {
220             _hightLightFee = hightLightFee;
221         }
222         if (prices[_tokenId].price < _ethPrice) {
223             ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);
224             if(prices[_tokenId].price == 0) {
225                 if (ethfee >= limitETHFee) {
226                     ethNeed = ethfee.add(_hightLightFee);
227                 } else {
228                     ethNeed = limitETHFee.add(_hightLightFee);
229                 }
230             }
231 
232         }
233         return (ethNeed, _hightLightFee);
234     }
235     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable isOwnerOf(_tokenId) {
236         require(prices[_tokenId].price != _ethPrice);
237         uint256 ethfee;
238         uint256 _hightLightFee = 0;
239         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {
240             _hightLightFee = hightLightFee;
241         }
242         if (prices[_tokenId].price < _ethPrice) {
243             ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);
244             if(prices[_tokenId].price == 0) {
245                 if (ethfee >= limitETHFee) {
246                     require(msg.value == ethfee.add(_hightLightFee));
247                 } else {
248                     require(msg.value == limitETHFee.add(_hightLightFee));
249                     ethfee = limitETHFee;
250                 }
251             }
252             ethfee = ethfee.add(prices[_tokenId].fee);
253         } else ethfee = _ethPrice.mul(ETHFee).div(Percen);
254 
255         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1);
256     }
257     function calPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
258         uint fee;
259         uint256 ethfee;
260         uint _hightLightFee = 0;
261         uint hbNeed;
262         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {
263             // _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
264             _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
265         }
266         if (prices[_tokenId].price < _ethPrice) {
267             ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);
268             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
269             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
270             if(prices[_tokenId].price == 0) {
271                 if (fee >= limitHBWALLETFee) {
272                     hbNeed = fee.add(_hightLightFee);
273                 } else {
274                     hbNeed = limitHBWALLETFee.add(_hightLightFee);
275                 }
276             }
277         }
278         return hbNeed;
279     }
280     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public isOwnerOf(_tokenId) {
281         require(prices[_tokenId].price != _ethPrice);
282         uint fee;
283         uint256 ethfee;
284         uint _hightLightFee = 0;
285         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || !prices[_tokenId].isHightlight)) {
286             _hightLightFee = hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16);
287         }
288         if (prices[_tokenId].price < _ethPrice) {
289             ethfee = _ethPrice.sub(prices[_tokenId].price).mul(ETHFee).div(Percen);
290             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
291             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
292             if(prices[_tokenId].price == 0) {
293                 if (fee >= limitHBWALLETFee) {
294                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee.add(_hightLightFee)));
295                 } else {
296                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee.add(_hightLightFee)));
297                     fee = limitHBWALLETFee;
298                 }
299             }
300             fee = fee.add(prices[_tokenId].hbfee);
301         } else {
302             ethfee = _ethPrice.mul(ETHFee).div(Percen);
303             fee = ethfee.mul(HBWALLETExchange).div(2).div(10 ** 16);
304         }
305 
306         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1);
307     }
308 
309     function removePrice(uint256 _tokenId) public isOwnerOf(_tokenId) returns (uint256){
310         if (prices[_tokenId].fee > 0) msg.sender.transfer(prices[_tokenId].fee);
311         else if (prices[_tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[_tokenId].hbfee);
312         resetPrice(_tokenId);
313         return prices[_tokenId].price;
314     }
315 
316     function setFee(uint256 _ethFee, uint _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint, uint256){
317         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
318         ETHFee = _ethFee;
319         HBWALLETExchange = _HBWALLETExchange;
320         hightLightFee = _hightLightFee;
321         return (ETHFee, HBWALLETExchange, hightLightFee);
322     }
323 
324     function setLimitFee(uint256 _ethlimitFee, uint _hbWalletlimitFee) public onlyOwner returns (uint256, uint){
325         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
326         limitETHFee = _ethlimitFee;
327         limitHBWALLETFee = _hbWalletlimitFee;
328         return (limitETHFee, limitHBWALLETFee);
329     }
330 
331     function _withdraw(uint256 amount, uint256 _amountHB) internal {
332         require(address(this).balance >= amount && hbwalletToken.balanceOf(address(this)) >= _amountHB);
333         if(amount > 0) {
334             msg.sender.transfer(amount);
335         }
336         if(_amountHB > 0) {
337             hbwalletToken.transfer(msg.sender, _amountHB);
338         }
339     }
340     function withdraw(uint256 amount, uint8 _amountHB) public onlyCeoAddress {
341         _withdraw(amount, _amountHB);
342     }
343     function cancelBussiness() public onlyCeoAddress {
344         uint256[] memory arr = arrayTokenIdSale;
345         uint length = arrayTokenIdSale.length;
346         for (uint i = 0; i < length; i++) {
347             if (prices[arr[i]].tokenOwner == erc721Address.ownerOf(arr[i])) {
348                 if (prices[arr[i]].fee > 0) {
349                     uint256 eth = prices[arr[i]].fee;
350                     if(prices[arr[i]].isHightlight) eth = eth.add(hightLightFee);
351                     if(address(this).balance >= eth) {
352                         prices[arr[i]].tokenOwner.transfer(eth);
353                     }
354                 }
355                 else if (prices[arr[i]].hbfee > 0) {
356                     uint hb = prices[arr[i]].hbfee;
357                     if(prices[arr[i]].isHightlight) hb = hb.add(hightLightFee.mul(HBWALLETExchange).div(2).div(10 ** 16));
358                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
359                         hbwalletToken.transfer(prices[arr[i]].tokenOwner, hb);
360                     }
361                 }
362                 resetPrice(arr[i]);
363             }
364         }
365         _withdraw(address(this).balance, hbwalletToken.balanceOf(address(this)));
366     }
367 
368     function revenue() public view returns (uint256, uint){
369         uint256 ethfee = 0;
370         uint256 hbfee = 0;
371         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
372             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
373                 if (prices[arrayTokenIdSale[i]].fee > 0) {
374                     ethfee = ethfee.add(prices[arrayTokenIdSale[i]].fee);
375                 }
376                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
377                     hbfee = hbfee.add(prices[arrayTokenIdSale[i]].hbfee);
378                 }
379             }
380         }
381         uint256 eth = address(this).balance.sub(ethfee);
382         uint256 hb = hbwalletToken.balanceOf(address(this)).sub(hbfee);
383         return (eth, hb);
384     }
385 
386     function changeCeo(address _address) public onlyCeoAddress {
387         require(_address != address(0));
388         ceoAddress = _address;
389 
390     }
391 
392     function buy(uint256 tokenId) public payable {
393         require(getApproved(tokenId) == address(this));
394         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
395         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
396         prices[tokenId].tokenOwner.transfer(msg.value);
397         resetPrice(tokenId);
398     }
399 
400     function buyWithoutCheckApproved(uint256 tokenId) public payable {
401         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
402         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
403         prices[tokenId].tokenOwner.transfer(msg.value);
404         resetPrice(tokenId);
405     }
406 
407     function resetPrice(uint256 tokenId) private {
408         prices[tokenId] = Price(address(0), 0, 0, 0, false);
409         for (uint8 i = 0; i < arrayTokenIdSale.length; i++) {
410             if (arrayTokenIdSale[i] == tokenId) {
411                 _burnArrayTokenIdSale(i);
412             }
413         }
414     }
415 }