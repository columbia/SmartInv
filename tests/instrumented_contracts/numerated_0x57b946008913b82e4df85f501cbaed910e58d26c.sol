1 pragma solidity >=0.4.21 <0.7.0;
2 
3 
4 /// @title Contract to reward overlapping stakes
5 /// @author Marlin
6 /// @notice Use this contract only for testing
7 /// @dev Contract may or may not change in future (depending upon the new slots in proxy-store)
8 contract TokenProxy {
9     bytes32 internal constant IMPLEMENTATION_SLOT = bytes32(
10         uint256(keccak256("eip1967.proxy.implementation")) - 1
11     );
12     bytes32 internal constant PROXY_ADMIN_SLOT = bytes32(
13         uint256(keccak256("eip1967.proxy.admin")) - 1
14     );
15 
16     constructor(address contractLogic, address proxyAdmin) public {
17         // save the code address
18         bytes32 slot = IMPLEMENTATION_SLOT;
19         assembly {
20             sstore(slot, contractLogic)
21         }
22         // save the proxy admin
23         slot = PROXY_ADMIN_SLOT;
24         address sender = proxyAdmin;
25         assembly {
26             sstore(slot, sender)
27         }
28     }
29 
30     function updateAdmin(address _newAdmin) public {
31         require(
32             msg.sender == getAdmin(),
33             "Only the current admin should be able to new admin"
34         );
35         bytes32 slot = PROXY_ADMIN_SLOT;
36         assembly {
37             sstore(slot, _newAdmin)
38         }
39     }
40 
41     /// @author Marlin
42     /// @dev Only admin can update the contract
43     /// @param _newLogic address is the address of the contract that has to updated to
44     function updateLogic(address _newLogic) public {
45         require(
46             msg.sender == getAdmin(),
47             "Only Admin should be able to update the contracts"
48         );
49         bytes32 slot = IMPLEMENTATION_SLOT;
50         assembly {
51             sstore(slot, _newLogic)
52         }
53     }
54 
55     /// @author Marlin
56     /// @dev use assembly as contract store slot is manually decided
57     function getAdmin() internal view returns (address result) {
58         bytes32 slot = PROXY_ADMIN_SLOT;
59         assembly {
60             result := sload(slot)
61         }
62     }
63 
64     /// @author Marlin
65     /// @dev add functionality to forward the balance as well.
66     function() external payable {
67         bytes32 slot = IMPLEMENTATION_SLOT;
68         assembly {
69             let contractLogic := sload(slot)
70             calldatacopy(0x0, 0x0, calldatasize())
71             let success := delegatecall(
72                 sub(gas(), 10000),
73                 contractLogic,
74                 0x0,
75                 calldatasize(),
76                 0,
77                 0
78             )
79             let retSz := returndatasize()
80             returndatacopy(0, 0, retSz)
81 
82             switch success
83                 case 0 {
84                     revert(0, retSz)
85                 }
86                 default {
87                     return(0, retSz)
88                 }
89         }
90     }
91 }