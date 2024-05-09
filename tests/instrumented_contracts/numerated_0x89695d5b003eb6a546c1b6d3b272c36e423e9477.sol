1 pragma solidity ^0.4.2;
2 
3 // Make setPrivate payout any pending payouts
4 
5 // ERC20 Token Interface
6 contract Token {
7     uint256 public totalSupply;
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 }
16 
17 // ERC20 Token Implementation
18 contract StandardToken is Token {
19     function transfer(address _to, uint256 _value) public returns (bool success) {
20       if (balances[msg.sender] >= _value && _value > 0) {
21         balances[msg.sender] -= _value;
22         balances[_to] += _value;
23         Transfer(msg.sender, _to, _value);
24         return true;
25       } else {
26         return false;
27       }
28     }
29 
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
31       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
32         balances[_to] += _value;
33         balances[_from] -= _value;
34         allowed[_from][msg.sender] -= _value;
35         Transfer(_from, _to, _value);
36         return true;
37       } else {
38         return false;
39       }
40     }
41 
42     function balanceOf(address _owner) public constant returns (uint256 balance) {
43         return balances[_owner];
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowed[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;
50     }
51 
52     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
53       return allowed[_owner][_spender];
54     }
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 }
59 
60 /*
61     PXLProperty is the ERC20 Cryptocurrency & Cryptocollectable
62     * It is a StandardToken ERC20 token and inherits all of that
63     * It has the Property structure and holds the Properties
64     * It governs the regulators (moderators, admins, root, Property DApps and PixelProperty)
65     * It has getters and setts for all data storage
66     * It selectively allows access to PXL and Properties based on caller access
67     
68     Moderation is handled inside PXLProperty, not by external DApps. It's up to other apps to respect the flags, however
69 */
70 contract PXLProperty is StandardToken {
71     /* Access Level Constants */
72     uint8 constant LEVEL_1_MODERATOR = 1;    // 1: Level 1 Moderator - nsfw-flagging power
73     uint8 constant LEVEL_2_MODERATOR = 2;    // 2: Level 2 Moderator - ban power + [1]
74     uint8 constant LEVEL_1_ADMIN = 3;        // 3: Level 1 Admin - Can manage moderator levels + [1,2]
75     uint8 constant LEVEL_2_ADMIN = 4;        // 4: Level 2 Admin - Can manage admin level 1 levels + [1-3]
76     uint8 constant LEVEL_1_ROOT = 5;         // 5: Level 1 Root - Can set property DApps level [1-4]
77     uint8 constant LEVEL_2_ROOT = 6;         // 6: Level 2 Root - Can set pixelPropertyContract level [1-5]
78     uint8 constant LEVEL_3_ROOT = 7;         // 7: Level 3 Root - Can demote/remove root, transfer root, [1-6]
79     uint8 constant LEVEL_PROPERTY_DAPPS = 8; // 8: Property DApps - Power over manipulating Property data
80     uint8 constant LEVEL_PIXEL_PROPERTY = 9; // 9: PixelProperty - Power over PXL generation & Property ownership
81     /* Flags Constants */
82     uint8 constant FLAG_NSFW = 1;
83     uint8 constant FLAG_BAN = 2;
84     
85     /* Accesser Addresses & Levels */
86     address pixelPropertyContract; // Only contract that has control over PXL creation and Property ownership
87     mapping (address => uint8) public regulators; // Mapping of users/contracts to their control levels
88     
89     // Mapping of PropertyID to Property
90     mapping (uint16 => Property) public properties;
91     // Property Owner's website
92     mapping (address => uint256[2]) public ownerWebsite;
93     // Property Owner's hover text
94     mapping (address => uint256[2]) public ownerHoverText;
95     
96     /* ### Ownable Property Structure ### */
97     struct Property {
98         uint8 flag;
99         bool isInPrivateMode; //Whether in private mode for owner-only use or free-use mode to be shared
100         address owner; //Who owns the Property. If its zero (0), then no owner and known as a "system-Property"
101         address lastUpdater; //Who last changed the color of the Property
102         uint256[5] colors; //10x10 rgb pixel colors per property. colors[0] is the top row, colors[9] is the bottom row
103         uint256 salePrice; //PXL price the owner has the Property on sale for. If zero, then its not for sale.
104         uint256 lastUpdate; //Timestamp of when it had its color last updated
105         uint256 becomePublic; //Timestamp on when to become public
106         uint256 earnUntil; //Timestamp on when Property token generation will stop
107     }
108     
109     /* ### Regulation Access Modifiers ### */
110     modifier regulatorAccess(uint8 accessLevel) {
111         require(accessLevel <= LEVEL_3_ROOT); // Only request moderator, admin or root levels forr regulatorAccess
112         require(regulators[msg.sender] >= accessLevel); // Users must meet requirement
113         if (accessLevel >= LEVEL_1_ADMIN) { //
114             require(regulators[msg.sender] <= LEVEL_3_ROOT); //DApps can't do Admin/Root stuff, but can set nsfw/ban flags
115         }
116         _;
117     }
118     
119     modifier propertyDAppAccess() {
120         require(regulators[msg.sender] == LEVEL_PROPERTY_DAPPS || regulators[msg.sender] == LEVEL_PIXEL_PROPERTY );
121         _;
122     }
123     
124     modifier pixelPropertyAccess() {
125         require(regulators[msg.sender] == LEVEL_PIXEL_PROPERTY);
126         _;
127     }
128     
129     /* ### Constructor ### */
130     function PXLProperty() public {
131         regulators[msg.sender] = LEVEL_3_ROOT; // Creator set to Level 3 Root
132     }
133     
134     /* ### Moderator, Admin & Root Functions ### */
135     // Moderator Flags
136     function setPropertyFlag(uint16 propertyID, uint8 flag) public regulatorAccess(flag == FLAG_NSFW ? LEVEL_1_MODERATOR : LEVEL_2_MODERATOR) {
137         properties[propertyID].flag = flag;
138         if (flag == FLAG_BAN) {
139             require(properties[propertyID].isInPrivateMode); //Can't ban an owner's property if a public user caused the NSFW content
140             properties[propertyID].colors = [0, 0, 0, 0, 0];
141         }
142     }
143     
144     // Setting moderator/admin/root access
145     function setRegulatorAccessLevel(address user, uint8 accessLevel) public regulatorAccess(LEVEL_1_ADMIN) {
146         if (msg.sender != user) {
147             require(regulators[msg.sender] > regulators[user]); // You have to be a higher rank than the user you are changing
148         }
149         require(regulators[msg.sender] > accessLevel); // You have to be a higher rank than the role you are setting
150         regulators[user] = accessLevel;
151     }
152     
153     function setPixelPropertyContract(address newPixelPropertyContract) public regulatorAccess(LEVEL_2_ROOT) {
154         require(newPixelPropertyContract != 0);
155         if (pixelPropertyContract != 0) {
156             regulators[pixelPropertyContract] = 0; //If we already have a pixelPropertyContract, revoke its ownership
157         }
158         
159         pixelPropertyContract = newPixelPropertyContract;
160         regulators[newPixelPropertyContract] = LEVEL_PIXEL_PROPERTY;
161     }
162     
163     function setPropertyDAppContract(address propertyDAppContract, bool giveAccess) public regulatorAccess(LEVEL_1_ROOT) {
164         require(propertyDAppContract != 0);
165         regulators[propertyDAppContract] = giveAccess ? LEVEL_PROPERTY_DAPPS : 0;
166     }
167     
168     /* ### PropertyDapp Functions ### */
169     function setPropertyColors(uint16 propertyID, uint256[5] colors) public propertyDAppAccess() {
170         for(uint256 i = 0; i < 5; i++) {
171             if (properties[propertyID].colors[i] != colors[i]) {
172                 properties[propertyID].colors[i] = colors[i];
173             }
174         }
175     }
176     
177     function setPropertyRowColor(uint16 propertyID, uint8 row, uint256 rowColor) public propertyDAppAccess() {
178         if (properties[propertyID].colors[row] != rowColor) {
179             properties[propertyID].colors[row] = rowColor;
180         }
181     }
182     
183     function setOwnerHoverText(address textOwner, uint256[2] hoverText) public propertyDAppAccess() {
184         require (textOwner != 0);
185         ownerHoverText[textOwner] = hoverText;
186     }
187     
188     function setOwnerLink(address websiteOwner, uint256[2] website) public propertyDAppAccess() {
189         require (websiteOwner != 0);
190         ownerWebsite[websiteOwner] = website;
191     }
192     
193     /* ### PixelProperty Property Functions ### */
194     function setPropertyPrivateMode(uint16 propertyID, bool isInPrivateMode) public pixelPropertyAccess() {
195         if (properties[propertyID].isInPrivateMode != isInPrivateMode) {
196             properties[propertyID].isInPrivateMode = isInPrivateMode;
197         }
198     }
199     
200     function setPropertyOwner(uint16 propertyID, address propertyOwner) public pixelPropertyAccess() {
201         if (properties[propertyID].owner != propertyOwner) {
202             properties[propertyID].owner = propertyOwner;
203         }
204     }
205     
206     function setPropertyLastUpdater(uint16 propertyID, address lastUpdater) public pixelPropertyAccess() {
207         if (properties[propertyID].lastUpdater != lastUpdater) {
208             properties[propertyID].lastUpdater = lastUpdater;
209         }
210     }
211     
212     function setPropertySalePrice(uint16 propertyID, uint256 salePrice) public pixelPropertyAccess() {
213         if (properties[propertyID].salePrice != salePrice) {
214             properties[propertyID].salePrice = salePrice;
215         }
216     }
217     
218     function setPropertyLastUpdate(uint16 propertyID, uint256 lastUpdate) public pixelPropertyAccess() {
219         properties[propertyID].lastUpdate = lastUpdate;
220     }
221     
222     function setPropertyBecomePublic(uint16 propertyID, uint256 becomePublic) public pixelPropertyAccess() {
223         properties[propertyID].becomePublic = becomePublic;
224     }
225     
226     function setPropertyEarnUntil(uint16 propertyID, uint256 earnUntil) public pixelPropertyAccess() {
227         properties[propertyID].earnUntil = earnUntil;
228     }
229     
230     function setPropertyPrivateModeEarnUntilLastUpdateBecomePublic(uint16 propertyID, bool privateMode, uint256 earnUntil, uint256 lastUpdate, uint256 becomePublic) public pixelPropertyAccess() {
231         if (properties[propertyID].isInPrivateMode != privateMode) {
232             properties[propertyID].isInPrivateMode = privateMode;
233         }
234         properties[propertyID].earnUntil = earnUntil;
235         properties[propertyID].lastUpdate = lastUpdate;
236         properties[propertyID].becomePublic = becomePublic;
237     }
238     
239     function setPropertyLastUpdaterLastUpdate(uint16 propertyID, address lastUpdater, uint256 lastUpdate) public pixelPropertyAccess() {
240         if (properties[propertyID].lastUpdater != lastUpdater) {
241             properties[propertyID].lastUpdater = lastUpdater;
242         }
243         properties[propertyID].lastUpdate = lastUpdate;
244     }
245     
246     function setPropertyBecomePublicEarnUntil(uint16 propertyID, uint256 becomePublic, uint256 earnUntil) public pixelPropertyAccess() {
247         properties[propertyID].becomePublic = becomePublic;
248         properties[propertyID].earnUntil = earnUntil;
249     }
250     
251     function setPropertyOwnerSalePricePrivateModeFlag(uint16 propertyID, address owner, uint256 salePrice, bool privateMode, uint8 flag) public pixelPropertyAccess() {
252         if (properties[propertyID].owner != owner) {
253             properties[propertyID].owner = owner;
254         }
255         if (properties[propertyID].salePrice != salePrice) {
256             properties[propertyID].salePrice = salePrice;
257         }
258         if (properties[propertyID].isInPrivateMode != privateMode) {
259             properties[propertyID].isInPrivateMode = privateMode;
260         }
261         if (properties[propertyID].flag != flag) {
262             properties[propertyID].flag = flag;
263         }
264     }
265     
266     function setPropertyOwnerSalePrice(uint16 propertyID, address owner, uint256 salePrice) public pixelPropertyAccess() {
267         if (properties[propertyID].owner != owner) {
268             properties[propertyID].owner = owner;
269         }
270         if (properties[propertyID].salePrice != salePrice) {
271             properties[propertyID].salePrice = salePrice;
272         }
273     }
274     
275     /* ### PixelProperty PXL Functions ### */
276     function rewardPXL(address rewardedUser, uint256 amount) public pixelPropertyAccess() {
277         require(rewardedUser != 0);
278         balances[rewardedUser] += amount;
279         totalSupply += amount;
280     }
281     
282     function burnPXL(address burningUser, uint256 amount) public pixelPropertyAccess() {
283         require(burningUser != 0);
284         require(balances[burningUser] >= amount);
285         balances[burningUser] -= amount;
286         totalSupply -= amount;
287     }
288     
289     function burnPXLRewardPXL(address burner, uint256 toBurn, address rewarder, uint256 toReward) public pixelPropertyAccess() {
290         require(balances[burner] >= toBurn);
291         if (toBurn > 0) {
292             balances[burner] -= toBurn;
293             totalSupply -= toBurn;
294         }
295         if (rewarder != 0) {
296             balances[rewarder] += toReward;
297             totalSupply += toReward;
298         }
299     } 
300     
301     function burnPXLRewardPXLx2(address burner, uint256 toBurn, address rewarder1, uint256 toReward1, address rewarder2, uint256 toReward2) public pixelPropertyAccess() {
302         require(balances[burner] >= toBurn);
303         if (toBurn > 0) {
304             balances[burner] -= toBurn;
305             totalSupply -= toBurn;
306         }
307         if (rewarder1 != 0) {
308             balances[rewarder1] += toReward1;
309             totalSupply += toReward1;
310         }
311         if (rewarder2 != 0) {
312             balances[rewarder2] += toReward2;
313             totalSupply += toReward2;
314         }
315     } 
316     
317     /* ### All Getters/Views ### */
318     function getOwnerHoverText(address user) public view returns(uint256[2]) {
319         return ownerHoverText[user];
320     }
321     
322     function getOwnerLink(address user) public view returns(uint256[2]) {
323         return ownerWebsite[user];
324     }
325     
326     function getPropertyFlag(uint16 propertyID) public view returns(uint8) {
327         return properties[propertyID].flag;
328     }
329     
330     function getPropertyPrivateMode(uint16 propertyID) public view returns(bool) {
331         return properties[propertyID].isInPrivateMode;
332     }
333     
334     function getPropertyOwner(uint16 propertyID) public view returns(address) {
335         return properties[propertyID].owner;
336     }
337     
338     function getPropertyLastUpdater(uint16 propertyID) public view returns(address) {
339         return properties[propertyID].lastUpdater;
340     }
341     
342     function getPropertyColors(uint16 propertyID) public view returns(uint256[5]) {
343         return properties[propertyID].colors;
344     }
345 
346     function getPropertyColorsOfRow(uint16 propertyID, uint8 rowIndex) public view returns(uint256) {
347         require(rowIndex <= 9);
348         return properties[propertyID].colors[rowIndex];
349     }
350     
351     function getPropertySalePrice(uint16 propertyID) public view returns(uint256) {
352         return properties[propertyID].salePrice;
353     }
354     
355     function getPropertyLastUpdate(uint16 propertyID) public view returns(uint256) {
356         return properties[propertyID].lastUpdate;
357     }
358     
359     function getPropertyBecomePublic(uint16 propertyID) public view returns(uint256) {
360         return properties[propertyID].becomePublic;
361     }
362     
363     function getPropertyEarnUntil(uint16 propertyID) public view returns(uint256) {
364         return properties[propertyID].earnUntil;
365     }
366     
367     function getRegulatorLevel(address user) public view returns(uint8) {
368         return regulators[user];
369     }
370     
371     // Gets the (owners address, Ethereum sale price, PXL sale price, last update timestamp, whether its in private mode or not, when it becomes public timestamp, flag) for a Property
372     function getPropertyData(uint16 propertyID, uint256 systemSalePriceETH, uint256 systemSalePricePXL) public view returns(address, uint256, uint256, uint256, bool, uint256, uint8) {
373         Property memory property = properties[propertyID];
374         bool isInPrivateMode = property.isInPrivateMode;
375         //If it's in private, but it has expired and should be public, set our bool to be public
376         if (isInPrivateMode && property.becomePublic <= now) { 
377             isInPrivateMode = false;
378         }
379         if (properties[propertyID].owner == 0) {
380             return (0, systemSalePriceETH, systemSalePricePXL, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
381         } else {
382             return (property.owner, 0, property.salePrice, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
383         }
384     }
385     
386     function getPropertyPrivateModeBecomePublic(uint16 propertyID) public view returns (bool, uint256) {
387         return (properties[propertyID].isInPrivateMode, properties[propertyID].becomePublic);
388     }
389     
390     function getPropertyLastUpdaterBecomePublic(uint16 propertyID) public view returns (address, uint256) {
391         return (properties[propertyID].lastUpdater, properties[propertyID].becomePublic);
392     }
393     
394     function getPropertyOwnerSalePrice(uint16 propertyID) public view returns (address, uint256) {
395         return (properties[propertyID].owner, properties[propertyID].salePrice);
396     }
397     
398     function getPropertyPrivateModeLastUpdateEarnUntil(uint16 propertyID) public view returns (bool, uint256, uint256) {
399         return (properties[propertyID].isInPrivateMode, properties[propertyID].lastUpdate, properties[propertyID].earnUntil);
400     }
401 }
402 
403 // PixelProperty
404 contract VirtualRealEstate {
405     /* ### Variables ### */
406     // Contract owner
407     address owner;
408     PXLProperty pxlProperty;
409     
410     bool initialPropertiesReserved;
411     
412     mapping (uint16 => bool) hasBeenSet;
413     
414     // The amount in % for which a user is paid
415     uint8 constant USER_BUY_CUT_PERCENT = 98;
416     // Maximum amount of generated PXL a property can give away per minute
417     uint8 constant PROPERTY_GENERATES_PER_MINUTE = 1;
418     // The point in time when the initial grace period is over, and users get the default values based on coins burned
419     uint256 GRACE_PERIOD_END_TIMESTAMP;
420     // The amount of time required for a Property to generate tokens for payouts
421     uint256 constant PROPERTY_GENERATION_PAYOUT_INTERVAL = (1 minutes); //Generation amount
422     
423     uint256 ownerEth = 0; // Amount of ETH the contract owner is entitled to withdraw (only Root account can do withdraws)
424     
425     // The current system prices of ETH and PXL, for which unsold Properties are listed for sale at
426     uint256 systemSalePriceETH;
427     uint256 systemSalePricePXL;
428     uint8 systemPixelIncreasePercent;
429     uint8 systemPriceIncreaseStep;
430     uint16 systemETHStepTally;
431     uint16 systemPXLStepTally;
432     uint16 systemETHStepCount;
433     uint16 systemPXLStepCount;
434 
435     /* ### Events ### */
436     event PropertyColorUpdate(uint16 indexed property, uint256[5] colors, uint256 lastUpdate, address indexed lastUpdaterPayee, uint256 becomePublic, uint256 indexed rewardedCoins);
437     event PropertyBought(uint16 indexed property, address indexed newOwner, uint256 ethAmount, uint256 PXLAmount, uint256 timestamp, address indexed oldOwner);
438     event SetUserHoverText(address indexed user, uint256[2] newHoverText);
439     event SetUserSetLink(address indexed user, uint256[2] newLink);
440     event PropertySetForSale(uint16 indexed property, uint256 forSalePrice);
441     event DelistProperty(uint16 indexed property);
442     event SetPropertyPublic(uint16 indexed property);
443     event SetPropertyPrivate(uint16 indexed property, uint32 numMinutesPrivate, address indexed rewardedUser, uint256 indexed rewardedCoins);
444     event Bid(uint16 indexed property, uint256 bid, uint256 timestamp);
445     
446     /* ### MODIFIERS ### */
447 
448     // Only the contract owner can call these methods
449     modifier ownerOnly() {
450         require(owner == msg.sender);
451         _;
452     }
453     
454     // Can only be called on Properties referecing a valid PropertyID
455     modifier validPropertyID(uint16 propertyID) {
456         if (propertyID < 10000) {
457             _;
458         }
459     }
460     
461     /* ### PUBLICALLY INVOKABLE FUNCTIONS ### */
462     
463     /* CONSTRUCTOR */
464     function VirtualRealEstate() public {
465         owner = msg.sender; // Default the owner to be whichever Ethereum account created the contract
466         systemSalePricePXL = 1000; //Initial PXL system price
467         systemSalePriceETH = 19500000000000000; //Initial ETH system price
468         systemPriceIncreaseStep = 10;
469         systemPixelIncreasePercent = 5;
470         systemETHStepTally = 0;
471         systemPXLStepTally = 0;
472         systemETHStepCount = 1;
473         systemPXLStepCount = 1;
474         initialPropertiesReserved = false;
475     }
476     
477     function setPXLPropertyContract(address pxlPropertyContract) public ownerOnly() {
478         pxlProperty = PXLProperty(pxlPropertyContract);
479         if (!initialPropertiesReserved) {
480             uint16 xReserved = 45;
481             uint16 yReserved = 0;
482             for(uint16 x = 0; x < 10; ++x) {
483                 uint16 propertyID = (yReserved) * 100 + (xReserved + x);
484                 _transferProperty(propertyID, owner, 0, 0, 0, 0);
485             }
486             initialPropertiesReserved = true;
487             GRACE_PERIOD_END_TIMESTAMP = now + 3 days; // Extends the three 
488         }
489     }
490 
491     function getSaleInformation() public view ownerOnly() returns(uint8, uint8, uint16, uint16, uint16, uint16) {
492         return (systemPixelIncreasePercent, systemPriceIncreaseStep, systemETHStepTally, systemPXLStepTally, systemETHStepCount, systemPXLStepCount);
493     }
494     
495     /* USER FUNCTIONS */
496     
497     // Property owners can change their hoverText for when a user mouses over their Properties
498     function setHoverText(uint256[2] text) public {
499         pxlProperty.setOwnerHoverText(msg.sender, text);
500         SetUserHoverText(msg.sender, text);
501     }
502     
503     // Property owners can change the clickable link for when a user clicks on their Properties
504     function setLink(uint256[2] website) public {
505         pxlProperty.setOwnerLink(msg.sender, website);
506         SetUserSetLink(msg.sender, website);
507     }
508     
509     // If a Property is private which has expired, make it public
510     function tryForcePublic(uint16 propertyID) public validPropertyID(propertyID) { 
511         var (isInPrivateMode, becomePublic) = pxlProperty.getPropertyPrivateModeBecomePublic(propertyID);
512         if (isInPrivateMode && becomePublic < now) {
513             pxlProperty.setPropertyPrivateMode(propertyID, false);
514         }
515     }
516     
517     // Update the 10x10 image data for a Property, triggering potential payouts if it succeeds
518     function setColors(uint16 propertyID, uint256[5] newColors, uint256 PXLToSpend) public validPropertyID(propertyID) returns(bool) {
519         uint256 projectedPayout = getProjectedPayout(propertyID);
520         if (_tryTriggerPayout(propertyID, PXLToSpend)) {
521             pxlProperty.setPropertyColors(propertyID, newColors);
522             var (lastUpdater, becomePublic) = pxlProperty.getPropertyLastUpdaterBecomePublic(propertyID);
523             PropertyColorUpdate(propertyID, newColors, now, lastUpdater, becomePublic, projectedPayout);
524             // The first user to set a Properties color ever is awarded extra PXL due to eating the extra GAS cost of creating the uint256[5]
525             if (!hasBeenSet[propertyID]) {
526                 pxlProperty.rewardPXL(msg.sender, 25);
527                 hasBeenSet[propertyID] = true;
528             }
529             return true;
530         }
531         return false;
532     }
533 
534     //Wrapper to call setColors 4 times in one call. Reduces overhead, however still duplicate work everywhere to ensure
535     function setColorsX4(uint16[4] propertyIDs, uint256[20] newColors, uint256 PXLToSpendEach) public returns(bool[4]) {
536         bool[4] results;
537         for(uint256 i = 0; i < 4; i++) {
538             require(propertyIDs[i] < 10000);
539             results[i] = setColors(propertyIDs[i], [newColors[i * 5], newColors[i * 5 + 1], newColors[i * 5 + 2], newColors[i * 5 + 3], newColors[i * 5 + 4]], PXLToSpendEach);
540         }
541         return results;
542     }
543 
544     //Wrapper to call setColors 8 times in one call. Reduces overhead, however still duplicate work everywhere to ensure
545     function setColorsX8(uint16[8] propertyIDs, uint256[40] newColors, uint256 PXLToSpendEach) public returns(bool[8]) {
546         bool[8] results;
547         for(uint256 i = 0; i < 8; i++) {
548             require(propertyIDs[i] < 10000);
549             results[i] = setColors(propertyIDs[i], [newColors[i * 5], newColors[i * 5 + 1], newColors[i * 5 + 2], newColors[i * 5 + 3], newColors[i * 5 + 4]], PXLToSpendEach);
550         }
551         return results;
552     }
553     
554     // Update a row of image data for a Property, triggering potential payouts if it succeeds
555     function setRowColors(uint16 propertyID, uint8 row, uint256 newColorData, uint256 PXLToSpend) public validPropertyID(propertyID) returns(bool) {
556         require(row < 10);
557         uint256 projectedPayout = getProjectedPayout(propertyID);
558         if (_tryTriggerPayout(propertyID, PXLToSpend)) {
559             pxlProperty.setPropertyRowColor(propertyID, row, newColorData);
560             var (lastUpdater, becomePublic) = pxlProperty.getPropertyLastUpdaterBecomePublic(propertyID);
561             PropertyColorUpdate(propertyID, pxlProperty.getPropertyColors(propertyID), now, lastUpdater, becomePublic, projectedPayout);
562             return true;
563         }
564         return false;
565     }
566     // Property owners can toggle their Properties between private mode and free-use mode
567     function setPropertyMode(uint16 propertyID, bool setPrivateMode, uint32 numMinutesPrivate) public validPropertyID(propertyID) {
568         var (propertyFlag, propertyIsInPrivateMode, propertyOwner, propertyLastUpdater, propertySalePrice, propertyLastUpdate, propertyBecomePublic, propertyEarnUntil) = pxlProperty.properties(propertyID);
569         
570         require(msg.sender == propertyOwner);
571         uint256 whenToBecomePublic = 0;
572         uint256 rewardedAmount = 0;
573         
574         if (setPrivateMode) {
575             //If inprivate, we can extend the duration, otherwise if becomePublic > now it means a free-use user locked it
576             require(propertyIsInPrivateMode || propertyBecomePublic <= now || propertyLastUpdater == msg.sender ); 
577             require(numMinutesPrivate > 0);
578             require(pxlProperty.balanceOf(msg.sender) >= numMinutesPrivate);
579             // Determines when the Property becomes public, one payout interval per coin burned
580             whenToBecomePublic = (now < propertyBecomePublic ? propertyBecomePublic : now) + PROPERTY_GENERATION_PAYOUT_INTERVAL * numMinutesPrivate;
581 
582             rewardedAmount = getProjectedPayout(propertyIsInPrivateMode, propertyLastUpdate, propertyEarnUntil);
583             if (rewardedAmount > 0 && propertyLastUpdater != 0) {
584                 pxlProperty.burnPXLRewardPXLx2(msg.sender, numMinutesPrivate, propertyLastUpdater, rewardedAmount, msg.sender, rewardedAmount);
585             } else {
586                 pxlProperty.burnPXL(msg.sender, numMinutesPrivate);
587             }
588 
589         } else {
590             // If its in private mode and still has time left, reimburse them for N-1 minutes tokens back
591             if (propertyIsInPrivateMode && propertyBecomePublic > now) {
592                 pxlProperty.rewardPXL(msg.sender, ((propertyBecomePublic - now) / PROPERTY_GENERATION_PAYOUT_INTERVAL) - 1);
593             }
594         }
595         
596         pxlProperty.setPropertyPrivateModeEarnUntilLastUpdateBecomePublic(propertyID, setPrivateMode, 0, 0, whenToBecomePublic);
597         
598         if (setPrivateMode) {
599             SetPropertyPrivate(propertyID, numMinutesPrivate, propertyLastUpdater, rewardedAmount);
600         } else {
601             SetPropertyPublic(propertyID);
602         }
603     }
604     // Transfer Property ownership between accounts. This has no cost, no cut and does not change flag status
605     function transferProperty(uint16 propertyID, address newOwner) public validPropertyID(propertyID) returns(bool) {
606         require(pxlProperty.getPropertyOwner(propertyID) == msg.sender);
607         _transferProperty(propertyID, newOwner, 0, 0, pxlProperty.getPropertyFlag(propertyID), msg.sender);
608         return true;
609     }
610     // Purchase a unowned system-Property in a combination of PXL and ETH
611     function buyProperty(uint16 propertyID, uint256 pxlValue) public validPropertyID(propertyID) payable returns(bool) {
612         //Must be the first purchase, otherwise do it with PXL from another user
613         require(pxlProperty.getPropertyOwner(propertyID) == 0);
614         // Must be able to afford the given PXL
615         require(pxlProperty.balanceOf(msg.sender) >= pxlValue);
616         require(pxlValue != 0);
617         
618         // Protect against underflow
619         require(pxlValue <= systemSalePricePXL);
620         uint256 pxlLeft = systemSalePricePXL - pxlValue;
621         uint256 ethLeft = systemSalePriceETH / systemSalePricePXL * pxlLeft;
622         
623         // Must have spent enough ETH to cover the ETH left after PXL price was subtracted
624         require(msg.value >= ethLeft);
625         
626         pxlProperty.burnPXLRewardPXL(msg.sender, pxlValue, owner, pxlValue);
627         
628         systemPXLStepTally += uint16(100 * pxlValue / systemSalePricePXL);
629         if (systemPXLStepTally >= 1000) {
630              systemPXLStepCount++;
631             systemSalePricePXL += systemSalePricePXL * 9 / systemPXLStepCount / 10;
632             systemPXLStepTally -= 1000;
633         }
634         
635         ownerEth += msg.value;
636 
637         systemETHStepTally += uint16(100 * pxlLeft / systemSalePricePXL);
638         if (systemETHStepTally >= 1000) {
639             systemETHStepCount++;
640             systemSalePriceETH += systemSalePriceETH * 9 / systemETHStepCount / 10;
641             systemETHStepTally -= 1000;
642         }
643 
644         _transferProperty(propertyID, msg.sender, msg.value, pxlValue, 0, 0);
645         
646         return true;
647     }
648     // Purchase a listed user-owner Property in PXL
649     function buyPropertyInPXL(uint16 propertyID, uint256 PXLValue) public validPropertyID(propertyID) {
650         // If Property is system-owned
651         var (propertyOwner, propertySalePrice) = pxlProperty.getPropertyOwnerSalePrice(propertyID);
652         address originalOwner = propertyOwner;
653         if (propertyOwner == 0) {
654             // Turn it into a user-owned at system price with contract owner as owner
655             pxlProperty.setPropertyOwnerSalePrice(propertyID, owner, systemSalePricePXL);
656             propertyOwner = owner;
657             propertySalePrice = systemSalePricePXL;
658             // Increase system PXL price
659             systemPXLStepTally += 100;
660             if (systemPXLStepTally >= 1000) {
661                 systemPXLStepCount++;
662                 systemSalePricePXL += systemSalePricePXL * 9 / systemPXLStepCount / 10;
663                 systemPXLStepTally -= 1000;
664             }
665         }
666         require(propertySalePrice <= PXLValue);
667         uint256 amountTransfered = propertySalePrice * USER_BUY_CUT_PERCENT / 100;
668         pxlProperty.burnPXLRewardPXLx2(msg.sender, propertySalePrice, propertyOwner, amountTransfered, owner, (propertySalePrice - amountTransfered));        
669         _transferProperty(propertyID, msg.sender, 0, propertySalePrice, 0, originalOwner);
670     }
671 
672     // Purchase a system-Property in pure ETH
673     function buyPropertyInETH(uint16 propertyID) public validPropertyID(propertyID) payable returns(bool) {
674         require(pxlProperty.getPropertyOwner(propertyID) == 0);
675         require(msg.value >= systemSalePriceETH);
676         
677         ownerEth += msg.value;
678         systemETHStepTally += 100;
679         if (systemETHStepTally >= 1000) {
680             systemETHStepCount++;
681             systemSalePriceETH += systemSalePriceETH * 9 / systemETHStepCount / 10;
682             systemETHStepTally -= 1000;
683         }
684         _transferProperty(propertyID, msg.sender, msg.value, 0, 0, 0);
685         return true;
686     }
687     
688     // Property owner lists their Property for sale at their preferred price
689     function listForSale(uint16 propertyID, uint256 price) public validPropertyID(propertyID) returns(bool) {
690         require(price != 0);
691         require(msg.sender == pxlProperty.getPropertyOwner(propertyID));
692         pxlProperty.setPropertySalePrice(propertyID, price);
693         PropertySetForSale(propertyID, price);
694         return true;
695     }
696     
697     // Property owner delists their Property from being for sale
698     function delist(uint16 propertyID) public validPropertyID(propertyID) returns(bool) {
699         require(msg.sender == pxlProperty.getPropertyOwner(propertyID));
700         pxlProperty.setPropertySalePrice(propertyID, 0);
701         DelistProperty(propertyID);
702         return true;
703     }
704 
705     // Make a public bid and notify a Property owner of your bid. Burn 1 coin
706     function makeBid(uint16 propertyID, uint256 bidAmount) public validPropertyID(propertyID) {
707         require(bidAmount > 0);
708         require(pxlProperty.balanceOf(msg.sender) >= 1 + bidAmount);
709         Bid(propertyID, bidAmount, now);
710         pxlProperty.burnPXL(msg.sender, 1);
711     }
712     
713     /* CONTRACT OWNER FUNCTIONS */
714     
715     // Contract owner can withdraw up to ownerEth amount
716     function withdraw(uint256 amount) public ownerOnly() {
717         if (amount <= ownerEth) {
718             owner.transfer(amount);
719             ownerEth -= amount;
720         }
721     }
722     
723     // Contract owner can withdraw ownerEth amount
724     function withdrawAll() public ownerOnly() {
725         owner.transfer(ownerEth);
726         ownerEth = 0;
727     }
728     
729     // Contract owner can change who is the contract owner
730     function changeOwners(address newOwner) public ownerOnly() {
731         owner = newOwner;
732     }
733     
734     /* ## PRIVATE FUNCTIONS ## */
735     
736     // Function which wraps payouts for setColors
737     function _tryTriggerPayout(uint16 propertyID, uint256 pxlToSpend) private returns(bool) {
738         var (propertyFlag, propertyIsInPrivateMode, propertyOwner, propertyLastUpdater, propertySalePrice, propertyLastUpdate, propertyBecomePublic, propertyEarnUntil) = pxlProperty.properties(propertyID);
739         //If the Property is in private mode and expired, make it public
740         if (propertyIsInPrivateMode && propertyBecomePublic <= now) {
741             pxlProperty.setPropertyPrivateMode(propertyID, false);
742             propertyIsInPrivateMode = false;
743         }
744         //If its in private mode, only the owner can interact with it
745         if (propertyIsInPrivateMode) {
746             require(msg.sender == propertyOwner);
747             require(propertyFlag != 2);
748         //If if its in free-use mode
749         } else if (propertyBecomePublic <= now || propertyLastUpdater == msg.sender) {
750             uint256 pxlSpent = pxlToSpend + 1; //All pxlSpent math uses N+1, so built in for convenience
751             if (isInGracePeriod() && pxlToSpend < 2) { //If first 3 days and we spent <2 coins, treat it as if we spent 2
752                 pxlSpent = 3; //We're treating it like 2, but it's N+1 in the math using this
753             }
754             
755             uint256 projectedAmount = getProjectedPayout(propertyIsInPrivateMode, propertyLastUpdate, propertyEarnUntil);
756             pxlProperty.burnPXLRewardPXLx2(msg.sender, pxlToSpend, propertyLastUpdater, projectedAmount, propertyOwner, projectedAmount);
757             
758             //BecomePublic = (N+1)/2 minutes of user-private mode
759             //EarnUntil = (N+1)*5 coins earned max/minutes we can earn from
760             pxlProperty.setPropertyBecomePublicEarnUntil(propertyID, now + (pxlSpent * PROPERTY_GENERATION_PAYOUT_INTERVAL / 2), now + (pxlSpent * 5 * PROPERTY_GENERATION_PAYOUT_INTERVAL));
761         } else {
762             return false;
763         }
764         pxlProperty.setPropertyLastUpdaterLastUpdate(propertyID, msg.sender, now);
765         return true;
766     }
767     // Transfer ownership of a Property and reset their info
768     function _transferProperty(uint16 propertyID, address newOwner, uint256 ethAmount, uint256 PXLAmount, uint8 flag, address oldOwner) private {
769         require(newOwner != 0);
770         pxlProperty.setPropertyOwnerSalePricePrivateModeFlag(propertyID, newOwner, 0, false, flag);
771         PropertyBought(propertyID, newOwner, ethAmount, PXLAmount, now, oldOwner);
772     }
773     
774     // Gets the (owners address, Ethereum sale price, PXL sale price, last update timestamp, whether its in private mode or not, when it becomes public timestamp, flag) for a Property
775     function getPropertyData(uint16 propertyID) public validPropertyID(propertyID) view returns(address, uint256, uint256, uint256, bool, uint256, uint32) {
776         return pxlProperty.getPropertyData(propertyID, systemSalePriceETH, systemSalePricePXL);
777     }
778     
779     // Gets the system ETH and PXL prices
780     function getSystemSalePrices() public view returns(uint256, uint256) {
781         return (systemSalePriceETH, systemSalePricePXL);
782     }
783     
784     // Gets the sale prices of any Property in ETH and PXL
785     function getForSalePrices(uint16 propertyID) public validPropertyID(propertyID) view returns(uint256, uint256) {
786         if (pxlProperty.getPropertyOwner(propertyID) == 0) {
787             return getSystemSalePrices();
788         } else {
789             return (0, pxlProperty.getPropertySalePrice(propertyID));
790         }
791     }
792     
793     // Gets the projected sale price for a property should it be triggered at this very moment
794     function getProjectedPayout(uint16 propertyID) public view returns(uint256) {
795         var (propertyIsInPrivateMode, propertyLastUpdate, propertyEarnUntil) = pxlProperty.getPropertyPrivateModeLastUpdateEarnUntil(propertyID);
796         return getProjectedPayout(propertyIsInPrivateMode, propertyLastUpdate, propertyEarnUntil);
797     }
798     
799     function getProjectedPayout(bool propertyIsInPrivateMode, uint256 propertyLastUpdate, uint256 propertyEarnUntil) public view returns(uint256) {
800         if (!propertyIsInPrivateMode && propertyLastUpdate != 0) {
801             uint256 earnedUntil = (now < propertyEarnUntil) ? now : propertyEarnUntil;
802             uint256 minutesSinceLastColourChange = (earnedUntil - propertyLastUpdate) / PROPERTY_GENERATION_PAYOUT_INTERVAL;
803             return minutesSinceLastColourChange * PROPERTY_GENERATES_PER_MINUTE;
804             //return (((now < propertyEarnUntil) ? now : propertyEarnUntil - propertyLastUpdate) / PROPERTY_GENERATION_PAYOUT_INTERVAL) * PROPERTY_GENERATES_PER_MINUTE; //Gave too high number wtf?
805         }
806         return 0;
807     }
808     
809     // Gets whether the contract is still in the intial grace period where we give extra features to color setters
810     function isInGracePeriod() public view returns(bool) {
811         return now <= GRACE_PERIOD_END_TIMESTAMP;
812     }
813 }