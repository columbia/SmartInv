1 pragma solidity ^0.4.13;
2 
3 contract DSExec {
4     function tryExec( address target, bytes calldata, uint value)
5              internal
6              returns (bool call_ret)
7     {
8         return target.call.value(value)(calldata);
9     }
10     function exec( address target, bytes calldata, uint value)
11              internal
12     {
13         if(!tryExec(target, calldata, value)) {
14             revert();
15         }
16     }
17 
18     // Convenience aliases
19     function exec( address t, bytes c )
20         internal
21     {
22         exec(t, c, 0);
23     }
24     function exec( address t, uint256 v )
25         internal
26     {
27         bytes memory c; exec(t, c, v);
28     }
29     function tryExec( address t, bytes c )
30         internal
31         returns (bool)
32     {
33         return tryExec(t, c, 0);
34     }
35     function tryExec( address t, uint256 v )
36         internal
37         returns (bool)
38     {
39         bytes memory c; return tryExec(t, c, v);
40     }
41 }
42 
43 contract DSNote {
44     event LogNote(
45         bytes4   indexed  sig,
46         address  indexed  guy,
47         bytes32  indexed  foo,
48         bytes32  indexed  bar,
49         uint              wad,
50         bytes             fax
51     ) anonymous;
52 
53     modifier note {
54         bytes32 foo;
55         bytes32 bar;
56 
57         assembly {
58             foo := calldataload(4)
59             bar := calldataload(36)
60         }
61 
62         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
63 
64         _;
65     }
66 }
67 
68 contract DSGroup is DSExec, DSNote {
69     address[]  public  members;
70     uint       public  quorum;
71     uint       public  window;
72     uint       public  actionCount;
73 
74     mapping (uint => Action)                     public  actions;
75     mapping (uint => mapping (address => bool))  public  confirmedBy;
76     mapping (address => bool)                    public  isMember;
77 
78     // Legacy events
79     event Proposed   (uint id, bytes calldata);
80     event Confirmed  (uint id, address member);
81     event Triggered  (uint id);
82 
83     struct Action {
84         address  target;
85         bytes    calldata;
86         uint     value;
87 
88         uint     confirmations;
89         uint     deadline;
90         bool     triggered;
91     }
92 
93     function DSGroup(
94         address[]  members_,
95         uint       quorum_,
96         uint       window_
97     ) {
98         members  = members_;
99         quorum   = quorum_;
100         window   = window_;
101 
102         for (uint i = 0; i < members.length; i++) {
103             isMember[members[i]] = true;
104         }
105     }
106 
107     function memberCount() constant returns (uint) {
108         return members.length;
109     }
110 
111     function target(uint id) constant returns (address) {
112         return actions[id].target;
113     }
114     function calldata(uint id) constant returns (bytes) {
115         return actions[id].calldata;
116     }
117     function value(uint id) constant returns (uint) {
118         return actions[id].value;
119     }
120 
121     function confirmations(uint id) constant returns (uint) {
122         return actions[id].confirmations;
123     }
124     function deadline(uint id) constant returns (uint) {
125         return actions[id].deadline;
126     }
127     function triggered(uint id) constant returns (bool) {
128         return actions[id].triggered;
129     }
130 
131     function confirmed(uint id) constant returns (bool) {
132         return confirmations(id) >= quorum;
133     }
134     function expired(uint id) constant returns (bool) {
135         return now > deadline(id);
136     }
137 
138     function deposit() note payable {
139     }
140 
141     function propose(
142         address  target,
143         bytes    calldata,
144         uint     value
145     ) onlyMembers note returns (uint id) {
146         id = ++actionCount;
147 
148         actions[id].target    = target;
149         actions[id].calldata  = calldata;
150         actions[id].value     = value;
151         actions[id].deadline  = now + window;
152 
153         Proposed(id, calldata);
154     }
155 
156     function confirm(uint id) onlyMembers onlyActive(id) note {
157         assert(!confirmedBy[id][msg.sender]);
158 
159         confirmedBy[id][msg.sender] = true;
160         actions[id].confirmations++;
161 
162         Confirmed(id, msg.sender);
163     }
164 
165     function trigger(uint id) onlyMembers onlyActive(id) note {
166         assert(confirmed(id));
167 
168         actions[id].triggered = true;
169         exec(actions[id].target, actions[id].calldata, actions[id].value);
170 
171         Triggered(id);
172     }
173 
174     modifier onlyMembers {
175         assert(isMember[msg.sender]);
176         _;
177     }
178 
179     modifier onlyActive(uint id) {
180         assert(!expired(id));
181         assert(!triggered(id));
182         _;
183     }
184 
185     //------------------------------------------------------------------
186     // Legacy functions
187     //------------------------------------------------------------------
188 
189     function getInfo() constant returns (
190         uint  quorum_,
191         uint  memberCount,
192         uint  window_,
193         uint  actionCount_
194     ) {
195         return (quorum, members.length, window, actionCount);
196     }
197 
198     function getActionStatus(uint id) constant returns (
199         uint     confirmations,
200         uint     deadline,
201         bool     triggered,
202         address  target,
203         uint     value
204     ) {
205         return (
206             actions[id].confirmations,
207             actions[id].deadline,
208             actions[id].triggered,
209             actions[id].target,
210             actions[id].value
211         );
212     }
213 }
214 
215 contract DSGroupFactory is DSNote {
216     mapping (address => bool)  public  isGroup;
217 
218     function newGroup(
219         address[]  members,
220         uint       quorum,
221         uint       window
222     ) note returns (DSGroup group) {
223         group = new DSGroup(members, quorum, window);
224         isGroup[group] = true;
225     }
226 }
227 
228 contract DBC {
229 
230     // MODIFIERS
231 
232     modifier pre_cond(bool condition) {
233         require(condition);
234         _;
235     }
236 
237     modifier post_cond(bool condition) {
238         _;
239         assert(condition);
240     }
241 
242     modifier invariant(bool condition) {
243         require(condition);
244         _;
245         assert(condition);
246     }
247 }
248 
249 contract Owned is DBC {
250 
251     // FIELDS
252 
253     address public owner;
254 
255     // NON-CONSTANT METHODS
256 
257     function Owned() { owner = msg.sender; }
258 
259     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
260 
261     // PRE, POST, INVARIANT CONDITIONS
262 
263     function isOwner() internal returns (bool) { return msg.sender == owner; }
264 
265 }
266 
267 contract Governance is DBC, Owned, DSGroup {
268 
269     // TYPES
270 
271     struct Version {
272         address version;
273         bool active;
274         uint timestamp;
275     }
276 
277     // FIELDS
278 
279     // Constructor fields
280     address public MELON_ASSET; // Adresss of Melon asset contract
281     address[] public authorities; // Addresses of all authorities
282     // Methods fields
283     Version[] public versions;
284     mapping (address => uint) public versionToProposalIds; // Links version addresses to proposal ids created through DSGroup
285     mapping (uint => uint) public versionIdToShutdownIds; // Links version ids to shutdown proposal ids created through DSGroup
286 
287     // EVENTS
288 
289     event VersionUpdated(uint id);
290 
291     // METHODS
292 
293     // CONSTRUCTOR
294 
295     /// @param ofAuthorities Addresses of authorities
296     /// @param ofQuorum Minimum number of signatures required for proposal to pass by
297     /// @param ofWindow Time limit for proposal validity
298     function Governance(
299         address[] ofAuthorities,
300         uint ofQuorum,
301         uint ofWindow
302     )
303         DSGroup(ofAuthorities, ofQuorum, ofWindow)
304     {}
305 
306     // PUBLIC VIEW METHODS
307 
308     /**
309     @return {
310         "ofVersion": "Address of the Version",
311         "active": "Whether the Version in question is active",
312         "timestamp": "When the Version in question was added to the list"
313     }
314     */
315     function getVersionById(uint id) view returns (address ofVersion, bool active, uint timestamp) {
316         return (
317             versions[id].version,
318             versions[id].active,
319             versions[id].timestamp
320         );
321     }
322 
323     // INTERNAL METHODS
324 
325     /// @dev In later version, require authorities consensus
326     /// @notice Add an approved version of Melon
327     /// @param ofVersion Address of the version to add
328     /// @return id integer ID of the version (list index)
329     function addVersion(
330         address ofVersion
331     )
332         pre_cond(msg.sender == address(this))
333         returns (uint id)
334     {
335         require(msg.sender == address(this));
336         Version memory info;
337         info.version = ofVersion;
338         info.active = true;
339         info.timestamp = now;
340         versions.push(info);
341         emit VersionUpdated(versions.length - 1);
342     }
343 
344     /// @notice Remove and shut down version of Melon
345     /// @param id Id of the version to shutdown
346     function shutDownVersion(uint id)
347         pre_cond(msg.sender == address(this))
348         pre_cond(isActive(id))
349     {
350         require(msg.sender == address(this));
351         VersionInterface Version = VersionInterface(versions[id].version);
352         Version.shutDown();
353         delete versions[id];
354         emit VersionUpdated(id);
355     }
356 
357     function getVersionsLength() public view returns (uint) {
358         return versions.length;
359     }
360 
361     function isActive(uint id) public view returns (bool active) {
362         (, active, ) = getVersionById(id);
363     }
364 }
365 
366 interface VersionInterface {
367 
368     // EVENTS
369 
370     event FundUpdated(uint id);
371 
372     // PUBLIC METHODS
373 
374     function shutDown() external;
375 
376     function setupFund(
377         bytes32 ofFundName,
378         address ofQuoteAsset,
379         uint ofManagementFee,
380         uint ofPerformanceFee,
381         address ofCompliance,
382         address ofRiskMgmt,
383         address[] ofExchanges,
384         address[] ofDefaultAssets,
385         uint8 v,
386         bytes32 r,
387         bytes32 s
388     );
389     function shutDownFund(address ofFund);
390 
391     // PUBLIC VIEW METHODS
392 
393     function getNativeAsset() view returns (address);
394     function getFundById(uint withId) view returns (address);
395     function getLastFundId() view returns (uint);
396     function getFundByManager(address ofManager) view returns (address);
397     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
398 
399 }