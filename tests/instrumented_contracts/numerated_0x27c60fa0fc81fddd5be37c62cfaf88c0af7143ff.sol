1 pragma solidity ^0.4.18;
2 // **-----------------------------------------------
3 // POWToken Storage.
4 // Contract in address PowerLineUpStorage.eth
5 // Storage for 30,000,000 in-platform MOYTokens. 
6 // Tokens only available through mining, stacking and tournaments in-platform through smart contracts.
7 // Proyect must have enough funds provided by PowerLineUp and partners to realease tokens. 
8 // This Contract stores the token and keeps record of own funding by PowerLineUp and partners. 
9 // For Open Distribution refer to contract at powcrowdsale.eth (will be launched only if own funding (PreSale) of proyect succeeds.)
10 // All operations can be monitored at etherscan.io
11 
12 // **-----------------------------------------------
13 // ERC Token Standard #20 Interface
14 // https://github.com/ethereum/EIPs/issues/20
15 // -------------------------------------------------
16 
17 contract owned {
18     address public owner;
19 
20     function owned() public {
21         owner = msg.sender;
22     }
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27     function transferOwnership(address newOwner) public onlyOwner {
28         owner = newOwner;
29     }
30 }
31 
32 contract safeMath {
33   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a * b;
35     safeAssert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
40     safeAssert(b > 0);
41     uint256 c = a / b;
42     safeAssert(a == b * c + a % b);
43     return c;
44   }
45 
46   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
47     safeAssert(b <= a);
48     return a - b;
49   }
50 
51   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     safeAssert(c>=a && c>=b);
54     return c;
55   }
56 
57   function safeAssert(bool assertion) internal pure {
58     if (!assertion) revert();
59   }
60 }
61 
62 contract StandardToken is owned, safeMath {
63   function balanceOf(address who) public constant returns (uint256);
64   function transfer(address to, uint256 value) public returns (bool);
65   event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 contract MoyTokenStorage is owned, safeMath {
69   // owner/admin & token reward
70   address        public admin = owner;   //admin address
71   StandardToken  public tokenContract;     // address of MoibeTV MOY ERC20 Standard Token.
72 
73   // loop control and limiters for funding proyect and mineable tokens through presale.
74 
75   string  public CurrentStatus = "";                          // current preSale status
76   uint256 public fundingStartBlock;                           // preSale start block#
77   uint256 public fundingEndBlock;                             // preSale end block#
78   uint256 public successAtBlock;                              // the private funding succeed at this block. All in-platform tokens backed.
79   uint256 public amountRaisedInUsd;                           //amount raised in USD for tokens backing. 
80   uint256 public tokensPerEthAtRegularPrice; 
81   bool public successfulPreSale; 
82          
83   
84 
85   event Transfer(address indexed from, address indexed to, uint256 value); 
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87   event Buy(address indexed _sender, uint256 _eth, uint256 _MOY);
88   mapping(address => uint256) balancesArray;
89   mapping(address => uint256) fundValue;
90 
91   // default function, map admin
92   function MoyTokenStorage() public onlyOwner {
93     admin = msg.sender;
94     CurrentStatus = "In-Platform POW Tokens Storage Released";
95   }
96 
97   
98   // setup the PreSale parameters
99   function setupStorage(uint256 _fundingStartBlock, uint256 _fundingEndBlock) public onlyOwner returns (bytes32 response) {
100       
101       if (msg.sender == admin)
102       {
103           tokenContract = StandardToken(0x2ea1EA9419A126673D1bBFdfE82524ea9E6F848B);  //MOYtoken Smart Contract.
104           tokensPerEthAtRegularPrice = 1000;                                         //Regular Price 1 ETH = 1000 MOY in-platform.Value to calculate proyect funding.
105           amountRaisedInUsd = 0;
106 
107           fundingStartBlock = _fundingStartBlock;
108           fundingEndBlock = _fundingEndBlock;
109                 
110           CurrentStatus = "Fundind of Proyect in Process";
111           //PowerLineUp is funding the proyect to be able to launch the tokens. 
112           
113           return "Storage is setup.";
114 
115       } else if (msg.sender != admin) {
116           return "Not Authorized";
117       } else  {
118           return "Setup cannot be changed.";
119       }
120     }
121 
122   // setup success parameters if proyect funding succeed. 
123   function FundingCompleted(uint256 _amountRaisedInUsd, uint256 _successAtBlock) public onlyOwner returns (bytes32 response) {
124       if (msg.sender == admin)
125       {
126           // Funding is the capital invested by PowerLineUp and partners to back the whole proyect and the tokens released.
127           amountRaisedInUsd = _amountRaisedInUsd; //amount raised includes development, human resources, infraestructure, design and marketing achieved by the proyect founders and partners.
128           successAtBlock = _successAtBlock;       //Block when goal reached.
129           successfulPreSale = true;       
130           CurrentStatus = "Funding Successful, in-platform tokens ready to use.";
131 
132           
133           return "All in-platform tokens backed.";
134       } else if (msg.sender != admin) {
135           return "Not Authorized";
136       } else {
137           return "Setup cannot be changed.";
138       }
139     }
140 
141     // default payable function when sending ether to this contract
142     // only owner (PowerLineUp) can send ether to this address.
143     function () public payable {
144       require(msg.sender == admin);
145       Transfer(this, msg.sender, msg.value); 
146     }
147 }