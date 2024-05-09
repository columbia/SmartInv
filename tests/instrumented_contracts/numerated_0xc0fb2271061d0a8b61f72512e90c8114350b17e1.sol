1 pragma solidity ^0.4.23;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
48 
49 /**
50  * @title Contactable token
51  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
52  * contact information.
53  */
54 contract Contactable is Ownable{
55 
56     string public contactInformation;
57 
58     /**
59      * @dev Allows the owner to set a string with their contact information.
60      * @param info The contact information to attach to the contract.
61      */
62     function setContactInformation(string info) onlyOwner public {
63          contactInformation = info;
64      }
65 }
66 
67 // File: contracts/MonethaUsersClaimStorage.sol
68 
69 /**
70  *  @title MonethaUsersClaimStorage
71  *
72  *  MonethaUsersClaimStorage is a storage contract. 
73  *  It will be used by MonethaUsersClaimHandler to update and delete user claim. 
74  */
75 contract MonethaUsersClaimStorage is Contactable {
76 
77     string constant VERSION = "0.1";
78     
79     // claimedTokens stores tokens claimed by the user.
80     mapping (address => uint256) public claimedTokens;
81 
82     event UpdatedClaim(address indexed _userAddress, uint256 _claimedTokens, bool _isDeleted);
83     event DeletedClaim(address indexed _userAddress, uint256 _unclaimedTokens, bool _isDeleted);
84 
85     /**
86      *  updateUserClaim updates user claim status and adds token to his wallet
87      *  @param _userAddress address of user's wallet
88      *  @param _tokens corresponds to user's token that is to be claimed.
89      */
90     function updateUserClaim(address _userAddress, uint256 _tokens)
91         external onlyOwner returns (bool)
92     {
93         claimedTokens[_userAddress] = claimedTokens[_userAddress] + _tokens;
94 
95         emit UpdatedClaim(_userAddress, _tokens, false);
96         
97         return true;
98     }
99     
100     /**
101      *  updateUserClaimInBulk updates multiple users claim status and adds token to their wallet
102      */
103     function updateUserClaimInBulk(address[] _userAddresses, uint256[] _tokens)
104         external onlyOwner returns (bool)
105     {
106         require(_userAddresses.length == _tokens.length);
107 
108         for (uint16 i = 0; i < _userAddresses.length; i++) {
109             claimedTokens[_userAddresses[i]] = claimedTokens[_userAddresses[i]] + _tokens[i];
110 
111             emit UpdatedClaim(_userAddresses[i], _tokens[i], false);
112         }
113 
114         return true;
115     }
116 
117     /**
118      *  deleteUserClaim deletes user account
119      *  @param _userAddress corresponds to address of user's wallet
120      */
121     function deleteUserClaim(address _userAddress)
122         external onlyOwner returns (bool)
123     {
124         delete claimedTokens[_userAddress];
125 
126         emit DeletedClaim(_userAddress, 0, true);
127 
128         return true;
129     }
130 
131     /**
132      *  deleteUserClaimInBulk deletes user account in bulk
133      */
134     function deleteUserClaimInBulk(address[] _userAddresses)
135         external onlyOwner returns (bool)
136     {
137         for (uint16 i = 0; i < _userAddresses.length; i++) {
138             delete claimedTokens[_userAddresses[i]];
139 
140             emit DeletedClaim(_userAddresses[i], 0, true);
141         }
142 
143         return true;
144     }
145 }