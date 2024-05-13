1 pragma solidity ^0.8.4;
2 
3 import "./PegExchanger.sol";
4 
5 contract PegExchangerDripper {
6     IERC20 public constant TRIBE = IERC20(0xc7283b66Eb1EB5FB86327f08e1B5816b0720212B);
7     address public constant CORE = 0x8d5ED43dCa8C2F7dFB20CF7b53CC7E593635d7b9;
8     address public constant PEG_EXCHANGER = 0xc09BB5ECf865e6f69Fe62A43c27f036A426909f7;
9 
10     uint256 public constant THRESHOLD = 5_000_000e18; // 5M TRIBE cutoff for dripping
11     uint256 public constant DRIP_AMOUNT = 20_000_000e18; // drip 20M TRIBE
12 
13     function drip() external {
14         require(!PegExchanger(PEG_EXCHANGER).isExpired(), "expired"); // ensure pegExchanger live
15         require(TRIBE.balanceOf(PEG_EXCHANGER) <= THRESHOLD, "over threshold"); // ensure under drip threshold
16         TRIBE.transfer(PEG_EXCHANGER, DRIP_AMOUNT);
17     }
18 
19     function isEligible() external view returns (bool) {
20         return !PegExchanger(PEG_EXCHANGER).isExpired() && TRIBE.balanceOf(PEG_EXCHANGER) <= THRESHOLD;
21     }
22 
23     function recover() external {
24         require(PegExchanger(PEG_EXCHANGER).isExpired(), "still live"); // ensure pegExchanger is expired
25         TRIBE.transfer(CORE, TRIBE.balanceOf(address(this))); // transfer everything back to treasury
26     }
27 }
