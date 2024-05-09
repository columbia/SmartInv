1 pragma solidity ^0.4.15;
2 /*Visit  http://titscrypto.com/  for more information */
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal returns(uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal returns(uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal returns(uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal returns(uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract Ownable {
32     address public owner;
33 
34 
35     /** 
36      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37      * account.
38      */
39     function Ownable() {
40         owner = msg.sender;
41     }
42 
43 
44     modifier onlyOwner() {
45         if (msg.sender != owner) {
46             revert();
47         } else {
48             _;
49         }
50     }
51 
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60     uint256 public totalSupply;
61 
62     function balanceOf(address who) constant returns(uint256);
63 
64     function transfer(address to, uint256 value);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73     function allowance(address owner, address spender) constant returns(uint256);
74 
75     function transferFrom(address from, address to, uint256 value);
76 
77     function approve(address spender, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances. 
84  */
85 contract BasicToken is ERC20Basic {
86     using SafeMath
87     for uint256;
88     mapping(address => uint256) balances;
89 
90 	/**
91 	  * @dev transfer token for a specified address
92 	  * @param _to The address to transfer to.
93 	  * @param _value The amount to be transferred.
94 	  */
95     function transfer(address _to, uint256 _value) {
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99     }
100 	
101 	/**
102 	  * @dev Gets the balance of the specified address.
103 	  * @param _owner The address to query the the balance of. 
104 	  * @return An uint256 representing the amount owned by the passed address.
105 	  */
106     function balanceOf(address _owner) constant returns(uint256 balance) {
107         return balances[_owner];
108     }
109 
110 }
111 
112 contract StandardToken is ERC20, BasicToken {
113 
114     mapping(address => mapping(address => uint256)) allowed;
115 	
116 	/**
117 	   * @dev Transfer tokens from one address to another
118 	   * @param _from address The address which you want to send tokens from
119 	   * @param _to address The address which you want to transfer to
120 	   * @param _value uint256 the amout of tokens to be transfered
121 	   */
122     function transferFrom(address _from, address _to, uint256 _value) {
123         var _allowance = allowed[_from][msg.sender];
124 
125         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126         // if (_value > _allowance) throw;
127 
128         balances[_to] = balances[_to].add(_value);
129         balances[_from] = balances[_from].sub(_value);
130         allowed[_from][msg.sender] = _allowance.sub(_value);
131         Transfer(_from, _to, _value);
132     }
133 
134 	  /**
135 	   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
136 	   * @param _spender The address which will spend the funds.
137 	   * @param _value The amount of tokens to be spent.
138 	   */
139     function approve(address _spender, uint256 _value) {
140 
141         // To change the approve amount you first have to reduce the addresses`
142         //  allowance to zero by calling `approve(_spender, 0)` if it is not
143         //  already 0 to mitigate the race condition described here:
144         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
146 
147         allowed[msg.sender][_spender] = _value;
148         Approval(msg.sender, _spender, _value);
149     }
150 
151 	/**
152 	   * @dev Function to check the amount of tokens that an owner allowed to a spender.
153 	   * @param _owner address The address which owns the funds.
154 	   * @param _spender address The address which will spend the funds.
155 	   * @return A uint256 specifing the amount of tokens still avaible for the spender.
156 	   */
157     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
158         return allowed[_owner][_spender];
159     }
160 
161 }
162 
163 contract MintableToken is StandardToken, Ownable {
164     event Mint(address indexed to, uint256 amount);
165     event MintFinished();
166     event MintStarted();
167     event RefundRequest(uint256 sum,address adr,uint256 balance);
168     event CoinBuy(uint256 sum,address adr);
169     
170 
171     bool public mintingFinished = true;
172     bool public goalReached = false;
173     uint public mintingStartTime = 0;
174     uint public maxMintingTime = 30 days;
175     uint public mintingGoal = 500 ether;
176 
177     address public titsTokenAuthor = 0x189891d02445D87e70d515fD2159416f023B0087;
178 
179 	/**
180 	   * @dev Fell fre to donate Author if You like what is presented here
181 	   */
182     function donateAuthor() payable {
183         titsTokenAuthor.transfer(msg.value);
184     }
185 
186     bool public alreadyMintedOnce = false;
187 
188     modifier mintingClosed() {
189         if (mintingFinished == false || alreadyMintedOnce == false) revert();
190         _;
191     }
192     
193     modifier IsMintingGoal() {
194         if (mintingFinished == false || alreadyMintedOnce == false || goalReached == false ) revert();
195         _;
196     }
197 
198     modifier notMintedYet() {
199         if (alreadyMintedOnce == true) revert();
200         _;
201     }
202 
203     function getNow() public returns(uint256){
204         return now;
205     }
206     
207 	/**
208 	   * @dev Premium for buying TITS at the begining of ICO 
209 	   * @return bool True if no errors
210 	   */
211     function fastBuyBonus() private returns(uint) {
212         uint period = getNow() - mintingStartTime;
213         if (period < 1 days) {
214             return 3500;
215         }
216         if (period < 2 days) {
217             return 3200;
218         }
219         if (period < 3 days) {
220             return 3000;
221         }
222         if (period < 7 days) {
223             return 2600;
224         }
225         if (period < 10 days) {
226             return 2400;
227         }
228         if (period < 12 days) {
229             return 2200;
230         }
231         if (period < 14 days) {
232             return 2000;
233         }
234         if (period < 17 days) {
235             return 1800;
236         }
237         if (period < 19 days) {
238             return 1600;
239         }
240         if (period < 21 days) {
241             return 1400;
242         }
243         if (period < 23 days) {
244             return 1200;
245         }
246         return 1000;
247     }
248 
249 	/**
250 	   * @dev Allows to buy shares
251 	   * @return bool True if no errors
252 	   */
253     function buy() payable returns(bool) {
254         if (mintingFinished) {
255             revert();
256         }
257 
258         uint _amount = 0;
259         _amount = msg.value * fastBuyBonus();
260         totalSupply = totalSupply.add(_amount);
261         CoinBuy(_amount,msg.sender);
262         balances[msg.sender] = balances[msg.sender].add(_amount);
263         balances[owner] = balances[owner].add(_amount / 85 * 15); //15% shares of owner
264         totalSupply = totalSupply.add(_amount / 85 * 15);
265         return true;
266     }
267 
268 	/**
269 	   * @dev Opens ICO (only owner)
270 	   * @return bool True if no errors
271 	   */
272     function startMinting() onlyOwner notMintedYet returns(bool) {
273         mintingStartTime = getNow();
274         alreadyMintedOnce = true;
275         mintingFinished = false;
276         MintStarted();
277         return true;
278     }
279 
280 	/**
281 	   * @dev Closes ICO - anyone can invoke if invoked to soon, takes no actions
282 	   * @return bool True if no errors
283 	   */
284     function finishMinting() returns(bool) {
285         if (mintingFinished == false) {
286             if (getNow() - mintingStartTime > maxMintingTime) {
287                 mintingFinished = true;
288                 MintFinished();
289                 goalReached = (this.balance > mintingGoal);
290                 return true;
291             }
292         }
293         revert();
294     }
295 
296 	/**
297 	   * @dev Function refunds contributors if ICO was unsuccesful 
298 	   * @return bool True if conditions for refund are met false otherwise.
299 	   */
300     function refund() returns(bool) {
301         if (mintingFinished == true && goalReached == false && alreadyMintedOnce == true) {
302             uint256 valueOfInvestment =  this.balance.mul(balances[msg.sender]).div(totalSupply);
303             totalSupply.sub(balances[msg.sender]);
304             RefundRequest(valueOfInvestment,msg.sender,balances[msg.sender]);
305             balances[msg.sender] = 0;
306             msg.sender.transfer(valueOfInvestment);
307 			return true;
308         }
309         revert();
310     }
311  
312 }
313 
314 contract TitsToken is MintableToken {
315     string public name = "Truth In The Sourcecode";
316     string public symbol = "TITS";
317     uint public decimals = 18;
318     uint public voitingStartTime;
319     address public votedAddress;
320     uint public votedYes = 1;
321     uint public votedNo = 0;
322     event VoteOnTransferStarted(address indexed beneficiaryContract);
323     event RegisterTransferBeneficiaryContract(address indexed beneficiaryContract);
324     event VotingEnded(address indexed beneficiaryContract, bool result);
325     event ShareHolderVoted(address adr,uint256 votes,bool isYesVote);
326 
327     uint public constant VOTING_PREPARE_TIMESPAN = 7 days;
328     uint public constant VOTING_TIMESPAN =  7 days;
329     uint public failedVotingCount = 0;
330     bool public isVoting = false;
331     bool public isVotingPrepare = false;
332 
333     address public beneficiaryContract = address(0);
334 
335     mapping(address => uint256) public votesAvailable;
336     address[] public voters;
337 
338 	/**
339 	   * @dev voting long enought to go to next phase 
340 	   */
341     modifier votingLong() {
342         if (getNow() - voitingStartTime <  VOTING_TIMESPAN) revert();
343         _;
344     }
345 
346 	/**
347 	   * @dev preparation for voting (application for voting) long enought to go to next phase 
348 	   */
349     modifier votingPrepareLong() {
350         if (getNow() - voitingStartTime < VOTING_PREPARE_TIMESPAN) revert();
351         _;
352     }
353 
354 	/**
355 	   * @dev Voting started and in progress
356 	   */
357     modifier votingInProgress() {
358         if (isVoting == false) revert();
359         _;
360     }
361     modifier votingNotInProgress() {
362         if (isVoting == true) revert();
363         _;
364     }
365 
366 	/**
367 	   * @dev Voting preparation started and in progress
368 	   */
369     modifier votingPrepareInProgress() {
370         if (isVotingPrepare == false) revert();
371         _;
372     }
373 
374 	/**
375 	   * @dev Voters agreed on proposed contract and Ethereum is being send to that contract
376 	   */
377     function sendToBeneficiaryContract()  {
378         if (beneficiaryContract != address(0)) {
379             beneficiaryContract.transfer(this.balance);
380         } else {
381             revert();
382         }
383     }
384 		
385 	/**
386 	   * @dev can be called by anyone, if timespan withou accepted proposal long enought 
387 	   * enables refund
388 	   */
389 	function registerVotingPrepareFailure() mintingClosed{
390 		if(getNow()-mintingStartTime>(2+failedVotingCount)*maxMintingTime ){
391 			failedVotingCount=failedVotingCount+1;
392             if (failedVotingCount == 10) {
393                 goalReached = false;
394             }
395 		}
396 	}
397 
398 	/**
399 	   * @dev opens preparation for new voting on proposed Lottery Contract address
400 	   */
401     function startVotingPrepare(address votedAddressArg) mintingClosed votingNotInProgress IsMintingGoal onlyOwner{
402         isVoting = false;
403         isVotingPrepare = true;
404         RegisterTransferBeneficiaryContract(votedAddressArg);
405         votedAddress = votedAddressArg;
406         voitingStartTime = getNow();
407         for (uint i = 0; i < voters.length; i++) {
408             delete voters[i];
409         }
410         delete voters;
411     }
412 
413 	/**
414 	   * @dev payable so attendance only of people who really care
415 	   * registers You as a voter;
416 	   */
417     function registerForVoting() payable votingPrepareInProgress {
418         if (msg.value >= 10 finney) {
419             voters.push(msg.sender);
420         }
421 		else{
422 			revert();
423 		}
424     }
425 
426 	/**
427 	   * @dev opens voting on proposed Lottery Contract address
428 	   */
429     function startVoting() votingPrepareInProgress votingPrepareLong {
430         VoteOnTransferStarted(votedAddress);
431         for (uint256 i = 0; i < voters.length; i++) {
432             address voter = voters[i];
433             uint256 votes = balanceOf(voter);
434             votesAvailable[voter]=votes;
435         }
436         isVoting = true;
437         voitingStartTime = getNow();
438         isVotingPrepare = false;
439     }
440 
441 	/**
442 	   * @dev closes voting on proposed Lottery Contract address
443 	   * checks if failed - if No votes is more common than yes increase failed voting count and if it reaches 10 
444 	   * reach of goal is failing and investors can withdraw their money
445 	   */
446     function closeVoring() votingInProgress votingLong {
447         VotingEnded(votedAddress, votedYes > votedNo);
448         isVoting = false;
449         isVotingPrepare = false;
450         if (votedYes > votedNo) {
451             beneficiaryContract = votedAddress;
452         } else {
453             failedVotingCount = failedVotingCount + 1;
454             if (failedVotingCount == 10) {
455                 goalReached = false;
456             }
457         }
458     }
459 
460 	/**
461 	   * @dev votes on contract proposal
462 	   */
463     function vote(bool isVoteYes) votingInProgress{
464 
465             uint256 votes = votesAvailable[msg.sender];
466             ShareHolderVoted(msg.sender,votes,isVoteYes);
467             if (isVoteYes) {
468                 votesAvailable[msg.sender] = 0;
469                 votedYes = votedYes.add(votes);
470             }
471             else
472             if (isVoteYes==false) {
473                 votesAvailable[msg.sender] = 0;
474                 votedNo = votedNo.add(votes);
475             } 
476             else{
477                 revert();   
478             }
479             
480     }
481 }