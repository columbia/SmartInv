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
49     mapping(address => address) public affiliates;
50     uint public totalWhiteListed; //white listed users number
51 
52     event LogWhiteListed(address indexed user, address affiliate, uint whiteListedNum);
53     event LogWhiteListedMultiple(uint whiteListedNum);
54     event LogRemoveWhiteListed(address indexed user);
55 
56     // @notice it will return status of white listing
57     // @return true if user is white listed and false if is not
58     function isWhiteListedAndAffiliate(address _user) external view returns (bool, address) {
59         return (whiteList[_user], affiliates[_user]); 
60     }
61 
62     // @notice it will return refferal address 
63     // @param _user {address} address of contributor
64     function returnReferral(address _user) external view returns (address) {
65         return  affiliates[_user];
66     
67     }
68 
69     // @notice it will remove whitelisted user
70     // @param _contributor {address} of user to unwhitelist
71     function removeFromWhiteList(address _user) external onlyOwner() returns (bool) {
72        
73         require(whiteList[_user] == true);
74         whiteList[_user] = false;
75         affiliates[_user] = address(0);
76         totalWhiteListed--;
77         LogRemoveWhiteListed(_user);
78         return true;
79     }
80 
81     // @notice it will white list one member
82     // @param _user {address} of user to whitelist
83     // @return true if successful
84     function addToWhiteList(address _user, address _affiliate) external onlyOwner() returns (bool) {
85 
86         if (whiteList[_user] != true) {
87             whiteList[_user] = true;
88             affiliates[_user] = _affiliate;
89             totalWhiteListed++;
90             LogWhiteListed(_user, _affiliate, totalWhiteListed);            
91         }
92         return true;
93     }
94 
95     // @notice it will white list multiple members
96     // @param _user {address[]} of users to whitelist
97     // @return true if successful
98     function addToWhiteListMultiple(address[] _users, address[] _affiliate) external onlyOwner() returns (bool) {
99 
100         for (uint i = 0; i < _users.length; ++i) {
101 
102             if (whiteList[_users[i]] != true) {
103                 whiteList[_users[i]] = true;
104                 affiliates[_users[i]] = _affiliate[i];
105                 totalWhiteListed++;                          
106             }           
107         }
108         LogWhiteListedMultiple(totalWhiteListed); 
109         return true;
110     }
111 }