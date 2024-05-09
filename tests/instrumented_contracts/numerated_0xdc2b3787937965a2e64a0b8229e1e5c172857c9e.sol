1 pragma solidity ^0.4.19;
2 
3 /*
4 PostManager
5 */
6 contract PostManager {
7     
8     // MARK:- Enums
9 	
10 	enum State { Inactive, Created, Completed }
11     
12     // MARK:- Structs
13     
14     struct Post {
15  	    bytes32 jsonHash;   // JSON Hash
16  	    uint value;         // Value
17     }
18 
19 	// MARK:- Modifiers
20 
21     /*
22     Is the actor the owner of this contract?
23     */
24     modifier isOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28     
29      /*
30     Is the actor part of the admin group, or are they the owner?
31     */
32     modifier isAdminGroupOrOwner() {
33         require(containsAdmin(msg.sender) || msg.sender == owner);
34         _;
35     }
36 
37 	// MARK:- Properties
38 	
39 	uint constant version = 1;                  // Version
40 
41 	address owner;                              // Creator of the contract
42 	mapping(address => Post) posts;             // Posts
43 	mapping(address => address) administrators; // Administrators
44     
45     // MARK:- Events
46 	event AdminAdded(address _adminAddress);
47 	event AdminDeleted(address _adminAddress);
48 	event PostAdded(address _fromAddress);
49 	event PostCompleted(address _fromAddress, address _toAddress);
50 
51     // MARK:- Methods
52     
53     /*
54     Constructor
55     */
56     function PostManager() public {
57        owner = msg.sender;
58     } 
59     
60     /*
61 	Get contract version
62 	*/
63 	function getVersion() public constant returns (uint) {
64 		return version;
65 	}
66         
67     // MARK:- Admin
68     
69     /*
70     Add an administrator
71     */
72     function addAdmin(address _adminAddress) public isOwner {
73         administrators[_adminAddress] = _adminAddress;
74         AdminAdded(_adminAddress);
75     }
76     
77     /*
78     Delete an administrator
79     */
80     function deleteAdmin(address _adminAddress) public isOwner {
81         delete administrators[_adminAddress];
82         AdminDeleted(_adminAddress);
83     }
84     
85     /*
86     Check if an address is an administrator
87     */
88     function containsAdmin(address _adminAddress) public constant returns (bool) {
89         return administrators[_adminAddress] != 0;
90     }
91     
92     /*
93     Add a post
94     */
95     function addPost(bytes32 _jsonHash) public payable {
96         
97         // Ensure post not already created
98         require(posts[msg.sender].value != 0);
99         
100         // Create post
101         var post = Post(_jsonHash, msg.value);
102         posts[msg.sender] = post;
103 
104         PostAdded(msg.sender);
105     }
106     
107     /*
108 	Complete post
109 	*/
110 	function completePost(address _fromAddress, address _toAddress) public isAdminGroupOrOwner() {
111 	
112 		// If owner wants funds, ignore
113 		require(_toAddress != _fromAddress);
114 
115         var post = posts[_fromAddress];
116         
117         // Make sure post exists
118         require(post.value != 0);
119 
120         // Transfer funds
121         _toAddress.transfer(post.value);
122         
123         // Mark complete
124         delete posts[_fromAddress];
125         
126         // Send event
127         PostCompleted(_fromAddress, _toAddress);
128     }
129     
130     function() public payable {
131     }
132     
133 }