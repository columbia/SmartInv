1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
11   */
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17   /**
18   * @dev Adds two numbers, throws on overflow.
19   */
20     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 
28 /**
29  * @title ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/20
31  */
32 contract ERC20 {
33     function allowance(address owner, address spender) public view returns (uint256);
34     function transferFrom(address from, address to, uint256 value) public returns (bool);
35     function approve(address spender, uint256 value) public returns (bool);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38     function totalSupply() public view returns (uint256);
39     function balanceOf(address who) public view returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 /**
45  * @title Standard ERC20 token
46  *
47  * @dev Implementation of the basic standard token.
48  * @dev https://github.com/ethereum/EIPs/issues/20
49  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
50  */
51 contract StandardToken is ERC20 {
52 
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) balances;
56 
57     uint256 totalSupply_;
58     mapping (address => mapping (address => uint256)) internal allowed;
59 
60 
61   /**
62    * @dev Transfer tokens from one address to another
63    * @param _from address The address which you want to send tokens from
64    * @param _to address The address which you want to transfer to
65    * @param _value uint256 the amount of tokens to be transferred
66    */
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         require(_value <= balances[_from]);
70         require(_value <= allowed[_from][msg.sender]);
71 
72         balances[_from] = balances[_from].sub(_value);
73         balances[_to] = balances[_to].add(_value);
74         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
75         emit Transfer(_from, _to, _value);
76         return true;
77     }
78 
79   /**
80    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
81    *
82    * Beware that changing an allowance with this method brings the risk that someone may use both the old
83    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
84    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
85    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86    * @param _spender The address which will spend the funds.
87    * @param _value The amount of tokens to be spent.
88    */
89     function approve(address _spender, uint256 _value) public returns (bool) {
90         allowed[msg.sender][_spender] = _value;
91         emit Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95   /**
96    * @dev Function to check the amount of tokens that an owner allowed to a spender.
97    * @param _owner address The address which owns the funds.
98    * @param _spender address The address which will spend the funds.
99    * @return A uint256 specifying the amount of tokens still available for the spender.
100    */
101     function allowance(address _owner, address _spender) public view returns (uint256) {
102         return allowed[_owner][_spender];
103     }
104 
105   /**
106    * @dev Increase the amount of tokens that an owner allowed to a spender.
107    *
108    * approve should be called when allowed[_spender] == 0. To increment
109    * allowed value is better to use this function to avoid 2 calls (and wait until
110    * the first transaction is mined)
111    * From MonolithDAO Token.sol
112    * @param _spender The address which will spend the funds.
113    * @param _addedValue The amount of tokens to increase the allowance by.
114    */
115     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
116         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
117         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118         return true;
119     }
120 
121   /**
122    * @dev Decrease the amount of tokens that an owner allowed to a spender.
123    *
124    * approve should be called when allowed[_spender] == 0. To decrement
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    * @param _spender The address which will spend the funds.
129    * @param _subtractedValue The amount of tokens to decrease the allowance by.
130    */
131     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
132         uint oldValue = allowed[msg.sender][_spender];
133         if (_subtractedValue > oldValue) {
134             allowed[msg.sender][_spender] = 0;
135         } else {
136             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137         }
138         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139         return true;
140     }
141 
142      /**
143   * @dev total number of tokens in existence
144   */
145     function totalSupply() public view returns (uint256) {
146         return totalSupply_;
147     }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154     function transfer(address _to, uint256 _value) public returns (bool) {
155         require(_to != address(0));
156         require(_value <= balances[msg.sender]);
157 
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         emit Transfer(msg.sender, _to, _value);
161         return true;
162     }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170         return balances[_owner];
171     }
172 
173 }
174 
175 contract RotoToken is StandardToken {
176 
177     string public constant name = "Roto"; // token name
178     string public constant symbol = "ROTO"; // token symbol
179     uint8 public constant decimals = 18; // token decimal
180 
181     uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(decimals));
182     address owner;
183     address roto = this;
184     address manager;
185 
186     // keeps track of the ROTO currently staked in a tournament
187     // the format is user address -> the tournament they staked in -> how much they staked
188     mapping (address => mapping (bytes32 => uint256)) stakes;
189     uint256 owner_transfer = 2000000 * (10** uint256(decimals));
190   /**
191    * @dev Constructor that gives msg.sender all of existing tokens.
192    */
193 
194     modifier onlyOwner {
195         require(msg.sender==owner);
196         _;
197     }
198 
199     modifier onlyManager {
200       require(msg.sender==manager);
201       _;
202     }
203 
204     event ManagerChanged(address _contract);
205     event RotoStaked(address _user, uint256 stake);
206     event RotoReleased(address _user, uint256 stake);
207     event RotoDestroyed(address _user, uint256 stake);
208     event RotoRewarded(address _contract, address _user, uint256 reward);
209 
210     constructor() public {
211         owner = msg.sender;
212         totalSupply_ = INITIAL_SUPPLY;
213         balances[roto] = INITIAL_SUPPLY;
214         emit Transfer(0x0, roto, INITIAL_SUPPLY);
215     }
216 
217     
218     /**
219      *  @dev A function that can only be called by RotoHive, transfers Roto Tokens out of the contract.
220         @param _to address, the address that the ROTO will be transferred to
221         @param _value ROTO, amount to transfer
222         @return - whether the Roto was transferred succesfully
223      */
224     function transferFromContract(address _to, uint256 _value) public onlyOwner returns(bool) {
225         require(_to!=address(0));
226         require(_value<=balances[roto]);
227         require(owner_transfer > 0);
228 
229         owner_transfer = owner_transfer.sub(_value);
230         
231         balances[roto] = balances[roto].sub(_value);
232         balances[_to] = balances[_to].add(_value);
233 
234         emit Transfer(roto, _to, _value);
235         return true;
236     }
237 
238     /**
239         @dev updates the helper contract(which will manage the tournament) with the new version
240         @param _contract address, the address of the manager contract
241         @return - whether the contract was successfully set
242     */
243     function setManagerContract(address _contract) external onlyOwner returns(bool) {
244       //checks that the address sent isn't the 0 address, the owner or the token contract
245       require(_contract!=address(0)&&_contract!=roto);
246 
247       // requires that the address sent be a contract
248       uint size;
249       assembly { size := extcodesize(_contract) }
250       require(size > 0);
251 
252       manager = _contract;
253 
254       emit ManagerChanged(_contract);
255       return true;
256     }
257 
258     /**
259         @dev - called by the manager contract to add back to the user their roto in the event that their submission was successful
260         @param  _user address, the address of the user who submitted the rankings
261         @param _tournamentID identifier
262         @return boolean value, whether the roto were successfully released
263     */
264     function releaseRoto(address _user, bytes32 _tournamentID) external onlyManager returns(bool) {
265         require(_user!=address(0));
266         uint256 value = stakes[_user][_tournamentID];
267         require(value > 0);
268 
269         stakes[_user][_tournamentID] = 0;
270         balances[_user] = balances[_user].add(value);
271 
272         emit RotoReleased(_user, value);
273         return true;
274     }
275 
276     /**
277         @dev - function called by manager contract to process the accounting aspects of the destroyRoto function
278         @param  _user address, the address of the user who's stake will be destroyed
279         @param _tournamentID identifier
280         @return - a boolean value that reflects whether the roto were successfully destroyed
281     */
282     function destroyRoto(address _user, bytes32 _tournamentID) external onlyManager returns(bool) {
283         require(_user!=address(0));
284         uint256 value = stakes[_user][_tournamentID];
285         require(value > 0);
286 
287         stakes[_user][_tournamentID] = 0;
288         balances[roto] = balances[roto].add(value);
289 
290         emit RotoDestroyed(_user, value);
291         return true;
292     }
293 
294     /**
295         @dev - called by the manager contract, runs the accounting portions of the staking process
296         @param  _user address, the address of the user staking ROTO
297         @param _tournamentID identifier
298         @param _value ROTO, the amount the user is staking
299         @return - whether the staking process went successfully
300     */
301     function stakeRoto(address _user, bytes32 _tournamentID, uint256 _value) external onlyManager returns(bool) {
302         require(_user!=address(0));
303         require(_value<=balances[_user]);
304         require(stakes[_user][_tournamentID] == 0);
305 
306         balances[_user] = balances[_user].sub(_value);
307         stakes[_user][_tournamentID] = _value;
308 
309         emit RotoStaked(_user, _value);
310         return true;
311     }
312     
313     /**
314       @dev - called by the manager contract, used to reward non-staked submissions by users
315       @param _user address, the address that will receive the rewarded ROTO
316       @param _value ROTO, the amount of ROTO that they'll be rewarded
317      */
318     function rewardRoto(address _user, uint256 _value) external onlyManager returns(bool successful) {
319       require(_user!=address(0));
320       require(_value<=balances[roto]);
321 
322       balances[_user] = balances[_user].add(_value);
323       balances[roto] = balances[roto].sub(_value);
324 
325       emit Transfer(roto, _user, _value);
326       return true;
327     }
328     /**
329         @dev - to be called by the manager contract to check if a given user has enough roto to
330             stake the given amount
331         @param  _user address, the address of the user who's attempting to stake ROTO
332         @param _value ROTO, the amount they are attempting to stake
333         @return - whether the user has enough balance to stake the received amount
334     */
335     function canStake(address _user, uint256 _value) public view onlyManager returns(bool) {
336       require(_user!=address(0));
337       require(_value<=balances[_user]);
338 
339       return true;
340     }
341 
342     /**
343       @dev Getter function for manager
344      */
345     function getManager() public view returns (address _manager) {
346       return manager;
347     }
348 
349     /**
350       @dev - sets the owner address to a new one
351       @param  _newOwner address
352       @return - true if the address was changed successful
353      */
354     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
355       owner = _newOwner;
356     }
357 }
358 
359 contract RotoBasic {
360 
361     mapping (bytes32 => Tournament) public tournaments;  // tournamentID
362     
363     //Instance and Address of the RotoToken contract
364     RotoToken token;
365     address roto;
366 
367     //Address of the contract owner the manager contract(this contract)
368     address owner;
369     address manager;
370 
371     //boolean variable that determines whether there's an emergency state
372     bool emergency;
373 
374     struct Tournament {
375         bool open;
376         // the total ether prize and how much is left
377         uint256 etherPrize;
378         uint256 etherLeft;
379         // the total roto prize how much is left
380         uint256 rotoPrize;
381         uint256 rotoLeft;
382         // tournament details
383         uint256 creationTime;
384         mapping (address => mapping (bytes32 => Stake)) stakes;  // address of staker, to tournament ID points to a specific stake
385         //counters to easily tell the # of stakes vs # of stakes resolved
386         uint256 userStakes;
387         uint256 stakesResolved;
388     }
389 
390     struct Stake {
391         uint256 amount; // Once the stake is resolved, this becomes 0
392         bool successful;
393         bool resolved;
394     }
395 
396     modifier onlyOwner {
397       require(msg.sender==owner);
398       _;
399     }
400 
401     modifier stopInEmergency {
402       require(emergency==false);
403       _;
404     }
405 
406     //Tournament Creation and Processing Events
407     event StakeProcessed(address indexed staker, uint256 totalAmountStaked, bytes32 indexed tournamentID);
408     event StakeDestroyed(bytes32 indexed tournamentID, address indexed stakerAddress, uint256 rotoLost);
409     event StakeReleased(bytes32 indexed tournamentID, address indexed stakerAddress, uint256 etherReward, uint256 rotoStaked);
410     event SubmissionRewarded(bytes32 indexed tournamentID, address indexed stakerAddress, uint256 rotoReward);
411     
412     event TokenChanged(address _contract);
413     event TournamentCreated(bytes32 indexed tournamentID, uint256 etherPrize, uint256 rotoPrize);
414     event TournamentClosed(bytes32 indexed tournamentID);
415 
416     /**
417        @dev - sets the token contract to used for the token accounting
418        @param _contract address, the address of the token contract
419        @return - true if the token contract was set successfully
420     */
421     function setTokenContract(address _contract) public onlyOwner returns(bool) {
422       require(_contract!=address(0)&&_contract!=manager);
423 
424       // requires that the address sent be a contract
425       uint size;
426       assembly { size := extcodesize(_contract) }
427       require(size > 0);
428 
429       roto = _contract;
430       token = RotoToken(roto);
431 
432       emit TokenChanged(_contract);
433       return true;
434     }
435 
436     /**
437         @dev - sets the state of the emegency variable to true, preventing any of the tournament processes to run
438         @param _emergency boolean variable to set emergency to
439         @return - true if the variable was changed successfully
440     */
441     function setEmergency(bool _emergency) public onlyOwner returns(bool) {
442       emergency = _emergency;
443       return true;
444     }
445 
446     /**
447       @dev - sets the owner address to a new one
448       @param  _newOwner address
449       @return - true if the address was changed successful
450      */
451     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
452       owner = _newOwner;
453     }
454 
455 }
456 
457 contract RotoManager is RotoBasic {
458 
459     using SafeMath for uint256;
460 
461     constructor() public {
462       owner = msg.sender;
463       emergency = false;
464       manager = this;
465     }
466 
467     /**
468         @dev - In the event that their submissions were successful, this function will return the tokens to the user, and distribute ether rewards were applicable
469         @param _user The user's address, the ether the've won,
470         @return - returns whether the Roto was sucessfully transferred
471      */
472     function releaseRoto(address _user, bytes32 _tournamentID, uint256 _etherReward) external onlyOwner stopInEmergency returns(bool successful){
473         Tournament storage tournament = tournaments[_tournamentID];
474         require(tournament.open==true);
475 
476         Stake storage user_stake = tournament.stakes[_user][_tournamentID];
477         uint256 initial_stake = user_stake.amount;
478 
479         // prelimiary checks 
480         require(initial_stake > 0);
481         require(user_stake.resolved == false);
482 
483         // ether balance rewards
484         require(manager.balance > _etherReward);
485         require(tournament.etherLeft >= _etherReward);
486 
487         //Redistributes roto back to the user, and marks the stake as successful and completed
488         user_stake.amount = 0;
489         assert(token.releaseRoto(_user, _tournamentID)); // calls the token contract releaseRoto function to handle the token accounting
490         tournament.stakesResolved = tournament.stakesResolved.add(1);
491         
492         user_stake.resolved = true;
493         user_stake.successful = true;
494 
495         if(_etherReward > 0) {
496           tournament.etherLeft = tournament.etherLeft.sub(_etherReward);
497           _user.transfer(_etherReward);
498         }
499 
500         emit StakeReleased(_tournamentID, _user, _etherReward, initial_stake);
501         
502         return true;
503     }
504     /**
505         @dev - If the user did not stake ROTO, but they still had a successful submission, then RotoHive will reward the user with an amount of ROTO respective to their performance.
506         @param _user address, which the ROTO will be sent to
507         @param _rotoReward amount of ROTO that the user has won
508         @return - a boolean value determining whether the operation was successful
509     
510      */
511     function rewardRoto(address _user, bytes32 _tournamentID, uint256 _rotoReward) external onlyOwner stopInEmergency returns(bool successful) {
512       Tournament storage tournament = tournaments[_tournamentID];
513       require(tournament.open==true);
514 
515       Stake storage user_stake = tournament.stakes[_user][_tournamentID];
516       uint256 initial_stake = user_stake.amount;
517       
518       require(initial_stake==0);
519       require(tournament.rotoLeft >= _rotoReward);
520       require(user_stake.resolved == false);
521 
522       tournament.rotoLeft = tournament.rotoLeft.sub(_rotoReward);
523       assert(token.rewardRoto(_user, _rotoReward));
524 
525       user_stake.resolved = true;
526       user_stake.successful = true;
527 
528       emit SubmissionRewarded(_tournamentID, _user, _rotoReward);
529 
530       return true;
531     }
532 
533     /**
534         @dev - For unsuccessful submission, the Roto will initially sent back to the contract.
535         @param _user address, the address of the user who's stake was unsuccessful
536         @param _tournamentID 32byte hex, the tournament which the stake belongs to
537         @return - whether the roto was successfully destroyed
538      */
539     function destroyRoto(address _user, bytes32 _tournamentID) external onlyOwner stopInEmergency returns(bool successful) {
540         Tournament storage tournament = tournaments[_tournamentID];
541         require(tournament.open==true);
542 
543         Stake storage user_stake = tournament.stakes[_user][_tournamentID];
544 
545         uint256 initial_stake = user_stake.amount;
546 
547         require(initial_stake > 0);
548         require(user_stake.resolved == false);
549 
550         user_stake.amount = 0;
551         user_stake.resolved = true;
552         user_stake.successful = false;
553 
554         assert(token.destroyRoto(_user, _tournamentID));
555         tournament.stakesResolved = tournament.stakesResolved.add(1);
556 
557         emit StakeDestroyed(_tournamentID, _user, initial_stake);
558 
559         return true;
560     }
561 
562     /**
563         @dev - The public method which will allow user's to stake their Roto alongside their submissions
564         @param _value the amount of Roto being staked, the id of that stake, and the id of the tournament
565         @return - whether the staking request was successful
566      */
567     function stake(uint256 _value, bytes32 _tournamentID) external stopInEmergency returns(bool successful) {
568         return _stake(msg.sender, _tournamentID, _value);
569     }
570 
571     /**
572         @dev - The internal method to process the request to stake Roto as a part of the Tournament Submission
573         @param _staker the user who's staking roto, the ID of the tournament, the amount of roto the user's staking, the staking tag
574         @return - whether the withdraw operation was successful
575      */
576     function _stake(address _staker, bytes32 _tournamentID, uint256 _value) internal returns(bool successful) {
577         Tournament storage tournament = tournaments[_tournamentID];
578 
579         //The User can't submit after tournament closure and the tournament must have begun
580         require((tournament.open==true));
581         require(tournament.etherPrize>0);
582         
583         Stake storage user_stake = tournament.stakes[_staker][_tournamentID];
584         
585         require(user_stake.amount==0); // Users can only stake once
586         require(_value>0); // Users must stake at least 1 ROTO
587         require(_staker != roto && _staker != owner); //RotoHive can't stake in tournament
588         
589         //Users must have the necessary balances to submit their stake
590         assert(token.canStake(_staker, _value));
591 
592         user_stake.amount = _value;
593         assert(token.stakeRoto(_staker,_tournamentID,_value));
594 
595         // adds the stake the submission
596         tournament.userStakes = tournament.userStakes.add(1);
597 
598         emit StakeProcessed(_staker, user_stake.amount, _tournamentID);
599 
600         return true;
601     }
602 
603     /**
604         @dev - Allows RotoHive to create this week's RotoHive Tournament
605         @param _tournamentID 32byte hex, the ID which RotoHive uses to reference each tournament
606         @param _etherPrize Eth, the total ether prize pool for the tournament
607         @param _rotoPrize ROTO, the total ROTO prize pool for the tournament
608         @return - whether the tournament was successfully created
609      */
610     function createTournament(bytes32 _tournamentID, uint256 _etherPrize, uint256 _rotoPrize) external payable onlyOwner returns(bool successful) {
611         Tournament storage newTournament = tournaments[_tournamentID];
612         require(newTournament.creationTime==0);
613         
614         newTournament.open = true;
615         newTournament.etherPrize = _etherPrize;
616         newTournament.etherLeft = _etherPrize;
617 
618         newTournament.rotoPrize = _rotoPrize;
619         newTournament.rotoLeft = _rotoPrize;
620         newTournament.creationTime = block.timestamp;
621 
622         emit TournamentCreated(_tournamentID, _etherPrize, _rotoPrize);
623 
624         return true;
625     }
626 
627     /**
628       @dev - closes the current tournament after the submission deadline has passed
629       @param _tournamentID the tournament ID
630       @return - returns whether the tournament was closed successfully
631     */
632     function closeTournament(bytes32 _tournamentID) external onlyOwner returns(bool successful) {
633        Tournament storage tournament = tournaments[_tournamentID];
634       //  the tournament should be open
635        require(tournament.open==true);
636 
637        //  all the prizes should have been given out
638        require(tournament.rotoLeft == 0 && tournament.etherLeft == 0);
639       //  all the users stakes should have been resolved
640        require(tournament.userStakes == tournament.stakesResolved);
641        tournament.open = false;
642 
643        emit TournamentClosed(_tournamentID);
644        return true;
645     }
646 }