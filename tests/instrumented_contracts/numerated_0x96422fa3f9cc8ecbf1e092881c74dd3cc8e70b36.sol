1 pragma solidity 0.4.24;
2 
3 // File: contracts/lib/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
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
31     require(msg.sender == owner, "only owner is able to call this function");
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 // File: contracts/Whitelist.sol
66 
67 /**
68  * @title Whitelist - crowdsale whitelist contract
69  * @author Gustavo Guimaraes - <gustavo@starbase.co>
70  */
71 contract Whitelist is Ownable {
72     mapping(address => bool) public allowedAddresses;
73 
74     event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);
75 
76     /**
77     * @dev Adds single address to whitelist.
78     * @param _address Address to be added to the whitelist
79     */
80     function addToWhitelist(address _address) external onlyOwner {
81         allowedAddresses[_address] = true;
82         emit WhitelistUpdated(now, "Added", _address);
83     }
84 
85     /**
86      * @dev add various whitelist addresses
87      * @param _addresses Array of ethereum addresses
88      */
89     function addManyToWhitelist(address[] _addresses) external onlyOwner {
90         for (uint256 i = 0; i < _addresses.length; i++) {
91             allowedAddresses[_addresses[i]] = true;
92             emit WhitelistUpdated(now, "Added", _addresses[i]);
93         }
94     }
95 
96     /**
97      * @dev remove whitelist addresses
98      * @param _addresses Array of ethereum addresses
99      */
100     function removeManyFromWhitelist(address[] _addresses) public onlyOwner {
101         for (uint256 i = 0; i < _addresses.length; i++) {
102             allowedAddresses[_addresses[i]] = false;
103             emit WhitelistUpdated(now, "Removed", _addresses[i]);
104         }
105     }
106 }