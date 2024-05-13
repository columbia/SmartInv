1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import {PCVDeposit} from "./PCVDeposit.sol";
7 import {CoreRef} from "../refs/CoreRef.sol";
8 import {Constants} from "../Constants.sol";
9 
10 /// @title ERC20HoldingPCVDeposit
11 /// @notice PCVDeposit that is used to hold ERC20 tokens as a safe harbour. Deposit is a no-op
12 contract ERC20HoldingPCVDeposit is PCVDeposit {
13     using SafeERC20 for IERC20;
14 
15     /// @notice Token which the balance is reported in
16     IERC20 immutable token;
17 
18     /// @notice Fei ERC20 token address
19     address private constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
20 
21     constructor(address _core, IERC20 _token) CoreRef(_core) {
22         require(address(_token) != FEI, "FEI not supported");
23         token = _token;
24     }
25 
26     /// @notice Empty receive function to receive ETH
27     receive() external payable {}
28 
29     ///////   READ-ONLY Methods /////////////
30 
31     /// @notice returns total balance of PCV in the deposit
32     function balance() public view override returns (uint256) {
33         return token.balanceOf(address(this));
34     }
35 
36     /// @notice returns the resistant balance and FEI in the deposit
37     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
38         return (balance(), 0);
39     }
40 
41     /// @notice display the related token of the balance reported
42     function balanceReportedIn() public view override returns (address) {
43         return address(token);
44     }
45 
46     /// @notice No-op deposit
47     function deposit() external override whenNotPaused {
48         emit Deposit(msg.sender, balance());
49     }
50 
51     /// @notice Withdraw underlying
52     /// @param amountUnderlying of tokens withdrawn
53     /// @param to the address to send PCV to
54     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController whenNotPaused {
55         token.safeTransfer(to, amountUnderlying);
56         emit Withdrawal(msg.sender, to, amountUnderlying);
57     }
58 
59     /// @notice Wraps all ETH held by the contract to WETH. Permissionless, anyone can call it
60     function wrapETH() public {
61         uint256 ethBalance = address(this).balance;
62         if (ethBalance != 0) {
63             Constants.WETH.deposit{value: ethBalance}();
64         }
65     }
66 }
