1 pragma solidity ^0.4.16;
2 
3 
4 /// @title etherfund.me ERC20 tokens issued crowdfunding contract
5 contract EtherFundMeIssueTokensCrowdfunding {
6 
7     ///////////////////////////////////////////////////////////////////////////////
8     /// ERC20 Token fields
9     ///////////////////////////////////////////////////////////////////////////////
10     /// Returns the name of the token - e.g. "MyToken".
11     string public name;
12 
13     /// Returns the symbol of the token. E.g. "HIX".
14     string public symbol;
15 
16     /// Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000 to get its user representation
17     uint public decimals;
18 
19     /// Returns the total token supply
20     uint public totalSupply;
21 
22     /// approve() allowances
23     mapping (address => mapping (address => uint)) allowed;
24 
25     /// holder balances
26     mapping(address => uint) balances;
27 
28     ///////////////////////////////////////////////////////////////////////////////
29     /// Crowdfunding fields
30     ///////////////////////////////////////////////////////////////////////////////
31     /// The crowdfunding project name
32     string public projectName;
33 
34     /// The crowdfunding project description
35     string public projectDescription;
36 
37     /// The crowdfunding team contact
38     string public teamEmail;
39 
40     /// The start time of crowdfunding
41     uint public startsAt;
42 
43     /// The end time of crowdfunding
44     uint public endsAt;
45 
46     /// Crowdfunding team wallet
47     address public teamWallet;
48 
49     /// etherfund.me fee wallet
50     address public feeReceiverWallet;
51 
52     /// etherfund.me deploy agent
53     address public deployAgentWallet;
54 
55     /// How much tokens will team will receive
56     uint teamTokensAmount;
57 
58     /// How much tokens remain for sale
59     uint tokensForSale = totalSupply - teamTokensAmount;
60 
61     /// How much token cost in wei 
62     uint public tokenPrice;
63 
64     /// if the funding goal is not reached, investors may withdraw their funds
65     uint public fundingGoal;
66 
67     ///  How many distinct addresses have invested
68     uint public investorCount = 0;
69 
70     ///  Has this crowdfunding been finalized
71     bool public finalized;
72 
73     ///  Has this crowdfunding been paused
74     bool public halted;
75 
76     ///  How much ETH each address has invested to this crowdfunding
77     mapping (address => uint256) public investedAmountOf;
78 
79     ///  How much tokens each address has invested to this crowdfunding
80     mapping (address => uint256) public tokenAmountOf;
81 
82     /// etherfund.me final fee in %
83     uint public constant ETHERFUNDME_FEE = 3;
84 
85     /// etherfund.me each transaction fee in %
86     uint public constant ETHERFUNDME_ONLINE_FEE = 1;
87 
88     /// if a project reach 60% of their funding goal it becomes successful
89     uint public constant GOAL_REACHED_CRITERION = 80;
90 
91     /// Define pricing schedule using milestones.
92     struct Milestone {
93         // UNIX timestamp when this milestone kicks in
94         uint start;
95         // UNIX timestamp when this milestone kicks out
96         uint end;
97         // How many % tokens will add
98         uint bonus;
99     }
100 
101     /// Define a structure for one investment event occurrence
102     struct Investment {
103         /// Who invested
104         address source;
105 
106         /// Tokens count
107         uint tokensAmount;
108     }
109  
110     /// Milestones list
111     Milestone[] public milestones;
112 
113     /// Array element counter for investments
114     uint public investmentsCount;
115 
116     /// How much tokens each address has invested to this contract
117     Investment[] public investments;
118 
119     /// State machine
120     /// Preparing: All contract initialization calls and variables have not been set yet
121     /// Funding: Active crowdsale
122     /// Success: Minimum funding goal reached
123     /// Failure: Minimum funding goal not reached before ending time
124     /// Finalized: The finalized has been called and succesfully executed
125     /// Refunding: Refunds are loaded on the contract for reclaim
126     enum State { Unknown, Preparing, Funding, Success, Failure, Finalized, Refunding }
127 
128     ///////////////////////////////////////////////////////////////////////////////
129     /// Crowdfunding events
130     ///////////////////////////////////////////////////////////////////////////////
131     /// A new investment was made
132     event Invested(address investor, uint weiAmount);
133     /// Withdraw was processed for a contributor
134     event Withdraw(address receiver, uint weiAmount);
135     /// Returning funds for a contributor
136     event Refund(address receiver, uint weiAmount);
137 
138     ///////////////////////////////////////////////////////////////////////////////
139     /// ERC20 Token events
140     ///////////////////////////////////////////////////////////////////////////////
141     event Transfer(address indexed from, address indexed to, uint value);
142     event Approval(address indexed owner, address indexed spender, uint value);
143 
144     ///////////////////////////////////////////////////////////////////////////////
145     /// ERC20 Token modifiers
146     ///////////////////////////////////////////////////////////////////////////////
147     /// @dev Modified allowing execution only if the crowdfunding is currently running
148     modifier inState(State state) {
149         require(getState() == state);
150         _;
151     }
152 
153     /// @dev Limit token transfer until the sale is over.
154     modifier canTransfer() {
155         require(finalized);
156         _;
157     }
158 
159     ///////////////////////////////////////////////////////////////////////////////
160     /// Crowdfunding modifiers
161     ///////////////////////////////////////////////////////////////////////////////
162     /// @dev Modified allowing execution only if deploy agent call
163     modifier onlyDeployAgent() {
164         require(msg.sender == deployAgentWallet);
165         _;
166     }
167 
168     /// @dev Modified allowing execution only if not stopped
169     modifier stopInEmergency {
170         require(!halted);
171         _;
172     }
173 
174     /// @dev Modified allowing execution only if stopped
175     modifier onlyInEmergency {
176         require(halted);
177         _;
178     }
179 
180     /// @dev Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
181     /// @param size payload size
182     modifier onlyPayloadSize(uint size) {
183        require(msg.data.length >= size + 4);
184        _;
185     }
186 
187     /// @dev Constructor
188     /// @param _projectName crowdfunding project name
189     /// @param _projectDescription crowdfunding project short description
190     /// @param _teamEmail crowdfunding team contact
191     /// @param _startsAt crowdfunding start time
192     /// @param _endsAt crowdfunding end time
193     /// @param _fundingGoal funding goal in wei
194     /// @param _teamWallet  team address
195     /// @param _feeReceiverWallet  fee receiver address
196     /// @param _name ERC20 token name
197     /// @param _symbol ERC20 token symbol
198     /// @param _decimals  ERC20 token decimal
199     /// @param _totalSupply  ERC20 token amount
200     /// @param _tokenPrice token price in wei
201     /// @param _teamTokensAmount token amount for team
202     function EtherFundMeIssueTokensCrowdfunding(
203       string _projectName,
204       string _projectDescription,
205       string _teamEmail,
206       uint _startsAt,
207       uint _endsAt,
208       uint _fundingGoal,
209       address _teamWallet,
210       address _feeReceiverWallet,
211       string _name,
212       string _symbol,
213       uint _decimals,
214       uint _totalSupply,
215       uint _tokenPrice,
216       uint _teamTokensAmount) {
217         require(_startsAt != 0);
218         require(_endsAt != 0);
219         require(_fundingGoal != 0);
220         require(_teamWallet != 0);
221         require(_feeReceiverWallet != 0);
222         require(_decimals >= 2);
223         require(_totalSupply > 0);
224         require(_tokenPrice > 0);
225 
226         deployAgentWallet = msg.sender;
227         projectName = _projectName;
228         projectDescription = _projectDescription;
229         teamEmail = _teamEmail;
230         startsAt = _startsAt;
231         endsAt = _endsAt;
232         fundingGoal = _fundingGoal;
233         teamWallet = _teamWallet;
234         feeReceiverWallet = _feeReceiverWallet;
235         name = _name;
236         symbol = _symbol;
237         decimals = _decimals;
238         totalSupply = _totalSupply;
239         tokenPrice = _tokenPrice;
240         teamTokensAmount = _teamTokensAmount;
241     }
242 
243     ///////////////////////////////////////////////////////////////////////////////
244     /// Crowdfunding methods
245     ///////////////////////////////////////////////////////////////////////////////
246     /// @dev Crowdfund state machine management.
247     /// @return State current state
248     function getState() public constant returns (State) {
249         if (finalized)
250             return State.Finalized;
251         if (startsAt > now)
252             return State.Preparing;
253         if (now >= startsAt && now < endsAt)
254             return State.Funding;
255         if (isGoalReached())
256             return State.Success;
257         if (!isGoalReached() && this.balance > 0)
258             return State.Refunding;
259         return State.Failure;
260     }
261 
262     /// @dev Goal was reached
263     /// @return true if the crowdsale has raised enough money to be a succes
264     function isGoalReached() public constant returns (bool reached) {
265         return this.balance >= (fundingGoal * GOAL_REACHED_CRITERION) / 100;
266     }
267 
268     /// @dev Fallback method
269     function() payable {
270         invest();
271     }
272 
273     /// @dev Allow contributions to this crowdfunding.
274     function invest() public payable stopInEmergency  {
275         require(getState() == State.Funding);
276         require(msg.value > 0);
277 
278         uint weiAmount = msg.value;
279         address investor = msg.sender;
280 
281         if(investedAmountOf[investor] == 0) {
282             // A new investor
283             investorCount++;
284         } 
285 
286         uint multiplier = 10 ** decimals;
287         uint tokensAmount = (weiAmount * multiplier) / tokenPrice;
288         assert(tokensAmount > 0);
289         
290         if(getCurrentMilestone().bonus > 0) {
291             tokensAmount += (tokensAmount * getCurrentMilestone().bonus) / 100;
292         }
293 
294         assert(tokensForSale - tokensAmount >= 0);
295         tokensForSale -= tokensAmount;
296         investments.push(Investment(investor, tokensAmount));
297         investmentsCount++;
298         tokenAmountOf[investor] += tokensAmount;
299 
300         // calculate online fee
301         uint onlineFeeAmount = (weiAmount * ETHERFUNDME_ONLINE_FEE) / 100;
302         Withdraw(feeReceiverWallet, onlineFeeAmount);
303         // send online fee
304         feeReceiverWallet.transfer(onlineFeeAmount);
305 
306         uint investedAmount = weiAmount - onlineFeeAmount;
307         // Update investor
308         investedAmountOf[investor] += investedAmount;
309         // Tell us invest was success
310         Invested(investor, investedAmount);
311     }
312 
313     /// @dev Finalize a succcesful crowdfunding. The team can triggre a call the contract that provides post-crowdfunding actions, like releasing the funds.
314     function finalize() public inState(State.Success) stopInEmergency  {
315         require(msg.sender == deployAgentWallet || msg.sender == teamWallet);
316         require(!finalized);
317 
318         finalized = true;
319 
320         uint feeAmount = (this.balance * ETHERFUNDME_FEE) / 100;
321         uint teamAmount = this.balance - feeAmount;
322 
323         Withdraw(teamWallet, teamAmount);
324         teamWallet.transfer(teamAmount);
325 
326         Withdraw(feeReceiverWallet, feeAmount);
327         feeReceiverWallet.transfer(feeAmount);
328 
329         // assign team tokens 
330         balances[teamWallet] += (teamTokensAmount + tokensForSale);
331         
332         // Distribute tokens to investors
333         for (uint i = 0; i < investments.length; i++) {
334             balances[investments[i].source] += investments[i].tokensAmount;
335             Transfer(0, investments[i].source, investments[i].tokensAmount);
336         }
337     }
338 
339     /// @dev Investors can claim refund.
340     function refund() public inState(State.Refunding) {
341         uint weiValue = investedAmountOf[msg.sender];
342         if (weiValue == 0) revert();
343         investedAmountOf[msg.sender] = 0;
344         Refund(msg.sender, weiValue);
345         msg.sender.transfer(weiValue);
346     }
347     
348     
349     /// @dev Called by the deploy agent on emergency, triggers stopped state
350     function halt() public onlyDeployAgent {
351         halted = true;
352     }
353 
354     /// @dev Called by the deploy agent on end of emergency, returns to normal state
355     function unhalt() public onlyDeployAgent onlyInEmergency {
356         halted = false;
357     }
358 
359     /// @dev Add a milestone
360     /// @param _start start bonus time 
361     /// @param _end end bonus  time
362     /// @param _bonus bonus percent
363     function addMilestone(uint _start, uint _end, uint _bonus) public onlyDeployAgent {
364         require(_bonus > 0 && _end > _start);
365         milestones.push(Milestone(_start, _end, _bonus));
366     }
367 
368     /// @dev Get the current milestone or bail out if we are not in the milestone periods.
369     /// @return Milestone current bonus milestone
370     function getCurrentMilestone() private constant returns (Milestone) {
371         for (uint i = 0; i < milestones.length; i++) {
372             if (milestones[i].start <= now && milestones[i].end > now) {
373                 return milestones[i];
374             }
375         }
376     }
377     ///////////////////////////////////////////////////////////////////////////////
378     /// ERC20 Token methods
379     ///////////////////////////////////////////////////////////////////////////////
380     /// @dev Returns the account balance of another account with address _owner
381     /// @param _owner holder address
382     /// @return balance amount
383     function balanceOf(address _owner) constant returns (uint balance) {
384         return balances[_owner];
385     }
386 
387     /// @dev Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. The function SHOULD throw if the _from account balance does not have enough tokens to spend.
388     /// @param _to dest address
389     /// @param _value tokens amount
390     /// @return transfer result
391     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
392         require((_to != 0) && (_to != address(this)));
393         require(balances[msg.sender] >= _value);
394 
395         balances[msg.sender] -= _value;
396         balances[_to] += _value;
397 
398         Transfer(msg.sender, _to, _value);
399         return true;
400     }
401 
402     /// @dev Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
403     /// @param _from source address
404     /// @param _to dest address
405     /// @param _value tokens amount
406     /// @return transfer result
407     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) canTransfer returns (bool success) {
408         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
409 
410         balances[_to] += _value;
411         balances[_from] -= _value;
412 
413         allowed[_from][msg.sender] -= _value;
414         Transfer(_from, _to, _value);
415         return true;
416     }
417 
418     /// @dev Allows _spender to withdraw from your account multiple times, up to the _value amount. If this function is called again it overwrites the current allowance with _value.
419     /// @param _spender holder address
420     /// @param _value tokens amount
421     /// @return result
422     function approve(address _spender, uint _value) returns (bool success) {
423         // To change the approve amount you first have to reduce the addresses`
424         //  allowance to zero by calling `approve(_spender, 0)` if it is not
425         //  already 0 to mitigate the race condition described here:
426         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
427         require ((_value == 0) || (allowed[msg.sender][_spender] == 0));
428 
429         allowed[msg.sender][_spender] = _value;
430         Approval(msg.sender, _spender, _value);
431         return true;
432     }
433 
434     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner.
435     /// @param _owner holder address
436     /// @param _spender spender address
437     /// @return remain amount
438     function allowance(address _owner, address _spender) constant returns (uint remaining) {
439         return allowed[_owner][_spender];
440     }
441 }