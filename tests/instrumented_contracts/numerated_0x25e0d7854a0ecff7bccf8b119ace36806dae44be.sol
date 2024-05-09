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