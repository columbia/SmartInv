1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _setOwner(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _setOwner(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _setOwner(newOwner);
81     }
82 
83     function _setOwner(address newOwner) private {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 interface MP {
91     function balanceOf(address wallet) external view returns(uint256);
92     function transferFrom(address from, address to, uint256 tokenId) external;
93     function isApprovedForAll(address wallet, address stakingAddress) external view returns(bool);
94 }
95 
96 interface Shard {
97     function determineYield(uint256 timestamp) external view returns(uint256);
98     function mintShards(address wallet, uint256 amount) external;
99 }
100 
101 /*
102 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
103 ⠀*⠀⠀⠀⠀⢀⣀⣀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣀⣀⡀⠀⠀⠀⠀⠀
104 ⠀*⠀⠀⠀⠀⢸⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⡇⠀⠀⠀⠀⠀
105 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⣿⣿⡿⠟⠁⠀⠀⣀⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
106 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⡿⠋⠀⠀⠀⣠⣾⣿⡿⠋⠁⠀⣿⡇⠀⠀⠀⠀⠀
107 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⠟⠉⠀⠀⢀⣴⣾⣿⠿⠋⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
108 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣠⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
109 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⣠⣾⣿⡿⠋⠁⠀⠀⠀⠀⠀⣠⣶⠀⣿⡇⠀⠀⠀⠀⠀
110 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⠿⠋⠀⠀⠀⠀⠀⢀⣠⣾⡿⠟⠀⣿⡇⠀⠀⠀⠀⠀
111 ⠀*⠀⠀⠀⠀⢸⣿⠀⠘⠁⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⣠⣴⠀⣿⡇⠀⠀⠀⠀⠀
112 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⢁⣠⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
113 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⢀⣠⣾⡿⠋⢁⣴⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
114 ⠀*⠀⠀⠀⠀⢸⣿⣀⣀⣀⣈⣉⣉⣀⣀⣉⣉⣉⣉⣉⣉⣉⣀⣿⡇⠀⠀⠀⠀⠀
115 ⠀*⠀⠀⠀⠀⠘⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠛⠛⠃⠀⠀⠀⠀⠀
116 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
117  *          MIRRORPASS.XYZ
118  */
119 contract Frame is Ownable {
120     MP private mp;
121     Shard private shards;
122 
123     struct LockedUp {
124         address owner;
125         uint256 until;
126         uint256 token;
127         bool hasToken;
128     }
129 
130     bool public stakingAvailable = false;
131     bool public lockupAvailable = false;
132     bool public claimingAvailable = false;
133     uint256 public totalStaked = 0;
134 
135     mapping(address => uint256[]) private tokensHeld;
136     mapping(address => LockedUp) private lockedup;
137     mapping(uint256 => uint256) private tokenYield;
138     mapping(uint256 => address) private tokenToOwner;
139 
140     event StakedToken(address wallet, uint256[] tokens, uint256 timestamp);
141     event WithdrewToken(address wallet, uint256 tokenId, uint256 timestamp);
142     event LockedToken(address wallet, uint256 tokenId, uint256 timestamp);
143     event FreeToken(address wallet, uint256 tokenId);
144 
145     modifier isNotContract() {
146         require(tx.origin == msg.sender, "No contracts allowed");
147         _;
148     }
149 
150     modifier isStakingAvailable() {
151         require(stakingAvailable, "Staking is currently disabled");
152         _;
153     }
154 
155     modifier isLockupAvailable() {
156         require(lockupAvailable, "Lock Up is currently disabled");
157         _;
158     }
159 
160     // this returns the index of the token we're looking for in the deposited wallets
161     function findToken(uint256 token, uint256[] memory tokens) private pure returns(uint256) {
162         uint256 index = 0;
163 
164         while (tokens[index] != token) {
165             index++;
166         }
167         
168         return index;
169     }
170 
171     // this allows the user to start staking their tokens and it keeps track of the
172     // tokens that are staked, as well as the timestamp that they were deposited with
173     function stake(uint256[] memory tokens) public isStakingAvailable isNotContract {
174         require(tokens.length >= 1 && tokens.length <= 5, "Invalid token amount");
175 
176         uint256[] storage _deposits = tokensHeld[msg.sender];
177 
178         for (uint256 x = 0;x < tokens.length;x++) {
179             uint256 _token = tokens[x];
180 
181             mp.transferFrom(msg.sender, address(this), _token);
182 
183             _deposits.push(_token); 
184             tokenYield[_token] = block.timestamp;
185             tokenToOwner[_token] = msg.sender;
186         }
187 
188         totalStaked += tokens.length;
189         emit StakedToken(msg.sender, tokens, block.timestamp);
190     }
191 
192     // this withdraws the staked tokens and claims any shards that weren't claimed
193     function withdraw(uint256[] memory tokens) public isNotContract {
194         require(tokens.length >= 1 && tokens.length <= 5, "Invalid token amount");
195 
196         uint256 shardsGained = 0;
197         uint256[] storage _deposits = tokensHeld[msg.sender];
198 
199         for (uint256 x = 0;x < tokens.length;x++) {
200             uint256 _token = tokens[x];
201             address _owner = tokenToOwner[_token];
202 
203             require(_owner == msg.sender, "You didn't deposit these");
204             mp.transferFrom(address(this), _owner, _token);
205             
206             uint256 index = findToken(_token, _deposits);
207             delete _deposits[index];
208 
209             // this accumulates the shards the wallet gained from all the tokens
210             if (claimingAvailable) {
211                 shardsGained += shards.determineYield(tokenYield[_token]);
212             }
213 
214             emit WithdrewToken(_owner, _token, tokenYield[_token]);
215 
216             tokenYield[_token] = 0;
217             delete _owner;
218         }
219 
220         if (claimingAvailable) {
221             shards.mintShards(msg.sender, shardsGained);
222         }
223 
224         totalStaked -= tokens.length;
225         delete shardsGained;
226     }
227 
228     // this allows you to "withdraw" your erc20 tokens from the staked tokens
229     function claimShardsFromTokens(uint256[] memory tokens) public isNotContract {
230         require(claimingAvailable, "You're not able to withdraw your shards right now");
231 
232         uint256 shardsGained = 0;
233 
234         for (uint256 x = 0;x < tokens.length;x++) {
235             uint256 _token = tokens[x];
236             require(tokenToOwner[_token] == msg.sender, "You didn't deposit these");
237 
238             shardsGained += shards.determineYield(tokenYield[_token]);
239             tokenYield[_token] = block.timestamp;
240             delete _token;
241         }
242 
243         shards.mintShards(msg.sender, shardsGained);
244         delete shardsGained;
245     }
246 
247     // this returns the timestamp of when the token was staked, used for determining
248     // the yield each token gives
249     function getTimeFromToken(uint256 token) public view returns (uint256) {
250         return tokenYield[token];
251     }
252 
253     // returns the total amount of tokens that are staked, used on the UI & for calculating yield
254     function getTokensStaked(address wallet) public view returns (uint256[] memory) {
255         return tokensHeld[wallet];
256     }
257 
258     // this locks in the pass into the staking contract for X amount of time, this will give access
259     // to the application until the lock up period is over
260     function lockIn(uint256 tokenId, uint256 period) public isLockupAvailable isNotContract {
261         LockedUp storage _lockedup = lockedup[msg.sender];
262 
263         require(!_lockedup.hasToken, "You need to withdraw your current token first");
264         require(period > 0 && period <= 3, "You can only lock in your token for 30 to 90 days!");
265 
266         mp.transferFrom(msg.sender, address(this), tokenId);
267 
268         _lockedup.owner = msg.sender;
269         _lockedup.until = block.timestamp + (30 days * period);
270         _lockedup.token = tokenId;
271         _lockedup.hasToken = true;
272         totalStaked += 1;
273 
274         emit LockedToken(msg.sender, tokenId, _lockedup.until);        
275     }
276 
277     // once the users lock in period is over, they are able to withdraw the token using this
278     function withdrawLockedUp() public isNotContract {
279         LockedUp storage _lockedup = lockedup[msg.sender];
280 
281         require(block.timestamp >= _lockedup.until, "Your lock in period is not over yet");
282 
283         mp.transferFrom(address(this), _lockedup.owner, _lockedup.token);
284 
285         _lockedup.hasToken = false;
286         _lockedup.until = 0;
287         totalStaked -= 1;
288 
289         emit FreeToken(_lockedup.owner, _lockedup.token);
290     }
291 
292     // this returns the timestamp of when the locked up period ends
293     function getLockedInTime(address wallet) public view returns (uint256) {
294         LockedUp storage _lockedup = lockedup[wallet];
295 
296         return _lockedup.until;
297     }
298 
299     // this is more of a emergency case incase anything happens that requires
300     // people to withdraw their tokens
301     function clearLockedupUntil(address[] memory addresses) public onlyOwner {
302         for (uint x = 0;x < addresses.length;x++) {
303             LockedUp storage _lockedup = lockedup[addresses[x]];
304 
305             _lockedup.until = 0;
306         }
307     }
308 
309     // this is a emergency withdraw for locked in tokens if we need to do this any reason
310     function emergencyWithdrawLockedup(address[] memory addresses) public onlyOwner {
311         for (uint x = 0;x < addresses.length;x++) {
312             LockedUp storage _lockedup = lockedup[addresses[x]];
313 
314             if (_lockedup.hasToken) {
315                 mp.transferFrom(address(this), _lockedup.owner, _lockedup.token);
316                 
317                 _lockedup.until = 0;
318                 _lockedup.hasToken = false;
319                 totalStaked -= 1;
320             }
321         }
322     }
323 
324     // this is used on the dashboard to calculate the pending shards 
325     function calculateTotalPendingShards(uint256[] memory tokens) public view returns(uint256) {
326         uint256 possibleShards = 0;
327 
328         for (uint256 x = 0;x < tokens.length;x++) {
329             uint256 _token = tokens[x];
330             possibleShards += shards.determineYield(tokenYield[_token]);
331             delete _token;
332         }
333 
334         return possibleShards;
335     }
336 
337     // this is the erc721 contract that holds the OG  mirror pass
338     function setTokenContract(address tokenContract) public onlyOwner {
339         mp = MP(tokenContract);
340     }
341     
342     // this is the erc20 token that interacts with the ECOSYSTEM
343     function setShardsContract(address shardsContract) public onlyOwner {
344         shards = Shard(shardsContract);
345     }
346 
347     // this enables / dsiables stake
348     function setStakingState(bool available) public onlyOwner {
349         stakingAvailable = available;
350     }
351 
352     // this enables / disables lockIn
353     function setLockupState(bool available) public onlyOwner {
354         lockupAvailable = available;
355     }
356 
357     // this enables / disable erc20 token minting incase something occurs
358     // where we need to disable this
359     function setShardMinting(bool available) public onlyOwner {
360         claimingAvailable = available;
361     }
362 }