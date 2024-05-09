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
86     address public ceoAddress = address(0x6C3E879BDD20e9686cfD9BBD1bfD4B2Dd6d47079);
87     IERC721 public erc721Address = IERC721(0x5D00d312e171Be5342067c09BaE883f9Bcb2003B);
88     ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
89     uint256 public ETHFee = 25; // 2,5 %
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
118     function _burnArrayTokenIdSale(uint index) internal {
119         require(index < arrayTokenIdSale.length);
120         arrayTokenIdSale[index] = arrayTokenIdSale[arrayTokenIdSale.length - 1];
121         delete arrayTokenIdSale[arrayTokenIdSale.length - 1];
122         arrayTokenIdSale.length--;
123     }
124 
125     function ownerOf(uint256 _tokenId) public view returns (address){
126         return erc721Address.ownerOf(_tokenId);
127     }
128 
129     function balanceOf() public view returns (uint256){
130         return address(this).balance;
131     }
132 
133     function getApproved(uint256 _tokenId) public view returns (address){
134         return erc721Address.getApproved(_tokenId);
135     }
136 
137     function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _ethfee, uint256 _hbfee, bool _isHightLight) internal {
138         prices[_tokenId] = Price(msg.sender, _ethPrice, _ethfee, _hbfee, _isHightLight);
139         arrayTokenIdSale.push(_tokenId);
140     }
141 
142     function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public payable {
143         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
144         uint256 ethfee;
145         uint256 _hightLightFee = 0;
146         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
147             _hightLightFee = hightLightFee;
148         }
149         if (prices[_tokenId].price < _ethPrice) {
150             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
151             if(prices[_tokenId].price == 0) {
152                 if (ethfee >= limitETHFee) {
153                     require(msg.value == ethfee + _hightLightFee);
154                 } else {
155                     require(msg.value == limitETHFee + _hightLightFee);
156                     ethfee = limitETHFee;
157                 }
158             }
159             ethfee += prices[_tokenId].fee;
160         } else ethfee = _ethPrice * ETHFee / Percen;
161 
162         setPrice(_tokenId, _ethPrice, ethfee, 0, _isHightLight);
163     }
164 
165     function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice, bool _isHightLight) public returns (bool){
166         require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
167         uint256 fee;
168         uint256 ethfee;
169         uint256 _hightLightFee = 0;
170         if (_isHightLight == true && (prices[_tokenId].price == 0 || prices[_tokenId].isHightlight == false)) {
171             _hightLightFee = hightLightFee * HBWALLETExchange / 2 / (10 ** 16);
172         }
173         if (prices[_tokenId].price < _ethPrice) {
174             ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
175             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
176             // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
177             if(prices[_tokenId].price == 0) {
178                 if (fee >= limitHBWALLETFee) {
179                     require(hbwalletToken.transferFrom(msg.sender, address(this), fee + _hightLightFee));
180                 } else {
181                     require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee + _hightLightFee));
182                     fee = limitHBWALLETFee;
183                 }
184             }
185             fee += prices[_tokenId].hbfee;
186         } else {
187             ethfee = _ethPrice * ETHFee / Percen;
188             fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
189         }
190 
191         setPrice(_tokenId, _ethPrice, 0, fee, _isHightLight);
192         return true;
193     }
194 
195     function removePrice(uint256 tokenId) public returns (uint256){
196         require(erc721Address.ownerOf(tokenId) == msg.sender);
197         if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
198         else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
199         resetPrice(tokenId);
200         return prices[tokenId].price;
201     }
202 
203     function setFee(uint256 _ethFee, uint256 _HBWALLETExchange, uint256 _hightLightFee) public onlyOwner returns (uint256, uint256, uint256){
204         require(_ethFee > 0 && _HBWALLETExchange > 0 && _hightLightFee > 0);
205         ETHFee = _ethFee;
206         HBWALLETExchange = _HBWALLETExchange;
207         hightLightFee = _hightLightFee;
208         return (ETHFee, HBWALLETExchange, hightLightFee);
209     }
210 
211     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public onlyOwner returns (uint256, uint256){
212         require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);
213         limitETHFee = _ethlimitFee;
214         limitHBWALLETFee = _hbWalletlimitFee;
215         return (limitETHFee, limitHBWALLETFee);
216     }
217     /**
218      * @dev Withdraw the amount of eth that is remaining in this contract.
219      * @param _address The address of EOA that can receive token from this contract.
220      */
221     function withdraw(address payable _address, uint256 amount, uint256 _amountHB) public onlyCeoAddress {
222         require(_address != address(0) && amount > 0 && address(this).balance >= amount && _amountHB > 0 && hbwalletToken.balanceOf(address(this)) >= _amountHB);
223         _address.transfer(amount);
224         hbwalletToken.transferFrom(address(this), _address, _amountHB);
225     }
226 
227     function cancelBussiness() public onlyCeoAddress {
228         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
229             if (prices[arrayTokenIdSale[i]].tokenOwner == erc721Address.ownerOf(arrayTokenIdSale[i])) {
230                 if (prices[arrayTokenIdSale[i]].fee > 0 && address(this).balance >= prices[arrayTokenIdSale[i]].fee) {
231                     prices[arrayTokenIdSale[i]].tokenOwner.transfer(prices[arrayTokenIdSale[i]].fee);
232                 }
233                 else if (prices[arrayTokenIdSale[i]].hbfee > 0 && hbwalletToken.balanceOf(address(this)) >= prices[arrayTokenIdSale[i]].hbfee) {
234                     hbwalletToken.transfer(prices[arrayTokenIdSale[i]].tokenOwner, prices[arrayTokenIdSale[i]].hbfee);
235                 }
236             }
237             resetPrice(arrayTokenIdSale[i]);
238         }
239     }
240 
241     function changeCeo(address _address) public onlyCeoAddress {
242         require(_address != address(0));
243         ceoAddress = _address;
244 
245     }
246 
247     function buy(uint256 tokenId) public payable {
248         require(getApproved(tokenId) == address(this));
249         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
250         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
251         prices[tokenId].tokenOwner.transfer(msg.value);
252         resetPrice(tokenId);
253     }
254 
255     function buyWithoutCheckApproved(uint256 tokenId) public payable {
256         require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
257         erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
258         prices[tokenId].tokenOwner.transfer(msg.value);
259         resetPrice(tokenId);
260     }
261 
262     function resetPrice(uint256 tokenId) private {
263         prices[tokenId] = Price(address(0), 0, 0, 0, false);
264         for (uint256 i = 0; i < arrayTokenIdSale.length; i++) {
265             if (arrayTokenIdSale[i] == tokenId) {
266                 _burnArrayTokenIdSale(i);
267             }
268         }
269     }
270 }