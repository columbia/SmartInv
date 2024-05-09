1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 // File: contracts/ContractRegistry.sol
68 
69 contract ContractRegistry is Ownable {
70 
71   uint8 public constant version = 1;
72   mapping (bytes32 => address) private contractAddresses;
73 
74   event UpdateContract(string name, address indexed contractAddress);
75 
76   /**
77     @notice Ensures that a given address is a contract by making sure it has code.
78    */
79   function isContract(address _address)
80     private
81     view
82     returns (bool)
83   {
84     uint256 _size;
85     assembly { _size := extcodesize(_address) }
86     return _size > 0;
87   }
88 
89   function updateContractAddress(string _name, address _address)
90     public
91     onlyOwner
92     returns (address)
93   {
94     require(isContract(_address));
95     require(_address != contractAddresses[keccak256(_name)]);
96 
97     contractAddresses[keccak256(_name)] = _address;
98     emit UpdateContract(_name, _address);
99 
100     return _address;
101   }
102 
103   function getContractAddress(string _name)
104     public
105     view
106     returns (address)
107   {
108     require(contractAddresses[keccak256(_name)] != address(0));
109     return contractAddresses[keccak256(_name)];
110   }
111 
112   function getContractAddress32(bytes32 _name32)
113     public
114     view
115     returns (address)
116   {
117     require(contractAddresses[_name32] != address(0));
118     return contractAddresses[_name32];
119   }
120 }