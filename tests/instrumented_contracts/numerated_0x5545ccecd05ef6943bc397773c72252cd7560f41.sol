1 pragma solidity 0.4.24;
2 
3 /*
4  * Simple Voting/Poll Demo
5  *
6  * This is just a DEMO! It contains a reset function and makes
7  * other assumptions which only make sense in the context of a demo.
8  *
9  * Also, the choice in the poll is determined by sender address
10  * (1 address per choice, you choose by sending from a specific address).
11  * This also probably will not be useful in a real-life scenario.
12  *
13  * Don't use it like this in a production setup!
14  *
15  */
16 
17 
18 
19 /**
20  * @title Ownable
21  *
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26 
27     address private _owner;
28 
29     event OwnershipRenounced(address indexed previousOwner);
30 
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     /**
37      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38      * account.
39      */
40     constructor()
41     public {
42         _owner = msg.sender;
43     }
44 
45     /**
46      * @return the address of the owner.
47      */
48     function owner()
49     public
50     view
51     returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(isOwner(), "Only the owner can do this.");
60         _;
61     }
62 
63     /**
64      * @return true if `msg.sender` is the owner of the contract.
65      */
66     function isOwner()
67     public
68     view
69     returns (bool) {
70         return msg.sender == _owner;
71     }
72 
73     /**
74      * @dev Allows the current owner to relinquish control of the contract.
75      * @notice Renouncing to ownership will leave the contract without an owner.
76      * It will not be possible to call the functions with the `onlyOwner`
77      * modifier anymore.
78      */
79     function renounceOwnership()
80     public
81     onlyOwner {
82         emit OwnershipRenounced(_owner);
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Allows the current owner to transfer control of the contract to a newOwner.
88      * @param newOwner The address to transfer ownership to.
89      */
90     function transferOwnership(address newOwner)
91     public
92     onlyOwner {
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers control of the contract to a newOwner.
98      * @param newOwner The address to transfer ownership to.
99      */
100     function _transferOwnership(address newOwner)
101     internal {
102         require(newOwner != address(0), "New owner cannot be 0x0.");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 /**
109  * @title Destructible
110  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
111  */
112 contract Destructible is Ownable {
113 
114     /**
115      * @notice Destructs this contract (removes it from the blockchain) and sends all funds in it
116      *     to the owner.
117      *
118      * @dev Transfers the current balance to the owner and terminates the contract.
119      */
120     function destroy()
121     public
122     onlyOwner {
123         selfdestruct(owner());
124     }
125 
126     /**
127      * @notice Destructs this contract (removes it from the blockchain) and sends all funds in it
128      *     to the specified recipient address.
129      *
130      * @dev Transfers the current balance to the specified recipient and terminates the contract.
131      */
132     function destroyAndSend(address _recipient)
133     public
134     onlyOwner {
135         selfdestruct(_recipient);
136     }
137 }
138 
139 /**
140  * @title ERC20 interface
141  *
142  * @notice Used to call methods in ERC-20 contracts.
143  *
144  * @dev see https://eips.ethereum.org/EIPS/eip-20
145  */
146 interface IERC20 {
147 
148     function transfer(address to, uint256 value)
149     external
150     returns (bool);
151 
152     function balanceOf(address who)
153     external
154     view
155     returns (uint256);
156 
157     function totalSupply()
158     external
159     view
160     returns (uint256);
161 
162     event Transfer(
163         address indexed from,
164         address indexed to,
165         uint256 value
166     );
167 
168 }
169 
170 /**
171  * @title CanRescueERC20
172  *
173  * Provides a function to recover ERC-20 tokens which are accidentally sent
174  * to the address of this contract (the owner can rescue ERC-20 tokens sent
175  * to this contract back to himself).
176  */
177 contract CanRescueERC20 is Ownable {
178 
179     /**
180      * Enable the owner to rescue ERC20 tokens, which are sent accidentally
181      * to this contract.
182      *
183      * @dev This will be invoked by the owner, when owner wants to rescue tokens
184      * @notice Recover tokens accidentally sent to this contract. They will be sent to the
185      *     contract owner. Can only be called by the owner.
186      * @param token Token which will we rescue to the owner from the contract
187      */
188     function recoverTokens(IERC20 token)
189     public
190     onlyOwner {
191         uint256 balance = token.balanceOf(this);
192         // Caution: ERC-20 standard doesn't require to throw exception on failures
193         // (although most ERC-20 tokens do so), but instead returns a bool value.
194         // Therefore let's check if it really returned true, and throw otherwise.
195         require(token.transfer(owner(), balance), "Token transfer failed, transfer() returned false.");
196     }
197 
198 }
199 
200 /**
201  * @title Simple Voting/Poll Demo
202  *
203  * This is just a DEMO! It contains a reset function and makes
204  * other assumptions which only make sense in the context of a demo.
205  *
206  * Don't use it like this in a production setup!
207  *
208  */
209 contract Voting is Ownable, Destructible, CanRescueERC20 {
210 
211     /**
212      * @dev number of possible choices. Constant set at compile time.
213      *     (Note: if this is changed you also have to adapt the
214      *     "castVote" function!)
215      */
216     uint8 internal constant NUMBER_OF_CHOICES = 4;
217 
218     /**
219      * @notice Only these adresses are allowed to send votes. Depending
220      *     on the sending address the voter's choice is dermined.
221      *     (i.e.: if sending from allowedSenderAdresses[0] means vote
222      *     for choice 0.)
223      */
224     address[NUMBER_OF_CHOICES] internal whitelistedSenderAdresses;
225 
226     /**
227      * @notice Number of total cast votes (uint40 is enough as at most
228      *     we support 2**8 choices and 2**32 votes per choice).
229      */
230     uint40 public voteCountTotal;
231 
232     /**
233      * @notice Number of votes, summarized per choice.
234      *
235      * @dev uint32 allows 4,294,967,296 possible votes per choice, should be enough,
236      *     and still allows 8 entries to be packed in a single storage slot
237      *     (EVM wordsize is 256 bit). And of course we check for overflows.
238      */
239     uint32[NUMBER_OF_CHOICES] internal currentVoteResults;
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
250      * @notice Event gets emitted every time the whitelisted sender addresses
251      *     get updated.
252      */
253     event WhitelistUpdated(address[NUMBER_OF_CHOICES] whitelistedSenderAdresses);
254 
255     /**
256      * @notice Event gets emitted every time this demo contract gets resetted.
257      */
258     event DemoResetted();
259 
260     /**
261      * @notice Fallback function. We do not allow to be ether sent to us. And we also
262      * do not allow transactions without any function call. Fallback function
263      * simply always throws.
264      */
265     function()
266     public {
267         require(false, "Fallback function always throws.");
268     }
269 
270     /**
271      * @notice Only the owner can define which addresses are allowed to vote
272      *     (and also which address stands for which vote choice)
273      *
274      * @param whitelistedSenders array of allowed vote sending addresses,
275      *     address at index 0 will vote for choice 0, address at index 1
276      *     will vote for choice 1, etc.
277      */
278     function setWhiteList(address[NUMBER_OF_CHOICES] whitelistedSenders)
279     external
280     onlyOwner {
281         // Assumption: we assume that owner takes care that list contains no duplicates.
282         // No duplicate check in here.
283         whitelistedSenderAdresses = whitelistedSenders;
284         emit WhitelistUpdated(whitelistedSenders);
285     }
286 
287     /**
288      * @notice As this is just a DEMO contract, allow the onwer to reset the
289      *     state of the Demo conract.
290      */
291     function resetDemo()
292     external
293     onlyOwner {
294         voteCountTotal = 0;
295         currentVoteResults[0] = 0;
296         currentVoteResults[1] = 0;
297         currentVoteResults[2] = 0;
298         currentVoteResults[3] = 0;
299         emit DemoResetted();
300     }
301 
302     /**
303      * @notice Cast your note. The sending address determines the choice you
304      *      are voting for (each choice has its own sending address). For the Demo
305      *      there will be 1 Infineon card lying around for each choice, and the
306      *      visitor chooses by using a specific card to to send the vote transaction.
307      */
308     function castVote()
309     external {
310         uint8 choice;
311         if (msg.sender == whitelistedSenderAdresses[0]) {
312             choice = 0;
313         } else if (msg.sender == whitelistedSenderAdresses[1]) {
314             choice = 1;
315         } else if (msg.sender == whitelistedSenderAdresses[2]) {
316             choice = 2;
317         } else if (msg.sender == whitelistedSenderAdresses[3]) {
318             choice = 3;
319         } else {
320             require(false, "Only whitelisted sender addresses can cast votes.");
321         }
322 
323         // everything ok, add voter
324         voteCountTotal = safeAdd40(voteCountTotal, 1);
325         currentVoteResults[choice] = safeAdd32(currentVoteResults[choice], 1);
326 
327         // emit a NewVote event at this point in time, so that a web3 Dapp
328         // can react it to it immediately. Emit full current vote state, as
329         // events are cheaper for light clients than querying the state.
330         emit NewVote(choice, currentVoteResults);
331     }
332 
333     /**
334      * @notice Return array with sums of votes per choice.
335      */
336     function currentResult()
337     external
338     view
339     returns (uint32[NUMBER_OF_CHOICES]) {
340         return currentVoteResults;
341     }
342 
343     /**
344      * @notice Return array of allowed voter addresses. Address at index 0
345      *     represents votes for choice 0, addresses at index 1 represent
346      *     votes for choice 1, etc.
347      */
348     function whitelistedSenderAddresses()
349     external
350     view
351     returns (address[NUMBER_OF_CHOICES]) {
352         return whitelistedSenderAdresses;
353     }
354 
355     /**
356      * @notice Return number of votes for one of the options.
357      */
358     function votesPerChoice(uint8 option)
359     external
360     view
361     returns (uint32) {
362         require(option < NUMBER_OF_CHOICES, "Choice must be less than numberOfChoices.");
363         return currentVoteResults[option];
364     }
365 
366     /**
367      * @notice Returns the number of possible choices, which can be voted for.
368      */
369     function numberOfPossibleChoices()
370     public
371     pure
372     returns (uint8) {
373         return NUMBER_OF_CHOICES;
374     }
375 
376     /**
377      * @dev Adds two uint40 numbers, throws on overflow.
378      */
379     function safeAdd40(uint40 _a, uint40 _b)
380     internal
381     pure
382     returns (uint40 c) {
383         c = _a + _b;
384         assert(c >= _a);
385         return c;
386     }
387 
388     /**
389      * @dev Adds two uint32 numbers, throws on overflow.
390      */
391     function safeAdd32(uint32 _a, uint32 _b)
392     internal
393     pure
394     returns (uint32 c) {
395         c = _a + _b;
396         assert(c >= _a);
397         return c;
398     }
399 }