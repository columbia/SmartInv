1 pragma solidity ^0.4.13;
2 
3 contract AbstractDatabase
4 {
5     function() public payable;
6     function ChangeOwner(address new_owner) public;
7     function ChangeOwner2(address new_owner) public;
8     function Store(address user, uint256 category, uint256 slot, bytes32 data) public;
9     function Load(address user, uint256 category, uint256 index) public view returns (bytes32);
10     function TransferFunds(address target, uint256 transfer_amount) public;
11 }
12 
13 contract AbstractGameHidden
14 {
15     function CalculateFinalDistance(bytes32 raw0, bytes32 raw1, bytes32 raw2, bytes32 raw3) pure public returns (int64, int64, uint64);
16 }
17 
18 library CompetitionScoreTypes
19 {
20     using Serializer for Serializer.DataComponent;
21 
22     struct CompetitionScore
23     {
24         address m_Owner; // 0
25         uint64 m_Distance; // 20
26         uint32 m_RocketId; // 28
27     }
28 
29     function SerializeCompetitionScore(CompetitionScore score) internal pure returns (bytes32)
30     {
31         Serializer.DataComponent memory data;
32         data.WriteAddress(0, score.m_Owner);
33         data.WriteUint64(20, score.m_Distance);
34         data.WriteUint32(28, score.m_RocketId);
35         return data.m_Raw;
36     }
37 
38     function DeserializeCompetitionScore(bytes32 raw) internal pure returns (CompetitionScore)
39     {
40         CompetitionScore memory score;
41 
42         Serializer.DataComponent memory data;
43         data.m_Raw = raw;
44 
45         score.m_Owner = data.ReadAddress(0);
46         score.m_Distance = data.ReadUint64(20);
47         score.m_RocketId = data.ReadUint32(28);
48 
49         return score;
50     }
51 }
52 
53 contract Game
54 {
55     using GlobalTypes for GlobalTypes.Global;
56     using MarketTypes for MarketTypes.MarketListing;
57     using MissionParametersTypes for MissionParametersTypes.MissionParameters;
58     using GameCommon for GameCommon.LaunchRocketStackFrame;
59 
60     address public m_Owner;
61     AbstractDatabase public m_Database;
62     AbstractGameHidden public m_GameHidden;
63     bool public m_Paused;
64 
65     uint256 constant GlobalCategory = 0;
66     uint256 constant RocketCategory = 1;
67     uint256 constant OwnershipCategory = 2;
68     uint256 constant InventoryCategory = 3;
69     uint256 constant MarketCategory = 4;
70     uint256 constant ProfitFundsCategory = 5;
71     uint256 constant CompetitionFundsCategory = 6;
72     uint256 constant MissionParametersCategory = 7;
73     uint256 constant CompetitionScoresCategory = 8;
74     uint256 constant WithdrawalFundsCategory = 9;
75     uint256 constant ReferralCategory = 10;
76     uint256 constant RocketStockCategory = 11;
77     uint256 constant RocketStockInitializedCategory = 12;
78 
79     address constant NullAddress = 0;
80     uint256 constant MaxCompetitionScores = 10;
81 
82     mapping(uint32 => RocketTypes.StockRocket) m_InitialRockets;
83 
84     modifier OnlyOwner()
85     {
86         require(msg.sender == m_Owner);
87 
88         _;
89     }
90 
91     modifier NotWhilePaused()
92     {
93         require(m_Paused == false);
94 
95         _;
96     }
97 
98     function Game() public
99     {
100         m_Owner = msg.sender;
101         m_Paused = true;
102     }
103 
104     event BuyStockRocketEvent(address indexed buyer, uint32 stock_id, uint32 rocket_id, address referrer);
105     event PlaceRocketForSaleEvent(address indexed seller, uint32 rocket_id, uint80 price);
106     event RemoveRocketForSaleEvent(address indexed seller, uint32 rocket_id);
107     event BuyRocketForSaleEvent(address indexed buyer, address indexed seller, uint32 rocket_id);
108     event LaunchRocketEvent(address indexed launcher, uint32 competition_id, int64 leo_displacement, int64 planet_displacement);
109     event StartCompetitionEvent(uint32 competition_id);
110     event FinishCompetitionEvent(uint32 competition_id);
111 
112     function ChangeOwner(address new_owner) public OnlyOwner()
113     {
114         m_Owner = new_owner;
115     }
116 
117     function ChangeDatabase(address db) public OnlyOwner()
118     {
119         m_Database = AbstractDatabase(db);
120     }
121 
122     function ChangeGameHidden(address hidden) public OnlyOwner()
123     {
124         m_GameHidden = AbstractGameHidden(hidden);
125     }
126 
127     function Unpause() public OnlyOwner()
128     {
129         m_Paused = false;
130     }
131 
132     function Pause() public OnlyOwner()
133     {
134         require(m_Paused == false);
135 
136         m_Paused = true;
137     }
138 
139     function IsPaused() public view returns (bool)
140     {
141         return m_Paused;
142     }
143 
144     // 1 write
145     function WithdrawProfitFunds(uint256 withdraw_amount, address beneficiary) public NotWhilePaused() OnlyOwner()
146     {
147         uint256 profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
148 
149         require(withdraw_amount > 0);
150         require(withdraw_amount <= profit_funds);
151         require(beneficiary != address(0));
152         require(beneficiary != address(this));
153         require(beneficiary != address(m_Database));
154 
155         profit_funds -= withdraw_amount;
156 
157         m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds));
158 
159         m_Database.TransferFunds(beneficiary, withdraw_amount);
160     }
161 
162     // 1 write
163     function WithdrawWinnings(uint256 withdraw_amount) public NotWhilePaused()
164     {
165         require(withdraw_amount > 0);
166 
167         uint256 withdrawal_funds = uint256(m_Database.Load(msg.sender, WithdrawalFundsCategory, 0));
168         require(withdraw_amount <= withdrawal_funds);
169 
170         withdrawal_funds -= withdraw_amount;
171 
172         m_Database.Store(msg.sender, WithdrawalFundsCategory, 0, bytes32(withdrawal_funds));
173 
174         m_Database.TransferFunds(msg.sender, withdraw_amount);
175     }
176 
177     function GetRocket(uint32 rocket_id) view public returns (bool is_valid, uint32 top_speed, uint32 thrust, uint32 weight, uint32 fuel_capacity, uint16 stock_id, uint64 max_distance, bool is_for_sale, address owner)
178     {
179         RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
180 
181         is_valid = rocket.m_Version >= 1;
182         is_for_sale = rocket.m_IsForSale == 1;
183         top_speed = rocket.m_TopSpeed;
184         thrust = rocket.m_Thrust;
185         weight = rocket.m_Weight;
186         fuel_capacity = rocket.m_FuelCapacity;
187         stock_id = rocket.m_StockId;
188         max_distance = rocket.m_MaxDistance;
189 
190         owner = GetRocketOwner(rocket_id);
191     }
192 
193     function GetWithdrawalFunds(address target) view public NotWhilePaused() returns (uint256 funds)
194     {
195         funds = uint256(m_Database.Load(target, WithdrawalFundsCategory, 0));
196     }
197 
198     function GetProfitFunds() view public OnlyOwner() returns (uint256 funds)
199     {
200         uint256 profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
201         return profit_funds;
202     }
203 
204     function GetCompetitionFunds(uint32 competition_id) view public returns (uint256 funds)
205     {
206         return uint256(m_Database.Load(NullAddress, CompetitionFundsCategory, competition_id));
207     }
208 
209     function GetRocketOwner(uint32 rocket_id) view internal returns (address owner)
210     {
211         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
212         owner = ownership.m_Owner;
213     }
214 
215     function GetAuction(uint32 rocket_id) view public returns (bool is_for_sale, address owner, uint80 price)
216     {
217         RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
218         is_for_sale = rocket.m_IsForSale == 1;
219 
220         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
221         owner = ownership.m_Owner;
222 
223         MarketTypes.MarketListing memory listing = MarketTypes.DeserializeMarketListing(m_Database.Load(NullAddress, MarketCategory, rocket_id));
224         price = listing.m_Price;
225     }
226 
227     function GetInventoryCount(address target) view public returns (uint256)
228     {
229         require(target != address(0));
230 
231         uint256 inventory_count = uint256(m_Database.Load(target, InventoryCategory, 0));
232 
233         return inventory_count;
234     }
235 
236     function GetInventory(address target, uint256 start_index) view public returns (uint32[8] rocket_ids)
237     {
238         require(target != address(0));
239 
240         uint256 inventory_count = GetInventoryCount(target);
241 
242         uint256 end = start_index + 8;
243         if (end > inventory_count)
244             end = inventory_count;
245 
246         for (uint256 i = start_index; i < end; i++)
247         {
248             rocket_ids[i - start_index] = uint32(uint256(m_Database.Load(target, InventoryCategory, i + 1)));
249         }
250     }
251 
252     // 1 write
253     function AddRocket(uint32 stock_id, uint64 cost, uint32 min_top_speed, uint32 max_top_speed, uint32 min_thrust, uint32 max_thrust, uint32 min_weight, uint32 max_weight, uint32 min_fuel_capacity, uint32 max_fuel_capacity, uint64 distance, uint32 max_stock) OnlyOwner() public
254     {
255         m_InitialRockets[stock_id] = RocketTypes.StockRocket({
256             m_IsValid: true,
257             m_Cost: cost,
258             m_MinTopSpeed: min_top_speed,
259             m_MaxTopSpeed: max_top_speed,
260             m_MinThrust: min_thrust,
261             m_MaxThrust: max_thrust,
262             m_MinWeight: min_weight,
263             m_MaxWeight: max_weight,
264             m_MinFuelCapacity: min_fuel_capacity,
265             m_MaxFuelCapacity: max_fuel_capacity,
266             m_Distance: distance
267         });
268 
269         min_top_speed = uint32(m_Database.Load(NullAddress, RocketStockInitializedCategory, stock_id));
270 
271         if (min_top_speed == 0)
272         {
273             m_Database.Store(NullAddress, RocketStockCategory, stock_id, bytes32(max_stock));
274             m_Database.Store(NullAddress, RocketStockInitializedCategory, stock_id, bytes32(1));
275         }
276     }
277 
278     function GetRocketStock(uint16 stock_id) public view returns (uint32)
279     {
280         return uint32(m_Database.Load(NullAddress, RocketStockCategory, stock_id));
281     }
282 
283     // 6 writes
284     function BuyStockRocket(uint16 stock_id, address referrer) payable NotWhilePaused() public
285     {
286         //require(referrer != msg.sender);
287         uint32 stock = GetRocketStock(stock_id);
288 
289         require(stock > 0);
290 
291         GiveRocketInternal(stock_id, msg.sender, true, referrer);
292 
293         stock--;
294 
295         m_Database.Store(NullAddress, RocketStockCategory, stock_id, bytes32(stock));
296     }
297 
298     function GiveReferralRocket(uint16 stock_id, address target) public NotWhilePaused() OnlyOwner()
299     {
300         uint256 already_received = uint256(m_Database.Load(target, ReferralCategory, 0));
301         require(already_received == 0);
302 
303         already_received = 1;
304         m_Database.Store(target, ReferralCategory, 0, bytes32(already_received));
305 
306         GiveRocketInternal(stock_id, target, false, address(0));
307     }
308 
309     function GiveRocketInternal(uint16 stock_id, address target, bool buying, address referrer) internal
310     {
311         RocketTypes.StockRocket storage stock_rocket = m_InitialRockets[stock_id];
312 
313         require(stock_rocket.m_IsValid);
314         if (buying)
315         {
316             require(msg.value == stock_rocket.m_Cost);
317         }
318 
319         GlobalTypes.Global memory global = GlobalTypes.DeserializeGlobal(m_Database.Load(NullAddress, GlobalCategory, 0));
320 
321         uint256 profit_funds = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
322 
323         global.m_LastRocketId++;
324         uint32 next_rocket_id = global.m_LastRocketId;
325 
326         uint256 inventory_count = GetInventoryCount(target);
327         inventory_count++;
328 
329         RocketTypes.Rocket memory rocket;
330         rocket.m_Version = 1;
331         rocket.m_StockId = stock_id;
332         rocket.m_IsForSale = 0;
333 
334         bytes32 rand = sha256(block.timestamp, block.coinbase, global.m_LastRocketId);
335 
336         // Fix LerpExtra calls in FinishCompetition if anything is added here
337         rocket.m_TopSpeed = uint32(Lerp(stock_rocket.m_MinTopSpeed, stock_rocket.m_MaxTopSpeed, rand[0]));
338         rocket.m_Thrust = uint32(Lerp(stock_rocket.m_MinThrust, stock_rocket.m_MaxThrust, rand[1]));
339         rocket.m_Weight = uint32(Lerp(stock_rocket.m_MinWeight, stock_rocket.m_MaxWeight, rand[2]));
340         rocket.m_FuelCapacity = uint32(Lerp(stock_rocket.m_MinFuelCapacity, stock_rocket.m_MaxFuelCapacity, rand[3]));
341         rocket.m_MaxDistance = uint64(stock_rocket.m_Distance);
342         //
343 
344         OwnershipTypes.Ownership memory ownership;
345         ownership.m_Owner = target;
346         ownership.m_OwnerInventoryIndex = uint32(inventory_count) - 1;
347 
348         profit_funds += msg.value;
349 
350         m_Database.Store(target, InventoryCategory, inventory_count, bytes32(next_rocket_id));
351         m_Database.Store(target, InventoryCategory, 0, bytes32(inventory_count));
352         m_Database.Store(NullAddress, RocketCategory, next_rocket_id, RocketTypes.SerializeRocket(rocket));
353         m_Database.Store(NullAddress, OwnershipCategory, next_rocket_id, OwnershipTypes.SerializeOwnership(ownership));
354         m_Database.Store(NullAddress, GlobalCategory, 0, GlobalTypes.SerializeGlobal(global));
355         if (buying)
356         {
357             m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds));
358 
359             m_Database.transfer(msg.value);
360         }
361         BuyStockRocketEvent(target, stock_id, next_rocket_id, referrer);
362     }
363 
364     // 2 writes
365     function PlaceRocketForSale(uint32 rocket_id, uint80 price) NotWhilePaused() public
366     {
367         RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
368         require(rocket.m_Version > 0);
369 
370         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
371         require(ownership.m_Owner == msg.sender);
372 
373         require(rocket.m_IsForSale == 0);
374 
375         MarketTypes.MarketListing memory listing;
376         listing.m_Price = price;
377 
378         rocket.m_IsForSale = 1;
379 
380         m_Database.Store(NullAddress, RocketCategory, rocket_id, RocketTypes.SerializeRocket(rocket));
381         m_Database.Store(NullAddress, MarketCategory, rocket_id, MarketTypes.SerializeMarketListing(listing));
382 
383         PlaceRocketForSaleEvent(msg.sender, rocket_id, price);
384     }
385 
386     // 1 write
387     function RemoveRocketForSale(uint32 rocket_id) NotWhilePaused() public
388     {
389         RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
390         require(rocket.m_Version > 0);
391         require(rocket.m_IsForSale == 1);
392 
393         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
394         require(ownership.m_Owner == msg.sender);
395 
396         rocket.m_IsForSale = 0;
397 
398         m_Database.Store(NullAddress, RocketCategory, rocket_id, RocketTypes.SerializeRocket(rocket));
399 
400         RemoveRocketForSaleEvent(msg.sender, rocket_id);
401     }
402 
403     // 9-11 writes
404     function BuyRocketForSale(uint32 rocket_id) payable NotWhilePaused() public
405     {
406         RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
407         require(rocket.m_Version > 0);
408 
409         require(rocket.m_IsForSale == 1);
410 
411         OwnershipTypes.Ownership memory ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
412         require(ownership.m_Owner != msg.sender);
413 
414         MarketTypes.MarketListing memory listing = MarketTypes.DeserializeMarketListing(m_Database.Load(NullAddress, MarketCategory, rocket_id));
415         require(msg.value == listing.m_Price);
416 
417         uint256 seller_inventory_count = uint256(m_Database.Load(ownership.m_Owner, InventoryCategory, 0));
418         uint256 buyer_inventory_count = uint256(m_Database.Load(msg.sender, InventoryCategory, 0));
419 
420         uint256 profit_funds_or_last_rocket_id;
421         uint256 wei_for_profit_funds;
422         uint256 buyer_price_or_wei_for_seller = uint256(listing.m_Price);
423 
424         address beneficiary = ownership.m_Owner;
425         ownership.m_Owner = msg.sender;
426         rocket.m_IsForSale = 0;
427 
428         listing.m_Price = 0;
429 
430         buyer_inventory_count++;
431         profit_funds_or_last_rocket_id = uint256(m_Database.Load(beneficiary, InventoryCategory, seller_inventory_count));
432 
433         m_Database.Store(beneficiary, InventoryCategory, seller_inventory_count, bytes32(0));
434 
435         if (ownership.m_OwnerInventoryIndex + 1 != seller_inventory_count)
436         {
437             m_Database.Store(beneficiary, InventoryCategory, ownership.m_OwnerInventoryIndex + 1, bytes32(profit_funds_or_last_rocket_id));
438 
439             OwnershipTypes.Ownership memory last_rocket_ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, profit_funds_or_last_rocket_id));
440             last_rocket_ownership.m_OwnerInventoryIndex = uint32(ownership.m_OwnerInventoryIndex);
441 
442             m_Database.Store(NullAddress, OwnershipCategory, profit_funds_or_last_rocket_id, OwnershipTypes.SerializeOwnership(last_rocket_ownership));
443         }
444 
445         ownership.m_OwnerInventoryIndex = uint32(buyer_inventory_count);
446         m_Database.Store(msg.sender, InventoryCategory, buyer_inventory_count, bytes32(rocket_id));
447 
448         wei_for_profit_funds = buyer_price_or_wei_for_seller / 20;
449         buyer_price_or_wei_for_seller = buyer_price_or_wei_for_seller - wei_for_profit_funds;
450 
451         profit_funds_or_last_rocket_id = uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
452         profit_funds_or_last_rocket_id += wei_for_profit_funds;
453 
454         seller_inventory_count--;
455         m_Database.Store(msg.sender, InventoryCategory, 0, bytes32(buyer_inventory_count));
456         m_Database.Store(beneficiary, InventoryCategory, 0, bytes32(seller_inventory_count));
457 
458         m_Database.Store(NullAddress, OwnershipCategory, rocket_id, OwnershipTypes.SerializeOwnership(ownership));
459         m_Database.Store(NullAddress, RocketCategory, rocket_id, RocketTypes.SerializeRocket(rocket));
460         m_Database.Store(NullAddress, MarketCategory, rocket_id, MarketTypes.SerializeMarketListing(listing));
461         m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(profit_funds_or_last_rocket_id));
462 
463         buyer_price_or_wei_for_seller += uint256(m_Database.Load(beneficiary, WithdrawalFundsCategory, 0)); // Reuse variable
464         m_Database.Store(beneficiary, WithdrawalFundsCategory, 0, bytes32(buyer_price_or_wei_for_seller));
465 
466         m_Database.transfer(msg.value);
467         BuyRocketForSaleEvent(msg.sender, beneficiary, rocket_id);
468     }
469 
470     // 3 writes + 1-12 writes = 4-15 writes
471     function LaunchRocket(uint32 competition_id, uint32 rocket_id, uint32 launch_thrust, uint32 fuel_to_use, uint32 fuel_allocation_for_launch, uint32 stabilizer_setting) payable NotWhilePaused() public
472     {
473         GameCommon.LaunchRocketStackFrame memory stack;
474         stack.m_Rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, rocket_id));
475         stack.m_Mission =  MissionParametersTypes.DeserializeMissionParameters(m_Database.Load(NullAddress, MissionParametersCategory, competition_id));
476         stack.m_Ownership = OwnershipTypes.DeserializeOwnership(m_Database.Load(NullAddress, OwnershipCategory, rocket_id));
477 
478         require(stack.m_Mission.m_IsStarted == 1);
479         require(stack.m_Rocket.m_Version > 0);
480         require(stack.m_Rocket.m_IsForSale == 0);
481         require(msg.value == uint256(stack.m_Mission.m_LaunchCost));
482         require(stack.m_Ownership.m_Owner == msg.sender);
483         require(launch_thrust <= stack.m_Rocket.m_Thrust);
484 
485         stack.m_MissionWindSpeed = stack.m_Mission.m_WindSpeed;
486         stack.m_MissionLaunchLocation = stack.m_Mission.m_LaunchLocation;
487         stack.m_MissionWeatherType = stack.m_Mission.m_WeatherType;
488         stack.m_MissionWeatherCoverage = stack.m_Mission.m_WeatherCoverage;
489         stack.m_MissionTargetDistance = stack.m_Mission.m_TargetDistance;
490         stack.m_DebugExtraDistance = stack.m_Mission.m_DebugExtraDistance;
491 
492         stack.m_RocketTopSpeed = stack.m_Rocket.m_TopSpeed;
493         stack.m_RocketThrust = stack.m_Rocket.m_Thrust;
494         stack.m_RocketMass = stack.m_Rocket.m_Weight;
495         stack.m_RocketFuelCapacity = stack.m_Rocket.m_FuelCapacity;
496         stack.m_RocketMaxDistance = int64(stack.m_Rocket.m_MaxDistance);
497 
498         stack.m_CompetitionId = competition_id;
499         stack.m_RocketId = rocket_id;
500         stack.m_LaunchThrust = launch_thrust * 100 / stack.m_Rocket.m_Thrust;
501         stack.m_FuelToUse = fuel_to_use;
502         stack.m_FuelAllocationForLaunch = fuel_allocation_for_launch;
503         stack.m_StabilizerSetting = stabilizer_setting;
504         stack.m_Launcher = msg.sender;
505 
506         LaunchRocketInternal(stack);
507     }
508 
509     // 3 writes
510     function LaunchRocketInternal(GameCommon.LaunchRocketStackFrame memory stack) internal
511     {
512         stack.SerializeLaunchRocketStackFrame();
513 
514         (stack.m_DisplacementFromLowEarthOrbit, stack.m_DisplacementFromPlanet, stack.m_FinalDistance) = m_GameHidden.CalculateFinalDistance(
515             stack.m_Raw0,
516             stack.m_Raw1,
517             stack.m_Raw2,
518             stack.m_Raw3
519         );
520 
521         AddScore(stack);
522 
523         stack.m_ProfitFunds = msg.value / 10;
524         stack.m_CompetitionFunds = msg.value - stack.m_ProfitFunds;
525 
526         stack.m_ProfitFunds += uint256(m_Database.Load(NullAddress, ProfitFundsCategory, 0));
527         stack.m_CompetitionFunds += uint256(m_Database.Load(NullAddress, CompetitionFundsCategory, stack.m_CompetitionId));
528 
529         m_Database.Store(NullAddress, ProfitFundsCategory, 0, bytes32(stack.m_ProfitFunds));
530         m_Database.Store(NullAddress, CompetitionFundsCategory, stack.m_CompetitionId, bytes32(stack.m_CompetitionFunds));
531         m_Database.Store(NullAddress, MissionParametersCategory, stack.m_CompetitionId, stack.m_Mission.SerializeMissionParameters());
532 
533         m_Database.transfer(msg.value);
534         LaunchRocketEvent(msg.sender, stack.m_CompetitionId, stack.m_DisplacementFromLowEarthOrbit, stack.m_DisplacementFromPlanet);
535     }
536 
537     // 0-1 writes
538     function AddScore(GameCommon.LaunchRocketStackFrame memory stack) internal
539     {
540         CompetitionScoreTypes.CompetitionScore memory new_score;
541         new_score.m_Owner = stack.m_Launcher;
542         new_score.m_Distance = stack.m_FinalDistance;
543         new_score.m_RocketId = stack.m_RocketId;
544 
545         CompetitionScoreTypes.CompetitionScore memory score;
546 
547         for (uint32 i = 0; i < stack.m_Mission.m_ValidCompetitionScores; i++)
548         {
549             // Check if the new score is better than the score that this user already has (if they are in the top x)
550             score = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(stack.m_CompetitionId, CompetitionScoresCategory, i));
551 
552             if (score.m_Owner == stack.m_Launcher)
553             {
554                 if (stack.m_FinalDistance < score.m_Distance)
555                 {
556                     m_Database.Store(stack.m_CompetitionId, CompetitionScoresCategory, i, CompetitionScoreTypes.SerializeCompetitionScore(new_score));
557                 }
558                 return;
559             }
560         }
561 
562         if (stack.m_Mission.m_ValidCompetitionScores < MaxCompetitionScores)
563         {
564             // Not enough scores, so this one is automatically one of the best
565             m_Database.Store(stack.m_CompetitionId, CompetitionScoresCategory, stack.m_Mission.m_ValidCompetitionScores, CompetitionScoreTypes.SerializeCompetitionScore(new_score));
566 
567             stack.m_Mission.m_ValidCompetitionScores++;
568             return;
569         }
570 
571         uint64 highest_distance = 0;
572         uint32 highest_index = 0xFFFFFFFF;
573         for (i = 0; i < stack.m_Mission.m_ValidCompetitionScores; i++)
574         {
575             score = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(stack.m_CompetitionId, CompetitionScoresCategory, i));
576 
577             if (score.m_Distance > highest_distance)
578             {
579                 highest_distance = score.m_Distance;
580                 highest_index = i;
581             }
582         }
583 
584         if (highest_index != 0xFFFFFFFF)
585         {
586             score = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(stack.m_CompetitionId, CompetitionScoresCategory, highest_index));
587 
588             // Check if the new score is better than the highest score
589             if (stack.m_FinalDistance < score.m_Distance)
590             {
591                 m_Database.Store(stack.m_CompetitionId, CompetitionScoresCategory, highest_index, CompetitionScoreTypes.SerializeCompetitionScore(new_score));
592                 return;
593             }
594         }
595     }
596 
597     function GetCompetitionInfo(uint32 competition_id) view NotWhilePaused() public returns (bool in_progress, uint8 wind_speed, uint8 launch_location, uint8 weather_type, uint8 weather_coverage, uint80 launch_cost, uint32 target_distance)
598     {
599         MissionParametersTypes.MissionParameters memory parameters = MissionParametersTypes.DeserializeMissionParameters(m_Database.Load(NullAddress, MissionParametersCategory, competition_id));
600 
601         in_progress = parameters.m_IsStarted == 1;
602         wind_speed = parameters.m_WindSpeed;
603         launch_location = parameters.m_LaunchLocation;
604         weather_type = parameters.m_WeatherType;
605         weather_coverage = parameters.m_WeatherCoverage;
606         launch_cost = parameters.m_LaunchCost;
607         target_distance = parameters.m_TargetDistance;
608     }
609 
610     function SetDebugExtra(uint32 competition_id, uint8 extra) public OnlyOwner()
611     {
612         MissionParametersTypes.MissionParameters memory parameters = MissionParametersTypes.DeserializeMissionParameters(m_Database.Load(NullAddress, MissionParametersCategory, competition_id));
613 
614         parameters.m_DebugExtraDistance = extra;
615 
616         m_Database.Store(NullAddress, MissionParametersCategory, competition_id, parameters.SerializeMissionParameters());
617     }
618 
619     // 2 writes
620     function StartCompetition(uint8 wind_speed, uint8 launch_location, uint8 weather_type, uint8 weather_coverage, uint80 launch_cost, uint32 target_distance) public NotWhilePaused() OnlyOwner()
621     {
622         GlobalTypes.Global memory global = GlobalTypes.DeserializeGlobal(m_Database.Load(NullAddress, GlobalCategory, 0));
623 
624         MissionParametersTypes.MissionParameters memory parameters;
625         parameters.m_WindSpeed = wind_speed;
626         parameters.m_LaunchLocation = launch_location;
627         parameters.m_WeatherType = weather_type;
628         parameters.m_WeatherCoverage = weather_coverage;
629         parameters.m_LaunchCost = launch_cost;
630         parameters.m_TargetDistance = target_distance;
631         parameters.m_IsStarted = 1;
632 
633         global.m_CompetitionNumber++;
634 
635         uint32 competition_id = global.m_CompetitionNumber;
636 
637         m_Database.Store(NullAddress, MissionParametersCategory, competition_id, parameters.SerializeMissionParameters());
638         m_Database.Store(NullAddress, GlobalCategory, 0, GlobalTypes.SerializeGlobal(global));
639 
640         StartCompetitionEvent(competition_id);
641     }
642 
643     function GetCompetitionResults(uint32 competition_id, bool first_half) public view returns (address[], uint64[])
644     {
645         CompetitionScoreTypes.CompetitionScore memory score;
646 
647         uint256 offset = (first_half == true ? 0 : 5);
648         address[] memory winners = new address[](5);
649         uint64[] memory distances = new uint64[](5);
650 
651         for (uint32 i = 0; i < 5; i++)
652         {
653             score = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(competition_id, CompetitionScoresCategory, offset + i));
654             winners[i] = score.m_Owner;
655             distances[i] = score.m_Distance;
656         }
657 
658         return (winners, distances);
659     }
660 
661     function SortCompetitionScores(uint32 competition_id) public NotWhilePaused() OnlyOwner()
662     {
663         CompetitionScoreTypes.CompetitionScore[] memory scores;
664         MissionParametersTypes.MissionParameters memory parameters;
665 
666         (scores, parameters) = MakeAndSortCompetitionScores(competition_id);
667 
668         for (uint256 i = 0; i < parameters.m_ValidCompetitionScores; i++)
669         {
670             m_Database.Store(competition_id, CompetitionScoresCategory, i, CompetitionScoreTypes.SerializeCompetitionScore(scores[i]));
671         }
672     }
673 
674     function MakeAndSortCompetitionScores(uint32 competition_id) internal view returns (CompetitionScoreTypes.CompetitionScore[] memory scores, MissionParametersTypes.MissionParameters memory parameters)
675     {
676         parameters = MissionParametersTypes.DeserializeMissionParameters(m_Database.Load(NullAddress, MissionParametersCategory, competition_id));
677         scores = new CompetitionScoreTypes.CompetitionScore[](MaxCompetitionScores + 1);
678 
679         for (uint256 i = 0; i < parameters.m_ValidCompetitionScores; i++)
680         {
681             scores[i] = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(competition_id, CompetitionScoresCategory, i));
682         }
683 
684         BubbleSort(scores, parameters.m_ValidCompetitionScores);
685     }
686 
687     // 22 writes (full competition)
688     function FinishCompetition(uint32 competition_id) public NotWhilePaused() OnlyOwner()
689     {
690         CompetitionScoreTypes.CompetitionScore[] memory scores;
691         MissionParametersTypes.MissionParameters memory parameters;
692 
693         (scores, parameters) = MakeAndSortCompetitionScores(competition_id);
694 
695         require(parameters.m_IsStarted == 1);
696 
697         parameters.m_IsStarted = 0;
698 
699         uint256 original_competition_funds = uint256(m_Database.Load(NullAddress, CompetitionFundsCategory, competition_id));
700         uint256 competition_funds_remaining = original_competition_funds;
701 
702         for (uint256 i = 0; i < parameters.m_ValidCompetitionScores; i++)
703         {
704             RocketTypes.Rocket memory rocket = RocketTypes.DeserializeRocket(m_Database.Load(NullAddress, RocketCategory, scores[i].m_RocketId));
705             RocketTypes.StockRocket storage stock_rocket = m_InitialRockets[rocket.m_StockId];
706 
707             // Fix Lerps in BuyStockRocket if anything is added here
708             // This will increase even if they change owners, which is fine
709             rocket.m_TopSpeed = uint32(LerpExtra(stock_rocket.m_MinTopSpeed, stock_rocket.m_MaxTopSpeed, rocket.m_TopSpeed, bytes1(10 - i)));
710             rocket.m_Thrust = uint32(LerpExtra(stock_rocket.m_MinThrust, stock_rocket.m_MaxThrust, rocket.m_Thrust, bytes1(10 - i)));
711             rocket.m_Weight = uint32(LerpLess(stock_rocket.m_MinWeight, stock_rocket.m_MaxWeight, rocket.m_Weight, bytes1(10 - i)));
712             rocket.m_FuelCapacity = uint32(LerpExtra(stock_rocket.m_MinFuelCapacity, stock_rocket.m_MaxFuelCapacity, rocket.m_FuelCapacity, bytes1(10 - i)));
713             //
714 
715             m_Database.Store(NullAddress, RocketCategory, scores[i].m_RocketId, RocketTypes.SerializeRocket(rocket));
716 
717             uint256 existing_funds = uint256(m_Database.Load(scores[i].m_Owner, WithdrawalFundsCategory, 0));
718 
719             uint256 funds_won = original_competition_funds / (2 ** (i + 1));
720 
721             if (funds_won > competition_funds_remaining)
722                 funds_won = competition_funds_remaining;
723 
724             existing_funds += funds_won;
725             competition_funds_remaining -= funds_won;
726 
727             m_Database.Store(scores[i].m_Owner, WithdrawalFundsCategory, 0, bytes32(existing_funds));
728         }
729 
730         if (competition_funds_remaining > 0)
731         {
732             scores[MaxCompetitionScores] = CompetitionScoreTypes.DeserializeCompetitionScore(m_Database.Load(competition_id, CompetitionScoresCategory, 0));
733             existing_funds = uint256(m_Database.Load(scores[MaxCompetitionScores].m_Owner, WithdrawalFundsCategory, 0));
734             existing_funds += competition_funds_remaining;
735             m_Database.Store(scores[MaxCompetitionScores].m_Owner, WithdrawalFundsCategory, 0, bytes32(existing_funds));
736         }
737 
738         m_Database.Store(NullAddress, MissionParametersCategory, competition_id, parameters.SerializeMissionParameters());
739 
740         FinishCompetitionEvent(competition_id);
741     }
742 
743     function Lerp(uint256 min, uint256 max, bytes1 percent) internal pure returns(uint256)
744     {
745         uint256 real_percent = (uint256(percent) % 100);
746         return uint256(min + (real_percent * (max - min)) / 100);
747     }
748 
749     function LerpExtra(uint256 min, uint256 max, uint256 current, bytes1 total_extra_percent) internal pure returns (uint256)
750     {
751         current += Lerp(min, max, total_extra_percent) - min;
752         if (current < min || current > max)
753             current = max;
754         return current;
755     }
756 
757     function LerpLess(uint256 min, uint256 max, uint256 current, bytes1 total_less_percent) internal pure returns (uint256)
758     {
759         current -= Lerp(min, max, total_less_percent) - min;
760         if (current < min || current > max)
761             current = min;
762         return current;
763     }
764 
765     function BubbleSort(CompetitionScoreTypes.CompetitionScore[] memory scores, uint32 length) internal pure
766     {
767         uint32 n = length;
768         while (true)
769         {
770             bool swapped = false;
771             for (uint32 i = 1; i < n; i++)
772             {
773                 if (scores[i - 1].m_Distance > scores[i].m_Distance)
774                 {
775                     scores[MaxCompetitionScores] = scores[i - 1];
776                     scores[i - 1] = scores[i];
777                     scores[i] = scores[MaxCompetitionScores];
778                     swapped = true;
779                 }
780             }
781             n--;
782             if (!swapped)
783                 break;
784         }
785     }
786 }
787 
788 library GameCommon
789 {
790     using Serializer for Serializer.DataComponent;
791 
792     struct LaunchRocketStackFrame
793     {
794         int64 m_RocketTopSpeed; // 0
795         int64 m_RocketThrust; // 8
796         int64 m_RocketMass; // 16
797         int64 m_RocketFuelCapacity; // 24
798 
799         int64 m_RocketMaxDistance; // 0
800         int64 m_MissionWindSpeed; // 8
801         int64 m_MissionLaunchLocation; // 16
802         int64 m_MissionWeatherType; // 24
803 
804         int64 m_MissionWeatherCoverage; // 0
805         int64 m_MissionTargetDistance; // 8
806         int64 m_FuelToUse; // 16
807         int64 m_FuelAllocationForLaunch; // 24
808 
809         int64 m_StabilizerSetting; // 0
810         int64 m_DebugExtraDistance; // 8
811         int64 m_LaunchThrust; // 16
812 
813         RocketTypes.Rocket m_Rocket;
814         OwnershipTypes.Ownership m_Ownership;
815         MissionParametersTypes.MissionParameters m_Mission;
816 
817         bytes32 m_Raw0;
818         bytes32 m_Raw1;
819         bytes32 m_Raw2;
820         bytes32 m_Raw3;
821 
822         uint32 m_CompetitionId;
823         uint32 m_RocketId;
824         int64 m_LowEarthOrbitPosition;
825         int64 m_DisplacementFromLowEarthOrbit;
826         int64 m_DisplacementFromPlanet;
827         address m_Launcher;
828         uint256 m_ProfitFunds;
829         uint256 m_CompetitionFunds;
830         uint64 m_FinalDistance;
831     }
832 
833     function SerializeLaunchRocketStackFrame(LaunchRocketStackFrame memory stack) internal pure
834     {
835         SerializeRaw0(stack);
836         SerializeRaw1(stack);
837         SerializeRaw2(stack);
838         SerializeRaw3(stack);
839     }
840 
841     function DeserializeLaunchRocketStackFrame(LaunchRocketStackFrame memory stack) internal pure
842     {
843         DeserializeRaw0(stack);
844         DeserializeRaw1(stack);
845         DeserializeRaw2(stack);
846         DeserializeRaw3(stack);
847     }
848 
849     function SerializeRaw0(LaunchRocketStackFrame memory stack) internal pure
850     {
851         Serializer.DataComponent memory data;
852 
853         data.WriteUint64(0, uint64(stack.m_RocketTopSpeed));
854         data.WriteUint64(8, uint64(stack.m_RocketThrust));
855         data.WriteUint64(16, uint64(stack.m_RocketMass));
856         data.WriteUint64(24, uint64(stack.m_RocketFuelCapacity));
857 
858         stack.m_Raw0 = data.m_Raw;
859     }
860 
861     function DeserializeRaw0(LaunchRocketStackFrame memory stack) internal pure
862     {
863         Serializer.DataComponent memory data;
864         data.m_Raw = stack.m_Raw0;
865 
866         stack.m_RocketTopSpeed = int64(data.ReadUint64(0));
867         stack.m_RocketThrust = int64(data.ReadUint64(8));
868         stack.m_RocketMass = int64(data.ReadUint64(16));
869         stack.m_RocketFuelCapacity = int64(data.ReadUint64(24));
870     }
871 
872     function SerializeRaw1(LaunchRocketStackFrame memory stack) internal pure
873     {
874         Serializer.DataComponent memory data;
875 
876         data.WriteUint64(0, uint64(stack.m_RocketMaxDistance));
877         data.WriteUint64(8, uint64(stack.m_MissionWindSpeed));
878         data.WriteUint64(16, uint64(stack.m_MissionLaunchLocation));
879         data.WriteUint64(24, uint64(stack.m_MissionWeatherType));
880 
881         stack.m_Raw1 = data.m_Raw;
882     }
883 
884     function DeserializeRaw1(LaunchRocketStackFrame memory stack) internal pure
885     {
886         Serializer.DataComponent memory data;
887         data.m_Raw = stack.m_Raw1;
888 
889         stack.m_RocketMaxDistance = int64(data.ReadUint64(0));
890         stack.m_MissionWindSpeed = int64(data.ReadUint64(8));
891         stack.m_MissionLaunchLocation = int64(data.ReadUint64(16));
892         stack.m_MissionWeatherType = int64(data.ReadUint64(24));
893     }
894 
895     function SerializeRaw2(LaunchRocketStackFrame memory stack) internal pure
896     {
897         Serializer.DataComponent memory data;
898 
899         data.WriteUint64(0, uint64(stack.m_MissionWeatherCoverage));
900         data.WriteUint64(8, uint64(stack.m_MissionTargetDistance));
901         data.WriteUint64(16, uint64(stack.m_FuelToUse));
902         data.WriteUint64(24, uint64(stack.m_FuelAllocationForLaunch));
903 
904         stack.m_Raw2 = data.m_Raw;
905     }
906 
907     function DeserializeRaw2(LaunchRocketStackFrame memory stack) internal pure
908     {
909         Serializer.DataComponent memory data;
910         data.m_Raw = stack.m_Raw2;
911 
912         stack.m_MissionWeatherCoverage = int64(data.ReadUint64(0));
913         stack.m_MissionTargetDistance = int64(data.ReadUint64(8));
914         stack.m_FuelToUse = int64(data.ReadUint64(16));
915         stack.m_FuelAllocationForLaunch = int64(data.ReadUint64(24));
916     }
917 
918     function SerializeRaw3(LaunchRocketStackFrame memory stack) internal pure
919     {
920         Serializer.DataComponent memory data;
921 
922         data.WriteUint64(0, uint64(stack.m_StabilizerSetting));
923         data.WriteUint64(8, uint64(stack.m_DebugExtraDistance));
924         data.WriteUint64(16, uint64(stack.m_LaunchThrust));
925 
926         stack.m_Raw3 = data.m_Raw;
927     }
928 
929     function DeserializeRaw3(LaunchRocketStackFrame memory stack) internal pure
930     {
931         Serializer.DataComponent memory data;
932         data.m_Raw = stack.m_Raw3;
933 
934         stack.m_StabilizerSetting = int64(data.ReadUint64(0));
935         stack.m_DebugExtraDistance = int64(data.ReadUint64(8));
936         stack.m_LaunchThrust = int64(data.ReadUint64(16));
937     }
938 }
939 
940 library GlobalTypes
941 {
942     using Serializer for Serializer.DataComponent;
943 
944     struct Global
945     {
946         uint32 m_LastRocketId; // 0
947         uint32 m_CompetitionNumber; // 4
948         uint8 m_Unused8; // 8
949         uint8 m_Unused9; // 9
950         uint8 m_Unused10; // 10
951         uint8 m_Unused11; // 11
952     }
953 
954     function SerializeGlobal(Global global) internal pure returns (bytes32)
955     {
956         Serializer.DataComponent memory data;
957         data.WriteUint32(0, global.m_LastRocketId);
958         data.WriteUint32(4, global.m_CompetitionNumber);
959         data.WriteUint8(8, global.m_Unused8);
960         data.WriteUint8(9, global.m_Unused9);
961         data.WriteUint8(10, global.m_Unused10);
962         data.WriteUint8(11, global.m_Unused11);
963 
964         return data.m_Raw;
965     }
966 
967     function DeserializeGlobal(bytes32 raw) internal pure returns (Global)
968     {
969         Global memory global;
970 
971         Serializer.DataComponent memory data;
972         data.m_Raw = raw;
973 
974         global.m_LastRocketId = data.ReadUint32(0);
975         global.m_CompetitionNumber = data.ReadUint32(4);
976         global.m_Unused8 = data.ReadUint8(8);
977         global.m_Unused9 = data.ReadUint8(9);
978         global.m_Unused10 = data.ReadUint8(10);
979         global.m_Unused11 = data.ReadUint8(11);
980 
981         return global;
982     }
983 }
984 
985 library MarketTypes
986 {
987     using Serializer for Serializer.DataComponent;
988 
989     struct MarketListing
990     {
991         uint80 m_Price; // 0
992     }
993 
994     function SerializeMarketListing(MarketListing listing) internal pure returns (bytes32)
995     {
996         Serializer.DataComponent memory data;
997         data.WriteUint80(0, listing.m_Price);
998 
999         return data.m_Raw;
1000     }
1001 
1002     function DeserializeMarketListing(bytes32 raw) internal pure returns (MarketListing)
1003     {
1004         MarketListing memory listing;
1005 
1006         Serializer.DataComponent memory data;
1007         data.m_Raw = raw;
1008 
1009         listing.m_Price = data.ReadUint80(0);
1010 
1011         return listing;
1012     }
1013 }
1014 
1015 library MissionParametersTypes
1016 {
1017     using Serializer for Serializer.DataComponent;
1018 
1019     struct MissionParameters
1020     {
1021         uint8 m_WindSpeed; // 0
1022         uint8 m_LaunchLocation; // 1
1023         uint8 m_WeatherType; // 2
1024         uint8 m_WeatherCoverage; // 3
1025         uint80 m_LaunchCost; // 4
1026         uint8 m_IsStarted; // 14
1027         uint32 m_TargetDistance; // 15
1028         uint32 m_ValidCompetitionScores; // 19
1029         uint8 m_DebugExtraDistance; // 23
1030     }
1031 
1032     function SerializeMissionParameters(MissionParameters mission) internal pure returns (bytes32)
1033     {
1034         Serializer.DataComponent memory data;
1035 
1036         data.WriteUint8(0, mission.m_WindSpeed);
1037         data.WriteUint8(1, mission.m_LaunchLocation);
1038         data.WriteUint8(2, mission.m_WeatherType);
1039         data.WriteUint8(3, mission.m_WeatherCoverage);
1040         data.WriteUint80(4, mission.m_LaunchCost);
1041         data.WriteUint8(14, mission.m_IsStarted);
1042         data.WriteUint32(15, mission.m_TargetDistance);
1043         data.WriteUint32(19, mission.m_ValidCompetitionScores);
1044         data.WriteUint8(23, mission.m_DebugExtraDistance);
1045 
1046         return data.m_Raw;
1047     }
1048 
1049     function DeserializeMissionParameters(bytes32 raw) internal pure returns (MissionParameters)
1050     {
1051         MissionParameters memory mission;
1052 
1053         Serializer.DataComponent memory data;
1054         data.m_Raw = raw;
1055 
1056         mission.m_WindSpeed = data.ReadUint8(0);
1057         mission.m_LaunchLocation = data.ReadUint8(1);
1058         mission.m_WeatherType = data.ReadUint8(2);
1059         mission.m_WeatherCoverage = data.ReadUint8(3);
1060         mission.m_LaunchCost = data.ReadUint80(4);
1061         mission.m_IsStarted = data.ReadUint8(14);
1062         mission.m_TargetDistance = data.ReadUint32(15);
1063         mission.m_ValidCompetitionScores = data.ReadUint32(19);
1064         mission.m_DebugExtraDistance = data.ReadUint8(23);
1065 
1066         return mission;
1067     }
1068 }
1069 
1070 library OwnershipTypes
1071 {
1072     using Serializer for Serializer.DataComponent;
1073 
1074     struct Ownership
1075     {
1076         address m_Owner; // 0
1077         uint32 m_OwnerInventoryIndex; // 20
1078     }
1079 
1080     function SerializeOwnership(Ownership ownership) internal pure returns (bytes32)
1081     {
1082         Serializer.DataComponent memory data;
1083         data.WriteAddress(0, ownership.m_Owner);
1084         data.WriteUint32(20, ownership.m_OwnerInventoryIndex);
1085 
1086         return data.m_Raw;
1087     }
1088 
1089     function DeserializeOwnership(bytes32 raw) internal pure returns (Ownership)
1090     {
1091         Ownership memory ownership;
1092 
1093         Serializer.DataComponent memory data;
1094         data.m_Raw = raw;
1095 
1096         ownership.m_Owner = data.ReadAddress(0);
1097         ownership.m_OwnerInventoryIndex = data.ReadUint32(20);
1098 
1099         return ownership;
1100     }
1101 }
1102 
1103 library RocketTypes
1104 {
1105     using Serializer for Serializer.DataComponent;
1106 
1107     struct Rocket
1108     {
1109         uint8 m_Version; // 0
1110         uint8 m_Unused1; // 1
1111         uint8 m_IsForSale; // 2
1112         uint8 m_Unused3; // 3
1113 
1114         uint32 m_TopSpeed; // 4
1115         uint32 m_Thrust; // 8
1116         uint32 m_Weight; // 12
1117         uint32 m_FuelCapacity; // 16
1118 
1119         uint16 m_StockId; // 20
1120         uint16 m_Unused22; // 22
1121         uint64 m_MaxDistance; // 24
1122     }
1123 
1124     struct StockRocket
1125     {
1126         bool m_IsValid; // 0
1127         uint64 m_Cost; // 1
1128 
1129         uint32 m_MinTopSpeed; // 5
1130         uint32 m_MaxTopSpeed; // 9
1131 
1132         uint32 m_MinThrust; // 13
1133         uint32 m_MaxThrust; // 17
1134 
1135         uint32 m_MinWeight; // 21
1136         uint32 m_MaxWeight; // 25
1137 
1138         uint32 m_MinFuelCapacity; // 29
1139         uint32 m_MaxFuelCapacity; // 33
1140 
1141         uint64 m_Distance; // 37
1142     }
1143 
1144     function SerializeRocket(Rocket rocket) internal pure returns (bytes32)
1145     {
1146         Serializer.DataComponent memory data;
1147         data.WriteUint8(0, rocket.m_Version);
1148         //data.WriteUint8(1, rocket.m_Unused1);
1149         data.WriteUint8(2, rocket.m_IsForSale);
1150         //data.WriteUint8(3, rocket.m_Unused3);
1151         data.WriteUint32(4, rocket.m_TopSpeed);
1152         data.WriteUint32(8, rocket.m_Thrust);
1153         data.WriteUint32(12, rocket.m_Weight);
1154         data.WriteUint32(16, rocket.m_FuelCapacity);
1155         data.WriteUint16(20, rocket.m_StockId);
1156         //data.WriteUint16(22, rocket.m_Unused22);
1157         data.WriteUint64(24, rocket.m_MaxDistance);
1158 
1159         return data.m_Raw;
1160     }
1161 
1162     function DeserializeRocket(bytes32 raw) internal pure returns (Rocket)
1163     {
1164         Rocket memory rocket;
1165 
1166         Serializer.DataComponent memory data;
1167         data.m_Raw = raw;
1168 
1169         rocket.m_Version = data.ReadUint8(0);
1170         //rocket.m_Unused1 = data.ReadUint8(1);
1171         rocket.m_IsForSale = data.ReadUint8(2);
1172         //rocket.m_Unused3 = data.ReadUint8(3);
1173         rocket.m_TopSpeed = data.ReadUint32(4);
1174         rocket.m_Thrust = data.ReadUint32(8);
1175         rocket.m_Weight = data.ReadUint32(12);
1176         rocket.m_FuelCapacity = data.ReadUint32(16);
1177         rocket.m_StockId = data.ReadUint16(20);
1178         //rocket.m_Unused22 = data.ReadUint16(22);
1179         rocket.m_MaxDistance = data.ReadUint64(24);
1180 
1181         return rocket;
1182     }
1183 }
1184 
1185 library Serializer
1186 {
1187     struct DataComponent
1188     {
1189         bytes32 m_Raw;
1190     }
1191 
1192     function ReadUint8(DataComponent memory self, uint32 offset) internal pure returns (uint8)
1193     {
1194         return uint8((self.m_Raw >> (offset * 8)) & 0xFF);
1195     }
1196 
1197     function WriteUint8(DataComponent memory self, uint32 offset, uint8 value) internal pure
1198     {
1199         self.m_Raw |= (bytes32(value) << (offset * 8));
1200     }
1201 
1202     function ReadUint16(DataComponent memory self, uint32 offset) internal pure returns (uint16)
1203     {
1204         return uint16((self.m_Raw >> (offset * 8)) & 0xFFFF);
1205     }
1206 
1207     function WriteUint16(DataComponent memory self, uint32 offset, uint16 value) internal pure
1208     {
1209         self.m_Raw |= (bytes32(value) << (offset * 8));
1210     }
1211 
1212     function ReadUint32(DataComponent memory self, uint32 offset) internal pure returns (uint32)
1213     {
1214         return uint32((self.m_Raw >> (offset * 8)) & 0xFFFFFFFF);
1215     }
1216 
1217     function WriteUint32(DataComponent memory self, uint32 offset, uint32 value) internal pure
1218     {
1219         self.m_Raw |= (bytes32(value) << (offset * 8));
1220     }
1221 
1222     function ReadUint64(DataComponent memory self, uint32 offset) internal pure returns (uint64)
1223     {
1224         return uint64((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFF);
1225     }
1226 
1227     function WriteUint64(DataComponent memory self, uint32 offset, uint64 value) internal pure
1228     {
1229         self.m_Raw |= (bytes32(value) << (offset * 8));
1230     }
1231 
1232     function ReadUint80(DataComponent memory self, uint32 offset) internal pure returns (uint80)
1233     {
1234         return uint80((self.m_Raw >> (offset * 8)) & 0xFFFFFFFFFFFFFFFFFFFF);
1235     }
1236 
1237     function WriteUint80(DataComponent memory self, uint32 offset, uint80 value) internal pure
1238     {
1239         self.m_Raw |= (bytes32(value) << (offset * 8));
1240     }
1241 
1242     function ReadAddress(DataComponent memory self, uint32 offset) internal pure returns (address)
1243     {
1244         return address((self.m_Raw >> (offset * 8)) & (
1245             (0xFFFFFFFF << 0)  |
1246             (0xFFFFFFFF << 32) |
1247             (0xFFFFFFFF << 64) |
1248             (0xFFFFFFFF << 96) |
1249             (0xFFFFFFFF << 128)
1250         ));
1251     }
1252 
1253     function WriteAddress(DataComponent memory self, uint32 offset, address value) internal pure
1254     {
1255         self.m_Raw |= (bytes32(value) << (offset * 8));
1256     }
1257 }