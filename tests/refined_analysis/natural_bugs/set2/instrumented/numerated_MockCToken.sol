1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 interface CToken {
8     function redeemUnderlying(uint256 redeemAmount) external returns (uint256);
9 
10     function exchangeRateStored() external view returns (uint256);
11 
12     function balanceOf(address account) external view returns (uint256);
13 }
14 
15 contract MockCToken is MockERC20 {
16     IERC20 public token;
17     bool public error;
18     bool public isCEther;
19 
20     uint256 private constant EXCHANGE_RATE_SCALE = 1e18;
21     uint256 public effectiveExchangeRate = 2;
22 
23     constructor(IERC20 _token, bool _isCEther) {
24         token = _token;
25         isCEther = _isCEther;
26     }
27 
28     function setError(bool _error) external {
29         error = _error;
30     }
31 
32     function isCToken() external pure returns (bool) {
33         return true;
34     }
35 
36     function underlying() external view returns (address) {
37         return address(token);
38     }
39 
40     function mint() external payable {
41         _mint(msg.sender, msg.value / effectiveExchangeRate);
42     }
43 
44     function mint(uint256 amount) external returns (uint256) {
45         token.transferFrom(msg.sender, address(this), amount);
46         _mint(msg.sender, amount / effectiveExchangeRate);
47         return error ? 1 : 0;
48     }
49 
50     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
51         _burn(msg.sender, redeemAmount / effectiveExchangeRate);
52         if (address(this).balance >= redeemAmount) {
53             payable(msg.sender).transfer(redeemAmount);
54         } else {
55             token.transfer(msg.sender, redeemAmount);
56         }
57         return error ? 1 : 0;
58     }
59 
60     function exchangeRateStored() external view returns (uint256) {
61         return EXCHANGE_RATE_SCALE * effectiveExchangeRate; // 2:1
62     }
63 }
