1 pragma solidity ^0.4.13;
2 // -------------------------------------------------
3 // 0.4.13+commit.0fb4cb1a
4 // [Assistive Reality ARX ERC20 client presold packages 25,50,100 ETH]
5 // [https://aronline.io/icoinfo]
6 // [Adapted from Ethereum standard crowdsale contract]
7 // [Contact staff@aronline.io for any queries]
8 // [Join us in changing the world]
9 // [aronline.io]
10 // -------------------------------------------------
11 // ERC Token Standard #20 Interface
12 // https://github.com/ethereum/EIPs/issues/20
13 // -------------------------------------------------
14 // Security reviews completed 26/09/17 [passed OK]
15 // Functional reviews completed 26/09/17 [passed OK]
16 // Final code revision and regression test cycle complete 26/09/17 [passed]
17 // https://github.com/assistivereality/ico/blob/master/3.2packagesaletestsARXmainnet.txt
18 // -------------------------------------------------
19 // 3 packages offered in this contract:
20 // 25 ETH  = 8500 ARX per 1 ETH
21 // 50 ETH  = 10500 ARX per 1 ETH
22 // 100 ETH = 12500 ARX per 1 ETH
23 // -------------------------------------------------
24 
25 contract owned {
26     address public owner;
27 
28     function owned() {
29         owner = msg.sender;
30     }
31     modifier onlyOwner {
32         require(msg.sender == owner);
33         _;
34     }
35     function transferOwnership(address newOwner) onlyOwner {
36         owner = newOwner;
37     }
38 }
39 
40 contract safeMath {
41   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
42     uint256 c = a * b;
43     safeAssert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
48     safeAssert(b > 0);
49     uint256 c = a / b;
50     safeAssert(a == b * c + a % b);
51     return c;
52   }
53 
54   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
55     safeAssert(b <= a);
56     return a - b;
57   }
58 
59   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
60     uint256 c = a + b;
61     safeAssert(c>=a && c>=b);
62     return c;
63   }
64 
65   function safeAssert(bool assertion) internal {
66     if (!assertion) revert();
67   }
68 }
69 
70 contract ERC20Interface is owned, safeMath {
71   function balanceOf(address _owner) constant returns (uint256 balance);
72   function transfer(address _to, uint256 _value) returns (bool success);
73   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
74   function approve(address _spender, uint256 _value) returns (bool success);
75   function increaseApproval (address _spender, uint _addedValue) returns (bool success);
76   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
77   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
78   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
79   event Transfer(address indexed _from, address indexed _to, uint256 _value);
80   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }
82 
83 contract ARXPackageSale is owned, safeMath {
84   // owner/admin & token reward
85   address        public admin                       = owner;      // admin address
86   ERC20Interface public tokenReward;                              // address of the token used as reward
87 
88   // deployment variables for static supply sale
89   uint256 public initialARXSupplyInWei;                           // initial ARX to be sent to this packagesale contract (requires 6.25M ARX, sending 6.5M ARX)
90   uint256 public CurrentARXSupplyInWei;                           // tracking to see how many to return
91   uint256 public EthCapInWei;                                     // maximum amount to raise in Eth
92   uint256 public tokensPerEthPrice;                               // floating price based on package size purchased
93 
94   // multi-sig addresses and price variable
95   address public beneficiaryMultisig;                             // beneficiaryMultiSig (founder group) live is 0x00F959866E977698D14a36eB332686304a4d6AbA
96   address public foundationMultisig;                              // foundationMultiSig (Assistive Reality foundation) live is
97 
98   // uint256 values for min,max,caps,tracking
99   uint256 public amountRaisedInWei;                               // amount raised in Wei
100 
101   // loop control, ICO startup and limiters
102   string  public CurrentStatus                     = "";          // current packagesale status
103   uint256 public fundingStartBlock;                               // packagesale start block#
104   uint256 public fundingEndBlock;                                 // packagesale end block#
105 
106   bool    public ispackagesaleSetup                = false;       // boolean for packagesale setup
107   bool    public ispackagesaleClosed               = false;       // packagesale completion boolean
108 
109   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
110   event Transfer(address indexed _from, address indexed _to, uint256 _value);
111   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
112   mapping (address => uint256) balances;
113   mapping (address => mapping (address => uint256)) allowed;
114 
115   // default function, map admin
116   function ARXPackageSale() onlyOwner {
117     admin = msg.sender;
118     CurrentStatus = "packagesale deployed to chain";
119   }
120 
121   // total number of tokens initially simplified from wei
122   function initialARXtokenSupply() constant returns (uint256 initialARXtokenSupplyCount) {
123       initialARXtokenSupplyCount = safeDiv(initialARXSupplyInWei,1 ether);
124   }
125 
126   // current number of tokens simplified from wei
127   function currentARXtokenSupply() constant returns (uint256 currentARXtokenSupplyCount) {
128       currentARXtokenSupplyCount = safeDiv(CurrentARXSupplyInWei,1 ether);
129   }
130 
131   // setup the packagesale parameters
132   function Setuppackagesale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
133       if ((msg.sender == admin)
134       && (!(ispackagesaleSetup))
135       && (!(beneficiaryMultisig > 0))){
136           // init addresses
137           tokenReward                             = ERC20Interface(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);   // mainnet is 0x7D5Edcd23dAa3fB94317D32aE253eE1Af08Ba14d //testnet = 0x75508c2B1e46ea29B7cCf0308d4Cb6f6af6211e0
138           beneficiaryMultisig                     = 0x5Ed4706A93b8a3239f97F7d2025cE1f9eaDcD9A4;                   // mainnet ARX foundation cold storage wallet
139           foundationMultisig                      = 0x5Ed4706A93b8a3239f97F7d2025cE1f9eaDcD9A4;                   // mainnet ARX foundation cold storage wallet
140           tokensPerEthPrice                       = 8500;                                                         // 8500 ARX per Eth default flat (this is altered in BuyTokens function based on amount sent for package deals)
141 
142           // funding targets
143           initialARXSupplyInWei                   = 6500000000000000000000000;                                    //   6,500,000 + 18 decimals = 6500000000000000000000000 //testnet 650k tokens = 65000000000000000000000
144           CurrentARXSupplyInWei                   = initialARXSupplyInWei;
145           EthCapInWei                             = 500000000000000000000;                                        //   500000000000000000000 =  500 Eth (max cap) - packages won't sell beyond this amount //testnet 5Eth 5000000000000000000
146           amountRaisedInWei                       = 0;
147 
148           // update values
149           fundingStartBlock                       = _fundingStartBlock;
150           fundingEndBlock                         = _fundingEndBlock;
151 
152           // configure packagesale
153           ispackagesaleSetup                      = true;
154           ispackagesaleClosed                     = false;
155           CurrentStatus                           = "packagesale is activated";
156 
157           return "packagesale is setup";
158       } else if (msg.sender != admin) {
159           return "not authorized";
160       } else  {
161           return "campaign cannot be changed";
162       }
163     }
164 
165     // default payable function when sending ether to this contract
166     function () payable {
167       require(msg.data.length == 0);
168       BuyARXtokens();
169     }
170 
171     function BuyARXtokens() payable {
172       // 0. conditions (length, packagesale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
173       require(!(msg.value == 0)
174       && (ispackagesaleSetup)
175       && (block.number >= fundingStartBlock)
176       && (block.number <= fundingEndBlock)
177       && (amountRaisedInWei < EthCapInWei));
178 
179       // 1. vars
180       uint256 rewardTransferAmount    = 0;
181 
182       // 2. effects
183       if (msg.value==25000000000000000000) { // 25 ETH (18 decimals) = 8500 ARX per 1 ETH
184         tokensPerEthPrice=8500;
185       } else if (msg.value==50000000000000000000) { // 50 ETH (18 decimals) = 10500 ARX per 1 ETH
186         tokensPerEthPrice=10500;
187       } else if (msg.value==100000000000000000000) { // 100 ETH (18 decimals) = 12500 ARX per 1 ETH
188         tokensPerEthPrice=12500;
189       } else {
190         revert();
191       }
192 
193       amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);
194       rewardTransferAmount            = safeMul(msg.value,tokensPerEthPrice);
195       CurrentARXSupplyInWei           = safeSub(CurrentARXSupplyInWei,rewardTransferAmount);
196 
197       // 3. interaction
198       tokenReward.transfer(msg.sender, rewardTransferAmount);
199 
200       // 4. events
201       Transfer(this, msg.sender, msg.value);
202       Buy(msg.sender, msg.value, rewardTransferAmount);
203     }
204 
205     function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
206       beneficiaryMultisig.transfer(_amount);
207     }
208 
209     function updateStatus() onlyOwner {
210       require((block.number >= fundingEndBlock) || (amountRaisedInWei >= EthCapInWei));
211       CurrentStatus = "packagesale is closed";
212     }
213 
214     function withdrawRemainingTokens(uint256 _amountToPull) onlyOwner {
215       require(block.number >= fundingEndBlock);
216       tokenReward.transfer(msg.sender, _amountToPull);
217     }
218 }