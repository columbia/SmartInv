1 pragma solidity ^0.4.19;
2 
3 /* solhint-disable no-inline-assembly, indent, state-visibility, avoid-low-level-calls */
4 
5 contract ProxyFactory {
6     event ProxyDeployed(address proxyAddress, address targetAddress);
7     event ProxiesDeployed(address[] proxyAddresses, address targetAddress);
8 
9     function createManyProxies(uint256 _count, address _target, bytes _data)
10     public
11     {
12         address[] memory proxyAddresses = new address[](_count);
13 
14         for (uint256 i = 0; i < _count; ++i) {
15             proxyAddresses[i] = createProxyImpl(_target, _data);
16         }
17 
18         ProxiesDeployed(proxyAddresses, _target);
19     }
20 
21     function createProxy(address _target, bytes _data)
22     public
23     returns (address proxyContract)
24     {
25         proxyContract = createProxyImpl(_target, _data);
26 
27         ProxyDeployed(proxyContract, _target);
28     }
29 
30     function createProxyImpl(address _target, bytes _data)
31     internal
32     returns (address proxyContract)
33     {
34         assembly {
35             let contractCode := mload(0x40) // Find empty storage location using "free memory pointer"
36 
37             mstore(add(contractCode, 0x0b), _target) // Add target address, with a 11 bytes [i.e. 23 - (32 - 20)] offset to later accomodate first part of the bytecode
38             mstore(sub(contractCode, 0x09), 0x000000000000000000603160008181600b9039f3600080808080368092803773) // First part of the bytecode, shifted left by 9 bytes, overwrites left padding of target address
39             mstore(add(contractCode, 0x2b), 0x5af43d828181803e808314602f57f35bfd000000000000000000000000000000) // Final part of bytecode, offset by 43 bytes
40 
41             proxyContract := create(0, contractCode, 60) // total length 60 bytes
42             if iszero(extcodesize(proxyContract)) {
43                 revert(0, 0)
44             }
45 
46         // check if the _data.length > 0 and if it is forward it to the newly created contract
47             let dataLength := mload(_data)
48             if iszero(iszero(dataLength)) {
49                 if iszero(call(gas, proxyContract, 0, add(_data, 0x20), dataLength, 0, 0)) {
50                     revert(0, 0)
51                 }
52             }
53         }
54     }
55 }