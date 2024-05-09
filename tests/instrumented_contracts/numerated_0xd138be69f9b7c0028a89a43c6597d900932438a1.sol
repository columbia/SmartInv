1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title DealsRootStorage
79  * @dev Storage for precalculated merkle roots.
80  */
81 contract DealsRootStorage is Ownable {
82   mapping(uint256 => bytes32) roots;
83   uint256 public lastTimestamp = 0;
84 
85   /**
86    * @dev Sets merkle root at the specified timestamp.
87    */
88   function setRoot(uint256 _timestamp, bytes32 _root) onlyOwner public returns (bool) {
89     require(_timestamp > 0);
90     require(roots[_timestamp] == 0);
91 
92     roots[_timestamp] = _root;
93     lastTimestamp = _timestamp;
94 
95     return true;
96   }
97 
98   /**
99    * @dev Gets last available merkle root.
100    */
101   function lastRoot() public view returns (bytes32) {
102     return roots[lastTimestamp];
103   }
104 
105   /**
106    * @dev Gets merkle root by the specified timestamp.
107    */
108   function getRoot(uint256 _timestamp) public view returns (bytes32) {
109     return roots[_timestamp];
110   }
111 }