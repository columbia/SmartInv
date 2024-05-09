1 pragma solidity ^0.4.2;
2 
3 contract CChain {
4 
5     //Model User
6     struct User {
7         int8 gifters;
8         uint id;
9         uint lineNo;
10         bool in_queue;
11         string uid;
12         address eth_address;
13        // bool newPayer;
14     }
15 
16     //Store User
17     User[] userStore;
18 
19     //Fetch User
20     mapping(address => User) public users;
21     mapping(uint => address) public intUsers;
22     //Store User Count
23     uint public userCount;
24     //pay price
25     //uint price = 0.10 ether;
26     //contract fee
27     //uint contract_price = 0.025 ether;
28     uint gift = 0.30 ether;
29     uint public total_price = 0.125 ether;
30     //my own
31     address public iown;
32 
33     uint public currentlyInLine;
34     uint public lineCount;
35 
36      //Constructor
37     constructor() public{
38         iown = msg.sender;
39         currentlyInLine = 0;
40         lineCount = 0;
41     }
42 
43     //add User to Contract
44     function addUser(string _user_id, address _user_address) private {
45         require(users[_user_address].id == 0);
46 
47         userCount++;
48         userStore.length++;
49         User storage u = userStore[userStore.length - 1];
50         u.id = userCount;
51         u.uid = _user_id;
52         u.eth_address = _user_address;
53         u.in_queue = false;
54         u.gifters = 0;
55 
56         users[_user_address] = u;
57         //intUsers[userCount] = _user_address;
58         //checkGifters();
59     }
60 
61 
62     //Pay to get in line
63     function getInLine(string _user_id, address _user_address) public payable returns (bool) {
64         require(msg.value >= total_price);
65         require(users[_user_address].in_queue == false);
66 
67         if(users[_user_address].id == 0) {
68             addUser(_user_id, _user_address);
69         }
70 
71         lineCount++;
72         User storage u = users[_user_address];
73         u.in_queue = true;
74         u.lineNo = lineCount;
75         intUsers[lineCount] = _user_address;
76 
77         checkGifters();
78 
79         return true;
80     }
81 
82     function checkGifters() private {
83         if(currentlyInLine == 0){
84             currentlyInLine = 1;
85         }
86         else{
87             address add = intUsers[currentlyInLine];
88             User storage u = users[add];
89             u.gifters++;
90             if(u.gifters == 3 && u.in_queue == true){
91                 u.in_queue = false;
92                 currentlyInLine++;
93             }
94         }
95     }
96 
97     //read your gifter
98     function getMyGifters(address _user_address) external view returns (int8) {
99         return users[_user_address].gifters;
100     }
101 
102     //user withdraw
103     function getGifted(address _user_address) external {
104         require(users[_user_address].id != 0);
105         require(users[_user_address].gifters == 3);
106 
107         if(users[_user_address].id != 0 && users[_user_address].gifters == 3){
108             _user_address.transfer(gift);
109             User storage u = users[_user_address];
110             u.gifters = 0;
111         }
112     }
113 
114     //admin
115     function withdraw() external{
116         require(msg.sender == iown);
117         iown.transfer(address(this).balance);
118     }
119 
120     function withdrawAmount(uint amount) external{
121         require(msg.sender == iown);
122         iown.transfer(amount);
123     }
124 
125     function getThisBalance() external view returns (uint) {
126         return address(this).balance;
127     }
128 
129 }