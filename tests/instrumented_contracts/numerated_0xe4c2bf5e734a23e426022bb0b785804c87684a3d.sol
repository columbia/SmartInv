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
106 // File: mirageminter.sol
107 
108 /*
109          M                                                 M
110        M   M                                             M   M
111       M  M  M                                           M  M  M
112      M  M  M  M                                       M  M  M  M
113     M  M  M  M  M                                    M  M  M  M  M
114    M  M M  M  M  M                                 M  M  M  M  M  M
115    M  M   M  M  M  M                              M  M     M  M  M  M
116    M  M     M  M  M  M                           M  M      M  M   M  M
117    M  M       M  M  M  M                        M  M       M  M   M  M       
118    M  M         M  M  M  M                     M  M        M  M   M  M
119    M  M           M  M  M  M                  M  M         M  M   M  M
120    M  M             M  M  M  M               M  M          M  M   M  M   M  M  M  M  M  M  M
121    M  M               M  M  M  M            M  M        M  M  M   M  M   M  M  M  M  M  M  M
122    M  M                 M  M  M  M         M  M      M  M  M  M   M  M                  M  M
123    M  M                   M  M  M  M      M  M    M  M  M  M  M   M  M                     M
124    M  M                     M  M  M  M   M  M  M  M  M  M  M  M   M  M
125    M  M                       M  M  M  M  M   M  M  M  M   M  M   M  M
126    M  M                         M  M  M  M   M  M  M  M    M  M   M  M
127    M  M                           M  M  M   M  M  M  M     M  M   M  M
128    M  M                             M  M   M  M  M  M      M  M   M  M
129 M  M  M  M  M  M                         M   M  M  M  M   M  M  M  M  M  M  M  
130                                           M  M  M  M
131                                           M  M  M  M
132                                           M  M  M  M
133                                            M  M  M  M                        M  M  M  M  M  M
134                                             M  M  M  M                          M  M  M  M
135                                              M  M  M  M                         M  M  M  M
136                                                M  M  M  M                       M  M  M  M
137                                                  M  M  M  M                     M  M  M  M
138                                                    M  M  M  M                   M  M  M  M
139                                                       M  M  M  M                M  M  M  M
140                                                          M  M  M  M             M  M  M  M
141                                                              M  M  M  M   M  M  M  M  M  M
142                                                                  M  M  M  M  M  M  M  M  M
143                                                                                                                                                     
144 */
145 
146 // Contract authored by August Rosedale (@augustfr)
147 // https://miragegallery.ai
148  
149 pragma solidity ^0.8.15;
150 
151 
152 interface curatedContract {
153     function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
154     function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
155     function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
156     function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
157     function mirageAddress() external view returns (address payable);
158     function miragePercentage() external view returns (uint256);
159     function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
160     function earlyMint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId);
161     function balanceOf(address owner) external view returns (uint256);
162 }
163 
164 interface mirageContracts {
165     function balanceOf(address owner, uint256 _id) external view returns (uint256);
166 }
167 
168 contract curatedMinterV2 is Ownable {
169 
170     curatedContract public mirageContract;
171     mirageContracts public membershipContract;
172 
173     uint256 public maxPubMint = 10;
174     uint256 public maxPreMint = 3;
175 
176     mapping(uint256 => bool) public excluded;
177 
178     constructor(address _mirageAddress, address _membershipAddress) {
179         mirageContract = curatedContract(_mirageAddress);
180         membershipContract = mirageContracts(_membershipAddress);
181     }
182     
183     function purchase(uint256 _projectId, uint256 numberOfTokens) public payable {
184         require(!excluded[_projectId], "Project cannot be minted through this contract");
185         require(numberOfTokens <= maxPubMint, "Can only mint 10 per transaction");
186         require(msg.value >= mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
187         _splitFundsETH(_projectId, numberOfTokens);
188         for(uint i = 0; i < numberOfTokens; i++) {
189             mirageContract.mint(msg.sender, _projectId, msg.sender);  
190         }
191     }
192 
193     function earlyPurchase(uint256 _projectId, uint256 _membershipId, uint256 numberOfTokens) public payable {
194         require(!excluded[_projectId], "Project cannot be minted through this contract");
195         require(membershipContract.balanceOf(msg.sender,_membershipId) > 0, "No membership tokens in this wallet");
196         require(numberOfTokens <= maxPreMint, "Can only mint 3 per transaction for presale minting");
197         require(msg.value>=mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens, "Must send minimum value to mint!");
198         _splitFundsETH(_projectId, numberOfTokens);
199         for(uint i = 0; i < numberOfTokens; i++) {
200             mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
201         }
202     }
203 
204     function toggleProject(uint256 _projectId) public onlyOwner {
205         excluded[_projectId] = !excluded[_projectId];
206     }
207 
208     function updateMintLimits(uint256 _preMint, uint256 _pubMint) public onlyOwner { 
209         maxPubMint = _pubMint;
210         maxPreMint = _preMint;
211     }
212 
213     function _splitFundsETH(uint256 _projectId, uint256 numberOfTokens) internal {
214         if (msg.value > 0) {
215             uint256 mintCost = mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens;
216             uint256 refund = msg.value - (mirageContract.projectIdToPricePerTokenInWei(_projectId) * numberOfTokens);
217         if (refund > 0) {
218             payable(msg.sender).transfer(refund);
219         }
220         uint256 mirageAmount = mintCost / 100 * mirageContract.miragePercentage();
221         if (mirageAmount > 0) {
222             payable(mirageContract.mirageAddress()).transfer(mirageAmount);
223         }
224         uint256 projectFunds = mintCost - mirageAmount;
225         uint256 additionalPayeeAmount;
226         if (mirageContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
227             additionalPayeeAmount = projectFunds / 100 * mirageContract.projectIdToAdditionalPayeePercentage(_projectId);
228             if (additionalPayeeAmount > 0) {
229             payable(mirageContract.projectIdToAdditionalPayee(_projectId)).transfer(additionalPayeeAmount);
230             }
231         }
232         uint256 creatorFunds = projectFunds - additionalPayeeAmount;
233         if (creatorFunds > 0) {
234             payable(mirageContract.projectIdToArtistAddress(_projectId)).transfer(creatorFunds);
235         }
236         }
237     }
238 }