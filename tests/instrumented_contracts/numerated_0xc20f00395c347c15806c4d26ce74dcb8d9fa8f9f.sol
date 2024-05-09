1 pragma solidity ^0.4.2;
2 
3 contract Likedapp{
4 
5     //state variables
6 
7     //like options: 1 - I love you-heart!, 2 - like-smile, 3 - youre cool-glasses, 4 - ok-regular, 5 -I dislike-angry you, 0 - welcome :)
8 
9     //Model Raction
10     struct Reactions{
11         int8 action;
12         string message;
13     }
14 
15     //Model User
16     struct User {
17         uint id;
18         uint userReactionCount;
19         address user_address;
20         string username;
21         Reactions[] reactions;
22     }
23 
24     //Store User
25     User[] userStore;
26 
27     //Fetch User
28     //TO:do we need id or address to reference user
29     mapping(address => User) public users;
30     //Store User Count
31     uint public userCount;
32 
33     //message price
34     uint price = 0.00015 ether;
35 
36     //my own
37     address public iown;
38 
39     //event declaration
40     event UserCreated(uint indexed id);
41     event SentReaction(address user_address);
42 
43     //Constructor
44     constructor() public{
45         iown = msg.sender;
46     }
47 
48     function addUser(string _username) public {
49 
50         //check string length
51         require(bytes(_username).length > 1);
52 
53         //TO DO: Check if username exist
54         require(users[msg.sender].id == 0);
55 
56         userCount++;
57         userStore.length++;
58         User storage u = userStore[userStore.length - 1];
59         Reactions memory react = Reactions(0, "Welcome to LikeDapp! :D");
60         u.reactions.push(react);
61         u.id = userCount;
62         u.user_address = msg.sender;
63         u.username = _username;
64         u.userReactionCount++;
65         users[msg.sender] = u;
66 
67         //UserCreated(userCount);
68     }
69 
70 
71     function getUserReaction(uint _i) external view returns (int8,string){
72         require(_i >= 0);
73         return (users[msg.sender].reactions[_i].action, users[msg.sender].reactions[_i].message);
74     }
75 
76     function sendReaction(address _a, int8 _l, string _m) public payable {
77          require(_l >= 1 && _l <= 5);
78          require(users[_a].id > 0);
79 
80         if(bytes(_m).length >= 1){
81             buyMessage();
82         }
83 
84         users[_a].reactions.push(Reactions(_l, _m));
85         users[_a].userReactionCount++;
86 
87         //SentReaction(_a);
88     }
89 
90     function getUserCount() external view returns (uint){
91         return userCount;
92     }
93 
94     function getUsername() external view returns (string){
95         return users[msg.sender].username;
96     }
97 
98     function getUserReactionCount() external view returns (uint){
99         return users[msg.sender].userReactionCount;
100     }
101 
102     //Payments
103     function buyMessage() public payable{
104         require(msg.value >= price);
105     }
106 
107     function withdraw() external{
108         require(msg.sender == iown);
109         iown.transfer(address(this).balance);
110     }
111 
112     function withdrawAmount(uint amount) external{
113         require(msg.sender == iown);
114         iown.transfer(amount);
115     }
116 
117     //check accounts
118     function checkAccount(address _a) external view returns (bool){
119         if(users[_a].id == 0){
120          return false;
121        }
122        else{
123          return true;
124        }
125     }
126 
127     function amIin() external view returns (bool){
128         if(users[msg.sender].id == 0){
129             return false;
130         }
131         else{
132             return true;
133         }
134     }
135 
136 }