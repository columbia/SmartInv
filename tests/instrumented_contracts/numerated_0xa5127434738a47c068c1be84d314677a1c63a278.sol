1 pragma solidity ^0.5.0;
2 /*
3  * FOMO Fast-PlayerBook - v0.3.14
4  */
5 
6 interface PlayerBookReceiverInterface {
7     function receivePlayerInfo(uint256 _pID, address _addr) external;
8 }
9 
10 contract PlayerBook {
11     using SafeMath for uint256;
12 
13     address private admin = msg.sender;
14     //==============================================================================
15     //     _| _ _|_ _    _ _ _|_    _   .
16     //    (_|(_| | (_|  _\(/_ | |_||_)  .
17     //=============================|================================================
18     // mapping of our game interfaces for sending your account info to games
19     mapping(uint256 => PlayerBookReceiverInterface) public games_;
20     mapping(address => uint256) public gameIDs_;            // lokup a games ID
21     uint256 public gID_;        // total number of games
22     uint256 public pID_;        // total number of players
23     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
24     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
25     mapping (uint256 => uint256) public refIDxpID_;
26 
27     struct Player {
28         address addr;
29     }
30     //==============================================================================
31     //     _ _  _  __|_ _    __|_ _  _  .
32     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
33     //==============================================================================
34     constructor()
35     public
36     {
37         plyr_[1].addr = 0x5838463c93100c48324bF56a4Ecd2cD378caCa7D;
38         pIDxAddr_[0x5838463c93100c48324bF56a4Ecd2cD378caCa7D] = 1;
39         // 合作地址
40         plyr_[2].addr = 0x4d20f551f4509BBdb5a3807e9A706b4fC411eD31;
41         pIDxAddr_[0x4d20f551f4509BBdb5a3807e9A706b4fC411eD31] = 2;
42 
43         //Total number of players
44         pID_ = 2;
45 
46     }
47     //==============================================================================
48     //     _ _  _  _|. |`. _  _ _  .
49     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
50     //==============================================================================
51     /**
52      * @dev prevents contracts from interacting with fomo3d 解读: 判断是否是合约
53      */
54     modifier isHuman() {
55         address _addr = msg.sender;
56         uint256 _codeLength;
57 
58         assembly {_codeLength := extcodesize(_addr)}
59         require(_codeLength == 0, "sorry humans only");
60         _;
61     }
62 
63     modifier isRegisteredGame()
64     {
65         require(gameIDs_[msg.sender] != 0);
66         _;
67     }
68     //==============================================================================
69     //     _    _  _ _|_ _  .
70     //    (/_\/(/_| | | _\  .
71     //==============================================================================
72     // fired whenever a player registers a name
73     event onNewName
74     (
75         uint256 indexed playerID,
76         address indexed playerAddress,
77         bytes32 indexed playerName,
78         bool isNewPlayer,
79         uint256 affiliateID,
80         address affiliateAddress,
81         bytes32 affiliateName,
82         uint256 amountPaid,
83         uint256 timeStamp
84     );
85 
86     //==============================================================================
87     //     _    |_ |. _   |`    _  __|_. _  _  _  .
88     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
89     //====|=========================================================================
90 
91 
92     //==============================================================================
93     //    _|_ _  _ | _  .
94     //     | (_)(_)|_\  .
95     //==============================================================================
96     function determinePID(address _addr)
97     private
98     returns (bool)
99     {
100         if (pIDxAddr_[_addr] == 0)
101         {
102             pID_++;
103             pIDxAddr_[_addr] = pID_;
104             plyr_[pID_].addr = _addr;
105 
106             // set the new player bool to true
107             return (true);
108         } else {
109             return (false);
110         }
111     }
112     //==============================================================================
113     //   _   _|_ _  _ _  _ |   _ _ || _  .
114     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
115     //==============================================================================
116     function getPlayerID(address _addr)
117     isRegisteredGame()
118     external
119     returns (uint256)
120     {
121         determinePID(_addr);
122         return (pIDxAddr_[_addr]);
123     }
124 
125     function getPlayerAddr(uint256 _pID)
126     external
127     view
128     returns (address)
129     {
130         return (plyr_[_pID].addr);
131     }
132 
133     //     function getPlayerRefIDxpID(uint256 _pID)
134     //         external
135     //         view
136     //         returns (uint256)
137     //     {
138     // //        return (plyr_[_pID].refID);
139     //     }
140 
141     //==============================================================================
142     //   _ _ _|_    _   .
143     //  _\(/_ | |_||_)  .
144     //=============|================================================================
145     function addGame(address _gameAddress)
146     public
147     {
148         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
149         gID_++;
150         gameIDs_[_gameAddress] = gID_;
151         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
152 
153         // No.1 for team , more to add later
154         games_[gID_].receivePlayerInfo(1, plyr_[1].addr);
155     }
156 }
157 
158 /**
159  * @title SafeMath v0.1.9
160  * @dev Math operations with safety checks that throw on error
161  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
162  * - added sqrt
163  * - added sq
164  * - added pwr
165  * - changed asserts to requires with error log outputs
166  * - removed div, its useless
167  */
168 library SafeMath {
169 
170     /**
171     * @dev Multiplies two numbers, throws on overflow.
172     */
173     function mul(uint256 a, uint256 b)
174     internal
175     pure
176     returns (uint256 c)
177     {
178         if (a == 0) {
179             return 0;
180         }
181         c = a * b;
182         require(c / a == b, "SafeMath mul failed");
183         return c;
184     }
185 
186     /**
187     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188     */
189     function sub(uint256 a, uint256 b)
190     internal
191     pure
192     returns (uint256)
193     {
194         require(b <= a, "SafeMath sub failed");
195         return a - b;
196     }
197 
198     /**
199     * @dev Adds two numbers, throws on overflow.
200     */
201     function add(uint256 a, uint256 b)
202     internal
203     pure
204     returns (uint256 c)
205     {
206         c = a + b;
207         require(c >= a, "SafeMath add failed");
208         return c;
209     }
210 
211     /**
212      * @dev gives square root of given x.
213      */
214     function sqrt(uint256 x)
215     internal
216     pure
217     returns (uint256 y)
218     {
219         uint256 z = ((add(x,1)) / 2);
220         y = x;
221         while (z < y)
222         {
223             y = z;
224             z = ((add((x / z),z)) / 2);
225         }
226     }
227 
228     /**
229      * @dev gives square. multiplies x by x
230      */
231     function sq(uint256 x)
232     internal
233     pure
234     returns (uint256)
235     {
236         return (mul(x,x));
237     }
238 
239     /**
240      * @dev x to the power of y
241      */
242     function pwr(uint256 x, uint256 y)
243     internal
244     pure
245     returns (uint256)
246     {
247         if (x==0)
248             return (0);
249         else if (y==0)
250             return (1);
251         else
252         {
253             uint256 z = x;
254             for (uint256 i=1; i < y; i++)
255                 z = mul(z,x);
256             return (z);
257         }
258     }
259 }