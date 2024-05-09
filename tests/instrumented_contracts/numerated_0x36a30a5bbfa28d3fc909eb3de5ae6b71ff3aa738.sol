1 pragma solidity ^0.4.11;
2 
3 
4 contract IPFSEvents {
5 	event HashAdded(address PubKey, string IPFSHash, uint ttl);
6 	event HashRemoved(address PubKey, string IPFSHash);
7 }
8 
9 contract Multimember {
10 
11     // TYPES
12 
13     // struct for the status of a pending operation.
14     struct PendingState {
15         uint yetNeeded;
16         uint membersDone;
17         uint index;
18     }
19 
20     // EVENTS
21 
22     // this contract only has seven types of events: it can accept a confirmation, in which case
23     // we record member and operation (hash) alongside it.
24     event Confirmation(address member, bytes32 operation);
25     event Revoke(address member, bytes32 operation);
26     // some others are in the case of an member changing.
27     event MemberChanged(address oldMember, address newMember);
28     event MemberAdded(address newMember);
29     event MemberRemoved(address oldMember);
30     // the last one is emitted if the required signatures change
31     event RequirementChanged(uint newRequirement);
32 
33     // MODIFIERS
34 
35     // simple single-sig function modifier.
36     modifier onlymember {
37         if (isMember(msg.sender))
38             _;
39     }
40     // multi-sig function modifier: the operation must have an intrinsic hash in order
41     // that later attempts can be realised as the same underlying operation and
42     // thus count as confirmations.
43     modifier onlymanymembers(bytes32 _operation) {
44         if (confirmAndCheck(_operation))
45             _;
46     }
47 
48     // METHODS
49 
50     // constructor is given number of sigs required to do protected "onlymanymembers" transactions
51     // as well as the selection of addresses capable of confirming them.
52     function Multimember(address[] _members, uint _required) public {
53         m_numMembers = _members.length + 1;
54         m_members[1] = uint(msg.sender);
55         m_memberIndex[uint(msg.sender)] = 1;
56         for (uint i = 0; i < _members.length; ++i) {
57             m_members[2 + i] = uint(_members[i]);
58             m_memberIndex[uint(_members[i])] = 2 + i;
59         }
60         m_required = _required;
61     }
62     
63     // Revokes a prior confirmation of the given operation
64     function revoke(bytes32 _operation) external {
65         uint memberIndex = m_memberIndex[uint(msg.sender)];
66         // make sure they're an member
67         if (memberIndex == 0) 
68             return;
69         uint memberIndexBit = 2**memberIndex;
70         var pending = m_pending[_operation];
71         if (pending.membersDone & memberIndexBit > 0) {
72             pending.yetNeeded++;
73             pending.membersDone -= memberIndexBit;
74             Revoke(msg.sender, _operation);
75         }
76     }
77     
78     // Replaces an member `_from` with another `_to`.
79     function changeMember(address _from, address _to) onlymanymembers(keccak256(_from,_to)) external {
80         if (isMember(_to)) 
81             return;
82         uint memberIndex = m_memberIndex[uint(_from)];
83         if (memberIndex == 0) 
84             return;
85 
86         clearPending();
87         m_members[memberIndex] = uint(_to);
88         m_memberIndex[uint(_from)] = 0;
89         m_memberIndex[uint(_to)] = memberIndex;
90         MemberChanged(_from, _to);
91     }
92     
93     function addMember(address _member) onlymanymembers(keccak256(_member)) public {
94         if (isMember(_member)) 
95             return;
96 
97         clearPending();
98         if (m_numMembers >= c_maxMembers)
99             reorganizeMembers();
100         if (m_numMembers >= c_maxMembers)
101             return;
102         m_numMembers++;
103         m_members[m_numMembers] = uint(_member);
104         m_memberIndex[uint(_member)] = m_numMembers;
105         MemberAdded(_member);
106     }
107     
108     function removeMember(address _member) onlymanymembers(keccak256(_member)) public {
109         uint memberIndex = m_memberIndex[uint(_member)];
110         if (memberIndex == 0) 
111             return;
112         if (m_required > m_numMembers - 1) 
113             return;
114 
115         m_members[memberIndex] = 0;
116         m_memberIndex[uint(_member)] = 0;
117         clearPending();
118         reorganizeMembers(); //make sure m_numMembers is equal to the number of members and always points to the optimal free slot
119         MemberRemoved(_member);
120     }
121     
122     function changeRequirement(uint _newRequired) onlymanymembers(keccak256(_newRequired)) external {
123         if (_newRequired > m_numMembers) 
124             return;
125         m_required = _newRequired;
126         clearPending();
127         RequirementChanged(_newRequired);
128     }
129     
130     function isMember(address _addr) public constant returns (bool) { 
131         return m_memberIndex[uint(_addr)] > 0;
132     }
133     
134     function hasConfirmed(bytes32 _operation, address _member) external constant returns (bool) {
135         var pending = m_pending[_operation];
136         uint memberIndex = m_memberIndex[uint(_member)];
137 
138         // make sure they're an member
139         if (memberIndex == 0) 
140             return false;
141 
142         // determine the bit to set for this member.
143         uint memberIndexBit = 2**memberIndex;
144         return !(pending.membersDone & memberIndexBit == 0);
145     }
146     
147     // INTERNAL METHODS
148 
149     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
150         // determine what index the present sender is:
151         uint memberIndex = m_memberIndex[uint(msg.sender)];
152         // make sure they're an member
153         if (memberIndex == 0) 
154             return;
155 
156         var pending = m_pending[_operation];
157         // if we're not yet working on this operation, switch over and reset the confirmation status.
158         if (pending.yetNeeded == 0) {
159             // reset count of confirmations needed.
160             pending.yetNeeded = m_required;
161             // reset which members have confirmed (none) - set our bitmap to 0.
162             pending.membersDone = 0;
163             pending.index = m_pendingIndex.length++;
164             m_pendingIndex[pending.index] = _operation;
165         }
166         // determine the bit to set for this member.
167         uint memberIndexBit = 2**memberIndex;
168         // make sure we (the message sender) haven't confirmed this operation previously.
169         if (pending.membersDone & memberIndexBit == 0) {
170             Confirmation(msg.sender, _operation);
171             // ok - check if count is enough to go ahead.
172             if (pending.yetNeeded <= 1) {
173                 // enough confirmations: reset and run interior.
174                 delete m_pendingIndex[m_pending[_operation].index];
175                 delete m_pending[_operation];
176                 return true;
177             } else {
178                 // not enough: record that this member in particular confirmed.
179                 pending.yetNeeded--;
180                 pending.membersDone |= memberIndexBit;
181             }
182         }
183     }
184 
185     function reorganizeMembers() private returns (bool) {
186         uint free = 1;
187         while (free < m_numMembers) {
188             while (free < m_numMembers && m_members[free] != 0) {
189                 free++;
190             } 
191 
192             while (m_numMembers > 1 && m_members[m_numMembers] == 0) {
193                 m_numMembers--;
194             } 
195 
196             if (free < m_numMembers && m_members[m_numMembers] != 0 && m_members[free] == 0) {
197                 m_members[free] = m_members[m_numMembers];
198                 m_memberIndex[m_members[free]] = free;
199                 m_members[m_numMembers] = 0;
200             }
201         }
202     }
203     
204     function clearPending() internal {
205         uint length = m_pendingIndex.length;
206         for (uint i = 0; i < length; ++i) {
207             if (m_pendingIndex[i] != 0) {
208                 delete m_pending[m_pendingIndex[i]];
209             }
210         }
211         delete m_pendingIndex;
212     }
213         
214     // FIELDS
215 
216     // the number of members that must confirm the same operation before it is run.
217     uint public m_required;
218     // pointer used to find a free slot in m_members
219     uint public m_numMembers;
220     
221     // list of members
222     uint[256] m_members;
223     uint constant c_maxMembers = 250;
224     // index on the list of members to allow reverse lookup
225     mapping(uint => uint) m_memberIndex;
226     // the ongoing operations.
227     mapping(bytes32 => PendingState) m_pending;
228     bytes32[] m_pendingIndex;
229 }
230 
231 contract IPFSProxy is IPFSEvents, Multimember {
232 	mapping(address => mapping( address => bool)) public complained;
233 	mapping(address => uint) public complaint;
234 	uint public banThreshold;
235 	uint public sizeLimit;
236 	address[] members;
237 	
238 	/**
239 	* @dev Throws if called by any account other than a valid member. 
240 	*/
241 	modifier onlyValidMembers {
242 		require (isMember(msg.sender));
243 		_;
244 	}
245 
246     event ContractAdded(address PubKey, uint ttl);
247     event ContractRemoved(address PubKey);
248 	event Banned(string IPFSHash);
249 	event BanAttempt(address complainer, address _Member, uint complaints );
250 	event PersistLimitChanged(uint Limit);	
251 
252 	/**
253 	* @dev Constructor - adds the owner of the contract to the list of valid members
254 	*/
255 	function IPFSProxy() Multimember (members, 1) public {
256 		addContract(this, 0);
257 		updateBanThreshold(1);
258 		setTotalPersistLimit(10000000000); //10 GB
259 	}
260 
261 	/**
262 	* @dev Add hash to persistent storage
263 	* @param _IPFSHash The ipfs hash to propagate.
264 	* @param _ttl amount of time is seconds to persist this. 
265 	*/
266 	function addHash(string _IPFSHash, uint _ttl) public onlyValidMembers {
267 		HashAdded(msg.sender,_IPFSHash,_ttl);
268 	}
269 
270 	/**
271 	* @dev Remove hash from persistent storage
272 	* @param _IPFSHash The ipfs hash to propagate.	
273 	*/
274 	function removeHash(string _IPFSHash) public onlyValidMembers {
275 		HashRemoved(msg.sender,_IPFSHash);
276 	}
277 
278 
279 	/** 
280 	* Add a contract to watch list. Each node will then 
281 	* watch it for `HashAdded(msg.sender,_IPFSHash,_ttl);` 
282 	* events and it will cache these events
283 	*/
284 
285 	function addContract(address _toWatch, uint _ttl) public onlyValidMembers {
286 		ContractAdded(_toWatch, _ttl);
287 	}
288 
289 	/**
290 	* @dev Remove contract from watch list
291 	*/
292 	function removeContract(address _contractAddress) public onlyValidMembers {
293 		ContractRemoved(_contractAddress);
294 	}
295 
296 	/**
297 	*@dev removes a member who exceeds the cap
298 	*/
299 	function banMember (address _Member, string _evidence) public onlyValidMembers {
300 		require(isMember(_Member));
301 		require(!complained[msg.sender][_Member]);
302 		complained[msg.sender][_Member] = true;
303 		complaint[_Member] += 1;	
304 		if (complaint[_Member] >= banThreshold) { 
305 			removeMember(_Member);
306 			if (!isMember(_Member)) {
307 				Banned(_evidence);
308 			} 
309 		} else {
310 			BanAttempt(msg.sender, _Member, complaint[_Member]);
311 		}
312 	}
313 	/**
314 	* @dev update ban threshold
315 	*/
316 	function updateBanThreshold (uint _banThreshold) public onlymanymembers(keccak256(_banThreshold)) {
317 		banThreshold = _banThreshold;
318 	}
319 
320 	/**
321 	* @dev set total allowed upload
322 	*
323 	**/
324 	function setTotalPersistLimit (uint _limit) public onlymanymembers(keccak256(_limit)) {
325 		sizeLimit = _limit;
326 		PersistLimitChanged(_limit);
327 	}
328 }