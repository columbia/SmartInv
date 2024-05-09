1 pragma solidity ^0.4.13;
2 
3 contract Prover {
4     // attach library
5     using Sets for *;
6 
7 
8     // storage vars
9     address owner;
10     Sets.addressSet internal users;
11     mapping (address => UserAccount) internal ledger;
12     
13     
14     // structs
15     struct UserAccount {
16         Sets.bytes32Set hashes;
17         mapping (bytes32 => Entry) entries;
18     }
19 
20     struct Entry {
21         uint256 time;
22         uint256 value;
23     }
24 
25 
26     // constructor
27     function Prover() {
28         owner = msg.sender;
29     }
30     
31     
32     // fallback: unmatched transactions will be returned
33     function () {
34         revert();
35     }
36 
37 
38     // modifier to check if sender has an account
39     modifier hasAccount() {
40         assert(ledger[msg.sender].hashes.length() >= 1);
41         _;
42     }
43 
44 
45     // external functions
46     // proving
47     function proveIt(address target, bytes32 dataHash) external constant
48         returns (bool proved, uint256 time, uint256 value)
49     {
50         return status(target, dataHash);
51     }
52 
53     function proveIt(address target, string dataString) external constant
54         returns (bool proved, uint256 time, uint256 value)
55     {
56         return status(target, sha3(dataString));
57     }
58     
59     // allow access to our structs via functions with convenient return values
60     function usersGetter() public constant
61         returns (uint256 number_unique_addresses, address[] unique_addresses)
62     {
63         return (users.length(), users.members);
64     }
65 
66     function userEntries(address target) external constant returns (bytes32[]) {
67         return ledger[target].hashes.members;
68     }
69     
70     
71     // public functions
72     // adding entries
73     function addEntry(bytes32 dataHash) payable {
74         _addEntry(dataHash);
75     }
76 
77     function addEntry(string dataString) payable {
78         _addEntry(sha3(dataString));
79     }
80 
81     // deleting entries
82     function deleteEntry(bytes32 dataHash) hasAccount {
83         _deleteEntry(dataHash);
84     }
85 
86     function deleteEntry(string dataString) hasAccount {
87         _deleteEntry(sha3(dataString));
88     }
89     
90     // allow owner to delete contract if no accounts exist
91     function selfDestruct() {
92         if ((msg.sender == owner) && (users.length() == 0)) {
93             selfdestruct(owner);
94         }
95     }
96 
97 
98     // internal functions
99     function _addEntry(bytes32 dataHash) internal {
100         // ensure the entry doesn't exist
101         assert(!ledger[msg.sender].hashes.contains(dataHash));
102         // update UserAccount (hashes then entries)
103         ledger[msg.sender].hashes.insert(dataHash);
104         ledger[msg.sender].entries[dataHash] = Entry(now, msg.value);
105         // add sender to userlist
106         users.insert(msg.sender);
107     }
108 
109     function _deleteEntry(bytes32 dataHash) internal {
110         // ensure the entry does exist
111         assert(ledger[msg.sender].hashes.contains(dataHash));
112         uint256 rebate = ledger[msg.sender].entries[dataHash].value;
113         // update UserAccount (hashes then entries)
114         ledger[msg.sender].hashes.remove(dataHash);
115         delete ledger[msg.sender].entries[dataHash];
116         // send the rebate
117         if (rebate > 0) {
118             msg.sender.transfer(rebate);
119         }
120         // delete from userlist if this was the user's last entry
121         if (ledger[msg.sender].hashes.length() == 0) {
122             users.remove(msg.sender);
123         }
124     }
125 
126     // return status of arbitrary address and dataHash
127     function status(address target, bytes32 dataHash) internal constant
128         returns (bool proved, uint256 time, uint256 value)
129     {
130         return (ledger[msg.sender].hashes.contains(dataHash),
131                 ledger[target].entries[dataHash].time,
132                 ledger[target].entries[dataHash].value);
133     }
134 }
135 
136 // note: breaks if members.length exceeds 2^256-1 (so, not really a problem)
137 library Sets {
138     // address set
139     struct addressSet {
140         address[] members;
141         mapping (address => bool) memberExists;
142         mapping (address => uint) memberIndex;
143     }
144 
145     function insert(addressSet storage self, address other) {
146         if (!self.memberExists[other]) {
147             self.memberExists[other] = true;
148             self.memberIndex[other] = self.members.length;
149             self.members.push(other);
150         }
151     }
152 
153     function remove(addressSet storage self, address other) {
154         if (self.memberExists[other])  {
155             self.memberExists[other] = false;
156             uint index = self.memberIndex[other];
157             // change index of last value to index of other 
158             self.memberIndex[self.members[self.members.length - 1]] = index;
159             // copy last value over other and decrement length
160             self.members[index] = self.members[self.members.length - 1];
161             self.members.length--;
162         }
163     }
164 
165     function contains(addressSet storage self, address other) returns (bool) {
166         return self.memberExists[other];
167     }
168 
169     function length(addressSet storage self) returns (uint256) {
170         return self.members.length;
171     }
172 
173 
174     // uint set
175     struct uintSet {
176         uint[] members;
177         mapping (uint => bool) memberExists;
178         mapping (uint => uint) memberIndex;
179     }
180 
181     function insert(uintSet storage self, uint other) {
182         if (!self.memberExists[other]) {
183             self.memberExists[other] = true;
184             self.memberIndex[other] = self.members.length;
185             self.members.push(other);
186         }
187     }
188 
189     function remove(uintSet storage self, uint other) {
190         if (self.memberExists[other])  {
191             self.memberExists[other] = false;
192             uint index = self.memberIndex[other];
193             // change index of last value to index of other 
194             self.memberIndex[self.members[self.members.length - 1]] = index;
195             // copy last value over other and decrement length
196             self.members[index] = self.members[self.members.length - 1];
197             self.members.length--;
198         }
199     }
200 
201     function contains(uintSet storage self, uint other) returns (bool) {
202         return self.memberExists[other];
203     }
204 
205     function length(uintSet storage self) returns (uint256) {
206         return self.members.length;
207     }
208 
209 
210     // uint8 set
211     struct uint8Set {
212         uint8[] members;
213         mapping (uint8 => bool) memberExists;
214         mapping (uint8 => uint) memberIndex;
215     }
216 
217     function insert(uint8Set storage self, uint8 other) {
218         if (!self.memberExists[other]) {
219             self.memberExists[other] = true;
220             self.memberIndex[other] = self.members.length;
221             self.members.push(other);
222         }
223     }
224 
225     function remove(uint8Set storage self, uint8 other) {
226         if (self.memberExists[other])  {
227             self.memberExists[other] = false;
228             uint index = self.memberIndex[other];
229             // change index of last value to index of other 
230             self.memberIndex[self.members[self.members.length - 1]] = index;
231             // copy last value over other and decrement length
232             self.members[index] = self.members[self.members.length - 1];
233             self.members.length--;
234         }
235     }
236 
237     function contains(uint8Set storage self, uint8 other) returns (bool) {
238         return self.memberExists[other];
239     }
240 
241     function length(uint8Set storage self) returns (uint256) {
242         return self.members.length;
243     }
244 
245 
246     // int set
247     struct intSet {
248         int[] members;
249         mapping (int => bool) memberExists;
250         mapping (int => uint) memberIndex;
251     }
252 
253     function insert(intSet storage self, int other) {
254         if (!self.memberExists[other]) {
255             self.memberExists[other] = true;
256             self.memberIndex[other] = self.members.length;
257             self.members.push(other);
258         }
259     }
260 
261     function remove(intSet storage self, int other) {
262         if (self.memberExists[other])  {
263             self.memberExists[other] = false;
264             uint index = self.memberIndex[other];
265             // change index of last value to index of other 
266             self.memberIndex[self.members[self.members.length - 1]] = index;
267             // copy last value over other and decrement length
268             self.members[index] = self.members[self.members.length - 1];
269             self.members.length--;
270         }
271     }
272 
273     function contains(intSet storage self, int other) returns (bool) {
274         return self.memberExists[other];
275     }
276 
277     function length(intSet storage self) returns (uint256) {
278         return self.members.length;
279     }
280 
281 
282     // int8 set
283     struct int8Set {
284         int8[] members;
285         mapping (int8 => bool) memberExists;
286         mapping (int8 => uint) memberIndex;
287     }
288 
289     function insert(int8Set storage self, int8 other) {
290         if (!self.memberExists[other]) {
291             self.memberExists[other] = true;
292             self.memberIndex[other] = self.members.length;
293             self.members.push(other);
294         }
295     }
296 
297     function remove(int8Set storage self, int8 other) {
298         if (self.memberExists[other])  {
299             self.memberExists[other] = false;
300             uint index = self.memberIndex[other];
301             // change index of last value to index of other 
302             self.memberIndex[self.members[self.members.length - 1]] = index;
303             // copy last value over other and decrement length
304             self.members[index] = self.members[self.members.length - 1];
305             self.members.length--;
306         }
307     }
308 
309     function contains(int8Set storage self, int8 other) returns (bool) {
310         return self.memberExists[other];
311     }
312 
313     function length(int8Set storage self) returns (uint256) {
314         return self.members.length;
315     }
316 
317 
318     // byte set
319     struct byteSet {
320         byte[] members;
321         mapping (byte => bool) memberExists;
322         mapping (byte => uint) memberIndex;
323     }
324 
325     function insert(byteSet storage self, byte other) {
326         if (!self.memberExists[other]) {
327             self.memberExists[other] = true;
328             self.memberIndex[other] = self.members.length;
329             self.members.push(other);
330         }
331     }
332 
333     function remove(byteSet storage self, byte other) {
334         if (self.memberExists[other])  {
335             self.memberExists[other] = false;
336             uint index = self.memberIndex[other];
337             // change index of last value to index of other 
338             self.memberIndex[self.members[self.members.length - 1]] = index;
339             // copy last value over other and decrement length
340             self.members[index] = self.members[self.members.length - 1];
341             self.members.length--;
342         }
343     }
344 
345     function contains(byteSet storage self, byte other) returns (bool) {
346         return self.memberExists[other];
347     }
348 
349     function length(byteSet storage self) returns (uint256) {
350         return self.members.length;
351     }
352 
353 
354     // bytes32 set
355     struct bytes32Set {
356         bytes32[] members;
357         mapping (bytes32 => bool) memberExists;
358         mapping (bytes32 => uint) memberIndex;
359     }
360 
361     function insert(bytes32Set storage self, bytes32 other) {
362         if (!self.memberExists[other]) {
363             self.memberExists[other] = true;
364             self.memberIndex[other] = self.members.length;
365             self.members.push(other);
366         }
367     }
368 
369     function remove(bytes32Set storage self, bytes32 other) {
370         if (self.memberExists[other])  {
371             self.memberExists[other] = false;
372             uint index = self.memberIndex[other];
373             // change index of last value to index of other 
374             self.memberIndex[self.members[self.members.length - 1]] = index;
375             // copy last value over other and decrement length
376             self.members[index] = self.members[self.members.length - 1];
377             self.members.length--;
378         }
379     }
380 
381     function contains(bytes32Set storage self, bytes32 other) returns (bool) {
382         return self.memberExists[other];
383     }
384 
385     function length(bytes32Set storage self) returns (uint256) {
386         return self.members.length;
387     }
388 }