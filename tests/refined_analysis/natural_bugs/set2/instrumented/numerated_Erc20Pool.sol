1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./LiquidityPool.sol";
5 import "../../interfaces/pool/IErc20Pool.sol";
6 
7 contract Erc20Pool is LiquidityPool, IErc20Pool {
8     using SafeERC20 for IERC20;
9 
10     address private _underlying;
11 
12     constructor(IController _controller) LiquidityPool(_controller) {}
13 
14     function initialize(
15         string memory name_,
16         address underlying_,
17         uint256 depositCap_,
18         address vault_
19     ) public override returns (bool) {
20         require(underlying_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
21         _underlying = underlying_;
22         return _initialize(name_, depositCap_, vault_);
23     }
24 
25     function getUnderlying() public view override returns (address) {
26         return _underlying;
27     }
28 
29     function _doTransferIn(address from, uint256 amount) internal override {
30         require(msg.value == 0, Error.INVALID_VALUE);
31         IERC20(_underlying).safeTransferFrom(from, address(this), amount);
32     }
33 
34     function _doTransferOut(address payable to, uint256 amount) internal override {
35         IERC20(_underlying).safeTransfer(to, amount);
36     }
37 
38     function _getBalanceUnderlying() internal view override returns (uint256) {
39         return IERC20(_underlying).balanceOf(address(this));
40     }
41 
42     function _getBalanceUnderlying(bool) internal view override returns (uint256) {
43         return _getBalanceUnderlying();
44     }
45 }
