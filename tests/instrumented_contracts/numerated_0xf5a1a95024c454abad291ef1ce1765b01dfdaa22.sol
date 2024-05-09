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
77     address public ceoAddress = address(0x6c3e879bdd20e9686cfd9bbd1bfd4b2dd6d47079);
78   IERC721 public erc721Address = IERC721(0x273f7f8e6489682df756151f5525576e322d51a3);
79   ERC20BasicInterface public usdtToken = ERC20BasicInterface(0xdac17f958d2ee523a2206206994597c13d831ec7);
80   uint256 public ETHFee = 2;
81   uint256 public HBWALLETFee = 1;
82   constructor() public {}
83   struct Price {
84     address tokenOwner;
85     uint256 price;
86     uint256 fee;
87   }
88 
89   mapping(uint256 => Price) public prices;
90   mapping(uint256 => Price) public usdtPrices;
91   
92   /**
93    * @dev Throws if called by any account other than the ceo address.
94    */
95   modifier onlyCeoAddress() {
96     require(msg.sender == ceoAddress);
97     _;
98   }
99   function ownerOf(uint256 _tokenId) public view returns (address){
100       return erc721Address.ownerOf(_tokenId);
101   }
102   function balanceOf() public view returns (uint256){
103       return address(this).balance;
104   }
105   function getApproved(uint256 _tokenId) public view returns (address){
106       return erc721Address.getApproved(_tokenId);
107   }
108   
109   function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {
110       require(erc721Address.ownerOf(_tokenId) == msg.sender);
111       prices[_tokenId] = Price(msg.sender, _ethPrice, 0);
112       usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice, 0);
113   }
114   function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice) public payable {
115       require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
116       uint256 ethfee;
117       if(prices[_tokenId].price < _ethPrice) {
118           ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / 100;
119           require(msg.value == ethfee);
120           ethfee += prices[_tokenId].fee;
121       } else ethfee = _ethPrice * ETHFee / 100;
122       prices[_tokenId] = Price(msg.sender, _ethPrice, ethfee);
123   }
124   function removePrice(uint256 tokenId) public returns (uint256){
125       require(erc721Address.ownerOf(tokenId) == msg.sender);
126       if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
127       resetPrice(tokenId);
128       return prices[tokenId].price;
129   }
130 
131   function getPrice(uint256 tokenId) public view returns (address, address, uint256, uint256){
132       address currentOwner = erc721Address.ownerOf(tokenId);
133       if(prices[tokenId].tokenOwner != currentOwner){
134            resetPrice(tokenId);
135        }
136       return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);
137 
138   }
139 
140   function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 _ETHFee, uint256 _HBWALLETFee){
141         require(_ethFee > 0 && _hbWalletFee > 0);
142         _ETHFee = _ethFee;
143         _HBWALLETFee = _hbWalletFee;
144         return (_ETHFee, _HBWALLETFee);
145     }
146   /**
147    * @dev Withdraw the amount of eth that is remaining in this contract.
148    * @param _address The address of EOA that can receive token from this contract.
149    */
150     function withdraw(address _address, uint256 amount) public onlyCeoAddress {
151         require(_address != address(0) && amount > 0 && address(this).balance > amount);
152         _address.transfer(amount);
153     }
154 
155   function buy(uint256 tokenId) public payable {
156     require(getApproved(tokenId) == address(this));
157     require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
158     erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
159     prices[tokenId].tokenOwner.transfer(msg.value);
160     resetPrice(tokenId);
161   }
162   function buyWithoutCheckApproved(uint256 tokenId) public payable {
163     require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
164     erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
165     prices[tokenId].tokenOwner.transfer(msg.value);
166     resetPrice(tokenId);
167   }
168   function buyByUsdt(uint256 tokenId) public {
169     require(usdtPrices[tokenId].price > 0 && erc721Address.getApproved(tokenId) == address(this));
170     require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));
171 
172     erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);
173     resetPrice(tokenId);
174 
175   }
176   function resetPrice(uint256 tokenId) private {
177     prices[tokenId] = Price(address(0), 0, 0);
178     usdtPrices[tokenId] = Price(address(0), 0, 0);
179   }
180 }