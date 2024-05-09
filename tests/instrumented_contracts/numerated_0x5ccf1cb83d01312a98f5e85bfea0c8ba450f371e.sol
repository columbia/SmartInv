1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 
44 /**
45  * @title Destructible
46  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
47  */
48 contract Destructible is Ownable {
49 
50   function Destructible() public payable { }
51 
52   /**
53    * @dev Transfers the current balance to the owner and terminates the contract.
54    */
55   function destroy() onlyOwner public {
56     selfdestruct(owner);
57   }
58 
59   function destroyAndSend(address _recipient) onlyOwner public {
60     selfdestruct(_recipient);
61   }
62 }
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return c;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 contract BallerToken is Ownable, Destructible {
111     using SafeMath for uint;
112     /*** EVENTS ***/
113 
114     // @dev Fired whenever a new Baller token is created for the first time.
115     event BallerCreated(uint256 tokenId, string name, address owner);
116 
117     // @dev Fired whenever a new Baller Player token is created for first time
118     event BallerPlayerCreated(uint256 tokenId, string name, uint teamID, address owner);
119 
120     // @dev Fired whenever a Baller token is sold.
121     event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwner, string name);
122 
123     // @dev Fired whenever a team is transfered from one owner to another
124     event Transfer(address from, address to, uint256 tokenId);
125 
126     /*** CONSTANTS ***/
127 
128     uint constant private DEFAULT_START_PRICE = 0.01 ether;
129     uint constant private FIRST_PRICE_LIMIT =  0.5 ether;
130     uint constant private SECOND_PRICE_LIMIT =  2 ether;
131     uint constant private THIRD_PRICE_LIMIT =  5 ether;
132     uint constant private FIRST_COMMISSION_LEVEL = 5;
133     uint constant private SECOND_COMMISSION_LEVEL = 4;
134     uint constant private THIRD_COMMISSION_LEVEL = 3;
135     uint constant private FOURTH_COMMISSION_LEVEL = 2;
136     uint constant private FIRST_LEVEL_INCREASE = 200;
137     uint constant private SECOND_LEVEL_INCREASE = 135;
138     uint constant private THIRD_LEVEL_INCREASE = 125;
139     uint constant private FOURTH_LEVEL_INCREASE = 115;
140 
141     /*** STORAGE ***/
142 
143     // @dev maps team id to address of who owns it
144     mapping (uint => address) private teamIndexToOwner;
145 
146     // @dev maps team id to a price
147     mapping (uint => uint) private teamIndexToPrice;
148 
149     // @dev maps address to how many tokens they own
150     mapping (address => uint) private ownershipTokenCount;
151 
152 
153     // @dev maps player id to address of who owns it
154     mapping (uint => address) public playerIndexToOwner;
155 
156     // @dev maps player id to a price
157     mapping (uint => uint) private playerIndexToPrice;
158 
159     // @dev maps address to how many players they own
160     mapping (address => uint) private playerOwnershipTokenCount;
161 
162 
163     /*** DATATYPES ***/
164     //@dev struct for a baller team
165     struct Team {
166         string name;
167     }
168 
169     //@dev struct for a baller player
170     struct Player {
171         string name;
172         uint teamID;
173     }
174 
175     //@dev array which holds each team
176     Team[] private ballerTeams;
177 
178     //@dev array which holds each baller
179     Player[] private ballerPlayers;
180 
181     /*** PUBLIC FUNCTIONS ***/
182 
183     /**
184     * @dev public function to create team, can only be called by owner of smart contract
185     * @param _name the name of the team
186     * @param _price the price of the team when created
187     */
188 
189     function createTeam(string _name, uint _price) public onlyOwner {
190         _createTeam(_name, this, _price);
191     }
192 
193     /**
194     * @dev public function to create a promotion team and assign it to some address
195     * @param _name the name of the team
196     * @param _owner the owner of the team when created
197     * @param _price the price of the team when created
198     */
199     function createPromoTeam(string _name, address _owner, uint _price) public onlyOwner {
200         _createTeam(_name, _owner, _price);
201     }
202 
203 
204     /**
205     * @dev public function to create a player, can only be called by owner of smart contract
206     * @param _name the name of the player
207     * @param _teamID the id of the team the player belongs to
208     * @param _price the price of the player when created
209     */
210     function createPlayer(string _name, uint _teamID, uint _price) public onlyOwner {
211         _createPlayer(_name, _teamID, this, _price);
212     }
213 
214     /**
215     * @dev Returns all the relevant information about a specific team.
216     * @param _tokenId The ID of the team.
217     * @return teamName the name of the team.
218     * @return currPrice what the team is currently worth.
219     * @return owner address of whoever owns the team
220     */
221     function getTeam(uint _tokenId) public view returns(string teamName, uint currPrice, address owner) {
222         Team storage currTeam = ballerTeams[_tokenId];
223         teamName = currTeam.name;
224         currPrice = teamIndexToPrice[_tokenId];
225         owner = ownerOf(_tokenId);
226     }
227 
228     /**
229     * @dev Returns all relevant info about a specific player.
230     * @return playerName the name of the player
231     * @return currPrice what the player is currently worth.
232     * @return owner address of whoever owns the player.
233     * @return owningTeamID ID of team that the player plays on.
234     */
235     function getPlayer(uint _tokenId) public view returns(string playerName, uint currPrice, address owner, uint owningTeamID) {
236         Player storage currPlayer = ballerPlayers[_tokenId];
237         playerName = currPlayer.name;
238         currPrice = playerIndexToPrice[_tokenId];
239         owner = ownerOfPlayer(_tokenId);
240         owningTeamID = currPlayer.teamID;
241     }
242 
243     /**
244     * @dev changes the name of a specific team.
245     * @param _tokenId The id of the team which you want to change.
246     * @param _newName The name you want to set the team to be.
247     */
248     function changeTeamName(uint _tokenId, string _newName) public onlyOwner {
249         require(_tokenId < ballerTeams.length && _tokenId >= 0);
250         ballerTeams[_tokenId].name = _newName;
251     }
252 
253     /**
254     * @dev changes name of a player.
255     * @param _tokenId the id of the player which you want to change.
256     * @param _newName the name you want to set the player to be.
257     */
258     function changePlayerName(uint _tokenId, string _newName) public onlyOwner {
259         require(_tokenId < ballerPlayers.length && _tokenId >= 0);
260         ballerPlayers[_tokenId].name = _newName;
261     }
262 
263     /**
264     * @dev changes the team the player is own
265     * @param _tokenId the id of the player which you want to change.
266     * @param _newTeamId the team the player will now be on.
267     */
268 
269     function changePlayerTeam(uint _tokenId, uint _newTeamId) public onlyOwner {
270         require(_newTeamId < ballerPlayers.length && _newTeamId >= 0);
271         ballerPlayers[_tokenId].teamID = _newTeamId;
272     }
273 
274     /**
275     * @dev sends all ethereum in this contract to the address specified
276     * @param _to address you want the eth to be sent to
277     */
278 
279     function payout(address _to) public onlyOwner {
280       _withdrawAmount(_to, this.balance);
281     }
282 
283     /**
284     * @dev Function to send some amount of ethereum out of the contract to an address
285     * @param _to address the eth will be sent to
286     * @param _amount amount you want to withdraw
287     */
288     function withdrawAmount(address _to, uint _amount) public onlyOwner {
289       _withdrawAmount(_to, _amount);
290     }
291 
292     /**
293     * @dev Function to get price of a team
294     * @param _teamId of team
295     * @return price price of team
296     */
297     function priceOfTeam(uint _teamId) public view returns (uint price) {
298       price = teamIndexToPrice[_teamId];
299     }
300 
301     /**
302     * @dev Function to get price of a player
303     * @param _playerID id of player
304     * @return price price of player
305     */
306 
307     function priceOfPlayer(uint _playerID) public view returns (uint price) {
308         price = playerIndexToPrice[_playerID];
309     }
310 
311     /**
312     * @dev Gets list of teams owned by a person.
313     * @dev note: don't want to call this in the smart contract, expensive op.
314     * @param _owner address of the owner
315     * @return ownedTeams list of the teams owned by the owner
316     */
317     function getTeamsOfOwner(address _owner) public view returns (uint[] ownedTeams) {
318       uint tokenCount = balanceOf(_owner);
319       ownedTeams = new uint[](tokenCount);
320       uint totalTeams = totalSupply();
321       uint resultIndex = 0;
322       if (tokenCount != 0) {
323         for (uint pos = 0; pos < totalTeams; pos++) {
324           address currOwner = ownerOf(pos);
325           if (currOwner == _owner) {
326             ownedTeams[resultIndex] = pos;
327             resultIndex++;
328           }
329         }
330       }
331     }
332 
333 
334     /**
335     * @dev Gets list of players owned by a person.
336     * @dev note: don't want to call this in smart contract, expensive op.
337     * @param _owner address of owner
338     * @return ownedPlayers list of all players owned by the address passed in
339     */
340 
341     function getPlayersOfOwner(address _owner) public view returns (uint[] ownedPlayers) {
342         uint numPlayersOwned = balanceOfPlayers(_owner);
343         ownedPlayers = new uint[](numPlayersOwned);
344         uint totalPlayers = totalPlayerSupply();
345         uint resultIndex = 0;
346         if (numPlayersOwned != 0) {
347             for (uint pos = 0; pos < totalPlayers; pos++) {
348                 address currOwner = ownerOfPlayer(pos);
349                 if (currOwner == _owner) {
350                     ownedPlayers[resultIndex] = pos;
351                     resultIndex++;
352                 }
353             }
354         }
355     }
356 
357     /*
358      * @dev gets the address of owner of the team
359      * @param _tokenId is id of the team
360      * @return owner the owner of the team's address
361     */
362     function ownerOf(uint _tokenId) public view returns (address owner) {
363       owner = teamIndexToOwner[_tokenId];
364       require(owner != address(0));
365     }
366 
367     /*
368      * @dev gets address of owner of player
369      * @param _playerId is id of the player
370      * @return owner the address of the owner of the player
371     */
372 
373     function ownerOfPlayer(uint _playerId) public view returns (address owner) {
374         owner = playerIndexToOwner[_playerId];
375         require(owner != address(0));
376     }
377 
378     function teamOwnerOfPlayer(uint _playerId) public view returns (address teamOwner) {
379         uint teamOwnerId = ballerPlayers[_playerId].teamID;
380         teamOwner = ownerOf(teamOwnerId);
381     }
382     /*
383      * @dev gets how many tokens an address owners
384      * @param _owner is address of owner
385      * @return numTeamsOwned how much teams he has
386     */
387 
388     function balanceOf(address _owner) public view returns (uint numTeamsOwned) {
389       numTeamsOwned = ownershipTokenCount[_owner];
390     }
391 
392     /*
393      * @dev gets how many players an owner owners
394      * @param _owner is address of owner
395      * @return numPlayersOwned how many players the owner has
396     */
397 
398     function balanceOfPlayers(address _owner) public view returns (uint numPlayersOwned) {
399         numPlayersOwned = playerOwnershipTokenCount[_owner];
400     }
401 
402     /*
403      * @dev gets total number of teams
404      * @return totalNumTeams which is the number of teams
405     */
406     function totalSupply() public view returns (uint totalNumTeams) {
407       totalNumTeams = ballerTeams.length;
408     }
409 
410     /*
411      * @dev gets total number of players
412      * @return totalNumPlayers is the number of players
413     */
414 
415     function totalPlayerSupply() public view returns (uint totalNumPlayers) {
416         totalNumPlayers = ballerPlayers.length;
417     }
418 
419     /**
420     * @dev Allows user to buy a team from the old owner.
421     * @dev Pays old owner minus commission, updates price.
422     * @param _teamId id of the team they're trying to buy
423     */
424     function purchase(uint _teamId) public payable {
425       address oldOwner = ownerOf(_teamId);
426       address newOwner = msg.sender;
427 
428       uint sellingPrice = teamIndexToPrice[_teamId];
429 
430       // Making sure token owner is not sending to self
431       require(oldOwner != newOwner);
432 
433       // Safety check to prevent against an unexpected 0x0 default.
434       require(_addressNotNull(newOwner));
435 
436       // Making sure sent amount is greater than or equal to the sellingPrice
437       require(msg.value >= sellingPrice);
438 
439       uint payment =  _calculatePaymentToOwner(sellingPrice, true);
440       uint excessPayment = msg.value.sub(sellingPrice);
441       uint newPrice = _calculateNewPrice(sellingPrice);
442       teamIndexToPrice[_teamId] = newPrice;
443 
444       _transfer(oldOwner, newOwner, _teamId);
445       // Pay old tokenOwner, unless it's the smart contract
446       if (oldOwner != address(this)) {
447         oldOwner.transfer(payment);
448       }
449 
450       newOwner.transfer(excessPayment);
451       string memory teamName = ballerTeams[_teamId].name;
452       TokenSold(_teamId, sellingPrice, newPrice, oldOwner, newOwner, teamName);
453     }
454 
455 
456     /**
457     * @dev allows user to buy a player from the old owner.
458     * @dev pays old owner minus commission, updates price.
459     * @dev commission includes house plus amount that goes to owner of team that player plays on
460     * @param _playerId the id of the player they're trying to buy.
461     */
462 
463     function purchasePlayer(uint _playerId) public payable {
464         address oldOwner = ownerOfPlayer(_playerId);
465         address newOwner = msg.sender;
466         address teamOwner = teamOwnerOfPlayer(_playerId);
467 
468         uint sellingPrice = playerIndexToPrice[_playerId];
469 
470         // Making sure token owner is not sending to self
471         require(oldOwner != newOwner);
472 
473         // Safety check to prevent against na unexpected 0x0 default
474         require(_addressNotNull(newOwner));
475 
476         //Making sure sent amount is greater than or equal to selling price
477         require(msg.value >= sellingPrice);
478 
479         bool sellingTeam = false;
480         uint payment = _calculatePaymentToOwner(sellingPrice, sellingTeam);
481         uint commission = msg.value.sub(payment);
482         uint teamOwnerCommission = commission.div(2);
483         uint excessPayment = msg.value.sub(sellingPrice);
484         uint newPrice = _calculateNewPrice(sellingPrice);
485         playerIndexToPrice[_playerId] = newPrice;
486 
487         _transferPlayer(oldOwner, newOwner, _playerId);
488 
489         // pay old token owner
490         if (oldOwner != address(this)) {
491             oldOwner.transfer(payment);
492         }
493 
494         // pay team owner
495         if (teamOwner != address(this)) {
496             teamOwner.transfer(teamOwnerCommission);
497         }
498 
499         newOwner.transfer(excessPayment);
500         string memory playerName = ballerPlayers[_playerId].name;
501         TokenSold(_playerId, sellingPrice, newPrice, oldOwner, newOwner, playerName);
502     }
503 
504 
505     /// Safety check on _to address to prevent against an unexpected 0x0 default.
506     function _addressNotNull(address _to) private pure returns (bool) {
507       return _to != address(0);
508     }
509 
510     /**
511     * @dev Internal function to send some amount of ethereum out of the contract to an address
512     * @param _to address the eth will be sent to
513     * @param _amount amount you want to withdraw
514     */
515     function _withdrawAmount(address _to, uint _amount) private {
516       require(this.balance >= _amount);
517       if (_to == address(0)) {
518         owner.transfer(_amount);
519       } else {
520         _to.transfer(_amount);
521       }
522     }
523 
524     /**
525     * @dev internal function to create team
526     * @param _name the name of the team
527     * @param _owner the owner of the team
528     * @param _startingPrice the price of the team at the beginning
529     */
530     function _createTeam(string _name, address _owner, uint _startingPrice) private {
531       Team memory currTeam = Team(_name);
532       uint newTeamId = ballerTeams.push(currTeam) - 1;
533 
534       // make sure we never overflow amount of tokens possible to be created
535       // 4 billion tokens...shouldn't happen.
536       require(newTeamId == uint256(uint32(newTeamId)));
537 
538       BallerCreated(newTeamId, _name, _owner);
539       teamIndexToPrice[newTeamId] = _startingPrice;
540       _transfer(address(0), _owner, newTeamId);
541     }
542 
543     /**
544     * @dev internal function to create player
545     * @param _name the name of the player
546     * @param _teamID the id of the team the player plays on
547     * @param _owner the owner of the player
548     * @param _startingPrice the price of the player at creation
549     */
550 
551     function _createPlayer(string _name, uint _teamID, address _owner, uint _startingPrice) private {
552         Player memory currPlayer = Player(_name, _teamID);
553         uint newPlayerId = ballerPlayers.push(currPlayer) - 1;
554 
555         // make sure we never overflow amount of tokens possible to be created
556         // 4 billion players, shouldn't happen
557         require(newPlayerId == uint256(uint32(newPlayerId)));
558         BallerPlayerCreated(newPlayerId, _name, _teamID, _owner);
559         playerIndexToPrice[newPlayerId] = _startingPrice;
560         _transferPlayer(address(0), _owner, newPlayerId);
561     }
562 
563     /**
564     * @dev internal function to transfer ownership of team
565     * @param _from original owner of token
566     * @param _to the new owner
567     * @param _teamId id of the team
568     */
569     function _transfer(address _from, address _to, uint _teamId) private {
570       ownershipTokenCount[_to]++;
571       teamIndexToOwner[_teamId] = _to;
572 
573       // Creation of new team causes _from to be 0
574       if (_from != address(0)) {
575         ownershipTokenCount[_from]--;
576       }
577 
578       Transfer(_from, _to, _teamId);
579     }
580 
581 
582     /**
583     * @dev internal function to transfer ownership of player
584     * @param _from original owner of token
585     * @param _to the new owner
586     * @param _playerId the id of the player
587     */
588 
589     function _transferPlayer(address _from, address _to, uint _playerId) private {
590         playerOwnershipTokenCount[_to]++;
591         playerIndexToOwner[_playerId] = _to;
592 
593         // creation of new player causes _from to be 0
594         if (_from != address(0)) {
595             playerOwnershipTokenCount[_from]--;
596         }
597 
598         Transfer(_from, _to, _playerId);
599     }
600 
601     /**
602     * @dev internal function to calculate how much to give to owner of contract
603     * @param _sellingPrice the current price of the team
604     * @param _sellingTeam if you're selling a team or a player
605     * @return payment amount the owner gets after commission.
606     */
607     function _calculatePaymentToOwner(uint _sellingPrice, bool _sellingTeam) private pure returns (uint payment) {
608       uint multiplier = 1;
609       if (! _sellingTeam) {
610           multiplier = 2;
611       }
612       uint commissionAmount = 100;
613       if (_sellingPrice < FIRST_PRICE_LIMIT) {
614         commissionAmount = commissionAmount.sub(FIRST_COMMISSION_LEVEL.mul(multiplier));
615         payment = uint256(_sellingPrice.mul(commissionAmount).div(100));
616       }
617       else if (_sellingPrice < SECOND_PRICE_LIMIT) {
618         commissionAmount = commissionAmount.sub(SECOND_COMMISSION_LEVEL.mul(multiplier));
619 
620         payment = uint256(_sellingPrice.mul(commissionAmount).div(100));
621       }
622       else if (_sellingPrice < THIRD_PRICE_LIMIT) {
623         commissionAmount = commissionAmount.sub(THIRD_COMMISSION_LEVEL.mul(multiplier));
624 
625         payment = uint256(_sellingPrice.mul(commissionAmount).div(100));
626       }
627       else {
628         commissionAmount = commissionAmount.sub(FOURTH_COMMISSION_LEVEL.mul(multiplier));
629         payment = uint256(_sellingPrice.mul(commissionAmount).div(100));
630       }
631     }
632 
633     /**
634     * @dev internal function to calculate how much the new price is
635     * @param _sellingPrice the current price of the team.
636     * @return newPrice price the team will be worth after being bought.
637     */
638     function _calculateNewPrice(uint _sellingPrice) private pure returns (uint newPrice) {
639       if (_sellingPrice < FIRST_PRICE_LIMIT) {
640         newPrice = uint256(_sellingPrice.mul(FIRST_LEVEL_INCREASE).div(100));
641       }
642       else if (_sellingPrice < SECOND_PRICE_LIMIT) {
643         newPrice = uint256(_sellingPrice.mul(SECOND_LEVEL_INCREASE).div(100));
644       }
645       else if (_sellingPrice < THIRD_PRICE_LIMIT) {
646         newPrice = uint256(_sellingPrice.mul(THIRD_LEVEL_INCREASE).div(100));
647       }
648       else {
649         newPrice = uint256(_sellingPrice.mul(FOURTH_LEVEL_INCREASE).div(100));
650       }
651     }
652 }