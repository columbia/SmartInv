1 pragma solidity ^0.4.24;
2 
3 /// @author David Li <davidli012345@gmail.com>
4 /// @dev basic authentication contract
5 /// @notice tracks list of all users
6 contract Authentication {
7   struct User {
8     bytes32 name;
9     uint256 created_at;
10   }
11   
12   event UserCreated(address indexed _address, bytes32 _name, uint256 _created_at);
13   event UserUpdated(address indexed _address, bytes32 _name);
14   event UserDeleted(address indexed _address);
15   
16   // make info public???
17   mapping (address => User) private users;
18   
19   // public array that contains list of all users that have registered 
20   address[] public allUsers;
21   modifier onlyExistingUser {
22     // Check if user exists or terminate
23 
24     require(!(users[msg.sender].name == 0x0));
25     _;
26   }
27 
28   modifier onlyValidName(bytes32 name) {
29     // Only valid names allowed
30 
31     require(!(name == 0x0));
32     _;
33   }
34   
35   /// @return username
36   function login() 
37   public
38   view 
39   onlyExistingUser
40   returns (bytes32) {
41     return (users[msg.sender].name);
42   }
43   
44   /// @param name the username to be created. 
45   /// @dev checks if user exists
46   /// If yes return user name 
47   /// If no, check if name was sent 
48   /// If yes, create and return user 
49   /// @return username of created user
50   function signup(bytes32 name)
51   public
52   payable
53   onlyValidName(name)
54   returns (bytes32) {
55 
56     if (users[msg.sender].name == 0x0)
57     {
58         users[msg.sender].name = name;
59 	    users[msg.sender].created_at = now;
60         
61         allUsers.push(msg.sender);
62         emit UserCreated(msg.sender,name,now);
63         return (users[msg.sender].name);
64     }
65 
66     return (users[msg.sender].name);
67   }
68   
69   /// @param name updating username
70   /// @dev updating user name 
71   /// @return updated username 
72   function update(bytes32 name)
73   public
74   payable
75   onlyValidName(name)
76   onlyExistingUser
77   returns (bytes32) {
78     // Update user name.
79 
80     if (users[msg.sender].name != 0x0)
81     {
82         users[msg.sender].name = name;
83         
84         emit UserUpdated(msg.sender,name);
85  
86         return (users[msg.sender].name);
87     }
88   }
89   
90   /// @dev destroy existing username 
91   function destroy () 
92   public 
93   onlyExistingUser {
94     delete users[msg.sender];
95     emit UserDeleted(msg.sender);
96   }
97 }