1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 interface ERC721 {
12     function totalSupply() external view returns (uint256 tokens);
13     function balanceOf(address owner) external view returns (uint256 balance);
14     function ownerOf(uint256 tokenId) external view returns (address owner);
15     function exists(uint256 tokenId) external view returns (bool tokenExists);
16     function approve(address to, uint256 tokenId) external;
17     function getApproved(uint256 tokenId) external view returns (address approvee);
18 
19     function transferFrom(address from, address to, uint256 tokenId) external;
20     function tokensOf(address owner) external view returns (uint256[] tokens);
21     //function tokenByIndex(uint256 index) external view returns (uint256 token);
22 
23     // Events
24     event Transfer(address from, address to, uint256 tokenId);
25     event Approval(address owner, address approved, uint256 tokenId);
26 }
27 
28 
29 interface ERC721Receiver {
30     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external returns(bytes4);
31 }
32 
33 contract Inventory is ERC721 {
34 
35     Units constant units = Units(0xf936aa9e1f22c915abf4a66a5a6e94eb8716ba5e);
36 
37     string public constant name = "Goo Item";
38     string public constant symbol = "GOOITEM";
39 
40     mapping(address => mapping(uint256 => uint256)) public unitEquippedItems; // address -> unitId -> tokenId
41     mapping(uint256 => Item) public itemList;
42 
43     // ERC721 stuff
44     mapping(uint256 => address) public tokenOwner;
45     mapping(uint256 => address) public tokenApprovals;
46     mapping(address => uint256[]) public ownedTokens;
47     mapping(uint256 => uint256) public ownedTokensIndex;
48     mapping(uint256 => uint256) public tokenItems; // tokenId -> ItemId
49     mapping(address => bool) operator;
50 
51     // Offset by one (so token id starts from 1)
52     uint256 nextTokenId = 1;
53     uint256 tokensBurnt = 1;
54 
55     struct Item {
56         uint256 itemId;
57         uint256 unitId;
58         uint256 rarity;
59         uint32[8] upgradeGains;
60     }
61 
62     address owner; // Minor management
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     function setOperator(address gameContract, bool isOperator) external {
69         require(msg.sender == owner);
70         operator[gameContract] = isOperator;
71     }
72 
73     function totalSupply() external view returns (uint256) {
74         return nextTokenId - tokensBurnt;
75     }
76 
77     function balanceOf(address player) public view returns (uint256) {
78         return ownedTokens[player].length;
79     }
80 
81     function ownerOf(uint256 tokenId) external view returns (address) {
82         return tokenOwner[tokenId];
83     }
84 
85     function exists(uint256 tokenId) external view returns (bool) {
86         return tokenOwner[tokenId] != address(0);
87     }
88 
89     function approve(address to, uint256 tokenId) external {
90         require(msg.sender == tokenOwner[tokenId]);
91         tokenApprovals[tokenId] = to;
92         emit Approval(msg.sender, to, tokenId);
93     }
94 
95     function getApproved(uint256 tokenId) external view returns (address) {
96         return tokenApprovals[tokenId];
97     }
98 
99     function tokensOf(address player) external view returns (uint256[] tokens) {
100          return ownedTokens[player];
101     }
102 
103     function itemsOf(address player) external view returns (uint256[], uint256[]) {
104         uint256 unequippedItemsCount = 0; // TODO better way?
105         uint256 tokensLength = ownedTokens[player].length;
106         for (uint256 i = 0; i < tokensLength; i++) {
107             if (tokenOwner[ownedTokens[player][i]] == player) {
108                 unequippedItemsCount++;
109             }
110         }
111 
112         uint256[] memory tokensOwned = new uint256[](unequippedItemsCount);
113         uint256 j = 0;
114         for (i = 0; i < tokensLength; i++) {
115             uint256 tokenId = ownedTokens[player][i];
116             if (tokenOwner[tokenId] == player) { // Unequipped items only
117                 tokensOwned[j] = tokenId;
118                 j++;
119             }
120         }
121 
122         uint256[] memory itemIdsOwned = new uint256[](unequippedItemsCount);
123         for (i = 0; i < unequippedItemsCount; i++) {
124             itemIdsOwned[i] = tokenItems[tokensOwned[i]];
125         }
126 
127         return (tokensOwned, itemIdsOwned);
128     }
129 
130     function transferFrom(address from, address to, uint256 tokenId) public {
131         require(tokenApprovals[tokenId] == msg.sender || tokenOwner[tokenId] == msg.sender || operator[msg.sender]);
132         require(tokenOwner[tokenId] == from);
133 
134         removeTokenFrom(from, tokenId);
135         addTokenTo(to, tokenId);
136 
137         delete tokenApprovals[tokenId]; // Clear approval
138         emit Transfer(from, to, tokenId);
139     }
140     
141     function safeTransferFrom(address from, address to, uint256 tokenId) public {
142         safeTransferFrom(from, to, tokenId, "");
143     }
144     
145     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
146         transferFrom(from, to, tokenId);
147         checkERC721Recieved(from, to, tokenId, data);
148     }
149     
150     function checkERC721Recieved(address from, address to, uint256 tokenId, bytes memory data) internal {
151         uint256 size;
152         assembly { size := extcodesize(to) }
153         if (size > 0) { // Recipient is contract so must confirm recipt
154             bytes4 successfullyRecieved = ERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data);
155             require(successfullyRecieved == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")));
156         }
157     }
158 
159     function removeTokenFrom(address from, uint256 tokenId) internal {
160         require(tokenOwner[tokenId] == from);
161         tokenOwner[tokenId] = address(0);
162 
163         uint256 tokenIndex = ownedTokensIndex[tokenId];
164         uint256 lastTokenIndex = SafeMath.sub(ownedTokens[from].length, 1);
165         uint256 lastToken = ownedTokens[from][lastTokenIndex];
166 
167         ownedTokens[from][tokenIndex] = lastToken;
168         ownedTokens[from][lastTokenIndex] = 0;
169 
170         ownedTokens[from].length--;
171         ownedTokensIndex[tokenId] = 0;
172         ownedTokensIndex[lastToken] = tokenIndex;
173     }
174 
175     function addTokenTo(address to, uint256 tokenId) internal {
176         require(tokenOwner[tokenId] == address(0));
177         tokenOwner[tokenId] = to;
178 
179         ownedTokensIndex[tokenId] = ownedTokens[to].length;
180         ownedTokens[to].push(tokenId);
181     }
182     
183     function burn(uint256 tokenId) external {
184         address itemOwner = tokenOwner[tokenId];
185         require(itemOwner == msg.sender || operator[msg.sender]);
186         
187         removeTokenFrom(itemOwner, tokenId);
188         delete tokenApprovals[tokenId]; // Clear approval
189         delete tokenItems[tokenId]; // Delete token-item
190         emit Transfer(itemOwner, address(0), tokenId);
191         tokensBurnt++;
192     }
193 
194     function mintItem(uint256 itemId, address player) external {
195         require(operator[msg.sender]);
196         require(validItem(itemId));
197 
198         uint256 tokenId = nextTokenId; // Start from id 1
199         tokenItems[tokenId] = itemId;
200         addTokenTo(player, tokenId);
201         emit Transfer(address(0), player, tokenId);
202         nextTokenId++;
203     }
204 
205     function getEquippedItemId(address player, uint256 unitId) external view returns (uint256) {
206         return tokenItems[unitEquippedItems[player][unitId]];
207     }
208 
209     function equipSingle(uint256 tokenId) public {
210         require(tokenOwner[tokenId] == msg.sender);
211         uint256 itemId = tokenItems[tokenId];
212         uint256 unitId = itemList[itemId].unitId;
213 
214         // Remove item from user
215         tokenOwner[tokenId] = 0;
216         delete tokenApprovals[tokenId]; // Clear approval
217 
218         uint256 existingEquipment = unitEquippedItems[msg.sender][unitId];
219         uint32[8] memory newItemGains = itemList[itemId].upgradeGains;
220         
221         if (existingEquipment == 0) {
222             // Grant buff to unit
223             units.increaseUpgradesExternal(msg.sender, unitId, newItemGains[0], newItemGains[1], newItemGains[2], newItemGains[3], newItemGains[4], newItemGains[5], newItemGains[6], newItemGains[7]);
224         } else if (existingEquipment != tokenId) {
225             uint256 existingItemId = tokenItems[existingEquipment];
226 
227             // Grant buff to unit
228             units.swapUpgradesExternal(msg.sender, unitId, newItemGains, itemList[existingItemId].upgradeGains);
229 
230             // Return old item to user
231             tokenOwner[existingEquipment] = msg.sender;
232         }
233 
234         // Finally equip token (item)
235         unitEquippedItems[msg.sender][unitId] = tokenId;
236     }
237 
238     function unequipSingle(uint256 unitId) public {
239         require(unitEquippedItems[msg.sender][unitId] > 0);
240 
241         uint256 tokenId = unitEquippedItems[msg.sender][unitId];
242         require(tokenOwner[tokenId] == 0);
243 
244         uint256 itemId = tokenItems[tokenId];
245         uint32[8] memory existingItemGains = itemList[itemId].upgradeGains;
246         units.decreaseUpgradesExternal(msg.sender, unitId, existingItemGains[0], existingItemGains[1], existingItemGains[2], existingItemGains[3], existingItemGains[4], existingItemGains[5], existingItemGains[6], existingItemGains[7]);
247 
248         // Finally return item
249         tokenOwner[tokenId] = msg.sender;
250         unitEquippedItems[msg.sender][unitId] = 0;
251     }
252 
253     function equipMultipleTokens(uint256[] tokens) external {
254         for (uint256 i = 0; i < tokens.length; ++i) {
255             equipSingle(tokens[i]);
256         }
257     }
258 
259     function unequipMultipleUnits(uint256[] unitIds) external {
260         for (uint256 i = 0; i < unitIds.length; ++i) {
261             unequipSingle(unitIds[i]);
262         }
263     }
264 
265     function addItem(uint256 itemId, uint256 unitId, uint256 rarity, uint32[8] upgradeGains) external {
266         require(operator[msg.sender]);
267         itemList[itemId] = Item(itemId, unitId, rarity, upgradeGains);
268     }
269 
270     function validItem(uint256 itemId) internal constant returns (bool) {
271         return itemList[itemId].itemId == itemId;
272     }
273     
274     function getItemRarity(uint256 itemId) external view returns (uint256) {
275         return itemList[itemId].rarity;
276     }
277 }
278 
279 
280 contract Units {
281     function increaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external;
282     function decreaseUpgradesExternal(address player, uint256 unitId, uint32 prodIncrease, uint32 prodMultiplier, uint32 attackIncrease, uint32 attackMultiplier, uint32 defenseIncrease, uint32 defenseMultiplier, uint32 lootingIncrease, uint32 lootingMultiplier) external;
283     function swapUpgradesExternal(address player, uint256 unitId, uint32[8] upgradeGains, uint32[8] upgradeLosses) external;
284 }
285 
286 
287 
288 library SafeMath {
289 
290   /**
291   * @dev Multiplies two numbers, throws on overflow.
292   */
293   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294     if (a == 0) {
295       return 0;
296     }
297     uint256 c = a * b;
298     assert(c / a == b);
299     return c;
300   }
301 
302   /**
303   * @dev Integer division of two numbers, truncating the quotient.
304   */
305   function div(uint256 a, uint256 b) internal pure returns (uint256) {
306     // assert(b > 0); // Solidity automatically throws when dividing by 0
307     uint256 c = a / b;
308     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309     return c;
310   }
311 
312   /**
313   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
314   */
315   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
316     assert(b <= a);
317     return a - b;
318   }
319 
320   /**
321   * @dev Adds two numbers, throws on overflow.
322   */
323   function add(uint256 a, uint256 b) internal pure returns (uint256) {
324     uint256 c = a + b;
325     assert(c >= a);
326     return c;
327   }
328 }