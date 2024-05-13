1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 import "solmate/tokens/ERC20.sol";
5 import "solmate/tokens/ERC721.sol";
6 import "solmate/utils/MerkleProofLib.sol";
7 import "solmate/utils/SafeTransferLib.sol";
8 import "openzeppelin/utils/math/Math.sol";
9 
10 import "./LpToken.sol";
11 import "./Caviar.sol";
12 
13 /// @title Pair
14 /// @author out.eth (@outdoteth)
15 /// @notice A pair of an NFT and a base token that can be used to create and trade fractionalized NFTs.
16 contract Pair is ERC20, ERC721TokenReceiver {
17     using SafeTransferLib for address;
18     using SafeTransferLib for ERC20;
19 
20     uint256 public constant ONE = 1e18;
21     uint256 public constant CLOSE_GRACE_PERIOD = 7 days;
22 
23     address public immutable nft;
24     address public immutable baseToken; // address(0) for ETH
25     bytes32 public immutable merkleRoot;
26     LpToken public immutable lpToken;
27     Caviar public immutable caviar;
28     uint256 public closeTimestamp;
29 
30     event Add(uint256 baseTokenAmount, uint256 fractionalTokenAmount, uint256 lpTokenAmount);
31     event Remove(uint256 baseTokenAmount, uint256 fractionalTokenAmount, uint256 lpTokenAmount);
32     event Buy(uint256 inputAmount, uint256 outputAmount);
33     event Sell(uint256 inputAmount, uint256 outputAmount);
34     event Wrap(uint256[] tokenIds);
35     event Unwrap(uint256[] tokenIds);
36     event Close(uint256 closeTimestamp);
37     event Withdraw(uint256 tokenId);
38 
39     constructor(
40         address _nft,
41         address _baseToken,
42         bytes32 _merkleRoot,
43         string memory pairSymbol,
44         string memory nftName,
45         string memory nftSymbol
46     ) ERC20(string.concat(nftName, " fractional token"), string.concat("f", nftSymbol), 18) {
47         nft = _nft;
48         baseToken = _baseToken; // use address(0) for native ETH
49         merkleRoot = _merkleRoot;
50         lpToken = new LpToken(pairSymbol);
51         caviar = Caviar(msg.sender);
52     }
53 
54     // ************************ //
55     //      Core AMM logic      //
56     // ***********************  //
57 
58     /// @notice Adds liquidity to the pair.
59     /// @param baseTokenAmount The amount of base tokens to add.
60     /// @param fractionalTokenAmount The amount of fractional tokens to add.
61     /// @param minLpTokenAmount The minimum amount of LP tokens to mint.
62     /// @return lpTokenAmount The amount of LP tokens minted.
63     function add(uint256 baseTokenAmount, uint256 fractionalTokenAmount, uint256 minLpTokenAmount)
64         public
65         payable
66         returns (uint256 lpTokenAmount)
67     {
68         // *** Checks *** //
69 
70         // check the token amount inputs are not zero
71         require(baseTokenAmount > 0 && fractionalTokenAmount > 0, "Input token amount is zero");
72 
73         // check that correct eth input was sent - if the baseToken equals address(0) then native ETH is used
74         require(baseToken == address(0) ? msg.value == baseTokenAmount : msg.value == 0, "Invalid ether input");
75 
76         // calculate the lp token shares to mint
77         lpTokenAmount = addQuote(baseTokenAmount, fractionalTokenAmount);
78 
79         // check that the amount of lp tokens outputted is greater than the min amount
80         require(lpTokenAmount >= minLpTokenAmount, "Slippage: lp token amount out");
81 
82         // *** Effects *** //
83 
84         // transfer fractional tokens in
85         _transferFrom(msg.sender, address(this), fractionalTokenAmount);
86 
87         // *** Interactions *** //
88 
89         // mint lp tokens to sender
90         lpToken.mint(msg.sender, lpTokenAmount);
91 
92         // transfer base tokens in if the base token is not ETH
93         if (baseToken != address(0)) {
94             // transfer base tokens in
95             ERC20(baseToken).safeTransferFrom(msg.sender, address(this), baseTokenAmount);
96         }
97 
98         emit Add(baseTokenAmount, fractionalTokenAmount, lpTokenAmount);
99     }
100 
101     /// @notice Removes liquidity from the pair.
102     /// @param lpTokenAmount The amount of LP tokens to burn.
103     /// @param minBaseTokenOutputAmount The minimum amount of base tokens to receive.
104     /// @param minFractionalTokenOutputAmount The minimum amount of fractional tokens to receive.
105     /// @return baseTokenOutputAmount The amount of base tokens received.
106     /// @return fractionalTokenOutputAmount The amount of fractional tokens received.
107     function remove(uint256 lpTokenAmount, uint256 minBaseTokenOutputAmount, uint256 minFractionalTokenOutputAmount)
108         public
109         returns (uint256 baseTokenOutputAmount, uint256 fractionalTokenOutputAmount)
110     {
111         // *** Checks *** //
112 
113         // calculate the output amounts
114         (baseTokenOutputAmount, fractionalTokenOutputAmount) = removeQuote(lpTokenAmount);
115 
116         // check that the base token output amount is greater than the min amount
117         require(baseTokenOutputAmount >= minBaseTokenOutputAmount, "Slippage: base token amount out");
118 
119         // check that the fractional token output amount is greater than the min amount
120         require(fractionalTokenOutputAmount >= minFractionalTokenOutputAmount, "Slippage: fractional token out");
121 
122         // *** Effects *** //
123 
124         // transfer fractional tokens to sender
125         _transferFrom(address(this), msg.sender, fractionalTokenOutputAmount);
126 
127         // *** Interactions *** //
128 
129         // burn lp tokens from sender
130         lpToken.burn(msg.sender, lpTokenAmount);
131 
132         if (baseToken == address(0)) {
133             // if base token is native ETH then send ether to sender
134             msg.sender.safeTransferETH(baseTokenOutputAmount);
135         } else {
136             // transfer base tokens to sender
137             ERC20(baseToken).safeTransfer(msg.sender, baseTokenOutputAmount);
138         }
139 
140         emit Remove(baseTokenOutputAmount, fractionalTokenOutputAmount, lpTokenAmount);
141     }
142 
143     /// @notice Buys fractional tokens from the pair.
144     /// @param outputAmount The amount of fractional tokens to buy.
145     /// @param maxInputAmount The maximum amount of base tokens to spend.
146     /// @return inputAmount The amount of base tokens spent.
147     function buy(uint256 outputAmount, uint256 maxInputAmount) public payable returns (uint256 inputAmount) {
148         // *** Checks *** //
149 
150         // check that correct eth input was sent - if the baseToken equals address(0) then native ETH is used
151         require(baseToken == address(0) ? msg.value == maxInputAmount : msg.value == 0, "Invalid ether input");
152 
153         // calculate required input amount using xyk invariant
154         inputAmount = buyQuote(outputAmount);
155 
156         // check that the required amount of base tokens is less than the max amount
157         require(inputAmount <= maxInputAmount, "Slippage: amount in");
158 
159         // *** Effects *** //
160 
161         // transfer fractional tokens to sender
162         _transferFrom(address(this), msg.sender, outputAmount);
163 
164         // *** Interactions *** //
165 
166         if (baseToken == address(0)) {
167             // refund surplus eth
168             uint256 refundAmount = maxInputAmount - inputAmount;
169             if (refundAmount > 0) msg.sender.safeTransferETH(refundAmount);
170         } else {
171             // transfer base tokens in
172             ERC20(baseToken).safeTransferFrom(msg.sender, address(this), inputAmount);
173         }
174 
175         emit Buy(inputAmount, outputAmount);
176     }
177 
178     /// @notice Sells fractional tokens to the pair.
179     /// @param inputAmount The amount of fractional tokens to sell.
180     /// @param minOutputAmount The minimum amount of base tokens to receive.
181     /// @return outputAmount The amount of base tokens received.
182     function sell(uint256 inputAmount, uint256 minOutputAmount) public returns (uint256 outputAmount) {
183         // *** Checks *** //
184 
185         // calculate output amount using xyk invariant
186         outputAmount = sellQuote(inputAmount);
187 
188         // check that the outputted amount of fractional tokens is greater than the min amount
189         require(outputAmount >= minOutputAmount, "Slippage: amount out");
190 
191         // *** Effects *** //
192 
193         // transfer fractional tokens from sender
194         _transferFrom(msg.sender, address(this), inputAmount);
195 
196         // *** Interactions *** //
197 
198         if (baseToken == address(0)) {
199             // transfer ether out
200             msg.sender.safeTransferETH(outputAmount);
201         } else {
202             // transfer base tokens out
203             ERC20(baseToken).safeTransfer(msg.sender, outputAmount);
204         }
205 
206         emit Sell(inputAmount, outputAmount);
207     }
208 
209     // ******************** //
210     //      Wrap logic      //
211     // ******************** //
212 
213     /// @notice Wraps NFTs into fractional tokens.
214     /// @param tokenIds The ids of the NFTs to wrap.
215     /// @param proofs The merkle proofs for the NFTs proving that they can be used in the pair.
216     /// @return fractionalTokenAmount The amount of fractional tokens minted.
217     function wrap(uint256[] calldata tokenIds, bytes32[][] calldata proofs)
218         public
219         returns (uint256 fractionalTokenAmount)
220     {
221         // *** Checks *** //
222 
223         // check that wrapping is not closed
224         require(closeTimestamp == 0, "Wrap: closed");
225 
226         // check the tokens exist in the merkle root
227         _validateTokenIds(tokenIds, proofs);
228 
229         // *** Effects *** //
230 
231         // mint fractional tokens to sender
232         fractionalTokenAmount = tokenIds.length * ONE;
233         _mint(msg.sender, fractionalTokenAmount);
234 
235         // *** Interactions *** //
236 
237         // transfer nfts from sender
238         for (uint256 i = 0; i < tokenIds.length; i++) {
239             ERC721(nft).safeTransferFrom(msg.sender, address(this), tokenIds[i]);
240         }
241 
242         emit Wrap(tokenIds);
243     }
244 
245     /// @notice Unwraps fractional tokens into NFTs.
246     /// @param tokenIds The ids of the NFTs to unwrap.
247     /// @return fractionalTokenAmount The amount of fractional tokens burned.
248     function unwrap(uint256[] calldata tokenIds) public returns (uint256 fractionalTokenAmount) {
249         // *** Effects *** //
250 
251         // burn fractional tokens from sender
252         fractionalTokenAmount = tokenIds.length * ONE;
253         _burn(msg.sender, fractionalTokenAmount);
254 
255         // *** Interactions *** //
256 
257         // transfer nfts to sender
258         for (uint256 i = 0; i < tokenIds.length; i++) {
259             ERC721(nft).safeTransferFrom(address(this), msg.sender, tokenIds[i]);
260         }
261 
262         emit Unwrap(tokenIds);
263     }
264 
265     // *********************** //
266     //      NFT AMM logic      //
267     // *********************** //
268 
269     /// @notice nftAdd Adds liquidity to the pair using NFTs.
270     /// @param baseTokenAmount The amount of base tokens to add.
271     /// @param tokenIds The ids of the NFTs to add.
272     /// @param minLpTokenAmount The minimum amount of lp tokens to receive.
273     /// @param proofs The merkle proofs for the NFTs.
274     /// @return lpTokenAmount The amount of lp tokens minted.
275     function nftAdd(
276         uint256 baseTokenAmount,
277         uint256[] calldata tokenIds,
278         uint256 minLpTokenAmount,
279         bytes32[][] calldata proofs
280     ) public payable returns (uint256 lpTokenAmount) {
281         // wrap the incoming NFTs into fractional tokens
282         uint256 fractionalTokenAmount = wrap(tokenIds, proofs);
283 
284         // add liquidity using the fractional tokens and base tokens
285         lpTokenAmount = add(baseTokenAmount, fractionalTokenAmount, minLpTokenAmount);
286     }
287 
288     /// @notice Removes liquidity from the pair using NFTs.
289     /// @param lpTokenAmount The amount of lp tokens to remove.
290     /// @param minBaseTokenOutputAmount The minimum amount of base tokens to receive.
291     /// @param tokenIds The ids of the NFTs to remove.
292     /// @return baseTokenOutputAmount The amount of base tokens received.
293     /// @return fractionalTokenOutputAmount The amount of fractional tokens received.
294     function nftRemove(uint256 lpTokenAmount, uint256 minBaseTokenOutputAmount, uint256[] calldata tokenIds)
295         public
296         returns (uint256 baseTokenOutputAmount, uint256 fractionalTokenOutputAmount)
297     {
298         // remove liquidity and send fractional tokens and base tokens to sender
299         (baseTokenOutputAmount, fractionalTokenOutputAmount) =
300             remove(lpTokenAmount, minBaseTokenOutputAmount, tokenIds.length * ONE);
301 
302         // unwrap the fractional tokens into NFTs and send to sender
303         unwrap(tokenIds);
304     }
305 
306     /// @notice Buys NFTs from the pair using base tokens.
307     /// @param tokenIds The ids of the NFTs to buy.
308     /// @param maxInputAmount The maximum amount of base tokens to spend.
309     /// @return inputAmount The amount of base tokens spent.
310     function nftBuy(uint256[] calldata tokenIds, uint256 maxInputAmount) public payable returns (uint256 inputAmount) {
311         // buy fractional tokens using base tokens
312         inputAmount = buy(tokenIds.length * ONE, maxInputAmount);
313 
314         // unwrap the fractional tokens into NFTs and send to sender
315         unwrap(tokenIds);
316     }
317 
318     /// @notice Sells NFTs to the pair for base tokens.
319     /// @param tokenIds The ids of the NFTs to sell.
320     /// @param minOutputAmount The minimum amount of base tokens to receive.
321     /// @param proofs The merkle proofs for the NFTs.
322     /// @return outputAmount The amount of base tokens received.
323     function nftSell(uint256[] calldata tokenIds, uint256 minOutputAmount, bytes32[][] calldata proofs)
324         public
325         returns (uint256 outputAmount)
326     {
327         // wrap the incoming NFTs into fractional tokens
328         uint256 inputAmount = wrap(tokenIds, proofs);
329 
330         // sell fractional tokens for base tokens
331         outputAmount = sell(inputAmount, minOutputAmount);
332     }
333 
334     // ****************************** //
335     //      Emergency exit logic      //
336     // ****************************** //
337 
338     /// @notice Closes the pair to new wraps.
339     /// @dev Can only be called by the caviar owner. This is used as an emergency exit in case
340     ///      the caviar owner suspects that the pair has been compromised.
341     function close() public {
342         // check that the sender is the caviar owner
343         require(caviar.owner() == msg.sender, "Close: not owner");
344 
345         // set the close timestamp with a grace period
346         closeTimestamp = block.timestamp + CLOSE_GRACE_PERIOD;
347 
348         // remove the pair from the Caviar contract
349         caviar.destroy(nft, baseToken, merkleRoot);
350 
351         emit Close(closeTimestamp);
352     }
353 
354     /// @notice Withdraws a particular NFT from the pair.
355     /// @dev Can only be called by the caviar owner after the close grace period has passed. This
356     ///      is used to auction off the NFTs in the pair in case NFTs get stuck due to liquidity
357     ///      imbalances. Proceeds from the auction should be distributed pro rata to fractional
358     ///      token holders. See documentation for more details.
359     function withdraw(uint256 tokenId) public {
360         // check that the sender is the caviar owner
361         require(caviar.owner() == msg.sender, "Withdraw: not owner");
362 
363         // check that the close period has been set
364         require(closeTimestamp != 0, "Withdraw not initiated");
365 
366         // check that the close grace period has passed
367         require(block.timestamp >= closeTimestamp, "Not withdrawable yet");
368 
369         // transfer the nft to the caviar owner
370         ERC721(nft).safeTransferFrom(address(this), msg.sender, tokenId);
371 
372         emit Withdraw(tokenId);
373     }
374 
375     // ***************** //
376     //      Getters      //
377     // ***************** //
378 
379     function baseTokenReserves() public view returns (uint256) {
380         return _baseTokenReserves();
381     }
382 
383     function fractionalTokenReserves() public view returns (uint256) {
384         return balanceOf[address(this)];
385     }
386 
387     /// @notice The current price of one fractional token in base tokens with 18 decimals of precision.
388     /// @dev Calculated by dividing the base token reserves by the fractional token reserves.
389     /// @return price The price of one fractional token in base tokens * 1e18.
390     function price() public view returns (uint256) {
391         return (_baseTokenReserves() * ONE) / fractionalTokenReserves();
392     }
393 
394     /// @notice The amount of base tokens required to buy a given amount of fractional tokens.
395     /// @dev Calculated using the xyk invariant and a 30bps fee.
396     /// @param outputAmount The amount of fractional tokens to buy.
397     /// @return inputAmount The amount of base tokens required.
398     function buyQuote(uint256 outputAmount) public view returns (uint256) {
399         return (outputAmount * 1000 * baseTokenReserves()) / ((fractionalTokenReserves() - outputAmount) * 997);
400     }
401 
402     /// @notice The amount of base tokens received for selling a given amount of fractional tokens.
403     /// @dev Calculated using the xyk invariant and a 30bps fee.
404     /// @param inputAmount The amount of fractional tokens to sell.
405     /// @return outputAmount The amount of base tokens received.
406     function sellQuote(uint256 inputAmount) public view returns (uint256) {
407         uint256 inputAmountWithFee = inputAmount * 997;
408         return (inputAmountWithFee * baseTokenReserves()) / ((fractionalTokenReserves() * 1000) + inputAmountWithFee);
409     }
410 
411     /// @notice The amount of lp tokens received for adding a given amount of base tokens and fractional tokens.
412     /// @dev Calculated as a share of existing deposits. If there are no existing deposits, then initializes to
413     ///      sqrt(baseTokenAmount * fractionalTokenAmount).
414     /// @param baseTokenAmount The amount of base tokens to add.
415     /// @param fractionalTokenAmount The amount of fractional tokens to add.
416     /// @return lpTokenAmount The amount of lp tokens received.
417     function addQuote(uint256 baseTokenAmount, uint256 fractionalTokenAmount) public view returns (uint256) {
418         uint256 lpTokenSupply = lpToken.totalSupply();
419         if (lpTokenSupply > 0) {
420             // calculate amount of lp tokens as a fraction of existing reserves
421             uint256 baseTokenShare = (baseTokenAmount * lpTokenSupply) / baseTokenReserves();
422             uint256 fractionalTokenShare = (fractionalTokenAmount * lpTokenSupply) / fractionalTokenReserves();
423             return Math.min(baseTokenShare, fractionalTokenShare);
424         } else {
425             // if there is no liquidity then init
426             return Math.sqrt(baseTokenAmount * fractionalTokenAmount);
427         }
428     }
429 
430     /// @notice The amount of base tokens and fractional tokens received for burning a given amount of lp tokens.
431     /// @dev Calculated as a share of existing deposits.
432     /// @param lpTokenAmount The amount of lp tokens to burn.
433     /// @return baseTokenAmount The amount of base tokens received.
434     /// @return fractionalTokenAmount The amount of fractional tokens received.
435     function removeQuote(uint256 lpTokenAmount) public view returns (uint256, uint256) {
436         uint256 lpTokenSupply = lpToken.totalSupply();
437         uint256 baseTokenOutputAmount = (baseTokenReserves() * lpTokenAmount) / lpTokenSupply;
438         uint256 fractionalTokenOutputAmount = (fractionalTokenReserves() * lpTokenAmount) / lpTokenSupply;
439 
440         return (baseTokenOutputAmount, fractionalTokenOutputAmount);
441     }
442 
443     // ************************ //
444     //      Internal utils      //
445     // ************************ //
446 
447     function _transferFrom(address from, address to, uint256 amount) internal returns (bool) {
448         balanceOf[from] -= amount;
449 
450         // Cannot overflow because the sum of all user
451         // balances can't exceed the max uint256 value.
452         unchecked {
453             balanceOf[to] += amount;
454         }
455 
456         emit Transfer(from, to, amount);
457 
458         return true;
459     }
460 
461     /// @dev Validates that the given tokenIds are valid for the contract's merkle root. Reverts
462     ///      if any of the tokenId proofs are invalid.
463     function _validateTokenIds(uint256[] calldata tokenIds, bytes32[][] calldata proofs) internal view {
464         // if merkle root is not set then all tokens are valid
465         if (merkleRoot == bytes23(0)) return;
466 
467         // validate merkle proofs against merkle root
468         for (uint256 i = 0; i < tokenIds.length; i++) {
469             bool isValid = MerkleProofLib.verify(proofs[i], merkleRoot, keccak256(abi.encodePacked(tokenIds[i])));
470             require(isValid, "Invalid merkle proof");
471         }
472     }
473 
474     /// @dev Returns the current base token reserves. If the base token is ETH then it ignores
475     ///      the msg.value that is being sent in the current call context - this is to ensure the
476     ///      xyk math is correct in the buy() and add() functions.
477     function _baseTokenReserves() internal view returns (uint256) {
478         return baseToken == address(0)
479             ? address(this).balance - msg.value // subtract the msg.value if the base token is ETH
480             : ERC20(baseToken).balanceOf(address(this));
481     }
482 }
