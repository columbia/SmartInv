1 pragma solidity ^0.4.18;
2 
3 contract KryptoArmy {
4 
5     address ceoAddress = 0x46d9112533ef677059c430E515775e358888e38b;
6     address cfoAddress = 0x23a49A9930f5b562c6B1096C3e6b5BEc133E8B2E;
7 
8     modifier onlyCeo() {
9         require (msg.sender == ceoAddress);
10         _;
11     }
12 
13     // Struct for Army
14     struct Army {
15         string name;            // The name of the army (invented by the user)
16         string idArmy;          // The id of the army (USA for United States)
17         uint experiencePoints;  // The experience points of the army, we will use this to handle
18         uint256 price;          // The cost of the Army in Wei (1 ETH = 1000000000000000000 Wei) 
19         uint attackBonus;       // The attack bonus for the soldiers (from 0 to 10)
20         uint defenseBonus;      // The defense bonus for the soldiers (from 0 to 10)
21         bool isForSale;         // User is selling this army, it can be purchase on the marketplace
22         address ownerAddress;   // The address of the owner
23         uint soldiersCount;     // The count of all the soldiers in this army
24     } 
25     Army[] armies;
26     
27     // Struct for Battles
28     struct Battle {
29         uint idArmyAttacking;   // The id of the army attacking
30         uint idArmyDefensing;   // The id of the army defensing
31         uint idArmyVictorious;  // The id of the winning army
32     } 
33 
34     Battle[] battles;
35 
36     // Mapping army
37     mapping (address => uint) public ownerToArmy;       // Which army does this address own
38     mapping (address => uint) public ownerArmyCount;    // How many armies own this address?
39 
40     // Mapping weapons to army
41     mapping (uint => uint) public armyDronesCount;
42     mapping (uint => uint) public armyPlanesCount;
43     mapping (uint => uint) public armyHelicoptersCount;
44     mapping (uint => uint) public armyTanksCount;
45     mapping (uint => uint) public armyAircraftCarriersCount;
46     mapping (uint => uint) public armySubmarinesCount;
47     mapping (uint => uint) public armySatelitesCount;
48 
49     // Mapping battles
50     mapping (uint => uint) public armyCountBattlesWon;
51     mapping (uint => uint) public armyCountBattlesLost;
52 
53     // This function creates a new army and saves it in the array with its parameters
54     function _createArmy(string _name, string _idArmy, uint _price, uint _attackBonus, uint _defenseBonus) public onlyCeo {
55 
56         // We add the new army to the list and save the id in a variable 
57         armies.push(Army(_name, _idArmy, 0, _price, _attackBonus, _defenseBonus, true, address(this), 0));
58     }
59 
60     // We use this function to purchase an army with Metamask
61     function purchaseArmy(uint _armyId) public payable {
62         // We verify that the value paid is equal to the cost of the army
63         require(msg.value == armies[_armyId].price);
64         require(msg.value > 0);
65         
66         // We check if this army is owned by another user
67         if(armies[_armyId].ownerAddress != address(this)) {
68             uint CommissionOwnerValue = msg.value - (msg.value / 10);
69             armies[_armyId].ownerAddress.transfer(CommissionOwnerValue);
70         }
71 
72         // We modify the ownership of the army
73         _ownershipArmy(_armyId);
74     }
75 
76     // Function to purchase a soldier
77     function purchaseSoldiers(uint _armyId, uint _countSoldiers) public payable {
78         // Check that message value > 0
79         require(msg.value > 0);
80         uint256 msgValue = msg.value;
81 
82         if(msgValue == 1000000000000000 && _countSoldiers == 1) {
83             // Increment soldiers count in army
84             armies[_armyId].soldiersCount = armies[_armyId].soldiersCount + _countSoldiers;
85         } else if(msgValue == 8000000000000000 && _countSoldiers == 10) {
86             // Increment soldiers count in army
87             armies[_armyId].soldiersCount = armies[_armyId].soldiersCount + _countSoldiers;
88         } else if(msgValue == 65000000000000000 && _countSoldiers == 100) {
89             // Increment soldiers count in army
90             armies[_armyId].soldiersCount = armies[_armyId].soldiersCount + _countSoldiers;
91         } else if(msgValue == 500000000000000000 && _countSoldiers == 1000) {
92             // Increment soldiers count in army
93             armies[_armyId].soldiersCount = armies[_armyId].soldiersCount + _countSoldiers;
94         }
95     }
96 
97     // Payable function to purchase weapons
98     function purchaseWeapons(uint _armyId, uint _weaponId, uint _bonusAttack, uint _bonusDefense ) public payable {
99         // Check that message value > 0
100         uint isValid = 0;
101         uint256 msgValue = msg.value;
102 
103         if(msgValue == 10000000000000000 && _weaponId == 0) {
104             armyDronesCount[_armyId]++;
105             isValid = 1;
106         } else if(msgValue == 25000000000000000 && _weaponId == 1) {
107              armyPlanesCount[_armyId]++;
108             isValid = 1;
109         } else if(msgValue == 25000000000000000 && _weaponId == 2) {
110             armyHelicoptersCount[_armyId]++;
111             isValid = 1;
112         } else if(msgValue == 45000000000000000 && _weaponId == 3) {
113             armyTanksCount[_armyId]++;
114             isValid = 1;
115         } else if(msgValue == 100000000000000000 && _weaponId == 4) {
116             armyAircraftCarriersCount[_armyId]++;
117             isValid = 1;
118         } else if(msgValue == 100000000000000000 && _weaponId == 5) {
119             armySubmarinesCount[_armyId]++;
120             isValid = 1;
121         } else if(msgValue == 120000000000000000 && _weaponId == 6) {
122             armySatelitesCount[_armyId]++;
123             isValid = 1;
124         } 
125 
126         // We check if the data has been verified as valid
127         if(isValid == 1) {
128             armies[_armyId].attackBonus = armies[_armyId].attackBonus + _bonusAttack;
129             armies[_armyId].defenseBonus = armies[_armyId].defenseBonus + _bonusDefense;
130         }
131     }
132 
133     // We use this function to affect an army to an address (when someone purchase an army)
134     function _ownershipArmy(uint armyId) private {
135 
136         // We check if the sender already own an army
137         require (ownerArmyCount[msg.sender] == 0);
138 
139         // If this army has alreay been purchased we verify that the owner put it on sale
140         require(armies[armyId].isForSale == true);
141         
142         // We check one more time that the price paid is the price of the army
143         require(armies[armyId].price == msg.value);
144 
145         // We decrement the army count for the previous owner (in case a user is selling army on marketplace)
146         ownerArmyCount[armies[armyId].ownerAddress]--;
147         
148         // We set the new army owner
149         armies[armyId].ownerAddress = msg.sender;
150         ownerToArmy[msg.sender] = armyId;
151 
152         // We increment the army count for this address
153         ownerArmyCount[msg.sender]++;
154 
155         // Send event for new ownership
156         armies[armyId].isForSale = false;
157     }
158 
159     // We use this function to start a new battle
160     function startNewBattle(uint _idArmyAttacking, uint _idArmyDefensing, uint _randomIndicatorAttack, uint _randomIndicatorDefense) public returns(uint) {
161 
162         // We verify that the army attacking is the army of msg.sender
163         require (armies[_idArmyAttacking].ownerAddress == msg.sender);
164 
165         // Get details for army attacking
166         uint ScoreAttack = armies[_idArmyAttacking].attackBonus * (armies[_idArmyAttacking].soldiersCount/3) + armies[_idArmyAttacking].soldiersCount  + _randomIndicatorAttack; 
167 
168         // Get details for army defending
169         uint ScoreDefense = armies[_idArmyAttacking].defenseBonus * (armies[_idArmyDefensing].soldiersCount/2) + armies[_idArmyDefensing].soldiersCount + _randomIndicatorDefense; 
170 
171         uint VictoriousArmy;
172         uint ExperiencePointsGained;
173         if(ScoreDefense >= ScoreAttack) {
174             VictoriousArmy = _idArmyDefensing;
175             ExperiencePointsGained = armies[_idArmyAttacking].attackBonus + 2;
176             armies[_idArmyDefensing].experiencePoints = armies[_idArmyDefensing].experiencePoints + ExperiencePointsGained;
177 
178             // Increment mapping battles won
179             armyCountBattlesWon[_idArmyDefensing]++;
180             armyCountBattlesLost[_idArmyAttacking]++;
181         } else {
182             VictoriousArmy = _idArmyAttacking;
183             ExperiencePointsGained = armies[_idArmyDefensing].defenseBonus + 2;
184             armies[_idArmyAttacking].experiencePoints = armies[_idArmyAttacking].experiencePoints + ExperiencePointsGained;
185 
186             // Increment mapping battles won
187             armyCountBattlesWon[_idArmyAttacking]++;
188             armyCountBattlesLost[_idArmyDefensing]++;
189         }
190         
191         // We add the new battle to the blockchain and save its id in a variable 
192         battles.push(Battle(_idArmyAttacking, _idArmyDefensing, VictoriousArmy));  
193         
194         // Send event
195         return (VictoriousArmy);
196     }
197 
198     // Owner can sell army
199     function ownerSellArmy(uint _armyId, uint256 _amount) public {
200         // We close the function if the user calling this function doesn't own the army
201         require (armies[_armyId].ownerAddress == msg.sender);
202         require (_amount > 0);
203         require (armies[_armyId].isForSale == false);
204 
205         armies[_armyId].isForSale = true;
206         armies[_armyId].price = _amount;
207     }
208     
209     // Owner remove army from marketplace
210     function ownerCancelArmyMarketplace(uint _armyId) public {
211         require (armies[_armyId].ownerAddress == msg.sender);
212         require (armies[_armyId].isForSale == true);
213         armies[_armyId].isForSale = false;
214     }
215 
216     // Function to return all the value of an army
217     function getArmyFullData(uint armyId) public view returns(string, string, uint, uint256, uint, uint, bool) {
218         string storage ArmyName = armies[armyId].name;
219         string storage ArmyId = armies[armyId].idArmy;
220         uint ArmyExperiencePoints = armies[armyId].experiencePoints;
221         uint256 ArmyPrice = armies[armyId].price;
222         uint ArmyAttack = armies[armyId].attackBonus;
223         uint ArmyDefense = armies[armyId].defenseBonus;
224         bool ArmyIsForSale = armies[armyId].isForSale;
225         return (ArmyName, ArmyId, ArmyExperiencePoints, ArmyPrice, ArmyAttack, ArmyDefense, ArmyIsForSale);
226     }
227 
228     // Function to return the owner of the army
229     function getArmyOwner(uint armyId) public view returns(address, bool) {
230         return (armies[armyId].ownerAddress, armies[armyId].isForSale);
231     }
232 
233     // Function to return the owner of the army
234     function getSenderArmyDetails() public view returns(uint, string) {
235         uint ArmyId = ownerToArmy[msg.sender];
236         string storage ArmyName = armies[ArmyId].name;
237         return (ArmyId, ArmyName);
238     }
239     
240     // Function to return the owner army count
241     function getSenderArmyCount() public view returns(uint) {
242         uint ArmiesCount = ownerArmyCount[msg.sender];
243         return (ArmiesCount);
244     }
245 
246     // Function to return the soldiers count of an army
247     function getArmySoldiersCount(uint armyId) public view returns(uint) {
248         uint SoldiersCount = armies[armyId].soldiersCount;
249         return (SoldiersCount);
250     }
251 
252     // Return an array with the weapons of the army
253     function getWeaponsArmy1(uint armyId) public view returns(uint, uint, uint, uint)  {
254         uint CountDrones = armyDronesCount[armyId];
255         uint CountPlanes = armyPlanesCount[armyId];
256         uint CountHelicopters = armyHelicoptersCount[armyId];
257         uint CountTanks = armyTanksCount[armyId];
258         return (CountDrones, CountPlanes, CountHelicopters, CountTanks);
259     }
260     function getWeaponsArmy2(uint armyId) public view returns(uint, uint, uint)  {
261         uint CountAircraftCarriers = armyAircraftCarriersCount[armyId];
262         uint CountSubmarines = armySubmarinesCount[armyId];
263         uint CountSatelites = armySatelitesCount[armyId];
264         return (CountAircraftCarriers, CountSubmarines, CountSatelites);
265     }
266 
267     // Retrieve count battles won
268     function getArmyBattles(uint _armyId) public view returns(uint, uint) {
269         return (armyCountBattlesWon[_armyId], armyCountBattlesLost[_armyId]);
270     }
271     
272     // Retrieve the details of a battle
273     function getDetailsBattles(uint battleId) public view returns(uint, uint, uint, string, string) {
274         return (battles[battleId].idArmyAttacking, battles[battleId].idArmyDefensing, battles[battleId].idArmyVictorious, armies[battles[battleId].idArmyAttacking].idArmy, armies[battles[battleId].idArmyDefensing].idArmy);
275     }
276     
277     // Get battles count
278     function getBattlesCount() public view returns(uint) {
279         return (battles.length);
280     }
281 
282     // To withdraw fund from this contract
283     function withdraw(uint amount, uint who) public onlyCeo returns(bool) {
284         require(amount <= this.balance);
285         if(who == 0) {
286             ceoAddress.transfer(amount);
287         } else {
288             cfoAddress.transfer(amount);
289         }
290         
291         return true;
292     }
293     
294     // Initial function to create the 100 armies with their attributes
295     function KryptoArmy() public onlyCeo {
296 
297       // 1. USA
298         _createArmy("United States", "USA", 550000000000000000, 8, 9);
299 
300         // 2. North Korea
301         _createArmy("North Korea", "NK", 500000000000000000, 10, 5);
302 
303         // 3. Russia
304         _createArmy("Russia", "RUS", 450000000000000000, 8, 7);
305 
306         // 4. China
307         _createArmy("China", "CHN", 450000000000000000, 7, 8);
308 
309         // 5. Japan
310         _createArmy("Japan", "JPN", 420000000000000000, 7, 7);
311 
312         // 6. France
313         _createArmy("France", "FRA", 400000000000000000, 6, 8);
314 
315         // 7. Germany
316         _createArmy("Germany", "GER", 400000000000000000, 7, 6);
317 
318         // 8. India
319         _createArmy("India", "IND", 400000000000000000, 7, 6);
320 
321         // 9. United Kingdom
322         _createArmy("United Kingdom", "UK", 350000000000000000, 5, 7);
323 
324         // 10. South Korea
325         _createArmy("South Korea", "SK", 350000000000000000, 6, 6);
326 
327         // 11. Turkey
328         _createArmy("Turkey", "TUR", 300000000000000000, 7, 4);
329 
330         // 12. Italy
331         //_createArmy("Italy", "ITA", 280000000000000000, 5, 5);
332     }
333 }