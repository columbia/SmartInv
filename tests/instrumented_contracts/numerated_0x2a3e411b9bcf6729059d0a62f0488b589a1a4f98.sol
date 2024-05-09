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
89     uint256 public ETHFee = 0; // 25 = 2,5 %
90     uint256 public Percen = 1000;
91     uint256 public HBWALLETExchange = 21;
92     // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
93     uint256 public limitETHFee = 0;
94     uint256 public limitHBWALLETFee = 0;
95     uint256 public hightLightFee = 10000000000000000;
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
151     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {
152         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
153         uint256 ethfee;
154         uint256 _hightLightFee = 0;
155         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
156             _hightLightFee = hightLightFee;
157         }
158         if (prices[_tokenId].price < _ethPrice) {
159             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
160             if(prices[_tokenId].price == 0) {
161                 if (ethfee >= limitETHFee) {
162                     require(msg.value == ethfee + _hightLightFee);
163                 } else {
164                     require(msg.value == limitETHFee + _hightLightFee);
165                     ethfee = limitETHFee;
166                 }
167             }
168             ethfee += prices[_tokenId].fee;
169         } else ethfee = _ethPrice * ETHFee / Percen;
170 
171         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight);
172     }
173 
174     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){
175         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
176         uint256 fee;
177         uint256 ethfee;
178         uint256 _hightLightFee = 0;
179         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
180             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
181         }
182         if (prices[_tokenId].price < _ethPrice) {
183             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
184             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
185             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
186             if(prices[_tokenId].price == 0) {
187                 if (fee >= limitHBWALLETFee) {
188                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
189                 } else {
190                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
191                     fee = limitHBWALLETFee;
192                 }
193             }
194             fee += prices[_tokenId].hbfee;
195         } else {
196             ethfee = _ethPrice * ETHFee / Percen;
197             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
198         }
199 
200         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight);
201         return true;
202     }
203 
204     function removePrice(uint256 tokenId) public returns (uint256){
205         require(erc721Address.ownerOf(tokenId) == msg.sender);
206         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
207         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
208         resetPrice(tokenId);
209         return prices[tokenId].price;
210     }
211 
212     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
213         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
214         ETHFee = _ethFee;
215         HBWALLETExchange = _HBWALLETExchange;
216         hightLightFee = _hightLightFee;
217         return (ETHFee, HBWALLETExchange, hightLightFee);
218     }
219 
220     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
221         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
222         limitETHFee = _ethlimitFee;
223         limitHBWALLETFee = _hbWalletlimitFee;
224         return (limitETHFee, limitHBWALLETFee);
225     }
226     /**
227      * @dev Withdraw the amount of eth that is remaining in this contract.
228      * @param _address The address of EOA that can receive token from this contract.
229      */
230     function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
231         require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
232         _address.transfer(amount);
233         hbwalletToken.transferFrom(address(this), _address, _amountHB);
234     }
235     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
236         _withdraw(_address, amount, _amountHB);
237     }
238     function cancelBussiness() public onlyCeoAddress {
239         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
240             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
241                 if (prices[arrayTokenIdSale[i]].fee > 0) {
242                     uint256 eth = prices[arrayTokenIdSale[i]].fee;
243                     if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
244                     if(address(this).balance >= eth) {
245                         prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
246                     } 
247                 }
248                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
249                     uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
250                     if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
251                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
252                         hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
253                     }
254                 }
255             }
256         }
257         _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
258     }
259     
260     function revenue(bool _isEth) public view onlyCeoAddress returns (uint256){
261         uint256 ethfee = 0;
262         uint256 hbfee = 0;
263         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
264             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
265                 if (prices[arrayTokenIdSale[i]].fee > 0) {
266                     ethfee += prices[arrayTokenIdSale[i]].fee;
267                 }
268                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
269                     hbfee += prices[arrayTokenIdSale[i]].hbfee;
270                 }
271             }
272         }
273         uint256 eth = address(this).balance - ethfee;
274         uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
275         return _isEth ? eth : hb;
276     }
277     
278     function changeCeo(address _address) public onlyCeoAddress {
279         require(_address != address(0));
280         ceoAddress = _address;
281 
282     }
283 
284     function buy(uint256 tokenId) public payable {
285         require(getApproved(tokenId) == address(this));
286         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
287         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
288         prices[tokenId].tokenOwner.transfer(msg.value);
289         resetPrice(tokenId);
290     }
291 
292     function buyWithoutCheckApproved(uint256 tokenId) public payable {
293         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
294         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
295         prices[tokenId].tokenOwner.transfer(msg.value);
296         resetPrice(tokenId);
297     }
298 
299     function resetPrice(uint256 tokenId) private {
300         prices[tokenId] = Price(address(0), 0, 0, 0, false);
301         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
302             if (arrayTokenIdSale[i] == tokenId) {
303                 _burnArrayTokenIdSale(i);
304             }
305         }
306     }
307 }