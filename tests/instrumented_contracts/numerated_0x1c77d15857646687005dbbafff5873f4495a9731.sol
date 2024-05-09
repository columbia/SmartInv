1 pragma solidity >=0.4.21 <0.7.0;
2 
3 
4 contract MPondProxy {
5     bytes32 internal constant IMPLEMENTATION_SLOT = bytes32(
6         uint256(keccak256("eip1967.proxy.implementation")) - 1
7     );
8     bytes32 internal constant PROXY_ADMIN_SLOT = bytes32(
9         uint256(keccak256("eip1967.proxy.admin")) - 1
10     );
11 
12     constructor(address contractLogic, address proxyAdmin) public {
13         // save the code address
14         bytes32 slot = IMPLEMENTATION_SLOT;
15         assembly {
16             sstore(slot, contractLogic)
17         }
18         // save the proxy admin
19         slot = PROXY_ADMIN_SLOT;
20         address sender = proxyAdmin;
21         assembly {
22             sstore(slot, sender)
23         }
24     }
25 
26     function updateAdmin(address _newAdmin) public {
27         require(
28             msg.sender == getAdmin(),
29             "Only the current admin should be able to new admin"
30         );
31         bytes32 slot = PROXY_ADMIN_SLOT;
32         assembly {
33             sstore(slot, _newAdmin)
34         }
35     }
36 
37     /// @author Marlin
38     /// @dev Only admin can update the contract
39     /// @param _newLogic address is the address of the contract that has to updated to
40     function updateLogic(address _newLogic) public {
41         require(
42             msg.sender == getAdmin(),
43             "Only Admin should be able to update the contracts"
44         );
45         bytes32 slot = IMPLEMENTATION_SLOT;
46         assembly {
47             sstore(slot, _newLogic)
48         }
49     }
50 
51     /// @author Marlin
52     /// @dev use assembly as contract store slot is manually decided
53     function getAdmin() internal view returns (address result) {
54         bytes32 slot = PROXY_ADMIN_SLOT;
55         assembly {
56             result := sload(slot)
57         }
58     }
59 
60     /// @author Marlin
61     /// @dev add functionality to forward the balance as well.
62     function() external payable {
63         bytes32 slot = IMPLEMENTATION_SLOT;
64         assembly {
65             let contractLogic := sload(slot)
66             calldatacopy(0x0, 0x0, calldatasize())
67             let success := delegatecall(
68                 sub(gas(), 10000),
69                 contractLogic,
70                 0x0,
71                 calldatasize(),
72                 0,
73                 0
74             )
75             let retSz := returndatasize()
76             returndatacopy(0, 0, retSz)
77 
78             switch success
79                 case 0 {
80                     revert(0, retSz)
81                 }
82                 default {
83                     return(0, retSz)
84                 }
85         }
86     }
87 }