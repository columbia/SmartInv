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
46     function registeredUsers() external constant
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
127         return (accounts[target].entries.contains(dataHash),
128                 accounts[target].values[dataHash].time,
129                 accounts[target].values[dataHash].staked);
130     }
131 }
132 
133 pragma solidity ^0.4.13;
134 
135 // sets support up to 2^256-2 members
136 // memberIndices stores the index of members + 1, not their actual index
137 library Sets {
138     // address set
139     struct addressSet {
140         address[] members;
141         mapping(address => uint) memberIndices;
142     }
143 
144     function insert(addressSet storage self, address other) {
145         if (!contains(self, other)) {
146             self.members.push(other);
147             self.memberIndices[other] = length(self);
148         }
149     }
150 
151     function remove(addressSet storage self, address other) {
152         if (contains(self, other)) {
153             uint replaceIndex = self.memberIndices[other];
154             address lastMember = self.members[length(self)-1];
155             // overwrite other with the last member and remove last member
156             self.members[replaceIndex-1] = lastMember;
157             self.members.length--;
158             // reflect this change in the indices
159             self.memberIndices[lastMember] = replaceIndex;
160             delete self.memberIndices[other];
161         }
162     }
163 
164     function contains(addressSet storage self, address other)
165         constant
166         returns (bool)
167     {
168         return self.memberIndices[other] > 0;
169     }
170 
171     function length(addressSet storage self) constant returns (uint) {
172         return self.members.length;
173     }
174 
175 
176     // uint set
177     struct uintSet {
178         uint[] members;
179         mapping(uint => uint) memberIndices;
180     }
181 
182     function insert(uintSet storage self, uint other) {
183         if (!contains(self, other)) {
184             self.members.push(other);
185             self.memberIndices[other] = length(self);
186         }
187     }
188 
189     function remove(uintSet storage self, uint other) {
190         if (contains(self, other)) {
191             uint replaceIndex = self.memberIndices[other];
192             uint lastMember = self.members[length(self)-1];
193             // overwrite other with the last member and remove last member
194             self.members[replaceIndex-1] = lastMember;
195             self.members.length--;
196             // reflect this change in the indices
197             self.memberIndices[lastMember] = replaceIndex;
198             delete self.memberIndices[other];
199         }
200     }
201 
202     function contains(uintSet storage self, uint other)
203         constant
204         returns (bool)
205     {
206         return self.memberIndices[other] > 0;
207     }
208 
209     function length(uintSet storage self) constant returns (uint) {
210         return self.members.length;
211     }
212 
213 
214     // uint8 set
215     struct uint8Set {
216         uint8[] members;
217         mapping(uint8 => uint) memberIndices;
218     }
219 
220     function insert(uint8Set storage self, uint8 other) {
221         if (!contains(self, other)) {
222             self.members.push(other);
223             self.memberIndices[other] = length(self);
224         }
225     }
226 
227     function remove(uint8Set storage self, uint8 other) {
228         if (contains(self, other)) {
229             uint replaceIndex = self.memberIndices[other];
230             uint8 lastMember = self.members[length(self)-1];
231             // overwrite other with the last member and remove last member
232             self.members[replaceIndex-1] = lastMember;
233             self.members.length--;
234             // reflect this change in the indices
235             self.memberIndices[lastMember] = replaceIndex;
236             delete self.memberIndices[other];
237         }
238     }
239 
240     function contains(uint8Set storage self, uint8 other)
241         constant
242         returns (bool)
243     {
244         return self.memberIndices[other] > 0;
245     }
246 
247     function length(uint8Set storage self) constant returns (uint) {
248         return self.members.length;
249     }
250 
251 
252     // int set
253     struct intSet {
254         int[] members;
255         mapping(int => uint) memberIndices;
256     }
257 
258     function insert(intSet storage self, int other) {
259         if (!contains(self, other)) {
260             self.members.push(other);
261             self.memberIndices[other] = length(self);
262         }
263     }
264 
265     function remove(intSet storage self, int other) {
266         if (contains(self, other)) {
267             uint replaceIndex = self.memberIndices[other];
268             int lastMember = self.members[length(self)-1];
269             // overwrite other with the last member and remove last member
270             self.members[replaceIndex-1] = lastMember;
271             self.members.length--;
272             // reflect this change in the indices
273             self.memberIndices[lastMember] = replaceIndex;
274             delete self.memberIndices[other];
275         }
276     }
277 
278     function contains(intSet storage self, int other)
279         constant
280         returns (bool)
281     {
282         return self.memberIndices[other] > 0;
283     }
284 
285     function length(intSet storage self) constant returns (uint) {
286         return self.members.length;
287     }
288 
289 
290     // int8 set
291     struct int8Set {
292         int8[] members;
293         mapping(int8 => uint) memberIndices;
294     }
295 
296     function insert(int8Set storage self, int8 other) {
297         if (!contains(self, other)) {
298             self.members.push(other);
299             self.memberIndices[other] = length(self);
300         }
301     }
302 
303     function remove(int8Set storage self, int8 other) {
304         if (contains(self, other)) {
305             uint replaceIndex = self.memberIndices[other];
306             int8 lastMember = self.members[length(self)-1];
307             // overwrite other with the last member and remove last member
308             self.members[replaceIndex-1] = lastMember;
309             self.members.length--;
310             // reflect this change in the indices
311             self.memberIndices[lastMember] = replaceIndex;
312             delete self.memberIndices[other];
313         }
314     }
315 
316     function contains(int8Set storage self, int8 other)
317         constant
318         returns (bool)
319     {
320         return self.memberIndices[other] > 0;
321     }
322 
323     function length(int8Set storage self) constant returns (uint) {
324         return self.members.length;
325     }
326 
327 
328     // byte set
329     struct byteSet {
330         byte[] members;
331         mapping(byte => uint) memberIndices;
332     }
333 
334     function insert(byteSet storage self, byte other) {
335         if (!contains(self, other)) {
336             self.members.push(other);
337             self.memberIndices[other] = length(self);
338         }
339     }
340 
341     function remove(byteSet storage self, byte other) {
342         if (contains(self, other)) {
343             uint replaceIndex = self.memberIndices[other];
344             byte lastMember = self.members[length(self)-1];
345             // overwrite other with the last member and remove last member
346             self.members[replaceIndex-1] = lastMember;
347             self.members.length--;
348             // reflect this change in the indices
349             self.memberIndices[lastMember] = replaceIndex;
350             delete self.memberIndices[other];
351         }
352     }
353 
354     function contains(byteSet storage self, byte other)
355         constant
356         returns (bool)
357     {
358         return self.memberIndices[other] > 0;
359     }
360 
361     function length(byteSet storage self) constant returns (uint) {
362         return self.members.length;
363     }
364 
365 
366     // bytes32 set
367     struct bytes32Set {
368         bytes32[] members;
369         mapping(bytes32 => uint) memberIndices;
370     }
371 
372     function insert(bytes32Set storage self, bytes32 other) {
373         if (!contains(self, other)) {
374             self.members.push(other);
375             self.memberIndices[other] = length(self);
376         }
377     }
378 
379     function remove(bytes32Set storage self, bytes32 other) {
380         if (contains(self, other)) {
381             uint replaceIndex = self.memberIndices[other];
382             bytes32 lastMember = self.members[length(self)-1];
383             // overwrite other with the last member and remove last member
384             self.members[replaceIndex-1] = lastMember;
385             self.members.length--;
386             // reflect this change in the indices
387             self.memberIndices[lastMember] = replaceIndex;
388             delete self.memberIndices[other];
389         }
390     }
391 
392     function contains(bytes32Set storage self, bytes32 other)
393         constant
394         returns (bool)
395     {
396         return self.memberIndices[other] > 0;
397     }
398 
399     function length(bytes32Set storage self) constant returns (uint) {
400         return self.members.length;
401     }
402 }