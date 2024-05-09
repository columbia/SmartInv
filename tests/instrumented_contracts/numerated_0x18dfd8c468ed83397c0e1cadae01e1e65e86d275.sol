1 /* Owned.sol
2 
3 Pacio Core Ltd https://www.pacio.io
4 
5 2017.03.04 djh Originally created
6 2017.08.16 Brought into use for Pacio token sale use
7 2017.08.22 Logging revised
8 
9 Owned is a Base Contract for contracts that are:
10 • "owned"
11 • can have their owner changed by a call to ChangeOwner() by the owner
12 • can be paused  from an active state by a call to Pause() by the owner
13 • can be resumed from a paused state by a call to Resume() by the owner
14 
15 Modifier functions available for use here and in child contracts are:
16 • IsOwner()  which throws if called by other than the current owner
17 • IsActive() which throws if called when the contract is paused
18 
19 Changes of owner are logged via event LogOwnerChange(address indexed previousOwner, address newOwner)
20 
21 */
22 
23 pragma solidity ^0.4.15;
24 
25 contract Owned {
26   address public ownerA; // Contract owner
27   bool    public pausedB;
28 
29   // Constructor NOT payable
30   // -----------
31   function Owned() {
32     ownerA = msg.sender;
33   }
34 
35   // Modifier functions
36   // ------------------
37   modifier IsOwner {
38     require(msg.sender == ownerA);
39     _;
40   }
41 
42   modifier IsActive {
43     require(!pausedB);
44     _;
45   }
46 
47   // Events
48   // ------
49   event LogOwnerChange(address indexed PreviousOwner, address NewOwner);
50   event LogPaused();
51   event LogResumed();
52 
53   // State changing public methods
54   // -----------------------------
55   // Change owner
56   function ChangeOwner(address vNewOwnerA) IsOwner {
57     require(vNewOwnerA != address(0)
58          && vNewOwnerA != ownerA);
59     LogOwnerChange(ownerA, vNewOwnerA);
60     ownerA = vNewOwnerA;
61   }
62 
63   // Pause
64   function Pause() IsOwner {
65     pausedB = true; // contract has been paused
66     LogPaused();
67   }
68 
69   // Resume
70   function Resume() IsOwner {
71     pausedB = false; // contract has been resumed
72     LogResumed();
73   }
74 } // End Owned contract
75 
76 
77 // DSMath.sol
78 // From https://dappsys.readthedocs.io/en/latest/ds_math.html
79 
80 // Reduced version - just the fns used by Pacio
81 
82 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
83 
84 // Licensed under the Apache License, Version 2.0 (the "License").
85 // You may not use this file except in compliance with the License.
86 
87 // Unless required by applicable law or agreed to in writing, software
88 // distributed under the License is distributed on an "AS IS" BASIS,
89 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
90 
91 contract DSMath {
92   /*
93   standard uint256 functions
94   */
95 
96   function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
97     assert((z = x + y) >= x);
98   }
99 
100   function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
101     assert((z = x - y) <= x);
102   }
103 
104   function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
105     z = x * y;
106     assert(x == 0 || z / x == y);
107   }
108 
109   // div isn't needed. Only error case is div by zero and Solidity throws on that
110   // function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
111   //   z = x / y;
112   // }
113 
114   // subMaxZero(x, y)
115   // Pacio addition to avoid throwing if a subtraction goes below zero and return 0 in that case.
116   function subMaxZero(uint256 x, uint256 y) constant internal returns (uint256 z) {
117     if (y > x)
118       z = 0;
119     else
120       z = x - y;
121   }
122 }
123 
124 // ERC20Token.sol 2017.08.16 started
125 
126 // 2017.10.07 isERC20Token changed to isEIP20Token
127 
128 /*
129 ERC Token Standard #20 Interface
130 https://github.com/ethereum/EIPs/issues/20
131 https://github.com/frozeman/EIPs/blob/94bc4311e889c2c58c561c074be1483f48ac9374/EIPS/eip-20-token-standard.md
132 Using Dappsys naming style of 3 letter names: src, dst, guy, wad
133 */
134 
135 contract ERC20Token is Owned, DSMath {
136   // Data
137   bool public constant isEIP20Token = true; // Interface declaration
138   uint public totalSupply;     // Total tokens minted
139   bool public saleInProgressB; // when true stops transfers
140 
141   mapping(address => uint) internal iTokensOwnedM;                 // Tokens owned by an account
142   mapping(address => mapping (address => uint)) private pAllowedM; // Owner of account approves the transfer of an amount to another account
143 
144   // ERC20 Events
145   // ============
146   // Transfer
147   // Triggered when tokens are transferred.
148   event Transfer(address indexed src, address indexed dst, uint wad);
149 
150   // Approval
151   // Triggered whenever approve(address spender, uint wad) is called.
152   event Approval(address indexed Sender, address indexed Spender, uint Wad);
153 
154   // ERC20 Methods
155   // =============
156   // Public Constant Methods
157   // -----------------------
158   // balanceOf()
159   // Returns the token balance of account with address guy
160   function balanceOf(address guy) public constant returns (uint) {
161     return iTokensOwnedM[guy];
162   }
163 
164   // allowance()
165   // Returns the number of tokens approved by guy that can be transferred ("spent") by spender
166   function allowance(address guy, address spender) public constant returns (uint) {
167     return pAllowedM[guy][spender];
168   }
169 
170   // Modifier functions
171   // ------------------
172   modifier IsTransferOK(address src, address dst, uint wad) {
173     require(!saleInProgressB          // Sale not in progress
174          && !pausedB                  // IsActive
175          && iTokensOwnedM[src] >= wad // Source has the tokens available
176       // && wad > 0                   // Non-zero transfer No! The std says: Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event
177          && dst != src                // Destination is different from source
178          && dst != address(this)      // Not transferring to this token contract
179          && dst != ownerA);           // Not transferring to the owner of this contract - the token sale contract
180     _;
181   }
182 
183   // State changing public methods made pause-able and with call logging
184   // -----------------------------
185   // transfer()
186   // Transfers wad of sender's tokens to another account, address dst
187   // No need for overflow check given that totalSupply is always far smaller than max uint
188   function transfer(address dst, uint wad) IsTransferOK(msg.sender, dst, wad) returns (bool) {
189     iTokensOwnedM[msg.sender] -= wad; // There is no need to check this for underflow via a sub() call given the IsTransferOK iTokensOwnedM[src] >= wad check
190     iTokensOwnedM[dst] = add(iTokensOwnedM[dst], wad);
191     Transfer(msg.sender, dst, wad);
192     return true;
193   }
194 
195   // transferFrom()
196   // Sender transfers wad tokens from src account src to dst account, if
197   // sender had been approved by src for a transfer of >= wad tokens from src's account
198   // by a prior call to approve() with that call's sender being this calls src,
199   //  and its spender being this call's sender.
200   function transferFrom(address src, address dst, uint wad) IsTransferOK(src, dst, wad) returns (bool) {
201     require(pAllowedM[src][msg.sender] >= wad); // Transfer is approved
202     iTokensOwnedM[src]         -= wad; // There is no need to check this for underflow given the require above
203     pAllowedM[src][msg.sender] -= wad; // There is no need to check this for underflow given the require above
204     iTokensOwnedM[dst] = add(iTokensOwnedM[dst], wad);
205     Transfer(src, dst, wad);
206     return true;
207   }
208 
209   // approve()
210   // Approves the passed address (of spender) to spend up to wad tokens on behalf of msg.sender,
211   //  in one or more transferFrom() calls
212   // If this function is called again it overwrites the current allowance with wad.
213   function approve(address spender, uint wad) IsActive returns (bool) {
214     // To change the approve amount you first have to reduce the addresses`
215     //  allowance to zero by calling `approve(spender, 0)` if it is not
216     //  already 0 to mitigate the race condition described here:
217     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218     // djh: This appears to be of doubtful value, and is not used in the Dappsys library though it is in the Zeppelin one. Removed.
219     // require((wad == 0) || (pAllowedM[msg.sender][spender] == 0));
220     pAllowedM[msg.sender][spender] = wad;
221     Approval(msg.sender, spender, wad);
222     return true;
223   }
224 } // End ERC20Token contracts
225 
226 // PacioToken.sol 2017.08.22 started
227 
228 /* The Pacio Token named PIOE for the Ethereum version
229 
230 Follows the EIP20 standard: https://github.com/frozeman/EIPs/blob/94bc4311e889c2c58c561c074be1483f48ac9374/EIPS/eip-20-token-standard.md
231 
232 2017.10.08 Changed to suit direct deployment rather than being created via the PacioICO constructor, so that Etherscan can recognise it.
233 
234 */
235 
236 contract PacioToken is ERC20Token {
237   // enum NFF {  // Founders/Foundation enum
238   //   Founders, // 0 Pacio Founders
239   //   Foundatn} // 1 Pacio Foundation
240   string public constant name   = "Pacio Token";
241   string public constant symbol = "PIOE";
242   uint8  public constant decimals = 12;
243   uint   public tokensIssued;           // Tokens issued - tokens in circulation
244   uint   public tokensAvailable;        // Tokens available = total supply less allocated and issued tokens
245   uint   public contributors;           // Number of contributors
246   uint   public founderTokensAllocated; // Founder tokens allocated
247   uint   public founderTokensVested;    // Founder tokens vested. Same as iTokensOwnedM[pFounderToksA] until tokens transferred. Unvested tokens = founderTokensAllocated - founderTokensVested
248   uint   public foundationTokensAllocated; // Foundation tokens allocated
249   uint   public foundationTokensVested;    // Foundation tokens vested. Same as iTokensOwnedM[pFoundationToksA] until tokens transferred. Unvested tokens = foundationTokensAllocated - foundationTokensVested
250   bool   public icoCompleteB;           // Is set to true when both presale and full ICO are complete. Required for vesting of founder and foundation tokens and transfers of PIOEs to PIOs
251   address private pFounderToksA;        // Address for Founder tokens issued
252   address private pFoundationToksA;     // Address for Foundation tokens issued
253 
254   // Events
255   // ------
256   event LogIssue(address indexed Dst, uint Picos);
257   event LogSaleCapReached(uint TokensIssued); // not tokensIssued just to avoid compiler Warning: This declaration shadows an existing declaration
258   event LogIcoCompleted();
259   event LogBurn(address Src, uint Picos);
260   event LogDestroy(uint Picos);
261 
262   // No Constructor
263   // --------------
264 
265   // Initialisation/Settings Methods IsOwner but not IsActive
266   // -------------------------------
267 
268   // Initialise()
269   // To be called by deployment owner to change ownership to the sale contract, and do the initial allocations and minting.
270   // Can only be called once. If the sale contract changes but the token contract stays the same then ChangeOwner() can be called via PacioICO.ChangeTokenContractOwner() to change the owner to the new contract
271   function Initialise(address vNewOwnerA) { // IsOwner c/o the super.ChangeOwner() call
272     require(totalSupply == 0);          // can only be called once
273     super.ChangeOwner(vNewOwnerA);      // includes an IsOwner check so don't need to repeat it here
274     founderTokensAllocated    = 10**20; // 10% or 100 million = 1e20 Picos
275     foundationTokensAllocated = 10**20; // 10% or 100 million = 1e20 Picos This call sets tokensAvailable
276     // Equivalent of Mint(10**21) which can't be used here as msg.sender is the old (deployment) owner // 1 Billion PIOEs    = 1e21 Picos, all minted)
277     totalSupply           = 10**21; // 1 Billion PIOEs    = 1e21 Picos, all minted)
278     iTokensOwnedM[ownerA] = 10**21;
279     tokensAvailable       = 8*(10**20); // 800 million [String: '800000000000000000000'] s: 1, e: 20, c: [ 8000000 ] }
280     // From the EIP20 Standard: A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
281     Transfer(0x0, ownerA, 10**21); // log event 0x0 from == minting
282   }
283 
284   // Mint()
285   // PacioICO() includes a Mint() fn to allow manual calling of this if necessary e.g. re full ICO going over the cap
286   function Mint(uint picos) IsOwner {
287     totalSupply           = add(totalSupply,           picos);
288     iTokensOwnedM[ownerA] = add(iTokensOwnedM[ownerA], picos);
289     tokensAvailable = subMaxZero(totalSupply, tokensIssued + founderTokensAllocated + foundationTokensAllocated);
290     // From the EIP20 Standard: A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
291     Transfer(0x0, ownerA, picos); // log event 0x0 from == minting
292   }
293 
294   // PrepareForSale()
295   // stops transfers and allows purchases
296   function PrepareForSale() IsOwner {
297     require(!icoCompleteB); // Cannot start selling again once ICO has been set to completed
298     saleInProgressB = true; // stops transfers
299   }
300 
301   // ChangeOwner()
302   // To be called by owner to change the token contract owner, expected to be to a sale contract
303   // Transfers any minted tokens from old to new sale contract
304   function ChangeOwner(address vNewOwnerA) { // IsOwner c/o the super.ChangeOwner() call
305     transfer(vNewOwnerA, iTokensOwnedM[ownerA]); // includes checks
306     super.ChangeOwner(vNewOwnerA); // includes an IsOwner check so don't need to repeat it here
307   }
308 
309   // Public Constant Methods
310   // -----------------------
311   // None. Used public variables instead which result in getter functions
312 
313   // State changing public methods made pause-able and with call logging
314   // -----------------------------
315   // Issue()
316   // Transfers picos tokens to dst to issue them. IsOwner because this is expected to be called from the token sale contract
317   function Issue(address dst, uint picos) IsOwner IsActive returns (bool) {
318     require(saleInProgressB      // Sale is in progress
319          && iTokensOwnedM[ownerA] >= picos // Owner has the tokens available
320       // && picos > 0            // Non-zero issue No need to check for this
321          && dst != address(this) // Not issuing to this token contract
322          && dst != ownerA);      // Not issuing to the owner of this contract - the token sale contract
323     if (iTokensOwnedM[dst] == 0)
324       contributors++;
325     iTokensOwnedM[ownerA] -= picos; // There is no need to check this for underflow via a sub() call given the iTokensOwnedM[ownerA] >= picos check
326     iTokensOwnedM[dst]     = add(iTokensOwnedM[dst], picos);
327     tokensIssued           = add(tokensIssued,       picos);
328     tokensAvailable    = subMaxZero(tokensAvailable, picos); // subMaxZero() in case a sale goes over, only possible for full ICO, when cap is for all available tokens.
329     LogIssue(dst, picos);                                    // If that should happen,may need to mint some more PIOEs to allow founder and foundation vesting to complete.
330     return true;
331   }
332 
333   // SaleCapReached()
334   // To be be called from the token sale contract when a cap (pre or full) is reached
335   // Allows transfers
336   function SaleCapReached() IsOwner IsActive {
337     saleInProgressB = false; // allows transfers
338     LogSaleCapReached(tokensIssued);
339   }
340 
341   // Functions for manual calling via same name function in PacioICO()
342   // =================================================================
343   // IcoCompleted()
344   // To be be called manually via PacioICO after full ICO ends. Could be called before cap is reached if ....
345   function IcoCompleted() IsOwner IsActive {
346     require(!icoCompleteB);
347     saleInProgressB = false; // allows transfers
348     icoCompleteB    = true;
349     LogIcoCompleted();
350   }
351 
352   // SetFFSettings(address vFounderTokensA, address vFoundationTokensA, uint vFounderTokensAllocation, uint vFoundationTokensAllocation)
353   // Allows setting Founder and Foundation addresses (or changing them if an appropriate transfer has been done)
354   //  plus optionally changing the allocations which are set by the constructor, so that they can be varied post deployment if required re a change of plan
355   // All values are optional - zeros can be passed
356   // Must have been called with non-zero Founder and Foundation addresses before Founder and Foundation vesting can be done
357   function SetFFSettings(address vFounderTokensA, address vFoundationTokensA, uint vFounderTokensAllocation, uint vFoundationTokensAllocation) IsOwner {
358     if (vFounderTokensA    != address(0)) pFounderToksA    = vFounderTokensA;
359     if (vFoundationTokensA != address(0)) pFoundationToksA = vFoundationTokensA;
360     if (vFounderTokensAllocation > 0)    assert((founderTokensAllocated    = vFounderTokensAllocation)    >= founderTokensVested);
361     if (vFoundationTokensAllocation > 0) assert((foundationTokensAllocated = vFoundationTokensAllocation) >= foundationTokensVested);
362     tokensAvailable = totalSupply - founderTokensAllocated - foundationTokensAllocated - tokensIssued;
363   }
364 
365   // VestFFTokens()
366   // To vest Founder and/or Foundation tokens
367   // 0 can be passed meaning skip that one
368   // No separate event as the LogIssue event can be used to trace vesting transfers
369   // To be be called manually via PacioICO
370   function VestFFTokens(uint vFounderTokensVesting, uint vFoundationTokensVesting) IsOwner IsActive {
371     require(icoCompleteB); // ICO must be completed before vesting can occur. djh?? Add other time restriction?
372     if (vFounderTokensVesting > 0) {
373       assert(pFounderToksA != address(0)); // Founders token address must have been set
374       assert((founderTokensVested  = add(founderTokensVested,          vFounderTokensVesting)) <= founderTokensAllocated);
375       iTokensOwnedM[ownerA]        = sub(iTokensOwnedM[ownerA],        vFounderTokensVesting);
376       iTokensOwnedM[pFounderToksA] = add(iTokensOwnedM[pFounderToksA], vFounderTokensVesting);
377       LogIssue(pFounderToksA,          vFounderTokensVesting);
378       tokensIssued = add(tokensIssued, vFounderTokensVesting);
379     }
380     if (vFoundationTokensVesting > 0) {
381       assert(pFoundationToksA != address(0)); // Foundation token address must have been set
382       assert((foundationTokensVested  = add(foundationTokensVested,          vFoundationTokensVesting)) <= foundationTokensAllocated);
383       iTokensOwnedM[ownerA]           = sub(iTokensOwnedM[ownerA],           vFoundationTokensVesting);
384       iTokensOwnedM[pFoundationToksA] = add(iTokensOwnedM[pFoundationToksA], vFoundationTokensVesting);
385       LogIssue(pFoundationToksA,       vFoundationTokensVesting);
386       tokensIssued = add(tokensIssued, vFoundationTokensVesting);
387     }
388     // Does not affect tokensAvailable as these tokens had already been allowed for in tokensAvailable when allocated
389   }
390 
391   // Burn()
392   // For use when transferring issued PIOEs to PIOs
393   // To be be called manually via PacioICO or from a new transfer contract to be written which is set to own this one
394   function Burn(address src, uint picos) IsOwner IsActive {
395     require(icoCompleteB);
396     iTokensOwnedM[src] = subMaxZero(iTokensOwnedM[src], picos);
397     tokensIssued       = subMaxZero(tokensIssued, picos);
398     totalSupply        = subMaxZero(totalSupply,  picos);
399     LogBurn(src, picos);
400     // Does not affect tokensAvailable as these are issued tokens that are being burnt
401   }
402 
403   // Destroy()
404   // For use when transferring unissued PIOEs to PIOs
405   // To be be called manually via PacioICO or from a new transfer contract to be written which is set to own this one
406   function Destroy(uint picos) IsOwner IsActive {
407     require(icoCompleteB);
408     totalSupply     = subMaxZero(totalSupply,     picos);
409     tokensAvailable = subMaxZero(tokensAvailable, picos);
410     LogDestroy(picos);
411   }
412 
413   // Fallback function
414   // =================
415   // No sending ether to this contract!
416   // Not payable so trying to send ether will throw
417   function() {
418     revert(); // reject any attempt to access the token contract other than via the defined methods with their testing for valid access
419   }
420 } // End PacioToken contract