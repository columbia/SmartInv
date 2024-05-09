1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract IERC20 {
30 
31     function balanceOf(address _to) public constant returns (uint256);
32     function transfer(address to, uint256 value) public;
33     function transferFrom(address from, address to, uint256 value) public;
34     function approve(address spender, uint256 value) public;
35     function allowance(address owner, address spender) public constant returns(uint256);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 contract StandardToken is IERC20{
40     using SafeMath for uint256;
41     // Balances for each account
42     mapping (address => uint256) balances;
43     // Owner of account approves the transfer of an amount to another account
44     mapping (address => mapping(address => uint256)) allowed;
45 
46     // What is the balance of a particular account?
47     // @param who The address of the particular account
48     // @return the balanace the particular account
49     function balanceOf(address _to) public constant returns (uint256) {
50         return balances[_to];
51     }
52 
53     // @notice send `value` token to `to` from `msg.sender`
54     // @param to The address of the recipient
55     // @param value The amount of token to be transferred
56     // @return the transaction address and send the event as Transfer
57     function transfer(address to, uint256 value) public {
58         require (
59             balances[msg.sender] >= value && value > 0
60         );
61         balances[msg.sender] = balances[msg.sender].sub(value);
62         balances[to] = balances[to].add(value);
63         Transfer(msg.sender, to, value);
64     }
65 
66 
67     // @notice send `value` token to `to` from `from`
68     // @param from The address of the sender
69     // @param to The address of the recipient
70     // @param value The amount of token to be transferred
71     // @return the transaction address and send the event as Transfer
72     function transferFrom(address from, address to, uint256 value) public {
73         require (
74             allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
75         );
76         balances[from] = balances[from].sub(value);
77         balances[to] = balances[to].add(value);
78         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
79         Transfer(from, to, value);
80     }
81 
82     // Allow spender to withdraw from your account, multiple times, up to the value amount.
83     // If this function is called again it overwrites the current allowance with value.
84     // @param spender The address of the sender
85     // @param value The amount to be approved
86     // @return the transaction address and send the event as Approval
87     function approve(address spender, uint256 value) public {
88         require (
89             balances[msg.sender] >= value && value > 0
90         );
91         allowed[msg.sender][spender] = value;
92         Approval(msg.sender, spender, value);
93     }
94 
95     // Check the allowed value for the spender to withdraw from owner
96     // @param owner The address of the owner
97     // @param spender The address of the spender
98     // @return the amount which spender is still allowed to withdraw from owner
99     function allowance(address _owner, address spender) public constant returns (uint256) {
100         return allowed[_owner][spender];
101     }
102 }
103 contract TLC is StandardToken {
104     
105   using SafeMath for uint256;
106  
107   string public constant name = "Toplancer";
108   string public constant symbol = "TLC";
109   uint256 public constant decimals = 18;
110   
111   uint256 public constant totalSupply = 400000000e18;  
112 }
113 
114 
115 contract TLCMarketCrowdsale is TLC {
116     
117   uint256 public minContribAmount = 0.1 ether; // 0.1 ether
118   uint256 public presaleCap = 20000000e18; // 5%
119   uint256 public soldTokenInPresale;
120   uint256 public publicSaleCap = 320000000e18; // 80%
121   uint256 public soldTokenInPublicsale;
122   uint256 public distributionSupply = 60000000e18; // 15%
123   uint256 public softCap = 5000 ether;
124   uint256 public hardCap = 60000 ether;
125   // amount of raised money in wei
126   uint256 public weiRaised = 0;
127    // Wallet Address of Token
128   address public multisig;
129   // Owner of Token
130   address public owner;
131    // start and end timestamps where investments are allowed (both inclusive)
132   uint256 public startTime;
133   uint256 public endTime;
134   // how many token units a buyer gets per wei
135   uint256 public rate = 3500 ; // 1 ether = 3500 TLC
136   // How much ETH each address has invested to this publicsale
137   mapping (address => uint256) public investedAmountOf;
138   // How many distinct addresses have invested
139   uint256 public investorCount;
140   // fund raised during public sale 
141   uint256 public fundRaisedDuringPublicSale = 0;
142   // How much wei we have returned back to the contract after a failed crowdfund.
143   uint256 public loadedRefund = 0;
144   // How much wei we have given back to investors.
145   uint256 public weiRefunded = 0;
146 
147   enum Stage {PRESALE, PUBLICSALE, SUCCESS, FAILURE, REFUNDING, CLOSED}
148   Stage public stage;
149   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
150   // Refund was processed for a contributor
151   event Refund(address investor, uint256 weiAmount);
152  
153 
154   function TLCMarketCrowdsale(uint256 _startTime, uint256 _endTime, address _wallet) {
155         require( _endTime >= _startTime && _wallet != 0x0);
156 
157         startTime = _startTime;
158         endTime = _endTime;
159         multisig = _wallet;
160         owner=msg.sender;
161         balances[multisig] = totalSupply;
162         stage = Stage.PRESALE;
163   }
164   
165   function buyTokens(address beneficiary) public payable {
166     require(beneficiary != address(0));
167     require(validPurchase());
168     uint256 weiAmount = msg.value;
169     // calculate token amount to be created
170     uint256 tokens = weiAmount.mul(rate);
171     weiRaised = weiRaised.add(weiAmount);
172    
173     uint256 timebasedBonus = tokens.mul(getTimebasedBonusRate()).div(100);
174     tokens = tokens.add(timebasedBonus);
175     forwardFunds();
176     if (stage == Stage.PRESALE) {
177         assert (soldTokenInPresale + tokens <= presaleCap);
178         soldTokenInPresale = soldTokenInPresale.add(tokens);
179     } else {
180         assert (soldTokenInPublicsale + tokens <= publicSaleCap);
181          if(investedAmountOf[beneficiary] == 0) {
182            // A new investor
183            investorCount++;
184         }
185         // Update investor
186         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
187         fundRaisedDuringPublicSale = fundRaisedDuringPublicSale.add(weiAmount);
188         soldTokenInPublicsale = soldTokenInPublicsale.add(tokens);
189     }
190     balances[multisig] = balances[multisig].sub(tokens);
191     balances[beneficiary] = balances[beneficiary].add(tokens);
192     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
193   }
194     // send ether to the fund collection wallet
195    // override to create custom fund forwarding mechanisms
196     function forwardFunds() internal {
197         multisig.transfer(msg.value);
198     }
199      // Payable method
200     // @notice Anyone can buy the tokens on tokensale by paying ether
201     function () public payable {
202         buyTokens(msg.sender);
203     }
204  
205     // modifier to allow only owner has full control on the function
206     modifier onlyOwner {
207         require(msg.sender == owner);
208         _;
209     }
210      modifier isRefunding {
211         require (stage == Stage.REFUNDING);
212         _;
213     }
214      modifier isFailure {
215         require (stage == Stage.FAILURE);
216         _;
217     }
218     // @return true if crowdsale current lot event has ended
219     function hasEnded() public constant returns (bool) {
220         return getNow() > endTime;
221     }
222      // @return  current time
223     function getNow() public constant returns (uint256) {
224         return (now * 1000);
225     }
226    
227   // @return true if the transaction can buy tokens
228   function validPurchase() internal constant returns (bool) {
229         bool withinPeriod = getNow() >= startTime && getNow() <= endTime;
230         bool nonZeroPurchase = msg.value != 0;
231         bool minContribution = minContribAmount <= msg.value;
232         return withinPeriod && nonZeroPurchase && minContribution;
233     }
234   // Get the time-based bonus rate
235   function getTimebasedBonusRate() internal constant returns (uint256) {
236   	  uint256 bonusRate = 0;
237       if (stage == Stage.PRESALE) {
238           bonusRate = 50;
239       } else {
240           uint256 nowTime = getNow();
241           uint256 bonusFirstWeek = startTime + (7 days * 1000);
242           uint256 bonusSecondWeek = bonusFirstWeek + (7 days * 1000);
243           uint256 bonusThirdWeek = bonusSecondWeek + (7 days * 1000);
244           uint256 bonusFourthWeek = bonusThirdWeek + (7 days * 1000);
245           if (nowTime <= bonusFirstWeek) {
246               bonusRate = 25;
247           } else if (nowTime <= bonusSecondWeek) {
248               bonusRate = 20;
249           } else if (nowTime <= bonusThirdWeek) {
250               bonusRate = 10;
251           } else if (nowTime <= bonusFourthWeek) {
252               bonusRate = 5;
253           }
254       }
255       return bonusRate;
256   }
257 
258   // Start public sale
259   function startPublicsale(uint256 _startTime, uint256 _endTime, uint256 _tokenPrice) public onlyOwner {
260       require(hasEnded() && stage == Stage.PRESALE && _endTime >= _startTime && _tokenPrice > 0);
261       stage = Stage.PUBLICSALE;
262       startTime = _startTime;
263       endTime = _endTime;
264       rate = _tokenPrice;
265   }
266   
267     // @return true if the crowdsale has raised enough money to be successful.
268     function isMaximumGoalReached() public constant returns (bool reached) {
269         return weiRaised >= hardCap;
270     }
271 
272     // Validate and update the crowdsale stage
273     function updateICOStatus() public onlyOwner {
274         require(hasEnded() && stage == Stage.PUBLICSALE);
275         if (hasEnded() && weiRaised >= softCap) {
276             stage = Stage.SUCCESS;
277         } else if (hasEnded()) {
278             stage = Stage.FAILURE;
279         }
280     }
281 
282     //  Allow load refunds back on the contract for the refunding. The team can transfer the funds back on the smart contract in the case the minimum goal was not reached.
283     function loadRefund() public payable isFailure{
284         require(msg.value != 0);
285         loadedRefund = loadedRefund.add(msg.value);
286         if (loadedRefund <= fundRaisedDuringPublicSale) {
287             stage = Stage.REFUNDING;
288         }
289     }
290 
291     // Investors can claim refund.
292     // Note that any refunds from indirect buyers should be handled separately, and not through this contract.
293     function refund() public isRefunding {
294         uint256 weiValue = investedAmountOf[msg.sender];
295         require (weiValue != 0);
296 
297         investedAmountOf[msg.sender] = 0;
298         balances[msg.sender] = 0;
299         weiRefunded = weiRefunded.add(weiValue);
300         Refund(msg.sender, weiValue);
301         
302         msg.sender.transfer(weiValue);
303         
304         if (weiRefunded <= fundRaisedDuringPublicSale) {
305             stage = Stage.CLOSED;
306         }
307     }
308   
309     // Set/change Multi-signature wallet address
310     function changeMultiSignatureWallet (address _multisig)public onlyOwner{
311         multisig = _multisig;
312     }
313     // Change Minimum contribution
314     function changeMinContribution(uint256 _minContribAmount)public onlyOwner {
315         minContribAmount = _minContribAmount;
316     }
317      
318      //Change Presale Publicsale end time
319      function changeEndTime(uint256 _endTime) public onlyOwner {
320         require(endTime > startTime);
321     	endTime = _endTime;
322     }
323 
324     // Token distribution to Founder, Key Employee Allocation
325     // _founderAndTeamCap = 10000000e18; 10%
326      function sendFounderAndTeamToken(address to, uint256 value) public onlyOwner{
327          require (
328              to != 0x0 && value > 0 && distributionSupply >= value
329          );
330          balances[multisig] = balances[multisig].sub(value);
331          balances[to] = balances[to].add(value);
332          distributionSupply = distributionSupply.sub(value);
333          Transfer(multisig, to, value);
334      }
335 }