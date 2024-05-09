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
19   function Ownable() public {
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
77   IERC721 public erc721Address = IERC721(0x06012c8cf97bead5deae237070f9587f8e7a266d);
78   ERC20BasicInterface public usdtToken = ERC20BasicInterface(0xdAC17F958D2ee523a2206206994597C13D831ec7);
79   uint256 public ETHFee = 2;
80   uint256 public HBWALLETFee = 1;
81   uint256 public balance = address(this).balance;
82   constructor() public {}
83   struct Price {
84     address tokenOwner;
85     uint256 price;
86     uint256 fee;
87   }
88 
89   mapping(uint256 => Price) public prices;
90   mapping(uint256 => Price) public usdtPrices;
91   function ownerOf(uint256 _tokenId) public view returns (address){
92       return erc721Address.ownerOf(_tokenId);
93   }
94   function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {
95       require(erc721Address.ownerOf(_tokenId) == msg.sender);
96       prices[_tokenId] = Price(msg.sender, _ethPrice, 0);
97       usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice, 0);
98   }
99   function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice) public payable {
100       require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);
101       uint256 ethfee;
102       if(prices[_tokenId].price < _ethPrice) {
103           ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / 100;
104           require(msg.value == ethfee);
105           ethfee += prices[_tokenId].fee;
106       } else ethfee = _ethPrice * ETHFee / 100;
107       prices[_tokenId] = Price(msg.sender, _ethPrice, ethfee);
108   }
109   function removePrice(uint256 tokenId) public returns (uint256){
110       require(erc721Address.ownerOf(tokenId) == msg.sender);
111       if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);
112       resetPrice(tokenId);
113       return prices[tokenId].price;
114   }
115 
116   function getPrice(uint256 tokenId) public returns (address, address, uint256, uint256){
117       address currentOwner = erc721Address.ownerOf(tokenId);
118       if(prices[tokenId].tokenOwner != currentOwner){
119            resetPrice(tokenId);
120        }
121       return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);
122 
123   }
124 
125   function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 ETHFee, uint256 HBWALLETFee){
126         require(_ethFee > 0 && _hbWalletFee > 0);
127         ETHFee = _ethFee;
128         HBWALLETFee = _hbWalletFee;
129         return (ETHFee, HBWALLETFee);
130     }
131   /**
132    * @dev Withdraw the amount of eth that is remaining in this contract.
133    * @param _address The address of EOA that can receive token from this contract.
134    */
135     function withdraw(address _address, uint256 amount) public onlyOwner {
136         require(_address != address(0) && amount > 0 && address(this).balance > amount);
137         _address.transfer(amount);
138     }
139 
140   function buy(uint256 tokenId) public payable {
141     require(erc721Address.getApproved(tokenId) == address(this));
142     require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);
143     erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
144     prices[tokenId].tokenOwner.transfer(msg.value);
145     resetPrice(tokenId);
146   }
147   function buyByUsdt(uint256 tokenId) public {
148     require(usdtPrices[tokenId].price > 0 && erc721Address.getApproved(tokenId) == address(this));
149     require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));
150 
151     erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);
152     resetPrice(tokenId);
153 
154   }
155   function resetPrice(uint256 tokenId) private {
156     prices[tokenId] = Price(address(0), 0, 0);
157     usdtPrices[tokenId] = Price(address(0), 0, 0);
158   }
159 }