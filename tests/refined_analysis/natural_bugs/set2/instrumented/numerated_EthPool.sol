1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./LiquidityPool.sol";
5 import "../../interfaces/pool/IEthPool.sol";
6 
7 contract EthPool is LiquidityPool, IEthPool {
8     constructor(IController _controller) LiquidityPool(_controller) {}
9 
10     receive() external payable {}
11 
12     function initialize(
13         string memory name_,
14         uint256 depositCap_,
15         address vault_
16     ) external override returns (bool) {
17         return _initialize(name_, depositCap_, vault_);
18     }
19 
20     function getUnderlying() public pure override returns (address) {
21         return address(0);
22     }
23 
24     function _doTransferIn(address from, uint256 amount) internal override {
25         require(msg.sender == from, Error.INVALID_SENDER);
26         require(msg.value == amount, Error.INVALID_AMOUNT);
27     }
28 
29     function _doTransferOut(address payable to, uint256 amount) internal override {
30         to.transfer(amount);
31     }
32 
33     function _getBalanceUnderlying() internal view override returns (uint256) {
34         return _getBalanceUnderlying(false);
35     }
36 
37     function _getBalanceUnderlying(bool transferInDone) internal view override returns (uint256) {
38         uint256 balance = address(this).balance;
39         if (!transferInDone) {
40             balance -= msg.value;
41         }
42         return balance;
43     }
44 }
