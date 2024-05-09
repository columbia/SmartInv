1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC721 {
5     function ownerOf(uint256 tokenId_) external view returns (address);
6     function transferFrom(address from_, address to_, uint256 tokenId_) external;
7 }
8 
9 interface iCM {
10     function ownerOf(uint256 tokenId_) external view returns (address);
11     function transferFrom(address from_, address to_, uint256 tokenId_) external;
12     function contractAddressToTokenUploaded(address contractAddress_, uint256 tokenId_) external view returns (bool);
13     function renderTypeAllowed(uint8 renderType_) external view returns (bool);
14 }
15 
16 interface iMES {
17     // View Functions
18     function balanceOf(address address_) external view returns (uint256);
19     function pendingRewards(address address_) external view returns (uint256); 
20     function getStorageClaimableTokens(address address_) external view returns (uint256);
21     function getPendingClaimableTokens(address address_) external view returns (uint256);
22     function getTotalClaimableTokens(address address_) external view returns (uint256);
23     // Administration
24     function setYieldRate(address address_, uint256 yieldRate_) external;
25     function addYieldRate(address address_, uint256 yieldRateAdd_) external;
26     function subYieldRate(address address_, uint256 yieldRateSub_) external;
27     // Updating
28     function updateReward(address address_) external;
29     // Credits System
30     function deductCredits(address address_, uint256 amount_) external;
31     function addCredits(address address_, uint256 amount_) external;
32     // Burn
33     function burn(address from, uint256 amount_) external;
34 }
35 
36 interface iCS {
37     struct Character {
38         uint8  race_;
39         uint8  renderType_;
40         uint16 transponderId_;
41         uint16 spaceCapsuleId_;
42         uint8  augments_;
43         uint16 basePoints_;
44         uint16 totalEquipmentBonus_;
45     }
46     struct Stats {
47         uint8 strength_; 
48         uint8 agility_; 
49         uint8 constitution_; 
50         uint8 intelligence_; 
51         uint8 spirit_; 
52     }
53     struct Equipment {
54         uint8 weaponUpgrades_;
55         uint8 chestUpgrades_;
56         uint8 headUpgrades_;
57         uint8 legsUpgrades_;
58         uint8 vehicleUpgrades_;
59         uint8 armsUpgrades_;
60         uint8 artifactUpgrades_;
61         uint8 ringUpgrades_;
62     }
63 
64     // Create Character
65     function createCharacter(uint tokenId_, Character memory Character_) external;
66     // Characters
67     function setName(uint256 tokenId_, string memory name_) external;
68     function setBio(uint256 tokenId_, string memory bio_) external;
69     function setRace(uint256 tokenId_, uint8 race_) external;
70     function setRenderType(uint256 tokenId_, uint8 renderType_) external;
71     function setTransponderId(uint256 tokenId_, uint16 transponderId_) external;
72     function setSpaceCapsuleId(uint256 tokenId_, uint16 spaceCapsuleId_) external;
73     function setAugments(uint256 tokenId_, uint8 augments_) external;
74     function setBasePoints(uint256 tokenId_, uint16 basePoints_) external;
75     function setBaseEquipmentBonus(uint256 tokenId_, uint16 baseEquipmentBonus_) external;
76     function setTotalEquipmentBonus(uint256 tokenId_, uint16 totalEquipmentBonus) external;
77     // Stats
78     function setStrength(uint256 tokenId_, uint8 strength_) external;
79     function setAgility(uint256 tokenId_, uint8 agility_) external;
80     function setConstitution(uint256 tokenId_, uint8 constitution_) external;
81     function setIntelligence(uint256 tokenId_, uint8 intelligence_) external;
82     function setSpirit(uint256 tokenId_, uint8 spirit_) external;
83     // Equipment
84     function setWeaponUpgrades(uint256 tokenId_, uint8 upgrade_) external;
85     function setChestUpgrades(uint256 tokenId_, uint8 upgrade_) external;
86     function setHeadUpgrades(uint256 tokenId_, uint8 upgrade_) external;
87     function setLegsUpgrades(uint256 tokenId_, uint8 upgrade_) external;
88     function setVehicleUpgrades(uint256 tokenId_, uint8 upgrade_) external;
89     function setArmsUpgrades(uint256 tokenId_, uint8 upgrade_) external;
90     function setArtifactUpgrades(uint256 tokenId_, uint8 upgrade_) external;
91     function setRingUpgrades(uint256 tokenId_, uint8 upgrade_) external;
92     // Structs and Mappings
93     function names(uint256 tokenId_) external view returns (string memory);
94     function characters(uint256 tokenId_) external view returns (Character memory);
95     function stats(uint256 tokenId_) external view returns (Stats memory);
96     function equipments(uint256 tokenId_) external view returns (Equipment memory);
97     function contractToRace(address contractAddress_) external view returns (uint8);
98 }
99 
100 library Strings {
101     function toString(uint256 value_) internal pure returns (string memory) {
102         if (value_ == 0) { return "0"; }
103         uint256 _iterate = value_; uint256 _digits;
104         while (_iterate != 0) { _digits++; _iterate /= 10; } // get digits in value_
105         bytes memory _buffer = new bytes(_digits);
106         while (value_ != 0) { _digits--; _buffer[_digits] = bytes1(uint8(48 + uint256(value_ % 10 ))); value_ /= 10; } // create bytes of value_
107         return string(_buffer); // return string converted bytes of value_
108     }
109 }
110 
111 library MTMLib {
112     // Static String Returns
113     function getNameOfItem(uint8 item_) public pure returns (string memory) {
114         if      (item_ == 1) { return "WEAPONS";   }
115         else if (item_ == 2) { return "CHEST";     }
116         else if (item_ == 3) { return "HEAD";      }
117         else if (item_ == 4) { return "LEGS";      }
118         else if (item_ == 5) { return "VEHICLE";   }
119         else if (item_ == 6) { return "ARMS";      }
120         else if (item_ == 7) { return "ARTIFACTS"; }
121         else if (item_ == 8) { return "RINGS";     }
122         else                 { revert("Invalid Equipment Upgrades Query!"); }
123     }
124 
125     // Static Rarity Stuff
126     function getItemRarity(uint16 spaceCapsuleId_, string memory keyPrefix_) public pure returns (uint8) {
127         uint256 _rarity = uint256(keccak256(abi.encodePacked(keyPrefix_, Strings.toString(spaceCapsuleId_)))) % 21;
128         return uint8(_rarity);
129     }
130     function queryEquipmentUpgradability(uint8 rarity_) public pure returns (uint8) {
131         return rarity_ >= 19 ? rarity_ == 19 ? 4 : 4 : 4; 
132     }
133     function queryBaseEquipmentTier(uint8 rarity_) public pure returns (uint8) {
134         return rarity_ >= 19 ? rarity_ == 19 ? 1 : 2 : 0;
135     }
136 
137     // Character Modification Costs
138     function queryAugmentCost(uint8 currentLevel_) public pure returns (uint256) {
139         if      (currentLevel_ == 0) { return 0;         }
140         else if (currentLevel_ == 1) { return 1 ether;   }
141         else if (currentLevel_ == 2) { return 2 ether;   }
142         else if (currentLevel_ == 3) { return 5 ether;   }
143         else if (currentLevel_ == 4) { return 10 ether;  }
144         else if (currentLevel_ == 5) { return 15 ether;  }
145         else if (currentLevel_ == 6) { return 25 ether;  }
146         else if (currentLevel_ == 7) { return 50 ether;  }
147         else if (currentLevel_ == 8) { return 100 ether; }
148         else if (currentLevel_ == 9) { return 250 ether; }
149         else                         { revert("Invalid level!"); }
150     }
151     function queryBasePointsUpgradeCost(uint16 currentLevel_) public pure returns (uint256) {
152         uint8 _tier = uint8(currentLevel_ / 5);
153         if      (_tier == 0) { return 1 ether;   }
154         else if (_tier == 1) { return 2 ether;   }
155         else if (_tier == 2) { return 5 ether;   }
156         else if (_tier == 3) { return 10 ether;  }
157         else if (_tier == 4) { return 20 ether;  }
158         else if (_tier == 5) { return 30 ether;  }
159         else if (_tier == 6) { return 50 ether;  }
160         else if (_tier == 7) { return 70 ether;  }
161         else if (_tier == 8) { return 100 ether; }
162         else if (_tier == 9) { return 150 ether; }
163         else                 { revert("Invalid Level!"); }
164     }
165     function queryEquipmentUpgradeCost(uint8 currentLevel_) public pure returns (uint256) {
166         if      (currentLevel_ == 0) { return 50 ether;   }
167         else if (currentLevel_ == 1) { return 250 ether;  }
168         else if (currentLevel_ == 2) { return 750 ether;  }
169         else if (currentLevel_ == 3) { return 1500 ether; }
170         else                         { revert("Invalid Level!"); }
171     }
172 
173     // Yield Rate Constants
174     function getBaseYieldRate(uint8 augments_) public pure returns (uint256) {
175         if      (augments_ == 0 ) { return 0.1 ether; }
176         else if (augments_ == 1 ) { return 1 ether;   }
177         else if (augments_ == 2 ) { return 2 ether;   }
178         else if (augments_ == 3 ) { return 3 ether;   }
179         else if (augments_ == 4 ) { return 4 ether;   }
180         else if (augments_ == 5 ) { return 5 ether;   }
181         else if (augments_ == 6 ) { return 6 ether;   }
182         else if (augments_ == 7 ) { return 7 ether;   }
183         else if (augments_ == 8 ) { return 8 ether;   }
184         else if (augments_ == 9 ) { return 9 ether;   }
185         else if (augments_ == 10) { return 10 ether;  }
186         else                      { return 0;         }
187     }
188     function queryEquipmentModulus(uint8 rarity_, uint8 upgrades_) public pure returns (uint8) {
189         uint8 _baseTier = queryBaseEquipmentTier(rarity_);
190         uint8 _currentTier = _baseTier + upgrades_;
191         if      (_currentTier == 0) { return 0;  }
192         else if (_currentTier == 1) { return 2;  }
193         else if (_currentTier == 2) { return 5;  }
194         else if (_currentTier == 3) { return 10; }
195         else if (_currentTier == 4) { return 20; }
196         else if (_currentTier == 5) { return 35; }
197         else if (_currentTier == 6) { return 50; }
198         else                        { revert("Invalid Level!"); }
199     }
200     function getStatMultiplier(uint16 basePoints_) public pure returns (uint256) {
201         return uint256( (basePoints_ * 2) + 100 );
202     }
203     function getEquipmentMultiplier(uint16 totalEquipmentBonus_) public pure returns (uint256) {
204         return uint256( totalEquipmentBonus_ + 100 );
205     }
206 
207     // Base Yield Rate Caclulations
208     function getItemBaseBonus(uint16 spaceCapsuleId_, string memory keyPrefix_) public pure returns (uint8) {
209         return queryEquipmentModulus( getItemRarity(spaceCapsuleId_, keyPrefix_), 0 );
210     }
211     function getEquipmentBaseBonus(uint16 spaceCapsuleId_) public pure returns (uint16) {
212         return uint16(
213         getItemBaseBonus(spaceCapsuleId_, "WEAPONS") + 
214         getItemBaseBonus(spaceCapsuleId_, "CHEST") +
215         getItemBaseBonus(spaceCapsuleId_, "HEAD") +
216         getItemBaseBonus(spaceCapsuleId_, "LEGS") +
217         getItemBaseBonus(spaceCapsuleId_, "VEHICLE") +
218         getItemBaseBonus(spaceCapsuleId_, "ARMS") + 
219         getItemBaseBonus(spaceCapsuleId_, "ARTIFACTS") +
220         getItemBaseBonus(spaceCapsuleId_, "RINGS")
221         );
222     }
223 
224     // Yield Rate Calculation
225     function getCharacterYieldRate(uint8 augments_, uint16 basePoints_, uint16 totalEquipmentBonus_) public pure returns (uint256) {
226         uint256 _baseYield = getBaseYieldRate(augments_);
227         uint256 _statMultiplier = getStatMultiplier(basePoints_);
228         uint256 _eqMultiplier = getEquipmentMultiplier(totalEquipmentBonus_);
229         return _baseYield * (_statMultiplier * _eqMultiplier) / 10000;
230     }
231 }
232 
233 library MTMStrings {
234     function onlyAllowedCharacters(string memory string_) public pure returns (bool) {
235         bytes memory _strBytes = bytes(string_);
236         for (uint i = 0; i < _strBytes.length; i++) {
237             if (_strBytes[i] < 0x20 || _strBytes[i] > 0x7A || _strBytes[i] == 0x26 || _strBytes[i] == 0x22 || _strBytes[i] == 0x3C || _strBytes[i] == 0x3E) {
238                 return false;
239             }     
240         }
241         return true;
242     }
243 }
244 
245 contract MTMCharactersController {
246     // Access
247     address public owner;
248     constructor() { owner = msg.sender; }
249     modifier onlyOwner { require(msg.sender == owner, "You are not the owner!"); _; }
250     function setNewOwner(address address_) external onlyOwner { owner = address_; }
251 
252     // Burn Target
253     address internal constant burnAddress = 0x000000000000000000000000000000000000dEaD;
254 
255     // Interfaces
256     iCM public CM; iMES public MES; iCS public CS;
257     IERC721 public SC; IERC721 public TP;
258     function setContracts(address cm_, address mes_, address cs_, address sc_, address tp_) external onlyOwner {
259         CM = iCM(cm_); MES = iMES(mes_); CS = iCS(cs_);
260         SC = IERC721(sc_); TP = IERC721(tp_);
261     }
262 
263     // Internal Write Functions
264     function __MESPayment(address address_, uint256 amount_, bool useCredits_) internal {
265         if (useCredits_) {
266             require(amount_ <= MES.getTotalClaimableTokens(address_), "Not enough MES credits to do action!");
267             if (amount_ >= MES.getStorageClaimableTokens(address_)) { MES.updateReward(address_); }
268             MES.deductCredits(address_, amount_);
269         } else {
270             require(amount_ <= MES.balanceOf(address_), "Not enough MES to do action!");
271             MES.burn(address_, amount_);
272         }
273     }
274     function __updateReward(address address_) internal {
275         MES.updateReward(address_);
276     }
277     function __addYieldRate(address address_, uint256 yieldRate_) internal {
278         MES.addYieldRate(address_, yieldRate_);
279     }
280 
281     // Internal Read Functions
282     function __getCharacter(uint256 characterId_) internal view returns (iCS.Character memory) {
283         return CS.characters(characterId_);
284     }
285     function __getEquipment(uint256 characterId_) internal view returns (iCS.Equipment memory) {
286         return CS.equipments(characterId_);
287     }
288     function __getStats(uint256 characterId_) internal view returns (iCS.Stats memory) {
289         return CS.stats(characterId_);
290     }
291     function __getAugments(uint256 characterId_) internal view returns (uint8) {
292         return CS.characters(characterId_).augments_;
293     }
294     function __getBasePoints(uint256 characterId_) internal view returns (uint16) {
295         return CS.characters(characterId_).basePoints_;
296     }
297 
298     // Internal Equipment Administration
299     function __getEquipmentUpgrades(iCS.Equipment memory Equipment_, uint8 item_) internal pure returns (uint8) {
300         if      (item_ == 1) { return Equipment_.weaponUpgrades_;   }
301         else if (item_ == 2) { return Equipment_.chestUpgrades_;    }
302         else if (item_ == 3) { return Equipment_.headUpgrades_;     }
303         else if (item_ == 4) { return Equipment_.legsUpgrades_;     }
304         else if (item_ == 5) { return Equipment_.vehicleUpgrades_;  }
305         else if (item_ == 6) { return Equipment_.armsUpgrades_;     }
306         else if (item_ == 7) { return Equipment_.artifactUpgrades_; }
307         else if (item_ == 8) { return Equipment_.ringUpgrades_;     }
308         else                 { revert("Invalid Equipment Upgrades Query!"); }
309     }
310     function __setItemUpgrades(uint256 characterId_, uint8 newUpgrades_, uint8 item_) internal {
311         if      (item_ == 1) { CS.setWeaponUpgrades(characterId_, newUpgrades_);   }
312         else if (item_ == 2) { CS.setChestUpgrades(characterId_, newUpgrades_);    }
313         else if (item_ == 3) { CS.setHeadUpgrades(characterId_, newUpgrades_);     }
314         else if (item_ == 4) { CS.setLegsUpgrades(characterId_, newUpgrades_);     }
315         else if (item_ == 5) { CS.setVehicleUpgrades(characterId_, newUpgrades_);  }
316         else if (item_ == 6) { CS.setArmsUpgrades(characterId_, newUpgrades_);     }
317         else if (item_ == 7) { CS.setArtifactUpgrades(characterId_, newUpgrades_); }
318         else if (item_ == 8) { CS.setRingUpgrades(characterId_, newUpgrades_);     }
319         else                 { revert("Invalid Equipment Set Upgrade Query!"); }
320     }
321 
322     // Augment Character
323     function augmentCharacter(uint256 characterId_, uint256[] memory charactersToBurn_, bool useCredits_) public {
324         require(msg.sender == CM.ownerOf(characterId_), "You don't own this character!");
325 
326         iCS.Character memory _Character = __getCharacter(characterId_);
327 
328         uint8 _augments = _Character.augments_;
329         uint8 _numberOfAugments = uint8(charactersToBurn_.length);
330 
331         // Calculate the Augmentation Cost
332         uint256 _totalAugmentCost;
333         for (uint8 i = 0; i < _numberOfAugments; i++) {
334             _totalAugmentCost += MTMLib.queryAugmentCost(_augments + i);
335         }
336 
337         // Check $MES Requirements and Burn $MES!
338         __MESPayment(msg.sender, _totalAugmentCost, useCredits_);
339 
340         // Check Character Requirements and Loop-Burn Characters!
341         for (uint8 i = 0; i < _numberOfAugments; i++) {
342             require(characterId_ != charactersToBurn_[i], "Cannot Burn Augmenting Character!");
343             require(msg.sender == CM.ownerOf(charactersToBurn_[i]), "Unowned Character to Burn!");
344 
345             CM.transferFrom(msg.sender, burnAddress, charactersToBurn_[i]);
346         }
347 
348         // Update Reward
349         __updateReward(msg.sender);
350 
351         // Calculate Current Character Yield Rate before Augment
352         uint256 _currentYieldRate = MTMLib.getCharacterYieldRate(_augments, _Character.basePoints_, _Character.totalEquipmentBonus_);
353 
354         // Set New Augment Level
355         uint8 _newAugments = _augments + _numberOfAugments;
356         CS.setAugments(characterId_, _newAugments);
357 
358         // Calculate New Character Yield Rate and Difference
359         uint256 _newYieldRate = MTMLib.getCharacterYieldRate(_newAugments, _Character.basePoints_, _Character.totalEquipmentBonus_);
360         uint256 _increasedYieldRate = _newYieldRate - _currentYieldRate;
361 
362         // Add Increased Yield Rate
363         __addYieldRate(msg.sender, _increasedYieldRate);
364     }
365     function augmentCharacterWithMats(uint256 characterId_, uint256[] memory transponders_, uint256[] memory spaceCapsules_, bool useCredits_) public {
366         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
367         require(transponders_.length == spaceCapsules_.length, "Pair length mismatch!");
368 
369         iCS.Character memory _Character = __getCharacter(characterId_);
370 
371         uint8 _augments = __getAugments(characterId_);
372         uint8 _numberOfAugments = uint8(transponders_.length);
373 
374         // Calculate the Augmentation Cost
375         uint256 _totalAugmentCost;
376         for (uint8 i = 0; i < _numberOfAugments; i++) {
377             _totalAugmentCost += MTMLib.queryAugmentCost(_augments + i);
378         }
379 
380         // Check $MES Requirements and Burn $MES!
381         __MESPayment(msg.sender, _totalAugmentCost, useCredits_);
382 
383         // Check TP/SC Requirements and Loop-Burn TP/SC!
384         for (uint8 i = 0; i < _numberOfAugments; i++) {
385             require(msg.sender == TP.ownerOf(transponders_[i]) && msg.sender == SC.ownerOf(spaceCapsules_[i]), "Not owner of pair!");
386 
387             TP.transferFrom(msg.sender, burnAddress, transponders_[i]);
388             SC.transferFrom(msg.sender, burnAddress, spaceCapsules_[i]);
389         }
390 
391         // Update Reward
392         __updateReward(msg.sender);
393 
394         // Calculate Current Character Yield Rate before Augment
395         uint256 _currentYieldRate = MTMLib.getCharacterYieldRate(_augments, _Character.basePoints_, _Character.totalEquipmentBonus_);
396 
397         // Set New Augment Level
398         uint8 _newAugments = _augments + _numberOfAugments;
399         CS.setAugments(characterId_, _newAugments);
400 
401         // Calculate New Character Yield Rate and Difference
402         uint256 _newYieldRate = MTMLib.getCharacterYieldRate(_newAugments, _Character.basePoints_, _Character.totalEquipmentBonus_);
403         uint256 _increasedYieldRate = _newYieldRate - _currentYieldRate;
404 
405         // Add Increased Yield Rate
406         __addYieldRate(msg.sender, _increasedYieldRate);
407     }
408 
409     // Level Up Base Points
410     function levelUp(uint256 characterId_, uint16 amount_, bool useCredits_) public {
411         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
412 
413         iCS.Character memory _Character = __getCharacter(characterId_);
414 
415         uint16 _currentBasePoints = __getBasePoints(characterId_);
416 
417         // Calculate $MES Cost for Level Up
418         uint256 _levelUpCost;
419         for (uint16 i = 0; i < amount_; i++) {
420             _levelUpCost += MTMLib.queryBasePointsUpgradeCost(_currentBasePoints + i);
421         }
422 
423         // Check $MES Requires and Burn $MES!
424         __MESPayment(msg.sender, _levelUpCost, useCredits_);
425 
426         // Update Reward
427         __updateReward(msg.sender);
428 
429         // Calculate Current Character Yield Rate before Augment
430         uint256 _currentYieldRate = MTMLib.getCharacterYieldRate(
431             _Character.augments_, _currentBasePoints, _Character.totalEquipmentBonus_);
432 
433         // Set New Base Points
434         uint16 _newBasePoints = _currentBasePoints + amount_;
435         CS.setBasePoints(characterId_, _newBasePoints);
436 
437         // Calculate Yield Rate Benefits
438         uint256 _newYieldRate = MTMLib.getCharacterYieldRate(
439             _Character.augments_, _newBasePoints, _Character.totalEquipmentBonus_);
440         uint256 _increasedYieldRate = _newYieldRate - _currentYieldRate;
441 
442         // Add Increased Yield Rate
443         __addYieldRate(msg.sender, _increasedYieldRate);
444     }
445     function multiLevelUp(uint256[] memory characterIds_, uint16[] memory amounts_, bool useCredits_) public {
446         // User must make sure they have enough $MES for the entire loop otherwise it will revert. Use with care.
447         require(characterIds_.length == amounts_.length, "Mismatched length of arrays!");
448         for (uint256 i = 0; i < characterIds_.length; i++) {
449             levelUp(characterIds_[i], amounts_[i], useCredits_);
450         }
451     }
452 
453     // Equipment Upgrade
454     function upgradeEquipment(uint256 characterId_, uint8 amount_, uint8 item_, bool useCredits_) public {
455         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
456 
457         iCS.Character memory _Character = __getCharacter(characterId_);
458         iCS.Equipment memory _Equipment = __getEquipment(characterId_);
459 
460         uint8 _rarity = MTMLib.getItemRarity(_Character.spaceCapsuleId_, MTMLib.getNameOfItem(item_));
461         uint8 _currentUpgrades = __getEquipmentUpgrades(_Equipment, item_);
462 
463         require(_currentUpgrades + amount_ <= MTMLib.queryEquipmentUpgradability(_rarity), "Request to upgrade past upgradability!");
464 
465         // Calculate the Upgrade Cost
466         uint256 _upgradeCost;
467         for (uint8 i = 0; i < amount_; i++) {
468             _upgradeCost += MTMLib.queryEquipmentUpgradeCost(_currentUpgrades + i);
469         }
470 
471         // Check $MES Requires and Burn $MES!
472         __MESPayment(msg.sender, _upgradeCost, useCredits_);
473 
474         // Update Reward
475         __updateReward(msg.sender);
476 
477         // Calculate the Curent Yield Rate before Upgrading
478         uint256 _currentYieldRate = MTMLib.getCharacterYieldRate(_Character.augments_, _Character.basePoints_, _Character.totalEquipmentBonus_);
479 
480         // Calculate and Set the New Item Level
481         uint8 _newUpgrades = _currentUpgrades + amount_;
482         __setItemUpgrades(characterId_, _newUpgrades, item_);
483 
484         // Calculate and Set the New Total Equipment Bonus of the Character
485         uint16 _newTotalEquipmentBonus = _Character.totalEquipmentBonus_ + ( MTMLib.queryEquipmentModulus(_rarity, _newUpgrades) - MTMLib.queryEquipmentModulus(_rarity, _currentUpgrades) );
486         CS.setTotalEquipmentBonus(characterId_, _newTotalEquipmentBonus);
487 
488         // Calculate the Yield Rate Difference
489         uint256 _newYieldRate = MTMLib.getCharacterYieldRate(_Character.augments_, _Character.basePoints_, _newTotalEquipmentBonus);
490         uint256 _increasedYieldRate = _newYieldRate - _currentYieldRate;
491 
492         // Adjust the Yield Rate accordingly
493         __addYieldRate(msg.sender, _increasedYieldRate);
494     }
495     function multiUpgradeEquipment(uint256 characterId_, uint8[] memory amounts_, uint8[] memory items_, bool useCredits_) public {
496         require(amounts_.length == items_.length, "Amounts and Items length mismatch!");
497         for (uint256 i = 0; i < amounts_.length; i++) {
498             upgradeEquipment(characterId_, amounts_[i], items_[i], useCredits_);
499         }
500     }
501 
502     // Role Play Stats
503     function __getTotalStatsLeveled(iCS.Stats memory Stats_) internal pure returns (uint8) {
504         return Stats_.strength_ + Stats_.agility_ + Stats_.constitution_ + Stats_.intelligence_ + Stats_.spirit_;
505     }
506     function __getCharacterLevel(iCS.Stats memory Stats_, uint8 attribute_) internal pure returns (uint8) {
507         if      (attribute_ == 1) { return Stats_.strength_; }
508         else if (attribute_ == 2) { return Stats_.agility_; }
509         else if (attribute_ == 3) { return Stats_.constitution_; }
510         else if (attribute_ == 4) { return Stats_.intelligence_; }
511         else if (attribute_ == 5) { return Stats_.spirit_; }
512         else                      { revert("Invalid attribute type!"); }
513     }
514     function __setCharacterLevel(uint256 characterId_, uint8 attribute_, uint8 level_) internal {
515         if      (attribute_ == 1) { CS.setStrength(characterId_, level_); }
516         else if (attribute_ == 2) { CS.setAgility(characterId_, level_); }
517         else if (attribute_ == 3) { CS.setConstitution(characterId_, level_); }
518         else if (attribute_ == 4) { CS.setIntelligence(characterId_, level_); }
519         else if (attribute_ == 5) { CS.setSpirit(characterId_, level_); }
520         else                      { revert("Invalid attribute type!"); }
521     }
522     function levelCharacterStat(uint256 characterId_, uint8 attribute_, uint8 amount_) public {
523         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
524 
525         iCS.Character memory _Character = __getCharacter(characterId_);
526         iCS.Stats memory _Stats = __getStats(characterId_);
527         require(__getTotalStatsLeveled(_Stats) + amount_ <= _Character.basePoints_, "Request to upgrade stats above available base points!");
528 
529         // Get Current Level and New Level of Attribute
530         uint8 _currentLevel = __getCharacterLevel(_Stats, attribute_);
531         uint8 _newLevel = _currentLevel + amount_;
532 
533         // Set New Level for Attribute
534         __setCharacterLevel(characterId_, attribute_, _newLevel);
535     }
536     function multiLevelCharacterStat(uint256 characterId_, uint8[] memory attributes_, uint8[] memory amounts_) public {
537         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
538         require(attributes_.length == amounts_.length, "Attributes and Amounts length mismatch!");
539         
540         // Load Character and Stats into local memory
541         iCS.Character memory _Character = __getCharacter(characterId_);
542         iCS.Stats memory _Stats = __getStats(characterId_);
543 
544         // Calculate total Amounts to add
545         uint16 _amountToAdd;
546         for (uint256 i = 0; i < amounts_.length; i++) {
547             _amountToAdd += amounts_[i];
548         }
549 
550         // Make sure stat upgrades are not above base points
551         require(__getTotalStatsLeveled(_Stats) + _amountToAdd <= _Character.basePoints_, "Request to upgrade stats above available base points!");
552 
553         // Loop-Level each stat
554         for (uint256 i = 0; i < amounts_.length; i++) {
555             uint8 _currentLevel = __getCharacterLevel(_Stats, attributes_[i]);
556             uint8 _newLevel = _currentLevel + amounts_[i];
557 
558             __setCharacterLevel(characterId_, attributes_[i], _newLevel);
559         }
560     }
561 
562     // General Cosmetics Variables
563     uint256 nameChangeCost = 5 ether;
564     uint256 bioChangeCost = 20 ether;
565     uint256 rerollRaceCost = 10 ether;
566     uint256 uploadRaceCost = 50 ether;
567     uint256 renderTypeChangeCost = 10 ether;
568     function __setCostmeticCost(uint8 type_, uint256 cost_) internal {
569         if      (type_ == 1) { nameChangeCost = cost_; }
570         else if (type_ == 2) { bioChangeCost = cost_; }
571         else if (type_ == 3) { rerollRaceCost = cost_; }
572         else if (type_ == 4) { uploadRaceCost = cost_; }
573         else if (type_ == 5) { renderTypeChangeCost = cost_; }
574         else                 { revert("Invalid Type!"); }
575     }
576     function setCosmeticCosts(uint8[] memory types_, uint256[] memory costs_) public onlyOwner {
577         require(types_.length == costs_.length, "Array length mismatch!");
578         for (uint256 i = 0; i < costs_.length; i++) {
579             __setCostmeticCost(types_[i], costs_[i]);
580         }
581     }
582 
583     // Change Name
584     bool public characterChangeNameable = true;
585     function setCharacterChangeNameable(bool bool_) external onlyOwner { characterChangeNameable = bool_; }
586 
587     function changeName(uint256 characterId_, string memory name_, bool useCredits_) public {
588         require(characterChangeNameable, "Characters not namable!");
589         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
590         require(MTMStrings.onlyAllowedCharacters(name_), "Name contains unallowed characters!");
591         require(20 >= bytes(name_).length, "Name can only contain 20 characters max!");
592         __MESPayment(msg.sender, nameChangeCost, useCredits_);
593         CS.setName(characterId_, name_);
594     }
595 
596     // Change Bio
597     bool public characterChangeBioable = true;
598     function setCharacterChangeBioable(bool bool_) external onlyOwner { characterChangeBioable = bool_; }
599 
600     function changeBio(uint256 characterId_, string memory bio_, bool useCredits_) public {
601         require(characterChangeBioable, "Characters not bio changable!");
602         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
603         require(MTMStrings.onlyAllowedCharacters(bio_), "Bio contains unallowed characters!");
604         // require(160 >= bytes(bio_).length, "Bio can only contain 160 characters max!");
605         __MESPayment(msg.sender, bioChangeCost, useCredits_);
606         CS.setBio(characterId_, bio_);
607     }
608 
609     // Reroll Race
610     bool public characterRerollable;
611     function setCharacterRerollable(bool bool_) public onlyOwner { characterRerollable = bool_; }
612     
613     function rerollRace(uint256 characterId_, bool useCredits_) public {
614         require(characterRerollable, "Character model is not rerollable!");
615         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
616         __MESPayment(msg.sender, rerollRaceCost, useCredits_);
617         uint8 _race = uint8( (uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.difficulty, characterId_))) % 10) + 1 ); // RNG (1-10) 
618         CS.setRace(characterId_, _race);
619     }
620 
621     // Upload Race
622     bool public characterUploadable;
623     function setCharacterUploadable(bool bool_) public onlyOwner { characterUploadable = bool_; }
624     mapping(address => mapping(uint256 => bool)) public contractAddressToTokenUploaded;
625     
626     function uploadRace(uint256 characterId_, address contractAddress_, uint256 uploadId_, bool useCredits_) public {
627         require(characterUploadable, "Character type is not uploadable!");
628         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
629         require(!CM.contractAddressToTokenUploaded(contractAddress_, uploadId_), "This character has already been uploaded!"); // from CM
630         require(contractAddressToTokenUploaded[contractAddress_][uploadId_], "This character has already been uploaded"); // from this contract
631 
632         __MESPayment(msg.sender, uploadRaceCost, useCredits_);
633 
634         contractAddressToTokenUploaded[contractAddress_][uploadId_] = true;
635 
636         uint8 _race = CS.contractToRace(contractAddress_);
637         CS.setRace(characterId_, _race);
638     }
639 
640     // Change Render Type
641     bool public renderTypeChangable;
642     function setRenderTypeChangable(bool bool_) public onlyOwner { renderTypeChangable = bool_; }
643     
644     function changeRenderType(uint256 characterId_, uint8 renderType_, bool useCredits_) public {
645         require(renderTypeChangable, "Render type is not changable!");
646         require(CM.renderTypeAllowed(renderType_), "Render type is not supported!");
647         require(msg.sender == CM.ownerOf(characterId_), "You don't own this Character!");
648          __MESPayment(msg.sender, uploadRaceCost, useCredits_);
649         CS.setRenderType(characterId_, renderType_);
650     }
651 
652     // Public View Functions (Mainly for Interfacing)
653     function getCharacterYieldRate(uint256 characterId_) public view returns (uint256) {
654         iCS.Character memory Character_ = __getCharacter(characterId_);
655         return MTMLib.getCharacterYieldRate(Character_.augments_, Character_.basePoints_, Character_.totalEquipmentBonus_);
656     }
657     function queryCharacterYieldRate(uint8 augments_, uint16 basePoints_, uint16 totalEquipmentBonus_) public pure returns (uint256) {
658         return MTMLib.getCharacterYieldRate(augments_, basePoints_, totalEquipmentBonus_);
659     }
660     function getItemRarity(uint16 spaceCapsuleId_, string memory keyPrefix_) public pure returns (uint8) {
661         return MTMLib.getItemRarity(spaceCapsuleId_, keyPrefix_);
662     }
663     function queryBaseEquipmentTier(uint8 rarity_) public pure returns (uint8) {
664         return MTMLib.queryBaseEquipmentTier(rarity_);
665     }
666     function getEquipmentBaseBonus(uint16 spaceCapsuleId_) public pure returns (uint16) {
667         return MTMLib.getEquipmentBaseBonus(spaceCapsuleId_);
668     }
669 
670     // Add GetCurrentItemLevel public view function
671     function getNameOfItem(uint8 itemType_) public pure returns (string memory) {
672         return MTMLib.getNameOfItem(itemType_);
673     }
674     function getCurrentItemLevel(uint256 characterId_, uint8 itemType_) public view returns (uint8) {
675         iCS.Character memory _Character = __getCharacter(characterId_);
676         iCS.Equipment memory _Equipment = __getEquipment(characterId_);
677 
678         uint8 _rarity = getItemRarity(_Character.spaceCapsuleId_, getNameOfItem(itemType_));
679         uint8 _baseEquipmentTier = queryBaseEquipmentTier(_rarity);
680 
681         uint8 _upgrades;
682         if      (itemType_ == 1) { _upgrades = _Equipment.weaponUpgrades_; }
683         else if (itemType_ == 2) { _upgrades = _Equipment.chestUpgrades_; }
684         else if (itemType_ == 3) { _upgrades = _Equipment.headUpgrades_; }
685         else if (itemType_ == 4) { _upgrades = _Equipment.legsUpgrades_; }
686         else if (itemType_ == 5) { _upgrades = _Equipment.vehicleUpgrades_; }
687         else if (itemType_ == 6) { _upgrades = _Equipment.armsUpgrades_; }
688         else if (itemType_ == 7) { _upgrades = _Equipment.artifactUpgrades_; }
689         else if (itemType_ == 8) { _upgrades = _Equipment.ringUpgrades_; }
690         else                     { revert("Invalid Item!"); }
691 
692         return _baseEquipmentTier + _upgrades;
693     }
694 }