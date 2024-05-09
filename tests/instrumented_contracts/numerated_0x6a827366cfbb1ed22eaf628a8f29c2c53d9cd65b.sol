1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 contract Whitelist is Ownable {
70 
71   mapping(address => bool) public isAddressWhitelist;
72 
73   event LogWhitelistAdded(address indexed participant, uint256 timestamp);
74   event LogWhitelistDeleted(address indexed participant, uint256 timestamp);
75 
76   constructor() public {}
77 
78   function isWhite(address participant) public view returns (bool) {
79     return isAddressWhitelist[participant];
80   }
81 
82   function addWhitelist(address[] participants) public onlyOwner returns (bool) {
83     for (uint256 i = 0; i < participants.length; i++) {
84       isAddressWhitelist[participants[i]] = true;
85 
86       emit LogWhitelistAdded(participants[i], now);
87     }
88 
89     return true;
90   }
91 
92   function delWhitelist(address[] participants) public onlyOwner returns (bool) {
93     for (uint256 i = 0; i < participants.length; i++) {
94       isAddressWhitelist[participants[i]] = false;
95 
96       emit LogWhitelistDeleted(participants[i], now);
97     }
98 
99     return true;
100   }
101 }