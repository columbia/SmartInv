1 pragma solidity ^0.4.11;
2 
3 library Math {
4   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
5     return a >= b ? a : b;
6   }
7 
8   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
9     return a < b ? a : b;
10   }
11 
12   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
13     return a >= b ? a : b;
14   }
15 
16   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
17     return a < b ? a : b;
18   }
19 }
20 
21 contract ERC20Basic {
22   uint256 public totalSupply;
23   function balanceOf(address who) constant returns (uint256);
24   function transfer(address to, uint256 value) returns (bool);
25   event Transfer(address indexed from, address indexed to, uint256 value);
26 }
27 
28 contract Ownable {
29   address public owner;
30 
31 
32   /**
33    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34    * account.
35    */
36   function Ownable() {
37     owner = msg.sender;
38   }
39 
40 
41   /**
42    * @dev Throws if called by any account other than the owner.
43    */
44   modifier onlyOwner() {
45     require(msg.sender == owner);
46     _;
47   }
48 
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) onlyOwner {
55     if (newOwner != address(0)) {
56       owner = newOwner;
57     }
58   }
59 
60 }
61 
62 contract ICOBuyer is Ownable {
63 
64   // Contract allows Ether to be paid into it
65   // Contract allows tokens / Ether to be extracted only to owner account
66   // Contract allows executor address or owner address to trigger ICO purtchase
67 
68   //Notify on economic events
69   event EtherReceived(address indexed _contributor, uint256 _amount);
70   event EtherWithdrawn(uint256 _amount);
71   event TokensWithdrawn(uint256 _balance);
72   event ICOPurchased(uint256 _amount);
73 
74   //Notify on contract updates
75   event ICOStartBlockChanged(uint256 _icoStartBlock);
76   event ICOStartTimeChanged(uint256 _icoStartTime);
77   event ExecutorChanged(address _executor);
78   event CrowdSaleChanged(address _crowdSale);
79   event TokenChanged(address _token);
80   event PurchaseCapChanged(uint256 _purchaseCap);
81 
82   // only owner can change these
83   // Earliest block number contract is allowed to buy into the crowdsale.
84   uint256 public icoStartBlock;
85   // Earliest time contract is allowed to buy into the crowdsale.
86   uint256 public icoStartTime;
87   // The crowdsale address.
88   address public crowdSale;
89   // The address that can trigger ICO purchase (may be different to owner)
90   address public executor;
91   // The amount for each ICO purchase
92   uint256 public purchaseCap;
93 
94   modifier onlyExecutorOrOwner() {
95     require((msg.sender == executor) || (msg.sender == owner));
96     _;
97   }
98 
99   function ICOBuyer(address _executor, address _crowdSale, uint256 _icoStartBlock, uint256 _icoStartTime, uint256 _purchaseCap) {
100     executor = _executor;
101     crowdSale = _crowdSale;
102     icoStartBlock = _icoStartBlock;
103     icoStartTime = _icoStartTime;
104     purchaseCap = _purchaseCap;
105   }
106 
107   function changeCrowdSale(address _crowdSale) onlyOwner {
108     crowdSale = _crowdSale;
109     CrowdSaleChanged(crowdSale);
110   }
111 
112   function changeICOStartBlock(uint256 _icoStartBlock) onlyExecutorOrOwner {
113     icoStartBlock = _icoStartBlock;
114     ICOStartBlockChanged(icoStartBlock);
115   }
116 
117   function changeICOStartTime(uint256 _icoStartTime) onlyExecutorOrOwner {
118     icoStartTime = _icoStartTime;
119     ICOStartTimeChanged(icoStartTime);
120   }
121 
122   function changePurchaseCap(uint256 _purchaseCap) onlyOwner {
123     purchaseCap = _purchaseCap;
124     PurchaseCapChanged(purchaseCap);
125   }
126 
127   function changeExecutor(address _executor) onlyOwner {
128     executor = _executor;
129     ExecutorChanged(_executor);
130   }
131 
132   // function allows all Ether to be drained from contract by owner
133   function withdrawEther() onlyOwner {
134     require(this.balance != 0);
135     owner.transfer(this.balance);
136     EtherWithdrawn(this.balance);
137   }
138 
139   // function allows all tokens to be transferred to owner
140   function withdrawTokens(address _token) onlyOwner {
141     ERC20Basic token = ERC20Basic(_token);
142     // Retrieve current token balance of contract.
143     uint256 contractTokenBalance = token.balanceOf(address(this));
144     // Disallow token withdrawals if there are no tokens to withdraw.
145     require(contractTokenBalance != 0);
146     // Send the funds.  Throws on failure to prevent loss of funds.
147     assert(token.transfer(owner, contractTokenBalance));
148     TokensWithdrawn(contractTokenBalance);
149   }
150 
151   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
152   function buyICO() onlyExecutorOrOwner {
153     // Short circuit to save gas if the earliest block number hasn't been reached.
154     if ((icoStartBlock != 0) && (getBlockNumber() < icoStartBlock)) return;
155     // Short circuit to save gas if the earliest buy time hasn't been reached.
156     if ((icoStartTime != 0) && (getNow() < icoStartTime)) return;
157     // Return if no balance
158     if (this.balance == 0) return;
159 
160     // Purchase tokens from ICO contract (assuming call to ICO fallback function)
161     uint256 purchaseAmount = Math.min256(this.balance, purchaseCap);
162     assert(crowdSale.call.value(purchaseAmount)());
163     ICOPurchased(purchaseAmount);
164   }
165 
166   // Fallback function accepts ether and logs this.
167   // Can be called by anyone to fund contract.
168   function () payable {
169     EtherReceived(msg.sender, msg.value);
170   }
171 
172   //Function is mocked for tests
173   function getBlockNumber() internal constant returns (uint256) {
174     return block.number;
175   }
176 
177   //Function is mocked for tests
178   function getNow() internal constant returns (uint256) {
179     return now;
180   }
181 
182 }