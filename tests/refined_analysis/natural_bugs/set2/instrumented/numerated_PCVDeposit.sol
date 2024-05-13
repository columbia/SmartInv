1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 import "./IPCVDeposit.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 /// @title abstract contract for withdrawing ERC-20 tokens using a PCV Controller
9 /// @author Fei Protocol
10 abstract contract PCVDeposit is IPCVDeposit, CoreRef {
11     using SafeERC20 for IERC20;
12 
13     /// @notice withdraw ERC20 from the contract
14     /// @param token address of the ERC20 to send
15     /// @param to address destination of the ERC20
16     /// @param amount quantity of ERC20 to send
17     function withdrawERC20(
18         address token,
19         address to,
20         uint256 amount
21     ) public virtual override onlyPCVController {
22         _withdrawERC20(token, to, amount);
23     }
24 
25     function _withdrawERC20(
26         address token,
27         address to,
28         uint256 amount
29     ) internal {
30         IERC20(token).safeTransfer(to, amount);
31         emit WithdrawERC20(msg.sender, token, to, amount);
32     }
33 
34     /// @notice withdraw ETH from the contract
35     /// @param to address to send ETH
36     /// @param amountOut amount of ETH to send
37     function withdrawETH(address payable to, uint256 amountOut) external virtual override onlyPCVController {
38         Address.sendValue(to, amountOut);
39         emit WithdrawETH(msg.sender, to, amountOut);
40     }
41 
42     function balance() public view virtual override returns (uint256);
43 
44     function balanceReportedIn() public view virtual override returns (address);
45 
46     function resistantBalanceAndFei() public view virtual override returns (uint256, uint256) {
47         uint256 tokenBalance = balance();
48         return (tokenBalance, balanceReportedIn() == address(fei()) ? tokenBalance : 0);
49     }
50 }
