1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20 {
31     function totalSupply() external constant returns (uint256 _totalSupply);
32     function balanceOf(address _owner) external constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) external returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
35     function approve(address _spender, uint256 _old, uint256 _new) external returns (bool success);
36     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     function ERC20() internal {
41     }
42 }
43 
44 
45 library RingList {
46 
47     address constant NULL = 0x0;
48     address constant HEAD = 0x0;
49     bool constant PREV = false;
50     bool constant NEXT = true;
51 
52     struct LinkedList{
53         mapping (address => mapping (bool => address)) list;
54     }
55 
56     /// @dev returns true if the list exists
57     /// @param self stored linked list from contract
58     function listExists(LinkedList storage self)
59     internal
60     view returns (bool)
61     {
62         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
63         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
64             return true;
65         } else {
66             return false;
67         }
68     }
69 
70     /// @dev returns true if the node exists
71     /// @param self stored linked list from contract
72     /// @param _node a node to search for
73     function nodeExists(LinkedList storage self, address _node)
74     internal
75     view returns (bool)
76     {
77         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
78             if (self.list[HEAD][NEXT] == _node) {
79                 return true;
80             } else {
81                 return false;
82             }
83         } else {
84             return true;
85         }
86     }
87 
88     /// @dev Returns the number of elements in the list
89     /// @param self stored linked list from contract
90     function sizeOf(LinkedList storage self) internal view returns (uint256 numElements) {
91         bool exists;
92         address i;
93         (exists,i) = getAdjacent(self, HEAD, NEXT);
94         while (i != HEAD) {
95             (exists,i) = getAdjacent(self, i, NEXT);
96             numElements++;
97         }
98         return;
99     }
100 
101     /// @dev Returns the links of a node as a tuple
102     /// @param self stored linked list from contract
103     /// @param _node id of the node to get
104     function getNode(LinkedList storage self, address _node)
105     internal view returns (bool, address, address)
106     {
107         if (!nodeExists(self,_node)) {
108             return (false,0x0,0x0);
109         } else {
110             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
111         }
112     }
113 
114     /// @dev Returns the link of a node `_node` in direction `_direction`.
115     /// @param self stored linked list from contract
116     /// @param _node id of the node to step from
117     /// @param _direction direction to step in
118     function getAdjacent(LinkedList storage self, address _node, bool _direction)
119     internal view returns (bool, address)
120     {
121         if (!nodeExists(self,_node)) {
122             return (false,0x0);
123         } else {
124             return (true,self.list[_node][_direction]);
125         }
126     }
127 
128     /// @dev Can be used before `insert` to build an ordered list
129     /// @param self stored linked list from contract
130     /// @param _node an existing node to search from, e.g. HEAD.
131     /// @param _value value to seek
132     /// @param _direction direction to seek in
133     //  @return next first node beyond '_node' in direction `_direction`
134     function getSortedSpot(LinkedList storage self, address _node, address _value, bool _direction)
135     internal view returns (address)
136     {
137         if (sizeOf(self) == 0) { return 0x0; }
138         require((_node == 0x0) || nodeExists(self,_node));
139         bool exists;
140         address next;
141         (exists,next) = getAdjacent(self, _node, _direction);
142         while  ((next != 0x0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
143         return next;
144     }
145 
146     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
147     /// @param self stored linked list from contract
148     /// @param _node first node for linking
149     /// @param _link  node to link to in the _direction
150     function createLink(LinkedList storage self, address _node, address _link, bool _direction) internal  {
151         self.list[_link][!_direction] = _node;
152         self.list[_node][_direction] = _link;
153     }
154 
155     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
156     /// @param self stored linked list from contract
157     /// @param _node existing node
158     /// @param _new  new node to insert
159     /// @param _direction direction to insert node in
160     function insert(LinkedList storage self, address _node, address _new, bool _direction) internal returns (bool) {
161         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
162             address c = self.list[_node][_direction];
163             createLink(self, _node, _new, _direction);
164             createLink(self, _new, c, _direction);
165             return true;
166         } else {
167             return false;
168         }
169     }
170 
171     /// @dev removes an entry from the linked list
172     /// @param self stored linked list from contract
173     /// @param _node node to remove from the list
174     function remove(LinkedList storage self, address _node) internal returns (address) {
175         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0x0; }
176         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
177         delete self.list[_node][PREV];
178         delete self.list[_node][NEXT];
179         return _node;
180     }
181 
182     /// @dev pushes an enrty to the head of the linked list
183     /// @param self stored linked list from contract
184     /// @param _node new entry to push to the head
185     /// @param _direction push to the head (NEXT) or tail (PREV)
186     function push(LinkedList storage self, address _node, bool _direction) internal  {
187         insert(self, HEAD, _node, _direction);
188     }
189 
190     /// @dev pops the first entry from the linked list
191     /// @param self stored linked list from contract
192     /// @param _direction pop from the head (NEXT) or the tail (PREV)
193     function pop(LinkedList storage self, bool _direction) internal returns (address) {
194         bool exists;
195         address adj;
196 
197         (exists,adj) = getAdjacent(self, HEAD, _direction);
198 
199         return remove(self, adj);
200     }
201 }
202 
203 contract UmkaToken is ERC20 {
204     using SafeMath for uint256;
205     using RingList for RingList.LinkedList;
206 
207     address public owner;
208 
209     bool    public              paused         = false;
210     bool    public              contractEnable = true;
211 
212     uint256 private             summarySupply;
213 
214     string  public              name = "";
215     string  public              symbol = "";
216     uint8   public              decimals = 0;
217 
218     mapping(address => uint256)                      private   accounts;
219     mapping(address => string)                       private   umkaAddresses;
220     mapping(address => mapping (address => uint256)) private   allowed;
221     mapping(address => uint8)                        private   group;
222     mapping(bytes32 => uint256)                      private   distribution;
223 
224     RingList.LinkedList                              private   holders;
225 
226     struct groupPolicy {
227         uint8 _default;
228         uint8 _backend;
229         uint8 _admin;
230         uint8 _migration;
231         uint8 _subowner;
232         uint8 _owner;
233     }
234 
235     groupPolicy public currentState = groupPolicy(0, 3, 4, 9, 2, 9);
236 
237     event EvTokenAdd(uint256 _value, uint256 _lastSupply);
238     event EvTokenRm(uint256 _delta, uint256 _value, uint256 _lastSupply);
239     event EvGroupChanged(address _address, uint8 _oldgroup, uint8 _newgroup);
240     event EvMigration(address _address, uint256 _balance, uint256 _secret);
241     event Pause();
242     event Unpause();
243 
244     function UmkaToken(string _name, string _symbol, uint8 _decimals, uint256 _startTokens) public {
245         owner = msg.sender;
246 
247         group[owner] = currentState._owner;
248 
249         accounts[msg.sender]  = _startTokens;
250 
251         holders.push(msg.sender, true);
252         summarySupply    = _startTokens;
253         name = _name;
254         symbol = _symbol;
255         decimals = _decimals;
256     }
257 
258     modifier onlyPayloadSize(uint size) {
259         assert(msg.data.length >= size + 4);
260         _;
261     }
262 
263     modifier minGroup(int _require) {
264         require(group[msg.sender] >= _require);
265         _;
266     }
267 
268     modifier onlyGroup(int _require) {
269         require(group[msg.sender] == _require);
270         _;
271     }
272 
273     modifier whenNotPaused() {
274         require(!paused || group[msg.sender] >= currentState._backend);
275         _;
276     }
277 
278     modifier whenPaused() {
279         require(paused);
280         _;
281     }
282 
283     function servicePause() minGroup(currentState._admin) whenNotPaused public {
284         paused = true;
285         Pause();
286     }
287 
288     function serviceUnpause() minGroup(currentState._admin) whenPaused public {
289         paused = false;
290         Unpause();
291     }
292 
293     function serviceGroupChange(address _address, uint8 _group) minGroup(currentState._admin) external returns(uint8) {
294         require(_address != address(0));
295 
296         uint8 old = group[_address];
297         if(old <= currentState._admin) {
298             group[_address] = _group;
299             EvGroupChanged(_address, old, _group);
300         }
301         return group[_address];
302     }
303 
304     function serviceTransferOwnership(address newOwner) minGroup(currentState._owner) external {
305         require(newOwner != address(0));
306 
307         group[newOwner] = currentState._subowner;
308         group[msg.sender] = currentState._subowner;
309         EvGroupChanged(newOwner, currentState._owner, currentState._subowner);
310     }
311 
312     function serviceClaimOwnership() onlyGroup(currentState._subowner) external {
313         address temp = owner;
314         uint256 value = accounts[owner];
315 
316         accounts[owner] = accounts[owner].sub(value);
317         holders.remove(owner);
318         accounts[msg.sender] = accounts[msg.sender].add(value);
319         holders.push(msg.sender, true);
320 
321         owner = msg.sender;
322 
323         delete group[temp];
324         group[msg.sender] = currentState._owner;
325 
326         EvGroupChanged(msg.sender, currentState._subowner, currentState._owner);
327     }
328 
329     function serviceIncreaseBalance(address _who, uint256 _value) minGroup(currentState._admin) external returns(bool) {
330         require(_who != address(0));
331         require(_value > 0);
332 
333         accounts[_who] = accounts[_who].add(_value);
334         summarySupply = summarySupply.add(_value);
335         holders.push(_who, true);
336         EvTokenAdd(_value, summarySupply);
337         return true;
338     }
339 
340     function serviceDecreaseBalance(address _who, uint256 _value) minGroup(currentState._admin) external returns(bool) {
341         require(_who != address(0));
342         require(_value > 0);
343         require(accounts[_who] >= _value);
344 
345         accounts[_who] = accounts[_who].sub(_value);
346         summarySupply = summarySupply.sub(_value);
347         if(accounts[_who] == 0){
348             holders.remove(_who);
349         }
350         EvTokenRm(accounts[_who], _value, summarySupply);
351         return true;
352     }
353 
354     function serviceRedirect(address _from, address _to, uint256 _value) minGroup(currentState._admin) external returns(bool){
355         require(_from != address(0));
356         require(_to != address(0));
357         require(_value > 0);
358         require(accounts[_from] >= _value);
359         require(_from != _to);
360 
361         accounts[_from] = accounts[_from].sub(_value);
362         if(accounts[_from] == 0){
363             holders.remove(_from);
364         }
365         accounts[_to] = accounts[_to].add(_value);
366         holders.push(_to, true);
367 
368         return true;
369     }
370 
371     function serviceTokensBurn(address _address) external minGroup(currentState._admin) returns(uint256 balance) {
372         require(_address != address(0));
373         require(accounts[_address] > 0);
374 
375         uint256 sum = accounts[_address];
376         accounts[_address] = 0;
377         summarySupply = summarySupply.sub(sum);
378         holders.remove(_address);
379         return accounts[_address];
380     }
381 
382     function serviceTrasferToDist(bytes32 _to, uint256 _value) external minGroup(currentState._admin) {
383         require(_value > 0);
384         require(accounts[owner] >= _value);
385 
386         distribution[_to] = distribution[_to].add(_value);
387         accounts[owner] = accounts[owner].sub(_value);
388     }
389 
390     function serviceTrasferFromDist(bytes32 _from, address _to, uint256 _value) external minGroup(currentState._backend) {
391         require(_to != address(0));
392         require(_value > 0);
393         require(distribution[_from] >= _value);
394 
395         accounts[_to] = accounts[_to].add(_value);
396         holders.push(_to, true);
397         distribution[_from] = distribution[_from].sub(_value);
398     }
399 
400     function getGroup(address _check) external constant returns(uint8 _group) {
401         return group[_check];
402     }
403 
404     function getBalanceOfDist(bytes32 _of) external constant returns(uint256){
405         return distribution[_of];
406     }
407 
408     function getHoldersLength() external constant returns(uint256){
409         return holders.sizeOf();
410     }
411 
412     function getHolderLink(address _holder) external constant returns(bool, address, address){
413         return holders.getNode(_holder);
414     }
415 
416     function getUmkaAddress(address _who) external constant returns(string umkaAddress){
417         return umkaAddresses[_who];
418     }
419 
420     function setUmkaAddress(string _umka) minGroup(currentState._default) whenNotPaused external{
421         umkaAddresses[msg.sender] = _umka;
422     }
423 
424     function transfer(address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
425         require(_to != address(0));
426         require (accounts[msg.sender] >= _value);
427 
428         accounts[msg.sender] = accounts[msg.sender].sub(_value);
429         if(accounts[msg.sender] == 0){
430             holders.remove(msg.sender);
431         }
432         accounts[_to] = accounts[_to].add(_value);
433         holders.push(_to, true);
434         Transfer(msg.sender, _to, _value);
435 
436         return true;
437     }
438 
439     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
440         require(_to != address(0));
441         require(_from != address(0));
442         require(_value <= accounts[_from]);
443         require(_value <= allowed[_from][msg.sender]);
444 
445         accounts[_from] = accounts[_from].sub(_value);
446         if(accounts[_from] == 0){
447             holders.remove(_from);
448         }
449         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
450         accounts[_to] = accounts[_to].add(_value);
451         holders.push(_to, true);
452         Transfer(_from, _to, _value);
453         return true;
454     }
455 
456     function approve(address _spender, uint256 _old, uint256 _new) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
457         require (_old == allowed[msg.sender][_spender]);
458         require(_spender != address(0));
459 
460         allowed[msg.sender][_spender] = _new;
461         Approval(msg.sender, _spender, _new);
462         return true;
463     }
464 
465     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
466         return allowed[_owner][_spender];
467     }
468 
469     function balanceOf(address _owner) external constant returns (uint256 balance) {
470         if (_owner == address(0))
471             return accounts[msg.sender];
472         return accounts[_owner];
473     }
474 
475     function totalSupply() external constant returns (uint256 _totalSupply) {
476         _totalSupply = summarySupply;
477     }
478 
479     function destroy() minGroup(currentState._owner) external {
480         selfdestruct(msg.sender);
481     }
482 
483     function settingsSwitchState() external minGroup(currentState._owner) returns (bool state) {
484 
485         if(contractEnable) {
486             currentState._default = 9;
487             currentState._migration = 0;
488             contractEnable = false;
489         } else {
490             currentState._default = 0;
491             currentState._migration = 9;
492             contractEnable = true;
493         }
494 
495         return contractEnable;
496     }
497 
498     function userMigration(uint256 _secrect) external minGroup(currentState._migration) returns (bool successful) {
499         uint256 balance = accounts[msg.sender];
500 
501         require (balance > 0);
502 
503         accounts[msg.sender] = accounts[msg.sender].sub(balance);
504         holders.remove(msg.sender);
505         accounts[owner] = accounts[owner].add(balance);
506         holders.push(owner, true);
507         EvMigration(msg.sender, balance, _secrect);
508         return true;
509     }
510 }