1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {UpgradeBeacon} from "./UpgradeBeacon.sol";
6 // ============ External Imports ============
7 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
8 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
9 
10 /**
11  * @title UpgradeBeaconController
12  * @notice Set as the controller of UpgradeBeacon contract(s),
13  * capable of changing their stored implementation address.
14  * @dev This implementation is a minimal version inspired by 0age's implementation:
15  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/upgradeability/DharmaUpgradeBeaconController.sol
16  */
17 contract UpgradeBeaconController is Ownable {
18     // ============ Events ============
19 
20     event BeaconUpgraded(address indexed beacon, address implementation);
21 
22     // ============ External Functions ============
23 
24     /**
25      * @notice Modify the implementation stored in the UpgradeBeacon,
26      * which will upgrade the implementation used by all
27      * Proxy contracts using that UpgradeBeacon
28      * @param _beacon Address of the UpgradeBeacon which will be updated
29      * @param _implementation Address of the Implementation contract to upgrade the Beacon to
30      */
31     function upgrade(address _beacon, address _implementation)
32         external
33         onlyOwner
34     {
35         // Require that the beacon is a contract
36         require(Address.isContract(_beacon), "beacon !contract");
37         // Call into beacon and supply address of new implementation to update it.
38         (bool _success, ) = _beacon.call(abi.encode(_implementation));
39         // Revert with message on failure (i.e. if the beacon is somehow incorrect).
40         if (!_success) {
41             assembly {
42                 returndatacopy(0, 0, returndatasize())
43                 revert(0, returndatasize())
44             }
45         }
46         emit BeaconUpgraded(_beacon, _implementation);
47     }
48 }
