1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: contracts/v2/tools/SelfServiceAccessControls.sol
69 
70 contract SelfServiceAccessControls is Ownable {
71 
72   // Simple map to only allow certain artist create editions at first
73   mapping(address => bool) public allowedArtists;
74 
75   // When true any existing KO artist can mint their own editions
76   bool public openToAllArtist = false;
77 
78   /**
79    * @dev Controls is the contract is open to all
80    * @dev Only callable from owner
81    */
82   function setOpenToAllArtist(bool _openToAllArtist) onlyOwner public {
83     openToAllArtist = _openToAllArtist;
84   }
85 
86   /**
87    * @dev Controls who can call this contract
88    * @dev Only callable from owner
89    */
90   function setAllowedArtist(address _artist, bool _allowed) onlyOwner public {
91     allowedArtists[_artist] = _allowed;
92   }
93 
94   /**
95    * @dev Checks to see if the account can create editions
96    */
97   function isEnabledForAccount(address account) public view returns (bool) {
98     if (openToAllArtist) {
99       return true;
100     }
101     return allowedArtists[account];
102   }
103 
104   /**
105    * @dev Allows for the ability to extract stuck ether
106    * @dev Only callable from owner
107    */
108   function withdrawStuckEther(address _withdrawalAccount) onlyOwner public {
109     require(_withdrawalAccount != address(0), "Invalid address provided");
110     _withdrawalAccount.transfer(address(this).balance);
111   }
112 }