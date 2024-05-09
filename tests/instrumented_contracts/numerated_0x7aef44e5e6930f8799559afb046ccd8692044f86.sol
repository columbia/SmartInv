1 pragma solidity ^0.4.13;
2 
3 library Sets {
4     // address set
5     struct addressSet {
6         address[] members;
7         mapping (address => bool) memberExists;
8         mapping (address => uint) memberIndex;
9     }
10 
11     function insert(addressSet storage self, address other) {
12         if (!self.memberExists[other]) {
13             self.memberExists[other] = true;
14             self.memberIndex[other] = self.members.length;
15             self.members.push(other);
16         }
17     }
18 
19     function remove(addressSet storage self, address other) {
20         if (self.memberExists[other])  {
21             self.memberExists[other] = false;
22             uint index = self.memberIndex[other];
23             // change index of last value to index of other 
24             self.memberIndex[self.members[self.members.length - 1]] = index;
25             // copy last value over other and decrement length
26             self.members[index] = self.members[self.members.length - 1];
27             self.members.length--;
28         }
29     }
30 
31     function contains(addressSet storage self, address other) returns (bool) {
32         return self.memberExists[other];
33     }
34 
35     function length(addressSet storage self) returns (uint256) {
36         return self.members.length;
37     }
38 
39 
40     // uint set
41     struct uintSet {
42         uint[] members;
43         mapping (uint => bool) memberExists;
44         mapping (uint => uint) memberIndex;
45     }
46 
47     function insert(uintSet storage self, uint other) {
48         if (!self.memberExists[other]) {
49             self.memberExists[other] = true;
50             self.memberIndex[other] = self.members.length;
51             self.members.push(other);
52         }
53     }
54 
55     function remove(uintSet storage self, uint other) {
56         if (self.memberExists[other])  {
57             self.memberExists[other] = false;
58             uint index = self.memberIndex[other];
59             // change index of last value to index of other 
60             self.memberIndex[self.members[self.members.length - 1]] = index;
61             // copy last value over other and decrement length
62             self.members[index] = self.members[self.members.length - 1];
63             self.members.length--;
64         }
65     }
66 
67     function contains(uintSet storage self, uint other) returns (bool) {
68         return self.memberExists[other];
69     }
70 
71     function length(uintSet storage self) returns (uint256) {
72         return self.members.length;
73     }
74 
75 
76     // uint8 set
77     struct uint8Set {
78         uint8[] members;
79         mapping (uint8 => bool) memberExists;
80         mapping (uint8 => uint) memberIndex;
81     }
82 
83     function insert(uint8Set storage self, uint8 other) {
84         if (!self.memberExists[other]) {
85             self.memberExists[other] = true;
86             self.memberIndex[other] = self.members.length;
87             self.members.push(other);
88         }
89     }
90 
91     function remove(uint8Set storage self, uint8 other) {
92         if (self.memberExists[other])  {
93             self.memberExists[other] = false;
94             uint index = self.memberIndex[other];
95             // change index of last value to index of other 
96             self.memberIndex[self.members[self.members.length - 1]] = index;
97             // copy last value over other and decrement length
98             self.members[index] = self.members[self.members.length - 1];
99             self.members.length--;
100         }
101     }
102 
103     function contains(uint8Set storage self, uint8 other) returns (bool) {
104         return self.memberExists[other];
105     }
106 
107     function length(uint8Set storage self) returns (uint256) {
108         return self.members.length;
109     }
110 
111 
112     // int set
113     struct intSet {
114         int[] members;
115         mapping (int => bool) memberExists;
116         mapping (int => uint) memberIndex;
117     }
118 
119     function insert(intSet storage self, int other) {
120         if (!self.memberExists[other]) {
121             self.memberExists[other] = true;
122             self.memberIndex[other] = self.members.length;
123             self.members.push(other);
124         }
125     }
126 
127     function remove(intSet storage self, int other) {
128         if (self.memberExists[other])  {
129             self.memberExists[other] = false;
130             uint index = self.memberIndex[other];
131             // change index of last value to index of other 
132             self.memberIndex[self.members[self.members.length - 1]] = index;
133             // copy last value over other and decrement length
134             self.members[index] = self.members[self.members.length - 1];
135             self.members.length--;
136         }
137     }
138 
139     function contains(intSet storage self, int other) returns (bool) {
140         return self.memberExists[other];
141     }
142 
143     function length(intSet storage self) returns (uint256) {
144         return self.members.length;
145     }
146 
147 
148     // int8 set
149     struct int8Set {
150         int8[] members;
151         mapping (int8 => bool) memberExists;
152         mapping (int8 => uint) memberIndex;
153     }
154 
155     function insert(int8Set storage self, int8 other) {
156         if (!self.memberExists[other]) {
157             self.memberExists[other] = true;
158             self.memberIndex[other] = self.members.length;
159             self.members.push(other);
160         }
161     }
162 
163     function remove(int8Set storage self, int8 other) {
164         if (self.memberExists[other])  {
165             self.memberExists[other] = false;
166             uint index = self.memberIndex[other];
167             // change index of last value to index of other 
168             self.memberIndex[self.members[self.members.length - 1]] = index;
169             // copy last value over other and decrement length
170             self.members[index] = self.members[self.members.length - 1];
171             self.members.length--;
172         }
173     }
174 
175     function contains(int8Set storage self, int8 other) returns (bool) {
176         return self.memberExists[other];
177     }
178 
179     function length(int8Set storage self) returns (uint256) {
180         return self.members.length;
181     }
182 
183 
184     // byte set
185     struct byteSet {
186         byte[] members;
187         mapping (byte => bool) memberExists;
188         mapping (byte => uint) memberIndex;
189     }
190 
191     function insert(byteSet storage self, byte other) {
192         if (!self.memberExists[other]) {
193             self.memberExists[other] = true;
194             self.memberIndex[other] = self.members.length;
195             self.members.push(other);
196         }
197     }
198 
199     function remove(byteSet storage self, byte other) {
200         if (self.memberExists[other])  {
201             self.memberExists[other] = false;
202             uint index = self.memberIndex[other];
203             // change index of last value to index of other 
204             self.memberIndex[self.members[self.members.length - 1]] = index;
205             // copy last value over other and decrement length
206             self.members[index] = self.members[self.members.length - 1];
207             self.members.length--;
208         }
209     }
210 
211     function contains(byteSet storage self, byte other) returns (bool) {
212         return self.memberExists[other];
213     }
214 
215     function length(byteSet storage self) returns (uint256) {
216         return self.members.length;
217     }
218 
219 
220     // bytes32 set
221     struct bytes32Set {
222         bytes32[] members;
223         mapping (bytes32 => bool) memberExists;
224         mapping (bytes32 => uint) memberIndex;
225     }
226 
227     function insert(bytes32Set storage self, bytes32 other) {
228         if (!self.memberExists[other]) {
229             self.memberExists[other] = true;
230             self.memberIndex[other] = self.members.length;
231             self.members.push(other);
232         }
233     }
234 
235     function remove(bytes32Set storage self, bytes32 other) {
236         if (self.memberExists[other])  {
237             self.memberExists[other] = false;
238             uint index = self.memberIndex[other];
239             // change index of last value to index of other 
240             self.memberIndex[self.members[self.members.length - 1]] = index;
241             // copy last value over other and decrement length
242             self.members[index] = self.members[self.members.length - 1];
243             self.members.length--;
244         }
245     }
246 
247     function contains(bytes32Set storage self, bytes32 other) returns (bool) {
248         return self.memberExists[other];
249     }
250 
251     function length(bytes32Set storage self) returns (uint256) {
252         return self.members.length;
253     }
254 }
255 
256 contract Prover {
257     // attach library
258     using Sets for *;
259 
260 
261     // storage vars
262     address owner;
263     Sets.addressSet internal users;
264     mapping (address => UserAccount) internal ledger;
265     
266     
267     // structs
268     struct UserAccount {
269         Sets.bytes32Set hashes;
270         mapping (bytes32 => Entry) entries;
271     }
272 
273     struct Entry {
274         uint256 time;
275         uint256 value;
276     }
277 
278 
279     // constructor
280     function Prover() {
281         owner = msg.sender;
282     }
283     
284     
285     // fallback: unmatched transactions will be returned
286     function () {
287         revert();
288     }
289 
290 
291     // modifier to check if sender has an account
292     modifier hasAccount() {
293         assert(ledger[msg.sender].hashes.length() >= 1);
294         _;
295     }
296 
297 
298     // external functions
299     // proving
300     function proveIt(address target, bytes32 dataHash) external constant
301         returns (bool proved, uint256 time, uint256 value)
302     {
303         return status(target, dataHash);
304     }
305 
306     function proveIt(address target, string dataString) external constant
307         returns (bool proved, uint256 time, uint256 value)
308     {
309         return status(target, sha3(dataString));
310     }
311     
312     // allow access to our structs via functions with convenient return values
313     function usersGetter() public constant
314         returns (uint256 number_unique_addresses, address[] unique_addresses)
315     {
316         return (users.length(), users.members);
317     }
318 
319     function userEntries(address target) external constant returns (bytes32[]) {
320         return ledger[target].hashes.members;
321     }
322     
323     
324     // public functions
325     // adding entries
326     function addEntry(bytes32 dataHash) payable {
327         _addEntry(dataHash);
328     }
329 
330     function addEntry(string dataString) payable {
331         _addEntry(sha3(dataString));
332     }
333 
334     // deleting entries
335     function deleteEntry(bytes32 dataHash) hasAccount {
336         _deleteEntry(dataHash);
337     }
338 
339     function deleteEntry(string dataString) hasAccount {
340         _deleteEntry(sha3(dataString));
341     }
342     
343     // allow owner to delete contract if no accounts exist
344     function selfDestruct() {
345         if ((msg.sender == owner) && (users.length() == 0)) {
346             selfdestruct(owner);
347         }
348     }
349 
350 
351     // internal functions
352     function _addEntry(bytes32 dataHash) internal {
353         // ensure the entry doesn't exist
354         assert(!ledger[msg.sender].hashes.contains(dataHash));
355         // update UserAccount (hashes then entries)
356         ledger[msg.sender].hashes.insert(dataHash);
357         ledger[msg.sender].entries[dataHash] = Entry(now, msg.value);
358         // add sender to userlist
359         users.insert(msg.sender);
360     }
361 
362     function _deleteEntry(bytes32 dataHash) internal {
363         // ensure the entry does exist
364         assert(ledger[msg.sender].hashes.contains(dataHash));
365         uint256 rebate = ledger[msg.sender].entries[dataHash].value;
366         // update UserAccount (hashes then entries)
367         ledger[msg.sender].hashes.remove(dataHash);
368         delete ledger[msg.sender].entries[dataHash];
369         // send the rebate
370         if (rebate > 0) {
371             msg.sender.transfer(rebate);
372         }
373         // delete from userlist if this was the user's last entry
374         if (ledger[msg.sender].hashes.length() == 0) {
375             users.remove(msg.sender);
376         }
377     }
378 
379     // return status of arbitrary address and dataHash
380     function status(address target, bytes32 dataHash) internal constant
381         returns (bool proved, uint256 time, uint256 value)
382     {
383         return (ledger[msg.sender].hashes.contains(dataHash),
384                 ledger[target].entries[dataHash].time,
385                 ledger[target].entries[dataHash].value);
386     }
387 }