1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address previousOwner, address newOwner);
7 
8     function Ownable() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract StorageBase is Ownable {
25 
26     function withdrawBalance() external onlyOwner returns (bool) {
27         // The owner has a method to withdraw balance from multiple contracts together,
28         // use send here to make sure even if one withdrawBalance fails the others will still work
29         bool res = msg.sender.send(address(this).balance);
30         return res;
31     }
32 }
33 
34 contract CryptoStorage is StorageBase {
35 
36     struct Monster {
37         uint32 matronId;
38         uint32 sireId;
39         uint32 siringWithId;
40         uint16 cooldownIndex;
41         uint16 generation;
42         uint64 cooldownEndBlock;
43         uint64 birthTime;
44         uint16 monsterId;
45         uint32 monsterNum;
46         bytes properties;
47     }
48 
49     // ERC721 tokens
50     Monster[] internal monsters;
51 
52     // total number of monster created from system instead of breeding
53     uint256 public promoCreatedCount;
54 
55     // total number of monster created by system sale address
56     uint256 public systemCreatedCount;
57 
58     // number of monsters in pregnant
59     uint256 public pregnantMonsters;
60     
61     // monsterId => total number
62     mapping (uint256 => uint32) public monsterCurrentNumber;
63     
64     // tokenId => owner address
65     mapping (uint256 => address) public monsterIndexToOwner;
66 
67     // owner address => balance of tokens
68     mapping (address => uint256) public ownershipTokenCount;
69 
70     // tokenId => approved address
71     mapping (uint256 => address) public monsterIndexToApproved;
72 
73     function CryptoStorage() public {
74         // placeholder to make the first available monster to have a tokenId starts from 1
75         createMonster(0, 0, 0, 0, 0, "");
76     }
77 
78     function createMonster(
79         uint256 _matronId,
80         uint256 _sireId,
81         uint256 _generation,
82         uint256 _birthTime,
83         uint256 _monsterId,
84         bytes _properties
85     ) 
86         public 
87         onlyOwner
88         returns (uint256)
89     {
90         require(_matronId == uint256(uint32(_matronId)));
91         require(_sireId == uint256(uint32(_sireId)));
92         require(_generation == uint256(uint16(_generation)));
93         require(_birthTime == uint256(uint64(_birthTime)));
94         require(_monsterId == uint256(uint16(_monsterId)));
95 
96         monsterCurrentNumber[_monsterId]++;
97 
98         Monster memory monster = Monster({
99             matronId: uint32(_matronId),
100             sireId: uint32(_sireId),
101             siringWithId: 0,
102             cooldownIndex: 0,
103             generation: uint16(_generation),
104             cooldownEndBlock: 0,
105             birthTime: uint64(_birthTime),
106             monsterId: uint16(_monsterId),
107             monsterNum: monsterCurrentNumber[_monsterId],
108             properties: _properties
109         });
110         uint256 tokenId = monsters.push(monster) - 1;
111 
112         // overflow check
113         require(tokenId == uint256(uint32(tokenId)));
114 
115         return tokenId;
116     }
117 
118     function getMonster(uint256 _tokenId)
119         external
120         view
121         returns (
122             bool isGestating,
123             bool isReady,
124             uint16 cooldownIndex,
125             uint64 nextActionAt,
126             uint32 siringWithId,
127             uint32 matronId,
128             uint32 sireId,
129             uint64 cooldownEndBlock,
130             uint16 generation,
131             uint64 birthTime,
132             uint32 monsterNum,
133             uint16 monsterId,
134             bytes properties
135         ) 
136     {
137         Monster storage monster = monsters[_tokenId];
138 
139         isGestating = (monster.siringWithId != 0);
140         isReady = (monster.cooldownEndBlock <= block.number);
141         cooldownIndex = monster.cooldownIndex;
142         nextActionAt = monster.cooldownEndBlock;
143         siringWithId = monster.siringWithId;
144         matronId = monster.matronId;
145         sireId = monster.sireId;
146         cooldownEndBlock = monster.cooldownEndBlock;
147         generation = monster.generation;
148         birthTime = monster.birthTime;
149         monsterNum = monster.monsterNum;
150         monsterId = monster.monsterId;
151         properties = monster.properties;
152     }
153 
154     function getMonsterCount() external view returns (uint256) {
155         return monsters.length - 1;
156     }
157 
158     function getMatronId(uint256 _tokenId) external view returns (uint32) {
159         return monsters[_tokenId].matronId;
160     }
161 
162     function getSireId(uint256 _tokenId) external view returns (uint32) {
163         return monsters[_tokenId].sireId;
164     }
165 
166     function getSiringWithId(uint256 _tokenId) external view returns (uint32) {
167         return monsters[_tokenId].siringWithId;
168     }
169     
170     function setSiringWithId(uint256 _tokenId, uint32 _siringWithId) external onlyOwner {
171         monsters[_tokenId].siringWithId = _siringWithId;
172     }
173 
174     function deleteSiringWithId(uint256 _tokenId) external onlyOwner {
175         delete monsters[_tokenId].siringWithId;
176     }
177 
178     function getCooldownIndex(uint256 _tokenId) external view returns (uint16) {
179         return monsters[_tokenId].cooldownIndex;
180     }
181 
182     function setCooldownIndex(uint256 _tokenId) external onlyOwner {
183         monsters[_tokenId].cooldownIndex += 1;
184     }
185 
186     function getGeneration(uint256 _tokenId) external view returns (uint16) {
187         return monsters[_tokenId].generation;
188     }
189 
190     function getCooldownEndBlock(uint256 _tokenId) external view returns (uint64) {
191         return monsters[_tokenId].cooldownEndBlock;
192     }
193 
194     function setCooldownEndBlock(uint256 _tokenId, uint64 _cooldownEndBlock) external onlyOwner {
195         monsters[_tokenId].cooldownEndBlock = _cooldownEndBlock;
196     }
197 
198     function getBirthTime(uint256 _tokenId) external view returns (uint64) {
199         return monsters[_tokenId].birthTime;
200     }
201 
202     function getMonsterId(uint256 _tokenId) external view returns (uint16) {
203         return monsters[_tokenId].monsterId;
204     }
205 
206     function getMonsterNum(uint256 _tokenId) external view returns (uint32) {
207         return monsters[_tokenId].monsterNum;
208     }
209 
210     function getProperties(uint256 _tokenId) external view returns (bytes) {
211         return monsters[_tokenId].properties;
212     }
213 
214     function updateProperties(uint256 _tokenId, bytes _properties) external onlyOwner {
215         monsters[_tokenId].properties = _properties;
216     }
217     
218     function setMonsterIndexToOwner(uint256 _tokenId, address _owner) external onlyOwner {
219         monsterIndexToOwner[_tokenId] = _owner;
220     }
221 
222     function increaseOwnershipTokenCount(address _owner) external onlyOwner {
223         ownershipTokenCount[_owner]++;
224     }
225 
226     function decreaseOwnershipTokenCount(address _owner) external onlyOwner {
227         ownershipTokenCount[_owner]--;
228     }
229 
230     function setMonsterIndexToApproved(uint256 _tokenId, address _approved) external onlyOwner {
231         monsterIndexToApproved[_tokenId] = _approved;
232     }
233     
234     function deleteMonsterIndexToApproved(uint256 _tokenId) external onlyOwner {
235         delete monsterIndexToApproved[_tokenId];
236     }
237 
238     function increasePromoCreatedCount() external onlyOwner {
239         promoCreatedCount++;
240     }
241 
242     function increaseSystemCreatedCount() external onlyOwner {
243         systemCreatedCount++;
244     }
245 
246     function increasePregnantCounter() external onlyOwner {
247         pregnantMonsters++;
248     }
249 
250     function decreasePregnantCounter() external onlyOwner {
251         pregnantMonsters--;
252     }
253 }