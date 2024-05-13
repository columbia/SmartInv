1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 import { Token } from "../token/Token.sol";
7 import { TokenLibrary } from "../token/TokenLibrary.sol";
8 
9 contract TestTokenLibrary {
10     using TokenLibrary for Token;
11 
12     receive() external payable {}
13 
14     function isNative(Token token) external pure returns (bool) {
15         return token.isNative();
16     }
17 
18     function symbol(Token token) external view returns (string memory) {
19         return token.symbol();
20     }
21 
22     function decimals(Token token) external view returns (uint8) {
23         return token.decimals();
24     }
25 
26     function balanceOf(Token token, address account) external view returns (uint256) {
27         return token.balanceOf(account);
28     }
29 
30     function safeTransfer(Token token, address to, uint256 amount) external {
31         token.safeTransfer(to, amount);
32     }
33 
34     function safeTransferFrom(Token token, address from, address to, uint256 amount) external {
35         token.safeTransferFrom(from, to, amount);
36     }
37 
38     function safeApprove(Token token, address spender, uint256 amount) external {
39         token.safeApprove(spender, amount);
40     }
41 
42     function ensureApprove(Token token, address spender, uint256 amount) external {
43         token.ensureApprove(spender, amount);
44     }
45 
46     function isEqual(Token token, IERC20 erc20Token) external pure returns (bool) {
47         return token.isEqual(erc20Token);
48     }
49 }
