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
306     // FALLBACK
307 
308     function() payable { }
309 
310     // PUBLIC METHODS
311 
312     /// @notice Propose new versions of Melon
313     /// @param ofVersion Address of version contract to be proposed
314     function proposeVersion(address ofVersion) {
315         versionToProposalIds[ofVersion] = propose(address(this), new bytes(0), 0);
316     }
317 
318     /// @notice Approve new versions of Melon
319     /// @param ofVersion Address of version contract to be approved
320     function approveVersion(address ofVersion) {
321         confirm(versionToProposalIds[ofVersion]);
322     }
323 
324     /// @notice Trigger new versions of Melon
325     /// @param ofVersion Address of version contract to be triggered
326     function triggerVersion(address ofVersion) {
327         trigger(versionToProposalIds[ofVersion]);
328         addVersion(ofVersion);
329     }
330 
331     /// @notice Propose shutdown of Melon version
332     /// @param ofVersionId Version id to be proposed for shutdown
333     function proposeShutdown(uint ofVersionId) {
334         versionIdToShutdownIds[ofVersionId] = propose(address(this), new bytes(0), 0);
335     }
336 
337     /// @notice Approve shutdown of Melon version
338     /// @param ofVersionId Version id to be approved for shutdown
339     function approveShutdown(uint ofVersionId) {
340         confirm(versionIdToShutdownIds[ofVersionId]);
341     }
342 
343     /// @notice Trigger shutdown of Melon version
344     /// @param ofVersionId Version id to be triggered for shutdown
345     function triggerShutdown(uint ofVersionId) {
346         trigger(versionIdToShutdownIds[ofVersionId]);
347         shutDownVersion(ofVersionId);
348     }
349 
350     // PUBLIC VIEW METHODS
351 
352     /**
353     @return {
354         "ofVersion": "Address of the Version",
355         "active": "Whether the Version in question is active",
356         "timestamp": "When the Version in question was added to the list"
357     }
358     */
359     function getVersionById(uint id) view returns (address ofVersion, bool active, uint timestamp) {
360         return (
361             versions[id].version,
362             versions[id].active,
363             versions[id].timestamp
364         );
365     }
366 
367     // INTERNAL METHODS
368 
369     /// @notice Add an approved version of Melon
370     /// @param ofVersion Address of the version to add
371     /// @return id integer ID of the version (list index)
372     function addVersion(
373         address ofVersion
374     )
375         // In later version
376         //  require Authorities consensus
377         internal returns (uint id)
378     {
379         Version memory info;
380         info.version = ofVersion;
381         info.active = true;
382         info.timestamp = now;
383         versions.push(info);
384         VersionUpdated(versions.length - 1);
385     }
386 
387     /// @notice Remove and shut down version of Melon
388     /// @param id Id of the version to shutdown
389     function shutDownVersion(uint id)
390         pre_cond(isActive(id)) internal
391     {
392         VersionInterface Version = VersionInterface(versions[id].version);
393         Version.shutDown();
394         delete versions[id];
395         VersionUpdated(id);
396     }
397 
398     function isActive(uint id) internal returns (bool active) {
399         (, active, ) = getVersionById(id);
400     }
401 
402 
403 }
404 
405 interface VersionInterface {
406 
407     // EVENTS
408 
409     event FundUpdated(uint id);
410 
411     // PUBLIC METHODS
412 
413     function shutDown() external;
414 
415     function setupFund(
416         string ofFundName,
417         address ofQuoteAsset,
418         uint ofManagementFee,
419         uint ofPerformanceFee,
420         address ofCompliance,
421         address ofRiskMgmt,
422         address ofPriceFeed,
423         address[] ofExchanges,
424         address[] ofExchangeAdapters,
425         uint8 v,
426         bytes32 r,
427         bytes32 s
428     );
429     function shutDownFund(address ofFund);
430 
431     // PUBLIC VIEW METHODS
432 
433     function getNativeAsset() view returns (address);
434     function getFundById(uint withId) view returns (address);
435     function getLastFundId() view returns (uint);
436     function getFundByManager(address ofManager) view returns (address);
437     function termsAndConditionsAreSigned(uint8 v, bytes32 r, bytes32 s) view returns (bool signed);
438 
439 }