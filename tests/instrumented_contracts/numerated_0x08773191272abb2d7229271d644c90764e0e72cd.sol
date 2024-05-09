1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5    
6     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7         if (_a == 0) {
8             return 0;
9         }
10         uint256 c = _a * _b;
11         require(c / _a == _b);
12         return c;
13     }
14 
15     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
16         uint256 c = _a / _b;
17         return c;
18     }
19   
20     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
21         require(_b <= _a);
22         uint256 c = _a - _b;
23         return c;
24     }
25     
26     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
27         uint256 c = _a + _b;
28         require(c >= _a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35     event OwnershipRenounced(address indexed previousOwner);
36     event OwnershipTransferred(
37         address indexed previousOwner,
38         address indexed newOwner
39     );
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44   
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function renounceOwnership() public onlyOwner {
51 emit OwnershipRenounced(owner);
52 owner = address(0);
53     }
54    
55     function transferOwnership(address _newOwner) public onlyOwner {
56         _transferOwnership(_newOwner);
57     }
58    
59     function _transferOwnership(address _newOwner) internal {
60         require(_newOwner != address(0)); 
61         emit OwnershipTransferred(owner, _newOwner);
62         owner = _newOwner;
63     }
64 }
65 
66 
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70     bool public paused = false;
71     
72     modifier whenNotPaused() {
73 require(!paused);
74         _;
75     }
76    
77     modifier whenPaused() {
78         require(paused);
79         _;
80     }
81    
82     function pause() public onlyOwner whenNotPaused {
83         paused = true;
84         emit Pause();
85     }
86     
87     function unpause() public onlyOwner whenPaused {
88         paused = false;
89         emit Unpause();
90     }
91 }
92 
93 contract ERC20 {
94     function totalSupply() public view returns (uint256);
95     function balanceOf(address _who) public view returns (uint256);
96     function allowance(address _owner, address _spender)
97     public view returns (uint256);
98     function transfer(address _to, uint256 _value) public returns (bool);
99     function approve(address _spender, uint256 _value)
100     public returns (bool);
101     function transferFrom(address _from, address _to, uint256 _value)
102     public returns (bool);
103     event Transfer(
104         address indexed from,
105         address indexed to,
106         uint256 value
107     );
108     event Approval(
109         address indexed owner,
110         address indexed spender,
111         uint256 value
112     );
113 }
114 contract StandardToken is ERC20 {
115     using SafeMath for uint256;
116     mapping(address => uint256) balances;
117     mapping (address => mapping (address => uint256)) internal allowed;
118     uint256 totalSupply_;
119     function totalSupply() public view returns (uint256) {
120 return totalSupply_;
121     }
122     function balanceOf(address _owner) public view returns (uint256) {
123         return balances[_owner];
124     }
125     function allowance(
126         address _owner,
127         address _spender
128     )
129     public
130     view
131     returns (uint256)
132     {
133         return allowed[_owner][_spender];
134     }
135     
136     function transfer(address _to, uint256 _value) public returns (bool) {
137 require(_value <= balances[msg.sender]);
138 require(_to != address(0)); 
139 balances[msg.sender] = balances[msg.sender].sub(_value);
140 balances[_to] = balances[_to].add(_value);
141 emit Transfer(msg.sender, _to, _value);
142         return true; 
143     }
144     function approve(address _spender, uint256 _value) public returns (bool) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true; 
148     }
149     function transferFrom(
150         address _from,
151         address _to,
152         uint256 _value
153     )
154     public
155     returns (bool)
156 {
157 require(_value <= balances[_from]);
158 require(_value <= allowed[_from][msg.sender]);
159 require(_to != address(0)); 
160 balances[_from] = balances[_from].sub(_value);
161 balances[_to] = balances[_to].add(_value);
162 allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true; 
165 }
166   
167     function increaseApproval(
168         address _spender,
169         uint256 _addedValue
170     )
171     public
172     returns (bool)
173     {
174         allowed[msg.sender][_spender] = (
175         allowed[msg.sender][_spender].add(_addedValue));
176         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177         return true;
178     }
179     
180     function decreaseApproval(
181         address _spender,
182         uint256 _subtractedValue
183     )
184     public
185     returns (bool)
186     {
187         uint256 oldValue = allowed[msg.sender][_spender];
188         if (_subtractedValue >= oldValue) {
189             allowed[msg.sender][_spender] = 0;
190         } else {
191             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192         }
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 }
197 
198 contract PausableERC20Token is StandardToken, Pausable {
199     function transfer(
200         address _to,
201         uint256 _value
202     )
203     public
204     whenNotPaused
205     returns (bool)
206     {
207         return super.transfer(_to, _value);
208     }
209     function transferFrom(
210         address _from,
211         address _to,
212         uint256 _value
213     )
214     public
215     whenNotPaused
216     returns (bool)
217     {
218         return super.transferFrom(_from, _to, _value);
219     }
220     function approve(
221         address _spender,
222         uint256 _value
223     )
224     public
225     whenNotPaused
226     returns (bool)
227     {
228         return super.approve(_spender, _value);
229     }
230     function increaseApproval(
231         address _spender,
232         uint _addedValue
233     )
234     public
235     whenNotPaused
236     returns (bool success)
237     {
238         return super.increaseApproval(_spender, _addedValue);
239     }
240     function decreaseApproval(
241         address _spender,
242         uint _subtractedValue
243     )
244     public
245     whenNotPaused
246     returns (bool success)
247     {
248         return super.decreaseApproval(_spender, _subtractedValue);
249     }
250 }
251 
252 contract BurnablePausableERC20Token is PausableERC20Token {
253     mapping (address => mapping (address => uint256)) internal allowedBurn;
254     event Burn(address indexed burner, uint256 value);
255     event ApprovalBurn(
256         address indexed owner,
257         address indexed spender,
258         uint256 value
259     );
260     function allowanceBurn(
261         address _owner,
262         address _spender
263     )
264     public
265     view
266     returns (uint256)
267     {
268         return allowedBurn[_owner][_spender];
269     }
270     function approveBurn(address _spender, uint256 _value)
271     public
272     whenNotPaused
273     returns (bool)
274     {
275         allowedBurn[msg.sender][_spender] = _value;
276         emit ApprovalBurn(msg.sender, _spender, _value);
277         return true;
278     }
279 
280     function burn(
281         uint256 _value
282     )
283     public
284     whenNotPaused
285 {
286 _burn(msg.sender, _value);
287 }
288    
289     function burnFrom(
290         address _from,
291         uint256 _value
292     )
293     public
294     whenNotPaused
295     {
296         require(_value <= allowedBurn[_from][msg.sender]);
297         allowedBurn[_from][msg.sender] = allowedBurn[_from][msg.sender].sub(_value);
298         _burn(_from, _value);
299     }
300     function _burn(
301         address _who,
302         uint256 _value
303     )
304     internal
305     whenNotPaused
306     {
307         require(_value <= balances[_who]);
308         balances[_who] = balances[_who].sub(_value);
309         totalSupply_ = totalSupply_.sub(_value);
310         emit Burn(_who, _value);
311         emit Transfer(_who, address(0), _value);
312     }
313     function increaseBurnApproval(
314         address _spender,
315         uint256 _addedValue
316     )
317     public
318     whenNotPaused
319     returns (bool)
320     {
321         allowedBurn[msg.sender][_spender] = (
322         allowedBurn[msg.sender][_spender].add(_addedValue));
323         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
324         return true;
325     }
326     function decreaseBurnApproval(
327         address _spender,
328         uint256 _subtractedValue
329     )
330     public
331     whenNotPaused
332     returns (bool)
333     {
334         uint256 oldValue = allowedBurn[msg.sender][_spender];
335         if (_subtractedValue >= oldValue) {
336             allowedBurn[msg.sender][_spender] = 0;
337         } else {
338             allowedBurn[msg.sender][_spender] = oldValue.sub(_subtractedValue);
339         }
340         emit ApprovalBurn(msg.sender, _spender, allowedBurn[msg.sender][_spender]);
341         return true;
342     }
343 }
344 contract FreezableBurnablePausableERC20Token is BurnablePausableERC20Token {
345     mapping (address => bool) public frozenAccount;
346     event FrozenFunds(address target, bool frozen);
347     function freezeAccount(
348         address target,
349         bool freeze
350     )
351     public
352     onlyOwner
353 {
354 frozenAccount[target] = freeze;
355     emit FrozenFunds(target, freeze);
356 }
357     function transfer(
358         address _to,
359         uint256 _value
360     )
361     public
362     whenNotPaused
363     returns (bool)
364     {
365         require(!frozenAccount[msg.sender], "Sender account freezed");
366         require(!frozenAccount[_to], "Receiver account freezed");
367         return super.transfer(_to, _value);
368     }
369     function transferFrom(
370         address _from,
371         address _to,
372         uint256 _value
373     )
374     public
375     whenNotPaused
376     returns (bool)
377     {
378         require(!frozenAccount[msg.sender], "Spender account freezed");
379         require(!frozenAccount[_from], "Sender account freezed");
380         require(!frozenAccount[_to], "Receiver account freezed");
381         return super.transferFrom(_from, _to, _value);
382     }
383     function burn(
384         uint256 _value
385     )
386     public
387     whenNotPaused
388 {
389 require(!frozenAccount[msg.sender], "Sender account freezed");
390 return super.burn(_value);
391 }
392     function burnFrom(
393         address _from,
394         uint256 _value
395     )
396     public
397     whenNotPaused
398     {
399         require(!frozenAccount[msg.sender], "Spender account freezed");
400         require(!frozenAccount[_from], "Sender account freezed");
401         return super.burnFrom(_from, _value);
402     }
403 }
404 
405 contract EFT is FreezableBurnablePausableERC20Token {
406     string public constant name = "EduFriend Token";
407     string public constant symbol = "EFT";
408     uint8 public constant decimals = 18;
409     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
410     constructor() public {
411         totalSupply_ = INITIAL_SUPPLY;
412         balances[msg.sender] = INITIAL_SUPPLY;
413         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
414     }
415 }