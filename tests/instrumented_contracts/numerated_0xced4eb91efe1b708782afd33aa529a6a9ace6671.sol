1 pragma solidity ^ 0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11     
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     function Ownable() public {
19         owner = msg.sender;
20     }
21 
22     /**
23     * @dev Throws if called by any account other than the owner.
24     */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     /**
31     * @dev Allows the current owner to transfer control of the contract to a newOwner.
32     * @param newOwner The address to transfer ownership to.
33     */
34     function transferOwnership(address newOwner) onlyOwner public {
35         require(newOwner != address(0));
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38     }
39 
40 }
41 
42 
43 // Whitelist smart contract
44 // This smart contract keeps list of addresses to whitelist
45 contract WhiteList is Ownable {
46 
47     
48     mapping(address => bool) public whiteList;
49     uint public totalWhiteListed; //white listed users number
50 
51     event LogWhiteListed(address indexed user, uint whiteListedNum);
52     event LogWhiteListedMultiple(uint whiteListedNum);
53     event LogRemoveWhiteListed(address indexed user);
54 
55     // @notice it will return status of white listing
56     // @return true if user is white listed and false if is not
57     function isWhiteListed(address _user) external view returns (bool) {
58 
59         return whiteList[_user]; 
60     }
61 
62     // @notice it will remove whitelisted user
63     // @param _contributor {address} of user to unwhitelist
64     function removeFromWhiteList(address _user) external onlyOwner() returns (bool) {
65        
66         require(whiteList[_user] == true);
67         whiteList[_user] = false;
68         totalWhiteListed--;
69         LogRemoveWhiteListed(_user);
70         return true;
71     }
72 
73     // @notice it will white list one member
74     // @param _user {address} of user to whitelist
75     // @return true if successful
76     function addToWhiteList(address _user) external onlyOwner() returns (bool) {
77 
78         if (whiteList[_user] != true) {
79             whiteList[_user] = true;
80             totalWhiteListed++;
81             LogWhiteListed(_user, totalWhiteListed);            
82         }
83         return true;
84     }
85 
86     // @notice it will white list multiple members
87     // @param _user {address[]} of users to whitelist
88     // @return true if successful
89     function addToWhiteListMultiple(address[] _users) external onlyOwner() returns (bool) {
90 
91         for (uint i = 0; i < _users.length; ++i) {
92 
93             if (whiteList[_users[i]] != true) {
94                 whiteList[_users[i]] = true;
95                 totalWhiteListed++;                          
96             }           
97         }
98         LogWhiteListedMultiple(totalWhiteListed); 
99         return true;
100     }
101 }