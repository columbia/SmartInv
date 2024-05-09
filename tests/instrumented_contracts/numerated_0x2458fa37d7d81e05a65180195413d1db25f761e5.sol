1 pragma solidity ^0.4.2;
2 
3 contract SpiceMembers {
4     enum MemberLevel { None, Member, Manager, Director }
5     struct Member {
6         uint id;
7         MemberLevel level;
8         bytes32 info;
9     }
10 
11     mapping (address => Member) member;
12 
13     address public owner;
14     mapping (uint => address) public memberAddress;
15     uint public memberCount;
16 
17     event TransferOwnership(address indexed sender, address indexed owner);
18     event AddMember(address indexed sender, address indexed member);
19     event RemoveMember(address indexed sender, address indexed member);
20     event SetMemberLevel(address indexed sender, address indexed member, MemberLevel level);
21     event SetMemberInfo(address indexed sender, address indexed member, bytes32 info);
22 
23     function SpiceMembers() {
24         owner = msg.sender;
25 
26         memberCount = 1;
27         memberAddress[memberCount] = owner;
28         member[owner] = Member(memberCount, MemberLevel.None, 0);
29     }
30 
31     modifier onlyOwner {
32         if (msg.sender != owner) throw;
33         _;
34     }
35 
36     modifier onlyManager {
37         if (msg.sender != owner && memberLevel(msg.sender) < MemberLevel.Manager) throw;
38         _;
39     }
40     
41     function transferOwnership(address _target) onlyOwner {
42         // If new owner has no memberId, create one
43         if (member[_target].id == 0) {
44             memberCount++;
45             memberAddress[memberCount] = _target;
46             member[_target] = Member(memberCount, MemberLevel.None, 0);
47         }
48         owner = _target;
49         TransferOwnership(msg.sender, owner);
50     }
51 
52     function addMember(address _target) onlyManager {
53         // Make sure trying to add an existing member throws an error
54         if (memberLevel(_target) != MemberLevel.None) throw;
55 
56         // If added member has no memberId, create one
57         if (member[_target].id == 0) {
58             memberCount++;
59             memberAddress[memberCount] = _target;
60             member[_target] = Member(memberCount, MemberLevel.None, 0);
61         }
62 
63         // Set memberLevel to initial value with basic access
64         member[_target].level = MemberLevel.Member;
65         AddMember(msg.sender, _target);
66     }
67 
68     function removeMember(address _target) {
69         // Make sure trying to remove a non-existing member throws an error
70         if (memberLevel(_target) == MemberLevel.None) throw;
71         // Make sure members are only allowed to delete members lower than their level
72         if (msg.sender != owner && memberLevel(msg.sender) <= memberLevel(_target)) throw;
73 
74         member[_target].level = MemberLevel.None;
75         RemoveMember(msg.sender, _target);
76     }
77 
78     function setMemberLevel(address _target, MemberLevel level) {
79         // Make sure all levels are larger than None but not higher than Director
80         if (level == MemberLevel.None || level > MemberLevel.Director) throw;
81         // Make sure the _target is currently already a member
82         if (memberLevel(_target) == MemberLevel.None) throw;
83         // Make sure the new level is lower level than we are (we cannot overpromote)
84         if (msg.sender != owner && memberLevel(msg.sender) <= level) throw;
85         // Make sure the member is currently on lower level than we are
86         if (msg.sender != owner && memberLevel(msg.sender) <= memberLevel(_target)) throw;
87 
88         member[_target].level = level;
89         SetMemberLevel(msg.sender, _target, level);
90     }
91 
92     function setMemberInfo(address _target, bytes32 info) {
93         // Make sure the target is currently already a member
94         if (memberLevel(_target) == MemberLevel.None) throw;
95         // Make sure the member is currently on lower level than we are
96         if (msg.sender != owner && msg.sender != _target && memberLevel(msg.sender) <= memberLevel(_target)) throw;
97 
98         member[_target].info = info;
99         SetMemberInfo(msg.sender, _target, info);
100     }
101 
102     function memberId(address _target) constant returns (uint) {
103         return member[_target].id;
104     }
105 
106     function memberLevel(address _target) constant returns (MemberLevel) {
107         return member[_target].level;
108     }
109 
110     function memberInfo(address _target) constant returns (bytes32) {
111         return member[_target].info;
112     }
113 }
114 
115 contract SpiceControlled {
116     SpiceMembers members;
117 
118     modifier onlyOwner {
119         if (!hasOwnerAccess(msg.sender)) throw;
120         _;
121     }
122 
123     modifier onlyDirector {
124         if (!hasDirectorAccess(msg.sender)) throw;
125         _;
126     }
127 
128     modifier onlyManager {
129         if (!hasManagerAccess(msg.sender)) throw;
130         _;
131     }
132 
133     modifier onlyMember {
134         if (!hasMemberAccess(msg.sender)) throw;
135         _;
136     }
137 
138     function SpiceControlled(address membersAddress) {
139         members = SpiceMembers(membersAddress);
140     }
141 
142     function hasOwnerAccess(address _target) internal returns (bool) {
143         return (_target == members.owner());
144     }
145 
146     function hasDirectorAccess(address _target) internal returns (bool) {
147         return (members.memberLevel(_target) >= SpiceMembers.MemberLevel.Director || hasOwnerAccess(_target));
148     }
149 
150     function hasManagerAccess(address _target) internal returns (bool) {
151         return (members.memberLevel(_target) >= SpiceMembers.MemberLevel.Manager || hasOwnerAccess(_target));
152     }
153     
154     function hasMemberAccess(address _target) internal returns (bool) {
155         return (members.memberLevel(_target) >= SpiceMembers.MemberLevel.Member || hasOwnerAccess(_target));
156     }
157 }
158 
159 contract IPayoutCalculator {
160     function calculatePayout(bytes32 _info, uint _duration) returns (uint);
161 }
162 
163 contract SpicePayroll is SpiceControlled {
164     struct PayrollEntry {
165         bool available;
166         uint duration;
167         bool processed;
168         uint payout;
169     }
170 
171     address creator;
172 
173     uint public fromBlock;
174     uint public toBlock;
175 
176     mapping (bytes32 => PayrollEntry) entries;
177     bytes32[] infos;
178 
179     address calculator;
180     bool public locked;
181 
182     event NewPayroll(address indexed creator);
183     event FailedMarking(bytes32 indexed info, bytes32 indexed description, uint total, int duration);
184     event AddMarking(bytes32 indexed info, bytes32 indexed description, int duration, uint total);
185     event ProcessMarkings(bytes32 indexed info, uint total, uint duration, uint payout);
186     event AllMarkingsProcessed(address indexed calculator, uint maxDuration, uint fromBlock, uint toBlock);
187 
188     event ModifyMarking(bytes32 indexed info, uint duration, uint payout);
189     event SetPayrollLocked(bool locked);
190 
191     modifier onlyCreator {
192         if (msg.sender != creator) throw;
193         _;
194     }
195 
196     modifier onlyUnprocessed {
197         if (calculator != 0) throw;
198         _;
199     }
200     
201     modifier onlyProcessed {
202         if (calculator == 0) throw;
203         _;
204     }
205 
206     modifier onlyUnlocked {
207         if (locked) throw;
208         _;
209     }
210 
211     function SpicePayroll(address _members) SpiceControlled(_members) {
212         creator = msg.sender;
213         fromBlock = block.number;
214         NewPayroll(msg.sender);
215     }
216 
217     function addMarking(bytes32 _info, bytes32 _description, int _duration) onlyCreator onlyUnprocessed returns(bool) {
218         // Check if the duration would become negative as a result of this marking
219         // and if it does, mark this as failed and return false to indicate failure.
220         if (_duration < 0 && entries[_info].duration < uint(-_duration)) {
221           FailedMarking(_info, _description, entries[_info].duration, _duration);
222           return false;
223         }
224 
225         // If info not added yet, add it to the infos array
226         PayrollEntry entry = entries[_info];
227         if (!entry.available) {
228             entry.available = true;
229             infos.push(_info);
230         }
231 
232         // Modify entry duration and send marking event
233         if (_duration < 0) {
234             entry.duration -= uint(-_duration);
235         } else {
236             entry.duration += uint(_duration);
237         }
238         AddMarking(_info, _description, _duration, entry.duration);
239         return true;
240     }
241 
242     function processMarkings(address _calculator, uint _maxDuration) onlyCreator onlyUnprocessed {
243         calculator = _calculator;
244         for (uint i = 0; i < infos.length; i++) {
245             bytes32 info = infos[i];
246             PayrollEntry entry = entries[info];
247 
248             uint originalDuration = entry.duration;
249             entry.duration = (originalDuration <= _maxDuration) ? originalDuration : _maxDuration;
250             entry.payout = IPayoutCalculator(calculator).calculatePayout(info, entry.duration);
251             ProcessMarkings(info, originalDuration, entry.duration, entry.payout);
252         }
253         toBlock = block.number;
254         AllMarkingsProcessed(_calculator, _maxDuration, fromBlock, toBlock);
255     }
256 
257     function modifyMarking(bytes32 _info, uint _duration) onlyDirector onlyProcessed onlyUnlocked {
258         if (!entries[_info].available) throw;
259 
260         PayrollEntry entry = entries[_info];
261         entry.duration = _duration;
262         entry.payout = IPayoutCalculator(calculator).calculatePayout(_info, _duration);
263         ModifyMarking(_info, entry.duration, entry.payout);
264     }
265 
266     function lock() onlyDirector {
267         locked = true;
268         SetPayrollLocked(locked);
269     }
270 
271     function unlock() onlyOwner {
272         locked = false;
273         SetPayrollLocked(locked);
274     }
275 
276     function processed() constant returns (bool) {
277         return (calculator != 0);
278     }
279 
280     function duration(bytes32 _info) constant returns (uint) {
281         return entries[_info].duration;
282     }
283 
284     function payout(bytes32 _info) constant returns (uint) {
285         return entries[_info].payout;
286     }
287 
288     function entryInfo(uint _index) constant returns (bytes32) {
289         return infos[_index];
290     }
291 
292     function entryCount() constant returns (uint) {
293         return infos.length;
294     }
295 }
296 
297 contract SpiceHours is SpiceControlled {
298     address[] public payrolls;
299 
300     event MarkHours(bytes32 indexed info, bytes32 indexed description, int duration, bool success);
301     event ProcessPayroll(address indexed payroll, uint maxDuration);
302     event CreatePayroll(address indexed payroll);
303 
304     function SpiceHours(address _members) SpiceControlled(_members) {
305         payrolls[payrolls.length++] = new SpicePayroll(members);
306         CreatePayroll(payrolls[payrolls.length-1]);
307     }
308 
309     function markHours(bytes32 _info, bytes32 _description, int _duration) onlyMember {
310         if (!hasManagerAccess(msg.sender) && members.memberInfo(msg.sender) != _info) throw;
311         if (_duration == 0) throw;
312         if (_info == 0) throw;
313 
314         SpicePayroll payroll = SpicePayroll(payrolls[payrolls.length-1]);
315         bool success = payroll.addMarking(_info, _description, _duration);
316         MarkHours(_info, _description, _duration, success);
317     }
318 
319     function markHours(bytes32 _description, int _duration) {
320         markHours(members.memberInfo(msg.sender), _description, _duration);
321     }
322 
323     function processPayroll(address _calculator, uint _maxDuration) onlyDirector {
324         SpicePayroll payroll = SpicePayroll(payrolls[payrolls.length-1]);
325         payroll.processMarkings(_calculator, _maxDuration);
326         ProcessPayroll(payroll, _maxDuration);
327 
328         payrolls[payrolls.length++] = new SpicePayroll(members);
329         CreatePayroll(payrolls[payrolls.length-1]);
330     }
331 
332     function hasPayroll(address _address) constant returns (bool) {
333         for (uint i; i < payrolls.length; i++) {
334             if (payrolls[i] == _address) return true;
335         }
336         return false;
337     }
338 
339     function payrollCount() constant returns (uint) {
340         return payrolls.length;
341     }
342 }