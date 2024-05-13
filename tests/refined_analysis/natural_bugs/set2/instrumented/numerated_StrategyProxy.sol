1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 import "../inheritance/IUpgradeSource.sol";
6 import "./BaseUpgradeabilityProxy.sol";
7 
8 contract StrategyProxy is BaseUpgradeabilityProxy {
9 
10   constructor(address _implementation) public {
11     _setImplementation(_implementation);
12   }
13 
14   /**
15   * The main logic. If the timer has elapsed and there is a schedule upgrade,
16   * the governance can upgrade the strategy
17   */
18   function upgrade() external {
19     (bool should, address newImplementation) = IUpgradeSource(address(this)).shouldUpgrade();
20     require(should, "Upgrade not scheduled");
21     _upgradeTo(newImplementation);
22 
23     // the finalization needs to be executed on itself to update the storage of this proxy
24     // it also needs to be invoked by the governance, not by address(this), so delegatecall is needed
25     (bool success,) = address(this).delegatecall(
26       abi.encodeWithSignature("finalizeUpgrade()")
27     );
28 
29     require(success, "Issue when finalizing the upgrade");
30   }
31 
32   function implementation() external view returns (address) {
33     return _implementation();
34   }
35 }
