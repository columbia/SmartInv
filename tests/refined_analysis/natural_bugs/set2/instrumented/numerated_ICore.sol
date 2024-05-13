1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 interface ICore {
6     function mint(
7         uint256 btc,
8         address account,
9         bytes32[] calldata merkleProof
10     ) external returns (uint256);
11 
12     function redeem(uint256 btc, address account) external returns (uint256);
13 
14     function btcToBbtc(uint256 btc) external view returns (uint256, uint256);
15 
16     function bBtcToBtc(uint256 bBtc) external view returns (uint256 btc, uint256 fee);
17 
18     function pricePerShare() external view returns (uint256);
19 
20     function setGuestList(address guestlist) external;
21 
22     function collectFee() external;
23 
24     function owner() external view returns (address);
25 }
