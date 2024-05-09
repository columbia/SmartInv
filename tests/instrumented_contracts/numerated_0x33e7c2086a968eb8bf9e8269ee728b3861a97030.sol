1 pragma solidity ^0.4.24;
2 
3 contract Whitelist {
4   function isInWhitelist(address addr) public view returns (bool);
5 }
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    * @notice Renouncing to ownership will leave the contract without an owner.
42    * It will not be possible to call the functions with the `onlyOwner`
43    * modifier anymore.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address _newOwner) public onlyOwner {
55     _transferOwnership(_newOwner);
56   }
57 
58   /**
59    * @dev Transfers control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function _transferOwnership(address _newOwner) internal {
63     require(_newOwner != address(0));
64     emit OwnershipTransferred(owner, _newOwner);
65     owner = _newOwner;
66   }
67 }
68 
69 contract WhitelistImpl is Ownable, Whitelist {
70   mapping(address => bool) whitelist;
71   event WhitelistChange(address indexed addr, bool allow);
72 
73   function isInWhitelist(address addr) constant public returns (bool) {
74     return whitelist[addr];
75   }
76 
77   function addToWhitelist(address[] _addresses) public onlyOwner {
78     for (uint i = 0; i < _addresses.length; i++) {
79       setWhitelistInternal(_addresses[i], true);
80     }
81   }
82 
83   function removeFromWhitelist(address[] _addresses) public onlyOwner {
84     for (uint i = 0; i < _addresses.length; i++) {
85       setWhitelistInternal(_addresses[i], false);
86     }
87   }
88 
89   function setWhitelist(address addr, bool allow) public onlyOwner {
90     setWhitelistInternal(addr, allow);
91   }
92 
93   function setWhitelistInternal(address addr, bool allow) internal {
94     whitelist[addr] = allow;
95     emit WhitelistChange(addr, allow);
96   }
97 }