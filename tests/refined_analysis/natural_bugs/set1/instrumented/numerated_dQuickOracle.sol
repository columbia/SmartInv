1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 import "../interfaces/IOracle.sol";
4 import "@boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol";
5 import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
6 
7 interface IAggregator {
8     function latestAnswer() external view returns (int256 answer);
9 }
10 
11 /// @title xSUSHIOracle
12 /// @author BoringCrypto
13 /// @notice Oracle used for getting the price of xSUSHI based on Chainlink
14 /// @dev
15 contract xSUSHIOracle is IOracle {
16     using BoringMath for uint256; // Keep everything in uint256
17 
18     IERC20 public immutable sushi;
19     IERC20 public immutable bar;
20     IAggregator public immutable sushiOracle;
21 
22     constructor(
23         IERC20 sushi_,
24         IERC20 bar_,
25         IAggregator sushiOracle_
26     ) public {
27         sushi = sushi_;
28         bar = bar_;
29         sushiOracle = sushiOracle_;
30     }
31 
32     // Calculates the lastest exchange rate
33     // Uses sushi rate and xSUSHI conversion and divide for any conversion other than from SUSHI to ETH
34     function _get(address divide, uint256 decimals) internal view returns (uint256) {
35         uint256 price = uint256(1e36);
36         price = (price.mul(uint256(sushiOracle.latestAnswer())) / bar.totalSupply()).mul(sushi.balanceOf(address(bar)));
37 
38         if (divide != address(0)) {
39             price = price / uint256(IAggregator(divide).latestAnswer());
40         }
41 
42         return price / decimals;
43     }
44 
45     function getDataParameter(address divide, uint256 decimals) public pure returns (bytes memory) {
46         return abi.encode(divide, decimals);
47     }
48 
49     // Get the latest exchange rate
50     /// @inheritdoc IOracle
51     function get(bytes calldata data) public override returns (bool, uint256) {
52         (address divide, uint256 decimals) = abi.decode(data, (address, uint256));
53         return (true, _get(divide, decimals));
54     }
55 
56     // Check the last exchange rate without any state changes
57     /// @inheritdoc IOracle
58     function peek(bytes calldata data) public view override returns (bool, uint256) {
59         (address divide, uint256 decimals) = abi.decode(data, (address, uint256));
60         return (true, _get(divide, decimals));
61     }
62 
63     // Check the current spot exchange rate without any state changes
64     /// @inheritdoc IOracle
65     function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
66         (, rate) = peek(data);
67     }
68 
69     /// @inheritdoc IOracle
70     function name(bytes calldata) public view override returns (string memory) {
71         return "xSUSHI Chainlink";
72     }
73 
74     /// @inheritdoc IOracle
75     function symbol(bytes calldata) public view override returns (string memory) {
76         return "xSUSHI-LINK";
77     }
78 }
