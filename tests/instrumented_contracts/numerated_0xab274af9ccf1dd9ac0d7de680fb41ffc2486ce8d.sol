1 pragma solidity ^0.4.24;
2 
3 contract CompanyShare {
4     using SafeMath for *;
5 
6     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
7     mapping (uint256 => CompanySharedatasets.Player) public team_;          // (team => fees) fee distribution by team
8 
9     /**
10      * @dev prevents contracts from interacting with fomo3d
11      */
12     modifier isHuman() {
13         address _addr = msg.sender;
14         uint256 _codeLength;
15 
16         assembly {_codeLength := extcodesize(_addr)}
17         require(_codeLength == 0, "sorry humans only");
18         _;
19     }
20 
21     constructor()
22         public
23     {
24         address first 	= 0xc1cac10cbe165706ce5c4fe5fad076394e8f6394;
25         address second 	= 0x70AAbFDcf6b98F571E0bEbC4eb777F7CaaA42429;
26         address third 	= 0x9a099cf4d575f9152ab98b0f566c4e255d08c7a3;
27         address fourth 	= 0xAdD148Cc4F7B1b7520325a7C5934C002420Ab3d5;
28 
29         //creatTeam
30         team_[1] = CompanySharedatasets.Player(first,0, 500);
31         pIDxAddr_[first] = 1;
32         team_[2] = CompanySharedatasets.Player(second,0, 250);
33         pIDxAddr_[second] = 2;
34         team_[3] = CompanySharedatasets.Player(third,0, 125);
35         pIDxAddr_[third] = 3;
36         team_[4] = CompanySharedatasets.Player(fourth,0, 125);
37         pIDxAddr_[fourth] = 4;
38 	}
39 
40     /**
41      * @dev emergency buy uses last stored affiliate ID and team snek
42      */
43     function()
44         public
45         payable
46     {
47         uint256 _eth = msg.value;
48         //giveTeam Gen
49         giveGen(_eth);
50     }
51 
52     function deposit()
53         public
54         payable
55         returns(bool)
56     {
57         uint256 _eth = msg.value;
58         //giveTeam Gen
59         giveGen(_eth);
60         return true;
61     }
62 
63 	function giveGen(uint256 _eth)
64 		private
65 		returns(uint256)
66     {
67         uint256 _genFirst = _eth.mul(team_[1].percent) /1000;
68         uint256 _genSecond = _eth.mul(team_[2].percent) /1000;
69         uint256 _genThird = _eth.mul(team_[3].percent) /1000;
70         uint256 _genFourth = _eth.sub(_genFirst).sub(_genSecond).sub(_genThird);
71         //give gen
72         team_[1].gen = _genFirst.add(team_[1].gen);
73         team_[2].gen = _genSecond.add(team_[2].gen);
74         team_[3].gen = _genThird.add(team_[3].gen);
75         team_[4].gen = _genFourth.add(team_[4].gen);
76     }
77 
78         /**
79      * @dev withdraws all of your earnings.
80      * -functionhash- 0x3ccfd60b
81      */
82     function withdraw()
83         isHuman()
84         public
85     {
86         // fetch player ID
87         uint256 _pID = pIDxAddr_[msg.sender];
88         require(_pID != 0, "sorry not team");
89         // setup temp var for player eth
90         uint256 _eth;
91         // get their earnings
92         _eth = withdrawEarnings(_pID);
93         team_[_pID].addr.transfer(_eth);
94     }
95 
96         /**
97      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
98      * @return earnings in wei format
99      */
100     function withdrawEarnings(uint256 _pID)
101         private
102         returns(uint256)
103     {
104 
105         // from vaults
106         uint256 _earnings = team_[_pID].gen;
107         if (_earnings > 0)
108         {
109             team_[_pID].gen = 0;
110         }
111 
112         return(_earnings);
113     }
114 
115     function getGen()
116 		public
117 		view
118 		returns(uint256)
119     {
120         uint256 _pID = pIDxAddr_[msg.sender];
121         require(_pID != 0, "sorry not in team");
122         uint256 _earnings = team_[_pID].gen;
123         return _earnings;
124     } 
125 }
126 
127 
128 //==============================================================================
129 //   __|_ _    __|_ _  .
130 //  _\ | | |_|(_ | _\  .
131 //==============================================================================
132 library CompanySharedatasets {
133     //compressedData key
134     struct Player {
135         address addr;   // player address
136         uint256 gen;    // general vault
137         uint256 percent;    // gen percent vault
138     }
139 }
140 
141 /**
142  * @title SafeMath v0.1.9
143  * @dev Math operations with safety checks that throw on error
144  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
145  * - added sqrt
146  * - added sq
147  * - added pwr
148  * - changed asserts to requires with error log outputs
149  * - removed div, its useless
150  */
151 library SafeMath {
152 
153     /**
154     * @dev Multiplies two numbers, throws on overflow.
155     */
156     function mul(uint256 a, uint256 b)
157         internal
158         pure
159         returns (uint256 c)
160     {
161         if (a == 0) {
162             return 0;
163         }
164         c = a * b;
165         require(c / a == b, "SafeMath mul failed");
166         return c;
167     }
168 
169     /**
170     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b)
173         internal
174         pure
175         returns (uint256)
176     {
177         require(b <= a, "SafeMath sub failed");
178         return a - b;
179     }
180 
181     /**
182     * @dev Adds two numbers, throws on overflow.
183     */
184     function add(uint256 a, uint256 b)
185         internal
186         pure
187         returns (uint256 c)
188     {
189         c = a + b;
190         require(c >= a, "SafeMath add failed");
191         return c;
192     }
193 
194     /**
195      * @dev gives square root of given x.
196      */
197     function sqrt(uint256 x)
198         internal
199         pure
200         returns (uint256 y)
201     {
202         uint256 z = ((add(x,1)) / 2);
203         y = x;
204         while (z < y)
205         {
206             y = z;
207             z = ((add((x / z),z)) / 2);
208         }
209     }
210 
211     /**
212      * @dev gives square. multiplies x by x
213      */
214     function sq(uint256 x)
215         internal
216         pure
217         returns (uint256)
218     {
219         return (mul(x,x));
220     }
221 
222     /**
223      * @dev x to the power of y
224      */
225     function pwr(uint256 x, uint256 y)
226         internal
227         pure
228         returns (uint256)
229     {
230         if (x==0)
231             return (0);
232         else if (y==0)
233             return (1);
234         else
235         {
236             uint256 z = x;
237             for (uint256 i=1; i < y; i++)
238                 z = mul(z,x);
239             return (z);
240         }
241     }
242 }