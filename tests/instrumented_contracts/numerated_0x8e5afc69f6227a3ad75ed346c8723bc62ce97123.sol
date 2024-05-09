1 pragma solidity ^0.4.23;
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
40     constructor () internal {
41     }
42 }
43 
44 library RingList {
45 
46     address constant NULL = 0x0;
47     address constant HEAD = 0x0;
48     bool constant PREV = false;
49     bool constant NEXT = true;
50 
51     struct LinkedList{
52         mapping (address => mapping (bool => address)) list;
53     }
54 
55     /// @dev returns true if the list exists
56     /// @param self stored linked list from contract
57     function listExists(LinkedList storage self)
58     internal
59     view returns (bool)
60     {
61         // if the head nodes previous or next pointers both point to itself, then there are no items in the list
62         if (self.list[HEAD][PREV] != HEAD || self.list[HEAD][NEXT] != HEAD) {
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     /// @dev returns true if the node exists
70     /// @param self stored linked list from contract
71     /// @param _node a node to search for
72     function nodeExists(LinkedList storage self, address _node)
73     internal
74     view returns (bool)
75     {
76         if (self.list[_node][PREV] == HEAD && self.list[_node][NEXT] == HEAD) {
77             if (self.list[HEAD][NEXT] == _node) {
78                 return true;
79             } else {
80                 return false;
81             }
82         } else {
83             return true;
84         }
85     }
86 
87     /// @dev Returns the number of elements in the list
88     /// @param self stored linked list from contract
89     function sizeOf(LinkedList storage self) internal view returns (uint256 numElements) {
90         bool exists;
91         address i;
92         (exists,i) = getAdjacent(self, HEAD, NEXT);
93         while (i != HEAD) {
94             (exists,i) = getAdjacent(self, i, NEXT);
95             numElements++;
96         }
97         return;
98     }
99 
100     /// @dev Returns the links of a node as a tuple
101     /// @param self stored linked list from contract
102     /// @param _node id of the node to get
103     function getNode(LinkedList storage self, address _node)
104     internal view returns (bool, address, address)
105     {
106         if (!nodeExists(self,_node)) {
107             return (false,0x0,0x0);
108         } else {
109             return (true,self.list[_node][PREV], self.list[_node][NEXT]);
110         }
111     }
112 
113     /// @dev Returns the link of a node `_node` in direction `_direction`.
114     /// @param self stored linked list from contract
115     /// @param _node id of the node to step from
116     /// @param _direction direction to step in
117     function getAdjacent(LinkedList storage self, address _node, bool _direction)
118     internal view returns (bool, address)
119     {
120         if (!nodeExists(self,_node)) {
121             return (false,0x0);
122         } else {
123             return (true,self.list[_node][_direction]);
124         }
125     }
126 
127     /// @dev Can be used before `insert` to build an ordered list
128     /// @param self stored linked list from contract
129     /// @param _node an existing node to search from, e.g. HEAD.
130     /// @param _value value to seek
131     /// @param _direction direction to seek in
132     //  @return next first node beyond '_node' in direction `_direction`
133     function getSortedSpot(LinkedList storage self, address _node, address _value, bool _direction)
134     internal view returns (address)
135     {
136         if (sizeOf(self) == 0) { return 0x0; }
137         require((_node == 0x0) || nodeExists(self,_node));
138         bool exists;
139         address next;
140         (exists,next) = getAdjacent(self, _node, _direction);
141         while  ((next != 0x0) && (_value != next) && ((_value < next) != _direction)) next = self.list[next][_direction];
142         return next;
143     }
144 
145     /// @dev Creates a bidirectional link between two nodes on direction `_direction`
146     /// @param self stored linked list from contract
147     /// @param _node first node for linking
148     /// @param _link  node to link to in the _direction
149     function createLink(LinkedList storage self, address _node, address _link, bool _direction) internal  {
150         self.list[_link][!_direction] = _node;
151         self.list[_node][_direction] = _link;
152     }
153 
154     /// @dev Insert node `_new` beside existing node `_node` in direction `_direction`.
155     /// @param self stored linked list from contract
156     /// @param _node existing node
157     /// @param _new  new node to insert
158     /// @param _direction direction to insert node in
159     function insert(LinkedList storage self, address _node, address _new, bool _direction) internal returns (bool) {
160         if(!nodeExists(self,_new) && nodeExists(self,_node)) {
161             address c = self.list[_node][_direction];
162             createLink(self, _node, _new, _direction);
163             createLink(self, _new, c, _direction);
164             return true;
165         } else {
166             return false;
167         }
168     }
169 
170     /// @dev removes an entry from the linked list
171     /// @param self stored linked list from contract
172     /// @param _node node to remove from the list
173     function remove(LinkedList storage self, address _node) internal returns (address) {
174         if ((_node == NULL) || (!nodeExists(self,_node))) { return 0x0; }
175         createLink(self, self.list[_node][PREV], self.list[_node][NEXT], NEXT);
176         delete self.list[_node][PREV];
177         delete self.list[_node][NEXT];
178         return _node;
179     }
180 
181     /// @dev pushes an enrty to the head of the linked list
182     /// @param self stored linked list from contract
183     /// @param _node new entry to push to the head
184     /// @param _direction push to the head (NEXT) or tail (PREV)
185     function push(LinkedList storage self, address _node, bool _direction) internal  {
186         insert(self, HEAD, _node, _direction);
187     }
188 
189     /// @dev pops the first entry from the linked list
190     /// @param self stored linked list from contract
191     /// @param _direction pop from the head (NEXT) or the tail (PREV)
192     function pop(LinkedList storage self, bool _direction) internal returns (address) {
193         bool exists;
194         address adj;
195 
196         (exists,adj) = getAdjacent(self, HEAD, _direction);
197 
198         return remove(self, adj);
199     }
200 }
201 
202 contract UmkaToken is ERC20 {
203     using SafeMath for uint256;
204     using RingList for RingList.LinkedList;
205 
206     address public owner;
207 
208     bool    public              paused         = false;
209     bool    public              contractEnable = true;
210 
211     uint256 private             summarySupply;
212 
213     string  public              name = "";
214     string  public              symbol = "";
215     uint8   public              decimals = 0;
216 
217     mapping(address => uint256)                      private   accounts;
218     mapping(address => string)                       private   umkaAddresses;
219     mapping(address => mapping (address => uint256)) private   allowed;
220     mapping(address => uint8)                        private   group;
221     mapping(bytes32 => uint256)                      private   distribution;
222 
223     RingList.LinkedList                              private   holders;
224 
225     struct groupPolicy {
226         uint8 _default;
227         uint8 _backend;
228         uint8 _admin;
229         uint8 _migration;
230         uint8 _subowner;
231         uint8 _owner;
232     }
233 
234     groupPolicy public currentState = groupPolicy(0, 3, 4, 9, 2, 9);
235 
236     event EvGroupChanged(address _address, uint8 _oldgroup, uint8 _newgroup);
237     event EvMigration(address _address, uint256 _balance, uint256 _secret);
238     event Pause();
239     event Unpause();
240 
241     constructor (string _name, string _symbol, uint8 _decimals, uint256 _startTokens) public {
242         owner = msg.sender;
243 
244         group[owner] = currentState._owner;
245 
246         accounts[msg.sender]  = _startTokens;
247 
248         holders.push(msg.sender, true);
249         summarySupply    = _startTokens;
250         name = _name;
251         symbol = _symbol;
252         decimals = _decimals;
253         emit Transfer(address(0x0), msg.sender, _startTokens);
254     }
255 
256     modifier onlyPayloadSize(uint size) {
257         assert(msg.data.length >= size + 4);
258         _;
259     }
260 
261     modifier minGroup(int _require) {
262         require(group[msg.sender] >= _require);
263         _;
264     }
265 
266     modifier onlyGroup(int _require) {
267         require(group[msg.sender] == _require);
268         _;
269     }
270 
271     modifier whenNotPaused() {
272         require(!paused || group[msg.sender] >= currentState._backend);
273         _;
274     }
275 
276     modifier whenPaused() {
277         require(paused);
278         _;
279     }
280 
281     function servicePause() minGroup(currentState._admin) whenNotPaused public {
282         paused = true;
283         emit Pause();
284     }
285 
286     function serviceUnpause() minGroup(currentState._admin) whenPaused public {
287         paused = false;
288         emit Unpause();
289     }
290 
291     function serviceGroupChange(address _address, uint8 _group) minGroup(currentState._admin) external returns(uint8) {
292         require(_address != address(0));
293 
294         uint8 old = group[_address];
295         if(old <= currentState._admin) {
296             group[_address] = _group;
297             emit EvGroupChanged(_address, old, _group);
298         }
299         return group[_address];
300     }
301 
302     function serviceTransferOwnership(address newOwner) minGroup(currentState._owner) external {
303         require(newOwner != address(0));
304 
305         group[newOwner] = currentState._subowner;
306         group[msg.sender] = currentState._subowner;
307         emit EvGroupChanged(newOwner, currentState._owner, currentState._subowner);
308     }
309 
310     function serviceClaimOwnership() onlyGroup(currentState._subowner) external {
311         address temp = owner;
312         uint256 value = accounts[owner];
313 
314         accounts[owner] = accounts[owner].sub(value);
315         holders.remove(owner);
316         accounts[msg.sender] = accounts[msg.sender].add(value);
317         holders.push(msg.sender, true);
318 
319         owner = msg.sender;
320 
321         delete group[temp];
322         group[msg.sender] = currentState._owner;
323 
324         emit EvGroupChanged(msg.sender, currentState._subowner, currentState._owner);
325         emit Transfer(temp, owner, value);
326     }
327 
328     function serviceIncreaseBalance(address _who, uint256 _value) minGroup(currentState._admin) external returns(bool) {
329         require(_who != address(0));
330         require(_value > 0);
331 
332         accounts[_who] = accounts[_who].add(_value);
333         summarySupply = summarySupply.add(_value);
334         holders.push(_who, true);
335         emit Transfer(address(0), _who, _value);
336         return true;
337     }
338 
339     function serviceDecreaseBalance(address _who, uint256 _value) minGroup(currentState._admin) external returns(bool) {
340         require(_who != address(0));
341         require(_value > 0);
342         require(accounts[_who] >= _value);
343 
344         accounts[_who] = accounts[_who].sub(_value);
345         summarySupply = summarySupply.sub(_value);
346         if(accounts[_who] == 0){
347             holders.remove(_who);
348         }
349         emit Transfer(_who, address(0), _value);
350         return true;
351     }
352 
353     function serviceRedirect(address _from, address _to, uint256 _value) minGroup(currentState._admin) external returns(bool){
354         require(_from != address(0));
355         require(_to != address(0));
356         require(_value > 0);
357         require(accounts[_from] >= _value);
358         require(_from != _to);
359 
360         accounts[_from] = accounts[_from].sub(_value);
361         if(accounts[_from] == 0){
362             holders.remove(_from);
363         }
364         accounts[_to] = accounts[_to].add(_value);
365         holders.push(_to, true);
366         emit Transfer(_from, _to, _value);
367         return true;
368     }
369 
370     function serviceTokensBurn(address _address) external minGroup(currentState._admin) returns(uint256 balance) {
371         require(_address != address(0));
372         require(accounts[_address] > 0);
373 
374         uint256 sum = accounts[_address];
375         accounts[_address] = 0;
376         summarySupply = summarySupply.sub(sum);
377         holders.remove(_address);
378         emit Transfer(_address, address(0), sum);
379         return accounts[_address];
380     }
381 
382     function serviceTrasferToDist(bytes32 _to, uint256 _value) external minGroup(currentState._admin) {
383         require(_value > 0);
384         require(accounts[owner] >= _value);
385 
386         distribution[_to] = distribution[_to].add(_value);
387         accounts[owner] = accounts[owner].sub(_value);
388         emit Transfer(owner, address(0), _value);
389     }
390 
391     function serviceTrasferFromDist(bytes32 _from, address _to, uint256 _value) external minGroup(currentState._backend) {
392         require(_to != address(0));
393         require(_value > 0);
394         require(distribution[_from] >= _value);
395 
396         accounts[_to] = accounts[_to].add(_value);
397         holders.push(_to, true);
398         distribution[_from] = distribution[_from].sub(_value);
399         emit Transfer(address(0), _to, _value);
400     }
401 
402     function getGroup(address _check) external constant returns(uint8 _group) {
403         return group[_check];
404     }
405 
406     function getBalanceOfDist(bytes32 _of) external constant returns(uint256){
407         return distribution[_of];
408     }
409 
410     function getHoldersLength() external constant returns(uint256){
411         return holders.sizeOf();
412     }
413 
414     function getHolderLink(address _holder) external constant returns(bool, address, address){
415         return holders.getNode(_holder);
416     }
417 
418     function getUmkaAddress(address _who) external constant returns(string umkaAddress){
419         return umkaAddresses[_who];
420     }
421 
422     function setUmkaAddress(string _umka) minGroup(currentState._default) whenNotPaused external{
423         umkaAddresses[msg.sender] = _umka;
424     }
425 
426     function transfer(address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
427         require(_to != address(0));
428         require (accounts[msg.sender] >= _value);
429 
430         accounts[msg.sender] = accounts[msg.sender].sub(_value);
431         if(accounts[msg.sender] == 0){
432             holders.remove(msg.sender);
433         }
434         accounts[_to] = accounts[_to].add(_value);
435         holders.push(_to, true);
436         emit Transfer(msg.sender, _to, _value);
437 
438         return true;
439     }
440 
441     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
442         require(_to != address(0));
443         require(_from != address(0));
444         require(_value <= accounts[_from]);
445         require(_value <= allowed[_from][msg.sender]);
446 
447         accounts[_from] = accounts[_from].sub(_value);
448         if(accounts[_from] == 0){
449             holders.remove(_from);
450         }
451         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
452         accounts[_to] = accounts[_to].add(_value);
453         holders.push(_to, true);
454         emit Transfer(_from, _to, _value);
455         return true;
456     }
457 
458     function approve(address _spender, uint256 _old, uint256 _new) onlyPayloadSize(64) minGroup(currentState._default) whenNotPaused external returns (bool success) {
459         require (_old == allowed[msg.sender][_spender]);
460         require(_spender != address(0));
461 
462         allowed[msg.sender][_spender] = _new;
463         emit Approval(msg.sender, _spender, _new);
464         return true;
465     }
466 
467     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
468         return allowed[_owner][_spender];
469     }
470 
471     function balanceOf(address _owner) external constant returns (uint256 balance) {
472         if (_owner == address(0))
473             return accounts[msg.sender];
474         return accounts[_owner];
475     }
476 
477     function totalSupply() external constant returns (uint256 _totalSupply) {
478         _totalSupply = summarySupply;
479     }
480 
481     function destroy() minGroup(currentState._owner) external {
482         selfdestruct(msg.sender);
483     }
484 
485     function settingsSwitchState() external minGroup(currentState._owner) returns (bool state) {
486 
487         if(contractEnable) {
488             currentState._default = 9;
489             currentState._migration = 0;
490             contractEnable = false;
491         } else {
492             currentState._default = 0;
493             currentState._migration = 9;
494             contractEnable = true;
495         }
496 
497         return contractEnable;
498     }
499 
500     function userMigration(uint256 _secrect) external minGroup(currentState._migration) returns (bool successful) {
501         uint256 balance = accounts[msg.sender];
502 
503         require (balance > 0);
504 
505         accounts[msg.sender] = accounts[msg.sender].sub(balance);
506         holders.remove(msg.sender);
507         accounts[owner] = accounts[owner].add(balance);
508         holders.push(owner, true);
509         emit EvMigration(msg.sender, balance, _secrect);
510         emit Transfer(msg.sender, owner, balance);
511         return true;
512     }
513 }