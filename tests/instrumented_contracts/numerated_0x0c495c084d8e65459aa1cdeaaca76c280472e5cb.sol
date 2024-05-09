1 // File contracts/beacon/IBeacon.sol
2 
3 pragma solidity ^0.8.0;
4 
5 interface IBeacon {
6     function latestCopy() external view returns(address);
7 }
8 
9 
10 // File contracts/beacon/BeaconProxy.sol
11 
12 pragma solidity ^0.8.0;
13 
14 contract BeaconProxy {
15 
16     bytes32 private constant BEACON_SLOT = keccak256(abi.encodePacked("fairmint.beaconproxy.beacon"));
17 
18     constructor() public {
19         _setBeacon(msg.sender);
20     }
21 
22     function _setBeacon(address _beacon) private {
23         bytes32 slot = BEACON_SLOT;
24         assembly {
25             sstore(slot, _beacon)
26         }
27     }
28 
29     function _getBeacon() internal view returns(address beacon) {
30         bytes32 slot = BEACON_SLOT;
31         assembly {
32             beacon := sload(slot)
33         }
34     }
35 
36     function _getMasterCopy() internal view returns(address) {
37         IBeacon beacon = IBeacon(_getBeacon());
38         return beacon.latestCopy();
39     }
40 
41     fallback() external payable {
42         address copy = _getMasterCopy();
43         assembly {
44             calldatacopy(0, 0, calldatasize())
45             let result := delegatecall(gas(), copy, 0, calldatasize(), 0, 0)
46             let size := returndatasize()
47             returndatacopy(0, 0, size)
48             switch result
49             case 0 { revert(0, size) }
50             default { return(0, size) }
51         }
52     }
53 }