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
36 This is the generic Manek.io wager contract where all Mankek.io bets live unless
37 otherwise stated. With a standard end timer. Betting can only be stared by the
38 admin. Who sets an endtime and number of picks. Betting can only be ended once
39 the timer is over or betting is ended and a refund is triggered. Players must
40 withdraw their funds once betting is over. There is a single jackpot winner which is
41 based off the hash of the block 200 before betting ends and will be valid for 6000
42 blocks (about 1 day). The jackpot winner must claim their prize or it will
43 go to the next winner.
44 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
45 BedID's [bID] reference a specific bet, bet names can be looked up via the viewPck
46 method.
47 */
48 
49 contract manekio {
50 
51   //EVENTS
52   event playerBet (
53     uint256 BetID,
54     address playerAddress,
55     uint256 pick,
56     uint256 eth
57     );
58   event playerPaid (
59     uint256 BetID,
60     address playerAddress,
61     uint256 pick,
62     uint256 eth
63     );
64   event jackpotClaim (
65     uint256 BetID,
66     address playerAddress,
67     uint256 eth
68     );
69   event adminStart (
70     uint256 betID,
71     uint256 pcknum,
72     uint256 endtime,
73     uint256 bEndtime
74     );
75   event adminEndWin (
76     uint256 betID,
77     uint256 wPck
78     );
79     //MODIFIERS
80     modifier onlyAdministrator(){
81       address _playerAddress = msg.sender;
82       require(_playerAddress == admin);
83       _;
84     }
85     //STRUCTURES
86     struct playerJBook {
87       uint256 sShare;
88       uint256 eShare;
89     }
90     struct playerBook {
91       uint256 share;
92       uint256 eth;
93       bool paid;
94     }
95     struct pickBook {
96       uint256 share; //number of shares in each
97       uint256 nBet; //number of player bets (ID)
98     }
99     struct betDataBook {
100       //set when games is started
101       string pckname;
102       uint256 pcknum;
103       uint256 endtime;
104       uint256 bEndtime;
105 
106       //in game values
107       uint256 tShare;
108       uint256 comm;
109       uint256 commPaid;
110       uint256 jackpot;
111 
112       //current state values
113       bool started;
114       bool ended;
115       bool refund;
116 
117       //end of game values
118       uint256 wPck;
119       uint256 shareval;
120       uint256 jendblock;
121       uint256 endblockhash;
122       address jPotWinner;
123       bool jPotclaimed;
124     }
125 
126     //DATASETS
127     mapping(uint256 => mapping(address => mapping(uint256 => playerJBook))) internal plyrJBk; //plyrJBk[bID][addr][bet #] = playerJBook addr => bet num => plyrJBk
128     mapping(uint256 => mapping(address => mapping(uint256 => playerBook))) internal pAddrxBk; //pAddrxBk[bID][addr][pck] = shares   address => pick => shares
129     mapping(uint256 => mapping(uint256 => pickBook)) internal pBk; //total number of N bets & shares
130     mapping(uint256 => betDataBook) internal bDB; //bDB[bID] = all round data except player data and pick totals
131 
132     uint256 internal commrate = 25;
133     uint256 internal jpotrate = 25;
134     uint256 internal jpotinterval = 6000;
135 
136     address payable internal admin = 0xe7Cef4D90BdA19A6e2A20F12A1A6C394230d2924;
137     uint256 internal donations = 0;
138     uint256 internal donationsPaid = 0;
139 
140 
141     //FALLBACK FUNCTION
142     //all eth sent to contract without proper message will dump into pot, comm, and jackpot
143     function() external payable {
144       require(msg.value > 0);
145       donations += msg.value;
146     }
147     //PUBLIC FUNCTIONS
148     //this is where players place their bets
149     function playerPick(uint256 _bID, uint256 _pck) public payable {
150       address _pAddr = msg.sender;
151       uint256 _eth = msg.value;
152       require(_eth > 0);
153       //minimum bet entry is .01 eth & player chose a valid pick
154       if (_eth >= 1e16 && !checkTime(_bID) && !bDB[_bID].ended && _pck <= bDB[_bID].pcknum && bDB[_bID].started && !bDB[_bID].refund) {
155         //get my fucking money
156         uint256 _commEth = _eth / commrate;
157         uint256 _jpEth = _eth / jpotrate;
158         uint256 _potEth = _eth - _commEth - _jpEth;
159         //calc shares (each share is .00001 eth)
160         uint256 _share = _potEth / 1e13;
161         //update books
162         bDB[_bID].comm += _commEth;
163         bDB[_bID].jackpot += _jpEth + (_potEth % 1e13);
164         pBk[_bID][_pck].nBet += 1;
165         pBk[_bID][_pck].share += _share;
166         //update plyrJBk
167         for(uint256 i = 0; true; i++) {
168           if(plyrJBk[_bID][_pAddr][i].eShare == 0){
169             plyrJBk[_bID][_pAddr][i].sShare = bDB[_bID].tShare;
170             plyrJBk[_bID][_pAddr][i].eShare = bDB[_bID].tShare + _share - 1;
171             break;
172           }
173         }
174         //update total shares
175         bDB[_bID].tShare += _share;
176         //update pAddrxBk
177         pAddrxBk[_bID][_pAddr][_pck].share += _share;
178         pAddrxBk[_bID][_pAddr][_pck].eth += _eth;
179         //fire event
180         emit playerBet(_bID, _pAddr, _pck, _potEth);
181       }
182       else {
183         donations += _eth;
184       }
185     }
186     //call me if you won the jackpot (can check via checkJPotWinner) which this function also calls
187     function claimJackpot(uint256 _bID) public {
188       address payable _pAddr = msg.sender;
189       uint256 _jackpot = bDB[_bID].jackpot;
190       require(bDB[_bID].ended == true && checkJPotWinner(_bID, _pAddr) && !bDB[_bID].jPotclaimed && bDB[_bID].refund == false);
191       bDB[_bID].jPotclaimed = true;
192       bDB[_bID].jPotWinner = _pAddr;
193       _pAddr.transfer(_jackpot);
194       emit jackpotClaim(_bID, _pAddr, _jackpot);
195     }
196     //call me if you won and betting is over
197     function payMeBitch(uint256 _bID, uint256 _pck) public {
198       address payable _pAddr = msg.sender;
199       require(pAddrxBk[_bID][_pAddr][_pck].paid == false && pAddrxBk[_bID][_pAddr][_pck].share > 0 && bDB[_bID].wPck == _pck && bDB[_bID].refund == false && bDB[_bID].ended == true);
200       uint256 _eth = pAddrxBk[_bID][_pAddr][_pck].share * bDB[_bID].shareval;
201       pAddrxBk[_bID][_pAddr][_pck].paid = true;
202       _pAddr.transfer(_eth);
203       emit playerPaid(_bID, _pAddr, _pck, _eth);
204     }
205     //call me if a refund was triggered by admin
206     function giveMeRefund(uint256 _bID, uint256 _pck) public {
207       address payable _pAddr = msg.sender;
208       require(bDB[_bID].refund == true);
209       require(pAddrxBk[_bID][_pAddr][_pck].paid == false && pAddrxBk[_bID][_pAddr][_pck].eth > 0);
210       pAddrxBk[_bID][_pAddr][_pck].paid = true;
211       _pAddr.transfer(pAddrxBk[_bID][_pAddr][_pck].eth);
212     }
213 
214     //VIEW FUNCTIONS
215     //checks if a specific address is the jackpot winner for bet
216     function checkJPotWinner(uint256 _bID, address payable _pAddr) public view returns(bool){
217       uint256 _endblockhash = bDB[_bID].endblockhash;
218       uint256 _tShare = bDB[_bID].tShare;
219       uint256 _nend = nextJPot(_bID);
220       uint256 _wnum;
221       require(plyrJBk[_bID][_pAddr][0].eShare != 0);
222       if (bDB[_bID].jPotclaimed == true) {
223         return(false);
224       }
225       //pseudo random function which adds deadline block to a stored block hash and keccack256 hashes it
226       _endblockhash = uint256(keccak256(abi.encodePacked(_endblockhash + _nend)));
227       _wnum = (_endblockhash % _tShare);
228       for(uint256 i = 0; true; i++) {
229         if(plyrJBk[_bID][_pAddr][i].eShare == 0){
230           break;
231         }
232         else {
233           if (plyrJBk[_bID][_pAddr][i].sShare <= _wnum && plyrJBk[_bID][_pAddr][i].eShare >= _wnum ){
234             return(true);
235           }
236         }
237       }
238       return(false);
239     }
240     //returns the current jackpot claim deadline
241     function nextJPot(uint256 _bID) public view returns(uint256) {
242       uint256 _cblock = block.number;
243       uint256 _jendblock = bDB[_bID].jendblock;
244       uint256 _tmp = (_cblock - _jendblock);
245       uint256 _nend = _jendblock + jpotinterval;
246       uint256 _c = 0;
247       if (bDB[_bID].jPotclaimed == true) {
248         return(0);
249       }
250       while(_tmp > ((_c + 1) * jpotinterval)) {
251         _c += 1;
252       }
253       _nend += jpotinterval * _c;
254       return(_nend);
255     }
256     //GETS FOR POT AND PLAYER STATS
257     //to view postitions on bet for specific address
258     function addressPicks(uint256 _bID, address _pAddr, uint256 _pck) public view returns(uint256) {return(pAddrxBk[_bID][_pAddr][_pck].share);}
259     //checks if an address has been paid
260     function addressPaid(uint256 _bID, address _pAddr, uint256 _pck) public view returns(bool) {return(pAddrxBk[_bID][_pAddr][_pck].paid);}
261     //get shares in pot for specified pick
262     function pickPot(uint256 _bID, uint256 _pck) public view returns(uint256) {return(pBk[_bID][_pck].share);}
263     //get number of bets for speficied pick
264     function pickPlyr(uint256 _bID, uint256 _pck) public view returns(uint256) {return(pBk[_bID][_pck].nBet);}
265     //gets pick pot to pot ratio (bet multipliers)
266     function pickRatio(uint256 _bID, uint256 _pck) public view returns(uint256) {return(bDB[_bID].tShare * 1e13 / pBk[_bID][_pck].share);}
267     function getPot(uint256 _bID) public view returns(uint256) {return(bDB[_bID].tShare * 1e13);}
268     function getJPot(uint256 _bID) public view returns(uint256) {return(bDB[_bID].jackpot);}
269     function getWPck(uint256 _bID) public view returns(uint256) {return(bDB[_bID].wPck);}
270     function viewJPotclaimed(uint256 _bID) public view returns(bool) {return(bDB[_bID].jPotclaimed);}
271     function viewJPotWinner(uint256 _bID) public view returns(address) {return(bDB[_bID].jPotWinner);}
272 
273     //GETS FOR THINGS SET BY ADMIN WHEN BETTING IS STARTED
274     function viewPck(uint256 _bID) public view returns(string memory name, uint256 num) {return(bDB[_bID].pckname, bDB[_bID].pcknum);}
275     function getEndtime(uint256 _bID) public view returns(uint256) {return(bDB[_bID].endtime);}
276     function getBEndtime(uint256 _bID) public view returns(uint256) {return(bDB[_bID].bEndtime);}
277 
278     //GETS FOR STATE VARIABLES
279     function hasStarted(uint256 _bID) public view returns(bool) {return(bDB[_bID].started);}
280     function isOver(uint256 _bID) public view returns(bool) {return(bDB[_bID].ended);}
281     function isRefund(uint256 _bID) public view returns(bool){return(bDB[_bID].refund);}
282 
283     function checkTime(uint256 _bID) public view returns(bool) {
284       uint256 _now = now;
285       if (_now < bDB[_bID].endtime) {
286         return(false);
287       }
288       else {
289         return(true);
290       }
291     }
292     //GETS FOR PAYING ADMIN
293     function getComm(uint256 _bID) public view returns(uint256 comm, uint256 commPaid) {return(bDB[_bID].comm, bDB[_bID].commPaid);}
294     function getDon() public view returns(uint256 don, uint256 donPaid) {return(donations, donationsPaid);}
295 
296     //ADMIN ONLY FUNCTIONS
297     function adminStartBet(uint256 _bID, string memory _pckname, uint256 _pcknum, uint256 _endtime, uint256 _bEndtime) onlyAdministrator() public {
298       require(!bDB[_bID].started);
299       bDB[_bID].pckname = _pckname;
300       bDB[_bID].pcknum = _pcknum;
301       bDB[_bID].endtime = _endtime;
302       bDB[_bID].bEndtime = _bEndtime;
303       bDB[_bID].started = true;
304       emit adminStart(_bID, _pcknum, _endtime, _bEndtime);
305     }
306     function adminWinner(uint256 _bID, uint256 _wPck) onlyAdministrator() public {
307       require(_wPck <= bDB[_bID].pcknum && checkTime(_bID) && bDB[_bID].ended == false && bDB[_bID].refund == false);
308       bDB[_bID].ended = true;
309       bDB[_bID].wPck = _wPck;
310       uint256 _shareval = (1e13 * bDB[_bID].tShare) / pBk[_bID][_wPck].share;
311       bDB[_bID].shareval = _shareval;
312       uint256 _rem = (1e13 * bDB[_bID].tShare ) % pBk[_bID][_wPck].share;
313       if (_rem > 0) {
314         donations += _rem;
315       }
316       uint256 _jendblock = block.number;
317       bDB[_bID].jendblock = _jendblock;
318       //setting the pseudo random block hash of 200 blocks ago
319       bDB[_bID].endblockhash = uint256(keccak256(abi.encodePacked(blockhash(_jendblock - 200))));
320       emit adminEndWin(_bID, _wPck);
321     }
322     function fuckYouPayMe(uint256 _bID) onlyAdministrator() public {
323       require(checkTime(_bID) == true && bDB[_bID].refund == false);
324       uint256 _commDue = bDB[_bID].comm - bDB[_bID].commPaid;
325       if (_commDue > 0) {
326         bDB[_bID].commPaid += _commDue;
327         admin.transfer(_commDue);
328       }
329     }
330     function adminRefund(uint256 _bID) onlyAdministrator() public {
331       require(bDB[_bID].ended != true && bDB[_bID].refund != true);
332       bDB[_bID].refund = true;
333     }
334     function adminRake() onlyAdministrator() public {
335       uint256 _donDue = donations - donationsPaid;
336       if (_donDue > 0) {
337         donationsPaid += _donDue;
338         admin.transfer(_donDue);
339       }
340     }
341   }