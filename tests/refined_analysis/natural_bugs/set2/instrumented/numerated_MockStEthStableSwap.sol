1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/utils/Address.sol";
7 
8 contract MockStEthStableSwap {
9     bool public anti;
10     uint256 public slippage;
11 
12     IERC20 public token;
13 
14     constructor(address _token1) {
15         token = IERC20(_token1);
16     }
17 
18     function setSlippage(uint256 _slippage, bool _anti) public {
19         slippage = _slippage;
20         anti = _anti;
21     }
22 
23     function coins(uint256 i) public view returns (address) {
24         if (i == 0) return 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
25         else return address(token);
26     }
27 
28     function exchange(
29         int128 i,
30         int128, /* j*/
31         uint256 input,
32         uint256 min_out
33     ) public payable returns (uint256 output) {
34         output = anti ? (input * (10000 + slippage)) / 10000 : (input * (10000 - slippage)) / 10000;
35 
36         require(output >= min_out, "MockStableswap/excess-slippage");
37 
38         if (i == 1) {
39             token.transferFrom(msg.sender, address(this), input);
40             Address.sendValue(payable(msg.sender), output);
41         } else token.transfer(msg.sender, output);
42     }
43 
44     function get_dy(
45         int128, /* i*/
46         int128, /* j*/
47         uint256 input
48     ) public view returns (uint256 output) {
49         output = anti ? (input * (10000 + slippage)) / 10000 : (input * (10000 - slippage)) / 10000;
50     }
51 
52     receive() external payable {}
53 }
