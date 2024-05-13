1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./Vault.sol";
5 
6 contract Erc20Vault is Vault {
7     using AddressProviderHelpers for IAddressProvider;
8     using SafeERC20 for IERC20;
9 
10     constructor(IController controller) Vault(controller) {}
11 
12     function initialize(
13         address _pool,
14         uint256 _debtLimit,
15         uint256 _targetAllocation,
16         uint256 _bound
17     ) external virtual override initializer {
18         _initialize(_pool, _debtLimit, _targetAllocation, _bound);
19         address underlying_ = ILiquidityPool(pool).getUnderlying();
20         require(underlying_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
21         IERC20(underlying_).safeApprove(address(reserve), type(uint256).max);
22         IERC20(underlying_).safeApprove(_pool, type(uint256).max);
23     }
24 
25     function getUnderlying() public view override returns (address) {
26         return ILiquidityPool(pool).getUnderlying();
27     }
28 
29     function _transfer(address to, uint256 amount) internal override {
30         IERC20(getUnderlying()).safeTransfer(to, amount);
31     }
32 
33     function _depositToReserve(uint256 amount) internal override {
34         reserve.deposit(getUnderlying(), amount);
35     }
36 
37     function _depositToTreasury(uint256 amount) internal override {
38         IERC20(getUnderlying()).safeTransfer(addressProvider.getTreasury(), amount);
39     }
40 
41     function _payStrategist(uint256 amount, address strategist) internal override {
42         if (strategist == address(0)) return;
43         ILiquidityPool(pool).depositFor(strategist, amount);
44     }
45 
46     function _availableUnderlying() internal view override returns (uint256) {
47         return IERC20(getUnderlying()).balanceOf(address(this));
48     }
49 }
