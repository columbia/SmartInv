1 /**
2  * Source Code first verified at https://etherscan.io on Thursday, May 2, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.25;
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 library SafeMath {
11     /**
12      * @dev Multiplies two unsigned integers, reverts on overflow.
13      */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
30      */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0);
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Adds two unsigned integers, reverts on overflow.
52      */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62      * reverts when dividing by zero.
63      */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 // ProfitLineInc contract
71 contract Snowball  {
72     using SafeMath for uint;
73     uint256 public RID; //roundid
74     mapping (uint256 => mapping(address => info)) public round;
75     
76     mapping(address => uint256)public  playerId; 
77     mapping(address => address)public  referalSticky;
78     mapping(uint256 => address)public  IdToAdress; 
79     mapping(address => address)public  hustler;
80     uint256 public hustlerprice;
81     address public currentHustler;
82     uint256 public curatorPrice;
83     address public currentCurator;
84     uint256 public nextPlayerID;
85     
86     PlincInterface constant hub_ = PlincInterface(0xd5D10172e8D8B84AC83031c16fE093cba4c84FC6);
87     
88     struct info {
89         uint256 stake;
90         uint256 lastDividendPoints;
91         }
92     address self;
93     mapping(address => uint256)public  playerVault;
94     mapping(address => uint256)public  curatorVault;
95     mapping(address => uint256)public  hustlerVault;
96     // div setup for round
97 uint256 public pointMultiplier = 10e18;
98     
99     mapping(uint256 => uint256) public price;
100     mapping(address => mapping(uint256 => uint256)) public lastActiveRound;
101     mapping(uint256 => address) public owner;
102     mapping(uint256 => uint256) public time;
103     uint256 public pot;
104     uint256 public curatorReward;
105     mapping(uint256 => uint256) public totalDividendPoints;
106     mapping(uint256 => uint256) public unclaimedDividends;
107     mapping(uint256 => uint256) public totalsupply;
108     
109     
110     function dividendsOwing(address target,uint256 roundid) public view returns(uint256) {
111         uint256 newDividendPoints = totalDividendPoints[roundid].sub(round[roundid][target].lastDividendPoints);
112         return (round[roundid][target].stake * newDividendPoints) / pointMultiplier;
113     }
114     function fetchdivs(address toUpdate, uint256 roundid) public updateAccount(toUpdate , roundid){}
115     
116     modifier updateAccount(address toUpdate , uint256 roundid) {
117         uint256 owing = dividendsOwing(toUpdate, roundid);
118         if(owing > 0) {
119             
120             unclaimedDividends[roundid] = unclaimedDividends[roundid].sub(owing);
121             playerVault[toUpdate] = playerVault[toUpdate].add(owing);
122         }
123        round[roundid][toUpdate].lastDividendPoints = totalDividendPoints[roundid];
124         _;
125         }
126     function () external payable{} // needs for divs
127     // events
128     event ballRolled(uint256 indexed round, address indexed player, uint256 indexed size);
129     event buddySold(uint256 indexed round, address indexed previousOwner, address indexed newOwner, uint256 price);
130     event collectorSold(uint256 indexed round, address indexed previousOwner, address indexed newOwner, uint256 price);
131     event cashout(uint256 indexed round, address indexed player , uint256 indexed ethAmount);
132     event endOfRound(uint256 indexed round, address player, uint256 size ,uint256 pot);
133     event ETHfail(address indexed player, uint256 indexed round,  uint256 sizeNeeded ,uint256 sizeSent);
134     // gameplay
135     function buyBall( address referral)updateAccount(msg.sender, RID)  payable public {
136         // update bonds first
137         uint256 values = msg.value;
138         address sender = msg.sender;
139         require(values > 0);
140         uint256 thisround = RID;
141         
142         if(referalSticky[sender] != 0x0){referral = referalSticky[sender];}
143         if(referalSticky[sender] == 0x0){referalSticky[sender] = referral;}
144         if(hustler[sender] == 0x0){hustler[sender] = currentHustler;}
145         // timer not expired.
146         uint256 base;
147         if(time[thisround] + 24 hours >= now){
148             // require enough $$ sent
149             if(values < price[thisround])
150             {
151                 playerVault[sender] = playerVault[sender].add(values);
152                 emit ETHfail(sender, thisround,price[thisround], values);
153             }
154             if(values >= price[thisround]){
155         // set base for calcs
156         base = price[thisround].div(100);
157         // buy plinchub bonds
158         hub_.buyBonds.value(price[thisround])(0xdc827558062AA1cc0e2AB28146DA9eeAC38A06D1) ;
159         // excess to playerbalance
160         if(values > price[thisround])
161         {
162             playerVault[msg.sender] = playerVault[msg.sender].add(values.sub(price[thisround]));
163         }
164         // pay to previous owner + 3% flip
165         playerVault[owner[thisround]] = playerVault[owner[thisround]].add(base.mul(103));
166         // adjust pot
167         pot = pot.add(base);
168         // set new owner
169         owner[thisround] = sender;
170         // update to new price
171         price[thisround] = base.mul(110);
172         // pay to previous owners
173         totalDividendPoints[thisround] = totalDividendPoints[thisround].add(base.mul(pointMultiplier).div(totalsupply[thisround]));
174         unclaimedDividends[thisround] = unclaimedDividends[thisround].add(base);
175         // pay to referral
176         playerVault[referalSticky[sender]] = playerVault[referalSticky[sender]].add(base);
177         // hustler reward
178         hustlerVault[hustler[sender]] = hustlerVault[hustler[sender]].add(base);
179         // update playerbook
180         if(playerId[sender] == 0){
181            playerId[sender] = nextPlayerID;
182            IdToAdress[nextPlayerID] = sender;
183            nextPlayerID++;
184             }
185         // add  to previous owners
186         round[thisround][sender].stake = round[thisround][sender].stake.add(1);
187         // update previous owners totalsupply
188         totalsupply[thisround] = totalsupply[thisround].add(1);
189         // update round timer
190         time[thisround] = now;
191         //update lastActiveRound
192         lastActiveRound[sender][thisround] = base.mul(100);
193        
194         emit ballRolled(thisround, sender,  values);
195             }
196     }
197     // timer expired
198         if(time[thisround] + 24 hours < now)
199             {
200                 require(values >= 10 finney);
201                 uint256 payout = pot.div(2);
202                emit endOfRound(thisround, owner[thisround], price[thisround] ,payout);
203             RID = thisround.add(1);
204             price[RID] = 10 finney;
205             owner[RID] = sender;
206             
207             base = price[thisround].div(100);
208         // buy plinc bonds
209         hub_.buyBonds.value(values)(0xdc827558062AA1cc0e2AB28146DA9eeAC38A06D1) ;
210         // pay to previous owner
211         playerVault[owner[thisround]] = playerVault[owner[thisround]].add(base.mul(100)).add(pot.div(2));
212         // adjust pot
213         pot = pot.div(2);
214         // update playerbook
215         if(playerId[sender] == 0){
216            playerId[sender] = nextPlayerID;
217            IdToAdress[nextPlayerID] = sender;
218            nextPlayerID++;
219            
220         }
221         
222         totalsupply[RID] = totalsupply[RID].add(1);
223         // update round timer
224         time[RID] = now;
225         emit ballRolled(RID, sender,  values);
226         }
227         
228     }
229     function walletToVault() payable public {
230         require(msg.value >0);
231         playerVault[msg.sender] = playerVault[msg.sender].add(msg.value);
232     }
233     // plinc functions
234     function fetchHubVault() public{
235         
236         uint256 value = hub_.playerVault(address(this));
237         require(value >0);
238         hub_.vaultToWallet();
239         
240         uint256 base = value.div(100);
241         playerVault[currentCurator] = playerVault[currentCurator].add(base);
242         // adjust pot
243         pot = pot.add(base).add(base);
244     }
245     function fetchHubPiggy() public{
246         
247         uint256 value = hub_.piggyBank(address(this));
248         require(value >0);
249         hub_.piggyToWallet();
250         uint256 base = value.div(100);
251         playerVault[currentCurator] = playerVault[currentCurator].add(base);
252         // adjust pot
253         pot = pot.add(base).add(base);
254         
255     }
256     
257     function buyHustler() payable public {
258         uint256 value = msg.value;
259         if(value < hustlerprice)
260         {
261             playerVault[msg.sender] = playerVault[msg.sender].add(value);
262             emit ETHfail(msg.sender, RID, hustlerprice, value);
263         }
264         if(value >= hustlerprice)
265         {
266         hub_.buyBonds.value(hustlerprice)(0xdc827558062AA1cc0e2AB28146DA9eeAC38A06D1) ;
267         playerVault[currentHustler] =  playerVault[currentHustler].add(hustlerprice);
268         emit buddySold(RID,currentHustler, msg.sender, hustlerprice);
269         if(value > hustlerprice)
270         {
271             playerVault[msg.sender] = playerVault[msg.sender].add(value.sub(hustlerprice));
272         }
273         hustlerprice = hustlerprice.add(1 finney);
274         currentHustler = msg.sender;
275         }
276         
277     }
278     function buyCurator() payable public {
279         uint256 value = msg.value;
280         if(value < curatorPrice)
281         {
282             playerVault[msg.sender] = playerVault[msg.sender].add(value);
283             emit ETHfail(msg.sender, RID, curatorPrice, value);
284         }
285         if(value >= curatorPrice)
286         {
287         hub_.buyBonds.value(curatorPrice)(0xdc827558062AA1cc0e2AB28146DA9eeAC38A06D1) ;
288         curatorVault[currentCurator] =  curatorVault[currentCurator].add(curatorPrice);
289         emit collectorSold(RID, currentCurator, msg.sender, curatorPrice);
290         if(value > curatorPrice)
291         {
292             playerVault[msg.sender] = playerVault[msg.sender].add(value.sub(curatorPrice));
293         }
294         curatorPrice = curatorPrice.add(1 finney);
295         currentCurator = msg.sender;
296         }
297         
298     }
299     function vaultToWallet() public {
300         
301         address sender = msg.sender;
302         require(playerVault[sender].sub(lastActiveRound[sender][RID]) > 0);
303         uint256 value = playerVault[sender].sub(lastActiveRound[sender][RID]);
304         playerVault[sender] = lastActiveRound[sender][RID];
305         emit cashout(RID,sender ,  value);
306         sender.transfer(value);
307         
308     }
309     function vaultCuratorToWallet() public {
310         
311         address sender = msg.sender;
312         require(curatorVault[sender] > 0);
313         uint256 value = curatorVault[sender];
314         curatorVault[sender] = 0;
315         emit cashout(RID,sender ,  value);
316         sender.transfer(value);
317         
318     }
319     function vaultHustlerToWallet() public {
320         
321         address sender = msg.sender;
322         require(hustlerVault[sender] > 0);
323         uint256 value = hustlerVault[sender];
324         hustlerVault[sender] = 0;
325         emit cashout(RID,sender ,  value);
326         sender.transfer(value);
327         
328     }
329     function donateToPot()  payable public {
330         pot = pot.add(msg.value);
331     }
332     
333     constructor()
334         public
335     {
336         hub_.setAuto(10);
337         hustlerprice = 1 finney;
338         curatorPrice = 1 finney;
339     }
340     // UI function
341     function fetchDataMain()
342         public
343         view
344         returns(uint256 _hubPiggy)
345     {
346         _hubPiggy = hub_.piggyBank(address(this));
347     }
348     
349     function getPlayerInfo() public view returns(address[] memory _Owner, uint256[] memory locationData,address[] memory infoRef ){
350           uint i;
351           address[] memory _locationOwner = new address[](nextPlayerID);
352           uint[] memory _locationData = new uint[](nextPlayerID*4); //curator + buddy + vault + frozen
353           address[] memory _info = new address[](nextPlayerID*2);
354           //bool[] memory _locationData2 = new bool[](nextPlayerID); //isAlive
355           uint y;
356           uint z;
357           for(uint x = 0; x < nextPlayerID; x+=1){
358             
359              
360                 _locationOwner[i] = IdToAdress[i];
361                 _locationData[y] = curatorVault[IdToAdress[i]];
362                 _locationData[y+1] = hustlerVault[IdToAdress[i]];
363                 _locationData[y+2] = playerVault[IdToAdress[i]];
364                 _locationData[y+3] = lastActiveRound[IdToAdress[i]][RID];
365                 _info[z] = referalSticky[IdToAdress[i]];
366                 _info[z+1] = hustler[IdToAdress[i]];
367                 
368                 //_locationData2[i] = allowAutoInvest[IdToAdress[i]];
369               y += 4;
370               z += 2;
371               i+=1;
372             }
373           
374           return (_locationOwner,_locationData, _info);
375         }
376         function getRoundInfo(address player) public view returns(address[] memory _Owner, uint256[] memory locationData){
377           uint i;
378           address[] memory _locationOwner = new address[](RID);
379           uint[] memory _locationData = new uint[](RID * 2); //
380           
381           uint y;
382           for(uint x = 0; x < RID; x+=1){
383             
384              
385                 _locationOwner[i] = owner[i];
386                 _locationData[y] = price[i];
387                 _locationData[y+1] = dividendsOwing(player,i);
388               y += 2;
389               i+=1;
390             }
391           
392           return (_locationOwner,_locationData);
393         }
394 }
395 interface PlincInterface {
396     
397     function IdToAdress(uint256 index) external view returns(address);
398     function nextPlayerID() external view returns(uint256);
399     function bondsOutstanding(address player) external view returns(uint256);
400     function playerVault(address player) external view returns(uint256);
401     function piggyBank(address player) external view returns(uint256);
402     function vaultToWallet() external ;
403     function piggyToWallet() external ;
404     function setAuto (uint256 percentage)external ;
405     function buyBonds( address referral)external payable ;
406 }