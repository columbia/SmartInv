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
106 // File: Season2.sol
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
121     bool public raidActive = false;
122 
123     mapping(uint256 => uint256) public tokenTiers;
124     mapping(uint256 => bool) public isLocked;
125 
126     uint256 public raidPrice = 0.01 ether;
127 
128     uint256 public constant SEASON = 2;
129     uint256 public constant MAX_TIER = 3;
130 
131     // raid 1: 90% chance of success
132     // raid 2: 50% chance of success
133     // raid 3: 30% chance of success
134     uint256[3] public CUTOFFS = [9, 5, 3];
135 
136     event Locked(uint256 indexed tokenId);
137     event TierUpdated(uint256 indexed tokenId, uint256 tier);
138 
139     constructor(address boneheadz) {
140         Boneheadz = IBoneheadz(boneheadz);
141     }
142 
143     // MODIFIERS
144 
145     modifier onlyTokenOwner(uint256 tokenId) {
146         require(msg.sender == Boneheadz.ownerOf(tokenId), "Caller is not the token owner");
147         _;
148     }
149 
150     // OWNER FUNCTIONS
151 
152     function flipRaidStatus() external onlyOwner {
153         raidActive = !raidActive;
154     }
155 
156     function setRaidPrice(uint256 price) external onlyOwner {
157         raidPrice = price;
158     }
159 
160     function flipLockStatuses(uint256[] calldata tokenIds) public onlyOwner {
161         uint256 numIds = tokenIds.length;
162         for (uint256 i; i < numIds; i++) {
163             isLocked[tokenIds[i]] = !isLocked[tokenIds[i]];
164         }
165     }
166 
167     function withdraw(address recipient) external onlyOwner {
168         (bool success, ) = recipient.call{value: address(this).balance}("");
169         require(success, "Withdraw failed");
170     }
171 
172     // RAID FUNCTIONS
173 
174     function raid(uint256 tokenId) public payable onlyTokenOwner(tokenId) {
175         require(msg.sender == tx.origin, "Caller not allowed");
176         require(raidActive, "Raiding not active");
177         require(!isLocked[tokenId], "Bonehead is locked");
178         require(tokenTiers[tokenId] < MAX_TIER, "Already max tier");
179         require(msg.value == raidPrice, "Not enough ETH sent");
180 
181         uint256 pseudoRandomNumber = _genPseudoRandomNumber(tokenId);
182         uint256 currentTier = tokenTiers[tokenId];
183         if (pseudoRandomNumber < CUTOFFS[currentTier]) {
184             tokenTiers[tokenId]++;
185             emit TierUpdated(tokenId, tokenTiers[tokenId]);
186         } else {
187             isLocked[tokenId] = true;
188             emit Locked(tokenId);
189         }
190     }
191 
192     // VIEW FUNCTIONS
193 
194     function numPerTier() public view returns (uint256[] memory) {
195         uint256[] memory counts = new uint256[](MAX_TIER + 1);
196         for (uint256 tier; tier <= MAX_TIER; tier++) {
197             uint256 numAtTier = 0;
198             uint256 totalSupply = Boneheadz.totalSupply();
199             for (uint256 id; id < totalSupply; id++) {
200                 if (tokenTiers[id] == tier) {
201                     numAtTier++;
202                 }
203             }
204             counts[tier] = numAtTier;
205         }
206         return counts;
207     }
208 
209     function numLockedPerTier() public view returns (uint256[] memory) {
210         uint256[] memory counts = new uint256[](MAX_TIER + 1);
211         for (uint256 tier; tier <= MAX_TIER; tier++) {
212             uint256 numLockedAtTier = 0;
213             uint256 totalSupply = Boneheadz.totalSupply();
214             for (uint256 id; id < totalSupply; id++) {
215                 if (tokenTiers[id] == tier && isLocked[id]) {
216                     numLockedAtTier++;
217                 }
218             }
219             counts[tier] = numLockedAtTier;
220         }
221         return counts;
222     }
223 
224     function _genPseudoRandomNumber(uint256 tokenId) private view returns (uint256) {
225         uint256 pseudoRandomHash = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, tokenId)));
226         return pseudoRandomHash % 10;
227     }
228 }