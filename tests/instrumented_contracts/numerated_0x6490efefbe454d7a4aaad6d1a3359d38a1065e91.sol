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
124     function CryptoCupToken() public {
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
199     function createTeam(string name, string code) public onlyContractModifier {
200         _createTeam(name, code, startingPrice, developerAddress);
201     }
202     
203     function lockInLastSixteenPrize() public onlyContractModifier {
204         prizes.LastSixteenTotalFixed = true;
205     }
206     
207     function payLastSixteenWinner(uint256 _tokenId) public onlyContractModifier {
208         require(prizes.LastSixteenTotalFixed != false);
209         require(lastSixteenWinnerPayments < 8);
210         require(tournamentComplete != true);
211         
212         Team storage team = teams[_tokenId];
213         require(team.numPayouts == 0);
214         
215         team.owner.transfer(prizes.LastSixteenWinner);
216         emit PrizePaid("Last Sixteen", _tokenId, team.owner, prizes.LastSixteenWinner, uint256(now));
217 
218         team.payouts[team.numPayouts++] = Payout({
219             stage: "Last Sixteen",
220             amount: prizes.LastSixteenWinner,
221             to: team.owner,
222             when: uint256(now)
223         });
224         
225         lastSixteenWinnerPayments++;
226     }
227     
228     function lockInQuarterFinalPrize() public onlyContractModifier {
229         require(prizes.LastSixteenTotalFixed != false);
230         prizes.QuarterFinalTotalFixed = true;
231     }
232     
233     function payQuarterFinalWinner(uint256 _tokenId) public onlyContractModifier {
234         require(prizes.QuarterFinalTotalFixed != false);
235         require(quarterFinalWinnerPayments < 4);
236         require(tournamentComplete != true);
237         Team storage team = teams[_tokenId];
238         require(team.numPayouts == 1);
239         Payout storage payout = team.payouts[0];
240         require(_compareStrings(payout.stage, "Last Sixteen"));
241 
242         team.owner.transfer(prizes.QuarterFinalWinner);
243         emit PrizePaid("Quarter Final", _tokenId, team.owner, prizes.QuarterFinalWinner, uint256(now));
244         team.payouts[team.numPayouts++] = Payout({
245             stage: "Quarter Final",
246             amount: prizes.QuarterFinalWinner,
247             to: team.owner,
248             when: uint256(now)
249         });
250         
251         quarterFinalWinnerPayments++;
252     }
253     
254     function lockInSemiFinalPrize() public onlyContractModifier {
255         require(prizes.QuarterFinalTotalFixed != false);
256         prizes.SemiFinalTotalFixed = true;
257     }
258         
259     function paySemiFinalWinner(uint256 _tokenId) public onlyContractModifier {
260         require(prizes.SemiFinalTotalFixed != false);
261         require(semiFinalWinnerPayments < 2);
262         require(tournamentComplete != true);
263         Team storage team = teams[_tokenId];
264         require(team.numPayouts == 2);
265         Payout storage payout = team.payouts[1];
266         require(_compareStrings(payout.stage, "Quarter Final"));
267         
268         team.owner.transfer(prizes.SemiFinalWinner);
269         emit PrizePaid("Semi Final", _tokenId, team.owner, prizes.SemiFinalWinner, uint256(now));
270         team.payouts[team.numPayouts++] = Payout({
271             stage: "Semi Final",
272             amount: prizes.SemiFinalWinner,
273             to: team.owner,
274             when: uint256(now)
275         });
276         
277         semiFinalWinnerPayments++;
278     }
279     
280     function payTournamentWinner(uint256 _tokenId) public onlyContractModifier {
281         require (tournamentComplete != true);
282         Team storage team = teams[_tokenId];
283         require(team.numPayouts == 3);
284         Payout storage payout = team.payouts[2];
285         require(_compareStrings(payout.stage, "Semi Final"));
286 
287         team.owner.transfer(prizes.TournamentWinner);
288         emit PrizePaid("Final", _tokenId, team.owner, prizes.TournamentWinner, uint256(now));
289         team.payouts[team.numPayouts++] = Payout({
290             stage: "Final",
291             amount: prizes.TournamentWinner,
292             to: team.owner,
293             when: uint256(now)
294         });
295         
296         tournamentComplete = true;
297     }
298 
299     function payExcess() public onlyContractModifier {
300         /* ONLY IF TOURNAMENT FINISHED AND THERE'S EXCESS - THERE SHOULDN'T BE */
301         /* ONLY IF TRADES OCCUR AFTER TOURNAMENT FINISHED */
302         require (tournamentComplete != false);
303         developerAddress.transfer(address(this).balance);
304     }
305 
306     function getTeam(uint256 _tokenId) public view returns (uint256 id, string name, string code, uint256 cost, uint256 price, address owner, uint256 numPayouts) {
307         Team storage team = teams[_tokenId];
308         id = _tokenId;
309         name = team.name;
310         code = team.code;
311         cost = team.cost;
312         price = team.price;
313         owner = team.owner;
314         numPayouts = team.numPayouts;
315     }
316         
317     function getTeamPayouts(uint256 _tokenId, uint256 _payoutId) public view returns (uint256 id, string stage, uint256 amount, address to, uint256 when) {
318         Team storage team = teams[_tokenId];
319         Payout storage payout = team.payouts[_payoutId];
320         id = _payoutId;
321         stage = payout.stage;
322         amount = payout.amount;
323         to = payout.to;
324         when = payout.when;
325     }
326 
327     // Allows someone to send ether and obtain the token
328     function buyTeam(uint256 _tokenId) public payable {
329         address from = teamOwners[_tokenId];
330         address to = msg.sender;
331         uint256 price = teamPrices[_tokenId];
332         
333 	    require(_addressNotNull(to));
334         require(from != to);
335         require(msg.value >= price);
336         
337         Team storage team = teams[_tokenId];
338 	    
339         uint256 purchaseExcess = SafeMath.sub(msg.value, price);
340         
341 	    // get 15% - 5 goes to dev and 10 stays in prize fund that is split during knockout stages
342 	    uint256 onePercent = SafeMath.div(price, 100);
343 	    uint256 developerAllocation = SafeMath.mul(onePercent, 5);
344 	    uint256 saleProceeds = SafeMath.mul(onePercent, 85);
345 	    uint256 fundProceeds = SafeMath.mul(onePercent, 10);
346 	    
347 	    _transfer(from, to, _tokenId);
348 	    
349 	    // Pay previous owner if owner is not contract
350         if (from != address(this)) {
351 	        from.transfer(saleProceeds);
352         }
353 
354         // Pay developer
355         if (developerAddress != address(this)) {
356 	        developerAddress.transfer(developerAllocation);
357         }
358         
359         uint256 slice = 0;
360         
361         // Increase prize fund totals
362         if (!prizes.LastSixteenTotalFixed) {
363             slice = SafeMath.div(fundProceeds, 4);
364             prizes.LastSixteenWinner += SafeMath.div(slice, 8);    
365             prizes.QuarterFinalWinner += SafeMath.div(slice, 4);    
366             prizes.SemiFinalWinner += SafeMath.div(slice, 2);    
367             prizes.TournamentWinner += slice;    
368         } else if (!prizes.QuarterFinalTotalFixed) {
369             slice = SafeMath.div(fundProceeds, 3);
370             prizes.QuarterFinalWinner += SafeMath.div(slice, 4);    
371             prizes.SemiFinalWinner += SafeMath.div(slice, 2);    
372             prizes.TournamentWinner += slice;   
373         } else if (!prizes.SemiFinalTotalFixed) {
374             slice = SafeMath.div(fundProceeds, 2);
375             prizes.SemiFinalWinner += SafeMath.div(slice, 2);
376             prizes.TournamentWinner += slice;   
377         } else {
378             prizes.TournamentWinner += fundProceeds;   
379         }
380 	    
381 		// Set new price for team
382 	    uint256 newPrice = 0;
383         if (price < doublePriceUntil) {
384             newPrice = SafeMath.div(SafeMath.mul(price, 200), 100);
385         } else {
386             newPrice = SafeMath.div(SafeMath.mul(price, 115), 100);
387         }
388 		
389 	    teamPrices[_tokenId] = newPrice;
390 	    team.cost = price;
391 	    team.price = newPrice;
392 	    
393 	    emit TeamSold(_tokenId, from, price, to, newPrice, uint256(now), address(this).balance, prizes.LastSixteenWinner, prizes.QuarterFinalWinner, prizes.SemiFinalWinner, prizes.TournamentWinner);
394 	    
395 	    msg.sender.transfer(purchaseExcess);
396 	}
397 	
398     function getPrizeFund() public view returns (bool lastSixteenTotalFixed, uint256 lastSixteenWinner, bool quarterFinalTotalFixed, uint256 quarterFinalWinner, bool semiFinalTotalFixed, uint256 semiFinalWinner, uint256 tournamentWinner, uint256 total) {
399         lastSixteenTotalFixed = prizes.LastSixteenTotalFixed;
400         lastSixteenWinner = prizes.LastSixteenWinner;   
401         quarterFinalTotalFixed = prizes.QuarterFinalTotalFixed;
402         quarterFinalWinner = prizes.QuarterFinalWinner;
403         semiFinalTotalFixed = prizes.SemiFinalTotalFixed;
404         semiFinalWinner = prizes.SemiFinalWinner;
405         tournamentWinner = prizes.TournamentWinner;
406         total = address(this).balance;
407     }
408 
409     /********----------- PRIVATE FUNCTIONS ------------********/
410     function _addressNotNull(address _to) private pure returns (bool) {
411         return _to != address(0);
412     }   
413     
414     function _createTeam(string _name, string _code, uint256 _price, address _owner) private {
415         Team memory team = Team({
416             name: _name,
417             code: _code,
418             cost: 0 ether,
419             price: _price,
420             owner: _owner,
421             numPayouts: 0
422         });
423 
424         uint256 newTeamId = teams.push(team) - 1;
425         teamPrices[newTeamId] = _price;
426         
427         _transfer(address(0), _owner, newTeamId);
428     }
429     
430     function _approved(address _to, uint256 _tokenId) private view returns (bool) {
431         return teamToApproved[_tokenId] == _to;
432     }
433     
434     function _transfer(address _from, address _to, uint256 _tokenId) private {
435         ownerTeamCount[_to]++;
436         teamOwners[_tokenId] = _to;
437         
438         Team storage team = teams[_tokenId];
439         team.owner = _to;
440         
441         if (_from != address(0)) {
442           ownerTeamCount[_from]--;
443           delete teamToApproved[_tokenId];
444         }
445         
446         emit Transfer(_from, _to, _tokenId);
447     }
448     
449     function _owns(address _claimant, uint256 _tokenId) private view returns (bool) {
450         return _claimant == teamOwners[_tokenId];
451     }    
452     
453     function _compareStrings (string a, string b) private pure returns (bool){
454         return keccak256(a) == keccak256(b);
455     }
456 }