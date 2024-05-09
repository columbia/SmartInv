1 pragma solidity ^ 0.4 .11;
2 
3 /**
4  * Overflow aware uint math functions.
5  *
6  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal returns(uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract Ownable {
35     address public owner;
36 
37 
38     /** 
39      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40      * account.
41      */
42     function Ownable() {
43         owner = msg.sender;
44     }
45 
46 
47     modifier onlyOwner() {
48         if (msg.sender != owner) {
49             revert();
50         } else {
51             _;
52         }
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) {
57             owner = newOwner;
58         }
59     }
60 
61 
62 }
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20Basic {
70     uint256 public totalSupply;
71 
72     function balanceOf(address who) constant returns(uint256);
73 
74     function transfer(address to, uint256 value);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83     function allowance(address owner, address spender) constant returns(uint256);
84 
85     function transferFrom(address from, address to, uint256 value);
86 
87     function approve(address spender, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances. 
94  */
95 contract BasicToken is ERC20Basic {
96     using SafeMath
97     for uint256;
98     mapping(address => uint256) balances;
99 
100 	/**
101 	  * @dev transfer token for a specified address
102 	  * @param _to The address to transfer to.
103 	  * @param _value The amount to be transferred.
104 	  */
105     function transfer(address _to, uint256 _value) {
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109     }
110 	
111 	/**
112 	  * @dev Gets the balance of the specified address.
113 	  * @param _owner The address to query the the balance of. 
114 	  * @return An uint256 representing the amount owned by the passed address.
115 	  */
116     function balanceOf(address _owner) constant returns(uint256 balance) {
117         return balances[_owner];
118     }
119 
120 }
121 
122 contract StandardToken is ERC20, BasicToken {
123 
124     mapping(address => mapping(address => uint256)) allowed;
125 	
126 	/**
127 	   * @dev Transfer tokens from one address to another
128 	   * @param _from address The address which you want to send tokens from
129 	   * @param _to address The address which you want to transfer to
130 	   * @param _value uint256 the amout of tokens to be transfered
131 	   */
132     function transferFrom(address _from, address _to, uint256 _value) {
133         var _allowance = allowed[_from][msg.sender];
134 
135         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
136         // if (_value > _allowance) throw;
137 
138         balances[_to] = balances[_to].add(_value);
139         balances[_from] = balances[_from].sub(_value);
140         allowed[_from][msg.sender] = _allowance.sub(_value);
141         Transfer(_from, _to, _value);
142     }
143 
144 	  /**
145 	   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
146 	   * @param _spender The address which will spend the funds.
147 	   * @param _value The amount of tokens to be spent.
148 	   */
149     function approve(address _spender, uint256 _value) {
150 
151         // To change the approve amount you first have to reduce the addresses`
152         //  allowance to zero by calling `approve(_spender, 0)` if it is not
153         //  already 0 to mitigate the race condition described here:
154         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
156 
157         allowed[msg.sender][_spender] = _value;
158         Approval(msg.sender, _spender, _value);
159     }
160 
161 	/**
162 	   * @dev Function to check the amount of tokens that an owner allowed to a spender.
163 	   * @param _owner address The address which owns the funds.
164 	   * @param _spender address The address which will spend the funds.
165 	   * @return A uint256 specifing the amount of tokens still avaible for the spender.
166 	   */
167     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 
171 }
172 
173 contract MintableToken is StandardToken, Ownable {
174     event Mint(address indexed to, uint256 amount);
175     event MintFinished();
176     event MintStarted();
177 
178     bool public mintingFinished = true;
179     bool public goalReached = false;
180     uint public mintingStartTime = 0;
181     uint public maxMintingTime = 30 days;
182     uint public mintingGoal = 500 ether;
183 
184     address public titsTokenAuthor = 0x189891d02445D87e70d515fD2159416f023B0087;
185 
186 	/**
187 	   * @dev Fell fre to donate Author if You like what is presented here
188 	   */
189     function donateAuthor() payable {
190         titsTokenAuthor.transfer(msg.value);
191     }
192 
193     bool public alreadyMintedOnce = false;
194 
195     modifier mintingClosed() {
196         if (mintingFinished == false || alreadyMintedOnce == false) revert();
197         _;
198     }
199 
200     modifier notMintedYet() {
201         if (alreadyMintedOnce == true) revert();
202         _;
203     }
204 
205     
206 	/**
207 	   * @dev Premium for buying TITS at the begining of ICO 
208 	   * @return bool True if no errors
209 	   */
210     function fastBuyBonus() private returns(uint) {
211         uint period = now - mintingStartTime;
212         if (period < 1 days) {
213             return 5000;
214         }
215         if (period < 2 days) {
216             return 4000;
217         }
218         if (period < 3 days) {
219             return 3000;
220         }
221         if (period < 7 days) {
222             return 2600;
223         }
224         if (period < 10 days) {
225             return 2400;
226         }
227         if (period < 12 days) {
228             return 2200;
229         }
230         if (period < 14 days) {
231             return 2000;
232         }
233         if (period < 17 days) {
234             return 1800;
235         }
236         if (period < 19 days) {
237             return 1600;
238         }
239         if (period < 21 days) {
240             return 1400;
241         }
242         if (period < 23 days) {
243             return 1200;
244         }
245         return 1000;
246     }
247 
248 	/**
249 	   * @dev Allows to buy shares
250 	   * @return bool True if no errors
251 	   */
252     function buy() payable returns(bool) {
253         if (mintingFinished) {
254             revert();
255         }
256 
257         uint _amount = 0;
258         _amount = msg.value * fastBuyBonus();
259         totalSupply = totalSupply.add(_amount);
260         balances[msg.sender] = balances[msg.sender].add(_amount);
261         balances[owner] = balances[owner].add(_amount / 85 * 15); //15% shares of owner
262         return true;
263     }
264 
265 	/**
266 	   * @dev Opens ICO (only owner)
267 	   * @return bool True if no errors
268 	   */
269     function startMinting() onlyOwner returns(bool) {
270         mintingStartTime = now;
271         if (alreadyMintedOnce) {
272             revert();
273         }
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
286             if (now - mintingStartTime > maxMintingTime) {
287                 mintingFinished = true;
288                 MintFinished();
289                 goalReached = (this.balance > mintingGoal);
290                 return true;
291             }
292         }
293         return false;
294     }
295 
296 	/**
297 	   * @dev Function refunds contributors if ICO was unsuccesful 
298 	   * @return bool True if conditions for refund are met false otherwise.
299 	   */
300     function refund() returns(bool) {
301         if (mintingFinished == true && goalReached == false && alreadyMintedOnce == true) {
302             uint valueOfAssets = this.balance.mul(balances[msg.sender]).div(totalSupply.sub(balances[owner]));
303             totalSupply = totalSupply.sub(balances[msg.sender]);
304             balances[msg.sender] = 0;
305             msg.sender.transfer(valueOfAssets);
306 			return true;
307         }
308 		return false;
309     }
310  
311  
312 	/**
313 	   * @dev Allows to remove buggy contract before ICO launch
314 	   */
315     function destroyUselessContract() onlyOwner notMintedYet {
316         selfdestruct(owner);
317     }
318 }
319 
320 contract TitsToken is MintableToken {
321     string public name = "Truth In The Sourcecode";
322     string public symbol = "TITS";
323     uint public decimals = 18;
324     uint public voitingStartTime;
325     address public votedAddress;
326     uint public votedYes = 1;
327     uint public votedNo = 0;
328     event VoteOnTransfer(address indexed beneficiaryContract);
329     event RogisterToVoteOnTransfer(address indexed beneficiaryContract);
330     event VotingEnded(address indexed beneficiaryContract, bool result);
331 
332     uint public constant VOTING_PREPARE_TIMESPAN = 7 days;
333     uint public constant VOTING_TIMESPAN =  7 days;
334     uint public failedVotingCount = 0;
335     bool public isVoting = false;
336     bool public isVotingPrepare = false;
337 
338     address public beneficiaryContract = 0;
339 
340     mapping(address => uint256) votesAvailable;
341     address[] public voters;
342     uint votersCount = 0;
343 
344 	/**
345 	   * @dev voting long enought to go to next phase 
346 	   */
347     modifier votingLong() {
348         if (now - voitingStartTime < VOTING_TIMESPAN) revert();
349         _;
350     }
351 
352 	/**
353 	   * @dev preparation for voting (application for voting) long enought to go to next phase 
354 	   */
355     modifier votingPrepareLong() {
356         if (now - voitingStartTime < VOTING_PREPARE_TIMESPAN) revert();
357         _;
358     }
359 
360 	/**
361 	   * @dev Voting started and in progress
362 	   */
363     modifier votingInProgress() {
364         if (isVoting == false) revert();
365         _;
366     }
367 
368 	/**
369 	   * @dev Voting preparation started and in progress
370 	   */
371     modifier votingPrepareInProgress() {
372         if (isVotingPrepare == false) revert();
373         _;
374     }
375 
376 	/**
377 	   * @dev Voters agreed on proposed contract and Ethereum is being send to that contract
378 	   */
379     function sendToBeneficiaryContract()  {
380         if (beneficiaryContract != 0) {
381             beneficiaryContract.transfer(this.balance);
382         } else {
383             revert();
384         }
385     }
386 		
387 	/**
388 	   * @dev can be called by anyone, if timespan withou accepted proposal long enought 
389 	   * enables refund
390 	   */
391 	function registerVotingPrepareFailure() mintingClosed{
392 		if(now-mintingStartTime>(2+failedVotingCount)*maxMintingTime ){
393 			failedVotingCount=failedVotingCount+1;
394             if (failedVotingCount == 10) {
395                 goalReached = false;
396             }
397 		}
398 	}
399 
400 	/**
401 	   * @dev opens preparation for new voting on proposed Lottery Contract address
402 	   */
403     function startVotingPrepare(address votedAddressArg) mintingClosed onlyOwner{
404         isVoting = false;
405         RogisterToVoteOnTransfer(votedAddressArg);
406         votedAddress = votedAddressArg;
407         voitingStartTime = now;
408         isVotingPrepare = true;
409         for (uint i = 0; i < voters.length; i++) {
410             delete voters[i];
411         }
412         delete voters;
413         votersCount = 0;
414     }
415 
416 	/**
417 	   * @dev payable so attendance only of people who really care
418 	   * registers You as a voter;
419 	   */
420     function registerForVoting() payable votingPrepareInProgress {
421         if (msg.value >= 10 finney) {
422             voters.push(msg.sender);
423             votersCount = votersCount + 1;
424         }
425 		else{
426 			revert();
427 		}
428     }
429 
430 	/**
431 	   * @dev opens voting on proposed Lottery Contract address
432 	   */
433     function startVoting() votingPrepareInProgress votingPrepareLong {
434         VoteOnTransfer(votedAddress);
435         for (uint i = 0; i < votersCount; i++) {
436             votesAvailable[voters[i]] = balanceOf(voters[i]);
437         }
438         isVoting = true;
439         voitingStartTime = now;
440         isVotingPrepare = false;
441         votersCount = 0;
442     }
443 
444 	/**
445 	   * @dev closes voting on proposed Lottery Contract address
446 	   * checks if failed - if No votes is more common than yes increase failed voting count and if it reaches 10 
447 	   * reach of goal is failing and investors can withdraw their money
448 	   */
449     function closeVoring() votingInProgress votingLong {
450         VotingEnded(votedAddress, votedYes > votedNo);
451         isVoting = false;
452         isVotingPrepare = false;
453         if (votedYes > votedNo) {
454             beneficiaryContract = votedAddress;
455         } else {
456             failedVotingCount = failedVotingCount + 1;
457             if (failedVotingCount == 10) {
458                 goalReached = false;
459             }
460         }
461     }
462 
463 	/**
464 	   * @dev votes on contract proposal
465 	   * payable to ensure only serious voters will attend 
466 	   */
467     function vote(bool isVoteYes) payable {
468 
469         if (msg.value >= 10 finney) {
470             var votes = votesAvailable[msg.sender];
471             votesAvailable[msg.sender] = 0;
472             if (isVoteYes) {
473                 votedYes.add(votes);
474             } else {
475                 votedNo.add(votes);
476             }
477         }
478 		else{
479 			revert();
480 		}
481     }
482 }