1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: TombRaid.sol
107 
108 
109 pragma solidity 0.8.13;
110 
111 
112 interface IBoneheadz {
113     function ownerOf(uint256 tokenId) external view returns (address);
114 
115     function totalSupply() external view returns (uint256);
116 }
117 
118 contract TombRaid is Ownable {
119     IBoneheadz public Boneheadz;
120 
121     uint256 internal cutoff;
122 
123     uint256 public immutable SEASON;
124     uint256 public immutable MAX_TIER;
125 
126     uint256 public raidPrice = 0.005 ether;
127 
128     mapping(uint256 => uint256) public tokenTiers;
129     mapping(uint256 => bool) public isLocked;
130 
131     bool public raidActive = false;
132 
133     event Locked(uint256 indexed tokenId);
134     event TierUpdated(uint256 indexed tokenId, uint256 tier);
135 
136     constructor(
137         address boneheadz,
138         uint256 _cutoff,
139         uint256 maxTier,
140         uint256 season
141     ) {
142         Boneheadz = IBoneheadz(boneheadz);
143         cutoff = _cutoff;
144         MAX_TIER = maxTier;
145         SEASON = season;
146     }
147 
148     // MODIFIERS
149 
150     modifier onlyTokenOwner(uint256 tokenId) {
151         require(msg.sender == Boneheadz.ownerOf(tokenId), "Caller is not the token owner");
152         _;
153     }
154 
155     // OWNER FUNCTIONS
156 
157     function flipRaidStatus() external onlyOwner {
158         raidActive = !raidActive;
159     }
160 
161     function setRaidPrice(uint256 price) external onlyOwner {
162         raidPrice = price;
163     }
164 
165     function setCutoff(uint256 _cutoff) external onlyOwner {
166         cutoff = _cutoff;
167     }
168 
169     function flipLockStatuses(uint256[] calldata tokenIds) public onlyOwner {
170         uint256 numIds = tokenIds.length;
171         for (uint256 i; i < numIds; i++) {
172             isLocked[tokenIds[i]] = !isLocked[tokenIds[i]];
173         }
174     }
175 
176     function withdraw(address recipient) external onlyOwner {
177         (bool success, ) = recipient.call{value: address(this).balance}("");
178         require(success, "Withdraw failed");
179     }
180 
181     // RAID FUNCTIONS
182 
183     function raid(uint256 tokenId) public payable onlyTokenOwner(tokenId) {
184         require(msg.sender == tx.origin, "Caller not allowed");
185         require(raidActive, "Raiding not active");
186         require(!isLocked[tokenId], "Bonehead is locked");
187         require(tokenTiers[tokenId] < MAX_TIER, "Already max tier");
188         require(msg.value == raidPrice, "Not enough ETH sent");
189 
190         uint256 pseudoRandomNumber = _genPseudoRandomNumber(tokenId);
191         if (pseudoRandomNumber < cutoff) {
192             tokenTiers[tokenId]++;
193             emit TierUpdated(tokenId, tokenTiers[tokenId]);
194         } else {
195             isLocked[tokenId] = true;
196             emit Locked(tokenId);
197         }
198     }
199 
200     // VIEW FUNCTIONS
201 
202     function numPerTier() public view returns (uint256[] memory) {
203         uint256[] memory counts = new uint256[](MAX_TIER);
204         for (uint256 tier; tier < MAX_TIER; tier++) {
205             uint256 numAtTier = 0;
206             uint256 totalSupply = Boneheadz.totalSupply();
207             for (uint256 id; id < totalSupply; id++) {
208                 if (tokenTiers[id] == tier) {
209                     numAtTier++;
210                 }
211             }
212             counts[tier] = numAtTier;
213         }
214         return counts;
215     }
216 
217     function numLockedPerTier() public view returns (uint256[] memory) {
218         uint256[] memory counts = new uint256[](MAX_TIER);
219         for (uint256 tier; tier < MAX_TIER; tier++) {
220             uint256 numLockedAtTier = 0;
221             uint256 totalSupply = Boneheadz.totalSupply();
222             for (uint256 id; id < totalSupply; id++) {
223                 if (tokenTiers[id] == tier && isLocked[id]) {
224                     numLockedAtTier++;
225                 }
226             }
227             counts[tier] = numLockedAtTier;
228         }
229         return counts;
230     }
231 
232     function _genPseudoRandomNumber(uint256 tokenId) private view returns (uint256) {
233         uint256 pseudoRandomHash = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, tokenId)));
234         return pseudoRandomHash % 10;
235     }
236 }