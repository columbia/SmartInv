1 pragma solidity ^0.5.2;
2 
3 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
4 
5 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
6 /// @author Alan Lu - <alan@gnosis.pm>
7 contract Proxied {
8     address public masterCopy;
9 }
10 
11 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
12 /// @author Stefan George - <stefan@gnosis.pm>
13 contract Proxy is Proxied {
14     /// @dev Constructor function sets address of master copy contract.
15     /// @param _masterCopy Master copy address.
16     constructor(address _masterCopy) public {
17         require(_masterCopy != address(0), "The master copy is required");
18         masterCopy = _masterCopy;
19     }
20 
21     /// @dev Fallback function forwards all transactions and returns all received return data.
22     function() external payable {
23         address _masterCopy = masterCopy;
24         assembly {
25             calldatacopy(0, 0, calldatasize)
26             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
27             returndatacopy(0, 0, returndatasize)
28             switch success
29                 case 0 {
30                     revert(0, returndatasize)
31                 }
32                 default {
33                     return(0, returndatasize)
34                 }
35         }
36     }
37 }
38 
39 // File: contracts/DutchExchangeProxy.sol
40 
41 contract DutchExchangeProxy is Proxy {
42     constructor(address _masterCopy) public Proxy(_masterCopy) {}
43 }