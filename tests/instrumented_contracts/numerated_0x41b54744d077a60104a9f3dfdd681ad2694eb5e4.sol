1 pragma solidity ^0.4.18;
2 
3 // Interface for contracts with buying functionality, for example, crowdsales.
4 contract Buyable {
5   function buy (address receiver) public payable;
6 }
7 
8  /// @title SafeMath contract - math operations with safety checks
9 contract SafeMath {
10   function safeMul(uint a, uint b) internal pure  returns (uint) {
11     uint c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function safeDiv(uint a, uint b) internal pure returns (uint) {
17     assert(b > 0);
18     uint c = a / b;
19     assert(a == b * c + a % b);
20     return c;
21   }
22 
23   function safeSub(uint a, uint b) internal pure returns (uint) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function safeAdd(uint a, uint b) internal pure returns (uint) {
29     uint c = a + b;
30     assert(c>=a && c>=b);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a < b ? a : b;
48   }
49 }
50 
51 
52  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
53 contract ERC20 {
54   uint public totalSupply;
55   function balanceOf(address who) public constant returns (uint);
56   function allowance(address owner, address spender) public constant returns (uint);  
57   function transfer(address to, uint value) public returns (bool ok);
58   function transferFrom(address from, address to, uint value) public returns (bool ok);
59   function approve(address spender, uint value) public returns (bool ok);
60   function decimals() public constant returns (uint value);
61   event Transfer(address indexed from, address indexed to, uint value);
62   event Approval(address indexed owner, address indexed spender, uint value);
63 }
64  /// @title Ownable contract - base contract with an owner
65 contract Ownable {
66   address public owner;
67 
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   function transferOwnership(address newOwner) public onlyOwner {
78     if (newOwner != address(0)) {
79       owner = newOwner;
80     }
81   }
82 }
83 
84  /// @title TokenAdr token sale contract
85 contract TokenAdrTokenSale is Ownable, SafeMath, Buyable {
86 
87    /// State machine
88    /// Preparing: Waiting for ICO start
89    /// Selling: Active sale
90    /// ProlongedSelling: Prolonged active sale
91    /// TokenShortage: ICO period isn't over yet, but there are no tokens on the contract
92    /// Finished: ICO has finished
93   enum Status {Unknown, Preparing, Selling, ProlongedSelling, TokenShortage, Finished}
94 
95   /// A new investment was made
96   event Invested(address investor, uint weiAmount, uint tokenAmount);
97 
98   /// Contract owner withdrew some tokens to team wallet
99   event Withdraw(uint tokenAmount);
100 
101   /// Token unit price changed
102   event TokenPriceChanged(uint newTokenPrice);
103 
104   /// SNTR token address
105   ERC20 public token;
106 
107   /// wallet address to transfer invested ETH
108   address public ethMultisigWallet;
109 
110   /// wallet address to withdraw unused tokens
111   address public tokenMultisigWallet;
112 
113   /// ICO start time
114   uint public startTime;
115 
116   /// ICO duration in seconds
117   uint public duration;
118 
119   /// Prolonged ICO duration in seconds, 0 if no prolongation is planned
120   uint public prolongedDuration;
121 
122   /// Token price in wei
123   uint public tokenPrice;
124 
125   /// Minimal investment amount in wei
126   uint public minInvestment;
127 
128   /// List of addresses allowed to send ETH to this contract, empty if anyone is allowed
129   address[] public allowedSenders;
130 
131   /// The number of tokens already sold through this contract
132   uint public tokensSoldAmount = 0;
133 
134   ///  How many wei of funding we have raised
135   uint public weiRaisedAmount = 0;
136 
137   ///  How many distinct addresses have invested
138   uint public investorCount = 0;
139 
140   ///  Was prolongation permitted by owner or not
141   bool public prolongationPermitted;
142 
143   ///  How much ETH each address has invested to this crowdsale
144   mapping (address => uint256) public investedAmountOf;
145 
146   ///  How much tokens this crowdsale has credited for each investor address
147   mapping (address => uint256) public tokenAmountOf;
148 
149   /// Multiplier for token value
150   uint public tokenValueMultiplier;
151 
152   /// Stop trigger in excess
153   bool public stopped;
154 
155   /// @dev Constructor
156   /// @param _token token address
157   /// @param _ethMultisigWallet wallet address to transfer invested ETH
158   /// @param _tokenMultisigWallet wallet address to withdraw unused tokens
159   /// @param _startTime ICO start time
160   /// @param _duration ICO duration in seconds
161   /// @param _prolongedDuration Prolonged ICO duration in seconds, 0 if no prolongation is planned
162   /// @param _tokenPrice Token price in wei
163   /// @param _minInvestment Minimal investment amount in wei
164   /// @param _allowedSenders List of addresses allowed to send ETH to this contract, empty if anyone is allowed
165   function TokenAdrTokenSale(address _token, address _ethMultisigWallet, address _tokenMultisigWallet,
166             uint _startTime, uint _duration, uint _prolongedDuration, uint _tokenPrice, uint _minInvestment, address[] _allowedSenders) public {
167     require(_token != 0);
168     require(_ethMultisigWallet != 0);
169     require(_tokenMultisigWallet != 0);
170     require(_duration > 0);
171     require(_tokenPrice > 0);
172     require(_minInvestment > 0);
173 
174     token = ERC20(_token);
175     ethMultisigWallet = _ethMultisigWallet;
176     tokenMultisigWallet = _tokenMultisigWallet;
177     startTime = _startTime;
178     duration = _duration;
179     prolongedDuration = _prolongedDuration;
180     tokenPrice = _tokenPrice;
181     minInvestment = _minInvestment;
182     allowedSenders = _allowedSenders;
183     tokenValueMultiplier = 10 ** token.decimals();
184   }
185 
186   /// @dev Sell tokens to specified address
187   /// @param receiver receiver of bought tokens
188   function buy (address receiver) public payable {
189     require(!stopped);
190     require(getCurrentStatus() == Status.Selling || getCurrentStatus() == Status.ProlongedSelling);
191     require(msg.value >= minInvestment);
192 
193     // Check if current sender is allowed to participate in this crowdsale
194     var senderAllowed = false;
195     if (allowedSenders.length > 0) {
196       for (uint i = 0; i < allowedSenders.length; i++)
197         if (allowedSenders[i] == receiver) {
198           senderAllowed = true;
199           break;
200         }
201     }
202     else
203       senderAllowed = true;
204 
205     assert(senderAllowed);
206 
207     uint weiAmount = msg.value;
208     uint tokenAmount = safeDiv(safeMul(weiAmount, tokenValueMultiplier), tokenPrice);
209     assert(tokenAmount > 0);
210 
211     uint changeWei = 0;
212     var currentContractTokens = token.balanceOf(address(this));
213     if (currentContractTokens < tokenAmount) {
214       var changeTokenAmount = safeSub(tokenAmount, currentContractTokens);
215       changeWei = safeDiv(safeMul(changeTokenAmount, tokenPrice), tokenValueMultiplier);
216       tokenAmount = currentContractTokens;
217       weiAmount = safeSub(weiAmount, changeWei);
218     }
219 
220     if(investedAmountOf[receiver] == 0) {
221        // A new investor
222        investorCount++;
223     }
224     // Update investor-amount mappings
225     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
226     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
227     // Update totals
228     weiRaisedAmount = safeAdd(weiRaisedAmount, weiAmount);
229     tokensSoldAmount = safeAdd(tokensSoldAmount, tokenAmount);
230 
231     // Transfer the invested ETH to the multisig wallet;
232     ethMultisigWallet.transfer(weiAmount);
233 
234     // Transfer the bought tokens to the ETH sender
235     var transferSuccess = token.transfer(receiver, tokenAmount);
236     assert(transferSuccess);
237 
238     // Return change if any
239     if (changeWei > 0) {
240       receiver.transfer(changeWei);
241     }
242 
243     // Tell us the investment succeeded
244     Invested(receiver, weiAmount, tokenAmount);
245   }
246 
247   /// @dev Sell tokens to ETH sender
248   function() public payable {
249     buy(msg.sender);
250   }
251 
252    /// @dev Token sale state machine management.
253    /// @return Status current status
254   function getCurrentStatus() public constant returns (Status) {
255     if (startTime > now)
256       return Status.Preparing;
257     if (now > startTime + duration + prolongedDuration)
258       return Status.Finished;
259     if (now > startTime + duration && !prolongationPermitted)
260       return Status.Finished;
261     if (token.balanceOf(address(this)) <= 0)
262       return Status.TokenShortage;
263     if (now > startTime + duration)
264       return Status.ProlongedSelling;
265     if (now >= startTime)
266         return Status.Selling;
267     return Status.Unknown;
268   }
269 
270   /// @dev Withdraw remaining tokens to the team wallet
271   /// @param value Amount of tokens to withdraw
272   function withdrawTokens(uint value) public onlyOwner {
273     require(value <= token.balanceOf(address(this)));
274     // Return the specified amount of tokens to team wallet
275     token.transfer(tokenMultisigWallet, value);
276     Withdraw(value);
277   }
278 
279   /// @dev Change current token price
280   /// @param newTokenPrice New token unit price in wei
281   function changeTokenPrice(uint newTokenPrice) public onlyOwner {
282     require(newTokenPrice > 0);
283 
284     tokenPrice = newTokenPrice;
285     TokenPriceChanged(newTokenPrice);
286   }
287 
288   /// @dev Prolong ICO if owner decides to do it
289   function prolong() public onlyOwner {
290     require(!prolongationPermitted && prolongedDuration > 0);
291     prolongationPermitted = true;
292   }
293 
294   /// @dev Called by the owner on excess, triggers stopped state
295   function stopSale() public onlyOwner {
296     stopped = true;
297   }
298 
299   /// @dev Called by the owner on end of excess, returns to normal state
300   function resumeSale() public onlyOwner {
301     require(stopped);
302     stopped = false;
303   }
304 
305   /// @dev Called by the owner to destroy contract
306   function kill() public onlyOwner {
307     selfdestruct(owner);
308   }
309 }