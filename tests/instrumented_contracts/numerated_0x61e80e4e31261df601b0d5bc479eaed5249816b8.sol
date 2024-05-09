1 pragma solidity ^0.6.9;
2 
3 abstract contract IERC20 {
4     function totalSupply() virtual public view returns (uint256);
5     function balanceOf(address who) virtual public view returns (uint256);
6     function allowance(address owner, address spender) virtual public view returns (uint256);
7     function transfer(address to, uint256 value) virtual public returns (bool);
8     function approve(address spender, uint256 value) virtual public returns (bool);
9     function transferFrom(address from, address to, uint256 value) virtual public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0);
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a);
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 contract Ownable {
53     address payable internal _owner;
54     event OwnershipTransferred(address owner, address newOwner);
55 
56     modifier onlyOwner() {
57         require(msg.sender == _owner);
58         _;
59     }
60 
61     constructor () public {
62         _owner = msg.sender;
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     function transferOwnership(address payable newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 contract Pausable is Ownable {
77     address internal _pauser;
78     bool private _paused = false;
79     event Paused(address account);
80     event Unpaused(address account);
81     event PauserChanged(address indexed newPauser);
82 
83     modifier whenNotPaused() {
84         require(!_paused, "It's paused");
85         _;
86     }
87 
88     modifier whenPaused() {
89         require(_paused, "It's not paused");
90         _;
91     }
92 
93     modifier onlyPauser() {
94         require(msg.sender == _pauser);
95         _;
96     }
97 
98     constructor () public {
99         _paused = false;
100         _pauser = msg.sender;
101     }
102 
103     function pauser() public view returns (address){
104         return _pauser;
105     }
106 
107     function pause() public onlyPauser  {
108         _paused = true;
109         emit Paused(msg.sender);
110     }
111 
112     function unPause() public onlyPauser {
113         _paused = false;
114         emit Unpaused(msg.sender);
115     }
116 
117     function paused() public view returns (bool) {
118         return _paused;
119     }
120 
121     function updatePauser(address newPauser) public onlyOwner {
122         require(newPauser != address(0));
123         _pauser = newPauser;
124         emit PauserChanged(newPauser);
125     }
126 }
127 
128 contract BlackListable is Ownable {
129     address internal _blackLister;
130     mapping (address => bool) internal _blackList;
131 
132     event BlackList(address account);
133     event UnBlackList(address account);
134     event BlackListerChanged(address newBlackLister);
135 
136     modifier whenNotBlackListed(address account) {
137         require(!_blackList[account]);
138         _;
139     }
140 
141     modifier onlyBlackLister() {
142         require(msg.sender == _blackLister);
143         _;
144     }
145 
146     constructor () public {
147         _blackLister = msg.sender;
148     }
149 
150     function blackLister() public view returns(address){
151         return _blackLister;
152     }
153 
154     function blackList(address account) public onlyBlackLister returns (bool) {
155         require(account != address(0));
156         require(account != _owner);
157         _blackList[account] = true;
158         emit BlackList(account);
159         return true;
160     }
161 
162     function unBlackList(address account) public onlyBlackLister returns (bool) {
163         require(account != address(0));
164         _blackList[account] = false;
165         emit UnBlackList( account);
166         return true;
167     }
168 
169     function isBlackListed(address account) public view returns (bool){
170         return _blackList[account];
171     }
172 
173     function updateBlackLister(address newBlackLister) public onlyOwner {
174         require(newBlackLister != address(0));
175         _blackLister = newBlackLister;
176         emit BlackListerChanged(newBlackLister);
177     }
178 }
179 
180 contract ERC20Token is IERC20,Ownable,Pausable,BlackListable {
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) internal _balances;
184     mapping (address => mapping (address => uint256)) private _allowed;
185 
186     address private _minter;
187     uint256 private _totalSupply;
188     bool private _inited;
189     string private _name;
190     string private _symbol;
191     uint8 private _decimals;
192     uint256 private _maxSupply = 10*10**9*10**4;
193 
194     event MinterChanged(address newMinter);
195 
196     modifier onlyMinter() {
197         require(msg.sender == _minter);
198         _;
199     }
200 
201     constructor () public {
202         _minter = msg.sender;
203     }
204     
205     function init(string memory name, string memory symbol, uint8 decimals, uint256 initSupply) public onlyOwner returns(bool){
206         require(!_inited);
207         
208         _name = name;
209         _symbol = symbol;
210         _decimals = decimals;
211         mint(initSupply);
212         _inited = true;
213         
214         return true;
215     }
216 
217     function name() public view returns(string memory) {
218         return _name;
219     }
220 
221     function symbol() public view returns(string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public view returns(uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() override public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     function maxSupply() public view returns (uint256) {
234         return _maxSupply;
235     }
236 
237     function minter() public view returns (address) {
238         return _minter;
239     }
240 
241     function balanceOf(address owner) override public view returns (uint256) {
242         return _balances[owner];
243     }
244 
245     function allowance(address owner, address spender) override public view returns (uint256) {
246         return _allowed[owner][spender];
247     }
248 
249     function transfer(address to, uint256 value) override
250         public whenNotPaused
251         whenNotBlackListed(msg.sender)
252         whenNotBlackListed(to)
253         returns (bool) {
254         _transfer(msg.sender, to, value);
255         return true;
256     }
257 
258     function approve(address spender, uint256 value) override
259         public whenNotPaused
260         whenNotBlackListed(msg.sender)
261         whenNotBlackListed(spender)
262         returns (bool) {
263         require(spender != address(0));
264 
265         _allowed[msg.sender][spender] = value;
266         emit Approval(msg.sender, spender, value);
267         return true;
268     }
269 
270     function transferFrom(address from, address to, uint256 value) override
271         public whenNotPaused
272         whenNotBlackListed(msg.sender)
273         whenNotBlackListed(from)
274         whenNotBlackListed(to)
275         returns (bool) {
276         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
277         _transfer(from, to, value);
278         return true;
279     }
280 
281     function increaseAllowance(address spender, uint256 addedValue)
282         public whenNotPaused
283         whenNotBlackListed(msg.sender)
284         whenNotBlackListed(spender)
285         returns (bool) {
286         require(spender != address(0));
287 
288         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
289         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
290         return true;
291     }
292 
293     function decreaseAllowance(address spender, uint256 subtractedValue)
294         public whenNotPaused
295         whenNotBlackListed(msg.sender)
296         whenNotBlackListed(spender)
297         returns (bool) {
298         require(spender != address(0));
299 
300         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
301         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
302         return true;
303     }
304 
305     function mint(uint256 value) private onlyMinter whenNotBlackListed(msg.sender) returns (bool) {
306         _mint(value);
307         return true;
308     }
309 
310     function burn(uint256 value) public onlyMinter whenNotPaused whenNotBlackListed(msg.sender) {
311         _burn(msg.sender, value);
312     }
313 
314     function updateMinter(address newMinter) public onlyOwner whenNotPaused {
315         require(newMinter != address(0));
316         _minter = newMinter;
317         emit MinterChanged(newMinter);
318     }
319 
320     //self kill contract
321     function kill()  public onlyOwner{
322         selfdestruct(_owner);
323     }
324 
325     function _transfer(address from, address to, uint256 value) private {
326         require(to != address(0));
327 
328         _balances[from] = _balances[from].sub(value);
329         _balances[to] = _balances[to].add(value);
330         emit Transfer(from, to, value);
331     }
332 
333     function _mint(uint256 value) private {
334         require(_totalSupply.add(value) <= _maxSupply);
335 
336         _totalSupply = _totalSupply.add(value);
337         _balances[_owner] = _balances[_owner].add(value);
338         emit Transfer(address(0), _owner, value);
339     }
340 
341     function _burn(address account, uint256 value) private {
342         require(account != address(0));
343 
344         _totalSupply = _totalSupply.sub(value);
345         _balances[account] = _balances[account].sub(value);
346         emit Transfer(account, address(0), value);
347     }
348 
349     receive() external payable {
350         if(msg.value > 0){
351             _owner.transfer(msg.value);
352         }
353     }
354 }