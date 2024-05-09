1 // This MasterRegistry keeps a list of all registries created using Regis.
2 // From it, you can search registries by its name, tags or owner and retrieve
3 // registries info.
4 
5 contract MasterRegistry {
6 
7     // This struct keeps a list of attributes that all registries have.
8     struct RegistryAttributes {
9         uint      creationTime;
10         string    description;
11         address   owner;
12         string    name;
13         bytes32[] tags;
14         uint      version; // To keep backward compatibility
15         uint      addressIndex; // Index in the addresses array for quick lookup.
16 
17         // Keeps the solidity source of the registry
18         // Storing the source on the blockchain is expensive but it is worth it. 
19         // Previous version didn't store and was able to rebuild the registry
20         // source from its parameters. But this showed to be problematic in 
21         // some cases.
22         string source; 
23         // To keep backward compatibility with version 1, source will have 
24         // keyType and recordAttributes stored in the source variable and the
25         // solidity source for those old registries will be unavailable.
26     }
27 
28     // Maps registry's address to its record.
29     mapping (address => RegistryAttributes) public registries;
30     uint public numRegistries;
31 
32     // Keeps a list of all registries' addresses
33     address[] public addresses;
34 
35     // maps owner -> list of registries' addresses
36     mapping (address => address[]) public indexedByOwner;
37 
38     // maps tag -> list of registries' addresses
39     mapping (bytes32 => address[]) public indexedByTag;
40 
41     // maps name -> list of registries' addresses
42     mapping (string => address[]) indexedByName; // cant use public here because it's indexed by string
43 
44     modifier onlyOwner(address regAddress) {
45         if (registries[regAddress].owner != msg.sender) throw;
46         _
47     }
48 
49     function addRegistryIntoOwnerIndex(address regAddress, address owner) internal {
50         address[] regs = indexedByOwner[owner];
51         regs.length++;
52         regs[regs.length - 1] = regAddress;
53     }
54 
55     function addRegistryIntoNameIndex(address regAddress) internal {
56         address[] regs = indexedByName[registries[regAddress].name];
57         regs.length++;
58         regs[regs.length - 1] = regAddress;
59     }
60 
61     function addRegistryIntoTagsIndex(address regAddress) internal {
62         bytes32[] tags = registries[regAddress].tags;
63         for (uint i = 0; i < tags.length; i++) {
64             address[] regs = indexedByTag[tags[i]];
65             regs.length++;
66             regs[regs.length - 1] = regAddress;
67         }
68     }
69 
70     function register(address regAddress, address owner, string name, string description, 
71                       bytes32[] tags, uint version, string source) {
72 
73         if (registries[regAddress].creationTime != 0) {
74             // throw;
75             return;
76         }
77 
78         registries[regAddress].creationTime = now;
79         //registries[regAddress].owner        = msg.sender;
80         registries[regAddress].owner        = owner;
81         registries[regAddress].description  = description;
82         registries[regAddress].name         = name;
83         registries[regAddress].version      = version;
84         registries[regAddress].tags         = tags;
85         registries[regAddress].source       = source;
86         registries[regAddress].addressIndex = numRegistries;
87         numRegistries++;
88 
89         addresses.length++;
90         addresses[numRegistries - 1] = regAddress;
91 
92         addRegistryIntoOwnerIndex(regAddress, owner);
93 
94         addRegistryIntoNameIndex(regAddress);
95 
96         addRegistryIntoTagsIndex(regAddress);
97 
98     }
99 
100     function removeRegistryFromOwnerIndex(address regAddress) internal {
101         address[] regs = indexedByOwner[msg.sender];
102         for (uint i = 0; i < regs.length; i++) {
103             if (regs[i] == regAddress) {
104                 regs[i] = regs[regs.length - 1];
105                 regs.length--;
106                 break;
107             }
108         }
109     }
110 
111     function removeRegistryFromNameIndex(address regAddress) internal {
112         address[] regs = indexedByName[registries[regAddress].name];
113         for (uint j = 0; j < regs.length; j++) {
114             if (regs[j] == regAddress) {
115                 regs[j] = regs[regs.length - 1];
116                 regs.length--;
117                 break;
118             }
119         }
120     }
121 
122     function removeRegistryFromTagsIndex(address regAddress) internal {
123         uint numTags = registries[regAddress].tags.length;
124         for (uint k = 0; k < numTags; k++) {
125             address[] regs = indexedByTag[registries[regAddress].tags[k]];
126             for (uint l = 0; l < regs.length; l++) {
127                 if (regs[l] == regAddress) {
128                     regs[l] = regs[regs.length - 1];
129                     regs.length--;
130                     break;
131                 }
132             }
133         }
134     }
135 
136     function unregister(address regAddress) onlyOwner(regAddress) {
137 
138         removeRegistryFromOwnerIndex(regAddress);
139         removeRegistryFromNameIndex(regAddress);
140         removeRegistryFromTagsIndex(regAddress);
141 
142         addresses[registries[regAddress].addressIndex] = addresses[addresses.length - 1];
143         addresses.length--;
144 
145         delete registries[regAddress];
146         numRegistries--;
147     }
148 
149     function changeDescription(address regAddress, string newDescription) onlyOwner(regAddress) {
150         registries[regAddress].description = newDescription;
151     }
152 
153     function changeName(address regAddress, string newName) onlyOwner(regAddress) {
154         removeRegistryFromNameIndex(regAddress);
155         registries[regAddress].name = newName;
156         addRegistryIntoNameIndex(regAddress);
157     }
158 
159     function transfer(address regAddress, address newOwner) onlyOwner(regAddress) {
160         removeRegistryFromOwnerIndex(regAddress);
161         registries[regAddress].owner = newOwner;
162         addRegistryIntoOwnerIndex(regAddress, newOwner);
163     }
164 
165     function searchByName(string name) constant returns (address[]) {
166         return indexedByName[name];
167     }
168 
169     function searchByTag(bytes32 tag) constant returns (address[]) {
170         return indexedByTag[tag];
171     }
172 
173     function searchByOwner(address owner) constant returns (address[]) {
174         return indexedByOwner[owner];
175     }
176 
177     function getRegInfo(address regAddress) constant returns (address owner, uint creationTime, 
178                         string name, string description, uint version, bytes32[] tags, string source) {
179         owner        = registries[regAddress].owner;
180         creationTime = registries[regAddress].creationTime;
181         name         = registries[regAddress].name;
182         description  = registries[regAddress].description;
183         version      = registries[regAddress].version;
184         tags         = registries[regAddress].tags;
185         source       = registries[regAddress].source;
186     }
187 
188     // This function is only valid for a very small amount of time
189     // after which it will become useless!
190     // It was used to migrate registries from old MasterRegistry
191     // into this new one and fix old registries creation_time (which
192     // are now inside the registry itself).
193     function setTime(address regAddress, uint time) {
194         if (now < 1469830946) { // Valid up to 29-Jul-2016 19:22:26
195             registries[regAddress].creationTime = time;
196         }
197     }
198 
199 }