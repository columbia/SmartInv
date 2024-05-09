1 pragma solidity ^0.4.2;
2 // Make setPrivate payout any pending payouts
3 
4 // ERC20 Token Interface
5 contract Token {
6     uint256 public totalSupply;
7     function balanceOf(address _owner) public constant returns (uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 // ERC20 Token Implementation
17 contract StandardToken is Token {
18     function transfer(address _to, uint256 _value) public returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) public constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 /*
60     PXLProperty is the ERC20 Cryptocurrency & Cryptocollectable
61     * It is a StandardToken ERC20 token and inherits all of that
62     * It has the Property structure and holds the Properties
63     * It governs the regulators (moderators, admins, root, Property DApps and PixelProperty)
64     * It has getters and setts for all data storage
65     * It selectively allows access to PXL and Properties based on caller access
66     
67     Moderation is handled inside PXLProperty, not by external DApps. It's up to other apps to respect the flags, however
68 */
69 contract PXLProperty is StandardToken {
70     /* ERC-20 MetaData */
71     string public constant name = "PixelPropertyToken";
72     string public constant symbol = "PXL";
73     uint256 public constant decimals = 0;
74     
75     /* Access Level Constants */
76     uint8 constant LEVEL_1_MODERATOR = 1;    // 1: Level 1 Moderator - nsfw-flagging power
77     uint8 constant LEVEL_2_MODERATOR = 2;    // 2: Level 2 Moderator - ban power + [1]
78     uint8 constant LEVEL_1_ADMIN = 3;        // 3: Level 1 Admin - Can manage moderator levels + [1,2]
79     uint8 constant LEVEL_2_ADMIN = 4;        // 4: Level 2 Admin - Can manage admin level 1 levels + [1-3]
80     uint8 constant LEVEL_1_ROOT = 5;         // 5: Level 1 Root - Can set property DApps level [1-4]
81     uint8 constant LEVEL_2_ROOT = 6;         // 6: Level 2 Root - Can set pixelPropertyContract level [1-5]
82     uint8 constant LEVEL_3_ROOT = 7;         // 7: Level 3 Root - Can demote/remove root, transfer root, [1-6]
83     uint8 constant LEVEL_PROPERTY_DAPPS = 8; // 8: Property DApps - Power over manipulating Property data
84     uint8 constant LEVEL_PIXEL_PROPERTY = 9; // 9: PixelProperty - Power over PXL generation & Property ownership
85     /* Flags Constants */
86     uint8 constant FLAG_NSFW = 1;
87     uint8 constant FLAG_BAN = 2;
88     
89     /* Accesser Addresses & Levels */
90     address pixelPropertyContract; // Only contract that has control over PXL creation and Property ownership
91     mapping (address => uint8) public regulators; // Mapping of users/contracts to their control levels
92     
93     // Mapping of PropertyID to Property
94     mapping (uint16 => Property) public properties;
95     // Property Owner's website
96     mapping (address => uint256[2]) public ownerWebsite;
97     // Property Owner's hover text
98     mapping (address => uint256[2]) public ownerHoverText;
99     // Whether migration is occuring or not
100     bool inMigrationPeriod;
101     // Old PXLProperty Contract from before update we migrate data from
102     PXLProperty oldPXLProperty;
103     
104     /* ### Ownable Property Structure ### */
105     struct Property {
106         uint8 flag;
107         bool isInPrivateMode; //Whether in private mode for owner-only use or free-use mode to be shared
108         address owner; //Who owns the Property. If its zero (0), then no owner and known as a "system-Property"
109         address lastUpdater; //Who last changed the color of the Property
110         uint256[5] colors; //10x10 rgb pixel colors per property. colors[0] is the top row, colors[9] is the bottom row
111         uint256 salePrice; //PXL price the owner has the Property on sale for. If zero, then its not for sale.
112         uint256 lastUpdate; //Timestamp of when it had its color last updated
113         uint256 becomePublic; //Timestamp on when to become public
114         uint256 earnUntil; //Timestamp on when Property token generation will stop
115     }
116     
117     /* ### Regulation Access Modifiers ### */
118     modifier regulatorAccess(uint8 accessLevel) {
119         require(accessLevel <= LEVEL_3_ROOT); // Only request moderator, admin or root levels forr regulatorAccess
120         require(regulators[msg.sender] >= accessLevel); // Users must meet requirement
121         if (accessLevel >= LEVEL_1_ADMIN) { //
122             require(regulators[msg.sender] <= LEVEL_3_ROOT); //DApps can't do Admin/Root stuff, but can set nsfw/ban flags
123         }
124         _;
125     }
126     
127     modifier propertyDAppAccess() {
128         require(regulators[msg.sender] == LEVEL_PROPERTY_DAPPS || regulators[msg.sender] == LEVEL_PIXEL_PROPERTY );
129         _;
130     }
131     
132     modifier pixelPropertyAccess() {
133         require(regulators[msg.sender] == LEVEL_PIXEL_PROPERTY);
134         _;
135     }
136     
137     /* ### Constructor ### */
138     function PXLProperty(address oldAddress) public {
139         inMigrationPeriod = true;
140         oldPXLProperty = PXLProperty(oldAddress);
141         regulators[msg.sender] = LEVEL_3_ROOT; // Creator set to Level 3 Root
142     }
143     
144     /* ### Moderator, Admin & Root Functions ### */
145     // Moderator Flags
146     function setPropertyFlag(uint16 propertyID, uint8 flag) public regulatorAccess(flag == FLAG_NSFW ? LEVEL_1_MODERATOR : LEVEL_2_MODERATOR) {
147         properties[propertyID].flag = flag;
148         if (flag == FLAG_BAN) {
149             require(properties[propertyID].isInPrivateMode); //Can't ban an owner's property if a public user caused the NSFW content
150             properties[propertyID].colors = [0, 0, 0, 0, 0];
151         }
152     }
153     
154     // Setting moderator/admin/root access
155     function setRegulatorAccessLevel(address user, uint8 accessLevel) public regulatorAccess(LEVEL_1_ADMIN) {
156         if (msg.sender != user) {
157             require(regulators[msg.sender] > regulators[user]); // You have to be a higher rank than the user you are changing
158         }
159         require(regulators[msg.sender] > accessLevel); // You have to be a higher rank than the role you are setting
160         regulators[user] = accessLevel;
161     }
162     
163     function setPixelPropertyContract(address newPixelPropertyContract) public regulatorAccess(LEVEL_2_ROOT) {
164         require(newPixelPropertyContract != 0);
165         if (pixelPropertyContract != 0) {
166             regulators[pixelPropertyContract] = 0; //If we already have a pixelPropertyContract, revoke its ownership
167         }
168         
169         pixelPropertyContract = newPixelPropertyContract;
170         regulators[newPixelPropertyContract] = LEVEL_PIXEL_PROPERTY;
171     }
172     
173     function setPropertyDAppContract(address propertyDAppContract, bool giveAccess) public regulatorAccess(LEVEL_1_ROOT) {
174         require(propertyDAppContract != 0);
175         regulators[propertyDAppContract] = giveAccess ? LEVEL_PROPERTY_DAPPS : 0;
176     }
177     
178         
179     /* ### Migration Functions Post Update ### */
180     //Migrates the owners of Properties
181     function migratePropertyOwnership(uint16[10] propertiesToCopy) public regulatorAccess(LEVEL_3_ROOT) {
182         require(inMigrationPeriod);
183         for(uint16 i = 0; i < 10; i++) {
184             if (propertiesToCopy[i] < 10000) {
185                 if (properties[propertiesToCopy[i]].owner == 0) { //Only migrate if there is no current owner
186                     properties[propertiesToCopy[i]].owner = oldPXLProperty.getPropertyOwner(propertiesToCopy[i]);
187                 }
188             }
189         }
190     }
191     
192     //Migrates the PXL balances of users
193     function migrateUsers(address[10] usersToMigrate) public regulatorAccess(LEVEL_3_ROOT) {
194         require(inMigrationPeriod);
195         for(uint16 i = 0; i < 10; i++) {
196             if(balances[usersToMigrate[i]] == 0) { //Only migrate if they have no funds to avoid duplicate migrations
197                 uint256 oldBalance = oldPXLProperty.balanceOf(usersToMigrate[i]);
198                 if (oldBalance > 0) {
199                     balances[usersToMigrate[i]] = oldBalance;
200                     totalSupply += oldBalance;
201                     Transfer(0, usersToMigrate[i], oldBalance);
202                 }
203             }
204         }
205     }
206     
207     //Perminantly ends migration so it cannot be abused after it is deemed complete
208     function endMigrationPeriod() public regulatorAccess(LEVEL_3_ROOT) {
209         inMigrationPeriod = false;
210     }
211     
212     /* ### PropertyDapp Functions ### */
213     function setPropertyColors(uint16 propertyID, uint256[5] colors) public propertyDAppAccess() {
214         for(uint256 i = 0; i < 5; i++) {
215             if (properties[propertyID].colors[i] != colors[i]) {
216                 properties[propertyID].colors[i] = colors[i];
217             }
218         }
219     }
220     
221     function setPropertyRowColor(uint16 propertyID, uint8 row, uint256 rowColor) public propertyDAppAccess() {
222         if (properties[propertyID].colors[row] != rowColor) {
223             properties[propertyID].colors[row] = rowColor;
224         }
225     }
226     
227     function setOwnerHoverText(address textOwner, uint256[2] hoverText) public propertyDAppAccess() {
228         require (textOwner != 0);
229         ownerHoverText[textOwner] = hoverText;
230     }
231     
232     function setOwnerLink(address websiteOwner, uint256[2] website) public propertyDAppAccess() {
233         require (websiteOwner != 0);
234         ownerWebsite[websiteOwner] = website;
235     }
236     
237     /* ### PixelProperty Property Functions ### */
238     function setPropertyPrivateMode(uint16 propertyID, bool isInPrivateMode) public pixelPropertyAccess() {
239         if (properties[propertyID].isInPrivateMode != isInPrivateMode) {
240             properties[propertyID].isInPrivateMode = isInPrivateMode;
241         }
242     }
243     
244     function setPropertyOwner(uint16 propertyID, address propertyOwner) public pixelPropertyAccess() {
245         if (properties[propertyID].owner != propertyOwner) {
246             properties[propertyID].owner = propertyOwner;
247         }
248     }
249     
250     function setPropertyLastUpdater(uint16 propertyID, address lastUpdater) public pixelPropertyAccess() {
251         if (properties[propertyID].lastUpdater != lastUpdater) {
252             properties[propertyID].lastUpdater = lastUpdater;
253         }
254     }
255     
256     function setPropertySalePrice(uint16 propertyID, uint256 salePrice) public pixelPropertyAccess() {
257         if (properties[propertyID].salePrice != salePrice) {
258             properties[propertyID].salePrice = salePrice;
259         }
260     }
261     
262     function setPropertyLastUpdate(uint16 propertyID, uint256 lastUpdate) public pixelPropertyAccess() {
263         properties[propertyID].lastUpdate = lastUpdate;
264     }
265     
266     function setPropertyBecomePublic(uint16 propertyID, uint256 becomePublic) public pixelPropertyAccess() {
267         properties[propertyID].becomePublic = becomePublic;
268     }
269     
270     function setPropertyEarnUntil(uint16 propertyID, uint256 earnUntil) public pixelPropertyAccess() {
271         properties[propertyID].earnUntil = earnUntil;
272     }
273     
274     function setPropertyPrivateModeEarnUntilLastUpdateBecomePublic(uint16 propertyID, bool privateMode, uint256 earnUntil, uint256 lastUpdate, uint256 becomePublic) public pixelPropertyAccess() {
275         if (properties[propertyID].isInPrivateMode != privateMode) {
276             properties[propertyID].isInPrivateMode = privateMode;
277         }
278         properties[propertyID].earnUntil = earnUntil;
279         properties[propertyID].lastUpdate = lastUpdate;
280         properties[propertyID].becomePublic = becomePublic;
281     }
282     
283     function setPropertyLastUpdaterLastUpdate(uint16 propertyID, address lastUpdater, uint256 lastUpdate) public pixelPropertyAccess() {
284         if (properties[propertyID].lastUpdater != lastUpdater) {
285             properties[propertyID].lastUpdater = lastUpdater;
286         }
287         properties[propertyID].lastUpdate = lastUpdate;
288     }
289     
290     function setPropertyBecomePublicEarnUntil(uint16 propertyID, uint256 becomePublic, uint256 earnUntil) public pixelPropertyAccess() {
291         properties[propertyID].becomePublic = becomePublic;
292         properties[propertyID].earnUntil = earnUntil;
293     }
294     
295     function setPropertyOwnerSalePricePrivateModeFlag(uint16 propertyID, address owner, uint256 salePrice, bool privateMode, uint8 flag) public pixelPropertyAccess() {
296         if (properties[propertyID].owner != owner) {
297             properties[propertyID].owner = owner;
298         }
299         if (properties[propertyID].salePrice != salePrice) {
300             properties[propertyID].salePrice = salePrice;
301         }
302         if (properties[propertyID].isInPrivateMode != privateMode) {
303             properties[propertyID].isInPrivateMode = privateMode;
304         }
305         if (properties[propertyID].flag != flag) {
306             properties[propertyID].flag = flag;
307         }
308     }
309     
310     function setPropertyOwnerSalePrice(uint16 propertyID, address owner, uint256 salePrice) public pixelPropertyAccess() {
311         if (properties[propertyID].owner != owner) {
312             properties[propertyID].owner = owner;
313         }
314         if (properties[propertyID].salePrice != salePrice) {
315             properties[propertyID].salePrice = salePrice;
316         }
317     }
318     
319     /* ### PixelProperty PXL Functions ### */
320     function rewardPXL(address rewardedUser, uint256 amount) public pixelPropertyAccess() {
321         require(rewardedUser != 0);
322         balances[rewardedUser] += amount;
323         totalSupply += amount;
324         Transfer(0, rewardedUser, amount);
325     }
326     
327     function burnPXL(address burningUser, uint256 amount) public pixelPropertyAccess() {
328         require(burningUser != 0);
329         require(balances[burningUser] >= amount);
330         balances[burningUser] -= amount;
331         totalSupply -= amount;
332         Transfer(burningUser, 0, amount);
333     }
334     
335     function burnPXLRewardPXL(address burner, uint256 toBurn, address rewarder, uint256 toReward) public pixelPropertyAccess() {
336         require(balances[burner] >= toBurn);
337         if (toBurn > 0) {
338             balances[burner] -= toBurn;
339             totalSupply -= toBurn;
340             Transfer(burner, 0, toBurn);
341         }
342         if (rewarder != 0) {
343             balances[rewarder] += toReward;
344             totalSupply += toReward;
345             Transfer(0, rewarder, toReward);
346         }
347     } 
348     
349     function burnPXLRewardPXLx2(address burner, uint256 toBurn, address rewarder1, uint256 toReward1, address rewarder2, uint256 toReward2) public pixelPropertyAccess() {
350         require(balances[burner] >= toBurn);
351         if (toBurn > 0) {
352             balances[burner] -= toBurn;
353             totalSupply -= toBurn;
354             Transfer(burner, 0, toBurn);
355         }
356         if (rewarder1 != 0) {
357             balances[rewarder1] += toReward1;
358             totalSupply += toReward1;
359             Transfer(0, rewarder1, toReward1);
360         }
361         if (rewarder2 != 0) {
362             balances[rewarder2] += toReward2;
363             totalSupply += toReward2;
364             Transfer(0, rewarder2, toReward2);
365         }
366     }
367     
368     /* ### All Getters/Views ### */
369     function getOwnerHoverText(address user) public view returns(uint256[2]) {
370         return ownerHoverText[user];
371     }
372     
373     function getOwnerLink(address user) public view returns(uint256[2]) {
374         return ownerWebsite[user];
375     }
376     
377     function getPropertyFlag(uint16 propertyID) public view returns(uint8) {
378         return properties[propertyID].flag;
379     }
380     
381     function getPropertyPrivateMode(uint16 propertyID) public view returns(bool) {
382         return properties[propertyID].isInPrivateMode;
383     }
384     
385     function getPropertyOwner(uint16 propertyID) public view returns(address) {
386         return properties[propertyID].owner;
387     }
388     
389     function getPropertyLastUpdater(uint16 propertyID) public view returns(address) {
390         return properties[propertyID].lastUpdater;
391     }
392     
393     function getPropertyColors(uint16 propertyID) public view returns(uint256[5]) {
394         if (properties[propertyID].colors[0] != 0 || properties[propertyID].colors[1] != 0 || properties[propertyID].colors[2] != 0 || properties[propertyID].colors[3] != 0 || properties[propertyID].colors[4] != 0) {
395             return properties[propertyID].colors;
396         } else {
397             return oldPXLProperty.getPropertyColors(propertyID);
398         }
399     }
400 
401     function getPropertyColorsOfRow(uint16 propertyID, uint8 rowIndex) public view returns(uint256) {
402         require(rowIndex <= 9);
403         return getPropertyColors(propertyID)[rowIndex];
404     }
405     
406     function getPropertySalePrice(uint16 propertyID) public view returns(uint256) {
407         return properties[propertyID].salePrice;
408     }
409     
410     function getPropertyLastUpdate(uint16 propertyID) public view returns(uint256) {
411         return properties[propertyID].lastUpdate;
412     }
413     
414     function getPropertyBecomePublic(uint16 propertyID) public view returns(uint256) {
415         return properties[propertyID].becomePublic;
416     }
417     
418     function getPropertyEarnUntil(uint16 propertyID) public view returns(uint256) {
419         return properties[propertyID].earnUntil;
420     }
421     
422     function getRegulatorLevel(address user) public view returns(uint8) {
423         return regulators[user];
424     }
425     
426     // Gets the (owners address, Ethereum sale price, PXL sale price, last update timestamp, whether its in private mode or not, when it becomes public timestamp, flag) for a Property
427     function getPropertyData(uint16 propertyID, uint256 systemSalePriceETH, uint256 systemSalePricePXL) public view returns(address, uint256, uint256, uint256, bool, uint256, uint8) {
428         Property memory property = properties[propertyID];
429         bool isInPrivateMode = property.isInPrivateMode;
430         //If it's in private, but it has expired and should be public, set our bool to be public
431         if (isInPrivateMode && property.becomePublic <= now) { 
432             isInPrivateMode = false;
433         }
434         if (properties[propertyID].owner == 0) {
435             return (0, systemSalePriceETH, systemSalePricePXL, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
436         } else {
437             return (property.owner, 0, property.salePrice, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
438         }
439     }
440     
441     function getPropertyPrivateModeBecomePublic(uint16 propertyID) public view returns (bool, uint256) {
442         return (properties[propertyID].isInPrivateMode, properties[propertyID].becomePublic);
443     }
444     
445     function getPropertyLastUpdaterBecomePublic(uint16 propertyID) public view returns (address, uint256) {
446         return (properties[propertyID].lastUpdater, properties[propertyID].becomePublic);
447     }
448     
449     function getPropertyOwnerSalePrice(uint16 propertyID) public view returns (address, uint256) {
450         return (properties[propertyID].owner, properties[propertyID].salePrice);
451     }
452     
453     function getPropertyPrivateModeLastUpdateEarnUntil(uint16 propertyID) public view returns (bool, uint256, uint256) {
454         return (properties[propertyID].isInPrivateMode, properties[propertyID].lastUpdate, properties[propertyID].earnUntil);
455     }
456 }