1 pragma solidity ^0.4.24;
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
30 //==============================================================================
31 //     _ _  _  __|_ _    __|_ _  _  .
32 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
33 //==============================================================================
34     constructor()
35         public
36     {
37         // premine the dev names (sorry not sorry)
38             // No keys are purchased with this method, it's simply locking our addresses,
39             // PID's and names for referral codes.
40         plyr_[1].addr = 0xe50ac0d497db44ffaaeb7d98cb57c420992e1d9d;
41         pIDxAddr_[0xe50ac0d497db44ffaaeb7d98cb57c420992e1d9d] = 1;
42 
43         //Total number of players
44         pID_ = 1;
45     }
46 //==============================================================================
47 //     _ _  _  _|. |`. _  _ _  .
48 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
49 //==============================================================================
50     /**
51      * @dev prevents contracts from interacting with fomo3d 解读: 判断是否是合约
52      */
53     modifier isHuman() {
54         address _addr = msg.sender;
55         uint256 _codeLength;
56 
57         assembly {_codeLength := extcodesize(_addr)}
58         require(_codeLength == 0, "sorry humans only");
59         _;
60     }
61 
62     modifier isRegisteredGame()
63     {
64         require(gameIDs_[msg.sender] != 0);
65         _;
66     }
67 //==============================================================================
68 //     _    _  _ _|_ _  .
69 //    (/_\/(/_| | | _\  .
70 //==============================================================================
71     // fired whenever a player registers a name
72     event onNewName
73     (
74         uint256 indexed playerID,
75         address indexed playerAddress,
76         bytes32 indexed playerName,
77         bool isNewPlayer,
78         uint256 affiliateID,
79         address affiliateAddress,
80         bytes32 affiliateName,
81         uint256 amountPaid,
82         uint256 timeStamp
83     );
84 
85 //==============================================================================
86 //     _    |_ |. _   |`    _  __|_. _  _  _  .
87 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
88 //====|=========================================================================
89 
90 
91 //==============================================================================
92 //    _|_ _  _ | _  .
93 //     | (_)(_)|_\  .
94 //==============================================================================
95     function determinePID(address _addr)
96         private
97         returns (bool)
98     {
99         if (pIDxAddr_[_addr] == 0)
100         {
101             pID_++;
102             pIDxAddr_[_addr] = pID_;
103             plyr_[pID_].addr = _addr;
104 
105             // set the new player bool to true
106             return (true);
107         } else {
108             return (false);
109         }
110     }
111 //==============================================================================
112 //   _   _|_ _  _ _  _ |   _ _ || _  .
113 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
114 //==============================================================================
115     function getPlayerID(address _addr)
116         isRegisteredGame()
117         external
118         returns (uint256)
119     {
120         determinePID(_addr);
121         return (pIDxAddr_[_addr]);
122     }
123 
124     function getPlayerAddr(uint256 _pID)
125         external
126         view
127         returns (address)
128     {
129         return (plyr_[_pID].addr);
130     }
131 
132 
133     //==============================================================================
134     //   _ _ _|_    _   .
135     //  _\(/_ | |_||_)  .
136     //=============|================================================================
137     function addGame(address _gameAddress)
138         public
139     {
140         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
141         gID_++;
142         gameIDs_[_gameAddress] = gID_;
143         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
144 
145         // No.1 for team , more to add later
146         games_[gID_].receivePlayerInfo(1, plyr_[1].addr);
147     }
148 }
149 
150 /**
151  * @title SafeMath v0.1.9
152  * @dev Math operations with safety checks that throw on error
153  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
154  * - added sqrt
155  * - added sq
156  * - added pwr
157  * - changed asserts to requires with error log outputs
158  * - removed div, its useless
159  */
160 library SafeMath {
161 
162     /**
163     * @dev Multiplies two numbers, throws on overflow.
164     */
165     function mul(uint256 a, uint256 b)
166         internal
167         pure
168         returns (uint256 c)
169     {
170         if (a == 0) {
171             return 0;
172         }
173         c = a * b;
174         require(c / a == b, "SafeMath mul failed");
175         return c;
176     }
177 
178     /**
179     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
180     */
181     function sub(uint256 a, uint256 b)
182         internal
183         pure
184         returns (uint256)
185     {
186         require(b <= a, "SafeMath sub failed");
187         return a - b;
188     }
189 
190     /**
191     * @dev Adds two numbers, throws on overflow.
192     */
193     function add(uint256 a, uint256 b)
194         internal
195         pure
196         returns (uint256 c)
197     {
198         c = a + b;
199         require(c >= a, "SafeMath add failed");
200         return c;
201     }
202 
203     /**
204      * @dev gives square root of given x.
205      */
206     function sqrt(uint256 x)
207         internal
208         pure
209         returns (uint256 y)
210     {
211         uint256 z = ((add(x,1)) / 2);
212         y = x;
213         while (z < y)
214         {
215             y = z;
216             z = ((add((x / z),z)) / 2);
217         }
218     }
219 
220     /**
221      * @dev gives square. multiplies x by x
222      */
223     function sq(uint256 x)
224         internal
225         pure
226         returns (uint256)
227     {
228         return (mul(x,x));
229     }
230 
231     /**
232      * @dev x to the power of y
233      */
234     function pwr(uint256 x, uint256 y)
235         internal
236         pure
237         returns (uint256)
238     {
239         if (x==0)
240             return (0);
241         else if (y==0)
242             return (1);
243         else
244         {
245             uint256 z = x;
246             for (uint256 i=1; i < y; i++)
247                 z = mul(z,x);
248             return (z);
249         }
250     }
251 }