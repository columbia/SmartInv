1 pragma solidity ^ 0.4.17;
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
22 
23     /**
24     * @dev Throws if called by any account other than the owner.
25     */
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31 
32     /**
33     * @dev Allows the current owner to transfer control of the contract to a newOwner.
34     * @param newOwner The address to transfer ownership to.
35     */
36     function transferOwnership(address newOwner) onlyOwner public {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 
42 }
43 
44 
45 
46 // Whitelist smart contract
47 // This smart contract keeps list of addresses to whitelist
48 contract WhiteList is Ownable {
49 
50     
51     mapping(address => bool) public whiteList;
52     uint public totalWhiteListed; //white listed users number
53 
54     event LogWhiteListed(address indexed user, uint whiteListedNum);
55     event LogWhiteListedMultiple(uint whiteListedNum);
56     event LogRemoveWhiteListed(address indexed user);
57 
58 
59     // @notice it will return status of white listing
60     // @return true if user is white listed and false if is not
61     function isWhiteListed(address _user) public view returns (bool) {
62 
63         return whiteList[_user]; 
64     }
65 
66     // @notice it will remove whitelisted user
67     // @param _contributor {address} of user to unwhitelist
68     function removeFromWhiteList(address _user) onlyOwner() external returns (bool) {
69        
70         require(whiteList[_user] == true);
71         whiteList[_user] = false;
72         totalWhiteListed--;
73         LogRemoveWhiteListed(_user);
74         return true;
75     }
76 
77     // @notice it will white list one member
78     // @param _user {address} of user to whitelist
79     // @return true if successful
80     function addToWhiteList(address _user) onlyOwner() external returns (bool) {
81 
82         if (whiteList[_user] != true) {
83             whiteList[_user] = true;
84             totalWhiteListed++;
85             LogWhiteListed(_user, totalWhiteListed);            
86         }
87         return true;
88     }
89 
90     // @notice it will white list multiple members
91     // @param _user {address[]} of users to whitelist
92     // @return true if successful
93     function addToWhiteListMultiple(address[] _users) onlyOwner() external returns (bool) {
94 
95          for (uint i = 0; i < _users.length; ++i) {
96 
97             if (whiteList[_users[i]] != true) {
98                 whiteList[_users[i]] = true;
99                 totalWhiteListed++;                          
100             }           
101         }
102          LogWhiteListedMultiple(totalWhiteListed); 
103          return true;
104     }
105 }