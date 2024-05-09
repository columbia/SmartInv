1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
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
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipRenounced(address indexed previousOwner);
34     event OwnershipTransferred(
35         address indexed previousOwner,
36         address indexed newOwner
37     );
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function renounceOwnership() public onlyOwner {
49         emit OwnershipRenounced(owner);
50         owner = address(0);
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         _transferOwnership(_newOwner);
55     }
56 
57     function _transferOwnership(address _newOwner) internal {
58         require(_newOwner != address(0));
59         emit OwnershipTransferred(owner, _newOwner);
60         owner = _newOwner;
61     }
62 }
63 
64 contract Claimable is Ownable {
65     address public pendingOwner;
66 
67     modifier onlyPendingOwner() {
68         require(msg.sender == pendingOwner);
69         _;
70     }
71 
72     function transferOwnership(address newOwner) onlyOwner public {
73         pendingOwner = newOwner;
74     }
75 
76     function claimOwnership() onlyPendingOwner public {
77         emit OwnershipTransferred(owner, pendingOwner);
78         owner = pendingOwner;
79         pendingOwner = address(0);
80     }
81 }
82 
83 contract ERC20Basic {
84     function totalSupply() public view returns (uint256);
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91     function allowance(address owner, address spender) public view returns (uint256);
92     function transferFrom(address from, address to, uint256 value) public returns (bool);
93     function approve(address spender, uint256 value) public returns (bool);
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract BasicToken is ERC20Basic {
98     using SafeMath for uint256;
99     mapping(address => uint256) balances;
100     uint256 totalSupply_;
101 
102     function totalSupply() public view returns (uint256) {
103         return totalSupply_;
104     }
105 
106     function transfer(address _to, uint256 _value) public returns (bool) {
107         require(_value <= balances[msg.sender]);
108         require(_to != address(0));
109         balances[msg.sender] = balances[msg.sender].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         emit Transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     function balanceOf(address _owner) public view returns (uint256) {
116         return balances[_owner];
117     }
118 }
119 
120 contract StandardToken is ERC20, BasicToken {
121     mapping (address => mapping (address => uint256)) internal allowed;
122 
123     function transferFrom(
124         address _from,
125         address _to,
126         uint256 _value
127     )
128     public
129     returns (bool)
130     {
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133         require(_to != address(0));
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         emit Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     function allowance(
148         address _owner,
149         address _spender
150     )
151     public
152     view
153     returns (uint256)
154     {
155         return allowed[_owner][_spender];
156     }
157 
158     function increaseApproval(
159         address _spender,
160         uint256 _addedValue
161     )
162     public
163     returns (bool)
164     {
165         allowed[msg.sender][_spender] = (
166         allowed[msg.sender][_spender].add(_addedValue));
167         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168         return true;
169     }
170 
171     function decreaseApproval(
172         address _spender,
173         uint256 _subtractedValue
174     )
175     public
176     returns (bool)
177     {
178         uint256 oldValue = allowed[msg.sender][_spender];
179         if (_subtractedValue >= oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 }
188 
189 library SafeERC20 {
190     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
191         require(token.transfer(to, value));
192     }
193     function safeTransferFrom(
194         ERC20 token,
195         address from,
196         address to,
197         uint256 value
198     )
199     internal
200     {
201         require(token.transferFrom(from, to, value));
202     }
203     function safeApprove(ERC20 token, address spender, uint256 value) internal {
204         require(token.approve(spender, value));
205     }
206 }
207 
208 contract CanReclaimToken is Ownable {
209     using SafeERC20 for ERC20Basic;
210 
211     function reclaimToken(ERC20Basic token) external onlyOwner {
212         uint256 balance = token.balanceOf(this);
213         token.safeTransfer(owner, balance);
214     }
215 }
216 
217 contract BurnableToken is BasicToken {
218     event Burn(address indexed burner, uint256 value);
219 
220     function burn(uint256 _value) public {
221         _burn(msg.sender, _value);
222     }
223     function _burn(address _who, uint256 _value) internal {
224         require(_value <= balances[_who]);
225 
226 
227         balances[_who] = balances[_who].sub(_value);
228         totalSupply_ = totalSupply_.sub(_value);
229         emit Burn(_who, _value);
230         emit Transfer(_who, address(0), _value);
231     }
232 }
233 
234 library Roles {
235     struct Role {
236         mapping (address => bool) bearer;
237     }
238 
239     function add(Role storage role, address addr)
240     internal
241     {
242         role.bearer[addr] = true;
243     }
244 
245     function remove(Role storage role, address addr)
246     internal
247     {
248         role.bearer[addr] = false;
249     }
250 
251     function check(Role storage role, address addr)
252     view
253     internal
254     {
255         require(has(role, addr));
256     }
257 
258     function has(Role storage role, address addr)
259     view
260     internal
261     returns (bool)
262     {
263         return role.bearer[addr];
264     }
265 }
266 
267 contract RBAC {
268     using Roles for Roles.Role;
269     mapping (string => Roles.Role) private roles;
270     event RoleAdded(address indexed operator, string role);
271     event RoleRemoved(address indexed operator, string role);
272 
273     function checkRole(address _operator, string _role)
274     view
275     public
276     {
277         roles[_role].check(_operator);
278     }
279 
280     function hasRole(address _operator, string _role)
281     view
282     public
283     returns (bool)
284     {
285         return roles[_role].has(_operator);
286     }
287 
288     function addRole(address _operator, string _role)
289     internal
290     {
291         roles[_role].add(_operator);
292         emit RoleAdded(_operator, _role);
293     }
294 
295     function removeRole(address _operator, string _role)
296     internal
297     {
298         roles[_role].remove(_operator);
299         emit RoleRemoved(_operator, _role);
300     }
301 
302     modifier onlyRole(string _role)
303     {
304         checkRole(msg.sender, _role);
305         _;
306     }
307 }
308 
309 contract Whitelist is Ownable, RBAC {
310     string public constant ROLE_WHITELISTED = "whitelist";
311 
312     modifier onlyIfWhitelisted(address _operator) {
313         checkRole(_operator, ROLE_WHITELISTED);
314         _;
315     }
316 
317     function addAddressToWhitelist(address _operator)
318     onlyOwner
319     public
320     {
321         addRole(_operator, ROLE_WHITELISTED);
322     }
323 
324     function whitelist(address _operator)
325     public
326     view
327     returns (bool)
328     {
329         return hasRole(_operator, ROLE_WHITELISTED);
330     }
331 
332     function addAddressesToWhitelist(address[] _operators)
333     onlyOwner
334     public
335     {
336         for (uint256 i = 0; i < _operators.length; i++) {
337             addAddressToWhitelist(_operators[i]);
338         }
339     }
340 
341     function removeAddressFromWhitelist(address _operator)
342     onlyOwner
343     public
344     {
345         removeRole(_operator, ROLE_WHITELISTED);
346     }
347 
348     function removeAddressesFromWhitelist(address[] _operators)
349     onlyOwner
350     public
351     {
352         for (uint256 i = 0; i < _operators.length; i++) {
353             removeAddressFromWhitelist(_operators[i]);
354         }
355     }
356 }
357 
358 contract DateKernel
359 {
360     uint256 public unlockTime;
361     constructor(uint256 _time) public {
362         unlockTime = _time;
363     }
364 
365     function determineDate() internal view
366     returns (uint256 v)
367     {
368         uint256 n = now;
369         uint256 ut = unlockTime;
370         uint256 mo = 30 * 1 days;
371         uint8 p = 10;
372         assembly {
373             if sgt(n, ut) {
374                 if or(slt(sub(n, ut), mo), eq(sub(n, ut), mo)) {
375                     v := 1
376                 }
377                 if sgt(sub(n, ut), mo) {
378                     v := add(div(sub(n, ut), mo), 1)
379                 }
380                 if or(eq(v, p), sgt(v, p)) {
381                     v := p
382                 }
383             }
384         }
385     }
386 }
387 
388 contract Distributable is StandardToken, Ownable, Whitelist, DateKernel {
389     using SafeMath for uint;
390     event Distributed(uint256 amount);
391     event MemberUpdated(address member, uint256 balance);
392     struct member {
393         uint256 lastWithdrawal;
394         uint256 tokensTotal;
395         uint256 tokensLeft;
396     }
397 
398     mapping (address => member) public teams;
399 
400     function _transfer(address _from, address _to, uint256 _value) private returns (bool) {
401         require(_value <= balances[_from]);
402         require(_to != address(0));
403         balances[_from] = balances[_from].sub(_value);
404         balances[_to] = balances[_to].add(_value);
405         emit Transfer(_from, _to, _value);
406         return true;
407     }
408 
409     function updateMember(address _who, uint256 _last, uint256 _total, uint256 _left) internal returns (bool) {
410         teams[_who] = member(_last, _total, _left);
411         emit MemberUpdated(_who, _left);
412         return true;
413     }
414     
415     function airdrop(address[] dests, uint256[] values) public onlyOwner {
416         // This simple validation will catch most mistakes without consuming
417         // too much gas.
418         require(dests.length == values.length);
419 
420         for (uint256 i = 0; i < dests.length; i++) {
421             transfer(dests[i], values[i]);
422         }
423     }
424 
425     function distributeTokens(address[] _member, uint256[] _amount)
426     onlyOwner
427     public
428     returns (bool)
429     {
430         require(_member.length == _amount.length);
431         for (uint256 i = 0; i < _member.length; i++) {
432             updateMember(_member[i], 0, _amount[i], _amount[i]);
433             addAddressToWhitelist(_member[i]);
434         }
435         emit Distributed(_member.length);
436         return true;
437     }
438 
439     function rewardController(address _member)
440     internal
441     returns (uint256)
442     {
443         member storage mbr = teams[_member];
444         require(mbr.tokensLeft > 0, "You've spent your share");
445         uint256 multiplier;
446         uint256 callback;
447         uint256 curDate = determineDate();
448         uint256 lastDate = mbr.lastWithdrawal;
449         if(curDate > lastDate) {
450             multiplier = curDate.sub(lastDate);
451         } else if(curDate == lastDate) {
452             revert("Its no time");
453         }
454         if(mbr.tokensTotal >= mbr.tokensLeft && mbr.tokensTotal > 0) {
455             if(curDate == 10) {
456                 callback = mbr.tokensLeft;
457             } else {
458                 callback = multiplier.mul((mbr.tokensTotal).div(10));
459             }
460         }
461         updateMember(
462             _member,
463             curDate,
464             mbr.tokensTotal,
465             mbr.tokensLeft.sub(callback)
466         );
467         return callback;
468     }
469 
470     function getDistributedToken()
471     public
472     onlyIfWhitelisted(msg.sender)
473     returns(bool)
474     {
475         require(unlockTime > now);
476         uint256 amount = rewardController(msg.sender);
477         _transfer(this, msg.sender, amount);
478         return true;
479     }
480 }
481 
482 contract TutorNinjaToken is Distributable, BurnableToken, CanReclaimToken, Claimable {
483     string public name;
484     string public symbol;
485     uint8 public decimals;
486     uint256 public INITIAL_SUPPLY = 33e6 * (10 ** uint256(decimals));
487 
488     constructor()
489     public
490     DateKernel(1541030400)
491     {
492         name = "Tutor Ninja";
493         symbol = "NTOK";
494         decimals = 10;
495         totalSupply_ = INITIAL_SUPPLY;
496         balances[msg.sender] = INITIAL_SUPPLY;
497         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
498     }
499 
500     function() external {
501         revert("Does not accept ether");
502     }
503 }