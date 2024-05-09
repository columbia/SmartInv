1 pragma solidity >=0.4.22 <0.6.0;
2 
3 //-----------------------------------------------------------------------------
4 /// @title Ownable
5 /// @dev The Ownable contract has an owner address, and provides basic 
6 ///  authorization control functions, this simplifies the implementation of
7 ///  "user permissions".
8 //-----------------------------------------------------------------------------
9 contract Ownable {
10     //-------------------------------------------------------------------------
11     /// @dev Emits when owner address changes by any mechanism.
12     //-------------------------------------------------------------------------
13     event OwnershipTransfer (address previousOwner, address newOwner);
14     
15     // Wallet address that can sucessfully execute onlyOwner functions
16     address owner;
17     
18     //-------------------------------------------------------------------------
19     /// @dev Sets the owner of the contract to the sender account.
20     //-------------------------------------------------------------------------
21     constructor() public {
22         owner = msg.sender;
23         emit OwnershipTransfer(address(0), owner);
24     }
25 
26     //-------------------------------------------------------------------------
27     /// @dev Throws if called by any account other than `owner`.
28     //-------------------------------------------------------------------------
29     modifier onlyOwner() {
30         require(
31             msg.sender == owner,
32             "Function can only be called by contract owner"
33         );
34         _;
35     }
36 
37     //-------------------------------------------------------------------------
38     /// @notice Transfer control of the contract to a newOwner.
39     /// @dev Throws if `_newOwner` is zero address.
40     /// @param _newOwner The address to transfer ownership to.
41     //-------------------------------------------------------------------------
42     function transferOwnership(address _newOwner) public onlyOwner {
43         // for safety, new owner parameter must not be 0
44         require (
45             _newOwner != address(0),
46             "New owner address cannot be zero"
47         );
48         // define local variable for old owner
49         address oldOwner = owner;
50         // set owner to new owner
51         owner = _newOwner;
52         // emit ownership transfer event
53         emit OwnershipTransfer(oldOwner, _newOwner);
54     }
55 }
56 
57 
58 //-----------------------------------------------------------------------------
59 /// @title VIP 181 Interface - VIP 181-compliant view functions 
60 //-----------------------------------------------------------------------------
61 interface VIP181 {
62     function ownerOf(uint256 _tokenId) external view returns (address);
63     function getApproved(uint256 _tokenId) external view returns (address);
64     function isApprovedForAll(
65         address _owner, 
66         address _operator
67     ) external view returns (bool);
68 }
69 
70 interface VIP180 {
71     function transferFrom(address _from, address _to, uint _tokens) external returns (bool);
72 }
73 
74 interface LockedTokenManager {    
75     function lockFrom(
76         address _tokenHolder, 
77         address _tokenAddress, 
78         uint _tokens, 
79         uint _numberOfMonths
80     ) external returns(bool);
81     
82     function transferFromAndLock(
83         address _from,
84         address _to,
85         address _tokenAddress,
86         uint _tokens,
87         uint _numberOfMonths
88     ) external returns (bool);
89 }
90 
91 
92 contract SegmentedTransfer is Ownable {
93     
94     struct TransferSettings {
95         uint burnedPercent;
96         uint lockedPercent;
97         uint transferredThenLockedPercent;
98         uint lockedMonths;
99     }
100     // Lock contract to interface with
101     LockedTokenManager public lockContract;
102 
103     //-------------------------------------------------------------------------
104     /// @dev Throws if parameter is zero
105     //-------------------------------------------------------------------------
106     modifier notZero(uint _param) {
107         require(_param != 0, "Parameter cannot be zero");
108         _;
109     }
110     
111     //-------------------------------------------------------------------------
112     /// @notice Set the address of the lock interface to `_lockAddress`.
113     /// @dev Throws if aacAddress is the zero address.
114     /// @param _lockAddress The address of the lock interface.
115     //-------------------------------------------------------------------------
116     function setLockContract (address _lockAddress)
117         external 
118         notZero(uint(_lockAddress)) 
119         onlyOwner
120     {
121         // initialize contract to lockAddress
122         lockContract = LockedTokenManager(_lockAddress);
123     }
124     
125     //-------------------------------------------------------------------------
126     /// @notice (1)Burn (2)Lock (3)TransferThenLock (4)Transfer
127     //-------------------------------------------------------------------------
128     function segmentedTransfer(
129         address _tokenContractAddress,
130         address _to,
131         uint _totalTokens,
132         TransferSettings storage _transfer
133     ) internal {
134         uint tokensLeft = _totalTokens;
135         uint amount;
136         // burn
137         if (_transfer.burnedPercent > 0) {
138             amount = _totalTokens * _transfer.burnedPercent / 100;
139             VIP180(_tokenContractAddress).transferFrom(msg.sender, address(0), amount);
140             tokensLeft -= amount;
141         }
142         // Lock
143         if (_transfer.lockedPercent > 0) {
144             amount = _totalTokens * _transfer.lockedPercent / 100;
145             lockContract.lockFrom(
146                 msg.sender, 
147                 _tokenContractAddress, 
148                 _transfer.lockedMonths, 
149                 amount
150             );
151             tokensLeft -= amount;
152         }
153         // Transfer Then Lock
154         if (_transfer.transferredThenLockedPercent > 0) {
155             amount = _totalTokens * _transfer.transferredThenLockedPercent / 100;
156             lockContract.transferFromAndLock(
157                 msg.sender, 
158                 address(_to), 
159                 _tokenContractAddress, 
160                 _transfer.lockedMonths, 
161                 amount
162             );
163             tokensLeft -= amount;
164         }
165         // Transfer
166         if (tokensLeft > 0) {
167             VIP180(_tokenContractAddress).transferFrom(msg.sender, _to, tokensLeft);
168         }
169     }   
170 }
171 
172 
173 //-----------------------------------------------------------------------------
174 /// @title AAC Colored Token Contract
175 /// @notice defines colored token registration, creation, and spending
176 ///  functionality.
177 //-----------------------------------------------------------------------------
178 contract AacColoredTokens is SegmentedTransfer {
179     //-------------------------------------------------------------------------
180     /// @dev Emits when a new colored token is created.
181     //-------------------------------------------------------------------------
182     event NewColor(address indexed _creator, string _name);
183 
184     //-------------------------------------------------------------------------
185     /// @dev Emits when colored tokens are deposited into AACs.
186     //-------------------------------------------------------------------------
187     event DepositColor(uint indexed _to, uint indexed _colorIndex, uint _tokens);
188 
189     //-------------------------------------------------------------------------
190     /// @dev Emits when colored tokens are spent by any mechanism.
191     //-------------------------------------------------------------------------
192     event SpendColor(
193         uint indexed _from, 
194         uint indexed _color, 
195         uint _amount
196     );
197 
198     // Colored token data
199     struct ColoredToken {
200         address creator;
201         string name;
202         mapping (uint => uint) balances;
203         mapping (address => uint) depositAllowances;
204     }
205 
206     // array containing all colored token data
207     ColoredToken[] coloredTokens;
208     // required locked tokens needed to register a color
209     uint public priceToRegisterColor = 100000 * 10**18;
210     // AAC contract to interface with
211     VIP181 public aacContract;
212     // Contract address whose tokens we accept
213     address public ehrtAddress;
214     // transfer percentages for colored token registration
215     TransferSettings public colorRegistrationTransfer = TransferSettings({
216         burnedPercent: 50,
217         lockedPercent: 0,
218         transferredThenLockedPercent: 0,
219         lockedMonths: 24
220     });
221     // transfer percentages for colored token minting/depositing
222     TransferSettings public colorDepositTransfer = TransferSettings({
223         burnedPercent: 50,
224         lockedPercent: 0,
225         transferredThenLockedPercent: 0,
226         lockedMonths: 24
227     });
228     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
229 
230     //-------------------------------------------------------------------------
231     /// @notice Set the address of the AAC interface to `_aacAddress`.
232     /// @dev Throws if aacAddress is the zero address.
233     /// @param _aacAddress The address of the AAC interface.
234     //-------------------------------------------------------------------------
235     function setAacContract (address _aacAddress) 
236         external 
237         notZero(uint(_aacAddress)) 
238         onlyOwner
239     {
240         // initialize contract to aacAddress
241         aacContract = VIP181(_aacAddress);
242     }
243     
244     //-------------------------------------------------------------------------
245     /// @notice Set the address of the VIP180 to `_newAddress`.
246     /// @dev Throws if ehrtAddress is the zero address.
247     /// @param _newAddress The address of the Eight Hours Token.
248     //-------------------------------------------------------------------------
249     function setEhrtContractAddress (address _newAddress) 
250         external 
251         notZero(uint(_newAddress)) 
252         onlyOwner
253     {
254         // initialize ehrtAddress to new address
255         ehrtAddress = _newAddress;
256     }
257 
258     //-------------------------------------------------------------------------
259     /// @notice Set required total locked tokens to 
260     ///  `(newAmount/1000000000000000000).fixed(0,18)`.
261     /// @dev Throws if the sender is not the contract owner. Throws if new
262     ///  amount is zero.
263     /// @param _newAmount The new required locked token amount.
264     //-------------------------------------------------------------------------
265     function setPriceToRegisterColor(uint _newAmount) 
266         external 
267         onlyOwner
268         notZero(_newAmount)
269     {
270         priceToRegisterColor = _newAmount;
271     }
272     
273     function setTransferSettingsForColoredTokenCreation(
274         uint _burnPercent,
275         uint _lockPercent,
276         uint _transferLockPercent,
277         uint _lockedMonths
278     ) external onlyOwner {
279         require(_burnPercent + _lockPercent + _transferLockPercent <= 100);
280         colorRegistrationTransfer = TransferSettings(
281             _burnPercent, 
282             _lockPercent, 
283             _transferLockPercent,
284             _lockedMonths
285         );
286     }
287     
288     function setTransferSettingsForColoredTokenDeposits(
289         uint _burnPercent,
290         uint _lockPercent,
291         uint _transferLockPercent,
292         uint _lockedMonths
293     ) external onlyOwner {
294         require(_burnPercent + _lockPercent + _transferLockPercent <= 100);
295         colorDepositTransfer = TransferSettings(
296             _burnPercent, 
297             _lockPercent, 
298             _transferLockPercent,
299             _lockedMonths
300         );
301     }
302     
303     //-------------------------------------------------------------------------
304     /// @notice Registers `_colorName` as a new colored token. Costs 
305     ///  `priceToRegisterColor` tokens.
306     /// @dev Throws if `msg.sender` has insufficient tokens. Throws if colorName
307     ///  is empty or is longer than 32 characters.
308     /// @param _colorName The name for the new colored token.
309     /// @return Index number for the new colored token.
310     //-------------------------------------------------------------------------
311     function registerNewColor(string calldata _colorName) external returns (uint) {
312         // colorName must be a valid length
313         require (
314             bytes(_colorName).length > 0 && bytes(_colorName).length < 32,
315             "Invalid color name length"
316         );
317         // send Eight Hours tokens
318         segmentedTransfer(ehrtAddress, owner, priceToRegisterColor, colorRegistrationTransfer);
319         // push new colored token to colored token array and store the index
320         uint index = coloredTokens.push(ColoredToken(msg.sender, _colorName));
321         return index;
322     }
323     
324     //-------------------------------------------------------------------------
325     /// @notice Allow `_spender` to deposit colored token #`_colorIndex`
326     ///  multiple times, up to `(_tokens/1000000000000000000).fixed(0,18)`. 
327     ///  Calling this function overwrites the previous allowance of spender.
328     /// @param _colorIndex The index of the color to approve.
329     /// @param _spender The address to authorize as a spender
330     /// @param _tokens The new token allowance of spender (in wei).
331     //-------------------------------------------------------------------------
332     function approve(uint _colorIndex, address _spender, uint _tokens) external {
333         require(msg.sender == coloredTokens[_colorIndex].creator);
334         // set the spender's allowance to token amount
335         coloredTokens[_colorIndex].depositAllowances[_spender] = _tokens;
336     }
337 
338     //-------------------------------------------------------------------------
339     /// @notice Deposits colored tokens with index `colorIndex` into AAC #`uid`.
340     ///  Costs `_tokens` tokens.
341     /// @dev Throws if tokens to deposit is zero. Throws if colorIndex is
342     ///  greater than number of colored tokens. Throws if `msg.sender` has
343     ///  insufficient balance. Throws if AAC does not have an owner. Throws if
344     ///  sender does not have enough deposit allowance (creator has unlimited).
345     /// @param _to The Unique Identifier of the AAC receiving tokens.
346     /// @param _colorIndex The index of the color to deposit.
347     /// @param _tokens The number of colored tokens to deposit.
348     //-------------------------------------------------------------------------
349     function deposit (uint _colorIndex, uint _to, uint _tokens)
350         external 
351         notZero(_tokens)
352     {
353         // colorIndex must be valid color
354         require (_colorIndex < coloredTokens.length, "Invalid color index");
355         // sender must be colored token creator
356         require (
357             msg.sender == coloredTokens[_colorIndex].creator ||
358             coloredTokens[_colorIndex].depositAllowances[msg.sender] >= _tokens,
359             "Not authorized to deposit this color"
360         );
361         // If AAC #uid is not owned, it does not exist yet.
362         require(aacContract.ownerOf(_to) != address(0), "AAC does not exist");
363         
364         // Initiate spending. Fails if sender's balance is too low.
365         segmentedTransfer(ehrtAddress, owner, _tokens, colorDepositTransfer);
366 
367         // add tokens to AAC #UID
368         coloredTokens[_colorIndex].balances[_to] += _tokens;
369         
370         // subtract tokens from allowance
371         if (msg.sender != coloredTokens[_colorIndex].creator) {
372             coloredTokens[_colorIndex].depositAllowances[msg.sender] -= _tokens;
373         }
374         
375         // emit color transfer event
376         emit DepositColor(_to, _colorIndex, _tokens);
377     }
378 
379     //-------------------------------------------------------------------------
380     /// @notice Deposits colored tokens with index `colorIndex` into multiple 
381     ///  AACs. Costs (`_tokens` * number of AACs) tokens.
382     /// @dev Throws if tokens to deposit is zero. Throws if colorIndex is
383     ///  greater than number of colored tokens. Throws if sender has
384     ///  insufficient balance. Throws if any AAC does not have an owner. Throws
385     ///  if sender does not have enough deposit allowance (creator has unlimited).
386     /// @param _to The Unique Identifier of the AAC receiving tokens.
387     /// @param _colorIndex The index of the color to deposit.
388     /// @param _tokens The number of colored tokens to deposit for each AAC.
389     //-------------------------------------------------------------------------
390     function depositBulk (uint _colorIndex, uint[] calldata _to, uint _tokens)
391         external 
392         notZero(_tokens)
393     {
394         // colorIndex must be valid color
395         require (_colorIndex < coloredTokens.length, "Invalid color index");
396         // sender must be colored token creator
397         require (
398             msg.sender == coloredTokens[_colorIndex].creator ||
399             coloredTokens[_colorIndex].depositAllowances[msg.sender] > _tokens * _to.length,
400             "Not authorized to deposit this color"
401         );
402 
403         // Initiate lock. Fails if sender's balance is too low.
404         segmentedTransfer(ehrtAddress, owner, _tokens * _to.length, colorDepositTransfer);
405 
406         for(uint i = 0; i < _to.length; ++i){
407             // If AAC #uid is not owned, it does not exist yet.
408             require(aacContract.ownerOf(_to[i]) != address(0), "AAC does not exist");
409 
410             // add tokens to AAC #UID
411             coloredTokens[_colorIndex].balances[_to[i]] += _tokens;
412             // emit color transfer event
413             emit DepositColor(_to[i], _colorIndex, _tokens);
414         }
415         
416         // subtract tokens from allowance
417         if (msg.sender != coloredTokens[_colorIndex].creator) {
418             coloredTokens[_colorIndex].depositAllowances[msg.sender] -= _tokens * _to.length;
419         }
420     }
421 
422     //-------------------------------------------------------------------------
423     /// @notice Spend `(tokens/1000000000000000000).fixed(0,18)` colored 
424     ///  tokens with index `_colorIndex`.
425     /// @dev Throws if tokens to spend is zero. Throws if colorIndex is
426     ///  greater than number of colored tokens. Throws if AAC with uid#`_from`
427     ///  has insufficient balance to spend.
428     /// @param _colorIndex The index of the color to spend.
429     /// @param _from The UID of the AAC to spend from.
430     /// @param _tokens The number of colored tokens to spend.
431     /// @return True if spend successful. Throw if unsuccessful.
432     //-------------------------------------------------------------------------
433     function spend (uint _colorIndex, uint _from, uint _tokens) 
434         external 
435         notZero(_tokens)
436         returns(bool) 
437     {
438         // colorIndex must be valid color
439         require (_colorIndex < coloredTokens.length, "Invalid color index");
440         // sender must own AAC
441         require (
442             msg.sender == aacContract.ownerOf(_from), 
443             "Sender is not owner of AAC"
444         );
445         // token owner's balance must be enough to spend tokens
446         require (
447             coloredTokens[_colorIndex].balances[_from] >= _tokens,
448             "Insufficient tokens to spend"
449         );
450         // deduct the tokens from the sender's balance
451         coloredTokens[_colorIndex].balances[_from] -= _tokens;
452         // emit spend event
453         emit SpendColor(_from, _colorIndex, _tokens);
454         return true;
455     }
456 
457     //-------------------------------------------------------------------------
458     /// @notice Spend `(tokens/1000000000000000000).fixed(0,18)` colored
459     ///  tokens with color index `_colorIndex` from AAC with uid#`_from`.
460     /// @dev Throws if tokens to spend is zero. Throws if colorIndex is 
461     ///  greater than number of colored tokens. Throws if sender is not
462     ///  an authorized operator of AAC. Throws if `from` has insufficient
463     ///  balance to spend.
464     /// @param _colorIndex The index of the color to spend.
465     /// @param _from The address whose colored tokens are being spent.
466     /// @param _tokens The number of tokens to send.
467     /// @return True if spend successful. Throw if unsuccessful.
468     //-------------------------------------------------------------------------
469     function spendFrom(uint _colorIndex, uint _from, uint _tokens)
470         external 
471         notZero(_tokens)
472         returns (bool) 
473     {
474         // colorIndex must be valid color
475         require (_colorIndex < coloredTokens.length, "Invalid color index");
476         // sender must be authorized address or operator for AAC
477         require (
478             msg.sender == aacContract.getApproved(_from) ||
479             aacContract.isApprovedForAll(aacContract.ownerOf(_from), msg.sender), 
480             "Sender is not authorized operator for AAC"
481         );
482         // token owner's balance must be enough to spend tokens
483         require (
484             coloredTokens[_colorIndex].balances[_from] >= _tokens,
485             "Insufficient balance to spend"
486         );
487         // deduct the tokens from token owner's balance
488         coloredTokens[_colorIndex].balances[_from] -= _tokens;
489         // emit spend event
490         emit SpendColor(_from, _colorIndex, _tokens);
491         return true;
492     }
493 
494     //-------------------------------------------------------------------------
495     /// @notice Transfer balances of colored tokens to new uid. AAC contract
496     ///  only.
497     /// @dev throws unless sent by AAC contract
498     //-------------------------------------------------------------------------
499     function onLink(uint _oldUid, uint _newUid) external {
500         require (msg.sender == address(aacContract), "Unauthorized transaction");
501         require (_oldUid > UID_MAX && _newUid <= UID_MAX);
502         for(uint i = 0; i < coloredTokens.length; ++i) {
503             coloredTokens[i].balances[_newUid] = coloredTokens[i].balances[_oldUid];
504         }
505     }
506     
507     //-------------------------------------------------------------------------
508     /// @notice Get the number of colored tokens with color index `_colorIndex`
509     ///  owned by AAC #`_uid`.
510     /// @param _uid The AAC with deposited color tokens.
511     /// @param _colorIndex Index of the colored token to query.
512     /// @return The number of colored tokens with color index `_colorIndex`
513     ///  owned by AAC #`_uid`.
514     //-------------------------------------------------------------------------
515     function getColoredTokenBalance(uint _uid, uint _colorIndex) 
516         external 
517         view 
518         returns(uint) 
519     {
520         return coloredTokens[_colorIndex].balances[_uid];
521     }
522 
523     //-------------------------------------------------------------------------
524     /// @notice Count the number of colored token types
525     /// @return Number of colored token types
526     //-------------------------------------------------------------------------
527     function coloredTokenCount() external view returns (uint) {
528         return coloredTokens.length;
529     }
530 
531     //-------------------------------------------------------------------------
532     /// @notice Get the name and creator address of colored token with index
533     ///  `_colorIndex`
534     /// @param _colorIndex Index of the colored token to query.
535     /// @return The creator address and name of colored token.
536     //-------------------------------------------------------------------------
537     function getColoredToken(uint _colorIndex) 
538         external 
539         view 
540         returns(address, string memory)
541     {
542         return (
543             coloredTokens[_colorIndex].creator, 
544             coloredTokens[_colorIndex].name
545         );
546     }
547 }