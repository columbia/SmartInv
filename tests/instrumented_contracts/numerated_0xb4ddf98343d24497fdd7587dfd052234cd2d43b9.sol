1 // File: contracts/interfaces/IERC173.sol
2 
3 pragma solidity ^0.5.7;
4 
5 contract ProxyStorage {
6     address powner;
7     address pimplementation;
8 }
9 
10 /// @title ERC-173 Contract Ownership Standard
11 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
12 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
13 contract IERC173 {
14     /// @dev This emits when ownership of a contract changes.
15     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
16 
17     /// @notice Get the address of the owner
18     /// @return The address of the owner.
19     //// function owner() external view returns (address);
20 
21     /// @notice Set the address of the new owner of the contract
22     /// @param _newOwner The address of the new owner of the contract
23     function transferOwnership(address _newOwner) external;
24 }
25 
26 // File: contracts/commons/Ownable.sol
27 
28 pragma solidity ^0.5.7;
29 
30 
31 
32 contract Ownable is ProxyStorage, IERC173 {
33     modifier onlyOwner() {
34         require(msg.sender == powner, "The owner should be the sender");
35         _;
36     }
37 
38     constructor() public {
39         powner = msg.sender;
40         emit OwnershipTransferred(address(0x0), msg.sender);
41     }
42 
43     function owner() external view returns (address) {
44         return powner;
45     }
46 
47     /**
48         @dev Transfers the ownership of the contract.
49 
50         @param _newOwner Address of the new owner
51     */
52     function transferOwnership(address _newOwner) external onlyOwner {
53         require(_newOwner != address(0), "0x0 Is not a valid owner");
54         emit OwnershipTransferred(powner, _newOwner);
55         powner = _newOwner;
56     }
57 }
58 
59 
60 contract Proxy is ProxyStorage, Ownable {
61     event SetImplementation(address _prev, address _new);
62 
63     function implementation() external view returns (address) {
64         return pimplementation;
65     }
66 
67     function setImplementation(address _implementation) external onlyOwner {
68         emit SetImplementation(pimplementation, _implementation);
69         pimplementation = _implementation;
70     }
71     
72     function() external {
73         address _impl = pimplementation;
74         assembly {
75             let ptr := mload(0x40)
76             calldatacopy(ptr, 0, calldatasize)
77             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
78             let size := returndatasize
79             returndatacopy(ptr, 0, size)
80 
81             if iszero(result) {
82                 revert(ptr, size)
83             }
84 
85             return(ptr, size)
86         }
87     }
88 }