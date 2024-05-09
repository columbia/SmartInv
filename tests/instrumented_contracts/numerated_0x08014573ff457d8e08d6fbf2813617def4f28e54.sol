1 pragma solidity ^0.4.24;
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
67 // File: contracts/Affiliate.sol
68 
69 // solhint-disable-next-line
70 pragma solidity ^0.4.25;
71 
72 
73 
74 /** @title Affiliate */
75 contract Affiliate is Ownable {
76     mapping(address => bool) public canSetAffiliate;
77     mapping(address => address) public userToAffiliate;
78 
79     /** @dev Allows an address to set the affiliate address for a user
80       * @param _setter The address that should be allowed
81       */
82     function setAffiliateSetter(address _setter) public onlyOwner {
83         canSetAffiliate[_setter] = true;
84     }
85 
86     /**
87      * @dev Set the affiliate of a user
88      * @param _user user to set affiliate for
89      * @param _affiliate address to set
90      */
91     function setAffiliate(address _user, address _affiliate) public {
92         require(canSetAffiliate[msg.sender]);
93         if (userToAffiliate[_user] == address(0)) {
94             userToAffiliate[_user] = _affiliate;
95         }
96     }
97 
98 }