1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two numbers, throws on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     /**
17     * @dev Integer division of two numbers, truncating the quotient.
18     */
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     /**
27     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28     */
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         assert(b <= a);
31         return a - b;
32     }
33 
34     /**
35     * @dev Adds two numbers, throws on overflow.
36     */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 contract ERC721 {
45   // Required methods
46   function approve(address _to, uint256 _tokenId) public;
47   function balanceOf(address _owner) public view returns (uint256 balance);
48   function implementsERC721() public pure returns (bool);
49   function ownerOf(uint256 _tokenId) public view returns (address addr);
50   function takeOwnership(uint256 _tokenId) public;
51   function totalSupply() public view returns (uint256 total);
52   function transferFrom(address _from, address _to, uint256 _tokenId) public;
53   function transfer(address _to, uint256 _tokenId) public;
54 
55   event Transfer(address indexed from, address indexed to, uint256 tokenId);
56   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
57 }
58 
59 contract CryptoCupToken is ERC721 {
60 
61     // evsoftware.co.uk
62     // cryptocup.online
63 
64     /*****------ EVENTS -----*****/
65     event TeamSold(uint256 indexed team, address indexed from, uint256 oldPrice, address indexed to, uint256 newPrice, uint256 tradingTime, uint256 balance, uint256 lastSixteenPrize, uint256 quarterFinalPrize, uint256 semiFinalPrize, uint256 winnerPrize);
66     event PrizePaid(string tournamentStage, uint256 indexed team, address indexed to, uint256 prize, uint256 time);
67     event Transfer(address from, address to, uint256 tokenId);
68 
69     /*****------- CONSTANTS -------******/
70     uint256 private startingPrice = 0.001 ether;
71 	uint256 private doublePriceUntil = 0.1 ether;
72 	uint256 private lastSixteenWinnerPayments = 0;
73 	uint256 private quarterFinalWinnerPayments = 0;
74 	uint256 private semiFinalWinnerPayments = 0;
75 	bool private tournamentComplete = false;
76     
77     /*****------- STORAGE -------******/
78     mapping (uint256 => address) public teamOwners;
79     mapping (address => uint256) private ownerTeamCount;
80     mapping (uint256 => address) public teamToApproved;
81     mapping (uint256 => uint256) private teamPrices;
82     address public contractModifierAddress;
83     address public developerAddress;
84     
85     /*****------- DATATYPES -------******/
86     struct Team {
87         string name;
88         string code;
89         uint256 cost;
90         uint256 price;
91         address owner;
92         uint256 numPayouts;
93         mapping (uint256 => Payout) payouts;
94     }
95 
96     struct Payout {
97         string stage;
98         uint256 amount;
99         address to;
100         uint256 when;
101     }
102 
103     Team[] private teams;
104     
105     struct PayoutPrizes {
106         uint256 LastSixteenWinner;
107         bool LastSixteenTotalFixed;
108         uint256 QuarterFinalWinner;
109         bool QuarterFinalTotalFixed;
110         uint256 SemiFinalWinner;
111         bool SemiFinalTotalFixed;
112         uint256 TournamentWinner;
113     }
114     
115     PayoutPrizes private prizes;
116 
117     /*****------- MODIFIERS -------******/
118     modifier onlyContractModifier() {
119         require(msg.sender == contractModifierAddress);
120         _;
121     }
122     
123     /*****------- CONSTRUCTOR -------******/
124     constructor() public {
125         contractModifierAddress = msg.sender;
126         developerAddress = msg.sender;
127 
128         // Initialse Prize Totals
129         prizes.LastSixteenTotalFixed = false;
130         prizes.QuarterFinalTotalFixed = false;
131         prizes.SemiFinalTotalFixed = false;
132     }
133     
134     /*****------- PUBLIC FUNCTIONS -------******/
135     function name() public pure returns (string) {
136         return "CryptoCup";
137     }
138   
139     function symbol() public pure returns (string) {
140         return "CryptoCupToken";
141     }
142     
143     function implementsERC721() public pure returns (bool) {
144         return true;
145     }
146 
147     function ownerOf(uint256 _tokenId) public view returns (address owner) {
148         owner = teamOwners[_tokenId];
149         require(owner != address(0));
150         return owner;
151     }
152     
153     function takeOwnership(uint256 _tokenId) public {
154         address to = msg.sender;
155         address from = teamOwners[_tokenId];
156     
157         require(_addressNotNull(to));
158         require(_approved(to, _tokenId));
159     
160         _transfer(from, to, _tokenId);
161     }
162     
163     function approve(address _to, uint256 _tokenId) public {
164         require(_owns(msg.sender, _tokenId));
165         teamToApproved[_tokenId] = _to;
166         emit Approval(msg.sender, _to, _tokenId);
167     }
168     
169     function balanceOf(address _owner) public view returns (uint256 balance) {
170         return ownerTeamCount[_owner];
171     }
172     
173     function totalSupply() public view returns (uint256 total) {
174         return teams.length;
175     }
176     
177     function transfer(address _to, uint256 _tokenId) public {
178         require(_owns(msg.sender, _tokenId));
179         require(_addressNotNull(_to));
180         _transfer(msg.sender, _to, _tokenId);
181     }
182     
183     function transferFrom(address _from, address _to, uint256 _tokenId) public {
184         require(_owns(_from, _tokenId));
185         require(_approved(_to, _tokenId));
186         require(_addressNotNull(_to));
187         _transfer(_from, _to, _tokenId);
188     }
189 
190 	function destroy() public onlyContractModifier {
191 		selfdestruct(contractModifierAddress);
192     }
193 
194     function setDeveloper(address _newDeveloperAddress) public onlyContractModifier {
195         require(_newDeveloperAddress != address(0));
196         developerAddress = _newDeveloperAddress;
197     }
198     
199     function createTeams() public onlyContractModifier {
200         _createTeam("Russia", "RUS", startingPrice, developerAddress);
201         _createTeam("Saudi Arabia", "KSA", startingPrice, developerAddress);
202         _createTeam("Egypt", "EGY", startingPrice, developerAddress);
203         _createTeam("Uruguay", "URU", startingPrice, developerAddress);
204         _createTeam("Portugal", "POR", startingPrice, developerAddress);
205         _createTeam("Spain", "SPA", startingPrice, developerAddress);
206         _createTeam("Morocco", "MOR", startingPrice, developerAddress);
207         _createTeam("Iran", "IRN", startingPrice, developerAddress);
208         _createTeam("France", "FRA", startingPrice, developerAddress);
209         _createTeam("Australia", "AUS", startingPrice, developerAddress);
210         _createTeam("Peru", "PER", startingPrice, developerAddress);
211         _createTeam("Denmark", "DEN", startingPrice, developerAddress);
212         _createTeam("Argentina", "ARG", startingPrice, developerAddress);
213         _createTeam("Iceland", "ICE", startingPrice, developerAddress);
214         _createTeam("Croatia", "CRO", startingPrice, developerAddress);
215         _createTeam("Nigeria", "NGA", startingPrice, developerAddress);
216         _createTeam("Brazil", "BRZ", startingPrice, developerAddress);
217         _createTeam("Switzerland", "SWI", startingPrice, developerAddress);
218         _createTeam("Costa Rica", "CRC", startingPrice, developerAddress);
219         _createTeam("Serbia", "SER", startingPrice, developerAddress);
220         _createTeam("Germany", "GER", startingPrice, developerAddress);
221         _createTeam("Mexico", "MEX", startingPrice, developerAddress);
222         _createTeam("Sweden", "SWE", startingPrice, developerAddress);
223         _createTeam("South Korea", "KOR", startingPrice, developerAddress);
224         _createTeam("Belgium", "BEL", startingPrice, developerAddress);
225         _createTeam("Panama", "PAN", startingPrice, developerAddress);
226         _createTeam("Tunisia", "TUN", startingPrice, developerAddress);
227         _createTeam("England", "ENG", startingPrice, developerAddress);
228         _createTeam("Poland", "POL", startingPrice, developerAddress);
229         _createTeam("Senegal", "SEN", startingPrice, developerAddress);
230         _createTeam("Colombia", "COL", startingPrice, developerAddress);
231         _createTeam("Japan", "JPN", startingPrice, developerAddress);
232     }
233     
234     function createTeam(string name, string code) public onlyContractModifier {
235         _createTeam(name, code, startingPrice, developerAddress);
236     }
237     
238     function lockInLastSixteenPrize() public onlyContractModifier {
239         prizes.LastSixteenTotalFixed = true;
240     }
241     
242     function payLastSixteenWinner(uint256 _tokenId) public onlyContractModifier {
243         require(prizes.LastSixteenTotalFixed != false);
244         require(lastSixteenWinnerPayments < 8);
245         require(tournamentComplete != true);
246         
247         Team storage team = teams[_tokenId];
248         require(team.numPayouts == 0);
249         
250         team.owner.transfer(prizes.LastSixteenWinner);
251         emit PrizePaid("Last Sixteen", _tokenId, team.owner, prizes.LastSixteenWinner, uint256(now));
252 
253         team.payouts[team.numPayouts++] = Payout({
254             stage: "Last Sixteen",
255             amount: prizes.LastSixteenWinner,
256             to: team.owner,
257             when: uint256(now)
258         });
259         
260         lastSixteenWinnerPayments++;
261     }
262     
263     function lockInQuarterFinalPrize() public onlyContractModifier {
264         require(prizes.LastSixteenTotalFixed != false);
265         prizes.QuarterFinalTotalFixed = true;
266     }
267     
268     function payQuarterFinalWinner(uint256 _tokenId) public onlyContractModifier {
269         require(prizes.QuarterFinalTotalFixed != false);
270         require(quarterFinalWinnerPayments < 4);
271         require(tournamentComplete != true);
272         Team storage team = teams[_tokenId];
273         require(team.numPayouts == 1);
274         Payout storage payout = team.payouts[0];
275         require(_compareStrings(payout.stage, "Last Sixteen"));
276 
277         team.owner.transfer(prizes.QuarterFinalWinner);
278         emit PrizePaid("Quarter Final", _tokenId, team.owner, prizes.QuarterFinalWinner, uint256(now));
279         team.payouts[team.numPayouts++] = Payout({
280             stage: "Quarter Final",
281             amount: prizes.QuarterFinalWinner,
282             to: team.owner,
283             when: uint256(now)
284         });
285         
286         quarterFinalWinnerPayments++;
287     }
288     
289     function lockInSemiFinalPrize() public onlyContractModifier {
290         require(prizes.QuarterFinalTotalFixed != false);
291         prizes.SemiFinalTotalFixed = true;
292     }
293         
294     function paySemiFinalWinner(uint256 _tokenId) public onlyContractModifier {
295         require(prizes.SemiFinalTotalFixed != false);
296         require(semiFinalWinnerPayments < 2);
297         require(tournamentComplete != true);
298         Team storage team = teams[_tokenId];
299         require(team.numPayouts == 2);
300         Payout storage payout = team.payouts[1];
301         require(_compareStrings(payout.stage, "Quarter Final"));
302         
303         team.owner.transfer(prizes.SemiFinalWinner);
304         emit PrizePaid("Semi Final", _tokenId, team.owner, prizes.SemiFinalWinner, uint256(now));
305         team.payouts[team.numPayouts++] = Payout({
306             stage: "Semi Final",
307             amount: prizes.SemiFinalWinner,
308             to: team.owner,
309             when: uint256(now)
310         });
311         
312         semiFinalWinnerPayments++;
313     }
314     
315     function payTournamentWinner(uint256 _tokenId) public onlyContractModifier {
316         require (tournamentComplete != true);
317         Team storage team = teams[_tokenId];
318         require(team.numPayouts == 3);
319         Payout storage payout = team.payouts[2];
320         require(_compareStrings(payout.stage, "Semi Final"));
321 
322         team.owner.transfer(prizes.TournamentWinner);
323         emit PrizePaid("Final", _tokenId, team.owner, prizes.TournamentWinner, uint256(now));
324         team.payouts[team.numPayouts++] = Payout({
325             stage: "Final",
326             amount: prizes.TournamentWinner,
327             to: team.owner,
328             when: uint256(now)
329         });
330         
331         tournamentComplete = true;
332     }
333 
334     function payExcess() public onlyContractModifier {
335         /* ONLY IF TOURNAMENT FINISHED AND THERE'S EXCESS - THERE SHOULDN'T BE */
336         /* ONLY IF TRADES OCCUR AFTER TOURNAMENT FINISHED */
337         require (tournamentComplete != false);
338         developerAddress.transfer(address(this).balance);
339     }
340 
341     function getTeam(uint256 _tokenId) public view returns (uint256 id, string name, string code, uint256 cost, uint256 price, address owner, uint256 numPayouts) {
342         Team storage team = teams[_tokenId];
343         id = _tokenId;
344         name = team.name;
345         code = team.code;
346         cost = team.cost;
347         price = team.price;
348         owner = team.owner;
349         numPayouts = team.numPayouts;
350     }
351         
352     function getTeamPayouts(uint256 _tokenId, uint256 _payoutId) public view returns (uint256 id, string stage, uint256 amount, address to, uint256 when) {
353         Team storage team = teams[_tokenId];
354         Payout storage payout = team.payouts[_payoutId];
355         id = _payoutId;
356         stage = payout.stage;
357         amount = payout.amount;
358         to = payout.to;
359         when = payout.when;
360     }
361 
362     // Allows someone to send ether and obtain the token
363     function buyTeam(uint256 _tokenId) public payable {
364         address from = teamOwners[_tokenId];
365         address to = msg.sender;
366         uint256 price = teamPrices[_tokenId];
367         
368 	    require(_addressNotNull(to));
369         require(from != to);
370         require(msg.value >= price);
371         
372         Team storage team = teams[_tokenId];
373 	    
374         uint256 purchaseExcess = SafeMath.sub(msg.value, price);
375         uint256 profit = SafeMath.sub(price, team.cost);
376         
377 	    // get 15% - 5 goes to dev and 10 stays in prize fund that is split during knockout stages
378 	    uint256 onePercent = SafeMath.div(profit, 100);
379 	    uint256 developerAllocation = SafeMath.mul(onePercent, 5);
380 	    uint256 saleProceeds = SafeMath.add(SafeMath.mul(onePercent, 85), team.cost);
381 	    uint256 fundProceeds = SafeMath.mul(onePercent, 10);
382 	    
383 	    _transfer(from, to, _tokenId);
384 	    
385 	    // Pay previous owner if owner is not contract
386         if (from != address(this)) {
387 	        from.transfer(saleProceeds);
388         }
389 
390         // Pay developer
391         if (developerAddress != address(this)) {
392 	        developerAddress.transfer(developerAllocation);
393         }
394         
395         uint256 slice = 0;
396         
397         // Increase prize fund totals
398         if (!prizes.LastSixteenTotalFixed) {
399             slice = SafeMath.div(fundProceeds, 4);
400             prizes.LastSixteenWinner += SafeMath.div(slice, 8);    
401             prizes.QuarterFinalWinner += SafeMath.div(slice, 4);    
402             prizes.SemiFinalWinner += SafeMath.div(slice, 2);    
403             prizes.TournamentWinner += slice;    
404         } else if (!prizes.QuarterFinalTotalFixed) {
405             slice = SafeMath.div(fundProceeds, 3);
406             prizes.QuarterFinalWinner += SafeMath.div(slice, 4);    
407             prizes.SemiFinalWinner += SafeMath.div(slice, 2);    
408             prizes.TournamentWinner += slice;   
409         } else if (!prizes.SemiFinalTotalFixed) {
410             slice = SafeMath.div(fundProceeds, 2);
411             prizes.SemiFinalWinner += SafeMath.div(slice, 2);
412             prizes.TournamentWinner += slice;   
413         } else {
414             prizes.TournamentWinner += fundProceeds;   
415         }
416 	    
417 		// Set new price for team
418 	    uint256 newPrice = 0;
419         if (price < doublePriceUntil) {
420             newPrice = SafeMath.div(SafeMath.mul(price, 200), 100);
421         } else {
422             newPrice = SafeMath.div(SafeMath.mul(price, 115), 100);
423         }
424 		
425 	    teamPrices[_tokenId] = newPrice;
426 	    team.cost = price;
427 	    team.price = newPrice;
428 	    
429 	    emit TeamSold(_tokenId, from, price, to, newPrice, uint256(now), address(this).balance, prizes.LastSixteenWinner, prizes.QuarterFinalWinner, prizes.SemiFinalWinner, prizes.TournamentWinner);
430 	    
431 	    msg.sender.transfer(purchaseExcess);
432 	}
433 	
434     function getPrizeFund() public view returns (bool lastSixteenTotalFixed, uint256 lastSixteenWinner, bool quarterFinalTotalFixed, uint256 quarterFinalWinner, bool semiFinalTotalFixed, uint256 semiFinalWinner, uint256 tournamentWinner, uint256 total) {
435         lastSixteenTotalFixed = prizes.LastSixteenTotalFixed;
436         lastSixteenWinner = prizes.LastSixteenWinner;   
437         quarterFinalTotalFixed = prizes.QuarterFinalTotalFixed;
438         quarterFinalWinner = prizes.QuarterFinalWinner;
439         semiFinalTotalFixed = prizes.SemiFinalTotalFixed;
440         semiFinalWinner = prizes.SemiFinalWinner;
441         tournamentWinner = prizes.TournamentWinner;
442         total = address(this).balance;
443     }
444 
445     /********----------- PRIVATE FUNCTIONS ------------********/
446     function _addressNotNull(address _to) private pure returns (bool) {
447         return _to != address(0);
448     }   
449     
450     function _createTeam(string _name, string _code, uint256 _price, address _owner) private {
451         Team memory team = Team({
452             name: _name,
453             code: _code,
454             cost: 0 ether,
455             price: _price,
456             owner: _owner,
457             numPayouts: 0
458         });
459 
460         uint256 newTeamId = teams.push(team) - 1;
461         teamPrices[newTeamId] = _price;
462         
463         _transfer(address(0), _owner, newTeamId);
464     }
465     
466     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
467         return teamToApproved[_tokenId] == _to;
468     }
469     
470     function _transfer(address _from, address _to, uint256 _tokenId) private {
471         ownerTeamCount[_to]++;
472         teamOwners[_tokenId] = _to;
473         
474         Team storage team = teams[_tokenId];
475         team.owner = _to;
476         
477         if (_from != address(0)) {
478           ownerTeamCount[_from]--;
479           delete teamToApproved[_tokenId];
480         }
481         
482         emit Transfer(_from, _to, _tokenId);
483     }
484     
485     function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
486         return _claimant == teamOwners[_tokenId];
487     }    
488     
489     function _compareStrings (string a, string b) private pure returns (bool){
490         return keccak256(a) == keccak256(b);
491     }
492 }