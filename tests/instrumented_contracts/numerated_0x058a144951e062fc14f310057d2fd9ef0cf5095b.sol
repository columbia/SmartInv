1 pragma solidity ^0.5.0;
2 /* Oh wow, it's finally happening /*
3 ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
4 ║           $$$$$$$\            $$\      $$\ $$\   $$\        $$$$$$\  $$$$$$$\        $$$$$$$$\                       ║
5 ║           $$  __$$\           $$ | $\  $$ |$$ |  $$ |      $$ ___$$\ $$  __$$\       $$  _____|                      ║
6 ║           $$ |  $$ | $$$$$$\  $$ |$$$\ $$ |$$ |  $$ |      \_/   $$ |$$ |  $$ |      $$ |      $$\   $$\             ║
7 ║           $$$$$$$  |$$  __$$\ $$ $$ $$\$$ |$$$$$$$$ |        $$$$$ / $$ |  $$ |      $$$$$\    \$$\ $$  |            ║
8 ║           $$  ____/ $$ /  $$ |$$$$  _$$$$ |$$  __$$ |        \___$$\ $$ |  $$ |      $$  __|    \$$$$  /             ║
9 ║           $$ |      $$ |  $$ |$$$  / \$$$ |$$ |  $$ |      $$\   $$ |$$ |  $$ |      $$ |       $$  $$<              ║
10 ║           $$ |      \$$$$$$  |$$  /   \$$ |$$ |  $$ |      \$$$$$$  |$$$$$$$  |      $$$$$$$$\ $$  /\$$\             ║
11 ║           \__|       \______/ \__/     \__|\__|  \__|       \______/ \_______/       \________|\__/  \__|            ║
12 ║                                                                                                                      ║
13 ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
14 ║           _____                  __          __  __          __        _      _    _                 _               ║
15 ║          |  __ \                / _|        / _| \ \        / /       | |    | |  | |               | |              ║
16 ║          | |__) | __ ___   ___ | |_    ___ | |_   \ \  /\  / /__  __ _| | __ | |__| | __ _ _ __   __| |___           ║
17 ║          |  ___/ '__/ _ \ / _ \|  _|  / _ \|  _|   \ \/  \/ / _ \/ _` | |/ / |  __  |/ _` | '_ \ / _` / __|          ║
18 ║          | |   | | | (_) | (_) | |   | (_) | |      \  /\  /  __/ (_| |   <  | |  | | (_| | | | | (_| \__ \          ║
19 ║          |_|   |_|  \___/ \___/|_|    \___/|_|       \/  \/ \___|\__,_|_|\_\ |_|  |_|\__,_|_| |_|\__,_|___/          ║
20 ║                       ____  _____        ________   _________ ______ _   _ _____  ______ _____                       ║
21 ║                      |___ \|  __ \   _  |  ____\ \ / /__   __|  ____| \ | |  __ \|  ____|  __ \                      ║
22 ║                        __) | |  | | (_) | |__   \ V /   | |  | |__  |  \| | |  | | |__  | |  | |                     ║
23 ║                       |__ <| |  | |     |  __|   > <    | |  |  __| | . ` | |  | |  __| | |  | |                     ║
24 ║                       ___) | |__| |  _  | |____ / . \   | |  | |____| |\  | |__| | |____| |__| |                     ║
25 ║                      |____/|_____/  (_) |______/_/ \_\  |_|  |______|_| \_|_____/|______|_____/                      ║
26 ║                                             ╔══════════════════════════╗                                             ║
27 ╚═════════════════════════════════════════════╣ Created by ARitz Cracker ╠═════════════════════════════════════════════╝
28 											  ╚══════════════════════════╝
29 
30 In a world, where  people wanted more 3rd party dApp integration with P3D, a small "Jack of all trades" developer,
31 ARitz Cracker set out to create an addon-token for P3D that would add the functionality required for 3rd party dApp
32 integration. However, while creating this, he had another calling... Replacing web3js and Metamask a grand feat, for
33 sure. Unfortunately, this left the extension token aside. One man took advantage of this functionality-vacuum and
34 created his own extension, but it was forged by greed... and would force its users to pay additional fees and taxes to
35 the creator and anyone he saw fit. ARitz Cracker saw this as a sign... "People need community focused dApp extensions
36 now!" And so, he set out to have it completed, audited, and ready for the community as soon as possible... In order to
37 prevent the greedy ones from taking power away from the community.
38 
39 Thus, P3X was born.
40 
41 So, what does this thing actually do?
42 * P3X is a utility token tethered to P3D.
43 * The total P3X supply will always be equal to the amount of P3D bought by this contract.
44 * P3X Price will always be equal to P3D price
45 * Dividends per P3X token is the same as P3D
46 * Functionally identical to P3D Exept:
47 *   0% token fees on transfers
48 *   Full ERC20 and ERC223 functionality, allowing for external dApps to _actually_ receive funds and interact with the contract.
49 *   Optional gauntlets which prevent you from selling (literally!)
50 *   For more information, please visit the wiki page: https://powh3d.hostedwiki.co/pages/What%20is%20P3X
51 
52 Also, this is my f̶i̶r̶s̶t̶ second contract on main-net please be gentle :S
53 */
54 
55 // Interfaces for easy copypasta
56 
57 interface ERC20interface {
58 	function transfer(address to, uint value) external returns(bool success);
59 	function approve(address spender, uint tokens) external returns(bool success);
60 	function transferFrom(address from, address to, uint tokens) external returns(bool success);
61 
62 	function allowance(address tokenOwner, address spender) external view returns(uint remaining);
63 	function balanceOf(address tokenOwner) external view returns(uint balance);
64 }
65 
66 interface ERC223interface {
67 	function transfer(address to, uint value) external returns(bool ok);
68 	function transfer(address to, uint value, bytes calldata data) external returns(bool ok);
69 	function transfer(address to, uint value, bytes calldata data, string calldata customFallback) external returns(bool ok);
70 
71 	function balanceOf(address who) external view returns(uint);
72 }
73 
74 // If your contract wants to accept P3X, implement this function
75 interface ERC223Handler {
76 	function tokenFallback(address _from, uint _value, bytes calldata _data) external;
77 }
78 
79 // External gauntlet interfaces can be useful for something like voting systems or contests
80 interface ExternalGauntletInterface {
81 	function gauntletRequirement(address wearer, uint256 oldAmount, uint256 newAmount) external returns(bool);
82 	function gauntletRemovable(address wearer) external view returns(bool);
83 }
84 
85 // This is P3D itself (not a cimplete interface)
86 interface Hourglass {
87 	function decimals() external view returns(uint8);
88 	function stakingRequirement() external view returns(uint256);
89 	function balanceOf(address tokenOwner) external view returns(uint);
90 	function dividendsOf(address tokenOwner) external view returns(uint);
91 	function calculateTokensReceived(uint256 _ethereumToSpend) external view returns(uint256);
92 	function calculateEthereumReceived(uint256 _tokensToSell) external view returns(uint256);
93 	function myTokens() external view returns(uint256);
94 	function myDividends(bool _includeReferralBonus) external view returns(uint256);
95 	function totalSupply() external view returns(uint256);
96 
97 	function transfer(address to, uint value) external returns(bool);
98 	function buy(address referrer) external payable returns(uint256);
99 	function sell(uint256 amount) external;
100 	function withdraw() external;
101 }
102 
103 // This a name database used in Fomo3D (Also not a complete interface)
104 interface TeamJustPlayerBook {
105 	function pIDxName_(bytes32 name) external view returns(uint256);
106 	function pIDxAddr_(address addr) external view returns(uint256);
107 	function getPlayerAddr(uint256 pID) external view returns(address);
108 }
109 
110 // Here's an interface in case you want to integration your dApp with this.
111 // Descriptions of each function are down below in the soure code.
112 // NOTE: It's not _entirely_ compatible with the P3D interface. myTokens() has been renamed to myBalance().
113 /*
114 interface HourglassX {
115 	function buy(address referrerAddress) payable external returns(uint256 tokensReceieved);
116 	function buy(string calldata referrerName) payable external returns(uint256 tokensReceieved);
117 	function reinvest() external returns(uint256 tokensReceieved);
118 	function reinvestPartial(uint256 ethToReinvest) external returns(uint256 tokensReceieved);
119 	function reinvestPartial(uint256 ethToReinvest, bool withdrawAfter) external returns(uint256 tokensReceieved);
120 	function sell(uint256 amount, bool withdrawAfter) external returns(uint256 ethReceieved);
121 	function sell(uint256 amount) external returns(uint256 ethReceieved); // Alias of sell(amount, false)
122 	function withdraw() external;
123 	function exit() external;
124 	function acquireGauntlet(uint256 amount, uint8 gType, uint256 end) external;
125 	function acquireExternalGauntlet(uint256 amount, address extGauntlet) external;
126 	function setReferrer(address referrer) external;
127 	function setReferrer(string calldata referrerName) external;
128 
129 	function myBalance() external view returns(uint256 balance);
130 	function dividendsOf(address accountHolder, bool includeReferralBonus) external view returns(uint256 divs);
131 	function dividendsOf(address accountHolder) external view returns(uint256 divs); // Alias of dividendsOf(accountHolder, true)
132 	function myDividends(bool includeReferralBonus) external view returns(uint256 divs);
133 	function myDividends() external view returns(uint256 divs); // Alias of myDividends(true);
134 
135 	function usableBalanceOf(address accountHolder) external view returns(uint256 balance);
136 	function myUsableBalance() external view returns(uint256 balance);
137 	function refBonusOf(address customerAddress) external view returns(uint256);
138 	function myRefBonus() external view returns(uint256);
139 	function gauntletTypeOf(address accountHolder) external view returns(uint256 stakeAmount, uint256 gType, uint256 end);
140 	function myGauntletType() external view returns(uint256 stakeAmount, uint256 gType, uint256 end);
141 	function stakingRequirement() external view returns(uint256);
142 	function savedReferral(address accountHolder) external view returns(address);
143 
144 	// ERC 20/223
145 	function balanceOf(address tokenOwner) external view returns(uint balance);
146 	function transfer(address to, uint value) external returns(bool ok);
147 	function transfer(address to, uint value, bytes data) external returns(bool ok);
148 	function transfer(address to, uint value, bytes data, string customFallback) external returns(bool ok);
149 	function allowance(address tokenOwner, address spender) external view returns(uint remaining);
150 	function approve(address spender, uint tokens) external returns(bool success);
151 	function transferFrom(address from, address to, uint tokens) external returns(bool success);
152 
153 	// Events (cannot be in interfaces used here as a reference)
154 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
155 	event Transfer(address indexed from, address indexed to, uint value);
156 	event Transfer(address indexed from, address indexed to, uint value, bytes data);
157 	event onTokenPurchase(
158 		address indexed accountHolder,
159 		uint256 ethereumSpent,
160 		uint256 tokensCreated,
161 		uint256 tokensGiven,
162 		address indexed referrer,
163 		uint8 bitFlags // 1 = invalidMasternode, 2 = usedHourglassMasternode, 4 = reinvestment
164 	);
165 	event onTokenSell(
166 		address indexed accountHolder,
167 		uint256 tokensDestroyed,
168 		uint256 ethereumEarned
169 	);
170 	event onWithdraw(
171 		address indexed accountHolder,
172 		uint256 earningsWithdrawn,
173 		uint256 refBonusWithdrawn,
174 		bool reinvestment
175 	);
176 	event onDonatedDividends(
177 		address indexed donator,
178 		uint256 ethereumDonated
179 	);
180 	event onGauntletAcquired(
181 		address indexed strongHands,
182 		uint256 stakeAmount,
183 		uint8 gauntletType,
184 		uint256 end
185 	);
186 	event onExternalGauntletAcquired(
187 		address indexed strongHands,
188 		uint256 stakeAmount,
189 		address indexed extGauntlet
190 	);
191 	// Gauntlet events will be emitted with stakeAmount == 0 when the gauntlets expire.
192 }
193 */
194 
195 // This contract is intended to only be used by HourglassX. Think of this as HourglassX's second account (or child slave with its own account)
196 
197 contract HourglassXReferralHandler {
198 	using SafeMath for uint256;
199 	using SafeMath for uint;
200 	address internal parent;
201 	Hourglass internal hourglass;
202 
203 	constructor(Hourglass h) public {
204 		hourglass = h;
205 		parent = msg.sender;
206 	}
207 
208 	// Don't expose this account to literally everyone
209 	modifier onlyParent {
210 		require(msg.sender == parent, "Can only be executed by parent process");
211 		_;
212 	}
213 
214 	// Contract's total ETH balance including divs
215 	function totalBalance() public view returns(uint256) {
216 		return address(this).balance + hourglass.myDividends(true);
217 	}
218 
219 	// Buy P3D from given ether
220 	function buyTokens(address referrer) public payable onlyParent {
221 		hourglass.buy.value(msg.value)(referrer);
222 	}
223 
224 	// Buy P3D from own ether balance
225 	function buyTokensFromBalance(address referrer, uint256 amount) public onlyParent {
226 		if (address(this).balance < amount) {
227 			hourglass.withdraw();
228 		}
229 		hourglass.buy.value(amount)(referrer);
230 	}
231 
232 	// Sell a specified amount of P3D for ether
233 	function sellTokens(uint256 amount) public onlyParent {
234 		if (amount > 0) {
235 			hourglass.sell(amount);
236 		}
237 	}
238 
239 	// Withdraw outstanding divs to internal balance
240 	function withdrawDivs() public onlyParent {
241 		hourglass.withdraw();
242 	}
243 
244 	// Send eth from internal balance to a specified account
245 	function sendETH(address payable to, uint256 amount) public onlyParent {
246 		if (address(this).balance < amount) {
247 			hourglass.withdraw();
248 		}
249 		to.transfer(amount);
250 	}
251 
252 	// Only allow ETH from our master or from the hourglass.
253 	function() payable external {
254 		require(msg.sender == address(hourglass) || msg.sender == parent, "No, I don't accept donations");
255 	}
256 
257 	// Reject possible accidental sendin of higher-tech shitcoins.
258 	function tokenFallback(address from, uint value, bytes memory data) public pure {
259 		revert("I don't want your shitcoins!");
260 	}
261 
262 	// Allow anyone else to take forcefully sent low-tech shitcoins. (I sure as hell don't want them)
263 	function takeShitcoin(address shitCoin) public {
264 		require(shitCoin != address(hourglass), "P3D isn't a shitcoin");
265 		ERC20interface s = ERC20interface(shitCoin);
266 		s.transfer(msg.sender, s.balanceOf(address(this)));
267 	}
268 }
269 
270 contract HourglassX {
271 	using SafeMath for uint256;
272 	using SafeMath for uint;
273 	using SafeMath for int256;
274 
275 	modifier onlyOwner {
276 		require(msg.sender == owner);
277 		_;
278 	}
279 
280 	modifier playerBookEnabled {
281 		require(address(playerBook) != NULL_ADDRESS, "named referrals not enabled");
282 		_;
283 	}
284 
285 	// Make the thing
286 	constructor(address h, address p) public {
287 		// Set up ERC20 values
288 		name = "PoWH3D Extended";
289 		symbol = "P3X";
290 		decimals = 18;
291 		totalSupply = 0;
292 
293 		// Add external contracts
294 		hourglass = Hourglass(h);
295 		playerBook = TeamJustPlayerBook(p);
296 
297 		// Set referral requirement to be the same as P3D by default.
298 		referralRequirement = hourglass.stakingRequirement();
299 
300 		// Yes I could deploy 2 contracts myself, but I'm lazy. :^)
301 		refHandler = new HourglassXReferralHandler(hourglass);
302 
303 		// Internal stuffs
304 		ignoreTokenFallbackEnable = false;
305 		owner = msg.sender;
306 	}
307 	// HourglassX-specific data
308 	address owner;
309 	address newOwner;
310 
311 	uint256 referralRequirement;
312 	uint256 internal profitPerShare = 0;
313 	uint256 public lastTotalBalance = 0;
314 	uint256 constant internal ROUNDING_MAGNITUDE = 2**64;
315 	address constant internal NULL_ADDRESS = 0x0000000000000000000000000000000000000000;
316 
317 	// I would get this from hourglass, but these values are inaccessable to the public.
318 	uint8 constant internal HOURGLASS_FEE = 10;
319 	uint8 constant internal HOURGLASS_BONUS = 3;
320 
321 	// External contracts
322 	Hourglass internal hourglass;
323 	HourglassXReferralHandler internal refHandler;
324 	TeamJustPlayerBook internal playerBook;
325 
326 	// P3X Specific data
327 	mapping(address => int256) internal payouts;
328 	mapping(address => uint256) internal bonuses;
329 	mapping(address => address) public savedReferral;
330 
331 	// Futureproofing stuffs
332 	mapping(address => mapping (address => bool)) internal ignoreTokenFallbackList;
333 	bool internal ignoreTokenFallbackEnable;
334 
335 	// Gauntlets
336 	mapping(address => uint256) internal gauntletBalance;
337 	mapping(address => uint256) internal gauntletEnd;
338 	mapping(address => uint8) internal gauntletType; // 1 = Time, 2 = P3D Supply, 3 = External
339 
340 	// Normal token data
341 	mapping(address => uint256) internal balances;
342 	mapping(address => mapping (address => uint256)) internal allowances;
343 	string public name;
344 	string public symbol;
345 	uint8 public decimals;
346 	uint256 public totalSupply;
347 
348 	// --Events
349 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
350 	event Transfer(address indexed from, address indexed to, uint value);
351 	event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
352 	// Q: Why do you have 2 transfer events?
353 	// A: Because keccak256("Transfer(address,address,uint256)") != keccak256("Transfer(address,address,uint256,bytes)")
354 	//    and etherscan listens for the former.
355 
356 
357 	event onTokenPurchase(
358 		address indexed accountHolder,
359 		uint256 ethereumSpent,
360 		uint256 tokensCreated,
361 		// If P3D is given to the contract, that amount in P3X will be given to the next buyer since we have no idea who gave us the P3D.
362 		uint256 tokensGiven,
363 		address indexed referrer,
364 		uint8 indexed bitFlags // 1 = invalidMasternode, 2 = usedHourglassMasternode, 4 = reinvestment
365 	);
366 	event onTokenSell(
367 		address indexed accountHolder,
368 		uint256 tokensDestroyed,
369 		uint256 ethereumEarned
370 	);
371 	event onWithdraw(
372 		address indexed accountHolder,
373 		uint256 earningsWithdrawn,
374 		uint256 refBonusWithdrawn,
375 		bool indexed reinvestment
376 	);
377 	event onDonatedDividends(
378 		address indexed donator,
379 		uint256 ethereumDonated
380 	);
381 	event onGauntletAcquired(
382 		address indexed strongHands,
383 		uint256 stakeAmount,
384 		uint8 indexed gauntletType,
385 		uint256 end
386 	);
387 	event onExternalGauntletAcquired(
388 		address indexed strongHands,
389 		uint256 stakeAmount,
390 		address indexed extGauntlet
391 	);
392 	// --Events--
393 
394 	// --Owner only functions
395 	function setNewOwner(address o) public onlyOwner {
396 		newOwner = o;
397 	}
398 
399 	function acceptNewOwner() public {
400 		require(msg.sender == newOwner);
401 		owner = msg.sender;
402 	}
403 
404 	// P3D allows re-branding, makes sense if P3X allows it too.
405 	function rebrand(string memory n, string memory s) public onlyOwner {
406 		name = n;
407 		symbol = s;
408 	}
409 
410 	// P3X selling point: _lower staking requirement than P3D!!_
411 	function setReferralRequirement(uint256 r) public onlyOwner {
412 		referralRequirement = r;
413 	}
414 
415 	// Enables the function defined below.
416 	function allowIgnoreTokenFallback() public onlyOwner {
417 		ignoreTokenFallbackEnable = true;
418 	}
419 	// --Owner only functions--
420 
421 	// --Public write functions
422 
423 	// Ethereum _might_ implement something where every address, including ones controlled by humans, is a smart contract.
424 	// Obviously transfering P3X to other people with no fee is one of its selling points.
425 	// A somewhat future-proofing fix is for the sender to specify that their recipiant is human if such a change ever takes place.
426 	// However, due to the popularity of ERC223, this might not be necessary.
427 	function ignoreTokenFallback(address to, bool ignore) public {
428 		require(ignoreTokenFallbackEnable, "This function is disabled");
429 		ignoreTokenFallbackList[msg.sender][to] = ignore;
430 	}
431 
432 	// Transfer tokens to the specified address, call the specified function, and pass the specified data
433 	function transfer(address payable to, uint value, bytes memory data, string memory func) public returns(bool) {
434 		actualTransfer(msg.sender, to, value, data, func, true);
435 		return true;
436 	}
437 
438 	// Transfer tokens to the specified address, call tokenFallback, and pass the specified data
439 	function transfer(address payable to, uint value, bytes memory data) public returns(bool) {
440 		actualTransfer(msg.sender, to, value, data, "", true);
441 		return true;
442 	}
443 
444 	// Transfer tokens to the specified address, call tokenFallback if applicable
445 	function transfer(address payable to, uint value) public returns(bool) {
446 		actualTransfer(msg.sender, to, value, "", "", !ignoreTokenFallbackList[msg.sender][to]);
447 		return true;
448 	}
449 
450 	// Allow someone else to spend your tokens
451 	function approve(address spender, uint value) public returns(bool) {
452 		require(updateUsableBalanceOf(msg.sender) >= value, "Insufficient balance to approve");
453 		allowances[msg.sender][spender] = value;
454 		emit Approval(msg.sender, spender, value);
455 		return true;
456 	}
457 
458 	// Have that someone else spend your tokens
459 	function transferFrom(address payable from, address payable to, uint value) public returns(bool success) {
460 		uint256 allowance = allowances[from][msg.sender];
461 		require(allowance > 0, "Not approved");
462 		require(allowance >= value, "Over spending limit");
463 		allowances[from][msg.sender] = allowance.sub(value);
464 		actualTransfer(from, to, value, "", "", false);
465 		return true;
466 	}
467 
468 	// The fallback function
469 	function() payable external{
470 		// Only accept free ETH from the hourglass and from our child slave.
471 		if (msg.sender != address(hourglass) && msg.sender != address(refHandler)) {
472 			// Now, sending ETH increases the balance _before_ the transaction has been fully processed.
473 			// We don't want to distribute the entire purchase order as dividends.
474 			if (msg.value > 0) {
475 				lastTotalBalance += msg.value;
476 				distributeDividends(0, NULL_ADDRESS);
477 				lastTotalBalance -= msg.value;
478 			}
479 			createTokens(msg.sender, msg.value, NULL_ADDRESS, false);
480 		}
481 	}
482 
483 	// Worried about having weak hands? Put on an optional gauntlet.
484 	// Prevents you from selling or transfering a specified amount of tokens
485 	function acquireGauntlet(uint256 amount, uint8 gType, uint256 end) public{
486 		require(amount <= balances[msg.sender], "Insufficient balance");
487 
488 		// We need to apply the data first in order to prevent re-entry attacks.
489 		// ExternalGauntletInterface.gauntletRequirement _is_ a function which can change the state, after all.
490 		uint256 oldGauntletType = gauntletType[msg.sender];
491 		uint256 oldGauntletBalance = gauntletBalance[msg.sender];
492 		uint256 oldGauntletEnd = gauntletEnd[msg.sender];
493 
494 		gauntletType[msg.sender] = gType;
495 		gauntletEnd[msg.sender] = end;
496 		gauntletBalance[msg.sender] = amount;
497 
498 		if (oldGauntletType == 0) {
499 			if (gType == 1) {
500 				require(end >= (block.timestamp + 97200), "Gauntlet time must be >= 4 weeks"); //97200 seconds = 3 weeks and 6 days.
501 				emit onGauntletAcquired(msg.sender, amount, gType, end);
502 			} else if (gType == 2) {
503 				uint256 P3DSupply = hourglass.totalSupply();
504 				require(end >= (P3DSupply + (P3DSupply / 5)), "Gauntlet must make a profit"); // P3D buyers are down 19% when they buy, so make gauntlet gainz a minimum of 20%.
505 				emit onGauntletAcquired(msg.sender, amount, gType, end);
506 			} else if (gType == 3) {
507 				require(end <= 0x00ffffffffffffffffffffffffffffffffffffffff, "Invalid address");
508 				require(ExternalGauntletInterface(address(end)).gauntletRequirement(msg.sender, 0, amount), "External gauntlet check failed");
509 				emit onExternalGauntletAcquired(msg.sender, amount, address(end));
510 			} else {
511 				revert("Invalid gauntlet type");
512 			}
513 		} else if (oldGauntletType == 3) {
514 			require(gType == 3, "New gauntlet must be same type");
515 			require(end == gauntletEnd[msg.sender], "Must be same external gauntlet");
516 			require(ExternalGauntletInterface(address(end)).gauntletRequirement(msg.sender, oldGauntletBalance, amount), "External gauntlet check failed");
517 			emit onExternalGauntletAcquired(msg.sender, amount, address(end));
518 		} else {
519 			require(gType == oldGauntletType, "New gauntlet must be same type");
520 			require(end > oldGauntletEnd, "Gauntlet must be an upgrade");
521 			require(amount >= oldGauntletBalance, "New gauntlet must hold more tokens");
522 			emit onGauntletAcquired(msg.sender, amount, gType, end);
523 		}
524 	}
525 
526 	function acquireExternalGauntlet(uint256 amount, address extGauntlet) public{
527 		acquireGauntlet(amount, 3, uint256(extGauntlet));
528 	}
529 
530 	// Throw your money at this thing with a referrer specified by their Ethereum address.
531 	// Returns the amount of tokens created.
532 	function buy(address referrerAddress) payable public returns(uint256) {
533 		// Now, sending ETH increases the balance _before_ the transaction has been fully processed.
534 		// We don't want to distribute the entire purchase order as dividends.
535 		if (msg.value > 0) {
536 			lastTotalBalance += msg.value;
537 			distributeDividends(0, NULL_ADDRESS);
538 			lastTotalBalance -= msg.value;
539 		}
540 		return createTokens(msg.sender, msg.value, referrerAddress, false);
541 	}
542 
543 	// I'm only copy/pasting these functions due to the stack limit.
544 	// Throw your money at this thing with a referrer specified by their team JUST playerbook name.
545 	// Returns the amount of tokens created.
546 	function buy(string memory referrerName) payable public playerBookEnabled returns(uint256) {
547 		address referrerAddress = getAddressFromReferralName(referrerName);
548 		// As I said before, we don't want to distribute the entire purchase order as dividends.
549 		if (msg.value > 0) {
550 			lastTotalBalance += msg.value;
551 			distributeDividends(0, NULL_ADDRESS);
552 			lastTotalBalance -= msg.value;
553 		}
554 		return createTokens(msg.sender, msg.value, referrerAddress, false);
555 	}
556 
557 	// Use all the ETH you earned hodling P3X to buy more P3X.
558 	// Returns the amount of tokens created.
559 	function reinvest() public returns(uint256) {
560 		address accountHolder = msg.sender;
561 		distributeDividends(0, NULL_ADDRESS); // Just in case P3D-only transactions happened.
562 		uint256 payout;
563 		uint256 bonusPayout;
564 		(payout, bonusPayout) = clearDividends(accountHolder);
565 		emit onWithdraw(accountHolder, payout, bonusPayout, true);
566 		return createTokens(accountHolder, payout + bonusPayout, NULL_ADDRESS, true);
567 	}
568 
569 	// Use some of the ETH you earned hodling P3X to buy more P3X.
570 	// You can withdraw the rest or keept it in here allocated for you.
571 	// Returns the amount of tokens created.
572 	function reinvestPartial(uint256 ethToReinvest, bool withdrawAfter) public returns(uint256 tokensCreated) {
573 		address payable accountHolder = msg.sender;
574 		distributeDividends(0, NULL_ADDRESS); // Just in case P3D-only transactions happened.
575 
576 		uint256 payout = dividendsOf(accountHolder, false);
577 		uint256 bonusPayout = bonuses[accountHolder];
578 
579 		uint256 payoutReinvested = 0;
580 		uint256 bonusReinvested;
581 
582 		require((payout + bonusPayout) >= ethToReinvest, "Insufficient balance for reinvestment");
583 		// We're going to take ETH out of the masternode bonus first, then the outstanding divs.
584 		if (ethToReinvest > bonusPayout){
585 			payoutReinvested = ethToReinvest - bonusPayout;
586 			bonusReinvested = bonusPayout;
587 			// Take ETH out from outstanding dividends.
588 			payouts[accountHolder] += int256(payoutReinvested * ROUNDING_MAGNITUDE);
589 		}else{
590 			bonusReinvested = ethToReinvest;
591 		}
592 		// Take ETH from the masternode bonus.
593 		bonuses[accountHolder] -= bonusReinvested;
594 
595 		emit onWithdraw(accountHolder, payoutReinvested, bonusReinvested, true);
596 		// Do the buy thing!
597 		tokensCreated = createTokens(accountHolder, ethToReinvest, NULL_ADDRESS, true);
598 
599 		if (withdrawAfter && dividendsOf(msg.sender, true) > 0) {
600 			withdrawDividends(msg.sender);
601 		}
602 		return tokensCreated;
603 	}
604 
605 	// I'm just a man who loves "default variables"
606 	function reinvestPartial(uint256 ethToReinvest) public returns(uint256) {
607 		return reinvestPartial(ethToReinvest, true);
608 	}
609 
610 	// There's literally no reason to call this function
611 	function sell(uint256 amount, bool withdrawAfter) public returns(uint256) {
612 		require(amount > 0, "You have to sell something");
613 		uint256 sellAmount = destroyTokens(msg.sender, amount);
614 		if (withdrawAfter && dividendsOf(msg.sender, true) > 0) {
615 			withdrawDividends(msg.sender);
616 		}
617 		return sellAmount;
618 	}
619 
620 	// Again with the default variables!
621 	function sell(uint256 amount) public returns(uint256) {
622 		require(amount > 0, "You have to sell something");
623 		return destroyTokens(msg.sender, amount);
624 	}
625 
626 	// Transfer the sender's masternode bonuses and their outstanding divs to their wallet.
627 	function withdraw() public{
628 		require(dividendsOf(msg.sender, true) > 0, "No dividends to withdraw");
629 		withdrawDividends(msg.sender);
630 	}
631 
632 	// There's definitely no reason to call this function
633 	function exit() public{
634 		address payable accountHolder = msg.sender;
635 		uint256 balance = balances[accountHolder];
636 		if (balance > 0) {
637 			destroyTokens(accountHolder, balance);
638 		}
639 		if (dividendsOf(accountHolder, true) > 0) {
640 			withdrawDividends(accountHolder);
641 		}
642 	}
643 
644 	// Since website won't be released on launch, provide something on etherscan which will allow users to easily set masternodes.
645 	function setReferrer(address ref) public{
646 		savedReferral[msg.sender] = ref;
647 	}
648 
649 	// Same as above except using the team JUST player book
650 	function setReferrer(string memory refName) public{
651 		savedReferral[msg.sender] = getAddressFromReferralName(refName);
652 	}
653 
654 	// Another P3X selling point: Get P3X-exclusive didvidends _combined with_ P3D dividends!
655 	function donateDividends() payable public{
656 		distributeDividends(0, NULL_ADDRESS);
657 		emit onDonatedDividends(msg.sender, msg.value);
658 	}
659 
660 	// --Public write functions--
661 
662 	// --Public read-only functions
663 
664 	// Returns the P3D address.
665 	function baseHourglass() external view returns(address) {
666 		return address(hourglass);
667 	}
668 
669 	// Returns the salve account address (was mostly used for debugging purposes)
670 	function refHandlerAddress() external view returns(address) {
671 		return address(refHandler);
672 	}
673 
674 	// Get someone's address from their team JUST playerbook name
675 	function getAddressFromReferralName(string memory refName) public view returns (address){
676 		return playerBook.getPlayerAddr(playerBook.pIDxName_(stringToBytes32(refName)));
677 	}
678 
679 	// Retruns an addresses gauntlet type.
680 	function gauntletTypeOf(address accountHolder) public view returns(uint stakeAmount, uint gType, uint end) {
681 		if (isGauntletExpired(accountHolder)) {
682 			return (0, 0, gauntletEnd[accountHolder]);
683 		} else {
684 			return (gauntletBalance[accountHolder], gauntletType[accountHolder], gauntletEnd[accountHolder]);
685 		}
686 	}
687 
688 	// Same as above except for msg.sender
689 	function myGauntletType() public view returns(uint stakeAmount, uint gType, uint end) {
690 		return gauntletTypeOf(msg.sender);
691 	}
692 
693 	// Returns an addresse's P3X balance minus what they have in their gauntlet.
694 	function usableBalanceOf(address accountHolder) public view returns(uint balance) {
695 		if (isGauntletExpired(accountHolder)) {
696 			return balances[accountHolder];
697 		} else {
698 			return balances[accountHolder].sub(gauntletBalance[accountHolder]);
699 		}
700 	}
701 
702 	// Same as above except for msg.sender
703 	function myUsableBalance() public view returns(uint balance) {
704 		return usableBalanceOf(msg.sender);
705 	}
706 
707 	// I mean, every ERC20 token has this function. I'm sure you know what it does.
708 	function balanceOf(address accountHolder) external view returns(uint balance) {
709 		return balances[accountHolder];
710 	}
711 
712 	// Same as above except for msg.sender
713 	function myBalance() public view returns(uint256) {
714 		return balances[msg.sender];
715 	}
716 
717 	// See if the specified sugardaddy allows the spender to spend their tokens
718 	function allowance(address sugardaddy, address spender) external view returns(uint remaining) {
719 		return allowances[sugardaddy][spender];
720 	}
721 
722 	// Returns all the ETH that this contract has access to
723 	function totalBalance() public view returns(uint256) {
724 		return address(this).balance + hourglass.myDividends(true) + refHandler.totalBalance();
725 	}
726 
727 	// Returns the ETH the specified address is owed.
728 	function dividendsOf(address customerAddress, bool includeReferralBonus) public view returns(uint256) {
729 		uint256 divs = uint256(int256(profitPerShare * balances[customerAddress]) - payouts[customerAddress]) / ROUNDING_MAGNITUDE;
730 		if (includeReferralBonus) {
731 			divs += bonuses[customerAddress];
732 		}
733 		return divs;
734 	}
735 
736 	// Same as above except includes the masternode bonus
737 	function dividendsOf(address customerAddress) public view returns(uint256) {
738 		return dividendsOf(customerAddress, true);
739 	}
740 
741 	// Alias of dividendsOf(msg.sender)
742 	function myDividends() public view returns(uint256) {
743 		return dividendsOf(msg.sender, true);
744 	}
745 
746 	// Alias of dividendsOf(msg.sender, includeReferralBonus)
747 	function myDividends(bool includeReferralBonus) public view returns(uint256) {
748 		return dividendsOf(msg.sender, includeReferralBonus);
749 	}
750 
751 	// Returns the masternode earnings of a specified account
752 	function refBonusOf(address customerAddress) external view returns(uint256) {
753 		return bonuses[customerAddress];
754 	}
755 
756 	// Same as above xcept with msg.sender
757 	function myRefBonus() external view returns(uint256) {
758 		return bonuses[msg.sender];
759 	}
760 
761 	// Backwards compatibility with the P3D interface
762 	function stakingRequirement() external view returns(uint256) {
763 		return referralRequirement;
764 	}
765 
766 	// Backwards compatibility with the P3D interface
767 	function calculateTokensReceived(uint256 ethereumToSpend) public view returns(uint256) {
768 		return hourglass.calculateTokensReceived(ethereumToSpend);
769 	}
770 
771 	// Backwards compatibility with the P3D interface
772 	function calculateEthereumReceived(uint256 tokensToSell) public view returns(uint256) {
773 		return hourglass.calculateEthereumReceived(tokensToSell);
774 	}
775 	// --Public read-only functions--
776 
777 	// Internal functions
778 
779 	// Returns true if the gauntlet has expired. Otherwise, false.
780 	function isGauntletExpired(address holder) internal view returns(bool) {
781 		if (gauntletType[holder] != 0) {
782 			if (gauntletType[holder] == 1) {
783 				return (block.timestamp >= gauntletEnd[holder]);
784 			} else if (gauntletType[holder] == 2) {
785 				return (hourglass.totalSupply() >= gauntletEnd[holder]);
786 			} else if (gauntletType[holder] == 3) {
787 				return ExternalGauntletInterface(gauntletEnd[holder]).gauntletRemovable(holder);
788 			}
789 		}
790 		return false;
791 	}
792 
793 	// Same as usableBalanceOf, except the gauntlet is lifted when it's expired.
794 	function updateUsableBalanceOf(address holder) internal returns(uint256) {
795 		// isGauntletExpired is a _view_ function, with uses STATICCALL in solidity 0.5.0 or later.
796 		// Since STATICCALLs can't modifiy the state, re-entry attacks aren't possible here.
797 		if (isGauntletExpired(holder)) {
798 			if (gauntletType[holder] == 3){
799 				emit onExternalGauntletAcquired(holder, 0, NULL_ADDRESS);
800 			}else{
801 				emit onGauntletAcquired(holder, 0, 0, 0);
802 			}
803 			gauntletType[holder] = 0;
804 			gauntletBalance[holder] = 0;
805 
806 			return balances[holder];
807 		}
808 		return balances[holder] - gauntletBalance[holder];
809 	}
810 
811 	// This is the actual buy function
812 	function createTokens(address creator, uint256 eth, address referrer, bool reinvestment) internal returns(uint256) {
813 		// Let's not call the parent hourglass all the time.
814 		uint256 parentReferralRequirement = hourglass.stakingRequirement();
815 		// How much ETH will be given to the referrer if there is one.
816 		uint256 referralBonus = eth / HOURGLASS_FEE / HOURGLASS_BONUS;
817 
818 		bool usedHourglassMasternode = false;
819 		bool invalidMasternode = false;
820 		if (referrer == NULL_ADDRESS) {
821 			referrer = savedReferral[creator];
822 		}
823 
824 		// Solidity has limited amount of local variables, so the memory allocated to this one gets reused for other purposes later.
825 		//uint256 refHandlerBalance = hourglass.balanceOf(address(refHandler));
826 		uint256 tmp = hourglass.balanceOf(address(refHandler));
827 
828 		// Let's once again pretend this actually prevents people from cheating.
829 		if (creator == referrer) {
830 			// Tell everyone that no referral purchase was made because cheating (unlike P3D)
831 			invalidMasternode = true;
832 		} else if (referrer == NULL_ADDRESS) {
833 			usedHourglassMasternode = true;
834 		// Make sure that the referrer has enough funds to _be_ a referrer, and make sure that we have our own P3D masternode to get that extra ETH
835 		} else if (balances[referrer] >= referralRequirement && (tmp >= parentReferralRequirement || hourglass.balanceOf(address(this)) >= parentReferralRequirement)) {
836 			// It's a valid P3X masternode, hooray! (do nothing)
837 		} else if (hourglass.balanceOf(referrer) >= parentReferralRequirement) {
838 			usedHourglassMasternode = true;
839 		} else {
840 			// Tell everyone that no referral purchase was made because not enough balance (again, unlike P3D)
841 			invalidMasternode = true;
842 		}
843 
844 		// Thanks to Crypto McPump for helping me _not_ waste gas here.
845 		/*
846 		uint256 createdTokens = hourglass.calculateTokensReceived(eth); // See? Look how much gas I would have wasted.
847 		totalSupply += createdTokens;
848 		*/
849 		uint256 createdTokens = hourglass.totalSupply();
850 
851 		// KNOWN BUG: If lord Justo increases the staking requirement to something above both of the contract's P3D
852 		// balance, then all masternodes won't work until there are enough buy orders to make the refHandler's P3D
853 		// balance above P3D's masternode requirement.
854 
855 		// if the refHandler hass less P3D than P3D's masternode requirement, then it should buy the tokens.
856 		if (tmp < parentReferralRequirement) {
857 			if (reinvestment) {
858 				// We need to know if the refHandler has enough ETH to do the reinvestment on its own
859 				//uint256 refHandlerEthBalance = refHandler.totalBalance();
860 				tmp = refHandler.totalBalance();
861 				if (tmp < eth) {
862 					// If it doesn't, then we must transfer it the remaining ETH it needs.
863 					tmp = eth - tmp; // fundsToGive = eth - refHandlerEthBalance;
864 					if (address(this).balance < tmp) {
865 						// If this fails, something went horribly wrong because the client is attempting to reinvest more ethereum than we've got
866 						hourglass.withdraw();
867 					}
868 					address(refHandler).transfer(tmp);
869 				}
870 				// Reinvestments are always done using the null referrer
871 				refHandler.buyTokensFromBalance(NULL_ADDRESS, eth);
872 			} else {
873 				// these nested ? statements are only here because I can only have a limited amount of local variables.
874 				// Forward the ETH we were sent to the refHandler to place the buy order.
875 				refHandler.buyTokens.value(eth)(invalidMasternode ? NULL_ADDRESS : (usedHourglassMasternode ? referrer : address(this)));
876 			}
877 			tmp = hourglass.balanceOf(address(refHandler));
878 		} else {
879 			if (reinvestment) {
880 				// If we don't have enough ETH to do the reinvestment, withdraw.
881 				if (address(this).balance < eth && hourglass.myDividends(true) > 0) {
882 					hourglass.withdraw();
883 				}
884 				// If we _still_ don't have enough ETH to do the reinvestment, have the refHandler sends us some.
885 				if (address(this).balance < eth) {
886 					refHandler.sendETH(address(this), eth - address(this).balance);
887 				}
888 			}
889 			hourglass.buy.value(eth)(invalidMasternode ? NULL_ADDRESS : (usedHourglassMasternode ? referrer : address(refHandler)));
890 		}
891 
892 		// Use the delta from before and after the buy order to get the amount of P3D created.
893 		createdTokens = hourglass.totalSupply() - createdTokens;
894 		totalSupply += createdTokens;
895 
896 		// This is here for when someone transfers P3D to the contract directly. We have no way of knowing who it's from, so we'll just give it to the next person who happens to buy.
897 		uint256 bonusTokens = hourglass.myTokens() + tmp - totalSupply;
898 
899 		// Here I now re-use that uint256 to create the bit flags.
900 		tmp = 0;
901 		if (invalidMasternode)			{ tmp |= 1; }
902 		if (usedHourglassMasternode)	{ tmp |= 2; }
903 		if (reinvestment)				{ tmp |= 4; }
904 
905 		emit onTokenPurchase(creator, eth, createdTokens, bonusTokens, referrer, uint8(tmp));
906 		createdTokens += bonusTokens;
907 		// We can finally give the P3X to the buyer!
908 		balances[creator] += createdTokens;
909 		totalSupply += bonusTokens;
910 
911 		//Updates services like etherscan which track token hodlings.
912 		emit Transfer(address(this), creator, createdTokens, "");
913 		emit Transfer(address(this), creator, createdTokens);
914 
915 		// Unfortunatly, SafeMath cannot be used here, otherwise the stack gets too deep
916 		payouts[creator] += int256(profitPerShare * createdTokens); // You don't deserve the dividends before you owned the tokens.
917 
918 		if (reinvestment) {
919 			// No dividend distribution underflows allowed.
920 			// Ethereum has been given away after a "reinvestment" purchase, so we have to keep track of that.
921 			lastTotalBalance = lastTotalBalance.sub(eth);
922 		}
923 		distributeDividends((usedHourglassMasternode || invalidMasternode) ? 0 : referralBonus, referrer);
924 		if (referrer != NULL_ADDRESS) {
925 			// Save the referrer for next time!
926 			savedReferral[creator] = referrer;
927 		}
928 		return createdTokens;
929 	}
930 
931 	// This is marked as an internal function because selling could have been the result of transfering P3X to the contract via a transferFrom transaction.
932 	function destroyTokens(address weakHand, uint256 bags) internal returns(uint256) {
933 		require(updateUsableBalanceOf(weakHand) >= bags, "Insufficient balance");
934 
935 		// Give the weak hand the last of their deserved payout.
936 		// Also updates lastTotalBalance
937 		distributeDividends(0, NULL_ADDRESS);
938 		uint256 tokenBalance = hourglass.myTokens();
939 
940 		// We can't rely on ETH balance delta because we get cut of the sell fee ourselves.
941 		uint256 ethReceived = hourglass.calculateEthereumReceived(bags);
942 		lastTotalBalance += ethReceived;
943 		if (tokenBalance >= bags) {
944 			hourglass.sell(bags);
945 		} else {
946 			// If we don't have enough P3D to sell ourselves, get the slave to sell some, too.
947 			if (tokenBalance > 0) {
948 				hourglass.sell(tokenBalance);
949 			}
950 			refHandler.sellTokens(bags - tokenBalance);
951 		}
952 
953 		// Put the ETH in outstanding dividends, and allow the weak hand access to the divs they've accumilated before they sold.
954 		int256 updatedPayouts = int256(profitPerShare * bags + (ethReceived * ROUNDING_MAGNITUDE));
955 		payouts[weakHand] = payouts[weakHand].sub(updatedPayouts);
956 
957 		// We already checked the balance of the weakHanded person, so SafeMathing here is redundant.
958 		balances[weakHand] -= bags;
959 		totalSupply -= bags;
960 
961 		emit onTokenSell(weakHand, bags, ethReceived);
962 
963 		// Tell etherscan of this tragity.
964 		emit Transfer(weakHand, address(this), bags, "");
965 		emit Transfer(weakHand, address(this), bags);
966 		return ethReceived;
967 	}
968 
969 	// sends ETH to the specified account, using all the ETH P3X has access to.
970 	function sendETH(address payable to, uint256 amount) internal {
971 		uint256 childTotalBalance = refHandler.totalBalance();
972 		uint256 thisBalance = address(this).balance;
973 		uint256 thisTotalBalance = thisBalance + hourglass.myDividends(true);
974 		if (childTotalBalance >= amount) {
975 			// the refHanlder has enough of its own ETH to send, so it should do that.
976 			refHandler.sendETH(to, amount);
977 		} else if (thisTotalBalance >= amount) {
978 			// We have enough ETH of our own to send.
979 			if (thisBalance < amount) {
980 				hourglass.withdraw();
981 			}
982 			to.transfer(amount);
983 		} else {
984 			// Neither we nor the refHandler has enough ETH to send individually, so both contracts have to send ETH.
985 			refHandler.sendETH(to, childTotalBalance);
986 			if (hourglass.myDividends(true) > 0) {
987 				hourglass.withdraw();
988 			}
989 			to.transfer(amount - childTotalBalance);
990 		}
991 		// keep the dividend tracker in check.
992 		lastTotalBalance = lastTotalBalance.sub(amount);
993 	}
994 
995 	// Take the ETH we've got and distribute it among our token holders.
996 	function distributeDividends(uint256 bonus, address bonuser) internal{
997 		// Prevents "HELP I WAS THE LAST PERSON WHO SOLD AND I CAN'T WITHDRAW MY ETH WHAT DO????" (dividing by 0 results in a crash)
998 		if (totalSupply > 0) {
999 			uint256 tb = totalBalance();
1000 			uint256 delta = tb - lastTotalBalance;
1001 			if (delta > 0) {
1002 				// We have more ETH than before, so we'll just distribute those dividends among our token holders.
1003 				if (bonus != 0) {
1004 					bonuses[bonuser] += bonus;
1005 				}
1006 				profitPerShare = profitPerShare.add(((delta - bonus) * ROUNDING_MAGNITUDE) / totalSupply);
1007 				lastTotalBalance += delta;
1008 			}
1009 		}
1010 	}
1011 
1012 	// Clear out someone's dividends.
1013 	function clearDividends(address accountHolder) internal returns(uint256, uint256) {
1014 		uint256 payout = dividendsOf(accountHolder, false);
1015 		uint256 bonusPayout = bonuses[accountHolder];
1016 
1017 		payouts[accountHolder] += int256(payout * ROUNDING_MAGNITUDE);
1018 		bonuses[accountHolder] = 0;
1019 
1020 		// External apps can now get reliable masternode statistics
1021 		return (payout, bonusPayout);
1022 	}
1023 
1024 	// Withdraw 100% of someone's dividends
1025 	function withdrawDividends(address payable accountHolder) internal {
1026 		distributeDividends(0, NULL_ADDRESS); // Just in case P3D-only transactions happened.
1027 		uint256 payout;
1028 		uint256 bonusPayout;
1029 		(payout, bonusPayout) = clearDividends(accountHolder);
1030 		emit onWithdraw(accountHolder, payout, bonusPayout, false);
1031 		sendETH(accountHolder, payout + bonusPayout);
1032 	}
1033 
1034 	// The internal transfer function.
1035 	function actualTransfer (address payable from, address payable to, uint value, bytes memory data, string memory func, bool careAboutHumanity) internal{
1036 		require(updateUsableBalanceOf(from) >= value, "Insufficient balance");
1037 		require(to != address(refHandler), "My slave doesn't get paid"); // I don't know why anyone would do this, but w/e
1038 		require(to != address(hourglass), "P3D has no need for these"); // Prevent l33x h4x0rs from having P3X call arbitrary P3D functions.
1039 
1040 		if (to == address(this)) {
1041 			// Treat transfers to this contract as a sell and withdraw order.
1042 			if (value == 0) {
1043 				// Transfers of 0 still have to be emitted... for some reason.
1044 				emit Transfer(from, to, value, data);
1045 				emit Transfer(from, to, value);
1046 			} else {
1047 				destroyTokens(from, value);
1048 			}
1049 			withdrawDividends(from);
1050 		} else {
1051 			distributeDividends(0, NULL_ADDRESS); // Just in case P3D-only transactions happened.
1052 			// I was going to add a value == 0 check here, but if you're sending 0 tokens to someone, you deserve to pay for wasted gas.
1053 
1054 			// Throwing an exception undos all changes. Otherwise changing the balance now would be a shitshow
1055 			balances[from] = balances[from].sub(value);
1056 			balances[to] = balances[to].add(value);
1057 
1058 			// Sender can have their dividends from when they owned the tokens
1059 			payouts[from] -= int256(profitPerShare * value);
1060 			// Receiver is not allowed to have dividends from before they owned the tokens.
1061 			payouts[to] += int256(profitPerShare * value);
1062 
1063 			if (careAboutHumanity && isContract(to)) {
1064 				if (bytes(func).length == 0) {
1065 					ERC223Handler receiver = ERC223Handler(to);
1066 					receiver.tokenFallback(from, value, data);
1067 				} else {
1068 					bool success;
1069 					bytes memory returnData;
1070 					(success, returnData) = to.call.value(0)(abi.encodeWithSignature(func, from, value, data));
1071 					assert(success);
1072 				}
1073 			}
1074 			emit Transfer(from, to, value, data);
1075 			emit Transfer(from, to, value);
1076 		}
1077 	}
1078 
1079 	// The playerbook contract accepts a bytes32. We'll be converting for convenience sense.
1080 	function bytesToBytes32(bytes memory data) internal pure returns(bytes32){
1081 		uint256 result = 0;
1082 		uint256 len = data.length;
1083 		uint256 singleByte;
1084 		for (uint256 i = 0; i<len; i+=1){
1085 			singleByte = uint256(uint8(data[i])) << ( (31 - i) * 8);
1086 			require(singleByte != 0, "bytes cannot contain a null byte");
1087 			result |= singleByte;
1088 		}
1089 		return bytes32(result);
1090 	}
1091 
1092 	// haha casting types.
1093 	function stringToBytes32(string memory data) internal pure returns(bytes32){
1094 		return bytesToBytes32(bytes(data));
1095 	}
1096 
1097 	// If bytecode exists at _addr then the _addr is a contract.
1098 	function isContract(address _addr) internal view returns(bool) {
1099 		uint length;
1100 		assembly {
1101 			//retrieve the size of the code on target address, this needs assembly
1102 			length := extcodesize(_addr)
1103 		}
1104 		return (length>0);
1105 	}
1106 
1107 	// Reject possible accidental sendin of higher-tech shitcoins. (with a fancy message)
1108 	function tokenFallback(address from, uint value, bytes memory data) public pure{
1109 		revert("I don't want your shitcoins!");
1110 	}
1111 
1112 	// Allow anyone else to take forcefully sent low-tech shitcoins. (I sure as hell don't want them)
1113 	function takeShitcoin(address shitCoin) public{
1114 		// Don't allow people to siphon funds from us
1115 		require(shitCoin != address(hourglass), "P3D isn't a shitcoin");
1116 		ERC20interface s = ERC20interface(shitCoin);
1117 		s.transfer(msg.sender, s.balanceOf(address(this)));
1118 	}
1119 }
1120 
1121 
1122 /**
1123  * @title SafeMath
1124  * @dev Math operations with safety checks that throw on error
1125  */
1126 library SafeMath {
1127 
1128 	/**
1129 	* @dev Multiplies two numbers, throws on overflow.
1130 	*/
1131 	function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
1132 		if (a == 0 || b == 0) {
1133 		   return 0;
1134 		}
1135 		c = a * b;
1136 		assert(c / a == b);
1137 		return c;
1138 	}
1139 
1140 	/**
1141 	* @dev Integer division of two numbers, truncating the quotient.
1142 	*/
1143 	function div(uint256 a, uint256 b) internal pure returns(uint256) {
1144 		// assert(b > 0); // Solidity automatically throws when dividing by 0
1145 		// uint256 c = a / b;
1146 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
1147 		return a / b;
1148 	}
1149 
1150 	/**
1151 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1152 	*/
1153 	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
1154 		assert(b <= a);
1155 		return a - b;
1156 	}
1157 
1158 	/**
1159 	* @dev Adds two numbers, throws on overflow.
1160 	*/
1161 	function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
1162 		c = a + b;
1163 		assert(c >= a);
1164 		return c;
1165 	}
1166 
1167 	/**
1168 	* @dev Subtracts two numbers, throws on underflow
1169 	*/
1170 	function sub(int256 a, int256 b) internal pure returns(int256 c) {
1171 		c = a - b;
1172 		assert(c <= a);
1173 		return c;
1174 	}
1175 
1176 	/**
1177 	* @dev Adds two numbers, throws on overflow.
1178 	*/
1179 	function add(int256 a, int256 b) internal pure returns(int256 c) {
1180 		c = a + b;
1181 		assert(c >= a);
1182 		return c;
1183 	}
1184 }