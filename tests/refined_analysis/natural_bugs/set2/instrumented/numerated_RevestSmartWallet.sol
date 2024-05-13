1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /// @author RobAnon
9 contract RevestSmartWallet {
10 
11     using SafeERC20 for IERC20;
12 
13     address private immutable MASTER;
14 
15     constructor() {
16         MASTER = msg.sender;
17     }
18 
19     modifier onlyMaster() {
20         require(msg.sender == MASTER, 'E016');
21         _;
22     }
23 
24     function withdraw(uint value, address token, address recipient) external onlyMaster {
25         IERC20(token).safeTransfer(recipient, value);
26         _cleanMemory();
27     }
28 
29     /// Credit to doublesharp for the brilliant gas-saving concept
30     /// Self-destructing clone pattern
31     function cleanMemory() external onlyMaster {
32         _cleanMemory();
33     }
34 
35     function _cleanMemory() internal {
36         selfdestruct(payable(MASTER));
37     }
38 
39 }
