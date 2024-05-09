1 // File: contracts/interfaces/IERC173.sol
2 
3 pragma solidity ^0.5.7;
4 
5 
6 /// @title ERC-173 Contract Ownership Standard
7 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
8 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
9 contract IERC173 {
10     /// @dev This emits when ownership of a contract changes.
11     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
12 
13     /// @notice Get the address of the owner
14     /// @return The address of the owner.
15     //// function owner() external view returns (address);
16 
17     /// @notice Set the address of the new owner of the contract
18     /// @param _newOwner The address of the new owner of the contract
19     function transferOwnership(address _newOwner) external;
20 }
21 
22 // File: contracts/commons/Ownable.sol
23 
24 pragma solidity ^0.5.7;
25 
26 
27 
28 contract Ownable is IERC173 {
29     address internal _owner;
30 
31     modifier onlyOwner() {
32         require(msg.sender == _owner, "The owner should be the sender");
33         _;
34     }
35 
36     constructor() public {
37         _owner = msg.sender;
38         emit OwnershipTransferred(address(0x0), msg.sender);
39     }
40 
41     function owner() external view returns (address) {
42         return _owner;
43     }
44 
45     /**
46         @dev Transfers the ownership of the contract.
47 
48         @param _newOwner Address of the new owner
49     */
50     function transferOwnership(address _newOwner) external onlyOwner {
51         require(_newOwner != address(0), "0x0 Is not a valid owner");
52         emit OwnershipTransferred(_owner, _newOwner);
53         _owner = _newOwner;
54     }
55 }
56 
57 
58 contract Proxy is Ownable {
59     event SetImplementation(address _prev, address _new);
60 
61     address private iimplementation;
62 
63     function implementation() external view returns (address) {
64         return iimplementation;
65     }
66 
67     function setImplementation(address _implementation) external onlyOwner {
68         emit SetImplementation(iimplementation, _implementation);
69         iimplementation = _implementation;
70     }
71     
72     function() external {
73         address _impl = iimplementation;
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