1 pragma solidity 0.4.24;
2 
3 /**
4  * Simple Public Voting/Poll Demo
5  *
6  * This is a DEMO contract. Please carefully inspect the source code and
7  * understand what it is doing before using any of this in production.
8  *
9  *
10  * Disclaimer of Warranty:
11  * THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.
12  * EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
13  * PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
14  * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
15  * FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
16  * PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
17  * NECESSARY SERVICING, REPAIR OR CORRECTION.
18  *
19  */
20 
21 
22 
23 // File: contracts/ownership/Ownable.sol
24 
25 /**
26  * @title Ownable
27  *
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32 
33     address private _owner;
34 
35     event OwnershipRenounced(address indexed previousOwner);
36 
37     event OwnershipTransferred(
38         address indexed previousOwner,
39         address indexed newOwner
40     );
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44      * account.
45      */
46     constructor()
47     public {
48         _owner = msg.sender;
49     }
50 
51     /**
52      * @return the address of the owner.
53      */
54     function owner()
55     public
56     view
57     returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(isOwner(), "Only the owner can do this.");
66         _;
67     }
68 
69     /**
70      * @return true if `msg.sender` is the owner of the contract.
71      */
72     function isOwner()
73     public
74     view
75     returns (bool) {
76         return msg.sender == _owner;
77     }
78 
79     /**
80      * @dev Allows the current owner to relinquish control of the contract.
81      * @notice Renouncing to ownership will leave the contract without an owner.
82      * It will not be possible to call the functions with the `onlyOwner`
83      * modifier anymore.
84      */
85     function renounceOwnership()
86     public
87     onlyOwner {
88         emit OwnershipRenounced(_owner);
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Allows the current owner to transfer control of the contract to a newOwner.
94      * @param newOwner The address to transfer ownership to.
95      */
96     function transferOwnership(address newOwner)
97     public
98     onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers control of the contract to a newOwner.
104      * @param newOwner The address to transfer ownership to.
105      */
106     function _transferOwnership(address newOwner)
107     internal {
108         require(newOwner != address(0), "New owner cannot be 0x0.");
109         emit OwnershipTransferred(_owner, newOwner);
110         _owner = newOwner;
111     }
112 }
113 
114 // File: contracts/lifecycle/Destructible.sol
115 
116 /**
117  * @title Destructible
118  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
119  */
120 contract Destructible is Ownable {
121 
122     /**
123      * @notice Destructs this contract (removes it from the blockchain) and sends all funds in it
124      *     to the owner.
125      *
126      * @dev Transfers the current balance to the owner and terminates the contract.
127      */
128     function destroy()
129     public
130     onlyOwner {
131         selfdestruct(owner());
132     }
133 
134     /**
135      * @notice Destructs this contract (removes it from the blockchain) and sends all funds in it
136      *     to the specified recipient address.
137      *
138      * @dev Transfers the current balance to the specified recipient and terminates the contract.
139      */
140     function destroyAndSend(address _recipient)
141     public
142     onlyOwner {
143         selfdestruct(_recipient);
144     }
145 }
146 
147 // File: contracts/interfaces/IERC20.sol
148 
149 /**
150  * @title ERC20 interface
151  *
152  * @notice Used to call methods in ERC-20 contracts.
153  *
154  * @dev see https://eips.ethereum.org/EIPS/eip-20
155  */
156 interface IERC20 {
157 
158     function transfer(address to, uint256 value)
159     external
160     returns (bool);
161 
162     function balanceOf(address who)
163     external
164     view
165     returns (uint256);
166 
167     function totalSupply()
168     external
169     view
170     returns (uint256);
171 
172     event Transfer(
173         address indexed from,
174         address indexed to,
175         uint256 value
176     );
177 
178 }
179 
180 // File: contracts/tokenutils/CanRescueERC20.sol
181 
182 /**
183  * @title CanRescueERC20
184  *
185  * Provides a function to recover ERC-20 tokens which are accidentally sent
186  * to the address of this contract (the owner can rescue ERC-20 tokens sent
187  * to this contract back to himself).
188  */
189 contract CanRescueERC20 is Ownable {
190 
191     /**
192      * Enable the owner to rescue ERC20 tokens, which are sent accidentally
193      * to this contract.
194      *
195      * @dev This will be invoked by the owner, when owner wants to rescue tokens
196      * @notice Recover tokens accidentally sent to this contract. They will be sent to the
197      *     contract owner. Can only be called by the owner.
198      * @param token Token which will we rescue to the owner from the contract
199      */
200     function recoverTokens(IERC20 token)
201     public
202     onlyOwner {
203         uint256 balance = token.balanceOf(this);
204         // Caution: ERC-20 standard doesn't require to throw exception on failures
205         // (although most ERC-20 tokens do so), but instead returns a bool value.
206         // Therefore let's check if it really returned true, and throw otherwise.
207         require(token.transfer(owner(), balance), "Token transfer failed, transfer() returned false.");
208     }
209 
210 }
211 
212 // File: contracts/Voting.sol
213 
214 contract Voting is Ownable, Destructible, CanRescueERC20 {
215 
216     /**
217      * @dev number of possible choices. Constant set at compile time.
218      */
219     uint8 internal constant NUMBER_OF_CHOICES = 4;
220 
221     /**
222      * @notice Number of total cast votes (uint40 is enough as at most
223      *     we support 4 choices and 2^32 votes per choice).
224      */
225     uint40 public voteCountTotal;
226 
227     /**
228      * @notice Number of votes, summarized per choice.
229      *
230      * @dev uint32 allows 4,294,967,296 possible votes per choice, should be enough,
231      *     and still allows 8 entries to be packed in a single storage slot
232      *     (EVM wordsize is 256 bit). And of course we check for overflows.
233      */
234     uint32[NUMBER_OF_CHOICES] internal currentVoteResults;
235 
236     /**
237      * @notice Mapping of address to vote details
238      */
239     mapping(address => Voter) public votersInfo;
240 
241     /**
242      * @notice Event gets emitted every time when a new vote is cast.
243      *
244      * @param addedVote choice in the vote
245      * @param allVotes array containing updated intermediate result
246      */
247     event NewVote(uint8 indexed addedVote, uint32[NUMBER_OF_CHOICES] allVotes);
248 
249     /**
250      * @dev Represent info about a single voter.
251      */
252     struct Voter {
253         bool exists;
254         uint8 choice;
255         string name;
256     }
257 
258     /**
259      * @notice Fallback function. Will be called whenever the contract receives ether, or
260      *     when is called without data or with unknown function signature.
261      */
262     function()
263     public {
264     }
265 
266     /**
267      * @notice Cast your note. In a real world scenario, you might want to have address
268      *     voting only once. In this DEMO we allow unlimited number of votes per address.
269      * @param voterName Name of the voter, will be publicly visible on the blockchain
270      * @param givenVote choice the caller has voted for
271      */
272     function castVote(string voterName, uint8 givenVote)
273     external {
274         // answer must be given
275         require(givenVote < numberOfChoices(), "Choice must be less than contract configured numberOfChoices.");
276 
277         // DEMO MODE: FOR EASIER TESTING, WE ALLOW UNLIMITED VOTES PER ADDRESS.
278         // check if already voted
279         //require(!votersInfo[msg.sender].exists, "This address has already voted. Vote denied.");
280 
281         //  voter name has to have at least 3 bytes (note: with utf8 some chars have
282         // more than 1 byte, so this check is not fully accurate but ok here)
283         require(bytes(voterName).length > 2, "Name of voter is too short.");
284 
285         // everything ok, add voter
286         votersInfo[msg.sender] = Voter(true, givenVote, voterName);
287         voteCountTotal = safeAdd40(voteCountTotal, 1);
288         currentVoteResults[givenVote] = safeAdd32(currentVoteResults[givenVote], 1);
289 
290         // emit a NewVote event at this point in time, so that a web3 Dapp
291         // can react it to it immediately. Emit full current vote state, as
292         // events are cheaper for light clients than querying the state.
293         emit NewVote(givenVote, currentVoteResults);
294     }
295 
296     /**
297     * @notice checks if this address has already cast a vote
298     *  this is required to find out if it is safe to call the other "thisVoters..." views.
299     */
300     function thisVoterExists()
301     external
302     view
303     returns (bool) {
304         return votersInfo[msg.sender].exists;
305     }
306 
307     /**
308      * @notice Returns the vote details of calling address or throws
309      *    if address has not voted yet.
310      */
311     function thisVotersChoice()
312     external
313     view
314     returns (uint8) {
315         // check if msg sender exists in voter mapping
316         require(votersInfo[msg.sender].exists, "No vote so far.");
317         return votersInfo[msg.sender].choice;
318     }
319 
320     /**
321      * @notice Returns the entered voter name of the calling address or throws
322      *    if address has not voted yet.
323      */
324     function thisVotersName()
325     external
326     view
327     returns (string) {
328         // check if msg sender exists in voter mapping
329         require(votersInfo[msg.sender].exists, "No vote so far.");
330         return votersInfo[msg.sender].name;
331     }
332 
333     /**
334      * @notice Return array with sums of votes per choice.
335      *
336      * @dev Note that this only will work for external callers, and not
337      *      for other contracts (as of solidity 0.4.24 returning of dynamically
338      *      sized data is still not in stable, it's only available with the
339      *      experimental "ABIEncoderV2" pragma). Also some block-explorers,
340      *      like etherscan, will have problems to display this correctly.
341      */
342     function currentResult()
343     external
344     view
345     returns (uint32[NUMBER_OF_CHOICES]) {
346         return currentVoteResults;
347     }
348 
349     /**
350      * @notice Return number of votes for one of the options.
351      */
352     function votesPerChoice(uint8 option)
353     external
354     view
355     returns (uint32) {
356         require(option < numberOfChoices(), "Choice must be less than contract configured numberOfChoices.");
357         return currentVoteResults[option];
358     }
359 
360     /**
361      * @notice Returns the number of possible choices, which can be voted for.
362      */
363     function numberOfChoices()
364     public
365     view
366     returns (uint8) {
367         // save as we only initialize array length in constructor
368         // and there we check it's never larger than uint8.
369         return uint8(currentVoteResults.length);
370     }
371 
372     /**
373      * @dev Adds two uint40 numbers, throws on overflow.
374      */
375     function safeAdd40(uint40 _a, uint40 _b)
376     internal
377     pure
378     returns (uint40 c) {
379         c = _a + _b;
380         assert(c >= _a);
381         return c;
382     }
383 
384     /**
385      * @dev Adds two uint32 numbers, throws on overflow.
386      */
387     function safeAdd32(uint32 _a, uint32 _b)
388     internal
389     pure
390     returns (uint32 c) {
391         c = _a + _b;
392         assert(c >= _a);
393         return c;
394     }
395 }