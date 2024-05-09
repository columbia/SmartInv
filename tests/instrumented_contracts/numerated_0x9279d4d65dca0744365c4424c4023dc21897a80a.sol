1 pragma solidity 0.4.19;
2 
3 contract EtherSpace {
4     // This contract was heavily inspired by EtherTanks/EtherArmy.
5     
6     address public owner;
7     
8     struct ShipProduct {
9         uint16 class; // 
10         uint256 startPrice; // initial price
11         uint256 currentPrice; // The current price. Changes every time someone buys this kind of ship
12         uint256 earning; // The amount of earning each owner of this ship gets when someone buys this type of ship
13         uint64 amount; // The amount of ships issued
14     }
15     
16     struct ShipEntity {
17         uint16 model;
18         address owner; // The address of the owner of this ship
19         uint64 lastCashoutIndex; // Last amount existing in the game with the same ProductID
20         bool battle;
21         uint32 battleWins;
22         uint32 battleLosses;
23     }
24     
25     // event EventProduct (
26     //     uint16 model,
27     //     uint16 class,
28     //     uint256 price,
29     //     uint256 earning,
30     //     uint256 currentTime
31     // ); 
32     
33     event EventCashOut (
34         address indexed player,
35         uint256 amount
36     );
37         
38     event EventBuyShip (
39         address indexed player,
40         uint16 productID,
41         uint64 shipID
42     );
43     
44     event EventAddToBattle (
45         address indexed player,
46         uint64 id
47     );
48     event EventRemoveFromBattle (
49         address indexed player,
50         uint64 id
51     );
52     event EventBattle (
53         address indexed player,
54         uint64 id,
55         uint64 idToAttack,
56         uint64 idWinner
57     );
58         
59     function EtherSpace() public {
60         owner = msg.sender;
61         
62         newShipProduct(0,   50000000000000000,   500000000000000); // 0.05, 0.0005
63         newShipProduct(0,   70000000000000000,   700000000000000); // 0.07, 0.0007
64         newShipProduct(0,   70000000000000000,   700000000000000); // 0.07, 0.0007
65         newShipProduct(0,   70000000000000000,   700000000000000); // 0.07, 0.0007
66         newShipProduct(0,  100000000000000000,  1000000000000000); // 0.10, 0.0010
67         newShipProduct(0,  100000000000000000,  1000000000000000); // 0.10, 0.0010
68         newShipProduct(0,  300000000000000000,  3000000000000000); // 0.30, 0.0030
69         newShipProduct(0,  300000000000000000,  3000000000000000); // 0.30, 0.0030
70         newShipProduct(0,  500000000000000000,  5000000000000000); // 0.50, 0.0050
71         newShipProduct(0,  500000000000000000,  5000000000000000); // 0.50, 0.0050
72         newShipProduct(0,  700000000000000000,  7000000000000000); // 0.70, 0.0070
73         newShipProduct(0,  700000000000000000,  7000000000000000); // 0.70, 0.0070
74         newShipProduct(0,  750000000000000000,  7500000000000000); // 0.75, 0.0075
75         newShipProduct(0, 1000000000000000000, 10000000000000000); // 1.00, 0.0100
76         newShipProduct(0, 2300000000000000000, 23000000000000000); // 2.30, 0.0230
77     }
78     
79     uint64 public newIdShip = 0; // The next ID for the new ship
80     uint16 public newModelShipProduct = 0; // The next model when creating ships
81     mapping (uint64 => ShipEntity) public ships; // The storage 
82     mapping (uint16 => ShipProduct) shipProducts;
83     mapping (address => uint64[]) shipOwners;
84     mapping (address => uint) balances;
85     
86     function newShipProduct (uint16 _class, uint256 _price, uint256 _earning) private {
87         shipProducts[newModelShipProduct++] = ShipProduct(_class, _price, _price, _earning, 0);
88         
89         // EventProduct (newModelShipProduct-1, _class, _price, _earning, now);
90     }
91     
92     function cashOut () public payable { // shouldnt be payable
93         uint _balance = balances[msg.sender];
94         
95         for (uint64 index=0; index<shipOwners[msg.sender].length; index++) {
96             uint64 id = shipOwners[msg.sender][index]; // entity id
97             uint16 model = ships[id].model; // product model id
98             
99             _balance += shipProducts[model].earning * (shipProducts[model].amount - ships[id].lastCashoutIndex);
100 
101             ships[id].lastCashoutIndex = shipProducts[model].amount;
102         }
103         
104         require (this.balance >= _balance); // Checking if this contract has enought money to pay
105         
106         balances[msg.sender] = 0;
107         msg.sender.transfer(_balance);
108         
109         EventCashOut (msg.sender, _balance);
110         return;
111     }
112     
113     function buyShip (uint16 _shipModel) public payable {
114         require (msg.value >= shipProducts[_shipModel].currentPrice); //value is higher than price
115         require (shipOwners[msg.sender].length <= 10); // max 10 ships allowed per player
116 
117         if (msg.value > shipProducts[_shipModel].currentPrice){
118             // If player payed more, put the rest amount of money on his balance
119             balances[msg.sender] += msg.value - shipProducts[_shipModel].currentPrice;
120         }
121         
122         shipProducts[_shipModel].currentPrice += shipProducts[_shipModel].earning;
123     
124         ships[newIdShip++] = ShipEntity(_shipModel, msg.sender, ++shipProducts[_shipModel].amount, false, 0, 0);
125 
126         shipOwners[msg.sender].push(newIdShip-1);
127 
128         // After all owners of the same type of ship got their earnings, admins get the amount which remains and no one need it
129         // Basically, it is the start price of the ship.
130         balances[owner] += shipProducts[_shipModel].startPrice;
131         
132         EventBuyShip (msg.sender, _shipModel, newIdShip-1);
133         return;
134     }
135     
136     // Management
137     function newShip (uint16 _class, uint256 _price, uint256 _earning) public {
138         require (owner == msg.sender);
139         
140         shipProducts[newModelShipProduct++] = ShipProduct(_class, _price, _price, _earning, 0);
141     }
142     
143     function changeOwner(address _newOwner) public {
144         require (owner == msg.sender);
145         
146         owner = _newOwner;
147     }
148     
149     // Battle Functions
150     
151     uint battleStake = 50000000000000000; // 0.05
152     uint battleFee = 5000000000000000; // 0.005 or 5%
153     
154     uint nonce = 0;
155     function rand(uint min, uint max) public returns (uint){
156         nonce++;
157         return uint(sha3(nonce+uint256(block.blockhash(block.number-1))))%(min+max+1)-min;
158     }
159     
160     function addToBattle(uint64 _id) public payable {
161         require (msg.value == battleStake); // must pay exactly the battle stake
162         require (msg.sender == ships[_id].owner); // must be the owner
163         
164         ships[_id].battle = true;
165         
166         EventAddToBattle(msg.sender, _id);
167     }
168     function removeFromBattle(uint64 _id) public {
169         require (msg.sender == ships[_id].owner); // must be the owner
170         
171         ships[_id].battle = false;
172         balances[msg.sender] += battleStake;
173         
174         EventRemoveFromBattle(msg.sender, _id);
175     }
176     
177     function battle(uint64 _id, uint64 _idToAttack) public payable {
178         require (msg.sender == ships[_id].owner); // must be the owner
179         require (msg.value == battleStake); // must pay exactly the battle stake
180         require (ships[_idToAttack].battle == true); // ship to attack must be in battle mode
181         require (ships[_id].battle == false); // attacking ship must not be offered for battle
182         
183         uint randNumber = rand(0,1);
184         
185         if (randNumber == 1) {
186             ships[_id].battleWins++;
187             ships[_idToAttack].battleLosses++;
188             
189             balances[ships[_id].owner] += (battleStake * 2) - battleFee;
190             
191             EventBattle(msg.sender, _id, _idToAttack, _id);
192             
193         } else {
194             ships[_id].battleLosses++;
195             ships[_idToAttack].battleWins++;
196             
197             balances[ships[_idToAttack].owner] += (battleStake * 2) - battleFee;
198             
199             EventBattle(msg.sender, _id, _idToAttack, _idToAttack);
200         }
201         
202         balances[owner] += battleFee;
203         
204         ships[_idToAttack].battle = false;
205     }
206     
207     // UI Functions
208     function getPlayerShipModelById(uint64 _id) public constant returns (uint16) {
209         return ships[_id].model;
210     }
211     function getPlayerShipOwnerById(uint64 _id) public constant returns (address) {
212         return ships[_id].owner;
213     }
214     function getPlayerShipBattleById(uint64 _id) public constant returns (bool) {
215         return ships[_id].battle;
216     }
217     function getPlayerShipBattleWinsById(uint64 _id) public constant returns (uint32) {
218         return ships[_id].battleWins;
219     }
220     function getPlayerShipBattleLossesById(uint64 _id) public constant returns (uint32) {
221         return ships[_id].battleLosses;
222     }
223     
224     function getPlayerShipCount(address _player) public constant returns (uint) {
225         return shipOwners[_player].length;
226     }
227     
228     function getPlayerShipModelByIndex(address _player, uint index) public constant returns (uint16) {
229         return ships[shipOwners[_player][index]].model;
230     }
231     
232     function getPlayerShips(address _player) public constant returns (uint64[]) {
233         return shipOwners[_player];
234     }
235     
236     function getPlayerBalance(address _player) public constant returns (uint256) {
237         uint _balance = balances[_player];
238         
239         for (uint64 index=0; index<shipOwners[_player].length; index++) {
240             uint64 id = shipOwners[_player][index]; // entity id
241             uint16 model = ships[id].model; // product model id
242 
243             _balance += shipProducts[model].earning * (shipProducts[model].amount - ships[id].lastCashoutIndex);
244         }
245         
246         return _balance;
247     }
248     
249     function getShipProductClassByModel(uint16 _model) public constant returns (uint16) {
250         return shipProducts[_model].class;
251     }
252     function getShipProductStartPriceByModel(uint16 _model) public constant returns (uint256) {
253         return shipProducts[_model].startPrice;
254     }
255     function getShipProductCurrentPriceByModel(uint16 _model) public constant returns (uint256) {
256         return shipProducts[_model].currentPrice;
257     }
258     function getShipProductEarningByModel(uint16 _model) public constant returns (uint256) {
259         return shipProducts[_model].earning;
260     }
261     function getShipProductAmountByModel(uint16 _model) public constant returns (uint64) {
262         return shipProducts[_model].amount;
263     }
264     
265     function getShipProductCount() public constant returns (uint16) {
266         return newModelShipProduct;
267     }
268     function getShipCount() public constant returns (uint64) {
269         return newIdShip;
270     }
271 }