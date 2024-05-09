1 pragma solidity ^0.5.8;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23     /**
24      * @dev Throws if called by any account other than the owner.
25      */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 contract IERC721 {
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     function balanceOf(address owner) public view returns (uint256 balance);
49 
50     function ownerOf(uint256 tokenId) public view returns (address owner);
51 
52     function approve(address to, uint256 tokenId) public;
53 
54     function getApproved(uint256 tokenId) public view returns (address operator);
55 
56     function setApprovalForAll(address operator, bool _approved) public;
57 
58     function isApprovedForAll(address owner, address operator) public view returns (bool);
59 
60     function transferFrom(address from, address to, uint256 tokenId) public;
61 
62     function safeTransferFrom(address from, address to, uint256 tokenId) public;
63 
64     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
65 }
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20BasicInterface {
72     function totalSupply() public view returns (uint256);
73 
74     function balanceOf(address who) public view returns (uint256);
75 
76     function transfer(address to, uint256 value) public returns (bool);
77 
78     function transferFrom(address from, address to, uint256 value) public returns (bool);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     uint8 public decimals;
83 }
84 
85 contract Bussiness is Ownable {
86     address public ceoAddress = address(0xFce92D4163AA532AA096DE8a3C4fEf9f875Bc55F);
87     IERC721 public erc721Address = IERC721(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
88     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
89     uint256 public ETHFee = 25; // 25 = 2,5 %
90     uint256 public Percen = 1000;
91     uint256 public HBWALLETExchange = 21;
92     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
93     uint256 public limitETHFee = 2000000000000000;
94     uint256 public limitHBWALLETFee = 2;
95     uint256 public hightLightFee = 30000000000000000;
96     constructor() public {}
97     struct Price {
98         address payable tokenOwner;
99         uint256 price;
100         uint256 fee;
101         uint256 hbfee;
102         bool isHightlight;
103     }
104 
105     uint[] public arrayTokenIdSale;
106     mapping(uint256 => Price) public prices;
107 
108     /**
109      * @dev Throws if called by any account other than the ceo address.
110      */
111     modifier onlyCeoAddress() {
112         require(msg.sender == ceoAddress);
113         _;
114     }
115 
116     // Move the last element to the deleted spot.
117     // Delete the last element, then correct the length.
118     function _burnArrayTokenIdSale(uint index)  internal {
119         if (index >= arrayTokenIdSale.length) return;
120 
121         for (uint i = index; i<arrayTokenIdSale.length-1; i++){
122             arrayTokenIdSale[i] = arrayTokenIdSale[i+1];
123         }
124         delete arrayTokenIdSale[arrayTokenIdSale.length-1];
125         arrayTokenIdSale.length--;
126     }
127     
128     function _burnArrayTokenIdSaleByArr(uint[] memory arr) internal {
129         for(uint i; i<arr.length; i++){
130             _burnArrayTokenIdSale(i);
131         }
132        
133     }
134     function ownerOf(uint256 _tokenId) public view returns (address){
135         return erc721Address.ownerOf(_tokenId);
136     }
137 
138     function balanceOf() public view returns (uint256){
139         return address(this).balance;
140     }
141 
142     function getApproved(uint256 _tokenId) public view returns (address){
143         return erc721Address.getApproved(_tokenId);
144     }
145 
146     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
147         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
148         arrayTokenIdSale.push(_tokenId);
149     }
150 
151     function calPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns(uint256, uint256) {
152         uint256 ethfee;
153         uint256 _hightLightFee = 0;
154         uint256 ethNeed;
155         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
156             _hightLightFee = hightLightFee;
157         }
158         if (prices[_tokenId].price < _ethPrice) {
159             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
160             if(prices[_tokenId].price == 0) {
161                 if (ethfee >= limitETHFee) {
162                     ethNeed = ethfee + _hightLightFee;
163                 } else {
164                     ethNeed = limitETHFee + _hightLightFee;
165                 }
166             }
167             
168         }
169         return (ethNeed, _hightLightFee);
170     }
171     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public payable {
172         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
173         uint256 ethfee;
174         uint256 _hightLightFee = 0;
175         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
176             _hightLightFee = hightLightFee;
177         }
178         if (prices[_tokenId].price < _ethPrice) {
179             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
180             if(prices[_tokenId].price == 0) {
181                 if (ethfee >= limitETHFee) {
182                     require(msg.value == ethfee + _hightLightFee);
183                 } else {
184                     require(msg.value == limitETHFee + _hightLightFee);
185                     ethfee = limitETHFee;
186                 }
187             }
188             ethfee += prices[_tokenId].fee;
189         } else ethfee = _ethPrice * ETHFee / Percen;
190 
191         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight == 1 ? true : false);
192     }
193     function calPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public view returns (uint256){
194         uint256 fee;
195         uint256 ethfee;
196         uint256 _hightLightFee = 0;
197         uint256 hbNeed;
198         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
199             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
200         }
201         if (prices[_tokenId].price < _ethPrice) {
202             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
203             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
204             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
205             if(prices[_tokenId].price == 0) {
206                 if (fee >= limitHBWALLETFee) {
207                     hbNeed = fee + _hightLightFee;
208                 } else {
209                     hbNeed = limitHBWALLETFee + _hightLightFee;
210                 }
211             }
212         }
213         return hbNeed;
214     }
215     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, uint _isHightLight) public returns (bool){
216         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
217         uint256 fee;
218         uint256 ethfee;
219         uint256 _hightLightFee = 0;
220         if (_isHightLight == 1 && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
221             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
222         }
223         if (prices[_tokenId].price < _ethPrice) {
224             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
225             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
226             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
227             if(prices[_tokenId].price == 0) {
228                 if (fee >= limitHBWALLETFee) {
229                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
230                 } else {
231                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
232                     fee = limitHBWALLETFee;
233                 }
234             }
235             fee += prices[_tokenId].hbfee;
236         } else {
237             ethfee = _ethPrice * ETHFee / Percen;
238             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
239         }
240 
241         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight == 1 ? true : false);
242         return true;
243     }
244 
245     function removePrice(uint256 tokenId) public returns (uint256){
246         require(erc721Address.ownerOf(tokenId) == msg.sender);
247         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
248         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
249         resetPrice(tokenId);
250         return prices[tokenId].price;
251     }
252 
253     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
254         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
255         ETHFee = _ethFee;
256         HBWALLETExchange = _HBWALLETExchange;
257         hightLightFee = _hightLightFee;
258         return (ETHFee, HBWALLETExchange, hightLightFee);
259     }
260 
261     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
262         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
263         limitETHFee = _ethlimitFee;
264         limitHBWALLETFee = _hbWalletlimitFee;
265         return (limitETHFee, limitHBWALLETFee);
266     }
267     /**
268      * @dev Withdraw the amount of eth that is remaining in this contract.
269      * @param _address The address of EOA that can receive token from this contract.
270      */
271     function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
272         require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
273         _address.transfer(amount);
274         hbwalletToken.transferFrom(address(this), _address, _amountHB);
275     }
276     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
277         _withdraw(_address, amount, _amountHB);
278     }
279     function cancelBussiness() public onlyCeoAddress {
280         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
281             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
282                 if (prices[arrayTokenIdSale[i]].fee > 0) {
283                     uint256 eth = prices[arrayTokenIdSale[i]].fee;
284                     if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
285                     if(address(this).balance >= eth) {
286                         prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
287                     } 
288                 }
289                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
290                     uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
291                     if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
292                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
293                         hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
294                     }
295                 }
296             }
297         }
298         _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
299     }
300     
301     function revenue(bool _isEth) public view returns (uint256){
302         uint256 ethfee = 0;
303         uint256 hbfee = 0;
304         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
305             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
306                 if (prices[arrayTokenIdSale[i]].fee > 0) {
307                     ethfee += prices[arrayTokenIdSale[i]].fee;
308                 }
309                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
310                     hbfee += prices[arrayTokenIdSale[i]].hbfee;
311                 }
312             }
313         }
314         uint256 eth = address(this).balance - ethfee;
315         uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
316         return _isEth ? eth : hb;
317     }
318     
319     function changeCeo(address _address) public onlyCeoAddress {
320         require(_address != address(0));
321         ceoAddress = _address;
322 
323     }
324 
325     function buy(uint256 tokenId) public payable {
326         require(getApproved(tokenId) == address(this));
327         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
328         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
329         prices[tokenId].tokenOwner.transfer(msg.value);
330         resetPrice(tokenId);
331     }
332 
333     function buyWithoutCheckApproved(uint256 tokenId) public payable {
334         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
335         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
336         prices[tokenId].tokenOwner.transfer(msg.value);
337         resetPrice(tokenId);
338     }
339 
340     function resetPrice(uint256 tokenId) private {
341         prices[tokenId] = Price(address(0), 0, 0, 0, false);
342         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
343             if (arrayTokenIdSale[i] == tokenId) {
344                 _burnArrayTokenIdSale(i);
345             }
346         }
347     }
348 }