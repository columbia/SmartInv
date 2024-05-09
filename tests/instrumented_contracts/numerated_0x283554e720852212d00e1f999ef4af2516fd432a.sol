1 pragma solidity 0.4.25;
2 
3 
4 /**
5  * @title Safe maths
6  * @author https://theethereum.wiki/w/index.php/ERC20_Token_Standard
7  */
8 library SafeMath {
9     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a, "Bad maths.");
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         require(b <= a, "Bad maths.");
16         c = a - b;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a * b;
21         require(a == 0 || c / a == b, "Bad maths.");
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         require(b > 0, "Bad maths.");
26         c = a / b;
27     }
28 }
29 
30 
31 /**
32  * @title ERC Token Standard #20 Interface
33  * @author https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
34  * @notice This is the basic interface for ERC20 that ensures all required functions exist.
35  * @dev https://theethereum.wiki/w/index.php/ERC20_Token_Standard
36  */
37 contract ERC20Interface {
38     function totalSupply() public constant returns (uint256);
39     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
41     function transfer(address to, uint256 tokens) public returns (bool success);
42     function approve(address spender, uint256 tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint256 tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
47 }
48 
49 
50 /**
51  * @title Contract function to receive approval and execute function in one call
52  * @author https://theethereum.wiki/w/index.php/ERC20_Token_Standard
53  * @dev Borrowed from MiniMeToken
54  */
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 /**
61  * @title Owned Contract
62  * @author https://theethereum.wiki/w/index.php/ERC20_Token_Standard
63  * @notice Gives an inheriting contract the ability for certain functions to be
64  *   called only by the owner of the system.
65  */
66 contract Owned {
67     address internal owner;
68     address internal newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     /**
77      * @notice Modifier indicates that the function can only be called by owner
78      */
79     modifier onlyOwner {
80         require(msg.sender == owner, "Only the owner may execute this function.");
81         _;
82     }
83 
84     /**
85      * @notice Give the ownership to the address _newOwner. Change only takes
86      *  place once the new owner accepts the ownership of this contract.
87      * @param _newOwner The address of the new owner
88      */
89     function transferOwnership(address _newOwner) public onlyOwner {
90         newOwner = _newOwner;
91     }
92 
93     /**
94      * @notice Delete owner information
95      */
96     function disown() public onlyOwner() {
97         delete owner;
98     }
99 
100     /**
101      * @notice The new owner accepts responsibility of contract ownership
102      *  by using this function.
103      */
104     function acceptOwnership() public {
105         require(msg.sender == newOwner, "You have not been selected as the new owner.");
106         emit OwnershipTransferred(owner, newOwner);
107         owner = newOwner;
108         newOwner = address(0);
109     }
110 }
111 
112 
113 
114 
115 
116 /**
117  * @title Snowden Token
118  * @author David Edwards <Telecontrol Unterhaltungselektronik AG>
119  * @notice This contract provides UltraUpload a token with which to
120  *   trade and receive dividends.
121  * @dev Heavily derivative of the ERC20 Token Standard
122     https://theethereum.wiki/w/index.php/ERC20_Token_Standard
123  */
124 contract SnowdenToken is ERC20Interface, Owned {
125     using SafeMath for uint256;
126 
127     string public symbol;
128     string public  name;
129     uint8 public decimals;
130     uint256 internal accountCount = 0;
131     uint256 internal _totalSupply = 0;
132     bool internal readOnly = false;
133     uint256 internal constant MAX_256 = 2**256 - 1;
134     mapping(address => bool) public ignoreDividend;
135 
136     event DividendGivenEvent(uint64 dividendPercentage);
137 
138     mapping(address => uint256) public freezeUntil;
139 
140     mapping(address => address) internal addressLinkedList;
141     mapping(address => uint256) public balances;
142     mapping(address => mapping(address => uint256)) public allowed;
143 
144     /**
145      * @notice The token constructor. Creates the total supply.
146      * @param supply The total number of coins to mint
147      * @param addresses The addresses that will receive initial tokens
148      * @param tokens The number of tokens that each address will receive
149      * @param freezeList The unixepoch timestamp from which addresses are allowed to trade
150      * @param ignoreList Addresses passed into this array will never receive dividends. The ignore list will always include this token contract.
151      *
152      * For example, if addresses is [ "0x1", "0x2" ], then tokens will need to have [ 1000, 8000 ] and freezeList will need to have [ 0, 0 ]. Numbers may change, but the values need to exist.
153      */
154     constructor(uint256 supply, address[] addresses, uint256[] tokens, uint256[] freezeList, address[] ignoreList) public {
155         symbol = "SNOW";
156         name = "Snowden";
157         decimals = 0;
158         _totalSupply = supply; // * 10**uint(decimals);
159         balances[address(0)] = _totalSupply;
160 
161         uint256 totalAddresses = addresses.length;
162         uint256 totalTokens = tokens.length;
163 
164         // Must have positive number of addresses and tokens
165         require(totalAddresses > 0 && totalTokens > 0, "Must be a positive number of addresses and tokens.");
166 
167         // Require same number of addresses as tokens
168         require(totalAddresses == totalTokens, "Must be tokens assigned to all addresses.");
169 
170         uint256 aggregateTokens = 0;
171 
172         for (uint256 i = 0; i < totalAddresses; i++) {
173             // Do not allow empty tokens – although this would have no impact on
174             // the mappings (a 0 count on the mapping will not result in a new entry).
175             // It is better to break here to ensure that there was no input error.
176             require(tokens[i] > 0, "No empty tokens allowed.");
177 
178             aggregateTokens = aggregateTokens + tokens[i];
179 
180             // Supply should always be more than the number of tokens given out!
181             require(aggregateTokens <= supply, "Supply is not enough for demand.");
182 
183             giveReserveTo(addresses[i], tokens[i]);
184             freezeUntil[addresses[i]] = freezeList[i];
185         }
186 
187         ignoreDividend[address(this)] = true;
188         ignoreDividend[msg.sender] = true;
189         for (i = 0; i < ignoreList.length; i++) {
190             ignoreDividend[ignoreList[i]] = true;
191         }
192     }
193 
194     /**
195      * @notice Fallback function reverts all paid ether. Do not accept payments.
196      */
197     function () public payable {
198         revert();
199     }
200 
201     /**
202      * @notice Total supply, including in reserve
203      * @return The number of tokens in circulation
204      */
205     function totalSupply() public constant returns (uint256) {
206         return _totalSupply; // (we use the local address to store the rest) - balances[address(0)];
207     }
208 
209     /**
210      * @notice Return a list of addresses and their tokens
211      * @return Two arrays, the first a list of addresses, the second a list of
212      *   token amounts. Each index matches the other.
213      */
214     function list() public view returns (address[], uint256[]) {
215         address[] memory addrs = new address[](accountCount);
216         uint256[] memory tokens = new uint256[](accountCount);
217 
218         uint256 i = 0;
219         address current = addressLinkedList[0];
220         while (current != 0) {
221             addrs[i] = current;
222             tokens[i] = balances[current];
223 
224             current = addressLinkedList[current];
225             i++;
226         }
227 
228         return (addrs, tokens);
229     }
230 
231     /**
232      * @notice Return the number of tokens not provisioned
233      * @return The total number of tokens left in the reserve pool
234      */
235     function remainingTokens() public view returns(uint256) {
236         return balances[address(0)];
237     }
238 
239     /**
240      * @return Is the contract set to readonly
241      */
242     function isReadOnly() public view returns(bool) {
243         return readOnly;
244     }
245 
246     /**
247      * @notice Get the token balance for account `tokenOwner`
248      * @param tokenOwner Address of the account to get the number of tokens for
249      * @return The number of tokens the address has
250      */
251     function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
252         return balances[tokenOwner];
253     }
254 
255     /**
256      * @notice Ensure that account is allowed to trade
257      * @param from Address of the account to send from
258      * @return True if this trade is allowed
259      */
260     function requireTrade(address from) public view {
261         require(!readOnly, "Read only mode engaged");
262 
263         uint256 i = 0;
264         address current = addressLinkedList[0];
265         while (current != 0) {
266             if(current == from) {
267                 uint256 timestamp = freezeUntil[current];
268                 require(timestamp < block.timestamp, "Trades from your account are temporarily not possible. This is due to ICO rules.");
269 
270                 break;
271             }
272 
273             current = addressLinkedList[current];
274             i++;
275         }
276     }
277 
278     /**
279      * @notice Transfer the balance from token owner's account to `to` account
280      *    - Owner's account must have sufficient balance to transfer
281      *    - 0 value transfers are allowed
282      * @param to Address to transfer tokens to
283      * @param tokens Number of tokens to be transferred
284      */
285     function transfer(address to, uint256 tokens) public returns (bool success) {
286         requireTrade(msg.sender);
287         balances[msg.sender] = balances[msg.sender].sub(tokens);
288         balances[to] = balances[to].add(tokens);
289         emit Transfer(msg.sender, to, tokens);
290 
291         ensureInAccountList(to);
292 
293         return true;
294     }
295 
296     /**
297      * @notice Token owner can approve for `spender` to transferFrom(...) `tokens`
298      *   from the token owner's account
299      * @param spender address of the spender to approve
300      * @param tokens Number of tokens to allow spender to spend
301      * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
302      *   recommends that there are no checks for the approval double-spend attack
303      *   as this should be implemented in user interfaces
304      */
305     function approve(address spender, uint256 tokens) public returns (bool success) {
306         requireTrade(msg.sender);
307         allowed[msg.sender][spender] = tokens;
308         emit Approval(msg.sender, spender, tokens);
309         return true;
310     }
311 
312     /**
313      * @notice Transfer `tokens` from the `from` account to the `to` account
314      * @param from address to transfer tokens from
315      * @param to address to transfer tokens to
316      * @param tokens Number of tokens to transfer
317      * @dev The calling account must already have sufficient tokens approve(...)-d
318      *   for spending from the `from` account and
319      *   - From account must have sufficient balance to transfer
320      *   - Spender must have sufficient allowance to transfer
321      *   - 0 value transfers are allowed
322      */
323     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
324         requireTrade(from);
325         balances[from] = balances[from].sub(tokens);
326         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
327         balances[to] = balances[to].add(tokens);
328         emit Transfer(from, to, tokens);
329 
330         ensureInAccountList(from);
331         ensureInAccountList(to);
332 
333         return true;
334     }
335 
336     /**
337      * @notice Returns the amount of tokens approved by the owner that can be
338      *   transferred to the spender's account
339      * @param tokenOwner The address of the owner of the token
340      * @param spender The address of the spender of the token
341      * @return Number of tokens that are approved for spending from the tokenOwner
342      */
343     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
344         requireTrade(tokenOwner);
345         return allowed[tokenOwner][spender];
346     }
347 
348     /**
349      * @notice Token owner can approve for `spender` to transferFrom(...) `tokens`
350      *   from the token owner's account. The `spender` contract function
351      *   `receiveApproval(...)` is then executed
352      * @param spender address with which to approve
353      * @param tokens The number of tokens that this address is approved to take
354      * @param data Pass data to receiveApproval
355      */
356     function approveAndCall(address spender, uint256 tokens, bytes data) public returns (bool success) {
357         requireTrade(msg.sender);
358         allowed[msg.sender][spender] = tokens;
359         emit Approval(msg.sender, spender, tokens);
360         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
361         return true;
362     }
363 
364     /**
365      * @notice In the event of errors, allow the owner to move tokens from an account
366      * @param addr address to take tokens from
367      * @param tokens The number of tokens to take
368      */
369     function transferAnyERC20Token(address addr, uint256 tokens) public onlyOwner returns (bool success) {
370         requireTrade(addr);
371         return ERC20Interface(addr).transfer(owner, tokens);
372     }
373 
374     /**
375      * @notice Give tokens from the pool to account, creating the account if necessary
376      * @param to The address to deliver the new tokens to
377      * @param tokens The number of tokens to deliver
378      */
379     function giveReserveTo(address to, uint256 tokens) public onlyOwner {
380         require(!readOnly, "Read only mode engaged");
381 
382         balances[address(0)] = balances[address(0)].sub(tokens);
383         balances[to] = balances[to].add(tokens);
384         emit Transfer(address(0), to, tokens);
385 
386         ensureInAccountList(to);
387     }
388 
389     /**
390      * @notice Distribute dividends to all owners
391      * @param percentage Given in the form 1% === 10000. This is not a number of
392      *   tokens, more a form of percentage that does not require decimals. This
393      *   supports 0.00001% (with 1 as the percentage value).
394      * @dev Dividends are rounded down, if a user has too few tokens, they will not receive anything
395      */
396     function giveDividend(uint64 percentage) public onlyOwner {
397         require(!readOnly, "Read only mode engaged");
398 
399         require(percentage > 0, "Percentage must be more than 0 (10000 = 1%)"); // At least 0.00001% dividends
400         require(percentage <= 500000, "Percentage may not be larger than 500000 (50%)"); // No more than 50% dividends
401 
402         emit DividendGivenEvent(percentage);
403 
404         address current = addressLinkedList[0];
405         while (current != 0) {
406             bool found = ignoreDividend[current];
407             if(!found) {
408                 uint256 extraTokens = (balances[current] * percentage) / 1000000;
409                 giveReserveTo(current, extraTokens);
410             }
411             current = addressLinkedList[current];
412         }
413     }
414 
415     /**
416      * @notice Allow admins to (en|dis)able all write functionality for emergencies
417      * @param enabled true to enable read only mode, false to allow writing
418      */
419     function setReadOnly(bool enabled) public onlyOwner {
420         readOnly = enabled;
421     }
422 
423     /**
424      * @notice Add an account to a linked list
425      * @param addr address of the account to add to the linked list
426      * @dev This is necessary to iterate over for listing purposes
427      */
428     function addToAccountList(address addr) internal {
429         require(!readOnly, "Read only mode engaged");
430 
431         addressLinkedList[addr] = addressLinkedList[0x0];
432         addressLinkedList[0x0] = addr;
433         accountCount++;
434     }
435 
436     /**
437      * @notice Remove an account from a linked list
438      * @param addr address of the account to remove from the linked list
439      * @dev This is necessary to iterate over for listing purposes
440      */
441     function removeFromAccountList(address addr) internal {
442         require(!readOnly, "Read only mode engaged");
443 
444         uint16 i = 0;
445         bool found = false;
446         address parent;
447         address current = addressLinkedList[0];
448         while (true) {
449             if (addressLinkedList[current] == addr) {
450                 parent = current;
451                 found = true;
452                 break;
453             }
454             current = addressLinkedList[current];
455 
456             if (i++ > accountCount) break;
457         }
458 
459         require(found, "Account was not found to remove.");
460 
461         addressLinkedList[parent] = addressLinkedList[addressLinkedList[parent]];
462         delete addressLinkedList[addr];
463 
464         if (balances[addr] > 0) {
465             balances[address(0)] += balances[addr];
466         }
467 
468         delete balances[addr];
469 
470         accountCount--;
471     }
472 
473     /**
474      * @notice Make sure that this address exists in our linked list
475      * @param addr address of the account to test
476      * @dev This is necessary to iterate over for listing purposes
477      */
478     function ensureInAccountList(address addr) internal {
479         require(!readOnly, "Read only mode engaged");
480 
481         bool found = false;
482         address current = addressLinkedList[0];
483         while (current != 0) {
484             if (current == addr) {
485                 found = true;
486                 break;
487             }
488             current = addressLinkedList[current];
489         }
490         if (!found) {
491             addToAccountList(addr);
492         }
493     }
494 }