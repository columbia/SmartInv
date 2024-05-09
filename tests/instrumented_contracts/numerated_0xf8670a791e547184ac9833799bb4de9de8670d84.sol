1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 15, 2019
3  (UTC) */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Wednesday, May 15, 2019
7  (UTC) */
8 
9 pragma solidity ^0.5.8;
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17     address public owner;
18 
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23     /**
24      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25      * account.
26      */
27     constructor() public {
28         owner = msg.sender;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     /**
40      * @dev Allows the current owner to transfer control of the contract to a newOwner.
41      * @param newOwner The address to transfer ownership to.
42      */
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49 }
50 
51 contract IERC721 {
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     function balanceOf(address owner) public view returns (uint256 balance);
57 
58     function ownerOf(uint256 tokenId) public view returns (address owner);
59 
60     function approve(address to, uint256 tokenId) public;
61 
62     function getApproved(uint256 tokenId) public view returns (address operator);
63 
64     function setApprovalForAll(address operator, bool _approved) public;
65 
66     function isApprovedForAll(address owner, address operator) public view returns (bool);
67 
68     function transferFrom(address from, address to, uint256 tokenId) public;
69 
70     function safeTransferFrom(address from, address to, uint256 tokenId) public;
71 
72     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
73 }
74 /**
75  * @title ERC20Basic
76  * @dev Simpler version of ERC20 interface
77  * @dev see https://github.com/ethereum/EIPs/issues/179
78  */
79 contract ERC20BasicInterface {
80     function totalSupply() public view returns (uint256);
81 
82     function balanceOf(address who) public view returns (uint256);
83 
84     function transfer(address to, uint256 value) public returns (bool);
85 
86     function transferFrom(address from, address to, uint256 value) public returns (bool);
87 
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     uint8 public decimals;
91 }
92 
93 contract Bussiness is Ownable {
94     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
95     IERC721 public erc721Address = IERC721(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
96     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
97     uint256 public ETHFee = 25; // 25 = 2,5 %
98     uint256 public Percen = 1000;
99     uint256 public HBWALLETExchange = 21;
100     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
101     uint256 public limitETHFee = 2000000000000000;
102     uint256 public limitHBWALLETFee = 2;
103     uint256 public hightLightFee = 30000000000000000;
104     constructor() public {}
105     struct Price {
106         address payable tokenOwner;
107         uint256 price;
108         uint256 fee;
109         uint256 hbfee;
110         bool isHightlight;
111     }
112 
113     uint[] public arrayTokenIdSale;
114     mapping(uint256 => Price) public prices;
115 
116     /**
117      * @dev Throws if called by any account other than the ceo address.
118      */
119     modifier onlyCeoAddress() {
120         require(msg.sender == ceoAddress);
121         _;
122     }
123 
124     // Move the last element to the deleted spot.
125     // Delete the last element, then correct the length.
126     function _burnArrayTokenIdSale(uint index)  internal {
127         if (index >= arrayTokenIdSale.length) return;
128 
129         for (uint i = index; i<arrayTokenIdSale.length-1; i++){
130             arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
131         }
132         delete arrayTokenIdSale[arrayTokenIdSale.length-1];
133         arrayTokenIdSale.length--;
134     }
135     
136     function _burnArrayTokenIdSaleByArr(uint[] memory arr) internal {
137         for(uint i; i<arr.length; i++){
138             _burnArrayTokenIdSale(i);
139         }
140        
141     }
142     function ownerOf(uint256 _tokenId) public view returns (address){
143         return erc721Address.ownerOf(_tokenId);
144     }
145 
146     function balanceOf() public view returns (uint256){
147         return address(this).balance;
148     }
149 
150     function getApproved(uint256 _tokenId) public view returns (address){
151         return erc721Address.getApproved(_tokenId);
152     }
153 
154     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
155         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
156         arrayTokenIdSale.push(_tokenId);
157     }
158 
159     function calPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
160         uint256 ethfee;
161         uint256 _hightLightFee = 0;
162         uint256 ethNeed;
163         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
164             _hightLightFee = hightLightFee;
165         }
166         if (prices[_tokenId].price < _ethPrice) {
167             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
168             if(prices[_tokenId].price == 0) {
169                 if (ethfee >= limitETHFee) {
170                     ethNeed = ethfee + _hightLightFee;
171                 } else {
172                     ethNeed = limitETHFee + _hightLightFee;
173                 }
174             }
175             
176         }
177         return (ethNeed, _hightLightFee);
178     }
179     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable {
180         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
181         uint256 ethfee;
182         uint256 _hightLightFee = 0;
183         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
184             _hightLightFee = hightLightFee;
185         }
186         if (prices[_tokenId].price < _ethPrice) {
187             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
188             if(prices[_tokenId].price == 0) {
189                 if (ethfee >= limitETHFee) {
190                     require(msg.value == ethfee + _hightLightFee);
191                 } else {
192                     require(msg.value == limitETHFee + _hightLightFee);
193                     ethfee = limitETHFee;
194                 }
195             }
196             ethfee += prices[_tokenId].fee;
197         } else ethfee = _ethPrice * ETHFee / Percen;
198 
199         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1 ? true : false);
200     }
201     function calPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
202         uint256 fee;
203         uint256 ethfee;
204         uint256 _hightLightFee = 0;
205         uint256 hbNeed;
206         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
207             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
208         }
209         if (prices[_tokenId].price < _ethPrice) {
210             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
211             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
212             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
213             if(prices[_tokenId].price == 0) {
214                 if (fee >= limitHBWALLETFee) {
215                     hbNeed = fee + _hightLightFee;
216                 } else {
217                     hbNeed = limitHBWALLETFee + _hightLightFee;
218                 }
219             }
220         }
221         return hbNeed;
222     }
223     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public returns (bool){
224         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
225         uint256 fee;
226         uint256 ethfee;
227         uint256 _hightLightFee = 0;
228         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
229             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
230         }
231         if (prices[_tokenId].price < _ethPrice) {
232             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
233             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
234             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
235             if(prices[_tokenId].price == 0) {
236                 if (fee >= limitHBWALLETFee) {
237                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
238                 } else {
239                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
240                     fee = limitHBWALLETFee;
241                 }
242             }
243             fee += prices[_tokenId].hbfee;
244         } else {
245             ethfee = _ethPrice * ETHFee / Percen;
246             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
247         }
248 
249         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1 ? true : false);
250         return true;
251     }
252 
253     function removePrice(uint256 tokenId) public returns (uint256){
254         require(erc721Address.ownerOf(tokenId) == msg.sender);
255         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
256         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
257         resetPrice(tokenId);
258         return prices[tokenId].price;
259     }
260 
261     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
262         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
263         ETHFee = _ethFee;
264         HBWALLETExchange = _HBWALLETExchange;
265         hightLightFee = _hightLightFee;
266         return (ETHFee, HBWALLETExchange, hightLightFee);
267     }
268 
269     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
270         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
271         limitETHFee = _ethlimitFee;
272         limitHBWALLETFee = _hbWalletlimitFee;
273         return (limitETHFee, limitHBWALLETFee);
274     }
275     /**
276      * @dev Withdraw the amount of eth that is remaining in this contract.
277      * @param _address The address of EOA that can receive token from this contract.
278      */
279     function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
280         require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
281         if(amount > 0) {
282             _address.transfer(amount);
283         }
284         if(_amountHB > 0) {
285             hbwalletToken.transferFrom(address(this), _address, _amountHB);
286         }
287     }
288     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
289         _withdraw(_address, amount, _amountHB);
290     }
291     function cancelBussiness() public onlyCeoAddress {
292         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
293             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
294                 if (prices[arrayTokenIdSale[i]].fee > 0) {
295                     uint256 eth = prices[arrayTokenIdSale[i]].fee;
296                     if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
297                     if(address(this).balance >= eth) {
298                         prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
299                     } 
300                 }
301                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
302                     uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
303                     if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
304                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
305                         hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
306                     }
307                 }
308             }
309         }
310         _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
311     }
312     
313     function revenue() public view returns (uint256, uint256){
314         uint256 ethfee = 0;
315         uint256 hbfee = 0;
316         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
317             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
318                 if (prices[arrayTokenIdSale[i]].fee > 0) {
319                     ethfee += prices[arrayTokenIdSale[i]].fee;
320                 }
321                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
322                     hbfee += prices[arrayTokenIdSale[i]].hbfee;
323                 }
324             }
325         }
326         uint256 eth = address(this).balance - ethfee;
327         uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
328         return (eth, hb);
329     }
330     
331     function changeCeo(address _address) public onlyCeoAddress {
332         require(_address != address(0));
333         ceoAddress = _address;
334 
335     }
336 
337     function buy(uint256 tokenId) public payable {
338         require(getApproved(tokenId) == address(this));
339         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
340         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
341         prices[tokenId].tokenOwner.transfer(msg.value);
342         resetPrice(tokenId);
343     }
344 
345     function buyWithoutCheckApproved(uint256 tokenId) public payable {
346         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
347         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
348         prices[tokenId].tokenOwner.transfer(msg.value);
349         resetPrice(tokenId);
350     }
351 
352     function resetPrice(uint256 tokenId) private {
353         prices[tokenId] = Price(address(0), 0, 0, 0, false);
354         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
355             if (arrayTokenIdSale[i] == tokenId) {
356                 _burnArrayTokenIdSale(i);
357             }
358         }
359     }
360 }