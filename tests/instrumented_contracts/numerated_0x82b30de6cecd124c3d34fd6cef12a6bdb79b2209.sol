1 pragma solidity 0.4.24;
2 
3 // File: contracts/FreeDnaCardRepositoryInterface.sol
4 
5 interface FreeDnaCardRepositoryInterface {
6     function airdrop(address to, uint256 animalId) external;
7 
8     function giveaway(
9         address to,
10         uint256 animalId,
11         uint8 effectiveness
12     )
13     external;
14 }
15 
16 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 // File: contracts/Restricted.sol
81 
82 contract Restricted is Ownable {
83     mapping(address => bool) private addressIsAdmin;
84     bool private isActive = true;
85 
86     modifier onlyAdmin() {
87         require(addressIsAdmin[msg.sender] || msg.sender == owner);
88         _;
89     }
90 
91     modifier contractIsActive() {
92         require(isActive);
93         _;
94     }
95 
96     function addAdmin(address adminAddress) public onlyOwner {
97         addressIsAdmin[adminAddress] = true;
98     }
99 
100     function removeAdmin(address adminAddress) public onlyOwner {
101         addressIsAdmin[adminAddress] = false;
102     }
103 
104     function pauseContract() public onlyOwner {
105         isActive = false;
106     }
107 
108     function activateContract() public onlyOwner {
109         isActive = true;
110     }
111 }
112 
113 // File: contracts/GameData.sol
114 
115 contract GameData {
116     struct Country {       
117         bytes2 isoCode;
118         uint8 animalsCount;
119         uint256[3] animalIds;
120     }
121 
122     struct Animal {
123         bool isSold;
124         uint256 currentValue;
125         uint8 rarity; // 0-4, rarity = stat range, higher rarity = better stats
126 
127         bytes32 name;         
128         uint256 countryId; // country of origin
129 
130     }
131 
132     struct Dna {
133         uint256 animalId; 
134         uint8 effectiveness; //  1 - 100, 100 = same stats as a wild card
135     }    
136 }
137 
138 // File: contracts/FreeDnaCardRepository.sol
139 
140 contract FreeDnaCardRepository is FreeDnaCardRepositoryInterface, GameData, Restricted {
141     event NewAirdrop(
142         address to,
143         uint256 animalId
144     );
145 
146     event NewGiveway(
147         address to,
148         uint256 animalId,
149         uint8 effectiveness
150     );
151 
152     uint8 private constant AIRDROP_EFFECTIVENESS = 10;
153 
154     uint256 private pendingGivewayCardCount;
155     uint256 private airdropEndTimestamp;
156 
157     bool private migrated = false;
158 
159     mapping (address => uint256[]) private addressDnaIds;
160     mapping (address => bool) public addressIsDonator;
161     mapping (uint => address) private dnaIdToOwnerAddress;
162 
163     Dna[] private dnas;
164 
165     constructor(
166         uint256 _pendingGivewayCardCount,
167         uint256 _airdropEndTimestamp
168     ) public {
169         pendingGivewayCardCount = _pendingGivewayCardCount;
170         airdropEndTimestamp = _airdropEndTimestamp;
171     }
172 
173     function getDna(uint dnaId) external view returns (
174        uint256 animalId,
175        address ownerAddress,
176        uint8 effectiveness,
177        uint256 id
178     ) {
179         Dna storage dna = dnas[dnaId];
180 
181         return (
182             dna.animalId,
183             dnaIdToOwnerAddress[dnaId],
184             dna.effectiveness,
185             dnaId
186         );
187     }
188 
189     function migrateData(
190         address to,
191         uint256 animalId,
192         uint8 effectiveness
193     )
194     external
195     onlyOwner
196     {
197         require(migrated == false);
198         donateDna(to, animalId, effectiveness);
199     }
200 
201     function setMigrated() external onlyOwner {
202         migrated = true;
203     }
204 
205     function addDonator(address donatorAddress) external onlyAdmin {
206         addressIsDonator[donatorAddress] = true;
207     }
208 
209     function deleteDonator(address donatorAddress) external onlyAdmin {
210         delete addressIsDonator[donatorAddress];
211     }
212 
213     function airdrop(address to, uint256 animalId) external contractIsActive {
214         require(now <= airdropEndTimestamp, "airdrop ended");
215         donateDnaFromContract(to, animalId, AIRDROP_EFFECTIVENESS);
216         emit NewAirdrop(to, animalId);
217     }
218 
219     function giveaway(
220         address to,
221         uint256 animalId,
222         uint8 effectiveness
223     )
224     external
225     contractIsActive
226     {
227         require(pendingGivewayCardCount > 0);
228 
229         donateDnaFromContract(to, animalId, effectiveness);
230         pendingGivewayCardCount--;
231         emit NewGiveway(to, animalId, effectiveness);
232     }
233 
234     function getAddressDnaIds(address owner) external view returns(uint256[])
235     {
236         return addressDnaIds[owner];
237     }
238 
239     function donateDnaFromContract(
240         address to,
241         uint256 animalId,
242         uint8 effectiveness
243     )
244     private
245     contractIsActive
246     {
247         require(migrated);
248         require(addressIsDonator[msg.sender], "donator not registered");
249         donateDna(to, animalId, effectiveness);
250     }
251 
252     function donateDna(
253         address to,
254         uint256 animalId,
255         uint8 effectiveness
256     )
257     private
258     {
259         uint256 id = dnas.length; // id is assigned before push
260         Dna memory dna = Dna(animalId, effectiveness);
261 
262         // Donate the card
263         dnas.push(dna);
264         dnaIdToOwnerAddress[id] = to;
265         addressDnaIds[to].push(id);
266     }
267 }