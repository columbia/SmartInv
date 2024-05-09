1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 contract Token is Ownable {
63   event UpgradedTo(address indexed implementation);
64 
65   address internal _implementation;
66 
67   function implementation() public view returns (address) {
68     return _implementation;
69   }
70 
71   function upgradeTo(address impl) public onlyOwner {
72     require(_implementation != impl);
73     _implementation = impl;
74     emit UpgradedTo(impl);
75   }
76 
77   function () payable public {
78     address _impl = implementation();
79     require(_impl != address(0));
80     bytes memory data = msg.data;
81 
82     assembly {
83       let result := delegatecall(gas, _impl, add(data, 0x20), mload(data), 0, 0)
84       let size := returndatasize
85       let ptr := mload(0x40)
86       returndatacopy(ptr, 0, size)
87       switch result
88       case 0 { revert(ptr, size) }
89       default { return(ptr, size) }
90     }
91   }
92 }