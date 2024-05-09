1 // GYM Ledger Token Sale Contract - Project website: www.gymledger.com
2 
3 // GYM Reward, LLC
4 
5 pragma solidity ^0.4.25;
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   constructor() public {
39     owner = msg.sender;
40   }
41   modifier onlyOwner() {
42     require(msg.sender == owner, "Only owner can call this function");
43     _;
44   }
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0), "Valid address is required");
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 interface TokenContract {
54   function mintTo(address _to, uint256 _amount) external;
55 }
56 
57 contract LGRSale is Ownable {
58   using SafeMath for uint256;
59 
60   address public walletAddress;
61   TokenContract public tkn;
62   uint256[3] public pricePerToken = [1400 szabo, 1500 szabo, 2000 szabo];
63   uint256[3] public levelEndDate = [1539648000, 1541030400, 1546300740];
64   uint256 public startDate = 1538352000;
65   uint8 public currentLevel;
66   uint256 public tokensSold;
67 
68   constructor() public {
69     currentLevel = 0;
70     tokensSold = 0;
71     walletAddress = 0xE38cc3F48b4F98Cb3577aC75bB96DBBc87bc57d6;
72     tkn = TokenContract(0x7172433857c83A68F6Dc98EdE4391c49785feD0B);
73   }
74 
75   function() public payable {
76     
77     if (levelEndDate[currentLevel] < now) {
78       currentLevel += 1;
79       if (currentLevel > 2) {
80         msg.sender.transfer(msg.value);
81       } else {
82         executeSell();
83       }
84     } else {
85       executeSell();
86     }
87   }
88   
89   function executeSell() private {
90     uint256 tokensToSell;
91     require(msg.value >= pricePerToken[currentLevel], "Minimum amount is 1 token");
92     tokensToSell = msg.value.div(pricePerToken[currentLevel]);
93     tkn.mintTo(msg.sender, tokensToSell);
94     tokensSold = tokensSold.add(tokensToSell);
95     walletAddress.transfer(msg.value);
96   }
97 
98   function killContract(bool _kill) public onlyOwner {
99     if (_kill == true) {
100       selfdestruct(owner);
101     }
102   }
103 
104   function setWallet(address _wallet) public onlyOwner {
105     walletAddress = _wallet;
106   }
107 
108   function setLevelEndDate(uint256 _level, uint256 _date) public onlyOwner {
109     levelEndDate[_level] = _date;
110   }
111 
112 }