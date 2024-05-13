1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../libraries/DecimalScale.sol";
5 
6 interface IChainlinkOracle {
7     function latestRoundData()
8         external
9         view
10         returns (
11             uint80 roundId,
12             int256 answer,
13             uint256 startedAt,
14             uint256 updatedAt,
15             uint80 answeredInRound
16         );
17 
18     function decimals() external view returns (uint8);
19 }
20 
21 /**
22  * Wrapper used for converting a Chainlink ETH Oracle to a USD Oracle.
23  */
24 contract ChainlinkUsdWrapper is IChainlinkOracle {
25     using DecimalScale for uint256;
26 
27     IChainlinkOracle private immutable _ethOracle =
28         IChainlinkOracle(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
29     IChainlinkOracle private immutable _oracle;
30     uint8 private immutable _decimals;
31 
32     constructor(address oracle_) {
33         _oracle = IChainlinkOracle(oracle_);
34         _decimals = IChainlinkOracle(oracle_).decimals();
35     }
36 
37     function latestRoundData()
38         external
39         view
40         override
41         returns (
42             uint80 roundId,
43             int256 answer,
44             uint256 startedAt,
45             uint256 updatedAt,
46             uint80 answeredInRound
47         )
48     {
49         (
50             uint80 roundId_,
51             int256 answer_,
52             uint256 startedAt_,
53             uint256 updatedAt_,
54             uint80 answeredInRound_
55         ) = _oracle.latestRoundData();
56         return (roundId_, (answer_ * _ethPrice()) / 1e8, startedAt_, updatedAt_, answeredInRound_);
57     }
58 
59     function decimals() external view override returns (uint8) {
60         return _decimals;
61     }
62 
63     function _ethPrice() private view returns (int256) {
64         (, int256 answer, , , ) = _ethOracle.latestRoundData();
65         return answer;
66     }
67 }
