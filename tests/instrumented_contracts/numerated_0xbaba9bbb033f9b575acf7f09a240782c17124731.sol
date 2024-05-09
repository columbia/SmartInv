1 pragma solidity ^0.4.13;
2 
3 contract Prover {
4     // attach library
5     using Sets for Sets.addressSet;
6     using Sets for Sets.bytes32Set;
7 
8     // storage vars
9     address owner;
10     Sets.addressSet users;
11     mapping(address => Account) internal accounts;
12 
13     // structs
14     struct Account {
15         Sets.bytes32Set entries;
16         mapping(bytes32 => Entry) values;
17     }
18 
19     struct Entry {
20         uint time;
21         uint staked;
22     }
23 
24 
25     // constructor
26     function Prover() {
27         owner = msg.sender;
28     }
29     
30     
31     // fallback: unmatched transactions will be returned
32     function() {
33         revert();
34     }
35 
36 
37     // modifier to check if a target address has a particular entry
38     modifier entryExists(address target, bytes32 dataHash, bool exists) {
39         assert(accounts[target].entries.contains(dataHash) == exists);
40         _;
41     }
42 
43 
44     // external functions
45     // allow access to our structs via functions with convenient return values
46     function registeredUsers() public constant
47         returns (uint number_unique_addresses, address[] unique_addresses)
48     {
49         return (users.length(), users.members);
50     }
51 
52     function userEntries(address target) external constant returns (bytes32[]) {
53         return accounts[target].entries.members;
54     }
55     // proving
56     function proveIt(address target, bytes32 dataHash) external constant
57         returns (bool proved, uint time, uint staked)
58     {
59         return status(target, dataHash);
60     }
61 
62     function proveIt(address target, string dataString) external constant
63         returns (bool proved, uint time, uint staked)
64     {
65         return status(target, sha3(dataString));
66     }
67 
68     
69     // public functions
70     // adding entries
71     function addEntry(bytes32 dataHash) payable {
72         _addEntry(dataHash);
73     }
74 
75     function addEntry(string dataString) payable
76     {
77         _addEntry(sha3(dataString));
78     }
79 
80     // deleting entries
81     function deleteEntry(bytes32 dataHash) {
82         _deleteEntry(dataHash);
83     }
84 
85     function deleteEntry(string dataString) {
86         _deleteEntry(sha3(dataString));
87     }
88     
89     // allow owner to delete contract if no accounts exist
90     function selfDestruct() {
91         if ((msg.sender == owner) && (users.length() == 0)) {
92             selfdestruct(owner);
93         }
94     }
95 
96 
97     // internal functions
98     function _addEntry(bytes32 dataHash)
99         entryExists(msg.sender, dataHash, false)
100         internal
101     {
102         users.insert(msg.sender);
103         accounts[msg.sender].entries.insert(dataHash);
104         accounts[msg.sender].values[dataHash] = Entry(now, msg.value);
105     }
106 
107     function _deleteEntry(bytes32 dataHash)
108         entryExists(msg.sender, dataHash, true)
109         internal
110     {
111         uint rebate = accounts[msg.sender].values[dataHash].staked;
112         // update user account
113         delete accounts[msg.sender].values[dataHash];
114         accounts[msg.sender].entries.remove(dataHash);
115         // delete from users if this was the user's last entry
116         if (accounts[msg.sender].entries.length() == 0) {
117             users.remove(msg.sender);
118         }
119         // send the rebate
120         if (rebate > 0) msg.sender.transfer(rebate);
121     }
122 
123     // return status of arbitrary address and dataHash
124     function status(address target, bytes32 dataHash) internal constant
125         returns (bool proved, uint time, uint staked)
126     {
127         return (accounts[msg.sender].entries.contains(dataHash),
128                 accounts[target].values[dataHash].time,
129                 accounts[target].values[dataHash].staked);
130     }
131 }
132 
133 // sets support up to 2^256-2 members
134 // memberIndices stores the index of members + 1, not their actual index
135 library Sets {
136     // address set
137     struct addressSet {
138         address[] members;
139         mapping(address => uint) memberIndices;
140     }
141 
142     function insert(addressSet storage self, address other) {
143         if (!contains(self, other)) {
144             self.members.push(other);
145             self.memberIndices[other] = length(self);
146         }
147     }
148 
149     function remove(addressSet storage self, address other) {
150         if (contains(self, other)) {
151             uint replaceIndex = self.memberIndices[other];
152             address lastMember = self.members[length(self)-1];
153             // overwrite other with the last member and remove last member
154             self.members[replaceIndex-1] = lastMember;
155             self.members.length--;
156             // reflect this change in the indices
157             self.memberIndices[lastMember] = replaceIndex;
158             delete self.memberIndices[other];
159         }
160     }
161 
162     function contains(addressSet storage self, address other)
163         constant
164         returns (bool)
165     {
166         return self.memberIndices[other] > 0;
167     }
168 
169     function length(addressSet storage self) constant returns (uint) {
170         return self.members.length;
171     }
172 
173 
174     // uint set
175     struct uintSet {
176         uint[] members;
177         mapping(uint => uint) memberIndices;
178     }
179 
180     function insert(uintSet storage self, uint other) {
181         if (!contains(self, other)) {
182             self.members.push(other);
183             self.memberIndices[other] = length(self);
184         }
185     }
186 
187     function remove(uintSet storage self, uint other) {
188         if (contains(self, other)) {
189             uint replaceIndex = self.memberIndices[other];
190             uint lastMember = self.members[length(self)-1];
191             // overwrite other with the last member and remove last member
192             self.members[replaceIndex-1] = lastMember;
193             self.members.length--;
194             // reflect this change in the indices
195             self.memberIndices[lastMember] = replaceIndex;
196             delete self.memberIndices[other];
197         }
198     }
199 
200     function contains(uintSet storage self, uint other)
201         constant
202         returns (bool)
203     {
204         return self.memberIndices[other] > 0;
205     }
206 
207     function length(uintSet storage self) constant returns (uint) {
208         return self.members.length;
209     }
210 
211 
212     // uint8 set
213     struct uint8Set {
214         uint8[] members;
215         mapping(uint8 => uint) memberIndices;
216     }
217 
218     function insert(uint8Set storage self, uint8 other) {
219         if (!contains(self, other)) {
220             self.members.push(other);
221             self.memberIndices[other] = length(self);
222         }
223     }
224 
225     function remove(uint8Set storage self, uint8 other) {
226         if (contains(self, other)) {
227             uint replaceIndex = self.memberIndices[other];
228             uint8 lastMember = self.members[length(self)-1];
229             // overwrite other with the last member and remove last member
230             self.members[replaceIndex-1] = lastMember;
231             self.members.length--;
232             // reflect this change in the indices
233             self.memberIndices[lastMember] = replaceIndex;
234             delete self.memberIndices[other];
235         }
236     }
237 
238     function contains(uint8Set storage self, uint8 other)
239         constant
240         returns (bool)
241     {
242         return self.memberIndices[other] > 0;
243     }
244 
245     function length(uint8Set storage self) constant returns (uint) {
246         return self.members.length;
247     }
248 
249 
250     // int set
251     struct intSet {
252         int[] members;
253         mapping(int => uint) memberIndices;
254     }
255 
256     function insert(intSet storage self, int other) {
257         if (!contains(self, other)) {
258             self.members.push(other);
259             self.memberIndices[other] = length(self);
260         }
261     }
262 
263     function remove(intSet storage self, int other) {
264         if (contains(self, other)) {
265             uint replaceIndex = self.memberIndices[other];
266             int lastMember = self.members[length(self)-1];
267             // overwrite other with the last member and remove last member
268             self.members[replaceIndex-1] = lastMember;
269             self.members.length--;
270             // reflect this change in the indices
271             self.memberIndices[lastMember] = replaceIndex;
272             delete self.memberIndices[other];
273         }
274     }
275 
276     function contains(intSet storage self, int other)
277         constant
278         returns (bool)
279     {
280         return self.memberIndices[other] > 0;
281     }
282 
283     function length(intSet storage self) constant returns (uint) {
284         return self.members.length;
285     }
286 
287 
288     // int8 set
289     struct int8Set {
290         int8[] members;
291         mapping(int8 => uint) memberIndices;
292     }
293 
294     function insert(int8Set storage self, int8 other) {
295         if (!contains(self, other)) {
296             self.members.push(other);
297             self.memberIndices[other] = length(self);
298         }
299     }
300 
301     function remove(int8Set storage self, int8 other) {
302         if (contains(self, other)) {
303             uint replaceIndex = self.memberIndices[other];
304             int8 lastMember = self.members[length(self)-1];
305             // overwrite other with the last member and remove last member
306             self.members[replaceIndex-1] = lastMember;
307             self.members.length--;
308             // reflect this change in the indices
309             self.memberIndices[lastMember] = replaceIndex;
310             delete self.memberIndices[other];
311         }
312     }
313 
314     function contains(int8Set storage self, int8 other)
315         constant
316         returns (bool)
317     {
318         return self.memberIndices[other] > 0;
319     }
320 
321     function length(int8Set storage self) constant returns (uint) {
322         return self.members.length;
323     }
324 
325 
326     // byte set
327     struct byteSet {
328         byte[] members;
329         mapping(byte => uint) memberIndices;
330     }
331 
332     function insert(byteSet storage self, byte other) {
333         if (!contains(self, other)) {
334             self.members.push(other);
335             self.memberIndices[other] = length(self);
336         }
337     }
338 
339     function remove(byteSet storage self, byte other) {
340         if (contains(self, other)) {
341             uint replaceIndex = self.memberIndices[other];
342             byte lastMember = self.members[length(self)-1];
343             // overwrite other with the last member and remove last member
344             self.members[replaceIndex-1] = lastMember;
345             self.members.length--;
346             // reflect this change in the indices
347             self.memberIndices[lastMember] = replaceIndex;
348             delete self.memberIndices[other];
349         }
350     }
351 
352     function contains(byteSet storage self, byte other)
353         constant
354         returns (bool)
355     {
356         return self.memberIndices[other] > 0;
357     }
358 
359     function length(byteSet storage self) constant returns (uint) {
360         return self.members.length;
361     }
362 
363 
364     // bytes32 set
365     struct bytes32Set {
366         bytes32[] members;
367         mapping(bytes32 => uint) memberIndices;
368     }
369 
370     function insert(bytes32Set storage self, bytes32 other) {
371         if (!contains(self, other)) {
372             self.members.push(other);
373             self.memberIndices[other] = length(self);
374         }
375     }
376 
377     function remove(bytes32Set storage self, bytes32 other) {
378         if (contains(self, other)) {
379             uint replaceIndex = self.memberIndices[other];
380             bytes32 lastMember = self.members[length(self)-1];
381             // overwrite other with the last member and remove last member
382             self.members[replaceIndex-1] = lastMember;
383             self.members.length--;
384             // reflect this change in the indices
385             self.memberIndices[lastMember] = replaceIndex;
386             delete self.memberIndices[other];
387         }
388     }
389 
390     function contains(bytes32Set storage self, bytes32 other)
391         constant
392         returns (bool)
393     {
394         return self.memberIndices[other] > 0;
395     }
396 
397     function length(bytes32Set storage self) constant returns (uint) {
398         return self.members.length;
399     }
400 }