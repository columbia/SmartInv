1 pragma solidity ^0.5.16;
2 
3 import "./PriceOracle.sol";
4 import "../CErc20.sol";
5 
6 contract SimplePriceOracle is PriceOracle {
7     mapping(address => uint256) prices;
8     event PricePosted(
9         address asset,
10         uint256 previousPriceMantissa,
11         uint256 requestedPriceMantissa,
12         uint256 newPriceMantissa
13     );
14 
15     function getUnderlyingPrice(CToken cToken) public view returns (uint256) {
16         if (compareStrings(cToken.symbol(), "crETH")) {
17             return 1e18;
18         } else {
19             return prices[address(CErc20(address(cToken)).underlying())];
20         }
21     }
22 
23     function setUnderlyingPrice(CToken cToken, uint256 underlyingPriceMantissa) public {
24         address asset = address(CErc20(address(cToken)).underlying());
25         emit PricePosted(asset, prices[asset], underlyingPriceMantissa, underlyingPriceMantissa);
26         prices[asset] = underlyingPriceMantissa;
27     }
28 
29     function setDirectPrice(address asset, uint256 price) public {
30         emit PricePosted(asset, prices[asset], price, price);
31         prices[asset] = price;
32     }
33 
34     // v1 price oracle interface for use as backing of proxy
35     function assetPrices(address asset) external view returns (uint256) {
36         return prices[asset];
37     }
38 
39     function compareStrings(string memory a, string memory b) internal pure returns (bool) {
40         return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
41     }
42 }
