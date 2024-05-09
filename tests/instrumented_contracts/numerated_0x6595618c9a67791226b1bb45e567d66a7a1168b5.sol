1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34     address public newOwner;
35 
36     event OwnershipTransferred(
37         address indexed previousOwner,
38         address indexed newOwner
39     );
40 
41     constructor() public {
42         owner = msg.sender;
43         newOwner = address(0);
44     }
45 
46     modifier onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50     modifier onlyNewOwner() {
51         require(msg.sender != address(0));
52         require(msg.sender == newOwner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         require(_newOwner != address(0));
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public onlyNewOwner returns (bool) {
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 contract Pausable is Ownable {
69     event Pause();
70     event Unpause();
71 
72     bool public paused = false;
73 
74     modifier whenNotPaused() {
75         require(!paused);
76         _;
77     }
78 
79     modifier whenPaused() {
80         require(paused);
81         _;
82     }
83 
84     function pause() public onlyOwner whenNotPaused {
85         paused = true;
86         emit Pause();
87     }
88 
89     function unpause() public onlyOwner whenPaused {
90         paused = false;
91         emit Unpause();
92     }
93 }
94 
95 contract ERC20 {
96     function totalSupply() public view returns (uint256);
97 
98     function balanceOf(address who) public view returns (uint256);
99 
100     function allowance(address owner, address spender)
101         public
102         view
103         returns (uint256);
104 
105     function transfer(address to, uint256 value) public returns (bool);
106 
107     function transferFrom(
108         address from,
109         address to,
110         uint256 value
111     ) public returns (bool);
112 
113     function approve(address spender, uint256 value) public returns (bool);
114 
115     event Approval(
116         address indexed owner,
117         address indexed spender,
118         uint256 value
119     );
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 }
122 
123 contract VTO is ERC20, Ownable, Pausable {
124     using SafeMath for uint256;
125 
126     string public name;
127     string public symbol;
128     uint8 public constant decimals = 18;
129     uint256 internal initialSupply;
130     uint256 internal totalSupply_;
131     uint256 internal mintCap;
132 
133     mapping(address => uint256) internal balances;
134     mapping(address => bool) public frozen;
135     mapping(address => mapping(address => uint256)) internal allowed;
136 
137     address implementation;
138 
139     event Burn(address indexed owner, uint256 value);
140     event Mint(uint256 value);
141     event Freeze(address indexed holder);
142     event Unfreeze(address indexed holder);
143 
144     modifier notFrozen(address _holder) {
145         require(!frozen[_holder]);
146         _;
147     }
148 
149     constructor() public {
150         name = "VictoryTournament";
151         symbol = "VTO";
152         initialSupply = 100000000; 
153         totalSupply_ = initialSupply * 10**uint256(decimals);
154         mintCap = 100000000 * 10**uint256(decimals); //100,000,000
155         balances[owner] = totalSupply_;
156 
157         emit Transfer(address(0), owner, totalSupply_);
158     }
159 
160     function() external payable {
161         address impl = implementation;
162         require(impl != address(0));
163         assembly {
164             let ptr := mload(0x40)
165             calldatacopy(ptr, 0, calldatasize)
166             let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
167             let size := returndatasize
168             returndatacopy(ptr, 0, size)
169 
170             switch result
171                 case 0 {
172                     revert(ptr, size)
173                 }
174                 default {
175                     return(ptr, size)
176                 }
177         }
178     }
179 
180     function _setImplementation(address _newImp) internal {
181         implementation = _newImp;
182     }
183 
184     function upgradeTo(address _newImplementation) public onlyOwner {
185         require(implementation != _newImplementation);
186         _setImplementation(_newImplementation);
187     }
188 
189     function totalSupply() public view returns (uint256) {
190         return totalSupply_;
191     }
192 
193     function transfer(address _to, uint256 _value)
194         public
195         whenNotPaused
196         notFrozen(msg.sender)
197         returns (bool)
198     {
199         require(_to != address(0));
200         require(_value <= balances[msg.sender]);
201 
202         // SafeMath.sub will throw if there is not enough balance.
203         balances[msg.sender] = balances[msg.sender].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         emit Transfer(msg.sender, _to, _value);
206         return true;
207     }
208 
209     function multiTransfer(
210         address[] memory _toList,
211         uint256[] memory _valueList
212     ) public whenNotPaused notFrozen(msg.sender) returns (bool) {
213         if (_toList.length != _valueList.length) {
214             revert();
215         }
216 
217         for (uint256 i = 0; i < _toList.length; i++) {
218             transfer(_toList[i], _valueList[i]);
219         }
220 
221         return true;
222     }
223 
224     function balanceOf(address _holder) public view returns (uint256 balance) {
225         return balances[_holder];
226     }
227 
228     function transferFrom(
229         address _from,
230         address _to,
231         uint256 _value
232     ) public whenNotPaused notFrozen(_from) returns (bool) {
233         require(_to != address(0));
234         require(_value <= balances[_from]);
235         require(_value <= allowed[_from][msg.sender]);
236 
237         balances[_from] = balances[_from].sub(_value);
238         balances[_to] = balances[_to].add(_value);
239         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240         emit Transfer(_from, _to, _value);
241         return true;
242     }
243 
244     function approve(address _spender, uint256 _value)
245         public
246         whenNotPaused
247         returns (bool)
248     {
249         allowed[msg.sender][_spender] = _value;
250         emit Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     function increaseAllowance(address spender, uint256 addedValue)
255         public
256         returns (bool)
257     {
258         require(spender != address(0));
259         allowed[msg.sender][spender] = (
260             allowed[msg.sender][spender].add(addedValue)
261         );
262 
263         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
264         return true;
265     }
266 
267     function decreaseAllowance(address spender, uint256 subtractedValue)
268         public
269         returns (bool)
270     {
271         require(spender != address(0));
272         allowed[msg.sender][spender] = (
273             allowed[msg.sender][spender].sub(subtractedValue)
274         );
275 
276         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
277         return true;
278     }
279 
280     function allowance(address _holder, address _spender)
281         public
282         view
283         returns (uint256)
284     {
285         return allowed[_holder][_spender];
286     }
287 
288     function freezeAccount(address _holder) public onlyOwner returns (bool) {
289         require(!frozen[_holder]);
290         frozen[_holder] = true;
291         emit Freeze(_holder);
292         return true;
293     }
294 
295     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
296         require(frozen[_holder]);
297         frozen[_holder] = false;
298         emit Unfreeze(_holder);
299         return true;
300     }
301 
302     function distribute(address _to, uint256 _value)
303         public
304         onlyOwner
305         returns (bool)
306     {
307         require(_to != address(0));
308         require(_value <= balances[msg.sender]);
309 
310         balances[msg.sender] = balances[msg.sender].sub(_value);
311         balances[_to] = balances[_to].add(_value);
312         emit Transfer(msg.sender, _to, _value);
313         return true;
314     }
315 
316     function claimToken(
317         ERC20 token,
318         address _to,
319         uint256 _value
320     ) public onlyOwner returns (bool) {
321         token.transfer(_to, _value);
322         return true;
323     }
324 
325     function burn(uint256 _value) public onlyOwner returns (bool success) {
326         require(_value <= balances[msg.sender]);
327         address burner = msg.sender;
328         balances[burner] = balances[burner].sub(_value);
329         totalSupply_ = totalSupply_.sub(_value);
330         emit Burn(burner, _value);
331         emit Transfer(burner, address(0), _value);
332         return true;
333     }
334 
335     function mint(address _to, uint256 _amount)
336         public
337         onlyOwner
338         returns (bool)
339     {
340         require(mintCap >= totalSupply_.add(_amount));
341         totalSupply_ = totalSupply_.add(_amount);
342         balances[_to] = balances[_to].add(_amount);
343         emit Transfer(address(0), _to, _amount);
344         return true;
345     }
346 }