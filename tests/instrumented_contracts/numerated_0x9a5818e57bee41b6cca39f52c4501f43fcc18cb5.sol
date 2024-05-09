1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount)
26         external
27         returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender)
37         external
38         view
39         returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(
85         address indexed owner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(
127         address indexed previousOwner,
128         address indexed newOwner
129     );
130 
131     /**
132      * @dev Initializes the contract setting the deployer as the initial owner.
133      */
134     constructor() {
135         _setOwner(_msgSender());
136     }
137 
138     /**
139      * @dev Returns the address of the current owner.
140      */
141     function owner() public view virtual returns (address) {
142         return _owner;
143     }
144 
145     /**
146      * @dev Throws if called by any account other than the owner.
147      */
148     modifier onlyOwner() {
149         require(owner() == _msgSender(), "Ownable: caller is not the owner");
150         _;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         _setOwner(address(0));
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(
170             newOwner != address(0),
171             "Ownable: new owner is the zero address"
172         );
173         _setOwner(newOwner);
174     }
175 
176     function _setOwner(address newOwner) private {
177         address oldOwner = _owner;
178         _owner = newOwner;
179         emit OwnershipTransferred(oldOwner, newOwner);
180     }
181 }
182 
183 interface IGenArtInterface {
184     function getMaxMintForMembership(uint256 _membershipId)
185         external
186         view
187         returns (uint256);
188 
189     function getMaxMintForOwner(address owner) external view returns (uint256);
190 
191     function upgradeGenArtTokenContract(address _genArtTokenAddress) external;
192 
193     function setAllowGen(bool allow) external;
194 
195     function genAllowed() external view returns (bool);
196 
197     function isGoldToken(uint256 _membershipId) external view returns (bool);
198 
199     function transferFrom(
200         address _from,
201         address _to,
202         uint256 _amount
203     ) external;
204 
205     function balanceOf(address _owner) external view returns (uint256);
206 
207     function ownerOf(uint256 _membershipId) external view returns (address);
208 }
209 
210 interface IGenArt {
211     function getTokensByOwner(address owner)
212         external
213         view
214         returns (uint256[] memory);
215 
216     function ownerOf(uint256 tokenId) external view returns (address);
217 
218     function balanceOf(address owner) external view returns (uint256);
219 
220     function isGoldToken(uint256 _tokenId) external view returns (bool);
221 }
222 
223 interface IGenArtAirdrop {
224     function getAllowedMintForMembership(
225         uint256 _collectionId,
226         uint256 _membershipId
227     ) external view returns (uint256);
228 }
229 
230 interface IGenArtDrop {
231     function getAllowedMintForMembership(uint256 _group, uint256 _membershipId)
232         external
233         view
234         returns (uint256);
235 }
236 
237 contract GenArtTokenAirdrop is Ownable {
238     address genArtTokenAddress;
239     address genArtMembershipAddress;
240 
241     uint256 tokensPerMint = 213 * 1e18;
242     uint256 endBlock;
243     address genArtAirdropAddress;
244     address genArtDropAddress;
245 
246     uint256[] airdropCollections = [1, 2];
247     uint256[] dropCollectionGroups = [1, 2, 3, 4, 5, 6, 7, 8, 9];
248 
249     mapping(uint256 => bool) membershipClaims;
250     event Claimed(address account, uint256 membershipId, uint256 amount);
251 
252     constructor(
253         address genArtMembershipAddress_,
254         address genArtTokenAddress_,
255         address genArtAirdropAddress_,
256         address genArtDropAddress_,
257         uint256 endBlock_
258     ) {
259         genArtTokenAddress = genArtTokenAddress_;
260         genArtMembershipAddress = genArtMembershipAddress_;
261         genArtAirdropAddress = genArtAirdropAddress_;
262         genArtDropAddress = genArtDropAddress_;
263         endBlock = endBlock_;
264         excludeMemberships();
265     }
266 
267     function claimAllTokens() public {
268         require(
269             block.number < endBlock,
270             "GenArtTokenAirdrop: token claiming window has ended"
271         );
272         uint256[] memory memberships = IGenArt(genArtMembershipAddress)
273             .getTokensByOwner(msg.sender);
274         require(
275             memberships.length > 0,
276             "GenArtTokenAirdrop: sender does not own memberships"
277         );
278         uint256 airdropTokenAmount = 0;
279         for (uint256 i = 0; i < memberships.length; i++) {
280             airdropTokenAmount += getAirdropTokenAmount(memberships[i]);
281             membershipClaims[memberships[i]] = true;
282             emit Claimed(msg.sender, memberships[i], airdropTokenAmount);
283         }
284         require(
285             airdropTokenAmount > 0,
286             "GenArtTokenAirdrop: no tokens to claim"
287         );
288         IERC20(genArtTokenAddress).transfer(msg.sender, airdropTokenAmount);
289     }
290 
291     function claimTokens(uint256 membershipId) public {
292         require(
293             !membershipClaims[membershipId],
294             "GenArtTokenAirdrop: tokens already claimed"
295         );
296         require(
297             block.number < endBlock,
298             "GenArtTokenAirdrop: token claiming window has ended"
299         );
300         require(
301             IGenArt(genArtMembershipAddress).ownerOf(membershipId) ==
302                 msg.sender,
303             "GenArtTokenAirdrop: sender is not owner of membership"
304         );
305 
306         uint256 airdropTokenAmount = getAirdropTokenAmount(membershipId);
307 
308         require(
309             airdropTokenAmount > 0,
310             "GenArtTokenAirdrop: no tokens to claim"
311         );
312         IERC20(genArtTokenAddress).transfer(msg.sender, airdropTokenAmount);
313         emit Claimed(msg.sender, membershipId, airdropTokenAmount);
314         membershipClaims[membershipId] = true;
315     }
316 
317     function getAirdropTokenAmountAccount(address account)
318         public
319         view
320         returns (uint256)
321     {
322         uint256[] memory memberships = IGenArt(genArtMembershipAddress)
323             .getTokensByOwner(account);
324         uint256 airdropTokenAmount = 0;
325         for (uint256 i = 0; i < memberships.length; i++) {
326             airdropTokenAmount += getAirdropTokenAmount(memberships[i]);
327         }
328 
329         return airdropTokenAmount;
330     }
331 
332     function getAirdropTokenAmount(uint256 membershipId)
333         public
334         view
335         returns (uint256)
336     {
337         if (membershipClaims[membershipId]) {
338             return 0;
339         }
340 
341         bool isGoldToken = IGenArt(genArtMembershipAddress).isGoldToken(
342             membershipId
343         );
344         uint256 tokenAmount = 0;
345         for (uint256 i = 0; i < airdropCollections.length; i++) {
346             uint256 remainingMints = IGenArtAirdrop(genArtAirdropAddress)
347                 .getAllowedMintForMembership(
348                     airdropCollections[i],
349                     membershipId
350                 );
351 
352             uint256 mints = (isGoldToken ? 5 : 1) - remainingMints;
353             tokenAmount = tokenAmount + (mints * tokensPerMint);
354         }
355 
356         for (uint256 i = 0; i < dropCollectionGroups.length; i++) {
357             uint256 remainingMints = IGenArtDrop(genArtDropAddress)
358                 .getAllowedMintForMembership(
359                     dropCollectionGroups[i],
360                     membershipId
361                 );
362 
363             uint256 mints = (isGoldToken ? 5 : 1) - remainingMints;
364             tokenAmount = tokenAmount + (mints * tokensPerMint);
365         }
366 
367         return tokenAmount;
368     }
369 
370     /**
371      * @dev Function to receive ETH
372      */
373     receive() external payable virtual {}
374 
375     function withdrawTokens(uint256 _amount, address _to) public onlyOwner {
376         IERC20(genArtTokenAddress).transfer(_to, _amount);
377     }
378 
379     function withdraw(uint256 value) public onlyOwner {
380         address _owner = owner();
381         payable(_owner).transfer(value);
382     }
383 
384     function excludeMemberships() internal {
385         membershipClaims[997] = true;
386         membershipClaims[2304] = true;
387         membershipClaims[3183] = true;
388         membershipClaims[4125] = true;
389         membershipClaims[1821] = true;
390         membershipClaims[2127] = true;
391         membershipClaims[4785] = true;
392         membershipClaims[5016] = true;
393         membershipClaims[3127] = true;
394         membershipClaims[3119] = true;
395         membershipClaims[3593] = true;
396         membershipClaims[2722] = true;
397         membershipClaims[3124] = true;
398         membershipClaims[3030] = true;
399         membershipClaims[3994] = true;
400         membershipClaims[993] = true;
401         membershipClaims[1671] = true;
402         membershipClaims[1959] = true;
403         membershipClaims[4754] = true;
404         membershipClaims[444] = true;
405         membershipClaims[664] = true;
406         membershipClaims[1605] = true;
407         membershipClaims[1613] = true;
408         membershipClaims[249] = true;
409         membershipClaims[1173] = true;
410         membershipClaims[3869] = true;
411         membershipClaims[1567] = true;
412         membershipClaims[4725] = true;
413         membershipClaims[3137] = true;
414         membershipClaims[149] = true;
415         membershipClaims[4526] = true;
416         membershipClaims[5070] = true;
417         membershipClaims[5078] = true;
418         membershipClaims[3261] = true;
419         membershipClaims[5047] = true;
420         membershipClaims[2836] = true;
421         membershipClaims[4429] = true;
422         membershipClaims[4197] = true;
423         membershipClaims[2472] = true;
424         membershipClaims[1706] = true;
425         membershipClaims[3941] = true;
426         membershipClaims[3692] = true;
427         membershipClaims[3298] = true;
428         membershipClaims[3861] = true;
429     }
430 }