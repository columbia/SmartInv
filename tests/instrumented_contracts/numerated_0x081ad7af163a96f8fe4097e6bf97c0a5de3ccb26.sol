1 pragma solidity ^0.4.4;
2 
3 
4 contract TeamContract {
5 
6   address   contractOwner;
7 //sssss
8   struct Team {
9     //internal fields
10     uint      index;
11     address   owner;
12     uint      lastUpdated;
13     bool initialized;
14     //generated fields
15     string team; 
16 string lead; 
17 string size; 
18 string description; 
19 string github; 
20 
21 
22 
23   }
24 
25   mapping(bytes32 => Team) public teamMap;
26   bytes32[] public teamArray;
27 
28   function TeamContract() public {
29     contractOwner = msg.sender;
30   }
31 
32   // Creates Team
33   function createTeam(bytes32 id,
34         //generated fields
35         string team, string lead, string size, string description, string github)
36         public returns (bool) {
37 
38     //team already exists
39      require (teamMap[id].owner == address(0));
40 
41     //create new team
42     //internal fields
43     teamMap[id].index = teamArray.length;
44     teamArray.push(id);
45     teamMap[id].owner = msg.sender;
46     teamMap[id].lastUpdated = now;
47     //generated fields
48     teamMap[id].team=team;
49  teamMap[id].lead=lead;
50  teamMap[id].size=size;
51  teamMap[id].description=description;
52  teamMap[id].github=github;
53     TeamCreated(id,
54         //generated fields - only param 1???
55         team, lead, size, description, github);
56     return true;
57   }
58 
59   // Returns an Team by id
60   function  readTeam(bytes32 id) constant public returns (address,uint,
61       //generated fields
62       string, string, string, string, string) {
63     return (teamMap[id].owner, teamMap[id].lastUpdated,
64       //generated fields
65             teamMap[id].team, teamMap[id].lead, teamMap[id].size, teamMap[id].description, teamMap[id].github);
66   }
67 
68   // Returns an Team by index
69   function  readTeamByIndex(uint index) constant public returns (address,uint,
70       //generated fields
71         string, string, string, string, string) {
72     require(index < teamArray.length);
73     bytes32 id = teamArray[index];
74     return (teamMap[id].owner, teamMap[id].lastUpdated,
75       //generated fields
76             teamMap[id].team, teamMap[id].lead, teamMap[id].size, teamMap[id].description, teamMap[id].github);
77   }
78  // Updates Team
79   function updateTeam(bytes32 id,
80         //generated fields
81         string team, string lead, string size, string description, string github)
82         public  returns (bool) {
83     //team should exist
84     require (teamMap[id].owner != address(0));
85     require (teamMap[id].owner == msg.sender || contractOwner == msg.sender); //only team owner or contract owner can update
86 
87     teamMap[id].lastUpdated = now;
88     //generated fields
89     teamMap[id].team=team;
90  teamMap[id].lead=lead;
91  teamMap[id].size=size;
92  teamMap[id].description=description;
93  teamMap[id].github=github;
94     TeamUpdated(id,
95         //generated fields - only param 1???
96         team, lead, size, description, github);
97     return true;
98   }
99 
100   // Deletes Team
101   function deleteTeam  (bytes32 id) public  returns (bool) {
102     //team should  exist
103     require (teamMap[id].owner != address(0));
104     require (teamMap[id].owner == msg.sender || contractOwner == msg.sender); //only team owner or contract owner can update
105 
106     var i = teamMap[id].index;
107     var lastTeam = teamArray[teamArray.length-1];
108     teamMap[lastTeam].index = i;
109     teamArray[i] = lastTeam;
110     teamArray.length--;
111 
112 
113     TeamDeleted(id,
114         //generated fields - only param 1???
115         teamMap[id].team, teamMap[id].lead, teamMap[id].size, teamMap[id].description, teamMap[id].github );
116     delete(teamMap[id]);
117     return true;
118   }
119 
120   // Returns teamCount
121   function  countTeam() constant public returns (uint) {
122     return teamArray.length;
123   }
124 
125 
126   event TeamCreated(bytes32 indexed _id,
127         string team, string lead, string size, string description, string github);
128   event TeamUpdated(bytes32 indexed _id,
129         string team, string lead, string size, string description, string github);
130   event TeamDeleted(bytes32 indexed _id,
131         string team, string lead, string size, string description, string github);
132 
133 }