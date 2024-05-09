1 pragma solidity ^0.4.24;
2 
3 /*
4     _______       __    __     ________      __  
5    / ____(_)___ _/ /_  / /_   / ____/ /_  __/ /_ 
6   / /_  / / __ `/ __ \/ __/  / /   / / / / / __ \
7  / __/ / / /_/ / / / / /_   / /___/ / /_/ / /_/ /
8 /_/   /_/\__, /_/ /_/\__/   \____/_/\__,_/_.___/ 
9         /____/                                   
10 
11 
12 Fight Club
13 
14 https://ethfightclub.com
15 
16 The Decentralized Ranking Site where YOU choose the winner
17 
18 Promoters can add any two fighters for a fee
19 
20 Enter the fighters names and image link
21 
22 Image link should be in a format like this:   https://i.etsystatic.com/14392680/r/il/84f51c/1325571098/il_570xN.1325571098_p21w.jpg
23 
24 Players can vote on either fighter
25 
26 The winning fighter is the one who has the most votes when time runs out
27 
28 The players who voted on the winning fighter receive 
29 a portion of 20% of all vote fees for the winning fighter
30 
31 Promoters receive 50% of all vote fees
32 
33 */
34 
35 
36 contract fightclub {
37 
38     event newvote(
39         uint rankid
40     );
41 
42     mapping (uint => address[]) public voter1Add;
43     mapping (uint => address[]) public voter2Add;
44 
45 
46     //mapping (uint => string) categories;
47     mapping (uint => string) public fighter1Name;  
48     mapping (uint => string) public fighter2Name;  
49     mapping (uint => string) public fighter1Image;  
50     mapping (uint => string) public fighter2Image; 
51     mapping (uint => uint) public fightEndTime; 
52     mapping (uint => bool) public fightActive;
53 
54     mapping(uint => uint) public voteCount1;
55     mapping(uint => uint) public voteCount2;
56 
57     mapping(uint => address) public promoter;      //map promoter address to fight
58     mapping(uint => string) public promoterName;   //map promoter name to fight
59 
60     mapping(address => uint) public accounts;      //player and promoter accounts for withdrawal
61     mapping(address => string) public playerName;      //players can enter an optional nickname
62     mapping(uint => uint) public fightPool;        //Reward Pool for each fight
63  
64 
65     uint public votePrice = 0.001 ether;
66     uint public promotePrice = 0.05 ether;
67     
68     uint public ownerFeeRate = 15;
69     uint public promoterFeeRate = 15;
70     uint public playerFeeRate = 70;
71 
72     uint public fightLength = 17700; //3 days
73 
74     uint public fightCount = 0;
75     
76     uint public ownerAccount = 0;
77 
78     address owner;
79     
80     constructor() public {
81         owner = msg.sender;
82     }
83 
84     function vote(uint fightID, uint fighter) public payable
85     {
86 
87         require(msg.value >= votePrice);
88         require(fighter == 1 || fighter == 2);
89         require(fightActive[fightID]);
90         uint ownerFee;
91         uint authorFee;
92         uint fightPoolFee;
93 
94         ownerFee = SafeMath.div(SafeMath.mul(msg.value,ownerFeeRate),100);
95         authorFee = SafeMath.div(SafeMath.mul(msg.value,promoterFeeRate),100);
96         fightPoolFee = SafeMath.div(SafeMath.mul(msg.value,playerFeeRate),100);
97 
98         accounts[owner] = SafeMath.add(accounts[owner], ownerFee);
99         accounts[promoter[fightID]] = SafeMath.add(accounts[promoter[fightID]], authorFee);
100         fightPool[fightID] = SafeMath.add(fightPool[fightID], fightPoolFee);
101 
102         if (fighter == 1) {
103             //vote1[fightID].push(1);
104             //voter1[fightID][voteCount1] = 1;//msg.sender;
105             voter1Add[fightID].push(msg.sender);
106         } else {
107             //vote2[fightID].push(1);
108             //voter2[fightID][voter2[fightID].length] = msg.sender;
109             voter2Add[fightID].push(msg.sender);
110         }
111     }
112 
113     function promoteFight(string _fighter1Name, string _fighter2Name, string _fighter1Image, string _fighter2Image) public payable
114     {
115         require(msg.value >= promotePrice || msg.sender == owner);
116         fightActive[fightCount] = true;
117         uint ownerFee;
118         ownerFee = msg.value;
119         accounts[owner] = SafeMath.add(accounts[owner], ownerFee);
120 
121         promoter[fightCount] = msg.sender;
122 
123         fightEndTime[fightCount] = block.number + fightLength;
124 
125         fighter1Name[fightCount] = _fighter1Name;
126         fighter2Name[fightCount] = _fighter2Name;
127 
128         fighter1Image[fightCount] = _fighter1Image;
129         fighter2Image[fightCount] = _fighter2Image;
130 
131         fightCount += 1;
132 
133 
134     }
135 
136     function endFight(uint fightID) public 
137     {
138         require(block.number > fightEndTime[fightID] || msg.sender == owner);
139         require(fightActive[fightID]);
140         uint voterAmount;
141         uint payoutRemaining;
142 
143         fightActive[fightID] = false;
144 
145 
146         //determine winner and distribute funds
147         if (voter1Add[fightID].length > voter2Add[fightID].length)
148         {
149             payoutRemaining = fightPool[fightID];
150             voterAmount = SafeMath.div(fightPool[fightID],voter1Add[fightID].length);
151             for (uint i1 = 0; i1 < voter1Add[fightID].length; i1++)
152                 {
153                     if (payoutRemaining >= voterAmount)
154                     {
155                         accounts[voter1Add[fightID][i1]] = SafeMath.add(accounts[voter1Add[fightID][i1]], voterAmount);
156                         payoutRemaining = SafeMath.sub(payoutRemaining,voterAmount);
157                     } else {
158                         accounts[voter1Add[fightID][i1]] = SafeMath.add(accounts[voter1Add[fightID][i1]], payoutRemaining);
159                     }
160                     
161                 }
162             
163         }
164 
165         if (voter1Add[fightID].length < voter2Add[fightID].length)
166         {
167             payoutRemaining = fightPool[fightID];
168             voterAmount = SafeMath.div(fightPool[fightID],voter2Add[fightID].length);
169             for (uint i2 = 0; i2 < voter2Add[fightID].length; i2++)
170                 {
171                     if (payoutRemaining >= voterAmount)
172                     {
173                         accounts[voter2Add[fightID][i2]] = SafeMath.add(accounts[voter2Add[fightID][i2]], voterAmount);
174                         payoutRemaining = SafeMath.sub(payoutRemaining,voterAmount);
175                     } else {
176                         accounts[voter2Add[fightID][i2]] = SafeMath.add(accounts[voter2Add[fightID][i2]], payoutRemaining);
177                     }
178                     
179                 }
180         }
181 
182         if (voter1Add[fightID].length == voter2Add[fightID].length)
183         {
184             payoutRemaining = fightPool[fightID];
185             voterAmount = SafeMath.div(fightPool[fightID],voter1Add[fightID].length + voter2Add[fightID].length);
186             for (uint i3 = 0; i3 < voter1Add[fightID].length; i3++)
187                 {
188                     if (payoutRemaining >= voterAmount)
189                     {
190                         accounts[voter1Add[fightID][i3]] = SafeMath.add(accounts[voter1Add[fightID][i3]], voterAmount);
191                         accounts[voter2Add[fightID][i3]] = SafeMath.add(accounts[voter2Add[fightID][i3]], voterAmount);
192                         payoutRemaining = SafeMath.sub(payoutRemaining,voterAmount + voterAmount);
193                     }
194                     
195                 }
196 
197         }
198 
199         
200 
201     }
202 
203 
204     function ownerWithdraw() 
205     {
206         require(msg.sender == owner);
207         uint tempAmount = ownerAccount;
208         ownerAccount = 0;
209         owner.transfer(tempAmount);
210     }
211 
212     function withdraw() 
213     {
214         uint tempAmount = accounts[msg.sender];
215         accounts[msg.sender] = 0;
216         msg.sender.transfer(tempAmount);
217     }
218 
219     function getFightData(uint fightID) public view returns(string, string, string, string, uint, uint, uint)
220     {
221         return(fighter1Name[fightID], fighter2Name[fightID], fighter1Image[fightID], fighter2Image[fightID], voter1Add[fightID].length, voter2Add[fightID].length, fightEndTime[fightID]);
222     }
223 
224     function setPrices(uint _votePrice, uint _promotePrice) public 
225     {
226         require(msg.sender == owner);
227         votePrice = _votePrice;
228         promotePrice = _promotePrice;
229 
230     }
231 
232      function setFightLength(uint _fightLength) public 
233     {
234         require(msg.sender == owner);
235         fightLength = _fightLength;
236 
237     }
238 
239     function setRates(uint _ownerRate, uint _promoterRate, uint _playerRate) public 
240     {
241         require(msg.sender == owner);
242         require(_ownerRate + _promoterRate + _playerRate == 100);
243         ownerFeeRate = _ownerRate;
244         promoterFeeRate = _promoterRate;
245         playerFeeRate = _playerRate;
246 
247     }
248 
249     function setImages(uint _fightID, string _fighter1Image, string _fighter2Image) public 
250     {
251         require(msg.sender == promoter[_fightID]);
252         fighter1Image[fightCount] = _fighter1Image;
253         fighter2Image[fightCount] = _fighter2Image;
254 
255     }
256 
257 
258 }
259 
260 
261 /**
262  * @title SafeMath
263  * @dev Math operations with safety checks that throw on error
264  */
265 library SafeMath {
266   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
267     uint256 c = a * b;
268     assert(a == 0 || c / a == b);
269     return c;
270   }
271  
272   function div(uint256 a, uint256 b) internal constant returns (uint256) {
273     // assert(b > 0); // Solidity automatically throws when dividing by 0
274     uint256 c = a / b;
275     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276     return c;
277   }
278  
279   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
280     assert(b <= a);
281     return a - b;
282   }
283  
284   function add(uint256 a, uint256 b) internal constant returns (uint256) {
285     uint256 c = a + b;
286     assert(c >= a);
287     return c;
288   }
289 }