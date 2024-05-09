1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
31 
32 
33 
34 pragma solidity ^0.8.0;
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
57         _setOwner(_msgSender());
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
83         _setOwner(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _setOwner(newOwner);
93     }
94 
95     function _setOwner(address newOwner) private {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File contracts/WickedStaking.sol
104 
105 
106 pragma solidity ^0.8.0;
107 
108 abstract contract TWC {
109     function ownerOf(uint256 tokenId) public view virtual returns (address);
110 
111     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256);
112 
113     function balanceOf(address owner) external view virtual returns (uint256 balance);
114 
115     function setApprovalForAll(address operator, bool _approved) external virtual;
116 
117     function transferFrom(
118         address from,
119         address to,
120         uint256 tokenId
121     ) external virtual;
122 }
123 
124 abstract contract TWS {
125     function ownerOf(uint256 tokenId) public view virtual returns (address);
126 
127     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256);
128 
129     function balanceOf(address owner) external view virtual returns (uint256 balance);
130 
131     function setApprovalForAll(address operator, bool _approved) external virtual;
132 
133     function transferFrom(
134         address from,
135         address to,
136         uint256 tokenId
137     ) external virtual;
138 }
139 
140 abstract contract WickedCraniumsComic {
141     function ownerOf(uint256 tokenId) external view virtual returns (address);
142 
143     function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual returns (uint256);
144 
145     function balanceOf(address owner) external view virtual returns (uint256 balance);
146 
147     function safeMint(address to) public virtual;
148 }
149 
150 abstract contract WickedCraniumsXHaylos {
151     function ownerOf(uint256 tokenId) external view virtual returns (address);
152 
153     function tokenOfOwnerByIndex(address owner, uint256 index) external view virtual returns (uint256);
154 
155     function balanceOf(address owner) external view virtual returns (uint256 balance);
156 
157     function safeMint(address to) public virtual;
158 }
159 
160 contract WickedStaking is Ownable {
161     TWC private twc = TWC(0x85f740958906b317de6ed79663012859067E745B);
162     TWS private tws = TWS(0x45d8f7Db9b437efbc74BA6a945A81AaF62dcedA7);
163     WickedCraniumsComic private comic = WickedCraniumsComic(0xA932DaC13BED512aaa12975f7aD892afB120022f);
164     WickedCraniumsXHaylos private haylos = WickedCraniumsXHaylos(0xB8bD00aA3a8fa212E0654c7382c1c7936c9728e6);
165 
166     mapping(address => uint256) private pagesUnredeemed;
167     mapping(address => uint256[]) private addressToCraniumsStaked;
168     mapping(address => uint256[]) private addressToStallionsStaked;
169     mapping(address => uint256) private unstakedIndex;
170 
171     bool public isStakingActive = false;
172     bool public areComicPagesRedeemable = false;
173     bool public isUnstakingActive = false;
174 
175     constructor() {}
176 
177     function flipStakingState() public onlyOwner {
178         isStakingActive = !isStakingActive;
179     }
180 
181     function flipComicRedeemableState() public onlyOwner {
182         areComicPagesRedeemable = !areComicPagesRedeemable;
183     }
184 
185     function flipUnstakingState() public onlyOwner {
186         isUnstakingActive = !isUnstakingActive;
187     }
188 
189     function stake(uint256[] memory craniumIds, uint256[] memory stallionIds) public {
190         require(isStakingActive, "stake: staking must be active");
191         require(craniumIds.length == stallionIds.length, "stake: Total number of Craniums staked must match the total number of Stallions staked.");
192         require(craniumIds.length >= 1, "stake: 1 or more {Cranium, Stallion} pairs must be staked.");
193 
194         for (uint256 i = 0; i < craniumIds.length; i++) {
195             require(twc.ownerOf(craniumIds[i]) == msg.sender, "stake: msg.sender must be the owner of all Craniums staked.");
196         }
197 
198         for (uint256 i = 0; i < stallionIds.length; i++) {
199             require(tws.ownerOf(stallionIds[i]) == msg.sender, "stake: msg.sender must be the owner of all Stallions staked.");
200         }
201 
202         // twc.setApprovalForAll(address(this), true);
203         // tws.setApprovalForAll(address(this), true);
204 
205         for (uint256 i = 0; i < craniumIds.length; i++) {
206             twc.transferFrom(msg.sender, address(this), craniumIds[i]);
207         }
208 
209         for (uint256 i = 0; i < stallionIds.length; i++) {
210             tws.transferFrom(msg.sender, address(this), stallionIds[i]);
211         }
212 
213         for (uint256 i = 0; i < craniumIds.length; i++) {
214             haylos.safeMint(msg.sender);
215         }
216 
217         pagesUnredeemed[msg.sender] += craniumIds.length;
218 
219         for (uint256 i = 0; i < craniumIds.length; i++) {
220             addressToCraniumsStaked[msg.sender].push(craniumIds[i]);
221             addressToStallionsStaked[msg.sender].push(stallionIds[i]);
222         }
223     }
224 
225     function redeemComicPages(uint256 pagesToRedeem) public {
226         require(areComicPagesRedeemable, "redeeming comic pages is not active");
227         require(pagesToRedeem > 0, "redeemComicPages: Can only request to redeem > 0 pages");
228         require(pagesToRedeem <= pagesUnredeemed[msg.sender], "redeemComicPages: pages to redeem must be <= pages unredeemed for this address");
229 
230         for (uint256 i = 0; i < pagesToRedeem; i++) {
231             comic.safeMint(msg.sender);
232         }
233 
234         pagesUnredeemed[msg.sender] -= pagesToRedeem;
235     }
236 
237     function redeemAllComicPages() public {
238         require(areComicPagesRedeemable, "redeeming comic pages is not active");
239         require(pagesUnredeemed[msg.sender] > 0, "redeemAllComicPages: pages unredeemed for this address should be > 0");
240 
241         uint256 pagesToRedeem = pagesUnredeemed[msg.sender];
242 
243         for (uint256 i = 0; i < pagesToRedeem; i++) {
244             comic.safeMint(msg.sender);
245         }
246 
247         pagesUnredeemed[msg.sender] -= pagesToRedeem;
248     }
249 
250     function unstakeAll() public {
251         require(isUnstakingActive, "unstaking is not active");
252         require(addressToCraniumsStaked[msg.sender].length > 0, "unstakeAll: craniums staked for this address should be > 0");
253         require(unstakedIndex[msg.sender] < addressToCraniumsStaked[msg.sender].length, "unstakeAll: unstake index must be less than total staked");
254 
255         uint256[] memory craniumsToUnstake = addressToCraniumsStaked[msg.sender];
256         uint256[] memory stallionsToUnstake = addressToStallionsStaked[msg.sender];
257 
258         for (uint256 i = unstakedIndex[msg.sender]; i < craniumsToUnstake.length; i++) {
259             twc.transferFrom(address(this), msg.sender, craniumsToUnstake[i]);
260             tws.transferFrom(address(this), msg.sender, stallionsToUnstake[i]);
261         }
262 
263         unstakedIndex[msg.sender] += craniumsToUnstake.length;
264     }
265 
266     function unstakeSome(uint256 totalToUnstake) public {
267         require(isUnstakingActive, "unstaking is not active");
268         require(totalToUnstake > 0, "cannot unstake 0 or less pairs");
269         require(
270             totalToUnstake <= addressToCraniumsStaked[msg.sender].length - unstakedIndex[msg.sender],
271             "unstakeSome: totalToUnstake <= total staked - unstakedIndex"
272         );
273 
274         uint256[] memory craniumsStaked = addressToCraniumsStaked[msg.sender];
275         uint256[] memory stallionsStaked = addressToStallionsStaked[msg.sender];
276 
277         for (uint256 i = unstakedIndex[msg.sender]; i < unstakedIndex[msg.sender] + totalToUnstake; i++) {
278             twc.transferFrom(address(this), msg.sender, craniumsStaked[i]);
279             tws.transferFrom(address(this), msg.sender, stallionsStaked[i]);
280         }
281 
282         unstakedIndex[msg.sender] += totalToUnstake;
283     }
284 }