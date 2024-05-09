1 /**
2  * Source Code first verified at https://etherscan.io on Wednesday, May 15, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.8;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 contract IERC721 {
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     function balanceOf(address owner) public view returns (uint256 balance);
53 
54     function ownerOf(uint256 tokenId) public view returns (address owner);
55 
56     function approve(address to, uint256 tokenId) public;
57 
58     function getApproved(uint256 tokenId) public view returns (address operator);
59 
60     function setApprovalForAll(address operator, bool _approved) public;
61 
62     function isApprovedForAll(address owner, address operator) public view returns (bool);
63 
64     function transferFrom(address from, address to, uint256 tokenId) public;
65 
66     function safeTransferFrom(address from, address to, uint256 tokenId) public;
67 
68     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
69 }
70 /**
71  * @title ERC20Basic
72  * @dev Simpler version of ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/179
74  */
75 contract ERC20BasicInterface {
76     function totalSupply() public view returns (uint256);
77 
78     function balanceOf(address who) public view returns (uint256);
79 
80     function transfer(address to, uint256 value) public returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) public returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     uint8 public decimals;
87 }
88 
89 contract Bussiness is Ownable {
90     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
91     IERC721 public erc721Address = IERC721(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
92     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
93     uint256 public ETHFee = 25; // 25 = 2,5 %
94     uint256 public Percen = 1000;
95     uint256 public HBWALLETExchange = 21;
96     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
97     uint256 public limitETHFee = 2000000000000000;
98     uint256 public limitHBWALLETFee = 2;
99     uint256 public hightLightFee = 30000000000000000;
100     constructor() public {}
101     struct Price {
102         address payable tokenOwner;
103         uint256 price;
104         uint256 fee;
105         uint256 hbfee;
106         bool isHightlight;
107     }
108 
109     uint[] public arrayTokenIdSale;
110     mapping(uint256 => Price) public prices;
111 
112     /**
113      * @dev Throws if called by any account other than the ceo address.
114      */
115     modifier onlyCeoAddress() {
116         require(msg.sender == ceoAddress);
117         _;
118     }
119 
120     // Move the last element to the deleted spot.
121     // Delete the last element, then correct the length.
122     function _burnArrayTokenIdSale(uint index)  internal {
123         if (index >= arrayTokenIdSale.length) return;
124 
125         for (uint i = index; i<arrayTokenIdSale.length-1; i++){
126             arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
127         }
128         delete arrayTokenIdSale[arrayTokenIdSale.length-1];
129         arrayTokenIdSale.length--;
130     }
131     
132     function _burnArrayTokenIdSaleByArr(uint[] memory arr) internal {
133         for(uint i; i<arr.length; i++){
134             _burnArrayTokenIdSale(i);
135         }
136        
137     }
138     function ownerOf(uint256 _tokenId) public view returns (address){
139         return erc721Address.ownerOf(_tokenId);
140     }
141 
142     function balanceOf() public view returns (uint256){
143         return address(this).balance;
144     }
145 
146     function getApproved(uint256 _tokenId) public view returns (address){
147         return erc721Address.getApproved(_tokenId);
148     }
149 
150     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
151         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
152         arrayTokenIdSale.push(_tokenId);
153     }
154 
155     function calPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
156         uint256 ethfee;
157         uint256 _hightLightFee = 0;
158         uint256 ethNeed;
159         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
160             _hightLightFee = hightLightFee;
161         }
162         if (prices[_tokenId].price < _ethPrice) {
163             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
164             if(prices[_tokenId].price == 0) {
165                 if (ethfee >= limitETHFee) {
166                     ethNeed = ethfee + _hightLightFee;
167                 } else {
168                     ethNeed = limitETHFee + _hightLightFee;
169                 }
170             }
171             
172         }
173         return (ethNeed, _hightLightFee);
174     }
175     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable {
176         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
177         uint256 ethfee;
178         uint256 _hightLightFee = 0;
179         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
180             _hightLightFee = hightLightFee;
181         }
182         if (prices[_tokenId].price < _ethPrice) {
183             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
184             if(prices[_tokenId].price == 0) {
185                 if (ethfee >= limitETHFee) {
186                     require(msg.value == ethfee + _hightLightFee);
187                 } else {
188                     require(msg.value == limitETHFee + _hightLightFee);
189                     ethfee = limitETHFee;
190                 }
191             }
192             ethfee += prices[_tokenId].fee;
193         } else ethfee = _ethPrice * ETHFee / Percen;
194 
195         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1 ? true : false);
196     }
197     function calPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
198         uint256 fee;
199         uint256 ethfee;
200         uint256 _hightLightFee = 0;
201         uint256 hbNeed;
202         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
203             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
204         }
205         if (prices[_tokenId].price < _ethPrice) {
206             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
207             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
208             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
209             if(prices[_tokenId].price == 0) {
210                 if (fee >= limitHBWALLETFee) {
211                     hbNeed = fee + _hightLightFee;
212                 } else {
213                     hbNeed = limitHBWALLETFee + _hightLightFee;
214                 }
215             }
216         }
217         return hbNeed;
218     }
219     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public returns (bool){
220         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
221         uint256 fee;
222         uint256 ethfee;
223         uint256 _hightLightFee = 0;
224         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
225             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
226         }
227         if (prices[_tokenId].price < _ethPrice) {
228             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
229             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
230             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
231             if(prices[_tokenId].price == 0) {
232                 if (fee >= limitHBWALLETFee) {
233                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
234                 } else {
235                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
236                     fee = limitHBWALLETFee;
237                 }
238             }
239             fee += prices[_tokenId].hbfee;
240         } else {
241             ethfee = _ethPrice * ETHFee / Percen;
242             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
243         }
244 
245         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1 ? true : false);
246         return true;
247     }
248 
249     function removePrice(uint256 tokenId) public returns (uint256){
250         require(erc721Address.ownerOf(tokenId) == msg.sender);
251         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
252         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
253         resetPrice(tokenId);
254         return prices[tokenId].price;
255     }
256 
257     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
258         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
259         ETHFee = _ethFee;
260         HBWALLETExchange = _HBWALLETExchange;
261         hightLightFee = _hightLightFee;
262         return (ETHFee, HBWALLETExchange, hightLightFee);
263     }
264 
265     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
266         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
267         limitETHFee = _ethlimitFee;
268         limitHBWALLETFee = _hbWalletlimitFee;
269         return (limitETHFee, limitHBWALLETFee);
270     }
271     /**
272      * @dev Withdraw the amount of eth that is remaining in this contract.
273      * @param _address The address of EOA that can receive token from this contract.
274      */
275     function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
276         require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
277         _address.transfer(amount);
278         hbwalletToken.transferFrom(address(this), _address, _amountHB);
279     }
280     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
281         _withdraw(_address, amount, _amountHB);
282     }
283     function cancelBussiness() public onlyCeoAddress {
284         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
285             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
286                 if (prices[arrayTokenIdSale[i]].fee > 0) {
287                     uint256 eth = prices[arrayTokenIdSale[i]].fee;
288                     if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
289                     if(address(this).balance >= eth) {
290                         prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
291                     } 
292                 }
293                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
294                     uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
295                     if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
296                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
297                         hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
298                     }
299                 }
300             }
301         }
302         _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
303     }
304     
305     function revenue() public view returns (uint256, uint256){
306         uint256 ethfee = 0;
307         uint256 hbfee = 0;
308         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
309             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
310                 if (prices[arrayTokenIdSale[i]].fee > 0) {
311                     ethfee += prices[arrayTokenIdSale[i]].fee;
312                 }
313                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
314                     hbfee += prices[arrayTokenIdSale[i]].hbfee;
315                 }
316             }
317         }
318         uint256 eth = address(this).balance - ethfee;
319         uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
320         return (eth, hb);
321     }
322     
323     function changeCeo(address _address) public onlyCeoAddress {
324         require(_address != address(0));
325         ceoAddress = _address;
326 
327     }
328 
329     function buy(uint256 tokenId) public payable {
330         require(getApproved(tokenId) == address(this));
331         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
332         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
333         prices[tokenId].tokenOwner.transfer(msg.value);
334         resetPrice(tokenId);
335     }
336 
337     function buyWithoutCheckApproved(uint256 tokenId) public payable {
338         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
339         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
340         prices[tokenId].tokenOwner.transfer(msg.value);
341         resetPrice(tokenId);
342     }
343 
344     function resetPrice(uint256 tokenId) private {
345         prices[tokenId] = Price(address(0), 0, 0, 0, false);
346         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
347             if (arrayTokenIdSale[i] == tokenId) {
348                 _burnArrayTokenIdSale(i);
349             }
350         }
351     }
352 }