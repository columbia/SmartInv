1 pragma solidity ^0.4.21;
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
16     function Proxy(address _masterCopy)
17         public
18     {
19         require(_masterCopy != 0);
20         masterCopy = _masterCopy;
21     }
22 
23     /// @dev Fallback function forwards all transactions and returns all received return data.
24     function ()
25         external
26         payable
27     {
28         address _masterCopy = masterCopy;
29         assembly {
30             calldatacopy(0, 0, calldatasize())
31             let success := delegatecall(not(0), _masterCopy, 0, calldatasize(), 0, 0)
32             returndatacopy(0, 0, returndatasize())
33             switch success
34             case 0 { revert(0, returndatasize()) }
35             default { return(0, returndatasize()) }
36         }
37     }
38 }
39 
40 // File: contracts/DutchExchangeProxy.sol
41 
42 contract DutchExchangeProxy is Proxy {
43   function DutchExchangeProxy(address _masterCopy) Proxy (_masterCopy) {
44   }
45 }