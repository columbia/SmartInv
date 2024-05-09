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
68   // Contract allows executor address or owner address to trigger ICO purtchase
69 
70   //Notify on economic events
71   event EtherReceived(address indexed _contributor, uint256 _amount);
72   event EtherWithdrawn(uint256 _amount);
73   event TokensWithdrawn(uint256 _balance);
74   event ICOPurchased(uint256 _amount);
75 
76   //Notify on contract updates
77   event ICOStartBlockChanged(uint256 _icoStartBlock);
78   event ICOStartTimeChanged(uint256 _icoStartTime);
79   event ExecutorChanged(address _executor);
80   event CrowdSaleChanged(address _crowdSale);
81   event TokenChanged(address _token);
82   event PurchaseCapChanged(uint256 _purchaseCap);
83   event MinimumContributionChanged(uint256 _minimumContribution);
84 
85   // only owner can change these
86   // Earliest block number contract is allowed to buy into the crowdsale.
87   uint256 public icoStartBlock;
88   // Earliest time contract is allowed to buy into the crowdsale.
89   uint256 public icoStartTime;
90   // The crowdsale address.
91   address public crowdSale;
92   // The address that can trigger ICO purchase (may be different to owner)
93   address public executor;
94   // The amount for each ICO purchase
95   uint256 public purchaseCap;
96   // Minimum contribution amount
97   uint256 public minimumContribution = 0.1 ether;
98 
99   modifier onlyExecutorOrOwner() {
100     require((msg.sender == executor) || (msg.sender == owner));
101     _;
102   }
103 
104   function ICOBuyer(address _executor, address _crowdSale, uint256 _icoStartBlock, uint256 _icoStartTime, uint256 _purchaseCap) {
105     executor = _executor;
106     crowdSale = _crowdSale;
107     icoStartBlock = _icoStartBlock;
108     icoStartTime = _icoStartTime;
109     purchaseCap = _purchaseCap;
110   }
111 
112   function changeCrowdSale(address _crowdSale) onlyOwner {
113     crowdSale = _crowdSale;
114     CrowdSaleChanged(crowdSale);
115   }
116 
117   function changeICOStartBlock(uint256 _icoStartBlock) onlyExecutorOrOwner {
118     icoStartBlock = _icoStartBlock;
119     ICOStartBlockChanged(icoStartBlock);
120   }
121 
122   function changeMinimumContribution(uint256 _minimumContribution) onlyExecutorOrOwner {
123     minimumContribution = _minimumContribution;
124     MinimumContributionChanged(minimumContribution);
125   }
126 
127   function changeICOStartTime(uint256 _icoStartTime) onlyExecutorOrOwner {
128     icoStartTime = _icoStartTime;
129     ICOStartTimeChanged(icoStartTime);
130   }
131 
132   function changePurchaseCap(uint256 _purchaseCap) onlyOwner {
133     purchaseCap = _purchaseCap;
134     PurchaseCapChanged(purchaseCap);
135   }
136 
137   function changeExecutor(address _executor) onlyOwner {
138     executor = _executor;
139     ExecutorChanged(_executor);
140   }
141 
142   // function allows all Ether to be drained from contract by owner
143   function withdrawEther() onlyOwner {
144     require(this.balance != 0);
145     owner.transfer(this.balance);
146     EtherWithdrawn(this.balance);
147   }
148 
149   // function allows all tokens to be transferred to owner
150   function withdrawTokens(address _token) onlyOwner {
151     ERC20Basic token = ERC20Basic(_token);
152     // Retrieve current token balance of contract.
153     uint256 contractTokenBalance = token.balanceOf(address(this));
154     // Disallow token withdrawals if there are no tokens to withdraw.
155     require(contractTokenBalance != 0);
156     // Send the funds.  Throws on failure to prevent loss of funds.
157     assert(token.transfer(owner, contractTokenBalance));
158     TokensWithdrawn(contractTokenBalance);
159   }
160 
161   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
162   function buyICO() {
163     // Short circuit to save gas if the earliest block number hasn't been reached.
164     if ((icoStartBlock != 0) && (getBlockNumber() < icoStartBlock)) return;
165     // Short circuit to save gas if the earliest buy time hasn't been reached.
166     if ((icoStartTime != 0) && (getNow() < icoStartTime)) return;
167     // Return if no balance
168     if (this.balance < minimumContribution) return;
169 
170     // Purchase tokens from ICO contract (assuming call to ICO fallback function)
171     uint256 purchaseAmount = Math.min256(this.balance, purchaseCap);
172     assert(crowdSale.call.value(purchaseAmount)());
173     ICOPurchased(purchaseAmount);
174   }
175 
176   // Fallback function accepts ether and logs this.
177   // Can be called by anyone to fund contract.
178   function () payable {
179     EtherReceived(msg.sender, msg.value);
180   }
181 
182   //Function is mocked for tests
183   function getBlockNumber() internal constant returns (uint256) {
184     return block.number;
185   }
186 
187   //Function is mocked for tests
188   function getNow() internal constant returns (uint256) {
189     return now;
190   }
191 
192 }