1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
5 import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import {TransparentUpgradeableProxy, ProxyAdmin} from "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
7 
8 /// @title Helper contract for OTC purchase of admin rights over a proxy
9 /// @author eswak
10 contract ProxyOTCEscrow is Ownable {
11     using SafeERC20 for IERC20;
12 
13     TransparentUpgradeableProxy public immutable proxy;
14     IERC20 public immutable otcToken;
15     uint256 public immutable otcAmount;
16     address public immutable otcPurchaser;
17     address public immutable otcDestination;
18 
19     constructor(
20         address _owner,
21         address _otcToken,
22         uint256 _otcAmount,
23         address _otcPurchaser,
24         address _otcDestination,
25         address _proxy
26     ) Ownable() {
27         _transferOwnership(_owner);
28         otcToken = IERC20(_otcToken);
29         otcAmount = _otcAmount;
30         otcPurchaser = _otcPurchaser;
31         otcDestination = _otcDestination;
32         proxy = TransparentUpgradeableProxy(payable(address(_proxy)));
33     }
34 
35     /// @notice buy the proxy in an OTC transaction
36     function otcBuy(address newProxyAdmin) external {
37         require(msg.sender == otcPurchaser, "UNAUTHORIZED");
38         otcToken.safeTransferFrom(msg.sender, otcDestination, otcAmount);
39         _transferOwnership(address(0)); // revoke ownership
40         proxy.changeAdmin(newProxyAdmin);
41     }
42 
43     /// @notice usable while OTC has not executed, for the Owner to recover
44     /// proxy ownership (that is otherwise escrowed on this contract).
45     function recoverProxyOwnership(address to) external onlyOwner {
46         proxy.changeAdmin(to);
47     }
48 }
