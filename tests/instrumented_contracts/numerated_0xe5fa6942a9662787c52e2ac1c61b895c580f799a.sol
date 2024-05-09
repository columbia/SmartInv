1 pragma solidity ^0.4.24;
2 
3 /**
4  * Powered by Daonomic (https://daonomic.io)
5  */
6 
7 contract Whitelist {
8   function isInWhitelist(address addr) public view returns (bool);
9 }
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   constructor() public {
32     owner = msg.sender;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   /**
44    * @dev Allows the current owner to relinquish control of the contract.
45    * @notice Renouncing to ownership will leave the contract without an owner.
46    * It will not be possible to call the functions with the `onlyOwner`
47    * modifier anymore.
48    */
49   function renounceOwnership() public onlyOwner {
50     emit OwnershipRenounced(owner);
51     owner = address(0);
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address _newOwner) public onlyOwner {
59     _transferOwnership(_newOwner);
60   }
61 
62   /**
63    * @dev Transfers control of the contract to a newOwner.
64    * @param _newOwner The address to transfer ownership to.
65    */
66   function _transferOwnership(address _newOwner) internal {
67     require(_newOwner != address(0));
68     emit OwnershipTransferred(owner, _newOwner);
69     owner = _newOwner;
70   }
71 }
72 
73 contract WhitelistImpl is Ownable, Whitelist {
74   mapping(address => bool) whitelist;
75   event WhitelistChange(address indexed addr, bool allow);
76 
77   function isInWhitelist(address addr) constant public returns (bool) {
78     return whitelist[addr];
79   }
80 
81   function addToWhitelist(address[] _addresses) public onlyOwner {
82     for (uint i = 0; i < _addresses.length; i++) {
83       setWhitelistInternal(_addresses[i], true);
84     }
85   }
86 
87   function removeFromWhitelist(address[] _addresses) public onlyOwner {
88     for (uint i = 0; i < _addresses.length; i++) {
89       setWhitelistInternal(_addresses[i], false);
90     }
91   }
92 
93   function setWhitelist(address addr, bool allow) public onlyOwner {
94     setWhitelistInternal(addr, allow);
95   }
96 
97   function setWhitelistInternal(address addr, bool allow) internal {
98     whitelist[addr] = allow;
99     emit WhitelistChange(addr, allow);
100   }
101 }