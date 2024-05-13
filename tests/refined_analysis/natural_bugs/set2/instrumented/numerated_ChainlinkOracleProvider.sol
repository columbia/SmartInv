1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../access/Authorization.sol";
5 
6 import "../../interfaces/oracles/IChainlinkOracleProvider.sol";
7 import "../../interfaces/vendor/ChainlinkAggregator.sol";
8 
9 import "../../libraries/Errors.sol";
10 import "../../libraries/DecimalScale.sol";
11 
12 contract ChainlinkOracleProvider is IChainlinkOracleProvider, Authorization {
13     using DecimalScale for uint256;
14 
15     uint256 public stalePriceDelay;
16 
17     mapping(address => address) public feeds;
18 
19     event FeedUpdated(address indexed asset, address indexed previousFeed, address indexed newFeed);
20 
21     constructor(IRoleManager roleManager, address ethFeed) Authorization(roleManager) {
22         feeds[address(0)] = ethFeed;
23         stalePriceDelay = 2 hours;
24     }
25 
26     /// @notice Allows to set Chainlink feeds
27     /// @dev All feeds should be set relative to USD.
28     /// This can only be called by governance
29     function setFeed(address asset, address feed) external override onlyGovernance {
30         address previousFeed = feeds[asset];
31         require(feed != previousFeed, Error.INVALID_ARGUMENT);
32         feeds[asset] = feed;
33         emit FeedUpdated(asset, previousFeed, feed);
34     }
35 
36     /**
37      * @notice Sets the stake price delay value.
38      * @param stalePriceDelay_ The new stale price delay to set.
39      */
40     function setStalePriceDelay(uint256 stalePriceDelay_) external override onlyGovernance {
41         require(stalePriceDelay_ >= 1 hours, Error.INVALID_ARGUMENT);
42         stalePriceDelay = stalePriceDelay_;
43     }
44 
45     /// @inheritdoc IOracleProvider
46     function getPriceETH(address asset) external view override returns (uint256) {
47         return (getPriceUSD(asset) * 1e18) / getPriceUSD(address(0));
48     }
49 
50     /// @inheritdoc IOracleProvider
51     function getPriceUSD(address asset) public view override returns (uint256) {
52         address feed = feeds[asset];
53         require(feed != address(0), Error.ASSET_NOT_SUPPORTED);
54 
55         (, int256 answer, , uint256 updatedAt, ) = AggregatorV2V3Interface(feed).latestRoundData();
56 
57         require(block.timestamp <= updatedAt + stalePriceDelay, Error.STALE_PRICE);
58         require(answer >= 0, Error.NEGATIVE_PRICE);
59 
60         uint256 price = uint256(answer);
61         uint8 decimals = AggregatorV2V3Interface(feed).decimals();
62         return price.scaleFrom(decimals);
63     }
64 }
