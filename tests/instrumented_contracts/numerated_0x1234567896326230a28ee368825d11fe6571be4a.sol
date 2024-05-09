1 pragma solidity ^0.5.3;
2 
3 // counter.market smart contracts:
4 //  1) Proxy (this one) - delegatecalls into current exchange code, maintains storage of exchange state
5 //  2) Registry - stores information on the latest exchange contract version and user approvals
6 //  3) Treasury - takes custody of funds, moves them between token accounts, authorizing exchange code via Registry
7 
8 // Getting current code address is the only thing Proxy needs from Registry.
9 interface RegistryInterface {
10     function getExchangeContract() external view returns (address);
11 }
12 
13 // Counter contracts are deployed at predefined addresses which can be hardcoded.
14 contract FixedAddress {
15     address constant ProxyAddress = 0x1234567896326230a28ee368825D11fE6571Be4a;
16     address constant TreasuryAddress = 0x12345678979f29eBc99E00bdc5693ddEa564cA80;
17     address constant RegistryAddress = 0x12345678982cB986Dd291B50239295E3Cb10Cdf6;
18 
19     function getRegistry() internal pure returns (RegistryInterface) {
20         return RegistryInterface(RegistryAddress);
21     }
22 }
23 
24 contract Proxy is FixedAddress {
25 
26   function () external payable {
27       // Query current code version from Registry.
28       address _impl = getRegistry().getExchangeContract();
29 
30       // Typical implementation of proxied delegatecall with RETURNDATASIZE/RETURNDATACOPY.
31       // Quick refresher:
32       //     delegatecall uses code from other contract, yet operates on Proxy storage,
33       //     which means the latter is preserved between code upgrades.
34       assembly {
35           let ptr := mload(0x40)
36           calldatacopy(ptr, 0, calldatasize)
37           let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
38           let size := returndatasize
39           returndatacopy(ptr, 0, size)
40 
41           switch result
42           case 0 { revert(ptr, size) }
43           default { return(ptr, size) }
44       }
45   }
46 
47 }