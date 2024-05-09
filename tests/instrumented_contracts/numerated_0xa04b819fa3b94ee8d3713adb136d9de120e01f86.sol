1 // File: contracts\CreativesStorage.sol
2 
3 pragma solidity ^0.4.21;
4 
5 contract CreativesStorage {
6 
7 	uint public constant ROLE_BIDDER = 1;
8 	uint public constant ROLE_ADVERTISER = 2;
9 	uint public constant ROLE_PUBLISHER = 3;
10 	uint public constant ROLE_VOTER = 4;
11 
12 	address public CONTRACT_MEMBERS;
13 	address public CONTRACT_TOKEN;
14 	address public VOTER_POOL;
15 
16 	uint public INITIAL_THRESHOLD = 50;
17 	uint public THRESHOLD_STEP = 10;
18 	uint public BLOCK_DEPOSIT = 10000000000000000; //0.01 ADT
19 	uint public MAJORITY = 666; // 0.666 considered as supermajority
20 
21 	mapping (address => address) creativeOwner;
22 	mapping (address => address[]) creatives;
23 	mapping (address => uint) threshold;
24 	mapping (address => bool) blocked;
25 }
26 
27 // File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
28 
29 pragma solidity ^0.4.24;
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address private _owner;
38 
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   constructor() internal {
49     _owner = msg.sender;
50     emit OwnershipTransferred(address(0), _owner);
51   }
52 
53   /**
54    * @return the address of the owner.
55    */
56   function owner() public view returns(address) {
57     return _owner;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(isOwner());
65     _;
66   }
67 
68   /**
69    * @return true if `msg.sender` is the owner of the contract.
70    */
71   function isOwner() public view returns(bool) {
72     return msg.sender == _owner;
73   }
74 
75   /**
76    * @dev Allows the current owner to relinquish control of the contract.
77    * @notice Renouncing to ownership will leave the contract without an owner.
78    * It will not be possible to call the functions with the `onlyOwner`
79    * modifier anymore.
80    */
81   function renounceOwnership() public onlyOwner {
82     emit OwnershipTransferred(_owner, address(0));
83     _owner = address(0);
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address newOwner) public onlyOwner {
91     _transferOwnership(newOwner);
92   }
93 
94   /**
95    * @dev Transfers control of the contract to a newOwner.
96    * @param newOwner The address to transfer ownership to.
97    */
98   function _transferOwnership(address newOwner) internal {
99     require(newOwner != address(0));
100     emit OwnershipTransferred(_owner, newOwner);
101     _owner = newOwner;
102   }
103 }
104 
105 // File: contracts\CreativesRegistry.sol
106 
107 pragma solidity ^0.4.21;
108 
109 
110 
111 contract CreativesRegistry is CreativesStorage, Ownable {
112 
113 	address private CONTRACT_ADDRESS;
114 
115 	function setContractAddress(address newContractAddress) public onlyOwner {
116 		CONTRACT_ADDRESS = newContractAddress;
117 	}
118 
119 	function () payable public {
120 		address target = CONTRACT_ADDRESS;
121 		assembly {
122 			// Copy the data sent to the memory address starting free mem position
123 			let ptr := mload(0x40)
124 			calldatacopy(ptr, 0, calldatasize)
125 			// Proxy the call to the contract address with the provided gas and data
126 			let result := delegatecall(gas, target, ptr, calldatasize, 0, 0)
127 			// Copy the data returned by the proxied call to memory
128 			let size := returndatasize
129 			returndatacopy(ptr, 0, size)
130 			// Check what the result is, return and revert accordingly
131 			switch result
132 			case 0 { revert(ptr, size) }
133 			case 1 { return(ptr, size) }
134 		}
135 	}
136 }