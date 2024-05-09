1 pragma solidity ^0.4.18;
2 // **-----------------------------------------------
3 // POWToken Storage.
4 // Contract in address PowerLineUpStorage.eth
5 // Storage for 30,000,000 in-platform POWTokens. 
6 // Tokens only available through mining, stacking and tournaments in-platform through smart contracts.
7 // Proyect must have enough funds provided by PowerLineUp and partners to realease tokens. 
8 // This Contract stores the token and keeps record of own funding by PowerLineUp and partners. 
9 // For Open Distribution refer to contract at powcrowdsale.eth (will be launched after private funding is closed).
10 // All operations can be monitored at etherscan.io
11 
12 // **-----------------------------------------------
13 // ERC Token Standard #20 Interface
14 // https://github.com/ethereum/EIPs/issues/20
15 // -------------------------------------------------
16 interface ERC20I {
17     function transfer(address _recipient, uint256 _amount) public returns (bool);
18     function balanceOf(address _holder) public view returns (uint256);
19 }
20 
21 contract owned {
22     address public owner;
23 
24     function owned() public {
25         owner = msg.sender;
26     }
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     function transferOwnership(address newOwner) public onlyOwner {
32         owner = newOwner;
33     }
34 }
35 
36 contract safeMath {
37   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a * b;
39     safeAssert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
44     safeAssert(b > 0);
45     uint256 c = a / b;
46     safeAssert(a == b * c + a % b);
47     return c;
48   }
49 
50   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
51     safeAssert(b <= a);
52     return a - b;
53   }
54 
55   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     safeAssert(c>=a && c>=b);
58     return c;
59   }
60 
61   function safeAssert(bool assertion) internal pure {
62     if (!assertion) revert();
63   }
64 }
65 
66 contract StandardToken is owned, safeMath {
67   function balanceOf(address who) public constant returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract POWTokenStorage is owned, safeMath {
73   // owner/admin & token reward
74   address        public admin = owner;                        //admin address
75   StandardToken  public tokenContract;                        // address of POWToken ERC20 Standard Token.
76 
77   // loop control and limiters for funding proyect and mineable tokens through own and private partners funding.
78 
79   string  public CurrentStatus = "";                          // Current Funding status
80   uint256 public fundingStartBlock;                           // Funding start block#
81   uint256 public fundingEndBlock;                             // Funding end block#
82   uint256 public successAtBlock;                              // Private funding succeed at this block. All in-platform tokens backed.
83   uint256 public amountRaisedInUsd;                           // Amount raised in USD for tokens backing. 
84   uint256 public tokensPerEthAtRegularPrice;                  // Regular Price of POW Tokens for Funding calculations.
85   bool public successfulFunding;                              // True if amount neccesary for Funding Stored Tokens is achieved.
86          
87   
88 
89   event Transfer(address indexed from, address indexed to, uint256 value); 
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91   event Buy(address indexed _sender, uint256 _eth, uint256 _POW);
92   mapping(address => uint256) balancesArray;
93   mapping(address => uint256) fundValue;
94 
95   // default function, map admin
96   function POWTokenStorage() public onlyOwner {
97     admin = msg.sender;
98     CurrentStatus = "In-Platform POW Tokens Storage Released";
99   }
100 
101   
102   // setup the Funding parameters
103   function setupFunding(uint256 _fundingStartBlock, uint256 _fundingEndBlock, address _tokenContract) public onlyOwner returns (bytes32 response) {
104       
105       if (msg.sender == admin)
106       {
107           tokenContract = StandardToken(_tokenContract);                              //POWtoken Smart Contract.
108           tokensPerEthAtRegularPrice = 1000;                                          //Regular Price 1 ETH = 1000 POW in-platform.Value to calculate proyect funding.
109           amountRaisedInUsd = 0;
110 
111           fundingStartBlock = _fundingStartBlock;
112           fundingEndBlock = _fundingEndBlock;
113                 
114           CurrentStatus = "Fundind of Proyect in Process";
115           //PowerLineUp is funding the proyect to be able to launch the tokens. 
116           
117           return "PreSale is setup.";
118 
119       } else if (msg.sender != admin) {
120           return "Not Authorized";
121       } else  {
122           return "Setup cannot be changed.";
123       }
124     }
125 
126   // setup success parameters if proyect funding succeed. 
127   function FundingCompleted(uint256 _amountRaisedInUsd, uint256 _successAtBlock) public onlyOwner returns (bytes32 response) {
128       if (msg.sender == admin)
129       {
130           // Funding is the capital invested by PowerLineUp and partners to back the whole proyect and the tokens released.
131           amountRaisedInUsd = _amountRaisedInUsd; //amount raised includes development, human resources, infraestructure, design and marketing achieved by the proyect founders and partners.
132           successAtBlock = _successAtBlock;       //Block when goal reached.
133           successfulFunding = true;       
134           CurrentStatus = "Funding Successful, in-platform tokens ready to use.";
135 
136           
137           return "All in-platform tokens backed.";
138       } else if (msg.sender != admin) {
139           return "Not Authorized";
140       } else {
141           return "Setup cannot be changed.";
142       }
143     }
144 
145     function transferTokens(address _tokenAddress, address _recipient) public onlyOwner returns (bool) { 
146        ERC20I e = ERC20I(_tokenAddress);
147        require(e.transfer(_recipient, e.balanceOf(this)));
148        return true;
149    }
150 
151     // default payable function when sending ether to this contract
152     // only owner (PowerLineUp) can send ether to this address.
153     function () public payable {
154       require(msg.sender == admin);
155       Transfer(this, msg.sender, msg.value); 
156     }
157 }