1 pragma solidity >=0.5.8;
2 /*
3 MMMMZ$..?ZOMMMMMMMMMMMMMMMMMOZ?~~IZMMMMM
4 MMMZ~.~~,..ZOMMMMMMMMMMMMMDZ~~~~~~+ZMMMM
5 MMDZ.~====~.:ZMMMMMMMMMMMO7~======~$8MMM
6 MMO.,=======.:7~.......+$=~=======~~OMMM
7 MMO.=====...............~~~~~~=====~ZMMM
8 MMZ.==~.................~~~~~~~~===~ZMMM
9 MMO.=~..................:~~~~~~~~~~~ZMMM
10 MMO......................~~~~~~~~~~~OMMM
11 MMMZ......................:~~~~~~~~OMMMM
12 MMO+........................~~~~~~~ZDMMM
13 MMO............................:~~~~ZMMM
14 MO~......:ZZ,.............ZZ:.......ZMMM
15 MO......+ZZZZ,...........ZZZZ+......7DMM
16 MDZ?7=...ZZZZ............OZZZ.......ZMMM
17 O+....Z==........ZZ~Z.......====.?ZZZ8MM
18 ,....Z,$....................,==~.ZODMMMM
19 Z.O.=ZZ.......................7OZOZDMMMM
20 O.....:ZZZ~,................I$.....OMMMM
21 8=.....ZZI??ZZZOOOZZZZZOZZZ?O.Z.:~.ZZMMM
22 MZ.......+7Z7????$OZZI????Z~~ZOZZZZ~~$OM
23 MMZ...........IZO~~~~~ZZ?.$~~~~~~~~~~~ZM
24 MMMO7........==Z=~~~~~~O=+I~~IIIZ?II~~IN
25 MMMMMZ=.....:==Z~~~Z~~+$=+I~~ZZZZZZZ~~IN
26 MMMMDZ.+Z...====Z+~~~$Z==+I~~~~$Z+OZ~~IN
27 MMMMO....O=.=====~I$?====+I~~ZZ?+Z~~~~IN
28 MMMMZ.....Z~=============+I~~$$$Z$$$~~IN
29 MMMMZ......O.============OI~ZZZZZZZZZ~IN
30 MMMMZ,.....~7..,=======,.ZI~Z?~OZZ~IZ~IN
31 MMMZZZ......O...........7+$~~~~~~~~~~~ZM
32 MMZ,........ZI:.........$~$=~~~~~~~~~7OM
33 MMOZ,Z.,?$Z8MMMMND888DNMMNZZZZZZZZZOOMMM
34 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNMMMMMMMM
35 
36 This is the generic Manek.io wager contract. With a standard end timer. Betting
37 can only be stared by the admin. Who sets an endtime and number of picks.
38 Bettingcan only be ended once the timer is over. Players must withdraw their
39 funds once betting is over. This can be done on Manek.io or via the abi which
40 will always be publicly available. There is a single jackpot winner which is
41 based off the hash of the block 200 before betting ends and will be valid for 6000
42 blocks (about 1 day). The jackpot winner must claim their prize or it will
43 go to the next winner.
44 */
45 
46 contract manekio {
47 
48   //EVENTS
49   event playerBet (
50     address indexed playerAddress,
51     uint256 pick,
52     uint256 eth
53     );
54     //MODIFIERS
55     modifier onlyAdministrator(){
56       address _playerAddress = msg.sender;
57       require(_playerAddress == admin);
58       _;
59     }
60     //STRUCTURES
61     struct playerJBook {
62       uint256 sShare;
63       uint256 eShare;
64     }
65     struct playerBook {
66       uint256 share;
67       bool paid;
68     }
69     struct pickBook {
70       uint256 share; //number of shares in each
71       uint256 nBet; //number of player bets (ID)
72     }
73 
74     //DATASETS
75     mapping(address => mapping(uint256 => playerJBook)) internal plyrJBk; //[addr][bet#] = playerJBook addr => bet num => plyrJBk
76     mapping(address => mapping(uint256 => playerBook)) internal pAddrxBk; //pAddrxBk[addr][pick ID] = shares   address => pick => shares
77     mapping(uint256 => pickBook) internal pBk; //total number of N bets & shares
78     uint256 internal tShare = 0;
79     uint256 internal pot = 0;
80     uint256 internal comm = 0;
81     uint256 internal commrate = 25;
82     uint256 internal commPaid = 0;
83     uint256 internal jackpot = 0;
84     uint256 internal jpotrate = 25;
85     uint256 internal jpotinterval = 6000;
86     bool internal ended = false;
87     address payable internal admin = 0xe7Cef4D90BdA19A6e2A20F12A1A6C394230d2924;
88     //set by admin when starting betting
89     uint256 internal endtime = 0;
90     bool internal started = false;
91     uint256 internal pcknum; //number of picks 0 to x
92     //end of game values
93     uint256 internal wPck = 999; //winning pick is initialized as 999
94     uint256 internal shareval = 0;
95     uint256 internal endblock = 0; //block number that betting is ended on
96     uint256 internal jendblock = 0;
97     uint256 internal endblockhash = 0;
98     address payable internal jPotWinner;
99     bool internal jPotclaimed = false;
100 
101     //FALLBACK FUNCTION
102     //all eth sent to contract without proper message will dump into pot, comm, and jackpot
103     function() external payable {
104       require(msg.value > 0);
105       playerPick(pcknum + 1);
106     }
107     //PUBLIC FUNCTIONS
108     //this is where players place their bets
109     function playerPick(uint256 _pck) public payable {
110       address payable _pAddr = msg.sender;
111       uint256 _eth = msg.value;
112       require(_eth > 0 && _pck >= 0 && _pck < 999);
113       //minimum bet entry is .01 eth & player chose a valid pick
114       if (_eth >= 1e16 && !checkTime() && !ended && _pck <= pcknum && started) {
115         //get my fucking money
116         uint256 _commEth = _eth / commrate;
117         uint256 _jpEth = _eth / jpotrate;
118         comm += _commEth;
119         jackpot += _jpEth;
120         uint256 _potEth = _eth - _commEth - _jpEth;
121         //inc pot
122         pot += _potEth;
123         //calc shares (each share is .00001 eth)
124         uint256 _share = _potEth / 1e13;
125         //update books
126         pBk[_pck].nBet += 1;
127         pBk[_pck].share += _share;
128         //update plyrJBk
129         for(uint256 i = 0; true; i++) {
130           if(plyrJBk[_pAddr][i].eShare == 0){
131             plyrJBk[_pAddr][i].sShare = tShare;
132             plyrJBk[_pAddr][i].eShare = tShare + _share - 1;
133             break;
134           }
135         }
136         //update total shares
137         tShare += _share;
138         //update pAddrxBk
139         pAddrxBk[_pAddr][_pck].share += _share;
140         //fire event
141         emit playerBet(_pAddr, _pck, _potEth);
142       }
143       //you go here if you didn't send enough eth, didn't choose a valid pick, or the betting hasnt started yet
144       else if (!started || !ended) {
145         uint256 _commEth = _eth / commrate;
146         uint256 _jpEth = _eth / jpotrate;
147         comm += _commEth;
148         jackpot += _jpEth;
149         uint256 _potEth = _eth - _commEth - _jpEth;
150         pot += _potEth;
151       }
152       //if you really goof. send too little eth or betting is over it goes to admin
153       else {
154         comm += _eth;
155       }
156     }
157 
158     function claimJackpot() public {
159       address payable _pAddr = msg.sender;
160       uint256 _jackpot = jackpot;
161       require(ended == true && checkJPotWinner(_pAddr) && !jPotclaimed);
162       _pAddr.transfer(_jackpot);
163       jPotclaimed = true;
164       jPotWinner = _pAddr;
165     }
166 
167     function payMeBitch(uint256 _pck) public {
168       address payable _pAddr = msg.sender;
169       require(_pck >= 0 && _pck < 998);
170       require(ended == true && pAddrxBk[_pAddr][_pck].paid == false && pAddrxBk[_pAddr][_pck].share > 0 && wPck == _pck);
171       _pAddr.transfer(pAddrxBk[_pAddr][_pck].share * shareval);
172       pAddrxBk[_pAddr][_pck].paid = true;
173     }
174 
175     //VIEW FUNCTIONS
176     function checkJPotWinner(address payable _pAddr) public view returns(bool){
177       uint256 _endblockhash = endblockhash;
178       uint256 _tShare = tShare;
179       uint256 _nend = nextJPot();
180       uint256 _wnum;
181       require(plyrJBk[_pAddr][0].eShare != 0);
182       if (jPotclaimed == true) {
183         return(false);
184       }
185       _endblockhash = uint256(keccak256(abi.encodePacked(_endblockhash + _nend)));
186       _wnum = (_endblockhash % _tShare);
187       for(uint256 i = 0; true; i++) {
188         if(plyrJBk[_pAddr][i].eShare == 0){
189           break;
190         }
191         else {
192           if (plyrJBk[_pAddr][i].sShare <= _wnum && plyrJBk[_pAddr][i].eShare >= _wnum ){
193             return(true);
194           }
195         }
196       }
197       return(false);
198     }
199 
200     function nextJPot() public view returns(uint256) {
201       uint256 _cblock = block.number;
202       uint256 _jendblock = jendblock;
203       uint256 _tmp = (_cblock - _jendblock);
204       uint256 _nend = _jendblock + jpotinterval;
205       uint256 _c = 0;
206       if (jPotclaimed == true) {
207         return(0);
208       }
209       while(_tmp > ((_c + 1) * jpotinterval)) {
210         _c += 1;
211       }
212       _nend += jpotinterval * _c;
213       return(_nend);
214     }
215 
216     //to view postitions on bet for specific address
217     function addressPicks(address _pAddr, uint256 _pck) public view returns(uint256) {
218       return(pAddrxBk[_pAddr][_pck].share);
219     }
220     //checks if an address has been paid
221     function addressPaid(address _pAddr, uint256 _pck) public view returns(bool) {
222       return(pAddrxBk[_pAddr][_pck].paid);
223     }
224     //get shares in pot for specified pick
225     function pickPot(uint256 _pck) public view returns(uint256) {
226       return(pBk[_pck].share);
227     }
228     //get number of bets for speficied pick
229     function pickPlyr(uint256 _pck) public view returns(uint256) {
230       return(pBk[_pck].nBet);
231     }
232     //gets the total pot
233     function getPot() public view returns(uint256) {
234       return(pot);
235     }
236     //gets the total jackpot
237     function getJPot() public view returns(uint256) {
238       return(jackpot);
239     }
240     //gets winning pick set by admin. Will return 999 prior to
241     function getWPck() public view returns(uint256) {
242       return(wPck);
243     }
244     function viewJPotclaimed() public view returns(bool) {
245       return(jPotclaimed);
246     }
247     function viewJPotWinner() public view returns(address) {
248       return(jPotWinner);
249     }
250     //grab the time betting is over
251     function getEndtime() public view returns(uint256) {
252       return(endtime);
253     }
254     //how much do they owe me?
255     function getComm() public view returns(uint256) {
256       return(comm);
257     }
258     function hasStarted() public view returns(bool) {
259       return(started);
260     }
261     function isOver() public view returns(bool) {
262       return(ended);
263     }
264     function pickRatio(uint256 _pck) public view returns(uint256) {
265       return(pot / pBk[_pck].share);
266     }
267     function checkTime() public view returns(bool) {
268       uint256 _now = now;
269       if (_now < endtime) {
270         return(false);
271       }
272       else {
273         return(true);
274       }
275     }
276 
277     function testView(address _pAddr, uint256 _n) public view returns(uint256 sShare, uint256 eShare) {
278       return(plyrJBk[_pAddr][_n].sShare, plyrJBk[_pAddr][_n].eShare);
279     }
280 
281     //ADMIN ONLY FUNCTIONS
282     function startYourEngines(uint256 _pcknum, uint256 _endtime) onlyAdministrator() public returns(bool){
283       require(!started);
284       pcknum = _pcknum;
285       endtime = _endtime;
286       started = true;
287       return(true);
288     }
289     function adminWinner(uint256 _wPck) onlyAdministrator() public {
290       require(_wPck <= pcknum && checkTime() && ended == false);
291       ended = true;
292       wPck = _wPck;
293       shareval = pot / pBk[_wPck].share;
294       endblock = block.number;
295       uint256 _jendblock = block.number;
296       jendblock = _jendblock;
297       endblockhash = uint256(keccak256(abi.encodePacked(blockhash(_jendblock - 200))));
298     }
299     function fuckYouPayMe() onlyAdministrator() public {
300       uint256 _commDue = comm - commPaid;
301       if (_commDue > 0) {
302         admin.transfer(_commDue);
303         commPaid += _commDue;
304       }
305     }
306   }