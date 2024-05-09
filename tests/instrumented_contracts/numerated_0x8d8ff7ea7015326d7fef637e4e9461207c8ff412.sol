1 pragma solidity ^0.4.11;
2 
3 pragma solidity ^0.4.11;
4 
5 library Math {
6   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
7     return a >= b ? a : b;
8   }
9 
10   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
11     return a < b ? a : b;
12   }
13 
14   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
15     return a >= b ? a : b;
16   }
17 
18   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
19     return a < b ? a : b;
20   }
21 }
22 
23 contract ERC20Basic {
24   uint256 public totalSupply;
25   function balanceOf(address who) constant returns (uint256);
26   function transfer(address to, uint256 value) returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner {
57     if (newOwner != address(0)) {
58       owner = newOwner;
59     }
60   }
61 
62 }
63 
64 contract ICOBuyer is Ownable {
65 
66   // Contract allows Ether to be paid into it
67   // Contract allows tokens / Ether to be extracted only to owner account
68 
69   //Notify on economic events
70   event EtherReceived(address indexed _contributor, uint256 _amount);
71   event EtherWithdrawn(uint256 _amount);
72   event TokensWithdrawn(uint256 _balance);
73   event ICOPurchased(uint256 _amount);
74 
75   //Notify on contract updates
76   event ICOStartBlockChanged(uint256 _icoStartBlock);
77   event ICOStartTimeChanged(uint256 _icoStartTime);
78   event ExecutorChanged(address _executor);
79   event CrowdSaleChanged(address _crowdSale);
80   event TokenChanged(address _token);
81   event PurchaseCapChanged(uint256 _purchaseCap);
82   event MinimumContributionChanged(uint256 _minimumContribution);
83 
84   // only owner can change these
85   // Earliest block number contract is allowed to buy into the crowdsale.
86   uint256 public icoStartBlock;
87   // Earliest time contract is allowed to buy into the crowdsale.
88   uint256 public icoStartTime;
89   // The crowdsale address.
90   address public crowdSale;
91   // The address that can trigger ICO purchase (may be different to owner)
92   address public executor;
93   // The amount for each ICO purchase
94   uint256 public purchaseCap;
95   // Minimum contribution amount
96   uint256 public minimumContribution = 0.1 ether;
97 
98   modifier onlyExecutorOrOwner() {
99     require((msg.sender == executor) || (msg.sender == owner));
100     _;
101   }
102 
103   function ICOBuyer(address _executor, address _crowdSale, uint256 _icoStartBlock, uint256 _icoStartTime, uint256 _purchaseCap) {
104     executor = _executor;
105     crowdSale = _crowdSale;
106     icoStartBlock = _icoStartBlock;
107     icoStartTime = _icoStartTime;
108     purchaseCap = _purchaseCap;
109   }
110 
111   function changeCrowdSale(address _crowdSale) onlyExecutorOrOwner {
112     crowdSale = _crowdSale;
113     CrowdSaleChanged(crowdSale);
114   }
115 
116   function changeICOStartBlock(uint256 _icoStartBlock) onlyExecutorOrOwner {
117     icoStartBlock = _icoStartBlock;
118     ICOStartBlockChanged(icoStartBlock);
119   }
120 
121   function changeMinimumContribution(uint256 _minimumContribution) onlyExecutorOrOwner {
122     minimumContribution = _minimumContribution;
123     MinimumContributionChanged(minimumContribution);
124   }
125 
126   function changeICOStartTime(uint256 _icoStartTime) onlyExecutorOrOwner {
127     icoStartTime = _icoStartTime;
128     ICOStartTimeChanged(icoStartTime);
129   }
130 
131   function changePurchaseCap(uint256 _purchaseCap) onlyExecutorOrOwner {
132     purchaseCap = _purchaseCap;
133     PurchaseCapChanged(purchaseCap);
134   }
135 
136   function changeExecutor(address _executor) onlyOwner {
137     executor = _executor;
138     ExecutorChanged(_executor);
139   }
140 
141   // function allows all Ether to be drained from contract by owner
142   function withdrawEther() onlyOwner {
143     require(this.balance != 0);
144     owner.transfer(this.balance);
145     EtherWithdrawn(this.balance);
146   }
147 
148   // function allows all tokens to be transferred to owner
149   function withdrawTokens(address _token) onlyOwner {
150     ERC20Basic token = ERC20Basic(_token);
151     // Retrieve current token balance of contract.
152     uint256 contractTokenBalance = token.balanceOf(address(this));
153     // Disallow token withdrawals if there are no tokens to withdraw.
154     require(contractTokenBalance != 0);
155     // Send the funds.  Throws on failure to prevent loss of funds.
156     assert(token.transfer(owner, contractTokenBalance));
157     TokensWithdrawn(contractTokenBalance);
158   }
159 
160   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
161   function buyICO() {
162     // Short circuit to save gas if the earliest block number hasn't been reached.
163     if ((icoStartBlock != 0) && (getBlockNumber() < icoStartBlock)) return;
164     // Short circuit to save gas if the earliest buy time hasn't been reached.
165     if ((icoStartTime != 0) && (getNow() < icoStartTime)) return;
166     // Return if no balance
167     if (this.balance < minimumContribution) return;
168 
169     // Purchase tokens from ICO contract (assuming call to ICO fallback function)
170     uint256 purchaseAmount = Math.min256(this.balance, purchaseCap);
171     assert(crowdSale.call.value(purchaseAmount)());
172     ICOPurchased(purchaseAmount);
173   }
174 
175   // Fallback function accepts ether and logs this.
176   // Can be called by anyone to fund contract.
177   function () payable {
178     EtherReceived(msg.sender, msg.value);
179   }
180 
181   //Function is mocked for tests
182   function getBlockNumber() internal constant returns (uint256) {
183     return block.number;
184   }
185 
186   //Function is mocked for tests
187   function getNow() internal constant returns (uint256) {
188     return now;
189   }
190 
191 }