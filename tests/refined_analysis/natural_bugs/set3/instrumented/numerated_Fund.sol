1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import "@openzeppelin/contracts/utils/Address.sol";
7 import "../interfaces/IWETH.sol";
8 import "./RoleAware.sol";
9 
10 /// @title Manage funding
11 contract Fund is RoleAware, Ownable {
12     using SafeERC20 for IERC20;
13     /// wrapped ether
14     address public immutable WETH;
15 
16     constructor(address _WETH, address _roles) Ownable() RoleAware(_roles) {
17         WETH = _WETH;
18     }
19 
20     /// Deposit an active token
21     function deposit(address depositToken, uint256 depositAmount) external {
22         IERC20(depositToken).safeTransferFrom(
23             msg.sender,
24             address(this),
25             depositAmount
26         );
27     }
28 
29     /// Deposit token on behalf of `sender`
30     function depositFor(
31         address sender,
32         address depositToken,
33         uint256 depositAmount
34     ) external {
35         require(
36             isFundTransferer(msg.sender),
37             "Contract not authorized to deposit for user"
38         );
39         IERC20(depositToken).safeTransferFrom(
40             sender,
41             address(this),
42             depositAmount
43         );
44     }
45 
46     /// Deposit to wrapped ether
47     function depositToWETH() external payable {
48         IWETH(WETH).deposit{value: msg.value}();
49     }
50 
51     // withdrawers role
52     function withdraw(
53         address withdrawalToken,
54         address recipient,
55         uint256 withdrawalAmount
56     ) external {
57         require(
58             isFundTransferer(msg.sender),
59             "Contract not authorized to withdraw"
60         );
61         IERC20(withdrawalToken).safeTransfer(recipient, withdrawalAmount);
62     }
63 
64     // withdrawers role
65     function withdrawETH(address recipient, uint256 withdrawalAmount) external {
66         require(isFundTransferer(msg.sender), "Not authorized to withdraw");
67         IWETH(WETH).withdraw(withdrawalAmount);
68         Address.sendValue(payable(recipient), withdrawalAmount);
69     }
70 }
