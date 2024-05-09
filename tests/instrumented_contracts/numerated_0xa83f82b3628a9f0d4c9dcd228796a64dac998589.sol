1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13 // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 interface TokenContract {
50   function transfer(address _recipient, uint256 _amount) external returns (bool);
51   function balanceOf(address _holder) external view returns (uint256);
52   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
53 }
54 
55 contract Exchange is Ownable {
56   using SafeMath for uint256;
57 
58   uint256 public buyPrice;
59   uint256 public sellPrice;
60   address public tokenAddress;
61   uint256 private fullEther = 1 ether;
62 
63 
64   constructor() public {
65     buyPrice = 600;
66     sellPrice = 400;
67     tokenAddress = 0x0;
68   }
69 
70   function setBuyPrice(uint256 _price) onlyOwner public {
71     buyPrice = _price;
72   }
73 
74   function setSellPrice(uint256 _price) onlyOwner public {
75     sellPrice = _price;
76   }
77 
78   function() payable public {
79     sellTokens();
80   }
81 
82   function sellTokens() payable public {
83     TokenContract tkn = TokenContract(tokenAddress);
84     uint256 tokensToSell = msg.value.mul(sellPrice);
85     require(tkn.balanceOf(address(this)) >= tokensToSell);
86     tkn.transfer(msg.sender, tokensToSell);
87     emit SellTransaction(msg.value, tokensToSell);
88   }
89 
90   function buyTokens(uint256 _amount) public {
91     address seller = msg.sender;
92     TokenContract tkn = TokenContract(tokenAddress);
93     uint256 transactionPrice = _amount.div(buyPrice);
94     require (address(this).balance >= transactionPrice);
95     require (tkn.transferFrom(msg.sender, address(this), _amount));
96     seller.transfer(transactionPrice);
97     emit BuyTransaction(transactionPrice, _amount);
98   }
99 
100   function getBalance(uint256 _amount) onlyOwner public {
101     msg.sender.transfer(_amount);
102   }
103 
104   function getTokens(uint256 _amount) onlyOwner public {
105     TokenContract tkn = TokenContract(tokenAddress);
106     tkn.transfer(msg.sender, _amount);
107   }
108 
109   function killMe() onlyOwner public {
110     TokenContract tkn = TokenContract(tokenAddress);
111     uint256 tokensLeft = tkn.balanceOf(address(this));
112     tkn.transfer(msg.sender, tokensLeft);
113     msg.sender.transfer(address(this).balance);
114     selfdestruct(owner);
115   }
116 
117   function changeToken(address _address) onlyOwner public {
118     tokenAddress = _address;
119   }
120 
121   event SellTransaction(uint256 ethAmount, uint256 tokenAmount);
122   event BuyTransaction(uint256 ethAmount, uint256 tokenAmount);
123 }