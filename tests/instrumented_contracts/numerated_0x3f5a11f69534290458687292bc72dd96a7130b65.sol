1 pragma solidity ^0.4.17;
2 
3 contract meOw {
4     uint256 public totalUsers;
5     
6     mapping ( address => mapping ( bytes32 => bool ) ) public counters;
7     mapping ( bytes32 => UserMeta ) public profiles;
8     
9     struct UserMeta {
10         address admin;
11         string username;
12         string name;
13         string bio;
14         string about;
15         uint positive_counter;
16         uint negative_counter;
17         uint time;
18         uint update_time;
19         bool status;
20     }
21     
22     
23     
24     function meOw() public {
25         
26     }
27     
28     function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
29         bytes memory tempEmptyStringTest = bytes(source);
30         if (tempEmptyStringTest.length == 0) {
31             return 0x0;
32         }
33     
34         assembly {
35             result := mload(add(source, 32))
36         }
37     }
38     
39     function _validateUserName(string _username) internal pure returns (bool){
40         bytes memory b = bytes(_username);
41         if(b.length > 32) return false;
42         
43         uint counter = 0;
44         for(uint i; i<b.length; i++){
45             bytes1 char = b[i];
46             
47             if(
48                 !(char >= 0x30 && char <= 0x39)   //9-0
49                 && !(char >= 0x61 && char <= 0x7A)  //a-z
50                 && !(char == 0x2D) // - 
51                 && !(char == 0x2E && counter == 0) // . 
52             ){
53                 return false;
54             }
55             
56             if(char == 0x2E) counter++; 
57         }
58     
59         return true;
60     }
61     
62     function register(
63         string _username, 
64         string _name, 
65         string _bio, 
66         string _about
67     ) public returns (bool _status) {
68         require( _validateUserName(_username) );
69         
70         bytes32 _unBytes = stringToBytes32(_username);
71         UserMeta storage u = profiles[_unBytes];
72         
73         require( !u.status );
74         
75         totalUsers++;
76         
77         u.admin = msg.sender;
78         u.username = _username;
79         u.name = _name;
80         u.bio = _bio;
81         u.about = _about;
82         u.time = now;
83         u.update_time = now;
84         u.status = true;
85         
86         _status = true;
87     }
88     
89     function update(
90         string _username, 
91         address _admin, 
92         string _name, 
93         string _bio, 
94         string _about
95     ) public returns (bool _status) {
96         bytes32 _unBytes = stringToBytes32(_username);
97         UserMeta storage u = profiles[_unBytes];
98         
99         require(
100             u.status 
101             && u.admin == msg.sender
102         );
103         
104         u.admin = _admin;
105         u.name = _name;
106         u.bio = _bio;
107         u.about = _about;
108         u.update_time = now;
109         
110         _status = true;
111     }
112     
113     function review(
114         string _username, 
115         bool _positive
116     ) public returns (bool _status) {
117         bytes32 _unBytes = stringToBytes32(_username);
118         UserMeta storage u = profiles[_unBytes];
119         
120         require( 
121             u.status 
122             && !counters[msg.sender][_unBytes]
123         );
124         
125         counters[msg.sender][_unBytes] = true;
126         
127         if(_positive){
128             u.positive_counter++;
129         } else {
130             u.negative_counter++;
131         }
132         
133         _status = true;
134     }
135     
136 }