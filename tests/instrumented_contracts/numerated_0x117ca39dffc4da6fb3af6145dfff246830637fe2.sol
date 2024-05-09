1 pragma solidity ^0.4.18;
2 
3 library Sets {
4     // address set
5     struct addressSet {
6         address[] members;
7         mapping(address => uint) memberIndices;
8     }
9 
10     function insert(addressSet storage self, address other) public {
11         if (!contains(self, other)) {
12             assert(length(self) < 2**256-1);
13             self.members.push(other);
14             self.memberIndices[other] = length(self);
15         }
16     }
17 
18     function remove(addressSet storage self, address other) public {
19         if (contains(self, other)) {
20             uint replaceIndex = self.memberIndices[other];
21             address lastMember = self.members[length(self)-1];
22             // overwrite other with the last member and remove last member
23             self.members[replaceIndex-1] = lastMember;
24             self.members.length--;
25             // reflect this change in the indices
26             self.memberIndices[lastMember] = replaceIndex;
27             delete self.memberIndices[other];
28         }
29     }
30 
31     function contains(addressSet storage self, address other) public view returns (bool) {
32         return self.memberIndices[other] > 0;
33     }
34 
35     function length(addressSet storage self) public view returns (uint) {
36         return self.members.length;
37     }
38 
39 
40     // uint set
41     struct uintSet {
42         uint[] members;
43         mapping(uint => uint) memberIndices;
44     }
45 
46     function insert(uintSet storage self, uint other) public {
47         if (!contains(self, other)) {
48             assert(length(self) < 2**256-1);
49             self.members.push(other);
50             self.memberIndices[other] = length(self);
51         }
52     }
53 
54     function remove(uintSet storage self, uint other) public {
55         if (contains(self, other)) {
56             uint replaceIndex = self.memberIndices[other];
57             uint lastMember = self.members[length(self)-1];
58             // overwrite other with the last member and remove last member
59             self.members[replaceIndex-1] = lastMember;
60             self.members.length--;
61             // reflect this change in the indices
62             self.memberIndices[lastMember] = replaceIndex;
63             delete self.memberIndices[other];
64         }
65     }
66 
67     function contains(uintSet storage self, uint other) public view returns (bool) {
68         return self.memberIndices[other] > 0;
69     }
70 
71     function length(uintSet storage self) public view returns (uint) {
72         return self.members.length;
73     }
74 
75 
76     // uint8 set
77     struct uint8Set {
78         uint8[] members;
79         mapping(uint8 => uint) memberIndices;
80     }
81 
82     function insert(uint8Set storage self, uint8 other) public {
83         if (!contains(self, other)) {
84             assert(length(self) < 2**256-1);
85             self.members.push(other);
86             self.memberIndices[other] = length(self);
87         }
88     }
89 
90     function remove(uint8Set storage self, uint8 other) public {
91         if (contains(self, other)) {
92             uint replaceIndex = self.memberIndices[other];
93             uint8 lastMember = self.members[length(self)-1];
94             // overwrite other with the last member and remove last member
95             self.members[replaceIndex-1] = lastMember;
96             self.members.length--;
97             // reflect this change in the indices
98             self.memberIndices[lastMember] = replaceIndex;
99             delete self.memberIndices[other];
100         }
101     }
102 
103     function contains(uint8Set storage self, uint8 other) public view returns (bool) {
104         return self.memberIndices[other] > 0;
105     }
106 
107     function length(uint8Set storage self) public view returns (uint) {
108         return self.members.length;
109     }
110 
111 
112     // int set
113     struct intSet {
114         int[] members;
115         mapping(int => uint) memberIndices;
116     }
117 
118     function insert(intSet storage self, int other) public {
119         if (!contains(self, other)) {
120             assert(length(self) < 2**256-1);
121             self.members.push(other);
122             self.memberIndices[other] = length(self);
123         }
124     }
125 
126     function remove(intSet storage self, int other) public {
127         if (contains(self, other)) {
128             uint replaceIndex = self.memberIndices[other];
129             int lastMember = self.members[length(self)-1];
130             // overwrite other with the last member and remove last member
131             self.members[replaceIndex-1] = lastMember;
132             self.members.length--;
133             // reflect this change in the indices
134             self.memberIndices[lastMember] = replaceIndex;
135             delete self.memberIndices[other];
136         }
137     }
138 
139     function contains(intSet storage self, int other) public view returns (bool) {
140         return self.memberIndices[other] > 0;
141     }
142 
143     function length(intSet storage self) public view returns (uint) {
144         return self.members.length;
145     }
146 
147 
148     // int8 set
149     struct int8Set {
150         int8[] members;
151         mapping(int8 => uint) memberIndices;
152     }
153 
154     function insert(int8Set storage self, int8 other) public {
155         if (!contains(self, other)) {
156             assert(length(self) < 2**256-1);
157             self.members.push(other);
158             self.memberIndices[other] = length(self);
159         }
160     }
161 
162     function remove(int8Set storage self, int8 other) public {
163         if (contains(self, other)) {
164             uint replaceIndex = self.memberIndices[other];
165             int8 lastMember = self.members[length(self)-1];
166             // overwrite other with the last member and remove last member
167             self.members[replaceIndex-1] = lastMember;
168             self.members.length--;
169             // reflect this change in the indices
170             self.memberIndices[lastMember] = replaceIndex;
171             delete self.memberIndices[other];
172         }
173     }
174 
175     function contains(int8Set storage self, int8 other) public view returns (bool) {
176         return self.memberIndices[other] > 0;
177     }
178 
179     function length(int8Set storage self) public view returns (uint) {
180         return self.members.length;
181     }
182 
183 
184     // byte set
185     struct byteSet {
186         byte[] members;
187         mapping(byte => uint) memberIndices;
188     }
189 
190     function insert(byteSet storage self, byte other) public {
191         if (!contains(self, other)) {
192             assert(length(self) < 2**256-1);
193             self.members.push(other);
194             self.memberIndices[other] = length(self);
195         }
196     }
197 
198     function remove(byteSet storage self, byte other) public {
199         if (contains(self, other)) {
200             uint replaceIndex = self.memberIndices[other];
201             byte lastMember = self.members[length(self)-1];
202             // overwrite other with the last member and remove last member
203             self.members[replaceIndex-1] = lastMember;
204             self.members.length--;
205             // reflect this change in the indices
206             self.memberIndices[lastMember] = replaceIndex;
207             delete self.memberIndices[other];
208         }
209     }
210 
211     function contains(byteSet storage self, byte other) public view returns (bool) {
212         return self.memberIndices[other] > 0;
213     }
214 
215     function length(byteSet storage self) public view returns (uint) {
216         return self.members.length;
217     }
218 
219 
220     // bytes32 set
221     struct bytes32Set {
222         bytes32[] members;
223         mapping(bytes32 => uint) memberIndices;
224     }
225 
226     function insert(bytes32Set storage self, bytes32 other) public {
227         if (!contains(self, other)) {
228             assert(length(self) < 2**256-1);
229             self.members.push(other);
230             self.memberIndices[other] = length(self);
231         }
232     }
233 
234     function remove(bytes32Set storage self, bytes32 other) public {
235         if (contains(self, other)) {
236             uint replaceIndex = self.memberIndices[other];
237             bytes32 lastMember = self.members[length(self)-1];
238             // overwrite other with the last member and remove last member
239             self.members[replaceIndex-1] = lastMember;
240             self.members.length--;
241             // reflect this change in the indices
242             self.memberIndices[lastMember] = replaceIndex;
243             delete self.memberIndices[other];
244         }
245     }
246 
247     function contains(bytes32Set storage self, bytes32 other) public view returns (bool) {
248         return self.memberIndices[other] > 0;
249     }
250 
251     function length(bytes32Set storage self) public view returns (uint) {
252         return self.members.length;
253     }
254 }
255 
256 contract Prover {
257     // attach library
258     using Sets for Sets.addressSet;
259     using Sets for Sets.bytes32Set;
260 
261     // storage vars
262     address owner;
263     Sets.addressSet users;
264     mapping(address => Account) internal accounts;
265 
266     // structs
267     struct Account {
268         Sets.bytes32Set entries;
269         mapping(bytes32 => Entry) values;
270     }
271 
272     struct Entry {
273         uint time;
274         uint staked;
275     }
276 
277     // constructor
278     function Prover() public {
279         owner = msg.sender;
280     }
281 
282     // fallback
283     function() internal {
284         revert();
285     }
286 
287 
288     // modifier to check if a target address has a particular entry
289     modifier entryExists(address target, bytes32 dataHash, bool exists) {
290         assert(accounts[target].entries.contains(dataHash) == exists);
291         _;
292     }
293 
294     // external functions
295     // allow access to our structs via functions with convenient return values
296     function registeredUsers()
297         external
298         view
299         returns (address[] unique_addresses) {
300         return users.members;
301     }
302     function userEntries(address target)
303         external
304         view
305         returns (bytes32[] entries) {
306         return accounts[target].entries.members;
307     }
308     function entryInformation(address target, bytes32 dataHash)
309         external
310         view
311         returns (bool proved, uint time, uint staked) {
312         return (accounts[target].entries.contains(dataHash),
313                 accounts[target].values[dataHash].time,
314                 accounts[target].values[dataHash].staked);
315     }
316 
317     // public functions
318     // adding entries
319     function addEntry(bytes32 dataHash)
320         public
321         payable
322         entryExists(msg.sender, dataHash, false){
323         users.insert(msg.sender);
324         accounts[msg.sender].entries.insert(dataHash);
325         accounts[msg.sender].values[dataHash] = Entry(now, msg.value);
326     }
327 
328     // deleting entries
329     function deleteEntry(bytes32 dataHash)
330         public
331         entryExists(msg.sender, dataHash, true) {
332         uint rebate = accounts[msg.sender].values[dataHash].staked;
333         // update user account
334         delete accounts[msg.sender].values[dataHash];
335         accounts[msg.sender].entries.remove(dataHash);
336         // delete from users if this was the user's last entry
337         if (accounts[msg.sender].entries.length() == 0) {
338             users.remove(msg.sender);
339         }
340         // send the rebate
341         if (rebate > 0) msg.sender.transfer(rebate);
342     }
343 
344     // allow owner to delete contract if no accounts exist
345     function selfDestruct() public {
346         if ((msg.sender == owner) && (users.length() == 0)) {
347             selfdestruct(owner);
348         }
349     }
350 }