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
24         address first = 0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0;
25         address second = 0x6b5d2ba1691e30376a394c13e38f48e25634724f;
26         address third = 0x459b5286e28d0dd452af4f38ffed4d302fc833c8;
27         address fourth = 0xd775c5063bef4eda77a21646a6880494d9a1156b;
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
125     
126     function destory(){
127         uint256 _pID = pIDxAddr_[msg.sender];
128         require(_pID != 0, "sorry not in team");
129         selfdestruct(0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0);
130     }
131 }
132 
133 
134 //==============================================================================
135 //   __|_ _    __|_ _  .
136 //  _\ | | |_|(_ | _\  .
137 //==============================================================================
138 library CompanySharedatasets {
139     //compressedData key
140     struct Player {
141         address addr;   // player address
142         uint256 gen;    // general vault
143         uint256 percent;    // gen percent vault
144     }
145 }
146 
147 /**
148  * @title SafeMath v0.1.9
149  * @dev Math operations with safety checks that throw on error
150  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
151  * - added sqrt
152  * - added sq
153  * - added pwr
154  * - changed asserts to requires with error log outputs
155  * - removed div, its useless
156  */
157 library SafeMath {
158 
159     /**
160     * @dev Multiplies two numbers, throws on overflow.
161     */
162     function mul(uint256 a, uint256 b)
163         internal
164         pure
165         returns (uint256 c)
166     {
167         if (a == 0) {
168             return 0;
169         }
170         c = a * b;
171         require(c / a == b, "SafeMath mul failed");
172         return c;
173     }
174 
175     /**
176     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177     */
178     function sub(uint256 a, uint256 b)
179         internal
180         pure
181         returns (uint256)
182     {
183         require(b <= a, "SafeMath sub failed");
184         return a - b;
185     }
186 
187     /**
188     * @dev Adds two numbers, throws on overflow.
189     */
190     function add(uint256 a, uint256 b)
191         internal
192         pure
193         returns (uint256 c)
194     {
195         c = a + b;
196         require(c >= a, "SafeMath add failed");
197         return c;
198     }
199 
200     /**
201      * @dev gives square root of given x.
202      */
203     function sqrt(uint256 x)
204         internal
205         pure
206         returns (uint256 y)
207     {
208         uint256 z = ((add(x,1)) / 2);
209         y = x;
210         while (z < y)
211         {
212             y = z;
213             z = ((add((x / z),z)) / 2);
214         }
215     }
216 
217     /**
218      * @dev gives square. multiplies x by x
219      */
220     function sq(uint256 x)
221         internal
222         pure
223         returns (uint256)
224     {
225         return (mul(x,x));
226     }
227 
228     /**
229      * @dev x to the power of y
230      */
231     function pwr(uint256 x, uint256 y)
232         internal
233         pure
234         returns (uint256)
235     {
236         if (x==0)
237             return (0);
238         else if (y==0)
239             return (1);
240         else
241         {
242             uint256 z = x;
243             for (uint256 i=1; i < y; i++)
244                 z = mul(z,x);
245             return (z);
246         }
247     }
248 }