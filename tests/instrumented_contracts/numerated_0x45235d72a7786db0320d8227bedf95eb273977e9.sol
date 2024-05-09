1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 interface IERC721Receiver {
9     /**
10      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
11      * by `operator` from `from`, this function is called.
12      *
13      * It must return its Solidity selector to confirm the token transfer.
14      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
15      *
16      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
17      */
18     function onERC721Received(
19         address operator,
20         address from,
21         uint256 tokenId,
22         bytes calldata data
23     ) external returns (bytes4);
24 }
25 
26 interface ILegendsOfAtlantis {
27     function safeTransferFrom(address from, address to, uint256 tokenId) external;
28     function ownerOf(uint256 tokenId) external view returns (address owner);
29 }
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and making it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 contract Staking is IERC721Receiver, ReentrancyGuard {
91 
92     address public owner;
93 
94     struct Stake {
95         uint256 tokenId;
96         address owner;
97         uint256 startTime;
98     }
99 
100     event stakeAdded(uint256 _id);
101     event stakeRemoved(uint256 _id);
102 
103     mapping(uint256 => Stake) public stakes;
104     mapping(address => uint256[]) public stakesByOwner;
105 
106     ILegendsOfAtlantis legendsOfAtlantis;
107 
108     constructor() {
109         legendsOfAtlantis = ILegendsOfAtlantis(0x7746B7eF168547B61890E6B7Ce2CC6a1FE40C872);
110         owner = msg.sender;
111     }
112 
113     function stake(uint256 _id) public nonReentrant {
114         address caller = msg.sender;
115         require(msg.sender == tx.origin, "Only EOA!");
116         // check if caller is owner of nft
117         require(legendsOfAtlantis.ownerOf(_id) == caller, "Not an owner of NFT!");
118         // update stakes & stakes by owner
119         stakes[_id] = Stake({
120             tokenId: _id,
121             owner: caller,
122             startTime: block.timestamp
123         });
124         // stakesByOwner[caller].push(_id);
125         for (uint256 j=0; j<stakesByOwner[caller].length + 1; j++) {
126             if (stakesByOwner[caller].length == j) {
127                 stakesByOwner[caller].push(_id);
128                 break;
129             } else if (stakesByOwner[caller][j] == 0) {
130                 stakesByOwner[caller][j] = _id;
131                 break;
132             }
133         }
134         // transfer nft to smart contract
135         legendsOfAtlantis.safeTransferFrom(caller, address(this), _id);
136 
137         emit stakeAdded(_id);
138     }
139 
140     function stakeMany(uint256[] memory _wallet) public nonReentrant {
141         address caller = msg.sender;
142         require(msg.sender == tx.origin, "Only EOA!");
143         // iterate over caller IDs
144         for (uint256 i=0; i<_wallet.length; i++) {
145             uint256 _id = _wallet[i];
146             // check if caller is owner of nft
147             require(legendsOfAtlantis.ownerOf(_id) == caller, "Not an owner of NFT!");
148             // update stakes & stakes by owner
149             stakes[_id] = Stake({
150                 tokenId: _id,
151                 owner: caller,
152                 startTime: block.timestamp
153             });
154             // stakesByOwner[caller].push(_id);
155             for (uint256 j=0; j<stakesByOwner[caller].length + 1; j++) {
156                 if (stakesByOwner[caller].length == j) {
157                     stakesByOwner[caller].push(_id);
158                     break;
159                 } else if (stakesByOwner[caller][j] == 0) {
160                     stakesByOwner[caller][j] = _id;
161                     break;
162                 }
163             }
164             // transfer nft to smart contract
165             legendsOfAtlantis.safeTransferFrom(caller, address(this), _id);
166 
167             emit stakeAdded(_id);
168         }
169     }
170 
171     function unstake(uint256 _id) public nonReentrant {
172         address caller = msg.sender;
173         require(msg.sender == tx.origin, "Only EOA!");
174         // check if caller is owner of nft & time staked longer than 2 days
175         require(stakes[_id].owner == msg.sender, "Not an owner of NFT!");
176         require(getStakeTime(_id) > 172_800, "You can unstake only after 2 days");
177         // update stakes & stakes by owner
178         delete stakes[_id];
179         for (uint256 j=0; j<stakesByOwner[caller].length; j++) {
180             if (stakesByOwner[caller][j] == _id) {
181                 delete stakesByOwner[caller][j];
182             }
183         }
184         // transfer nft to caller
185         legendsOfAtlantis.safeTransferFrom(address(this), caller, _id);
186 
187         emit stakeRemoved(_id);
188     }
189 
190     function unstakeMany(uint256[] memory _wallet) public nonReentrant {
191         address caller = msg.sender;
192         require(msg.sender == tx.origin, "Only EOA!");
193         // iterate over caller IDs
194         for (uint256 i=0; i<_wallet.length; i++) {
195             uint256 _id = _wallet[i];
196             // check if caller is owner of nft & time staked longer than 2 days
197             require(stakes[_id].owner == caller, "Not an owner of NFT!");
198             require(getStakeTime(_id) > 172_800, "You can unstake only after 2 days!");
199             // update stakes & stakes by owner
200             delete stakes[_id];
201             for (uint256 j=0; j<stakesByOwner[caller].length; j++) {
202                 if (stakesByOwner[caller][j] == _id) {
203                     delete stakesByOwner[caller][j];
204                 }
205             }
206             // transfer nft to caller
207             legendsOfAtlantis.safeTransferFrom(address(this), caller, _id);
208 
209             emit stakeRemoved(_id);
210         }
211     }
212 
213     function emergencyUnstake(uint256 _id) public {
214         require(msg.sender == owner, "You are not an owner!");
215         address stakeOwner = stakes[_id].owner;
216         delete stakes[_id];
217         for (uint256 j=0; j<stakesByOwner[stakeOwner].length; j++) {
218                 if (stakesByOwner[stakeOwner][j] == _id) {
219                     delete stakesByOwner[stakeOwner][j];
220                 }
221             }
222         legendsOfAtlantis.safeTransferFrom(address(this), owner, _id);
223     }
224 
225     function getStakeTime(uint256 _id) public view returns(uint256) {
226         return (block.timestamp - stakes[_id].startTime);
227     }
228 
229     function getStakeOwner(uint256 _id) public view returns(address) {
230         return stakes[_id].owner;
231     }
232 
233     function getStakesByOwner(address _owner) public view returns(uint256[] memory) {
234         return stakesByOwner[_owner];
235     }
236 
237     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) pure external override returns(bytes4) {
238         return IERC721Receiver.onERC721Received.selector;
239     }
240 }