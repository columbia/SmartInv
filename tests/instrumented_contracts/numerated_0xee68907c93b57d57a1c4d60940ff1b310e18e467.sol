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
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner {
60     if (newOwner != address(0)) {
61       owner = newOwner;
62     }
63   }
64 
65 }
66 
67 contract ICOBuyer is Ownable {
68 
69   // Contract allows Ether to be paid into it
70   // Contract allows tokens / Ether to be extracted only to owner account
71   // Contract allows executor address or owner address to trigger ICO purtchase
72 
73   //Notify on economic events
74   event EtherReceived(address indexed _contributor, uint256 _amount);
75   event EtherWithdrawn(uint256 _amount);
76   event TokensWithdrawn(uint256 _balance);
77   event ICOPurchased(uint256 _amount);
78 
79   //Notify on contract updates
80   event ICOStartBlockChanged(uint256 _icoStartBlock);
81   event ExecutorChanged(address _executor);
82   event CrowdSaleChanged(address _crowdSale);
83   event TokenChanged(address _token);
84   event PurchaseCapChanged(uint256 _purchaseCap);
85 
86   // only owner can change these
87   // Earliest time contract is allowed to buy into the crowdsale.
88   uint256 public icoStartBlock;
89   // The crowdsale address.
90   address public crowdSale;
91   // The address that can trigger ICO purchase (may be different to owner)
92   address public executor;
93   // The amount for each ICO purchase
94   uint256 public purchaseCap;
95 
96   modifier onlyExecutorOrOwner() {
97     require((msg.sender == executor) || (msg.sender == owner));
98     _;
99   }
100 
101   function ICOBuyer(address _executor, address _crowdSale, uint256 _icoStartBlock, uint256 _purchaseCap) {
102     executor = _executor;
103     crowdSale = _crowdSale;
104     icoStartBlock = _icoStartBlock;
105     purchaseCap = _purchaseCap;
106   }
107 
108   function changeCrowdSale(address _crowdSale) onlyOwner {
109     crowdSale = _crowdSale;
110     CrowdSaleChanged(crowdSale);
111   }
112 
113   function changeICOStartBlock(uint256 _icoStartBlock) onlyOwner {
114     icoStartBlock = _icoStartBlock;
115     ICOStartBlockChanged(icoStartBlock);
116   }
117 
118   function changePurchaseCap(uint256 _purchaseCap) onlyOwner {
119     purchaseCap = _purchaseCap;
120     PurchaseCapChanged(purchaseCap);
121   }
122 
123   function changeExecutor(address _executor) onlyOwner {
124     executor = _executor;
125     ExecutorChanged(_executor);
126   }
127 
128   // function allows all Ether to be drained from contract by owner
129   function withdrawEther() onlyOwner {
130     require(this.balance != 0);
131     owner.transfer(this.balance);
132     EtherWithdrawn(this.balance);
133   }
134 
135   // function allows all tokens to be transferred to owner
136   function withdrawTokens(address _token) onlyOwner {
137     ERC20Basic token = ERC20Basic(_token);
138     // Retrieve current token balance of contract.
139     uint256 contractTokenBalance = token.balanceOf(address(this));
140     // Disallow token withdrawals if there are no tokens to withdraw.
141     require(contractTokenBalance != 0);
142     // Send the funds.  Throws on failure to prevent loss of funds.
143     assert(token.transfer(owner, contractTokenBalance));
144     TokensWithdrawn(contractTokenBalance);
145   }
146 
147   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
148   function buyICO() onlyExecutorOrOwner {
149     // Short circuit to save gas if the earliest buy time hasn't been reached.
150     if (getBlockNumber() < icoStartBlock) return;
151     // Return if no balance
152     if (this.balance == 0) return;
153 
154     // Purchase tokens from ICO contract (assuming call to ICO fallback function)
155     uint256 purchaseAmount = Math.min256(this.balance, purchaseCap);
156     assert(crowdSale.call.value(purchaseAmount)());
157     ICOPurchased(purchaseAmount);
158   }
159 
160   // Fallback function accepts ether and logs this.
161   // Can be called by anyone to fund contract.
162   function () payable {
163     EtherReceived(msg.sender, msg.value);
164   }
165 
166   //Function is mocked for tests
167   function getBlockNumber() internal constant returns (uint256) {
168     return block.number;
169   }
170 
171 }