1 pragma solidity ^0.5.0;
2 
3 contract Receiver {
4     //The purpose of this contract is to act purely as a static address
5     //in the Ethereum uint256 address space from which to initiate other
6     //actions
7 
8     //State
9     address public implementation;
10     bool public isPayable;
11 
12     //Events
13     event LogImplementationChanged(address _oldImplementation, address _newImplementation);
14     event LogPaymentReceived(address sender, uint256 value);
15 
16     constructor(address _implementation, bool _isPayable)
17         public
18     {
19         require(_implementation != address(0), "Implementation address cannot be 0");
20         implementation = _implementation;
21         isPayable = _isPayable;
22     }
23 
24     modifier onlyImplementation
25     {
26         require(msg.sender == implementation, "Only the contract implementation may perform this action");
27         _;
28     }
29     
30     function drain()
31         external
32         onlyImplementation
33     {
34         msg.sender.call.value(address(this).balance)("");
35     }
36 
37 
38     function ()
39         external
40         payable 
41     {
42         if (msg.sender != implementation) {
43             if (isPayable) {
44                 emit LogPaymentReceived(msg.sender, msg.value);
45             } else {
46                 revert("not payable");
47             }
48         } else {
49             assembly {
50                 switch calldatasize
51                 case 0 {
52                 }
53                 default {
54                     //Copy call data into free memory region.
55                     let free_ptr := mload(0x40)
56                     calldatacopy(free_ptr, 0, calldatasize)
57 
58                     //Forward all gas and call data to the target contract.
59                     let result := delegatecall(gas, caller, free_ptr, calldatasize, 0, 0)
60                     returndatacopy(free_ptr, 0, returndatasize)
61 
62                     //Revert if the call failed, otherwise return the result
63                     if iszero(result) { revert(free_ptr, returndatasize) }
64                     return(free_ptr, returndatasize)
65                 }
66             }
67         }
68     }
69 }