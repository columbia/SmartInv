1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "@sushiswap/bentobox-sdk/contracts/IStrategy.sol";
4 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
5 import "@boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol";
6 
7 // solhint-disable not-rely-on-time
8 
9 contract SimpleStrategyMock is IStrategy {
10     using BoringMath for uint256;
11     using BoringERC20 for IERC20;
12 
13     IERC20 private immutable token;
14     address private immutable bentoBox;
15 
16     modifier onlyBentoBox() {
17         require(msg.sender == bentoBox, "Ownable: caller is not the owner");
18         _;
19     }
20 
21     constructor(address bentoBox_, IERC20 token_) public {
22         bentoBox = bentoBox_;
23         token = token_;
24     }
25 
26     // Send the assets to the Strategy and call skim to invest them
27     function skim(uint256) external override onlyBentoBox {
28         // Leave the tokens on the contract
29         return;
30     }
31 
32     // Harvest any profits made converted to the asset and pass them to the caller
33     function harvest(uint256 balance, address) external override onlyBentoBox returns (int256 amountAdded) {
34         amountAdded = int256(token.balanceOf(address(this)).sub(balance));
35         token.safeTransfer(bentoBox, uint256(amountAdded)); // Add as profit
36     }
37 
38     // Withdraw assets. The returned amount can differ from the requested amount due to rounding or if the request was more than there is.
39     function withdraw(uint256 amount) external override onlyBentoBox returns (uint256 actualAmount) {
40         token.safeTransfer(bentoBox, uint256(amount)); // Add as profit
41         actualAmount = amount;
42     }
43 
44     // Withdraw all assets in the safest way possible. This shouldn't fail.
45     function exit(uint256 balance) external override onlyBentoBox returns (int256 amountAdded) {
46         amountAdded = 0;
47         token.safeTransfer(bentoBox, balance);
48     }
49 }
