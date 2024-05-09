1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
106 // File: contracts/Grail.sol
107 
108 
109 pragma solidity ^0.8.0;
110 
111 
112 interface InterfaceRainbows {
113     function burn(address user, uint256 amount) external;
114 }
115 
116 contract Grail is Ownable {
117 
118     struct RaffleEntry {
119         address user;
120         uint32 count;
121     }
122 
123     // Interfaces to interact with the other contracts
124     InterfaceRainbows public Rainbows;
125 
126     // address[] public entryList;
127     address[] public winnerList;
128 
129     uint256 public raffleEntryCost = 20 ether;
130 
131     // Entry time.
132     uint256 public raffleStartTime = 0;
133     uint256 public raffleEndTime = 0;
134 
135     RaffleEntry[] public raffleEntries;
136     uint256 public totalRaffleEntries;
137 
138     uint256 public uniqueEntryAddresses;
139     mapping(address => uint256) public userEntries;
140     mapping(address => bool) public winners;
141 
142     event RaffleWinner(address indexed _winner);
143 
144     // Extended access
145     mapping(address => bool) public extendedAccess;
146 
147     modifier raffleEnabled() {
148         require(raffleStartTime > 0 && block.timestamp > raffleStartTime, "Raffle not started.");
149         require(raffleEndTime > 0 && block.timestamp <= raffleEndTime, "Raffle has ended.");
150         _;
151     }
152 
153     modifier onlyFromRestricted() {
154         require(extendedAccess[msg.sender], "Your address does not have permission to use.");
155         _;
156     }
157 
158     constructor() {
159         extendedAccess[msg.sender] = true;
160     }
161 
162     // Set the address for the contract.
163     function setAddressAccess(address _noundles, bool _value) public onlyOwner {
164         extendedAccess[_noundles] = _value;
165     }
166 
167     // Get the access status for a address.
168     function getAddressAccess(address user) external view returns(bool) {
169         return extendedAccess[user];
170     }
171 
172     // Reset the raffle.
173     function resetRaffle() public onlyFromRestricted {
174         totalRaffleEntries = 0;
175         uniqueEntryAddresses = 0;
176         for(uint i; i < raffleEntries.length; i++) {
177             address user = raffleEntries[i].user;
178             userEntries[user] = 0;
179             winners[user] = false;
180         }
181         delete winnerList;
182         delete raffleEntries;
183     }
184 
185     function resetWinners() internal {
186         for(uint i; i < raffleEntries.length; i++) {
187             address user = raffleEntries[i].user;
188             winners[user] = false;
189         }
190         delete winnerList;
191     }
192 
193     // Set the time.
194     function setRaffleSettings(uint256 _raffleStartTime, uint256 _raffleEndTime, uint256 _raffleEntryCost) public onlyFromRestricted {
195         raffleStartTime = _raffleStartTime;
196         raffleEndTime   = _raffleEndTime;
197         raffleEntryCost = _raffleEntryCost;
198     }
199 
200     // Set the address.
201     function setAddresses(address _rainbow) external onlyOwner {
202         Rainbows = InterfaceRainbows(_rainbow);
203     }
204 
205     // Enter the raffle.
206     function enterRaffle(uint32 _entryCount) public raffleEnabled {
207         Rainbows.burn(msg.sender, raffleEntryCost * _entryCount);
208 
209         raffleEntries.push(RaffleEntry(msg.sender, _entryCount));
210         totalRaffleEntries += _entryCount;
211 
212         if(userEntries[msg.sender] == 0) {
213             uniqueEntryAddresses += 1;
214         }
215 
216         userEntries[msg.sender] += _entryCount;
217     }
218 
219     // Pick the winners.
220     function pickWinners(uint256 _winnerCount) public onlyFromRestricted {
221         require(_winnerCount <= uniqueEntryAddresses, "Can't have more winners than entries");
222 
223         // Reset the winners.
224         resetWinners();
225 
226         uint256 retryCounter = 0;
227 
228         for(uint256 i = 1; i < (_winnerCount + 1); i += 1) {
229 
230             uint256 pick = getRandomNumber(i + retryCounter) % totalRaffleEntries;
231             uint256 runningTotal = 0;
232 
233             for(uint r; r < raffleEntries.length; r += 1) {
234 
235                 RaffleEntry storage entry = raffleEntries[r];
236 
237                 if(runningTotal <= pick && pick < (runningTotal + entry.count)) {
238 
239                     // If it's already picked.
240                     if(winners[entry.user]) {
241                         i--;
242                         retryCounter += 1;
243                         break;
244                     }
245 
246                     winners[entry.user] = true;
247                     emit RaffleWinner(entry.user);
248                     winnerList.push(entry.user);
249                     break;
250                 }
251 
252                 // Add to our total.
253                 runningTotal += entry.count;
254             }
255         }
256     }
257 
258     function pickWinnersView(uint256 _winnerCount) public view returns (address [] memory){
259         require(_winnerCount <= uniqueEntryAddresses, "Can't have more winners than entries");
260 
261         address[] memory localWinnerList = new address[](_winnerCount);
262 
263         uint256 retryCounter = 0;
264 
265         for(uint256 i = 1; i < (_winnerCount + 1); i += 1) {
266 
267             uint256 pick = getRandomNumber(i + retryCounter) % totalRaffleEntries;
268             uint256 runningTotal = 0;
269 
270             for(uint r; r < raffleEntries.length; r += 1) {
271                 RaffleEntry storage entry = raffleEntries[r];
272 
273                 if(runningTotal <= pick && pick < (runningTotal + entry.count)) {
274                     localWinnerList[i -1] = entry.user;
275                     break;
276                 }
277 
278                 // Add to our total.
279                 runningTotal += entry.count;
280             }
281         }
282 
283         return localWinnerList;
284     }
285 
286     function getRandomNumber(uint256 _arg) public view returns (uint) {
287         return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, _arg)));
288     }
289 
290     function getEntryCount(address _arg) public view returns (uint256) {
291         return userEntries[_arg];
292     }
293 
294     function getWinners() public view returns (address[] memory) {
295         return winnerList;
296     }
297 
298     function checkWinners(address _arg) public view returns (bool) {
299         return winners[_arg];
300     }
301 }