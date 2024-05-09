1 pragma solidity ^0.4.18;
2 
3  /// @title SafeMath contract - math operations with safety checks
4 contract SafeMath {
5   function safeMul(uint a, uint b) internal pure  returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint a, uint b) internal pure returns (uint) {
12     assert(b > 0);
13     uint c = a / b;
14     assert(a == b * c + a % b);
15     return c;
16   }
17 
18   function safeSub(uint a, uint b) internal pure returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function safeAdd(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     assert(c>=a && c>=b);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
42     return a < b ? a : b;
43   }
44 }
45 
46  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
47 contract ERC20 {
48   uint public totalSupply;
49   function balanceOf(address who) public constant returns (uint);
50   function allowance(address owner, address spender) public constant returns (uint);  
51   function transfer(address to, uint value) public returns (bool ok);
52   function transferFrom(address from, address to, uint value) public returns (bool ok);
53   function approve(address spender, uint value) public returns (bool ok);
54   function decimals() public constant returns (uint value);
55   event Transfer(address indexed from, address indexed to, uint value);
56   event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59  /// @title Ownable contract - base contract with an owner
60 contract Ownable {
61   address public owner;
62 
63   function Ownable() public {
64     owner = msg.sender;
65   }
66 
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   function transferOwnership(address newOwner) public onlyOwner {
73     if (newOwner != address(0)) {
74       owner = newOwner;
75     }
76   }
77 }
78 
79  /// @title SilentNotary token sale contract
80 contract SilentNotaryTokenSale is Ownable, SafeMath {
81 
82    /// State machine
83    /// Preparing: Waiting for ICO start
84    /// Selling: Active sale
85    /// ProlongedSelling: Prolonged active sale
86    /// TokenShortage: ICO period isn't over yet, but there are no tokens on the contract
87    /// Finished: ICO has finished
88   enum Status {Unknown, Preparing, Selling, ProlongedSelling, TokenShortage, Finished}
89 
90   /// A new investment was made
91   event Invested(address investor, uint weiAmount, uint tokenAmount);
92 
93   /// Contract owner withdrew some tokens to team wallet
94   event Withdraw(uint tokenAmount);
95 
96   /// Token unit price changed
97   event TokenPriceChanged(uint newTokenPrice);
98 
99   /// SNTR token address
100   ERC20 public token;
101 
102   /// wallet address to transfer invested ETH
103   address public ethMultisigWallet;
104 
105   /// wallet address to withdraw unused tokens
106   address public tokenMultisigWallet;
107 
108   /// ICO start time
109   uint public startTime;
110 
111   /// ICO duration in seconds
112   uint public duration;
113 
114   /// Prolonged ICO duration in seconds, 0 if no prolongation is planned
115   uint public prolongedDuration;
116 
117   /// Token price in wei
118   uint public tokenPrice;
119 
120   /// Minimal investment amount in wei
121   uint public minInvestment;
122 
123   /// List of addresses allowed to send ETH to this contract, empty if anyone is allowed
124   address[] public allowedSenders;
125 
126   /// The number of tokens already sold through this contract
127   uint public tokensSoldAmount = 0;
128 
129   ///  How many wei of funding we have raised
130   uint public weiRaisedAmount = 0;
131 
132   ///  How many distinct addresses have invested
133   uint public investorCount = 0;
134 
135   ///  Was prolongation permitted by owner or not
136   bool public prolongationPermitted;
137 
138   ///  How much ETH each address has invested to this crowdsale
139   mapping (address => uint256) public investedAmountOf;
140 
141   ///  How much tokens this crowdsale has credited for each investor address
142   mapping (address => uint256) public tokenAmountOf;
143 
144   /// Multiplier for token value
145   uint public tokenValueMultiplier;
146 
147   /// Stop trigger in excess
148   bool public stopped;
149 
150   /// @dev Constructor
151   /// @param _token SNTR token address
152   /// @param _ethMultisigWallet wallet address to transfer invested ETH
153   /// @param _tokenMultisigWallet wallet address to withdraw unused tokens
154   /// @param _startTime ICO start time
155   /// @param _duration ICO duration in seconds
156   /// @param _prolongedDuration Prolonged ICO duration in seconds, 0 if no prolongation is planned
157   /// @param _tokenPrice Token price in wei
158   /// @param _minInvestment Minimal investment amount in wei
159   /// @param _allowedSenders List of addresses allowed to send ETH to this contract, empty if anyone is allowed
160   function SilentNotaryTokenSale(address _token, address _ethMultisigWallet, address _tokenMultisigWallet,
161             uint _startTime, uint _duration, uint _prolongedDuration, uint _tokenPrice, uint _minInvestment, address[] _allowedSenders) public {
162     require(_token != 0);
163     require(_ethMultisigWallet != 0);
164     require(_tokenMultisigWallet != 0);
165     require(_duration > 0);
166     require(_tokenPrice > 0);
167     require(_minInvestment > 0);
168 
169     token = ERC20(_token);
170     ethMultisigWallet = _ethMultisigWallet;
171     tokenMultisigWallet = _tokenMultisigWallet;
172     startTime = _startTime;
173     duration = _duration;
174     prolongedDuration = _prolongedDuration;
175     tokenPrice = _tokenPrice;
176     minInvestment = _minInvestment;
177     allowedSenders = _allowedSenders;
178     tokenValueMultiplier = 10 ** token.decimals();
179   }
180 
181   /// @dev Sell tokens to ETH sender
182   function() public payable {
183     require(!stopped);
184     require(getCurrentStatus() == Status.Selling || getCurrentStatus() == Status.ProlongedSelling);
185     require(msg.value >= minInvestment);
186     address receiver = msg.sender;
187 
188     // Check if current sender is allowed to participate in this crowdsale
189     var senderAllowed = false;
190     if (allowedSenders.length > 0) {
191       for (uint i = 0; i < allowedSenders.length; i++)
192         if (allowedSenders[i] == receiver){
193           senderAllowed = true;
194           break;
195         }
196     }
197     else
198       senderAllowed = true;
199 
200     assert(senderAllowed);
201 
202     uint weiAmount = msg.value;
203     uint tokenAmount = safeDiv(safeMul(weiAmount, tokenValueMultiplier), tokenPrice);
204     assert(tokenAmount > 0);
205 
206     uint changeWei = 0;
207     var currentContractTokens = token.balanceOf(address(this));
208     if (currentContractTokens < tokenAmount) {
209       var changeTokenAmount = safeSub(tokenAmount, currentContractTokens);
210       changeWei = safeDiv(safeMul(changeTokenAmount, tokenPrice), tokenValueMultiplier);
211       tokenAmount = currentContractTokens;
212       weiAmount = safeSub(weiAmount, changeWei);
213     }
214 
215     if(investedAmountOf[receiver] == 0) {
216        // A new investor
217        investorCount++;
218     }
219     // Update investor-amount mappings
220     investedAmountOf[receiver] = safeAdd(investedAmountOf[receiver], weiAmount);
221     tokenAmountOf[receiver] = safeAdd(tokenAmountOf[receiver], tokenAmount);
222     // Update totals
223     weiRaisedAmount = safeAdd(weiRaisedAmount, weiAmount);
224     tokensSoldAmount = safeAdd(tokensSoldAmount, tokenAmount);
225 
226     // Transfer the invested ETH to the multisig wallet;
227     ethMultisigWallet.transfer(weiAmount);
228 
229     // Transfer the bought tokens to the ETH sender
230     var transferSuccess = token.transfer(receiver, tokenAmount);
231     assert(transferSuccess);
232 
233     // Return change if any
234     if (changeWei > 0) {
235       receiver.transfer(changeWei);
236     }
237 
238     // Tell us the investment succeeded
239     Invested(receiver, weiAmount, tokenAmount);
240   }
241 
242    /// @dev Token sale state machine management.
243    /// @return Status current status
244   function getCurrentStatus() public constant returns (Status) {
245     if (startTime > now)
246       return Status.Preparing;
247     if (now > startTime + duration + prolongedDuration)
248       return Status.Finished;
249     if (now > startTime + duration && !prolongationPermitted)
250       return Status.Finished;
251     if (token.balanceOf(address(this)) <= 0)
252       return Status.TokenShortage;
253     if (now > startTime + duration)
254       return Status.ProlongedSelling;
255     if (now >= startTime)
256         return Status.Selling;
257     return Status.Unknown;
258   }
259 
260   /// @dev Withdraw remaining tokens to the team wallet
261   /// @param value Amount of tokens to withdraw
262   function withdrawTokens(uint value) public onlyOwner {
263     require(value <= token.balanceOf(address(this)));
264     // Return the specified amount of tokens to team wallet
265     token.transfer(tokenMultisigWallet, value);
266     Withdraw(value);
267   }
268 
269   /// @dev Change current token price
270   /// @param newTokenPrice New token unit price in wei
271   function changeTokenPrice(uint newTokenPrice) public onlyOwner {
272     require(newTokenPrice > 0);
273 
274     tokenPrice = newTokenPrice;
275     TokenPriceChanged(newTokenPrice);
276   }
277 
278   /// @dev Prolong ICO if owner decides to do it
279   function prolong() public onlyOwner {
280     require(!prolongationPermitted && prolongedDuration > 0);
281     prolongationPermitted = true;
282   }
283 
284   /// @dev Called by the owner on excess, triggers stopped state
285   function stopSale() public onlyOwner {
286     stopped = true;
287   }
288 
289   /// @dev Called by the owner on end of excess, returns to normal state
290   function resumeSale() public onlyOwner {
291     require(stopped);
292     stopped = false;
293   }
294 
295   /// @dev Called by the owner to destroy contract
296   function kill() public onlyOwner {
297     selfdestruct(owner);
298   }
299 }