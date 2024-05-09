1 contract Etherization {
2     
3     // 1 eth starting price
4     uint public START_PRICE = 1000000000000000000;
5     // 0.8 eth city build price
6     uint public CITY_PRICE = 800000000000000000;
7     // 0.5 eth building build price
8     uint public BUILDING_PRICE = 500000000000000000;
9     // 0.2 eth unit build price
10     uint public UNIT_PRICE = 200000000000000000;
11     // 0.02 eth unit maintenance price
12     uint public MAINT_PRICE = 20000000000000000;
13     // 0.1 eth min withdraw amount to prevent spam
14     uint public MIN_WTH = 100000000000000000;
15     
16     // minimum time to wait between moves in seconds
17     uint public WAIT_TIME = 14400;
18     uint MAP_ROWS = 34;
19     uint MAP_COLS = 34;
20     
21     
22     struct City {
23         uint owner;
24         string name;
25         // 0 - quarry, 1 - farm, 2 - woodworks, 3 - metalworks, 4 -stables
26         bool[5] buildings;
27         // 1 - pikemen, 2 - swordsmen, 3 - horsemen
28         uint[10] units; //maximum num of units per city 10
29         uint[2] rowcol;
30         int previousID;
31         int nextID;
32     }
33     
34     struct Player {
35         // Player address
36         address etherAddress;
37         // Their name
38         string name;
39         // Their treasury balance
40         uint treasury;
41         // Their capitol
42         uint capitol;
43         // Number of cities the player has under control
44         uint numCities;
45         uint numUnits;
46         // When was their last move (based on block.timestamp)
47         uint lastTimestamp;
48     }
49     
50     Player player;
51     Player[] public players;
52     uint public numPlayers = 0;
53     
54     mapping(address => uint) playerIDs;
55     mapping(uint => uint) public playerMsgs;
56     
57     City city;
58     City[] public cities;
59     uint public numCities = 0;
60     
61     uint[] public quarryCities;
62     uint[] public farmCities;
63     uint[] public woodworksCities;
64     uint[] public metalworksCities;
65     uint[] public stablesCities;
66     
67     uint[34][34] public map;
68 
69     address wizardAddress;
70     
71     address utilsAddress;
72     address utilsAddress2;
73     
74     // Sum of all players' balances
75     uint public totalBalances = 0;
76 
77     // Used to ensure only the owner can do some things.
78     modifier onlywizard { if (msg.sender == wizardAddress) _ }
79     
80     // Used to ensure only the utils contract can do some things.
81     modifier onlyutils { if (msg.sender == utilsAddress || msg.sender == utilsAddress2) _ }
82 
83 
84 
85     // Sets up defaults.
86     function Etherization() {
87         wizardAddress = msg.sender;
88     }
89 
90     function start(string playerName, string cityName, uint row, uint col, uint rowref, uint colref) {
91         
92         
93         // If they paid too little, reject and refund their money.
94         if (msg.value < START_PRICE) {
95             //msg.sender.send(msg.value);
96             //playerMsgs[msg.sender] = "Not enough ether sent to found a city and start playing. Sending back any eth sent...";
97             return;
98         }
99         // If the player already exists
100         if (playerIDs[msg.sender] > 0) {
101             //msg.sender.send(msg.value);
102             //playerMsgs[msg.sender] =  "You already founded an etherization. Lookup your player ID by calling getMyPlayerID(). Sending back any eth sent...";
103             return;
104         }
105         
106         player.etherAddress = msg.sender;
107         player.name = playerName;
108         player.treasury = msg.value;
109         totalBalances += msg.value;
110         player.capitol = numCities;
111         player.numCities = 1;
112         player.numUnits = 1;
113 
114         players.push(player);
115         
116         city.owner = numPlayers;
117         city.name = cityName;
118         // the first city in the game has a quarry and a farm by default
119         if(numCities <= 0) {
120             city.buildings[0] = true;
121             quarryCities.push(0);
122             city.buildings[1] = true;
123             farmCities.push(0);
124             city.rowcol[0] = 10;
125             city.rowcol[1] = 10;
126             map[10][10] = numPlayers+1;
127         } else {
128             city.buildings[0] = false;
129             city.buildings[1] = false;
130             if(row>33 || col>33 || rowref>33 || colref>33 || int(row)-int(rowref) > int(1) || int(row)-int(rowref) < int(-1) || int(col)-int(colref) > int(1) || int(col)-int(colref) < int(-1) || map[row][col]>0 || map[rowref][colref]<=0) {
131                 throw;
132             }
133             city.rowcol[0] = row;
134             city.rowcol[1] = col;
135             map[row][col] = numPlayers+1;
136             
137             players[numPlayers].treasury -= START_PRICE;
138             // distribute build funds to production type building owners
139             uint productionCut;
140             uint i;
141             productionCut = START_PRICE / quarryCities.length;
142             for(i=0; i < quarryCities.length; i++) {
143                 players[cities[quarryCities[i]].owner].treasury += productionCut;
144             }
145         }
146         city.units[0] = 1;  //pikemen guards a city by default
147         city.previousID = -1;
148         city.nextID = -1;
149         
150         cities.push(city);
151         
152         playerIDs[msg.sender] = numPlayers+1; //to distinguish it from the default 0
153         numPlayers++;
154         numCities++;
155         
156         playerMsgs[playerIDs[msg.sender]-1] = 1 + row*100 + col*10000;
157         players[numPlayers-1].lastTimestamp = now;
158     }
159     
160     function deposit() {
161         players[playerIDs[msg.sender]-1].treasury += msg.value;
162         totalBalances += msg.value;
163     }
164     
165     function withdraw(uint amount) {
166         if(int(playerIDs[msg.sender])-1 < 0) {
167             throw;
168         }
169         uint playerID = playerIDs[msg.sender]-1;
170         if(timePassed(playerID) < WAIT_TIME) {
171             playerMsgs[playerIDs[msg.sender]-1] = 2;
172             return;        
173         }
174         if(amount < players[playerID].treasury && amount > MIN_WTH) {
175             players[playerID].treasury -= amount;
176             totalBalances -= amount;
177             players[playerID].etherAddress.send((amount*99)/100); //keep 1% as commission
178         }
179     }
180     
181     
182     
183     function getMyPlayerID() constant returns (int ID) {
184         return int(playerIDs[msg.sender])-1;
185     }
186     
187     function getMyMsg() constant returns (uint s) {
188         return playerMsgs[playerIDs[msg.sender]-1];
189     }
190     
191     function getCity(uint cityID) constant returns (uint owner, string cityName, bool[5] buildings, uint[10] units, uint[2] rowcol, int previousID, int nextID) {
192         return (cities[cityID].owner, cities[cityID].name, cities[cityID].buildings, cities[cityID].units, cities[cityID].rowcol, cities[cityID].previousID, cities[cityID].nextID);
193     }
194     
195     
196     function timePassed(uint playerID) constant returns (uint tp) {
197         return (now - players[playerID].lastTimestamp);
198     }
199 
200 
201     // Used only by the wizard to check his commission.
202     function getCommission() onlywizard constant returns (uint com) {
203         return this.balance-totalBalances;
204     }
205 
206     // Used only by the wizard to collect his commission.
207     function sweepCommission(uint amount) onlywizard {
208         if(amount < this.balance-totalBalances) {
209             wizardAddress.send(amount);
210         }
211     }
212     
213     
214     
215     function setUtils(address a) onlywizard {
216         utilsAddress = a;
217     }
218     
219     function setUtils2(address a) onlywizard {
220         utilsAddress2 = a;
221     }
222     
223     function getPlayerID(address sender) onlyutils constant returns (uint playerID) {
224         if(int(playerIDs[sender])-1 < 0) {
225             throw;
226         }
227         return playerIDs[sender]-1;
228     }
229     
230     function getWwLength() constant returns (uint length) {
231         return woodworksCities.length;
232     }
233     
234     function getMwLength() constant returns (uint length) {
235         return metalworksCities.length;
236     }
237     
238     function getStLength() constant returns (uint length) {
239         return stablesCities.length;
240     }
241     
242     function getFmLength() constant returns (uint length) {
243         return farmCities.length;
244     }
245     
246     function getQrLength() constant returns (uint length) {
247         return quarryCities.length;
248     }
249     
250     
251     function setMsg(address sender, uint s) onlyutils {
252         playerMsgs[playerIDs[sender]-1] = s;
253     }
254     
255     function setNumCities(uint nc) onlyutils {
256         numCities = nc;
257     }
258     
259     function setUnit(uint cityID, uint i, uint unitType) onlyutils {
260         cities[cityID].units[i] = unitType;
261     }
262     
263     function setOwner(uint cityID, uint owner) onlyutils {
264         cities[cityID].owner = owner;
265     }
266     
267     function setName(uint cityID, string name) onlyutils {
268         cities[cityID].name = name;
269     }
270     
271     function setPreviousID(uint cityID, int previousID) onlyutils {
272         cities[cityID].previousID = previousID;
273     }
274     
275     function setNextID(uint cityID, int nextID) onlyutils {
276         cities[cityID].nextID = nextID;
277     }
278     
279     function setRowcol(uint cityID, uint[2] rowcol) onlyutils {
280         cities[cityID].rowcol = rowcol;
281     }
282     
283     function setMap(uint row, uint col, uint ind) onlyutils {
284         map[row][col] = ind;
285     }
286     
287     function setCapitol(uint playerID, uint capitol) onlyutils {
288         players[playerID].capitol = capitol;
289     }
290 
291     function setNumUnits(uint playerID, uint numUnits) onlyutils {
292         players[playerID].numUnits = numUnits;
293     }
294     
295     function setNumCities(uint playerID, uint numCities) onlyutils {
296         players[playerID].numCities = numCities;
297     }
298     
299     function setTreasury(uint playerID, uint treasury) onlyutils {
300         players[playerID].treasury = treasury;
301     }
302     
303     function setLastTimestamp(uint playerID, uint timestamp) onlyutils {
304         players[playerID].lastTimestamp = timestamp;
305     }
306     
307     function setBuilding(uint cityID, uint buildingType) onlyutils {
308         cities[cityID].buildings[buildingType] = true;
309         if(buildingType == 0) {
310             quarryCities.push(cityID);
311         } else if(buildingType == 1) {
312             farmCities.push(cityID);
313         } else if(buildingType == 2) {
314             woodworksCities.push(cityID);
315         } else if(buildingType == 3) {
316             metalworksCities.push(cityID);
317         } else if(buildingType == 4) {
318             stablesCities.push(cityID);
319         }
320     }
321     
322     function pushCity() onlyutils {
323         city.buildings[0] = false;
324         city.buildings[1] = false;
325         cities.push(city);
326     }
327 
328 }