1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, throws on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18      * @dev Integer division of two numbers, truncating the quotient.
19      */
20     function div(uint256 a, uint256 b) internal pure returns(uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         // uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return a / b;
25     }
26 
27     /**
28      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29      */
30     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36      * @dev Adds two numbers, throws on overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
39         c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 contract Ownable {
46     address public owner;
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         if (newOwner != address(0)) {
59             owner = newOwner;
60         }
61     }
62     
63     function withdrawAll() public onlyOwner{
64         owner.transfer(address(this).balance);
65     }
66 
67     function withdrawPart(address _to,uint256 _percent) public onlyOwner{
68         require(_percent>0&&_percent<=100);
69         require(_to != address(0));
70         uint256 _amount = address(this).balance - address(this).balance*(100 - _percent)/100;
71         if (_amount>0){
72             _to.transfer(_amount);
73         }
74     }
75 }
76 contract Pausable is Ownable {
77 
78     bool public paused = false;
79 
80     modifier whenNotPaused() {
81         require(!paused);
82         _;
83     }
84 
85 
86     modifier whenPaused {
87         require(paused);
88         _;
89     }
90 
91     function pause() public onlyOwner whenNotPaused returns(bool) {
92         paused = true;
93         return true;
94     }
95 
96     function unpause() public onlyOwner whenPaused returns(bool) {
97         paused = false;
98         return true;
99     }
100 
101 }
102 contract WWC is Pausable {
103     string[33] public teams = [
104         "",
105         "Egypt",              // 1
106         "Morocco",            // 2
107         "Nigeria",            // 3
108         "Senegal",            // 4
109         "Tunisia",            // 5
110         "Australia",          // 6
111         "IR Iran",            // 7
112         "Japan",              // 8
113         "Korea Republic",     // 9
114         "Saudi Arabia",       // 10
115         "Belgium",            // 11
116         "Croatia",            // 12
117         "Denmark",            // 13
118         "England",            // 14
119         "France",             // 15
120         "Germany",            // 16
121         "Iceland",            // 17
122         "Poland",             // 18
123         "Portugal",           // 19
124         "Russia",             // 20
125         "Serbia",             // 21
126         "Spain",              // 22
127         "Sweden",             // 23
128         "Switzerland",        // 24
129         "Costa Rica",         // 25
130         "Mexico",             // 26
131         "Panama",             // 27
132         "Argentina",          // 28
133         "Brazil",             // 29
134         "Colombia",           // 30
135         "Peru",               // 31
136         "Uruguay"             // 32
137     ];
138 }
139 
140 contract Champion is WWC {
141     event VoteSuccessful(address user,uint256 team, uint256 amount);
142     
143     using SafeMath for uint256;
144     struct Vote {
145         mapping(address => uint256) amounts;
146         uint256 totalAmount;
147         address[] users;
148         mapping(address => uint256) weightedAmounts;
149         uint256 weightedTotalAmount;
150     }
151     uint256 public pool;
152     Vote[33] votes;
153     uint256 public voteCut = 5;
154     uint256 public poolCut = 30;
155     
156     uint256 public teamWon;
157     uint256 public voteStopped;
158     
159     uint256 public minVote = 0.05 ether;
160     uint256 public voteWeight = 4;
161     
162     mapping(address=>uint256) public alreadyWithdraw;
163 
164     modifier validTeam(uint256 _teamno) {
165         require(_teamno > 0 && _teamno <= 32);
166         _;
167     }
168 
169     function setVoteWeight(uint256 _w) public onlyOwner{
170         require(_w>0&& _w<voteWeight);
171         voteWeight = _w;
172     }
173     
174     function setMinVote(uint256 _min) public onlyOwner{
175         require(_min>=0.01 ether);
176         minVote = _min;
177     }
178     function setVoteCut(uint256 _cut) public onlyOwner{
179         require(_cut>=0&&_cut<=100);
180         voteCut = _cut;
181     }
182     
183     function setPoolCut(uint256 _cut) public onlyOwner{
184         require(_cut>=0&&_cut<=100);
185         poolCut = _cut;
186     }
187     function getVoteOf(uint256 _team) validTeam(_team) public view returns(
188         uint256 totalUsers,
189         uint256 totalAmount,
190         uint256 meAmount,
191         uint256 meWeightedAmount
192     ) {
193         Vote storage _v = votes[_team];
194         totalAmount = _v.totalAmount;
195         totalUsers = _v.users.length;
196         meAmount = _v.amounts[msg.sender];
197         meWeightedAmount = _v.weightedAmounts[msg.sender];
198     }
199 
200     function voteFor(uint256 _team) validTeam(_team) public payable whenNotPaused {
201         require(msg.value >= minVote);
202         require(voteStopped == 0);
203         userVoteFor(msg.sender, _team, msg.value);
204     }
205 
206     function userVoteFor(address _user, uint256 _team, uint256 _amount) internal{
207         Vote storage _v = votes[_team];
208         uint256 voteVal = _amount.sub(_amount.mul(voteCut).div(100));
209         if (voteVal<_amount){
210             owner.transfer(_amount.sub(voteVal));
211         }
212         if (_v.amounts[_user] == 0) {
213             _v.users.push(_user);
214         }
215         pool = pool.add(voteVal);
216         _v.totalAmount = _v.totalAmount.add(voteVal);
217         _v.amounts[_user] = _v.amounts[_user].add(voteVal);
218         _v.weightedTotalAmount = _v.weightedTotalAmount.add(voteVal.mul(voteWeight));
219         _v.weightedAmounts[_user] = _v.weightedAmounts[_user].add(voteVal.mul(voteWeight)); 
220         emit VoteSuccessful(_user,_team,_amount);
221     }
222 
223     function stopVote()  public onlyOwner {
224         require(voteStopped == 0);
225         voteStopped = 1;
226     }
227     
228     function setWonTeam(uint256 _team) validTeam(_team) public onlyOwner{
229         require(voteStopped == 1);
230         teamWon = _team;
231     }
232     
233     function myBonus() public view returns(uint256 _bonus,bool _isTaken){
234         if (teamWon==0){
235             return (0,false);
236         }
237         _bonus = bonusAmount(teamWon,msg.sender);
238         _isTaken = alreadyWithdraw[msg.sender] == 1;
239     }
240 
241     function bonusAmount(uint256 _team, address _who) internal view returns(uint256) {
242         Vote storage _v = votes[_team];
243         if (_v.weightedTotalAmount == 0){
244             return 0;
245         }
246         uint256 _poolAmount = pool.mul(100-poolCut).div(100);
247         uint256 _amount = _v.weightedAmounts[_who].mul(_poolAmount).div(_v.weightedTotalAmount);
248         return _amount;
249     }
250     
251     function withdrawBonus() public whenNotPaused{
252         require(teamWon>0);
253         require(alreadyWithdraw[msg.sender]==0);
254         alreadyWithdraw[msg.sender] = 1;
255         uint256 _amount = bonusAmount(teamWon,msg.sender);
256         require(_amount<=address(this).balance);
257         if(_amount>0){
258             msg.sender.transfer(_amount);
259         }
260     }
261 }
262 
263 contract TeamVersus is WWC {
264     event VoteSuccessful(address user,uint256 combatId,uint256 team, uint256 amount);
265     using SafeMath for uint256;
266     struct Combat{
267         uint256 poolOfTeamA;
268         uint256 poolOfTeamB;
269         uint128 teamAID;         // team id: 1-32
270         uint128 teamBID;         // team id: 1-32
271         uint128 state;  // 0 not started 1 started 2 ended
272         uint128 wonTeamID; // 0 not set
273         uint256 errCombat;  // 0 validate 1 errCombat
274     }
275     mapping (uint256 => bytes32) public comments;
276     
277     uint256 public voteCut = 5;
278     uint256 public poolCut = 20;
279     uint256 public minVote = 0.05 ether;
280     Combat[] combats;
281     mapping(uint256=>mapping(address=>uint256)) forTeamAInCombat;
282     mapping(uint256=>mapping(address=>uint256)) forTeamBInCombat;
283     mapping(uint256=>address[]) usersForTeamAInCombat;
284     mapping(uint256=>address[]) usersForTeamBInCombat;
285     
286     mapping(uint256=>mapping(address=>uint256)) public alreadyWithdraw;
287     
288     function init() public onlyOwner{
289         addCombat(1,32,"Friday 15 June");
290         addCombat(2,7,"Friday 15 June");
291         addCombat(19,22,"Friday 15 June");
292         addCombat(15,6,"Saturday 16 June");
293         addCombat(28,17,"Saturday 16 June");
294         addCombat(31,13,"Saturday 16 June");
295         addCombat(12,3,"Saturday 16 June");
296         addCombat(25,21,"Sunday 17 June");
297         addCombat(16,26,"Sunday 17 June");
298         addCombat(29,24,"Sunday 17 June");
299         addCombat(23,9,"Monday 18 June");
300         addCombat(11,27,"Monday 18 June");
301         addCombat(5,14,"Monday 18 June");
302         addCombat(30,8,"Tuesday 19 June");
303         addCombat(18,4,"Tuesday 19 June");
304         addCombat(20,1,"Tuesday 19 June");
305         addCombat(19,2,"Wednesday 20 June");
306         addCombat(32,10,"Wednesday 20 June");
307         addCombat(7,22,"Wednesday 20 June");
308         addCombat(13,6,"Thursday 21 June");
309         addCombat(15,31,"Thursday 21 June");
310         addCombat(28,12,"Thursday 21 June");
311         addCombat(29,25,"Friday 22 June");
312         addCombat(3,17,"Friday 22 June");
313         addCombat(21,24,"Friday 22 June");
314         addCombat(11,5,"Saturday 23 June");
315         addCombat(9,26,"Saturday 23 June");
316         addCombat(16,23,"Saturday 23 June");
317         addCombat(14,27,"Sunday 24 June");
318         addCombat(8,4,"Sunday 24 June");
319         addCombat(18,30,"Sunday 24 June");
320         addCombat(32,20,"Monday 25 June");
321         addCombat(10,1,"Monday 25 June");
322         addCombat(22,2,"Monday 25 June");
323         addCombat(7,19,"Monday 25 June");
324         addCombat(6,31,"Tuesday 26 June");
325         addCombat(13,15,"Tuesday 26 June");
326         addCombat(3,28,"Tuesday 26 June");
327         addCombat(17,12,"Tuesday 26 June");
328         addCombat(9,16,"Wednesday 27 June");
329         addCombat(26,23,"Wednesday 27 June");
330         addCombat(21,29,"Wednesday 27 June");
331         addCombat(24,25,"Wednesday 27 June");
332         addCombat(8,18,"Thursday 28 June");
333         addCombat(4,30,"Thursday 28 June");
334         addCombat(27,5,"Thursday 28 June");
335         addCombat(14,11,"Thursday 28 June");
336     }
337     function setMinVote(uint256 _min) public onlyOwner{
338         require(_min>=0.01 ether);
339         minVote = _min;
340     }
341     
342     function markCombatStarted(uint256 _index) public onlyOwner{
343         Combat storage c = combats[_index];
344         require(c.errCombat==0 && c.state==0);
345         c.state = 1;
346     }
347     
348     function markCombatEnded(uint256 _index) public onlyOwner{
349         Combat storage c = combats[_index];
350         require(c.errCombat==0 && c.state==1);
351         c.state = 2;
352     }  
353     
354     function setCombatWonTeam(uint256 _index,uint128 _won) public onlyOwner{
355         Combat storage c = combats[_index];
356         require(c.errCombat==0 && c.state==2);
357         require(c.teamAID == _won || c.teamBID == _won);
358         c.wonTeamID = _won;
359     }      
360 
361     function withdrawBonus(uint256 _index) public whenNotPaused{
362         Combat storage c = combats[_index];
363         require(c.errCombat==0 && c.state ==2 && c.wonTeamID>0);
364         require(alreadyWithdraw[_index][msg.sender]==0);
365         alreadyWithdraw[_index][msg.sender] = 1;
366         uint256 _amount = bonusAmount(_index,msg.sender);
367         require(_amount<=address(this).balance);
368         if(_amount>0){
369             msg.sender.transfer(_amount);
370         }
371     }    
372     function myBonus(uint256 _index) public view returns(uint256 _bonus,bool _isTaken){
373         Combat storage c = combats[_index];
374         if (c.wonTeamID==0){
375             return (0,false);
376         }
377         _bonus = bonusAmount(_index,msg.sender);
378         _isTaken = alreadyWithdraw[_index][msg.sender] == 1;
379     }    
380     
381     function bonusAmount(uint256 _index,address _who) internal view returns(uint256){
382         Combat storage c = combats[_index];
383         uint256 _poolAmount = c.poolOfTeamA.add(c.poolOfTeamB).mul(100-poolCut).div(100);
384         uint256 _amount = 0;
385         if (c.teamAID ==c.wonTeamID){
386             if (c.poolOfTeamA == 0){
387                 return 0;
388             }
389             _amount = forTeamAInCombat[_index][_who].mul(_poolAmount).div(c.poolOfTeamA);
390         }else if (c.teamBID == c.wonTeamID) {
391             if (c.poolOfTeamB == 0){
392                 return 0;
393             }            
394             _amount = forTeamBInCombat[_index][_who].mul(_poolAmount).div(c.poolOfTeamB);
395         }
396         return _amount;        
397     }
398     
399     function addCombat(uint128 _teamA,uint128 _teamB,bytes32 _cmt) public onlyOwner{
400         Combat memory c = Combat({
401             poolOfTeamA: 0,
402             poolOfTeamB: 0,
403             teamAID: _teamA,
404             teamBID: _teamB,
405             state: 0,
406             wonTeamID: 0,
407             errCombat: 0
408         });
409         uint256 id = combats.push(c) - 1;
410         comments[id] = _cmt;
411     }
412     
413     
414     function setVoteCut(uint256 _cut) public onlyOwner{
415         require(_cut>=0&&_cut<=100);
416         voteCut = _cut;
417     }
418     
419     function setPoolCut(uint256 _cut) public onlyOwner{
420         require(_cut>=0&&_cut<=100);
421         poolCut = _cut;
422     }    
423     
424     function getCombat(uint256 _index) public view returns(
425         uint128 teamAID,
426         string teamAName,
427         uint128 teamBID,
428         string teamBName,
429         uint128 wonTeamID,
430         uint256 poolOfTeamA,
431         uint256 poolOfTeamB,
432         uint256 meAmountForTeamA,
433         uint256 meAmountForTeamB,
434         uint256 state,
435         bool isError,
436         bytes32 comment
437     ){
438         Combat storage c = combats[_index];
439         teamAID = c.teamAID;
440         teamAName = teams[c.teamAID];
441         teamBID = c.teamBID;
442         teamBName = teams[c.teamBID];
443         wonTeamID = c.wonTeamID;
444         state = c.state;
445         poolOfTeamA = c.poolOfTeamA;
446         poolOfTeamB = c.poolOfTeamB;
447         meAmountForTeamA = forTeamAInCombat[_index][msg.sender];
448         meAmountForTeamB = forTeamBInCombat[_index][msg.sender];
449         isError = c.errCombat == 1;
450         comment = comments[_index];
451     }
452     
453     function getCombatsCount() public view returns(uint256){
454         return combats.length;
455     }
456     
457     function invalidateCombat(uint256 _index) public onlyOwner{
458         Combat storage c = combats[_index];
459         require(c.errCombat==0);
460         c.errCombat = 1;
461     }
462     
463     function voteFor(uint256 _index,uint256 _whichTeam) public payable whenNotPaused{
464         require(msg.value>=minVote);
465         Combat storage c = combats[_index];
466         require(c.errCombat==0 && c.state == 0 && c.wonTeamID==0);
467         userVoteFor(msg.sender, _index,_whichTeam, msg.value);
468     }
469 
470     function userVoteFor(address _standFor, uint256 _index,uint256 _whichTeam, uint256 _amount) internal{
471         Combat storage c = combats[_index];
472         uint256 voteVal = _amount.sub(_amount.mul(voteCut).div(100));
473         if (voteVal<_amount){
474             owner.transfer(_amount.sub(voteVal));
475         }
476         if (_whichTeam == c.teamAID){
477             c.poolOfTeamA = c.poolOfTeamA.add(voteVal);
478             if (forTeamAInCombat[_index][_standFor]==0){
479                 usersForTeamAInCombat[_index].push(_standFor);
480             }
481             forTeamAInCombat[_index][_standFor] = forTeamAInCombat[_index][_standFor].add(voteVal);
482         }else {
483             c.poolOfTeamB = c.poolOfTeamB.add(voteVal);
484             if (forTeamBInCombat[_index][_standFor]==0){
485                 usersForTeamBInCombat[_index].push(_standFor);
486             }
487             forTeamBInCombat[_index][_standFor] = forTeamAInCombat[_index][_standFor].add(voteVal);            
488         }
489         emit VoteSuccessful(_standFor,_index,_whichTeam,_amount);
490     }    
491     
492     function refundErrCombat(uint256 _index) public whenNotPaused{
493         Combat storage c = combats[_index];
494         require(c.errCombat == 1);
495         uint256 _amount = forTeamAInCombat[_index][msg.sender].add(forTeamBInCombat[_index][msg.sender]);
496         require(_amount>0);
497 
498         forTeamAInCombat[_index][msg.sender] = 0;
499         forTeamBInCombat[_index][msg.sender] = 0;
500         msg.sender.transfer(_amount);
501     }
502 }