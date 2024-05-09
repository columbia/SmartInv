1 pragma solidity ^0.4.24;
2 
3 contract LIMITED_42 {
4 
5     struct PatternOBJ {
6         address owner;
7         string message;
8         string data;
9     }
10 
11     mapping(address => bytes32[]) public Patterns;
12     mapping(bytes32 => PatternOBJ) public Pattern;
13 
14     string public info = "";
15 
16     address private constant emergency_admin = 0x59ab67D9BA5a748591bB79Ce223606A8C2892E6d;
17     address private constant first_admin = 0x9a203e2E251849a26566EBF94043D74FEeb0011c;
18     address private admin = 0x9a203e2E251849a26566EBF94043D74FEeb0011c;
19 
20 
21     /**************************************************************************
22     * modifiers
23     ***************************************************************************/
24 
25     modifier onlyAdmin {
26         require(msg.sender == admin);
27         _;
28     }
29 
30     /**************************************************************************
31     * functionS
32     ***************************************************************************/
33 
34     function checkPatternExistance (bytes32 patternid) public view
35     returns(bool)
36     {
37       if(Pattern[patternid].owner == address(0)){
38         return false;
39       }else{
40         return true;
41       }
42     }
43 
44     function createPattern(bytes32 patternid, string dataMixed, address newowner, string message)
45         onlyAdmin
46         public
47         returns(string)
48     {
49       //CONVERT DATA to UPPERCASE
50       string memory data = toUpper(dataMixed);
51 
52       //FIRST CHECK IF PATTERNID AND DATA HASH MATCH!!!
53       require(keccak256(abi.encodePacked(data)) == patternid);
54 
55       //no ownerless Pattern // also possible to gift Pattern
56       require(newowner != address(0));
57 
58       //check EXISTANCE
59       if(Pattern[patternid].owner == address(0)){
60           //IF DOENST EXIST
61 
62           //create pattern at coresponding id
63           Pattern[patternid].owner = newowner;
64           Pattern[patternid].message = message;
65           Pattern[patternid].data = data;
66 
67           addPatternUserIndex(newowner,patternid);
68 
69           return "ok";
70 
71       }else{
72           //must be for sale
73           return "error:exists";
74       }
75 
76     }
77     function transferPattern(bytes32 patternid,address newowner,string message, uint8 v, bytes32 r, bytes32 s)
78       public
79       returns(string)
80     {
81       // just so we have somthing
82       address oldowner = admin;
83 
84       //check that pattern in question has an owner
85       require(Pattern[patternid].owner != address(0));
86 
87       //check that newowner is not no one
88       require(newowner != address(0));
89 
90       //check if sender iis owner
91       if(Pattern[patternid].owner == msg.sender){
92         //if sender iiis owner
93         oldowner = msg.sender;
94       }else{
95         // anyone else need to supply a new address signed by the old owner
96 
97         //generate the h for the new address
98         bytes32 h = prefixedHash2(newowner);
99         //check if eveything adds up.
100         require(ecrecover(h, v, r, s) == Pattern[patternid].owner);
101         oldowner = Pattern[patternid].owner;
102       }
103 
104       //remove reference from old owner mapping
105       removePatternUserIndex(oldowner,patternid);
106 
107       //update pattern owner and message
108       Pattern[patternid].owner = newowner;
109       Pattern[patternid].message = message;
110       //add reference to owner map
111       addPatternUserIndex(newowner,patternid);
112 
113       return "ok";
114 
115     }
116 
117     function changeMessage(bytes32 patternid,string message, uint8 v, bytes32 r, bytes32 s)
118       public
119       returns(string)
120     {
121       // just so we have somthing
122       address owner = admin;
123 
124       //check that pattern in question has an owner
125       require(Pattern[patternid].owner != address(0));
126 
127       //check if sender iis owner
128       if(Pattern[patternid].owner == msg.sender){
129         //if sender iiis owner
130         owner = msg.sender;
131       }else{
132         // anyone else need to supply a new address signed by the old owner
133 
134         //generate the h for the new address
135         bytes32 h = prefixedHash(message);
136         owner = ecrecover(h, v, r, s);
137       }
138 
139       require(Pattern[patternid].owner == owner);
140 
141       Pattern[patternid].message = message;
142 
143       return "ok";
144 
145     }
146 
147     function verifyOwner(bytes32 patternid, address owner, uint8 v, bytes32 r, bytes32 s)
148       public
149       view
150       returns(bool)
151     {
152       //check that pattern in question has an owner
153       require(Pattern[patternid].owner != address(0));
154 
155       //resolve owner address from signature
156       bytes32 h = prefixedHash2(owner);
157       address owner2 = ecrecover(h, v, r, s);
158 
159       require(owner2 == owner);
160 
161       //check if owner actually owns item in question
162       if(Pattern[patternid].owner == owner2){
163         return true;
164       }else{
165         return false;
166       }
167     }
168 
169     function prefixedHash(string message)
170       private
171       pure
172       returns (bytes32)
173     {
174         bytes32 h = keccak256(abi.encodePacked(message));
175         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
176     }
177 
178     function prefixedHash2(address message)
179       private
180       pure
181       returns (bytes32)
182     {
183         bytes32 h = keccak256(abi.encodePacked(message));
184         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
185     }
186 
187 
188     function addPatternUserIndex(address account, bytes32 patternid)
189       private
190     {
191         Patterns[account].push(patternid);
192     }
193 
194     function removePatternUserIndex(address account, bytes32 patternid)
195       private
196     {
197       require(Pattern[patternid].owner == account);
198       for (uint i = 0; i<Patterns[account].length; i++){
199           if(Patterns[account][i] == patternid){
200               //replace with last entry
201               Patterns[account][i] = Patterns[account][Patterns[account].length-1];
202               //delete last
203               delete Patterns[account][Patterns[account].length-1];
204               //shorten array
205               Patterns[account].length--;
206           }
207       }
208     }
209 
210     function userHasPattern(address account)
211       public
212       view
213       returns(bool)
214     {
215       if(Patterns[account].length >=1 )
216       {
217         return true;
218       }else{
219         return false;
220       }
221     }
222 
223     function emergency(address newa, uint8 v, bytes32 r, bytes32 s, uint8 v2, bytes32 r2, bytes32 s2)
224       public
225     {
226       //generate hashes
227       bytes32 h = prefixedHash2(newa);
228 
229       //check if admin and emergency_admin signed the messages
230       require(ecrecover(h, v, r, s)==admin);
231       require(ecrecover(h, v2, r2, s2)==emergency_admin);
232       //set new admin
233       admin = newa;
234     }
235 
236     function changeInfo(string newinfo)
237       public
238       onlyAdmin
239     {
240       //only admin can call this.
241       //require(msg.sender == admin); used modifier
242 
243       info = newinfo;
244     }
245 
246 
247     function toUpper(string str)
248       pure
249       private
250       returns (string)
251     {
252       bytes memory bStr = bytes(str);
253       bytes memory bLower = new bytes(bStr.length);
254       for (uint i = 0; i < bStr.length; i++) {
255         // lowercase character...
256         if ((bStr[i] >= 65+32) && (bStr[i] <= 90+32)) {
257           // So we remove 32 to make it uppercase
258           bLower[i] = bytes1(int(bStr[i]) - 32);
259         } else {
260           bLower[i] = bStr[i];
261         }
262       }
263       return string(bLower);
264     }
265 
266 }