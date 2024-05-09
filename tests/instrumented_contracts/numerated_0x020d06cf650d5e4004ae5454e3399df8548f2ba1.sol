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
118     function _burnArrayTokenIdSale(uint index) internal {
119         require(index < arrayTokenIdSale.length);
120         arrayTokenIdSale[index] = arrayTokenIdSale[arrayTokenIdSale.length - 1];
121         delete arrayTokenIdSale[arrayTokenIdSale.length - 1];
122         arrayTokenIdSale.length--;
123     }
124     function _burnArrayTokenIdSaleByArr(uint[] memory arr) internal {
125         for(uint i; i<arr.length; i++){
126             arrayTokenIdSale[i] = arrayTokenIdSale[arrayTokenIdSale.length - 1];
127             delete arrayTokenIdSale[arrayTokenIdSale.length - 1];
128             arrayTokenIdSale.length--;
129         }
130        
131     }
132     function ownerOf(uint256 _tokenId) public view returns (address){
133         return erc721Address.ownerOf(_tokenId);
134     }
135 
136     function balanceOf() public view returns (uint256){
137         return address(this).balance;
138     }
139 
140     function getApproved(uint256 _tokenId) public view returns (address){
141         return erc721Address.getApproved(_tokenId);
142     }
143 
144     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
145         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
146         arrayTokenIdSale.push(_tokenId);
147     }
148 
149     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {
150         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
151         uint256 ethfee;
152         uint256 _hightLightFee = 0;
153         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
154             _hightLightFee = hightLightFee;
155         }
156         if (prices[_tokenId].price < _ethPrice) {
157             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
158             if(prices[_tokenId].price == 0) {
159                 if (ethfee >= limitETHFee) {
160                     require(msg.value == ethfee + _hightLightFee);
161                 } else {
162                     require(msg.value == limitETHFee + _hightLightFee);
163                     ethfee = limitETHFee;
164                 }
165             }
166             ethfee += prices[_tokenId].fee;
167         } else ethfee = _ethPrice * ETHFee / Percen;
168 
169         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight);
170     }
171 
172     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){
173         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
174         uint256 fee;
175         uint256 ethfee;
176         uint256 _hightLightFee = 0;
177         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
178             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
179         }
180         if (prices[_tokenId].price < _ethPrice) {
181             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
182             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
183             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
184             if(prices[_tokenId].price == 0) {
185                 if (fee >= limitHBWALLETFee) {
186                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
187                 } else {
188                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
189                     fee = limitHBWALLETFee;
190                 }
191             }
192             fee += prices[_tokenId].hbfee;
193         } else {
194             ethfee = _ethPrice * ETHFee / Percen;
195             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
196         }
197 
198         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight);
199         return true;
200     }
201 
202     function removePrice(uint256 tokenId) public returns (uint256){
203         require(erc721Address.ownerOf(tokenId) == msg.sender);
204         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
205         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
206         resetPrice(tokenId);
207         return prices[tokenId].price;
208     }
209 
210     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
211         require(_ethFee >= 0 && _HBWALLETExchange >= 1 && _hightLightFee >= 0);
212         ETHFee = _ethFee;
213         HBWALLETExchange = _HBWALLETExchange;
214         hightLightFee = _hightLightFee;
215         return (ETHFee, HBWALLETExchange, hightLightFee);
216     }
217 
218     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
219         require(_ethlimitFee >= 0 && _hbWalletlimitFee >= 0);
220         limitETHFee = _ethlimitFee;
221         limitHBWALLETFee = _hbWalletlimitFee;
222         return (limitETHFee, limitHBWALLETFee);
223     }
224     /**
225      * @dev Withdraw the amount of eth that is remaining in this contract.
226      * @param _address The address of EOA that can receive token from this contract.
227      */
228     function _withdraw(address payable _address, uint256 amount, uint256 _amountHB) internal {
229         require(_address != address(0) && amount >= 0 && address(this).balance >= amount && _amountHB >= 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
230         _address.transfer(amount);
231         hbwalletToken.transferFrom(address(this), _address, _amountHB);
232     }
233     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
234         _withdraw(_address, amount, _amountHB);
235     }
236     function cancelBussiness() public onlyCeoAddress {
237         for (uint i = 0; i < arrayTokenIdSale.length; i++) {
238             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
239                 if (prices[arrayTokenIdSale[i]].fee > 0) {
240                     uint256 eth = prices[arrayTokenIdSale[i]].fee;
241                     if(prices[arrayTokenIdSale[i]].isHightlight == true) eth += hightLightFee;
242                     if(address(this).balance >= eth) {
243                         prices[arrayTokenIdSale[i]].tokenOwner.transfer(eth);
244                     } 
245                 }
246                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
247                     uint256 hb = prices[arrayTokenIdSale[i]].hbfee;
248                     if(prices[arrayTokenIdSale[i]].isHightlight == true) hb += hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
249                     if(hbwalletToken.balanceOf(address(this)) >= hb) {
250                         hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, hb);
251                     }
252                 }
253             }
254         }
255         _withdraw(msg.sender, address(this).balance, hbwalletToken.balanceOf(address(this)));
256     }
257     
258     function revenue(bool _isEth) public view onlyCeoAddress returns (uint256){
259         uint256 ethfee = 0;
260         uint256 hbfee = 0;
261         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
262             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
263                 if (prices[arrayTokenIdSale[i]].fee > 0) {
264                     ethfee += prices[arrayTokenIdSale[i]].fee;
265                 }
266                 else if (prices[arrayTokenIdSale[i]].hbfee > 0) {
267                     hbfee += prices[arrayTokenIdSale[i]].hbfee;
268                 }
269             }
270         }
271         uint256 eth = address(this).balance - ethfee;
272         uint256 hb = hbwalletToken.balanceOf(address(this)) - hbfee;
273         return _isEth ? eth : hb;
274     }
275     
276     function changeCeo(address _address) public onlyCeoAddress {
277         require(_address != address(0));
278         ceoAddress = _address;
279 
280     }
281 
282     function buy(uint256 tokenId) public payable {
283         require(getApproved(tokenId) == address(this));
284         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
285         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
286         prices[tokenId].tokenOwner.transfer(msg.value);
287         resetPrice(tokenId);
288     }
289 
290     function buyWithoutCheckApproved(uint256 tokenId) public payable {
291         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
292         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
293         prices[tokenId].tokenOwner.transfer(msg.value);
294         resetPrice(tokenId);
295     }
296 
297     function resetPrice(uint256 tokenId) private {
298         prices[tokenId] = Price(address(0), 0, 0, 0, false);
299         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
300             if (arrayTokenIdSale[i] == tokenId) {
301                 _burnArrayTokenIdSale(i);
302             }
303         }
304     }
305 }