1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 contract IERC721 {
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     function balanceOf(address owner) public view returns (uint256 balance);
49     function ownerOf(uint256 tokenId) public view returns (address owner);
50 
51     function approve(address to, uint256 tokenId) public;
52     function getApproved(uint256 tokenId) public view returns (address operator);
53 
54     function setApprovalForAll(address operator, bool _approved) public;
55     function isApprovedForAll(address owner, address operator) public view returns (bool);
56 
57     function transferFrom(address from, address to, uint256 tokenId) public;
58     function safeTransferFrom(address from, address to, uint256 tokenId) public;
59 
60     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
61 }
62 /**
63  * @title ERC20Basic
64  * @dev Simpler version of ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/179
66  */
67 contract ERC20BasicInterface {
68     function totalSupply() public view returns (uint256);
69     function balanceOf(address who) public view returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     function transferFrom(address from, address to, uint256 value) public returns (bool);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     uint8 public decimals;
75 }
76 contract Bussiness is Ownable {
77   address public ceoAddress = address(0x6c3e879bdd20e9686cfd9bbd1bfd4b2dd6d47079);
78   IERC721 public erc721Address = IERC721(0x06012c8cf97bead5deae237070f9587f8e7a266d);
79   ERC20BasicInterface public usdtToken = ERC20BasicInterface(0x315f396592c3c8a2d96d62fb597e2bf4fa7734ab);
80   ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);
81   uint256 public ETHFee = 25; // 2,5 %
82   uint256 public Percen = 1000;
83   uint256 public HBWALLETExchange = 21;
84   // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2
85   uint256 public limitETHFee = 2000000000000000;
86   uint256 public limitHBWALLETFee = 2;
87   constructor() public {}
88   struct Price {
89     address tokenOwner;
90     uint256 price;
91     uint256 fee;
92     uint256 hbfee;
93   }
94 
95   mapping(uint256 => Price) public prices;
96   mapping(uint256 => Price) public usdtPrices;
97 
98   /**
99    * @dev Throws if called by any account other than the ceo address.
100    */
101   modifier onlyCeoAddress() {
102     require(msg.sender == ceoAddress);
103     _;
104   }
105   function ownerOf(uint256 _tokenId) public view returns (address){
106       return erc721Address.ownerOf(_tokenId);
107   }
108   function balanceOf() public view returns (uint256){
109       return address(this).balance;
110   }
111   function getApproved(uint256 _tokenId) public view returns (address){
112       return erc721Address.getApproved(_tokenId);
113   }
114 
115   function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {
116       require(erc721Address.ownerOf(_tokenId) == msg.sender);
117       prices[_tokenId] = Price(msg.sender, _ethPrice, 0, 0);
118       usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice, 0, 0);
119   }
120   function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice) public payable {
121       require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
122       uint256 ethfee;
123       if(prices[_tokenId].price < _ethPrice) {
124           ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
125           if(ethfee >= limitETHFee) {
126               require(msg.value == ethfee);
127           } else {
128               require(msg.value == limitETHFee);
129           }
130           ethfee += prices[_tokenId].fee;
131       } else ethfee = _ethPrice * ETHFee / Percen;
132       prices[_tokenId] = Price(msg.sender, _ethPrice, ethfee, 0);
133   }
134   function setPriceFeeHBWALLETTest(uint256 _tokenId, uint256 _ethPrice) public view returns (uint256, uint256){
135       uint256 ethfee = _ethPrice * ETHFee / Percen;
136       return (ethfee, ethfee * HBWALLETExchange / 2 / (10 ** 16)); // ethfee / (10 ** 18) * HBWALLETExchange / 2 * (10 ** 2)
137   }
138   function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice) public returns (bool){
139       require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
140       uint256 fee;
141       uint256 ethfee;
142       if(prices[_tokenId].price < _ethPrice) {
143           ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;
144           fee = ethfee * HBWALLETExchange / 2 / (10 ** 16); // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)
145           if(fee >= limitHBWALLETFee) {
146               require(hbwalletToken.transferFrom(msg.sender, address(this), fee));
147           } else {
148               require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee));
149           }
150           fee += prices[_tokenId].hbfee;
151       } else {
152           ethfee = _ethPrice * ETHFee / Percen;
153           fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);
154       }
155       prices[_tokenId] = Price(msg.sender, _ethPrice, 0, fee);
156       return true;
157   }
158   function removePrice(uint256 tokenId) public returns (uint256){
159       require(erc721Address.ownerOf(tokenId) == msg.sender);
160       if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
161       else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);
162       resetPrice(tokenId);
163       return prices[tokenId].price;
164   }
165 
166   function getPrice(uint256 tokenId) public view returns (address, address, uint256, uint256){
167       address currentOwner = erc721Address.ownerOf(tokenId);
168       if(prices[tokenId].tokenOwner != currentOwner){
169            resetPrice(tokenId);
170        }
171       return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);
172 
173   }
174 
175   function setFee(uint256 _ethFee, uint256 _HBWALLETExchange) public view onlyOwner returns (uint256, uint256){
176         require(_ethFee > 0 && _HBWALLETExchange > 0);
177         ETHFee = _ethFee;
178         HBWALLETExchange = _HBWALLETExchange;
179         return (ETHFee, HBWALLETExchange);
180     }
181     function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public view onlyOwner returns (uint256, uint256){
182         require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);
183         limitETHFee = _ethlimitFee;
184         limitHBWALLETFee = _hbWalletlimitFee;
185         return (limitETHFee, limitHBWALLETFee);
186     }
187   /**
188    * @dev Withdraw the amount of eth that is remaining in this contract.
189    * @param _address The address of EOA that can receive token from this contract.
190    */
191     function withdraw(address _address, uint256 amount) public onlyCeoAddress {
192         require(_address != address(0) && amount > 0 && address(this).balance > amount);
193         _address.transfer(amount);
194     }
195 
196   function buy(uint256 tokenId) public payable {
197     require(getApproved(tokenId) == address(this));
198     require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
199     erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
200     prices[tokenId].tokenOwner.transfer(msg.value);
201     resetPrice(tokenId);
202   }
203   function buyByUsdt(uint256 tokenId) public {
204     require(usdtPrices[tokenId].price > 0 && erc721Address.getApproved(tokenId) == address(this));
205     require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));
206 
207     erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);
208     resetPrice(tokenId);
209 
210   }
211   function resetPrice(uint256 tokenId) private {
212     prices[tokenId] = Price(address(0), 0, 0, 0);
213     usdtPrices[tokenId] = Price(address(0), 0, 0, 0);
214   }
215 }