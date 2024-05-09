1 pragma solidity ^0.4.18;
2 
3 // sets support up to 2^256-2 members
4 // memberIndices stores the index of members + 1, not their actual index
5 library Sets {
6     // address set
7     struct addressSet {
8         address[] members;
9         mapping(address => uint) memberIndices;
10     }
11 
12     function insert(addressSet storage self, address other) public {
13         if (!contains(self, other)) {
14             assert(length(self) < 2**256-1);
15             self.members.push(other);
16             self.memberIndices[other] = length(self);
17         }
18     }
19 
20     function remove(addressSet storage self, address other) public {
21         if (contains(self, other)) {
22             uint replaceIndex = self.memberIndices[other];
23             address lastMember = self.members[length(self)-1];
24             // overwrite other with the last member and remove last member
25             self.members[replaceIndex-1] = lastMember;
26             self.members.length--;
27             // reflect this change in the indices
28             self.memberIndices[lastMember] = replaceIndex;
29             delete self.memberIndices[other];
30         }
31     }
32 
33     function contains(addressSet storage self, address other) public view returns (bool) {
34         return self.memberIndices[other] > 0;
35     }
36 
37     function length(addressSet storage self) public view returns (uint) {
38         return self.members.length;
39     }
40 
41 
42     // uint set
43     struct uintSet {
44         uint[] members;
45         mapping(uint => uint) memberIndices;
46     }
47 
48     function insert(uintSet storage self, uint other) public {
49         if (!contains(self, other)) {
50             assert(length(self) < 2**256-1);
51             self.members.push(other);
52             self.memberIndices[other] = length(self);
53         }
54     }
55 
56     function remove(uintSet storage self, uint other) public {
57         if (contains(self, other)) {
58             uint replaceIndex = self.memberIndices[other];
59             uint lastMember = self.members[length(self)-1];
60             // overwrite other with the last member and remove last member
61             self.members[replaceIndex-1] = lastMember;
62             self.members.length--;
63             // reflect this change in the indices
64             self.memberIndices[lastMember] = replaceIndex;
65             delete self.memberIndices[other];
66         }
67     }
68 
69     function contains(uintSet storage self, uint other) public view returns (bool) {
70         return self.memberIndices[other] > 0;
71     }
72 
73     function length(uintSet storage self) public view returns (uint) {
74         return self.members.length;
75     }
76 
77 
78     // uint8 set
79     struct uint8Set {
80         uint8[] members;
81         mapping(uint8 => uint) memberIndices;
82     }
83 
84     function insert(uint8Set storage self, uint8 other) public {
85         if (!contains(self, other)) {
86             assert(length(self) < 2**256-1);
87             self.members.push(other);
88             self.memberIndices[other] = length(self);
89         }
90     }
91 
92     function remove(uint8Set storage self, uint8 other) public {
93         if (contains(self, other)) {
94             uint replaceIndex = self.memberIndices[other];
95             uint8 lastMember = self.members[length(self)-1];
96             // overwrite other with the last member and remove last member
97             self.members[replaceIndex-1] = lastMember;
98             self.members.length--;
99             // reflect this change in the indices
100             self.memberIndices[lastMember] = replaceIndex;
101             delete self.memberIndices[other];
102         }
103     }
104 
105     function contains(uint8Set storage self, uint8 other) public view returns (bool) {
106         return self.memberIndices[other] > 0;
107     }
108 
109     function length(uint8Set storage self) public view returns (uint) {
110         return self.members.length;
111     }
112 
113 
114     // int set
115     struct intSet {
116         int[] members;
117         mapping(int => uint) memberIndices;
118     }
119 
120     function insert(intSet storage self, int other) public {
121         if (!contains(self, other)) {
122             assert(length(self) < 2**256-1);
123             self.members.push(other);
124             self.memberIndices[other] = length(self);
125         }
126     }
127 
128     function remove(intSet storage self, int other) public {
129         if (contains(self, other)) {
130             uint replaceIndex = self.memberIndices[other];
131             int lastMember = self.members[length(self)-1];
132             // overwrite other with the last member and remove last member
133             self.members[replaceIndex-1] = lastMember;
134             self.members.length--;
135             // reflect this change in the indices
136             self.memberIndices[lastMember] = replaceIndex;
137             delete self.memberIndices[other];
138         }
139     }
140 
141     function contains(intSet storage self, int other) public view returns (bool) {
142         return self.memberIndices[other] > 0;
143     }
144 
145     function length(intSet storage self) public view returns (uint) {
146         return self.members.length;
147     }
148 
149 
150     // int8 set
151     struct int8Set {
152         int8[] members;
153         mapping(int8 => uint) memberIndices;
154     }
155 
156     function insert(int8Set storage self, int8 other) public {
157         if (!contains(self, other)) {
158             assert(length(self) < 2**256-1);
159             self.members.push(other);
160             self.memberIndices[other] = length(self);
161         }
162     }
163 
164     function remove(int8Set storage self, int8 other) public {
165         if (contains(self, other)) {
166             uint replaceIndex = self.memberIndices[other];
167             int8 lastMember = self.members[length(self)-1];
168             // overwrite other with the last member and remove last member
169             self.members[replaceIndex-1] = lastMember;
170             self.members.length--;
171             // reflect this change in the indices
172             self.memberIndices[lastMember] = replaceIndex;
173             delete self.memberIndices[other];
174         }
175     }
176 
177     function contains(int8Set storage self, int8 other) public view returns (bool) {
178         return self.memberIndices[other] > 0;
179     }
180 
181     function length(int8Set storage self) public view returns (uint) {
182         return self.members.length;
183     }
184 
185 
186     // byte set
187     struct byteSet {
188         byte[] members;
189         mapping(byte => uint) memberIndices;
190     }
191 
192     function insert(byteSet storage self, byte other) public {
193         if (!contains(self, other)) {
194             assert(length(self) < 2**256-1);
195             self.members.push(other);
196             self.memberIndices[other] = length(self);
197         }
198     }
199 
200     function remove(byteSet storage self, byte other) public {
201         if (contains(self, other)) {
202             uint replaceIndex = self.memberIndices[other];
203             byte lastMember = self.members[length(self)-1];
204             // overwrite other with the last member and remove last member
205             self.members[replaceIndex-1] = lastMember;
206             self.members.length--;
207             // reflect this change in the indices
208             self.memberIndices[lastMember] = replaceIndex;
209             delete self.memberIndices[other];
210         }
211     }
212 
213     function contains(byteSet storage self, byte other) public view returns (bool) {
214         return self.memberIndices[other] > 0;
215     }
216 
217     function length(byteSet storage self) public view returns (uint) {
218         return self.members.length;
219     }
220 
221 
222     // bytes32 set
223     struct bytes32Set {
224         bytes32[] members;
225         mapping(bytes32 => uint) memberIndices;
226     }
227 
228     function insert(bytes32Set storage self, bytes32 other) public {
229         if (!contains(self, other)) {
230             assert(length(self) < 2**256-1);
231             self.members.push(other);
232             self.memberIndices[other] = length(self);
233         }
234     }
235 
236     function remove(bytes32Set storage self, bytes32 other) public {
237         if (contains(self, other)) {
238             uint replaceIndex = self.memberIndices[other];
239             bytes32 lastMember = self.members[length(self)-1];
240             // overwrite other with the last member and remove last member
241             self.members[replaceIndex-1] = lastMember;
242             self.members.length--;
243             // reflect this change in the indices
244             self.memberIndices[lastMember] = replaceIndex;
245             delete self.memberIndices[other];
246         }
247     }
248 
249     function contains(bytes32Set storage self, bytes32 other) public view returns (bool) {
250         return self.memberIndices[other] > 0;
251     }
252 
253     function length(bytes32Set storage self) public view returns (uint) {
254         return self.members.length;
255     }
256 }
257 
258 contract Prover {
259     // attach library
260     using Sets for Sets.addressSet;
261     using Sets for Sets.bytes32Set;
262 
263     // storage vars
264     address owner;
265     Sets.addressSet users;
266     mapping(address => Account) internal accounts;
267 
268     // structs
269     struct Account {
270         Sets.bytes32Set entries;
271         mapping(bytes32 => Entry) values;
272     }
273 
274     struct Entry {
275         uint time;
276         uint staked;
277     }
278 
279     // constructor
280     function Prover() public {
281         owner = msg.sender;
282     }
283 
284     // fallback: allow internal calls
285     function() internal {
286         if (! this.delegatecall(msg.data)) {
287             revert();
288         }
289     }
290 
291 
292     // modifier to check if a target address has a particular entry
293     modifier entryExists(address target, bytes32 dataHash, bool exists) {
294         assert(accounts[target].entries.contains(dataHash) == exists);
295         _;
296     }
297 
298     // external functions
299     // allow access to our structs via functions with convenient return values
300     function registeredUsers()
301         external
302         view
303         returns (uint number_unique_addresses, address[] unique_addresses) {
304         return (users.length(), users.members);
305     }
306     function userEntries(address target)
307         external
308         view
309         returns (bytes32[]) {
310         return accounts[target].entries.members;
311     }
312     function entryInformation(address target, bytes32 dataHash)
313         external
314         view
315         returns (bool proved, uint time, uint staked) {
316         return (accounts[target].entries.contains(dataHash),
317                 accounts[target].values[dataHash].time,
318                 accounts[target].values[dataHash].staked);
319     }
320 
321     // public functions
322     // adding entries
323     function addEntry(bytes32 dataHash)
324         public
325         payable
326         entryExists(msg.sender, dataHash, false){
327         users.insert(msg.sender);
328         accounts[msg.sender].entries.insert(dataHash);
329         accounts[msg.sender].values[dataHash] = Entry(now, msg.value);
330     }
331 
332     // deleting entries
333     function deleteEntry(bytes32 dataHash)
334         public
335         entryExists(msg.sender, dataHash, true) {
336         uint rebate = accounts[msg.sender].values[dataHash].staked;
337         // update user account
338         delete accounts[msg.sender].values[dataHash];
339         accounts[msg.sender].entries.remove(dataHash);
340         // delete from users if this was the user's last entry
341         if (accounts[msg.sender].entries.length() == 0) {
342             users.remove(msg.sender);
343         }
344         // send the rebate
345         if (rebate > 0) msg.sender.transfer(rebate);
346     }
347 
348     // allow owner to delete contract if no accounts exist
349     function selfDestruct() public {
350         if ((msg.sender == owner) && (users.length() == 0)) {
351             selfdestruct(owner);
352         }
353     }
354 }