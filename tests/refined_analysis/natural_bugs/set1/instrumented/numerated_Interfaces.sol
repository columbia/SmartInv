1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 
6 interface IERC20 {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external view returns (string memory);
11     function symbol() external view returns (string memory);
12     function decimals() external view returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 }
21 
22 interface IERC20Permit {
23     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
24     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
25     function permit(address owner, address spender, uint value, uint deadline, bytes calldata signature) external;
26 }
27 
28 interface IERC3156FlashBorrower {
29     function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data) external returns (bytes32);
30 }
31 
32 interface IERC3156FlashLender {
33     function maxFlashLoan(address token) external view returns (uint256);
34     function flashFee(address token, uint256 amount) external view returns (uint256);
35     function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 amount, bytes calldata data) external returns (bool);
36 }
