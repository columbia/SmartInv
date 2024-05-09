1 pragma solidity ^0.4.2;
2 
3 // ERC20 Token Interface
4 contract Token {
5     uint256 public totalSupply;
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 // ERC20 Token Implementation
16 contract StandardToken is Token {
17     function transfer(address _to, uint256 _value) public returns (bool success) {
18       if (balances[msg.sender] >= _value && _value > 0) {
19         balances[msg.sender] -= _value;
20         balances[_to] += _value;
21         Transfer(msg.sender, _to, _value);
22         return true;
23       } else {
24         return false;
25       }
26     }
27 
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
29       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
30         balances[_to] += _value;
31         balances[_from] -= _value;
32         allowed[_from][msg.sender] -= _value;
33         Transfer(_from, _to, _value);
34         return true;
35       } else {
36         return false;
37       }
38     }
39 
40     function balanceOf(address _owner) public constant returns (uint256 balance) {
41         return balances[_owner];
42     }
43 
44     function approve(address _spender, uint256 _value) public returns (bool success) {
45         allowed[msg.sender][_spender] = _value;
46         Approval(msg.sender, _spender, _value);
47         return true;
48     }
49 
50     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
51       return allowed[_owner][_spender];
52     }
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56 }
57 
58 /*
59     PXLProperty is the ERC20 Cryptocurrency & Cryptocollectable
60     * It is a StandardToken ERC20 token and inherits all of that
61     * It has the Property structure and holds the Properties
62     * It governs the regulators (moderators, admins, root, Property DApps and PixelProperty)
63     * It has getters and setts for all data storage
64     * It selectively allows access to PXL and Properties based on caller access
65     
66     Moderation is handled inside PXLProperty, not by external DApps. It's up to other apps to respect the flags, however
67 */
68 contract PXLProperty is StandardToken {
69     /* Access Level Constants */
70     uint8 constant LEVEL_1_MODERATOR = 1;    // 1: Level 1 Moderator - nsfw-flagging power
71     uint8 constant LEVEL_2_MODERATOR = 2;    // 2: Level 2 Moderator - ban power + [1]
72     uint8 constant LEVEL_1_ADMIN = 3;        // 3: Level 1 Admin - Can manage moderator levels + [1,2]
73     uint8 constant LEVEL_2_ADMIN = 4;        // 4: Level 2 Admin - Can manage admin level 1 levels + [1-3]
74     uint8 constant LEVEL_1_ROOT = 5;         // 5: Level 1 Root - Can set property DApps level [1-4]
75     uint8 constant LEVEL_2_ROOT = 6;         // 6: Level 2 Root - Can set pixelPropertyContract level [1-5]
76     uint8 constant LEVEL_3_ROOT = 7;         // 7: Level 3 Root - Can demote/remove root, transfer root, [1-6]
77     uint8 constant LEVEL_PROPERTY_DAPPS = 8; // 8: Property DApps - Power over manipulating Property data
78     uint8 constant LEVEL_PIXEL_PROPERTY = 9; // 9: PixelProperty - Power over PXL generation & Property ownership
79     /* Flags Constants */
80     uint8 constant FLAG_NSFW = 1;
81     uint8 constant FLAG_BAN = 2;
82     
83     /* Accesser Addresses & Levels */
84     address pixelPropertyContract; // Only contract that has control over PXL creation and Property ownership
85     mapping (address => uint8) public regulators; // Mapping of users/contracts to their control levels
86     
87     // Mapping of PropertyID to Property
88     mapping (uint16 => Property) public properties;
89     // Property Owner's website
90     mapping (address => uint256[2]) public ownerWebsite;
91     // Property Owner's hover text
92     mapping (address => uint256[2]) public ownerHoverText;
93     
94     /* ### Ownable Property Structure ### */
95     struct Property {
96         uint8 flag;
97         bool isInPrivateMode; //Whether in private mode for owner-only use or free-use mode to be shared
98         address owner; //Who owns the Property. If its zero (0), then no owner and known as a "system-Property"
99         address lastUpdater; //Who last changed the color of the Property
100         uint256[5] colors; //10x10 rgb pixel colors per property. colors[0] is the top row, colors[9] is the bottom row
101         uint256 salePrice; //PXL price the owner has the Property on sale for. If zero, then its not for sale.
102         uint256 lastUpdate; //Timestamp of when it had its color last updated
103         uint256 becomePublic; //Timestamp on when to become public
104         uint256 earnUntil; //Timestamp on when Property token generation will stop
105     }
106     
107     /* ### Regulation Access Modifiers ### */
108     modifier regulatorAccess(uint8 accessLevel) {
109         require(accessLevel <= LEVEL_3_ROOT); // Only request moderator, admin or root levels forr regulatorAccess
110         require(regulators[msg.sender] >= accessLevel); // Users must meet requirement
111         if (accessLevel >= LEVEL_1_ADMIN) { //
112             require(regulators[msg.sender] <= LEVEL_3_ROOT); //DApps can't do Admin/Root stuff, but can set nsfw/ban flags
113         }
114         _;
115     }
116     
117     modifier propertyDAppAccess() {
118         require(regulators[msg.sender] == LEVEL_PROPERTY_DAPPS || regulators[msg.sender] == LEVEL_PIXEL_PROPERTY );
119         _;
120     }
121     
122     modifier pixelPropertyAccess() {
123         require(regulators[msg.sender] == LEVEL_PIXEL_PROPERTY);
124         _;
125     }
126     
127     /* ### Constructor ### */
128     function PXLProperty() public {
129         regulators[msg.sender] = LEVEL_3_ROOT; // Creator set to Level 3 Root
130     }
131     
132     /* ### Moderator, Admin & Root Functions ### */
133     // Moderator Flags
134     function setPropertyFlag(uint16 propertyID, uint8 flag) public regulatorAccess(flag == FLAG_NSFW ? LEVEL_1_MODERATOR : LEVEL_2_MODERATOR) {
135         properties[propertyID].flag = flag;
136         if (flag == FLAG_BAN) {
137             require(properties[propertyID].isInPrivateMode); //Can't ban an owner's property if a public user caused the NSFW content
138             properties[propertyID].colors = [0, 0, 0, 0, 0];
139         }
140     }
141     
142     // Setting moderator/admin/root access
143     function setRegulatorAccessLevel(address user, uint8 accessLevel) public regulatorAccess(LEVEL_1_ADMIN) {
144         if (msg.sender != user) {
145             require(regulators[msg.sender] > regulators[user]); // You have to be a higher rank than the user you are changing
146         }
147         require(regulators[msg.sender] > accessLevel); // You have to be a higher rank than the role you are setting
148         regulators[user] = accessLevel;
149     }
150     
151     function setPixelPropertyContract(address newPixelPropertyContract) public regulatorAccess(LEVEL_2_ROOT) {
152         require(newPixelPropertyContract != 0);
153         if (pixelPropertyContract != 0) {
154             regulators[pixelPropertyContract] = 0; //If we already have a pixelPropertyContract, revoke its ownership
155         }
156         
157         pixelPropertyContract = newPixelPropertyContract;
158         regulators[newPixelPropertyContract] = LEVEL_PIXEL_PROPERTY;
159     }
160     
161     function setPropertyDAppContract(address propertyDAppContract, bool giveAccess) public regulatorAccess(LEVEL_1_ROOT) {
162         require(propertyDAppContract != 0);
163         regulators[propertyDAppContract] = giveAccess ? LEVEL_PROPERTY_DAPPS : 0;
164     }
165     
166     /* ### PropertyDapp Functions ### */
167     function setPropertyColors(uint16 propertyID, uint256[5] colors) public propertyDAppAccess() {
168         for(uint256 i = 0; i < 5; i++) {
169             if (properties[propertyID].colors[i] != colors[i]) {
170                 properties[propertyID].colors[i] = colors[i];
171             }
172         }
173     }
174     
175     function setPropertyRowColor(uint16 propertyID, uint8 row, uint256 rowColor) public propertyDAppAccess() {
176         if (properties[propertyID].colors[row] != rowColor) {
177             properties[propertyID].colors[row] = rowColor;
178         }
179     }
180     
181     function setOwnerHoverText(address textOwner, uint256[2] hoverText) public propertyDAppAccess() {
182         require (textOwner != 0);
183         ownerHoverText[textOwner] = hoverText;
184     }
185     
186     function setOwnerLink(address websiteOwner, uint256[2] website) public propertyDAppAccess() {
187         require (websiteOwner != 0);
188         ownerWebsite[websiteOwner] = website;
189     }
190     
191     /* ### PixelProperty Property Functions ### */
192     function setPropertyPrivateMode(uint16 propertyID, bool isInPrivateMode) public pixelPropertyAccess() {
193         if (properties[propertyID].isInPrivateMode != isInPrivateMode) {
194             properties[propertyID].isInPrivateMode = isInPrivateMode;
195         }
196     }
197     
198     function setPropertyOwner(uint16 propertyID, address propertyOwner) public pixelPropertyAccess() {
199         if (properties[propertyID].owner != propertyOwner) {
200             properties[propertyID].owner = propertyOwner;
201         }
202     }
203     
204     function setPropertyLastUpdater(uint16 propertyID, address lastUpdater) public pixelPropertyAccess() {
205         if (properties[propertyID].lastUpdater != lastUpdater) {
206             properties[propertyID].lastUpdater = lastUpdater;
207         }
208     }
209     
210     function setPropertySalePrice(uint16 propertyID, uint256 salePrice) public pixelPropertyAccess() {
211         if (properties[propertyID].salePrice != salePrice) {
212             properties[propertyID].salePrice = salePrice;
213         }
214     }
215     
216     function setPropertyLastUpdate(uint16 propertyID, uint256 lastUpdate) public pixelPropertyAccess() {
217         properties[propertyID].lastUpdate = lastUpdate;
218     }
219     
220     function setPropertyBecomePublic(uint16 propertyID, uint256 becomePublic) public pixelPropertyAccess() {
221         properties[propertyID].becomePublic = becomePublic;
222     }
223     
224     function setPropertyEarnUntil(uint16 propertyID, uint256 earnUntil) public pixelPropertyAccess() {
225         properties[propertyID].earnUntil = earnUntil;
226     }
227     
228     function setPropertyPrivateModeEarnUntilLastUpdateBecomePublic(uint16 propertyID, bool privateMode, uint256 earnUntil, uint256 lastUpdate, uint256 becomePublic) public pixelPropertyAccess() {
229         if (properties[propertyID].isInPrivateMode != privateMode) {
230             properties[propertyID].isInPrivateMode = privateMode;
231         }
232         properties[propertyID].earnUntil = earnUntil;
233         properties[propertyID].lastUpdate = lastUpdate;
234         properties[propertyID].becomePublic = becomePublic;
235     }
236     
237     function setPropertyLastUpdaterLastUpdate(uint16 propertyID, address lastUpdater, uint256 lastUpdate) public pixelPropertyAccess() {
238         if (properties[propertyID].lastUpdater != lastUpdater) {
239             properties[propertyID].lastUpdater = lastUpdater;
240         }
241         properties[propertyID].lastUpdate = lastUpdate;
242     }
243     
244     function setPropertyBecomePublicEarnUntil(uint16 propertyID, uint256 becomePublic, uint256 earnUntil) public pixelPropertyAccess() {
245         properties[propertyID].becomePublic = becomePublic;
246         properties[propertyID].earnUntil = earnUntil;
247     }
248     
249     function setPropertyOwnerSalePricePrivateModeFlag(uint16 propertyID, address owner, uint256 salePrice, bool privateMode, uint8 flag) public pixelPropertyAccess() {
250         if (properties[propertyID].owner != owner) {
251             properties[propertyID].owner = owner;
252         }
253         if (properties[propertyID].salePrice != salePrice) {
254             properties[propertyID].salePrice = salePrice;
255         }
256         if (properties[propertyID].isInPrivateMode != privateMode) {
257             properties[propertyID].isInPrivateMode = privateMode;
258         }
259         if (properties[propertyID].flag != flag) {
260             properties[propertyID].flag = flag;
261         }
262     }
263     
264     function setPropertyOwnerSalePrice(uint16 propertyID, address owner, uint256 salePrice) public pixelPropertyAccess() {
265         if (properties[propertyID].owner != owner) {
266             properties[propertyID].owner = owner;
267         }
268         if (properties[propertyID].salePrice != salePrice) {
269             properties[propertyID].salePrice = salePrice;
270         }
271     }
272     
273     /* ### PixelProperty PXL Functions ### */
274     function rewardPXL(address rewardedUser, uint256 amount) public pixelPropertyAccess() {
275         require(rewardedUser != 0);
276         balances[rewardedUser] += amount;
277         totalSupply += amount;
278     }
279     
280     function burnPXL(address burningUser, uint256 amount) public pixelPropertyAccess() {
281         require(burningUser != 0);
282         require(balances[burningUser] >= amount);
283         balances[burningUser] -= amount;
284         totalSupply -= amount;
285     }
286     
287     function burnPXLRewardPXL(address burner, uint256 toBurn, address rewarder, uint256 toReward) public pixelPropertyAccess() {
288         require(balances[burner] >= toBurn);
289         if (toBurn > 0) {
290             balances[burner] -= toBurn;
291             totalSupply -= toBurn;
292         }
293         if (rewarder != 0) {
294             balances[rewarder] += toReward;
295             totalSupply += toReward;
296         }
297     } 
298     
299     function burnPXLRewardPXLx2(address burner, uint256 toBurn, address rewarder1, uint256 toReward1, address rewarder2, uint256 toReward2) public pixelPropertyAccess() {
300         require(balances[burner] >= toBurn);
301         if (toBurn > 0) {
302             balances[burner] -= toBurn;
303             totalSupply -= toBurn;
304         }
305         if (rewarder1 != 0) {
306             balances[rewarder1] += toReward1;
307             totalSupply += toReward1;
308         }
309         if (rewarder2 != 0) {
310             balances[rewarder2] += toReward2;
311             totalSupply += toReward2;
312         }
313     } 
314     
315     /* ### All Getters/Views ### */
316     function getOwnerHoverText(address user) public view returns(uint256[2]) {
317         return ownerHoverText[user];
318     }
319     
320     function getOwnerLink(address user) public view returns(uint256[2]) {
321         return ownerWebsite[user];
322     }
323     
324     function getPropertyFlag(uint16 propertyID) public view returns(uint8) {
325         return properties[propertyID].flag;
326     }
327     
328     function getPropertyPrivateMode(uint16 propertyID) public view returns(bool) {
329         return properties[propertyID].isInPrivateMode;
330     }
331     
332     function getPropertyOwner(uint16 propertyID) public view returns(address) {
333         return properties[propertyID].owner;
334     }
335     
336     function getPropertyLastUpdater(uint16 propertyID) public view returns(address) {
337         return properties[propertyID].lastUpdater;
338     }
339     
340     function getPropertyColors(uint16 propertyID) public view returns(uint256[5]) {
341         return properties[propertyID].colors;
342     }
343 
344     function getPropertyColorsOfRow(uint16 propertyID, uint8 rowIndex) public view returns(uint256) {
345         require(rowIndex <= 9);
346         return properties[propertyID].colors[rowIndex];
347     }
348     
349     function getPropertySalePrice(uint16 propertyID) public view returns(uint256) {
350         return properties[propertyID].salePrice;
351     }
352     
353     function getPropertyLastUpdate(uint16 propertyID) public view returns(uint256) {
354         return properties[propertyID].lastUpdate;
355     }
356     
357     function getPropertyBecomePublic(uint16 propertyID) public view returns(uint256) {
358         return properties[propertyID].becomePublic;
359     }
360     
361     function getPropertyEarnUntil(uint16 propertyID) public view returns(uint256) {
362         return properties[propertyID].earnUntil;
363     }
364     
365     function getRegulatorLevel(address user) public view returns(uint8) {
366         return regulators[user];
367     }
368     
369     // Gets the (owners address, Ethereum sale price, PXL sale price, last update timestamp, whether its in private mode or not, when it becomes public timestamp, flag) for a Property
370     function getPropertyData(uint16 propertyID, uint256 systemSalePriceETH, uint256 systemSalePricePXL) public view returns(address, uint256, uint256, uint256, bool, uint256, uint8) {
371         Property memory property = properties[propertyID];
372         bool isInPrivateMode = property.isInPrivateMode;
373         //If it's in private, but it has expired and should be public, set our bool to be public
374         if (isInPrivateMode && property.becomePublic <= now) { 
375             isInPrivateMode = false;
376         }
377         if (properties[propertyID].owner == 0) {
378             return (0, systemSalePriceETH, systemSalePricePXL, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
379         } else {
380             return (property.owner, 0, property.salePrice, property.lastUpdate, isInPrivateMode, property.becomePublic, property.flag);
381         }
382     }
383     
384     function getPropertyPrivateModeBecomePublic(uint16 propertyID) public view returns (bool, uint256) {
385         return (properties[propertyID].isInPrivateMode, properties[propertyID].becomePublic);
386     }
387     
388     function getPropertyLastUpdaterBecomePublic(uint16 propertyID) public view returns (address, uint256) {
389         return (properties[propertyID].lastUpdater, properties[propertyID].becomePublic);
390     }
391     
392     function getPropertyOwnerSalePrice(uint16 propertyID) public view returns (address, uint256) {
393         return (properties[propertyID].owner, properties[propertyID].salePrice);
394     }
395     
396     function getPropertyPrivateModeLastUpdateEarnUntil(uint16 propertyID) public view returns (bool, uint256, uint256) {
397         return (properties[propertyID].isInPrivateMode, properties[propertyID].lastUpdate, properties[propertyID].earnUntil);
398     }
399 }