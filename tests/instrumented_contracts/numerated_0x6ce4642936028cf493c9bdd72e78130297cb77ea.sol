1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8 
9         uint256 c = a * b;
10         assert(c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         // uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19 
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25 
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32 
33         return c;
34     }
35 }
36 contract ERC20Basic {
37     function totalSupply() public view returns (uint256);
38     function balanceOf(address who) public view returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) public view returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) balances;
54     uint256 totalSupply_;
55 
56     function totalSupply() public view returns (uint256) {
57         return totalSupply_;
58     }
59 
60     function transfer(address _to, uint256 _value) public returns (bool) {
61         require(_to != address(0));
62         require(_value <= balances[msg.sender]);
63 
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66 
67         emit Transfer(msg.sender, _to, _value);
68 
69         return true;
70     }
71 
72     function balanceOf(address _owner) public view returns (uint256) {
73         return balances[_owner];
74     }
75 }
76 contract StandardToken is ERC20, BasicToken {
77     mapping(address => mapping (address => uint256)) internal allowed;
78 
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80         require(_to != address(0));
81         require(_value <= balances[_from]);
82         require(_value <= allowed[_from][msg.sender]);
83 
84         balances[_from] = balances[_from].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87 
88         emit Transfer(_from, _to, _value);
89 
90         return true;
91     }
92 
93     function approve(address _spender, uint256 _value) public returns (bool) {
94         allowed[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96 
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) public view returns (uint256) {
101         return allowed[_owner][_spender];
102     }
103 
104     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106 
107         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108 
109         return true;
110     }
111 
112     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113         uint oldValue = allowed[msg.sender][_spender];
114 
115         if (_subtractedValue > oldValue) {
116             allowed[msg.sender][_spender] = 0;
117         } else {
118             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
119         }
120 
121         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122 
123         return true;
124     }
125 }
126 
127 
128 
129 contract Ownable {
130     address public owner;
131     address public ownerCandidate;
132     address[4] public admins;
133     uint256 public ownershipTransferCounter;
134 
135     constructor(address _owner, address[4] _admins) public {
136         owner = _owner;
137         admins[0] = _admins[0];
138         admins[1] = _admins[1];
139         admins[2] = _admins[2];
140         admins[3] = _admins[3];
141     }
142 
143     function changeAdmin(address _oldAdmin, address _newAdmin, bytes32[3] _rs, bytes32[3] _ss, uint8[3] _vs) external returns (bool) {
144         bytes32 prefixedMessage = prefixedHash(transferAdminMessage(_oldAdmin, _newAdmin));
145         address[3] memory signers;
146 
147         for (uint8 i = 0; i < 3; i++) {
148             signers[i] = ecrecover(prefixedMessage, _vs[i], _rs[i], _ss[i]);
149         }
150 
151         require (isQuorum(signers));
152 
153         return replaceAdmin(_oldAdmin, _newAdmin);
154     }
155 
156     function transferOwnership(address _newOwner, bytes32[3] _rs, bytes32[3] _ss, uint8[3] _vs) external returns (bool) {
157         bytes32 prefixedMessage = prefixedHash(transferOwnershipMessage(_newOwner));
158         address[3] memory signers;
159 
160         for (uint8 i = 0; i < 3; i++) {
161             signers[i] = ecrecover(prefixedMessage, _vs[i], _rs[i], _ss[i]);
162         }
163 
164         require (isQuorum(signers));
165 
166         ownerCandidate = _newOwner;
167         ownershipTransferCounter += 1;
168 
169         return true;
170     }
171 
172     function confirmOwnership() external returns (bool) {
173         require (msg.sender == ownerCandidate);
174 
175         owner = ownerCandidate;
176 
177         return true;
178     }
179 
180     function transferOwnershipMessage(address _candidate) public view returns (bytes32) {
181         return keccak256(address(this), _candidate, ownershipTransferCounter);
182     }
183 
184     function transferAdminMessage(address _oldAdmin, address _newAdmin) public view returns (bytes32) {
185         return keccak256(address(this), _oldAdmin, _newAdmin);
186     }
187 
188     modifier onlyOwner() {
189         require(msg.sender == owner);
190         _;
191     }
192 
193     function prefixedHash(bytes32 hash) pure public returns (bytes32) {
194         return keccak256("\x19Ethereum Signed Message:\n32", hash);
195     }
196 
197     function replaceAdmin (address _old, address _new) internal returns (bool) {
198         require (_new != address(0));
199         require (!isAdmin(_new));
200 
201         for (uint8 i = 0; i < admins.length; i++) {
202             if (admins[i] == _old) {
203                 admins[i] = _new;
204 
205                 return true;
206             }
207         }
208 
209         require (false);
210     }
211 
212     function isAdmin (address _a) public view returns (bool) {
213         for (uint8 i = 0; i < admins.length; i++) {
214             if (admins[i] == _a) {
215                 return true;
216             }
217         }
218 
219         return false;
220     }
221 
222     function isQuorum(address[3] signers) public view returns (bool) {
223         if (signers[0] == signers[1] || signers[0] == signers[2] || signers[1] == signers[2])
224         {
225             return false;
226         }
227 
228         for (uint8 i = 0; i < signers.length; i++) {
229             if (signers[i] == address(0)) {
230                 return false;
231             }
232 
233             if (!isAdmin(signers[i])) {
234                 return false;
235             }
236         }
237 
238         return true;
239     }
240 }
241 contract OwnedToken is StandardToken, Ownable {
242     constructor (address _owner, address[4] _admins) public Ownable(_owner, _admins) {
243     }
244 
245     function confirmOwnership () external returns (bool) {
246         require (msg.sender == ownerCandidate);
247 
248         balances[ownerCandidate] += balances[owner];
249 
250         delete balances[owner];
251 
252         owner = ownerCandidate;
253 
254         return true;
255     }
256 }
257 
258 contract Pausable is Ownable {
259     event Pause();
260     event Unpause();
261 
262     bool public paused = false;
263 
264     modifier whenNotPaused() {
265         require(!paused);
266         _;
267     }
268 
269     modifier whenPaused() {
270         require(paused);
271         _;
272     }
273 
274     function pause() onlyOwner whenNotPaused public {
275         paused = true;
276         emit Pause();
277     }
278 
279     function unpause() onlyOwner whenPaused public {
280         paused = false;
281         emit Unpause();
282     }
283 }
284 
285 contract PausableToken is StandardToken, Pausable {
286     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
287         return super.transfer(_to, _value);
288     }
289 
290     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
291         return super.transferFrom(_from, _to, _value);
292     }
293 
294     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
295         return super.approve(_spender, _value);
296     }
297 
298     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
299         return super.increaseApproval(_spender, _addedValue);
300     }
301 
302     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
303         return super.decreaseApproval(_spender, _subtractedValue);
304     }
305 }
306 
307 contract CollectableToken is PausableToken {
308     mapping(address => uint256) nextNonce;
309 
310     event Collected(address indexed from, address indexed to, address indexed collector, uint256 value);
311 
312     function collectMessage(address _from, address _to, uint256 _value) public view returns (bytes32) {
313         return keccak256(address(this), _from, _to, _value, nextNonce[_from]);
314     }
315 
316     function isCollectSignatureCorrect(address _from, address _to, uint256 _value, bytes32 _r, bytes32 _s, uint8 _v) public view returns (bool) {
317         return _from == ecrecover(
318             prefixedHash(collectMessage(_from, _to, _value)),
319             _v, _r, _s
320         );
321     }
322 
323     function collect(address _from, address _to, uint256 _value, bytes32 _r, bytes32 _s, uint8 _v) public whenNotPaused returns (bool success) {
324         require (_value > 0);
325         require (_from != _to);
326         require (_to != address(0));
327         require (isCollectSignatureCorrect(_from, _to, _value, _r, _s, _v));
328 
329         nextNonce[_from] += 1;
330         balances[_from] = balances[_from].sub(_value);
331         balances[_to] = balances[_to].add(_value);
332 
333         emit Transfer(_from, _to, _value);
334         emit Collected(_from, _to, msg.sender, _value);
335 
336         return true;
337     }
338 }
339 contract BixtrimToken is CollectableToken, OwnedToken {
340     string public constant name = "BixtrimToken";
341     string public constant symbol = "BXM";
342     uint256 public constant decimals = 0;
343 
344     constructor (uint256 _total, address _owner, address[4] _admins) public OwnedToken(_owner, _admins) {
345         totalSupply_ = _total;
346         balances[_owner] = _total;
347     }
348 }