1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./Vault.sol";
5 
6 contract EthVault is Vault {
7     using AddressProviderHelpers for IAddressProvider;
8 
9     address private constant _UNDERLYING = address(0);
10 
11     constructor(IController controller) Vault(controller) {}
12 
13     receive() external payable {}
14 
15     function initialize(
16         address _pool,
17         uint256 _debtLimit,
18         uint256 _targetAllocation,
19         uint256 _bound
20     ) external virtual override initializer {
21         _initialize(_pool, _debtLimit, _targetAllocation, _bound);
22     }
23 
24     function getUnderlying() public pure override returns (address) {
25         return _UNDERLYING;
26     }
27 
28     function _transfer(address to, uint256 amount) internal override {
29         payable(to).transfer(amount);
30     }
31 
32     function _depositToReserve(uint256 amount) internal override {
33         reserve.deposit{value: amount}(_UNDERLYING, amount);
34     }
35 
36     function _depositToTreasury(uint256 amount) internal override {
37         payable(addressProvider.getTreasury()).transfer(amount);
38     }
39 
40     function _payStrategist(uint256 amount, address strategist) internal override {
41         if (strategist == address(0)) return;
42         ILiquidityPool(pool).depositFor{value: amount}(strategist, amount);
43     }
44 
45     function _availableUnderlying() internal view override returns (uint256) {
46         return address(this).balance;
47     }
48 }
