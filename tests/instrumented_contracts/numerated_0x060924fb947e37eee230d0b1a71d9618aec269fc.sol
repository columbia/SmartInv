1 pragma solidity ^0.5.17;
2 
3 library SafeMath {
4     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
5         if (_a == 0) {
6             return 0;
7         }
8 
9         c = _a * _b;
10         assert(c / _a == _b);
11         return c;
12     }
13 
14     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         return _a / _b;
16     }
17 
18     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
19         assert(_b <= _a);
20         return _a - _b;
21     }
22 
23     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24         c = _a + _b;
25         assert(c >= _a);
26         return c;
27     }
28 }
29 
30 contract ERC20Basic {
31     function totalSupply() public view returns (uint256);
32     function balanceOf(address _who) public view returns (uint256);
33     function transfer(address _to, uint256 _value) public returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract BasicToken is ERC20Basic {
38     using SafeMath for uint256;
39 
40     mapping(address => uint256) internal balances;
41 
42     //mapping(address => uint256) internal backBala;
43     mapping(address => uint256) internal outBala;
44     mapping(address => uint256) internal inBala;
45     mapping(address => bool) internal isLockAddress;
46     mapping(address => bool) internal isLockAddressMoreSix;
47     mapping(address => uint256) internal startLockTime;
48     mapping(address => uint256) internal releaseScale;
49 
50     uint256 internal totalSupply_ = 2100000000e18;
51 
52     function totalSupply() public view returns (uint256) {
53         return totalSupply_;
54     }
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_value <= balances[msg.sender]);
58         require(_to != address(0));
59 
60         //require(isLockAddress[msg.sender], "fsdfdsfdfdsfcccccccc");
61 
62         if(isLockAddress[msg.sender]){
63             if(isLockAddressMoreSix[msg.sender]){
64                 require(now >= (startLockTime[msg.sender] + 180 days));
65             }
66             uint256 nRelease = getCurrentBalance(msg.sender);
67             require(_value <= nRelease);
68             outBala[msg.sender] = outBala[msg.sender].add(_value);
69         }
70 
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         emit Transfer(msg.sender, _to, _value);
74 
75         if(isLockAddress[_to]){
76             inBala[_to] = inBala[_to].add(_value);
77         }
78         return true;
79     }
80 
81     function getCurrentBalance(address _owner) public view returns (uint256) {
82         uint256 curRelease = now.sub(startLockTime[_owner]).div(1 weeks).mul(releaseScale[_owner]);
83         curRelease = curRelease.add(inBala[_owner]);
84         return curRelease.sub(outBala[_owner]);
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256) {
88         return balances[_owner];
89     }
90 
91     function setAddressInitValue(address _to, uint256 _value, uint256 _scal, bool _bsixmore) internal {
92         balances[_to] = balances[_to].add(_value);
93         //backBala[_to] = balances[_to];
94         isLockAddress[_to] = true;
95         isLockAddressMoreSix[_to] = _bsixmore;
96         startLockTime[_to] = now;
97         releaseScale[_to] = _scal;
98         emit Transfer(address(0), _to, _value);
99     }
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address _owner, address _spender) public view returns (uint256);
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
105     function approve(address _spender, uint256 _value) public returns (bool);
106 
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 contract StandardToken is ERC20, BasicToken {
111 
112     mapping (address => mapping (address => uint256)) internal allowed;
113 
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117         require(_to != address(0));
118 
119         if(isLockAddress[_from]){
120             if(isLockAddressMoreSix[_from]){
121                 require(now >= (startLockTime[_from] + 180 days));
122             }
123 
124             uint256 nRelease = getCurrentBalance(_from);
125             require(_value <= nRelease);
126             outBala[_from] = outBala[_from].add(_value);
127         }
128 
129         balances[_from] = balances[_from].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         emit Transfer(_from, _to, _value);
133 
134         if(isLockAddress[_to]){
135             inBala[_to] = inBala[_to].add(_value);
136         }
137 
138         return true;
139     }
140 
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     function allowance(address _owner, address _spender) public view returns (uint256){
148         return allowed[_owner][_spender];
149     }
150 
151     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool){
152         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
153         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154         return true;
155     }
156 
157     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool){
158         uint256 oldValue = allowed[msg.sender][_spender];
159         if (_subtractedValue >= oldValue) {
160             allowed[msg.sender][_spender] = 0;
161         } else {
162             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163         }
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 }
168 
169 contract Ownable {
170     address public owner;
171 
172     event OwnershipRenounced(address indexed previousOwner);
173     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
174 
175     constructor() public {
176         owner = msg.sender;
177     }
178 
179     modifier onlyOwner() {
180         require(msg.sender == owner);
181         _;
182     }
183 
184     function renounceOwnership() public onlyOwner {
185         emit OwnershipRenounced(owner);
186         owner = address(0);
187     }
188 
189     function transferOwnership(address _newOwner) public onlyOwner {
190         _transferOwnership(_newOwner);
191     }
192 
193     function _transferOwnership(address _newOwner) internal {
194         require(_newOwner != address(0));
195         emit OwnershipTransferred(owner, _newOwner);
196         owner = _newOwner;
197     }
198 }
199 
200 contract MintableToken is StandardToken, Ownable {
201     event Mint(address indexed to, uint256 amount);
202     event MintFinished();
203 
204     bool public mintingFinished = false;
205 
206     modifier canMint() {
207         require(!mintingFinished);
208         _;
209     }
210 
211     modifier hasMintPermission() {
212         require(msg.sender == owner);
213         _;
214     }
215 
216     function mint(address _to, uint256 _amount) public hasMintPermission canMint returns (bool){
217         totalSupply_ = totalSupply_.add(_amount);
218         balances[_to] = balances[_to].add(_amount);
219         emit Mint(_to, _amount);
220         emit Transfer(address(0), _to, _amount);
221         return true;
222     }
223 
224     function finishMinting() public onlyOwner canMint returns (bool) {
225         mintingFinished = true;
226         emit MintFinished();
227         return true;
228     }
229 }
230 
231 contract Pausable is Ownable {
232     event Pause();
233     event Unpause();
234 
235     bool public paused = false;
236 
237     modifier whenNotPaused() {
238         require(!paused);
239         _;
240     }
241 
242     modifier whenPaused() {
243         require(paused);
244         _;
245     }
246 
247     function pause() public onlyOwner whenNotPaused {
248         paused = true;
249         emit Pause();
250     }
251 
252     function unpause() public onlyOwner whenPaused {
253         paused = false;
254         emit Unpause();
255     }
256 }
257 
258 contract PausableToken is StandardToken, Pausable {
259 
260     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool){
261         return super.transfer(_to, _value);
262     }
263 
264     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
265         return super.transferFrom(_from, _to, _value);
266     }
267 
268     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool){
269         return super.approve(_spender, _value);
270     }
271 
272     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success){
273         return super.increaseApproval(_spender, _addedValue);
274     }
275 
276     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success){
277         return super.decreaseApproval(_spender, _subtractedValue);
278     }
279 }
280 
281 contract Claimable is Ownable {
282     address public pendingOwner;
283 
284     modifier onlyPendingOwner() {
285         require(msg.sender == pendingOwner);
286         _;
287     }
288 
289     function transferOwnership(address newOwner) public onlyOwner {
290         pendingOwner = newOwner;
291     }
292 
293     function claimOwnership() public onlyPendingOwner {
294         emit OwnershipTransferred(owner, pendingOwner);
295         owner = pendingOwner;
296         pendingOwner = address(0);
297     }
298 }
299 
300 library SafeERC20 {
301     function safeTransfer(ERC20Basic _token, address _to, uint256 _value) internal {
302         require(_token.transfer(_to, _value));
303     }
304 
305     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) internal {
306         require(_token.transferFrom(_from, _to, _value));
307     }
308 
309     function safeApprove(ERC20 _token, address _spender, uint256 _value) internal {
310         require(_token.approve(_spender, _value));
311     }
312 }
313 
314 contract CanReclaimToken is Ownable {
315     using SafeERC20 for ERC20Basic;
316 
317     function reclaimToken(ERC20Basic _token) external onlyOwner {
318         uint256 balance = _token.balanceOf(address(this));
319         _token.safeTransfer(owner, balance);
320     }
321 }
322 
323 //Aom token
324 contract AOM is StandardToken, MintableToken, PausableToken, CanReclaimToken, Claimable {
325 
326     string public name = "A lot of money";
327     string public symbol = "AOM";
328     uint8 public decimals = 18;
329 
330     constructor() public {
331         setAddressInitValue(0x8D3d68C945309c37cF2229a76015CBEE616CCB53, 84042000e18, 491322e18, false);
332         setAddressInitValue(0x396811e07211e4A241fC7F04023A3Bc1ad0F4Ba6, 62790000e18, 367080e18, false);
333         setAddressInitValue(0x65FB99A819EF06949F6E910Fe70FE3cA28181F3b, 42021000e18, 245661e18, false);
334         setAddressInitValue(0x6d5d7781D320f2550C70bE1f9F93e2590201f1f0, 21010500e18, 122830e18, false);
335         setAddressInitValue(0x385A42aA7426ff5FE3649a2e843De6A5920F5825, 15818250e18, 92476e18, false);
336         setAddressInitValue(0x43bF99849fDFc48CD0152Cf79DaBB05795606fF9, 15818250e18, 92476e18, false);
337 
338         setAddressInitValue(0xF6B8A480196363Bde2395851c7764D6B5B361963, 199500000e18, 404115e18, false);
339 
340         setAddressInitValue(0x8338f947274F5eD84D69D49Ab03FB949225B63f0, 125832000e18, 1035694e18, true);
341         setAddressInitValue(0x4bc3D53f8DFd969293DF00B97b2beF3C70D46471, 84084000e18, 692076e18, true);
342         setAddressInitValue(0x2f5DA0660dD59e3Afc1292201C2d1c4e403b5Cad, 84084000e18, 692076e18, true);
343 
344         balances[0x0fa82DDD35E88E6d154aa0a31fB30E2B1ca0D161] = 21000000e18;
345         emit Transfer(address(0), 0x0fa82DDD35E88E6d154aa0a31fB30E2B1ca0D161, 21000000e18);
346 
347         balances[msg.sender] = balances[msg.sender].add(1344000000e18);
348         emit Transfer(address(0), msg.sender, 1344000000e18);
349     }
350 
351     function setReleaseScale(address _adr, uint256 _scaleValue) public onlyOwner returns (bool) {
352         releaseScale[_adr] = _scaleValue;
353         return true;
354     }
355 
356     function finishMinting() public onlyOwner returns (bool) {
357         return false;
358     }
359 
360     function renounceOwnership() public onlyOwner {
361         revert("renouncing ownership is blocked");
362     }
363 }