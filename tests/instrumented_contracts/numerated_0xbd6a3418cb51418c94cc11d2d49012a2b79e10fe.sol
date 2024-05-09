1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner = msg.sender;
5     address public manager = 0xcEd259dB3435BcbC63eC80A2440F94a1c95C69Bb;
6 
7     function getOwner() view external returns (address) {
8         return owner;
9     }
10 
11     /// @notice check if the caller is the owner of the contract
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     modifier onlyManager {
18         require(msg.sender == manager);
19         _;
20     }
21 
22     bool locked;
23     modifier noReentrancy() {
24         require(!locked);
25         locked = true;
26         _;
27         locked = false;
28     }
29 
30     /// @notice change the owner of the contract
31     /// @param _newOwner the address of the new owner of the contract.
32     function changeOwner(address _newOwner) public
33     onlyOwner
34     {
35         require(_newOwner != 0x0);
36         owner = _newOwner;
37     }
38 }
39 
40 contract WeaponsCore is Ownable
41 {
42     struct WeaponModel {
43         uint id;
44         uint weaponType;
45         uint generation;
46         uint price;
47     }
48 
49     struct WeaponEntity {
50         uint modelId;
51         uint weaponType;
52         uint generation;
53         uint dna;
54     }
55 
56     uint8 public nextWeaponID = 1; // ID for the next weapon
57 
58     WeaponModel[] public weaponModels;
59     WeaponEntity[] public weaponEntities;
60     mapping(uint256 => address) public weaponToOwner;
61     mapping(address => uint256[]) internal ownerToWeapons;
62     mapping(uint256 => address) public weaponToApproved;
63 
64     function WeaponsCore() public payable {
65         //registering swords (type 0)
66         _registerWeapon(0, 0, 0, 0.01 ether);
67         _registerWeapon(1, 0, 1, 0.05 ether);
68         _registerWeapon(2, 0, 2, 0.1 ether);
69         _registerWeapon(3, 0, 3, 0.25 ether);
70         _registerWeapon(4, 0, 4, 0.5 ether);
71 
72         //registering axes (type 1)
73         _registerWeapon(5, 1, 0, 0.01 ether);
74         _registerWeapon(6, 1, 1, 0.05 ether);
75         _registerWeapon(7, 1, 2, 0.1 ether);
76         _registerWeapon(8, 1, 3, 0.25 ether);
77         _registerWeapon(9, 1, 4, 0.5 ether);
78 
79         //registering hammers (type 2)
80         _registerWeapon(10, 2, 0, 0.01 ether);
81         _registerWeapon(11, 2, 1, 0.05 ether);
82         _registerWeapon(12, 2, 2, 0.1 ether);
83         _registerWeapon(13, 2, 3, 0.25 ether);
84         _registerWeapon(14, 2, 4, 0.5 ether);
85 
86         //registering bows (type 3)
87         _registerWeapon(15, 3, 0, 0.01 ether);
88         _registerWeapon(16, 3, 1, 0.05 ether);
89         _registerWeapon(17, 3, 2, 0.1 ether);
90         _registerWeapon(18, 3, 3, 0.25 ether);
91         _registerWeapon(19, 3, 4, 0.5 ether);
92     }
93 
94     function _registerWeapon(uint _id, uint _type, uint _generation, uint _price) private {
95         WeaponModel memory weaponModel = WeaponModel(_id, _type, _generation, _price);
96         weaponModels.push(weaponModel);
97     }
98 
99     function getWeaponEntity(uint256 id) external view returns (uint, uint, uint, uint) {
100         WeaponEntity memory weapon = weaponEntities[id];
101 
102         return (weapon.modelId, weapon.weaponType, weapon.generation, weapon.dna);
103     }
104 
105     function getWeaponModel(uint256 id) external view returns (uint, uint, uint, uint) {
106         WeaponModel memory weapon = weaponModels[id];
107 
108         return (weapon.id, weapon.weaponType, weapon.generation, weapon.price);
109     }
110 
111     function getWeaponIds() external view returns (uint[]) {
112         uint weaponsCount = nextWeaponID - 1;
113         uint[] memory _weaponsList = new uint[](weaponsCount);
114         for (uint weaponId = 0; weaponId < weaponsCount; weaponId++) {
115             _weaponsList[weaponId] = weaponId;
116         }
117 
118         return _weaponsList;
119     }
120 
121     /*
122     function newWeapon(uint8 _id, uint8 _weaponType, uint8 _attack, uint8 _defense, uint8 _accuracy, uint8 _speed, uint8 _levelRequired, uint8 _criticalHitChance, uint8 _maxDurability, uint8 _durability, uint256 _profit, uint _price) external payable noReentrancy onlyOwner {
123         weaponModels[nextWeaponID++] = WeaponModel(_id, _weaponType, _attack, _defense, _accuracy, _speed, _levelRequired, _criticalHitChance, _maxDurability, _durability, _profit, _price);
124     }
125     */
126 
127     function _generateWeapon(address _owner, uint256 _weaponId) internal returns (uint256 id) {
128         require(weaponModels[_weaponId].price > 0);
129         require(msg.value == weaponModels[_weaponId].price);
130 
131         id = weaponEntities.length;
132         uint256 createTime = block.timestamp;
133 
134         // Insecure RNG, but good enough for our purposes - borrowed from EtherTulips
135         uint256 seed = uint(block.blockhash(block.number - 1)) + uint(block.blockhash(block.number - 100))
136         + uint(block.coinbase) + createTime + id;
137         uint256 dna = uint256(keccak256(seed)) % 1000000000000000;
138 
139         WeaponModel memory weaponModel = weaponModels[_weaponId];
140         WeaponEntity memory newWeapon = WeaponEntity(_weaponId, weaponModel.weaponType, weaponModel.generation, dna);
141         weaponEntities.push(newWeapon);
142         weaponToOwner[id] = _owner;
143         ownerToWeapons[_owner].push(id);
144     }
145 
146     function _transferWeapon(address _from, address _to, uint256 _id) internal {
147         weaponToOwner[_id] = _to;
148         ownerToWeapons[_to].push(_id);
149         weaponToApproved[_id] = address(0);
150 
151         uint256[] storage fromWeapons = ownerToWeapons[_from];
152         for (uint256 i = 0; i < fromWeapons.length; i++) {
153             if (fromWeapons[i] == _id) {
154                 break;
155             }
156         }
157         assert(i < fromWeapons.length);
158 
159         fromWeapons[i] = fromWeapons[fromWeapons.length - 1];
160         delete fromWeapons[fromWeapons.length - 1];
161         fromWeapons.length--;
162     }
163 }
164 
165 contract ERC721 {
166     // Required Functions
167     function implementsERC721() public pure returns (bool);
168     function totalSupply() public view returns (uint256);
169     function balanceOf(address _owner) public view returns (uint256);
170     function ownerOf(uint256 _tokenId) public view returns (address);
171     function transfer(address _to, uint _tokenId) public;
172     function approve(address _to, uint256 _tokenId) public;
173     function transferFrom(address _from, address _to, uint256 _tokenId) public;
174 
175     // Optional Functions
176     function name() public pure returns (string);
177     function symbol() public pure returns (string);
178     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256);
179     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
180 
181     // Required Events
182     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
183     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
184 }
185 
186 
187 contract WeaponToken is WeaponsCore, ERC721 {
188 
189     function implementsERC721() public pure returns (bool) {
190         return true;
191     }
192 
193     function totalSupply() public view returns (uint256) {
194         return weaponEntities.length;
195     }
196 
197     function balanceOf(address _owner) public view returns (uint256 balance) {
198         return ownerToWeapons[_owner].length;
199     }
200 
201     function ownerOf(uint256 _tokenId) public view returns (address owner) {
202         owner = weaponToOwner[_tokenId];
203         require(owner != address(0));
204     }
205 
206     function transfer(address _to, uint256 _tokenId) public {
207         require(_to != address(0));
208         require(weaponToOwner[_tokenId] == msg.sender);
209 
210         _transferWeapon(msg.sender, _to, _tokenId);
211         Transfer(msg.sender, _to, _tokenId);
212     }
213 
214     function approve(address _to, uint256 _tokenId) public {
215         require(weaponToOwner[_tokenId] == msg.sender);
216         weaponToApproved[_tokenId] = _to;
217 
218         Approval(msg.sender, _to, _tokenId);
219     }
220 
221     function transferFrom(address _from, address _to, uint256 _tokenId) public {
222         require(_to != address(0));
223         require(weaponToApproved[_tokenId] == msg.sender);
224         require(weaponToOwner[_tokenId] == _from);
225 
226         _transferWeapon(_from, _to, _tokenId);
227         Transfer(_from, _to, _tokenId);
228     }
229 
230     function name() public pure returns (string) {
231         return "GladiEther Weapon";
232     }
233 
234     function symbol() public pure returns (string) {
235         return "GEW";
236     }
237 
238     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
239         require(_index < ownerToWeapons[_owner].length);
240         return ownerToWeapons[_owner][_index];
241     }
242 
243     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
244 }
245 
246 
247 contract WeaponSales is WeaponToken {
248     event Purchase(address indexed owner, uint256 unitPrice, uint32 amount);
249 
250     function buyWeapon(uint256 _weaponId) public payable returns (uint256 id) {
251         id = _generateWeapon(msg.sender, _weaponId);
252         Transfer(address(0), msg.sender, id);
253         Purchase(msg.sender, weaponModels[_weaponId].price, 1);
254     }
255 
256     function withdrawBalance(uint256 _amount) external onlyOwner {
257         require(_amount <= this.balance);
258 
259         msg.sender.transfer(_amount);
260     }
261 }
262 
263 
264 contract GladiEther is WeaponSales
265 {
266     function GladiEther() public payable {
267         owner = msg.sender;
268     }
269 
270     function getWeapon(uint weaponId) public view returns (uint modelId, uint weaponType, uint generation, uint dna) {
271         WeaponEntity memory weapon = weaponEntities[weaponId];
272 
273         return (weapon.modelId, weapon.weaponType, weapon.generation, weapon.dna);
274     }
275 
276     function myWeapons() public view returns (uint256[]) {
277         uint256[] memory weaponsMemory = ownerToWeapons[msg.sender];
278         return weaponsMemory;
279     }
280 
281     function kill() public {
282         if (msg.sender == owner) selfdestruct(owner);
283     }
284 }