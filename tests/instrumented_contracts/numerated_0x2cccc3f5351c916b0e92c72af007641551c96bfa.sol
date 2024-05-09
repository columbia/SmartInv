1 pragma solidity ^0.4.19;
2 
3 contract CrowdsaleTokenInterface {
4 
5   uint public decimals;
6    
7   function addLockAddress(address addr, uint lock_time) public;
8   function mint(address _to, uint256 _amount) public returns (bool);
9   function finishMinting() public returns (bool);
10 }
11 
12 contract CrowdsaleLimit {
13   using SafeMath for uint256;
14 
15   // the UNIX timestamp start date of the crowdsale
16   uint public startsAt;
17   // the UNIX timestamp end date of the crowdsale
18   uint public endsAt;
19   
20   uint public token_decimals = 8;
21     
22   uint public TOKEN_RATE_PRESALE  = 7200;
23   uint public TOKEN_RATE_CROWDSALE= 6000;
24   
25   // setting the wei value for one token in presale stage
26   uint public PRESALE_TOKEN_IN_WEI = 1 ether / TOKEN_RATE_PRESALE;  
27   // setting the wei value for one token in crowdsale stage
28   uint public CROWDSALE_TOKEN_IN_WEI = 1 ether / TOKEN_RATE_CROWDSALE;
29   
30   // setting the max fund of presale with eth
31   uint public PRESALE_ETH_IN_WEI_FUND_MAX = 40000 ether; 
32   // setting the min fund of crowdsale with eth
33   uint public CROWDSALE_ETH_IN_WEI_FUND_MIN = 22000 ether;
34   // setting the max fund of crowdsale with eth
35   uint public CROWDSALE_ETH_IN_WEI_FUND_MAX = 90000 ether;
36   
37   // setting the min acceptable invest with eth in presale
38   uint public PRESALE_ETH_IN_WEI_ACCEPTED_MIN = 1 ether; 
39   // setting the min acceptable invest with eth in pubsale
40   uint public CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN = 100 finney;
41   
42   // setting the gasprice to limit big buyer, default to disable
43   uint public CROWDSALE_GASPRICE_IN_WEI_MAX = 0;
44  
45  // total eth fund in presale stage
46   uint public presale_eth_fund= 0;
47   // total eth fund
48   uint public crowdsale_eth_fund= 0;
49   // total eth refund
50   uint public crowdsale_eth_refund = 0;
51    
52   // setting team list and set percentage of tokens
53   mapping(address => uint) public team_addresses_token_percentage;
54   mapping(uint => address) public team_addresses_idx;
55   uint public team_address_count= 0;
56   uint public team_token_percentage_total= 0;
57   uint public team_token_percentage_max= 40;
58     
59   event EndsAtChanged(uint newEndsAt);
60   event AddTeamAddress(address addr, uint release_time, uint token_percentage);
61   event Refund(address investor, uint weiAmount);
62     
63   // limitation of buying tokens
64   modifier allowCrowdsaleAmountLimit(){	
65 	if (msg.value == 0) revert();
66 	if((crowdsale_eth_fund.add(msg.value)) > CROWDSALE_ETH_IN_WEI_FUND_MAX) revert();
67 	if((CROWDSALE_GASPRICE_IN_WEI_MAX > 0) && (tx.gasprice > CROWDSALE_GASPRICE_IN_WEI_MAX)) revert();
68 	_;
69   }
70    
71   function CrowdsaleLimit(uint _start, uint _end) public {
72 	require(_start != 0);
73 	require(_end != 0);
74 	require(_start < _end);
75 			
76 	startsAt = _start;
77     endsAt = _end;
78   }
79     
80   // caculate amount of token in presale stage
81   function calculateTokenPresale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
82     uint multiplier = 10 ** decimals;
83     return value.mul(multiplier).div(PRESALE_TOKEN_IN_WEI);
84   }
85   
86   // caculate amount of token in crowdsale stage
87   function calculateTokenCrowsale(uint value, uint decimals) /*internal*/ public constant returns (uint) {
88     uint multiplier = 10 ** decimals;
89     return value.mul(multiplier).div(CROWDSALE_TOKEN_IN_WEI);
90   }
91   
92   // check if the goal is reached
93   function isMinimumGoalReached() public constant returns (bool) {
94     return crowdsale_eth_fund >= CROWDSALE_ETH_IN_WEI_FUND_MIN;
95   }
96   
97   // add new team percentage of tokens
98   function addTeamAddressInternal(address addr, uint release_time, uint token_percentage) internal {
99 	if((team_token_percentage_total.add(token_percentage)) > team_token_percentage_max) revert();
100 	if((team_token_percentage_total.add(token_percentage)) > 100) revert();
101 	if(team_addresses_token_percentage[addr] != 0) revert();
102 	
103 	team_addresses_token_percentage[addr]= token_percentage;
104 	team_addresses_idx[team_address_count]= addr;
105 	team_address_count++;
106 	
107 	team_token_percentage_total = team_token_percentage_total.add(token_percentage);
108 
109 	AddTeamAddress(addr, release_time, token_percentage);
110   }
111    
112   // @return true if crowdsale event has ended
113   function hasEnded() public constant returns (bool) {
114     return now > endsAt;
115   }
116 }
117 
118 contract Ownable {
119   address public owner;
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124    * account.
125    */
126   function Ownable() public {
127     owner = msg.sender;
128   }
129 
130 
131   /**
132    * @dev Throws if called by any account other than the owner.
133    */
134   modifier onlyOwner() {
135     require(msg.sender == owner);
136     _;
137   }
138 
139 
140   /**
141    * @dev Allows the current owner to transfer control of the contract to a newOwner.
142    * @param newOwner The address to transfer ownership to.
143    */
144   function transferOwnership(address newOwner) onlyOwner public {
145     require(newOwner != address(0));      
146     owner = newOwner;
147   }
148 
149 }
150 
151 contract Haltable is Ownable {
152   bool public halted;
153 
154   modifier stopInEmergency {
155     if (halted) revert();
156     _;
157   }
158 
159   modifier onlyInEmergency {
160     if (!halted) revert();
161     _;
162   }
163 
164   // called by the owner on emergency, triggers stopped state
165   function halt() external onlyOwner {
166     halted = true;
167   }
168 
169   // called by the owner on end of emergency, returns to normal state
170   function unhalt() external onlyOwner onlyInEmergency {
171     halted = false;
172   }
173 
174 }
175 
176 contract Crowdsale is CrowdsaleLimit, Haltable {
177   using SafeMath for uint256;
178 
179   CrowdsaleTokenInterface public token;
180     
181   /* tokens will be transfered from this address */
182   address public multisigWallet;
183     
184   /** How much ETH each address has invested to this crowdsale */
185   mapping (address => uint256) public investedAmountOf;
186 
187   /** How much tokens this crowdsale has credited for each investor address */
188   mapping (address => uint256) public tokenAmountOf;
189      
190   /* the number of tokens already sold through this contract*/
191   uint public tokensSold = 0;
192   
193   /* How many distinct addresses have invested */
194   uint public investorCount = 0;
195   
196   /* How much wei we have returned back to the contract after a failed crowdfund. */
197   uint public loadedRefund = 0;
198   
199   /* Has this crowdsale been finalized */
200   bool public finalized;
201   
202   enum State{Unknown, PreFunding, Funding, Success, Failure, Finalized, Refunding}
203     
204   // A new investment was made
205   event Invested(address investor, uint weiAmount, uint tokenAmount);
206     
207   event createTeamTokenEvent(address addr, uint tokens);
208   
209   event Finalized();
210   
211   /** Modified allowing execution only if the crowdsale is currently running.  */
212   modifier inState(State state) {
213     if(getState() != state) revert();
214     _;
215   }
216 
217   function Crowdsale(address _token, address _multisigWallet, uint _start, uint _end) CrowdsaleLimit(_start, _end) public
218   {
219     require(_token != 0x0);
220     require(_multisigWallet != 0x0);
221 	
222 	token = CrowdsaleTokenInterface(_token);	
223 	if(token_decimals != token.decimals()) revert();
224 	
225 	multisigWallet = _multisigWallet;
226   }
227   
228   /* Crowdfund state machine management. */
229   function getState() public constant returns (State) {
230     if(finalized) return State.Finalized;
231     else if (now < startsAt) return State.PreFunding;
232     else if (now <= endsAt && !isMinimumGoalReached()) return State.Funding;
233     else if (isMinimumGoalReached()) return State.Success;
234     else if (!isMinimumGoalReached() && crowdsale_eth_fund > 0 && loadedRefund >= crowdsale_eth_fund) return State.Refunding;
235     else return State.Failure;
236   }
237     
238   //add new team percentage of tokens and lock their release time
239   function addTeamAddress(address addr, uint release_time, uint token_percentage) onlyOwner inState(State.PreFunding) public {
240 	super.addTeamAddressInternal(addr, release_time, token_percentage);
241 	token.addLockAddress(addr, release_time);  //not use delegatecall
242   }
243   
244   //generate team tokens in accordance with percentage of total issue tokens, not preallocate
245   function createTeamTokenByPercentage() onlyOwner internal {
246 	//uint total= token.totalSupply();
247 	uint total= tokensSold;
248 	
249 	//uint tokens= total.mul(100).div(100-team_token_percentage_total).sub(total);
250 	uint tokens= total.mul(team_token_percentage_total).div(100-team_token_percentage_total);
251 	
252 	for(uint i=0; i<team_address_count; i++) {
253 		address addr= team_addresses_idx[i];
254 		if(addr==0x0) continue;
255 		
256 		uint ntoken= tokens.mul(team_addresses_token_percentage[addr]).div(team_token_percentage_total);
257 		token.mint(addr, ntoken);		
258 		createTeamTokenEvent(addr, ntoken);
259 	}
260   }
261   
262   // fallback function can be used to buy tokens
263   function () stopInEmergency allowCrowdsaleAmountLimit payable public {
264 	require(msg.sender != 0x0);
265     buyTokensCrowdsale(msg.sender);
266   }
267 
268   // low level token purchase function
269   function buyTokensCrowdsale(address receiver) internal /*stopInEmergency allowCrowdsaleAmountLimit payable*/ {
270 	uint256 weiAmount = msg.value;
271 	uint256 tokenAmount= 0;
272 	
273 	if(getState() == State.PreFunding) {
274 		if (weiAmount < PRESALE_ETH_IN_WEI_ACCEPTED_MIN) revert();
275 		if((PRESALE_ETH_IN_WEI_FUND_MAX > 0) && ((presale_eth_fund.add(weiAmount)) > PRESALE_ETH_IN_WEI_FUND_MAX)) revert();		
276 		
277 		tokenAmount = calculateTokenPresale(weiAmount, token_decimals);
278 		presale_eth_fund = presale_eth_fund.add(weiAmount);
279 	}
280 	else if((getState() == State.Funding) || (getState() == State.Success)) {
281 		if (weiAmount < CROWDSALE_ETH_IN_WEI_ACCEPTED_MIN) revert();
282 		
283 		tokenAmount = calculateTokenCrowsale(weiAmount, token_decimals);
284 		
285     } else {
286       // Unwanted state
287       revert();
288     }
289 	
290 	if(tokenAmount == 0) {
291 		revert();
292 	}	
293 	
294 	if(investedAmountOf[receiver] == 0) {
295        investorCount++;
296     }
297     
298 	// Update investor
299     investedAmountOf[receiver] = investedAmountOf[receiver].add(weiAmount);
300     tokenAmountOf[receiver] = tokenAmountOf[receiver].add(tokenAmount);
301 	
302     // Update totals
303 	crowdsale_eth_fund = crowdsale_eth_fund.add(weiAmount);
304 	tokensSold = tokensSold.add(tokenAmount);
305 	
306     token.mint(receiver, tokenAmount);
307 
308     if(!multisigWallet.send(weiAmount)) revert();
309 	
310 	// Tell us invest was success
311     Invested(receiver, weiAmount, tokenAmount);
312   }
313  
314   /**
315    * Allow load refunds back on the contract for the refunding.
316    *
317    * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
318    */
319   function loadRefund() public payable inState(State.Failure) {
320     if(msg.value == 0) revert();
321     loadedRefund = loadedRefund.add(msg.value);
322   }
323   
324   /**
325    * Investors can claim refund.
326    *
327    * Note that any refunds from proxy buyers should be handled separately,
328    * and not through this contract.
329    */
330   function refund() public inState(State.Refunding) {
331     uint256 weiValue = investedAmountOf[msg.sender];
332     if (weiValue == 0) revert();
333     investedAmountOf[msg.sender] = 0;
334     crowdsale_eth_refund = crowdsale_eth_refund.add(weiValue);
335     Refund(msg.sender, weiValue);
336     if (!msg.sender.send(weiValue)) revert();
337   }
338   
339   function setEndsAt(uint time) onlyOwner public {
340     if(now > time) {
341       revert();
342     }
343 
344     endsAt = time;
345     EndsAtChanged(endsAt);
346   }
347   
348   // should be called after crowdsale ends, to do
349   // some extra finalization work
350   function doFinalize() public inState(State.Success) onlyOwner stopInEmergency {
351     
352 	if(finalized) {
353       revert();
354     }
355 
356 	createTeamTokenByPercentage();
357     token.finishMinting();	
358         
359     finalized = true;
360 	Finalized();
361   }
362   
363 }
364 
365 library SafeMath {
366   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
367     uint256 c = a * b;
368     assert(a == 0 || c / a == b);
369     return c;
370   }
371 
372   function div(uint256 a, uint256 b) internal pure returns (uint256) {
373     // assert(b > 0); // Solidity automatically throws when dividing by 0
374     uint256 c = a / b;
375     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
376     return c;
377   }
378 
379   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
380     assert(b <= a);
381     return a - b;
382   }
383 
384   function add(uint256 a, uint256 b) internal pure returns (uint256) {
385     uint256 c = a + b;
386     assert(c >= a);
387     return c;
388   }
389 }