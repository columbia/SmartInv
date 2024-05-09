1 // File: contracts\UtilitiesStorage.sol
2 
3 pragma solidity ^0.4.21;
4 
5 contract UtilitiesStorage {
6 
7 	uint public constant ROLE_BIDDER = 1;
8 	uint public constant ROLE_ADVERTISER = 2;
9 	uint public constant ROLE_PUBLISHER = 3;
10 	uint public constant ROLE_VOTER = 4;
11 
12 	address public CONTRACT_MEMBERS;
13 	address public CONTRACT_TOKEN;
14 
15 	mapping (address => mapping (address => uint256)) deposits;
16 }
17 
18 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
19 
20 pragma solidity ^0.4.24;
21 
22 /**
23  * @title Ownable
24  * @dev The Ownable contract has an owner address, and provides basic authorization control
25  * functions, this simplifies the implementation of "user permissions".
26  */
27 contract Ownable {
28   address private _owner;
29 
30   event OwnershipTransferred(
31     address indexed previousOwner,
32     address indexed newOwner
33   );
34 
35   /**
36    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
37    * account.
38    */
39   constructor() internal {
40     _owner = msg.sender;
41     emit OwnershipTransferred(address(0), _owner);
42   }
43 
44   /**
45    * @return the address of the owner.
46    */
47   function owner() public view returns(address) {
48     return _owner;
49   }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(isOwner());
56     _;
57   }
58 
59   /**
60    * @return true if `msg.sender` is the owner of the contract.
61    */
62   function isOwner() public view returns(bool) {
63     return msg.sender == _owner;
64   }
65 
66   /**
67    * @dev Allows the current owner to relinquish control of the contract.
68    * @notice Renouncing to ownership will leave the contract without an owner.
69    * It will not be possible to call the functions with the `onlyOwner`
70    * modifier anymore.
71    */
72   function renounceOwnership() public onlyOwner {
73     emit OwnershipTransferred(_owner, address(0));
74     _owner = address(0);
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     _transferOwnership(newOwner);
83   }
84 
85   /**
86    * @dev Transfers control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function _transferOwnership(address newOwner) internal {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(_owner, newOwner);
92     _owner = newOwner;
93   }
94 }
95 
96 // File: contracts\UtilitiesRegistry.sol
97 
98 pragma solidity ^0.4.21;
99 
100 
101 
102 contract UtilitiesRegistry is UtilitiesStorage, Ownable {
103 
104 	address private CONTRACT_ADDRESS;
105 
106 	function setContractAddress(address newContractAddress) public onlyOwner {
107 		CONTRACT_ADDRESS = newContractAddress;
108 	}
109 
110 	function () payable public {
111 		address target = CONTRACT_ADDRESS;
112 		assembly {
113 			// Copy the data sent to the memory address starting free mem position
114 			let ptr := mload(0x40)
115 			calldatacopy(ptr, 0, calldatasize)
116 			// Proxy the call to the contract address with the provided gas and data
117 			let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
118 			// Copy the data returned by the proxied call to memory
119 			let size := returndatasize
120 			returndatacopy(ptr, 0, size)
121 			// Check what the result is, return and revert accordingly
122 			switch result
123 			case 0 { revert(ptr, size) }
124 			case 1 { return(ptr, size) }
125 		}
126 	}
127 }