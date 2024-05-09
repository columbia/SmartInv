1 pragma solidity ^0.4.25;
2 
3 contract IERC721 {
4     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
5     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
6     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
7 
8     function balanceOf(address owner) public view returns (uint256 balance);
9     function ownerOf(uint256 tokenId) public view returns (address owner);
10 
11     function approve(address to, uint256 tokenId) public;
12     function getApproved(uint256 tokenId) public view returns (address operator);
13 
14     function setApprovalForAll(address operator, bool _approved) public;
15     function isApprovedForAll(address owner, address operator) public view returns (bool);
16 
17     function transferFrom(address from, address to, uint256 tokenId) public;
18     function safeTransferFrom(address from, address to, uint256 tokenId) public;
19 
20     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
21 }
22 /**
23  * @title ERC20Basic
24  * @dev Simpler version of ERC20 interface
25  * @dev see https://github.com/ethereum/EIPs/issues/179
26  */
27 contract ERC20BasicInterface {
28     function totalSupply() public view returns (uint256);
29     function balanceOf(address who) public view returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     function transferFrom(address from, address to, uint256 value) public returns (bool);
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     uint8 public decimals;
35 }
36 contract Bussiness {
37   IERC721 public erc721Address;
38   ERC20BasicInterface usdtToken = ERC20BasicInterface(0xdac17f958d2ee523a2206206994597c13d831ec7);
39   constructor(IERC721 token) public {
40      erc721Address = token;
41   }
42   struct Price {
43     address tokenOwner;
44     uint256 price;
45   }
46 
47   mapping(uint256 => Price) public prices;
48   mapping(uint256 => Price) public usdtPrices;
49   function ownerOf(uint256 _tokenId) public view returns (address){
50       return erc721Address.ownerOf(_tokenId);
51   }
52   function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {
53       require(erc721Address.ownerOf(_tokenId) == msg.sender);
54       prices[_tokenId] = Price(msg.sender, _ethPrice);
55       usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice);
56   }
57   function removePrice(uint256 tokenId) public returns (uint256){
58       require(erc721Address.ownerOf(tokenId) == msg.sender);
59       resetPrice(tokenId);
60       return prices[tokenId].price;
61   }
62 
63   function getPrice(uint256 tokenId) public returns (address, address, uint256, uint256){
64       address currentOwner = erc721Address.ownerOf(tokenId);
65       if(prices[tokenId].tokenOwner != currentOwner){
66            resetPrice(tokenId);
67        }
68       return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);
69 
70   }
71   function buy(uint256 tokenId) public payable {
72     require(erc721Address.getApproved(tokenId) == address(this));
73     require(prices[tokenId].price == msg.value);
74     erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);
75     prices[tokenId].tokenOwner.transfer(msg.value);
76     resetPrice(tokenId);
77   }
78   function buyByUsdt(uint256 tokenId) public {
79     require(erc721Address.getApproved(tokenId) == address(this));
80     require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));
81 
82     erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);
83     usdtPrices[tokenId].tokenOwner.transfer(msg.value);
84     resetPrice(tokenId);
85 
86   }
87   function resetPrice(uint256 tokenId) private {
88     prices[tokenId] = Price(address(0), 0);
89     usdtPrices[tokenId] = Price(address(0), 0);
90   }
91 }