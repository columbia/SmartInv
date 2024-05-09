1 /*! crypton.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a / b;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Ownable {
32     address public owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     modifier onlyOwner() { require(msg.sender == owner); _; }
37 
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     function _transferOwnership(address _newOwner) internal {
43         require(_newOwner != address(0));
44         owner = _newOwner;
45         emit OwnershipTransferred(owner, _newOwner);
46     }
47 
48     function transferOwnership(address _newOwner) public onlyOwner {
49         _transferOwnership(_newOwner);
50     }
51 }
52 
53 contract Manageable is Ownable {
54     address[] public managers;
55 
56     event ManagerAdded(address indexed manager);
57     event ManagerRemoved(address indexed manager);
58 
59     modifier onlyManager() { require(isManager(msg.sender)); _; }
60 
61     function countManagers() view public returns(uint) {
62         return managers.length;
63     }
64 
65     function getManagers() view public returns(address[]) {
66         return managers;
67     }
68 
69     function isManager(address _manager) view public returns(bool) {
70         for(uint i = 0; i < managers.length; i++) {
71             if(managers[i] == _manager) {
72                 return true;
73             }
74         }
75         return false;
76     }
77 
78     function addManager(address _manager) onlyOwner public {
79         require(_manager != address(0));
80         require(!isManager(_manager));
81 
82         managers.push(_manager);
83 
84         emit ManagerAdded(_manager);
85     }
86 
87     function removeManager(address _manager) onlyOwner public {
88         require(isManager(_manager));
89 
90         uint index = 0;
91         for(uint i = 0; i < managers.length; i++) {
92             if(managers[i] == _manager) {
93                 index = i;
94             }
95         }
96 
97         for(; index < managers.length - 1; index++) {
98             managers[index] = managers[index + 1];
99         }
100 
101         managers.length--;
102         emit ManagerRemoved(_manager);
103     }
104 }
105 
106 contract Withdrawable is Ownable {
107     function withdrawEther(address _to, uint _value) onlyOwner public {
108         require(_to != address(0));
109         require(address(this).balance >= _value);
110 
111         _to.transfer(_value);
112     }
113 
114     function withdrawTokens(ERC20 _token, address _to, uint256 _value) onlyOwner public {
115         require(_token.transfer(_to, _value));
116     }
117 
118 }
119 
120 contract Pausable is Ownable {
121     bool public paused = false;
122 
123     event Pause();
124     event Unpause();
125 
126     modifier whenNotPaused() { require(!paused); _; }
127     modifier whenPaused() { require(paused); _; }
128 
129     function pause() onlyOwner whenNotPaused public {
130         paused = true;
131         emit Pause();
132     }
133 
134     function unpause() onlyOwner whenPaused public {
135         paused = false;
136         emit Unpause();
137     }
138 }
139 
140 contract ERC20 {
141     event Transfer(address indexed from, address indexed to, uint256 value);
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 
144     function totalSupply() public view returns (uint256);
145 
146     function balanceOf(address who) public view returns (uint256);
147 
148     function transfer(address to, uint256 value) public returns (bool);
149 
150     function transferFrom(address from, address to, uint256 value) public returns (bool);
151 
152     function allowance(address owner, address spender) public view returns (uint256);
153 
154     function approve(address spender, uint256 value) public returns (bool);
155 }
156 
157 contract StandardToken is ERC20 {
158     using SafeMath for uint256;
159 
160     uint256 totalSupply_;
161 
162     string public name;
163     string public symbol;
164     uint8 public decimals;
165 
166     mapping(address => uint256) balances;
167     mapping(address => mapping(address => uint256)) internal allowed;
168 
169     constructor(string _name, string _symbol, uint8 _decimals) public {
170         name = _name;
171         symbol = _symbol;
172         decimals = _decimals;
173     }
174 
175     function totalSupply() public view returns (uint256) {
176         return totalSupply_;
177     }
178 
179     function balanceOf(address _owner) public view returns (uint256) {
180         return balances[_owner];
181     }
182 
183     function transfer(address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[msg.sender]);
186 
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189 
190         emit Transfer(msg.sender, _to, _value);
191 
192         return true;
193     }
194 
195     function multiTransfer(address[] _to, uint256[] _value) public returns (bool) {
196         require(_to.length == _value.length);
197 
198         for (uint i = 0; i < _to.length; i++) {
199             transfer(_to[i], _value[i]);
200         }
201 
202         return true;
203     }
204 
205     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
206         require(_to != address(0));
207         require(_value <= balances[_from]);
208         require(_value <= allowed[_from][msg.sender]);
209 
210         balances[_from] = balances[_from].sub(_value);
211         balances[_to] = balances[_to].add(_value);
212         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213 
214         emit Transfer(_from, _to, _value);
215 
216         return true;
217     }
218 
219     function allowance(address _owner, address _spender) public view returns (uint256) {
220         return allowed[_owner][_spender];
221     }
222 
223     function approve(address _spender, uint256 _value) public returns (bool) {
224         allowed[msg.sender][_spender] = _value;
225 
226         emit Approval(msg.sender, _spender, _value);
227 
228         return true;
229     }
230 
231     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233 
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235 
236         return true;
237     }
238 
239     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
240         uint oldValue = allowed[msg.sender][_spender];
241 
242         if (_subtractedValue > oldValue) {
243             allowed[msg.sender][_spender] = 0;
244         } else {
245             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246         }
247 
248         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249 
250         return true;
251     }
252 }
253 
254 contract MintableToken is StandardToken, Ownable {
255     event Mint(address indexed to, uint256 amount);
256     event MintFinished();
257 
258     bool public mintingFinished = false;
259 
260     modifier canMint() { require(!mintingFinished); _; }
261 
262     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
263         totalSupply_ = totalSupply_.add(_amount);
264         balances[_to] = balances[_to].add(_amount);
265 
266         emit Mint(_to, _amount);
267         emit Transfer(address(0), _to, _amount);
268 
269         return true;
270     }
271 
272     function finishMinting() onlyOwner canMint public returns (bool) {
273         mintingFinished = true;
274 
275         emit MintFinished();
276 
277         return true;
278     }
279 }
280 
281 contract CappedToken is MintableToken {
282     uint256 public cap;
283 
284     constructor(uint256 _cap) public {
285         require(_cap > 0);
286         cap = _cap;
287     }
288 
289     function mint(address _to, uint256 _amount) public returns (bool) {
290         require(totalSupply_.add(_amount) <= cap);
291 
292         return super.mint(_to, _amount);
293     }
294 }
295 
296 contract BurnableToken is StandardToken {
297     event Burn(address indexed burner, uint256 value);
298 
299     function _burn(address _who, uint256 _value) internal {
300         require(_value <= balances[_who]);
301 
302         balances[_who] = balances[_who].sub(_value);
303         totalSupply_ = totalSupply_.sub(_value);
304 
305         emit Burn(_who, _value);
306         emit Transfer(_who, address(0), _value);
307     }
308 
309     function burn(uint256 _value) public {
310         _burn(msg.sender, _value);
311     }
312 
313 }
314 
315 /*
316     ICO Crypt-ON - p2p DAO System
317 */
318 contract Token is CappedToken, BurnableToken, Withdrawable, Pausable {
319     constructor() CappedToken(200000000 * 1e18) StandardToken("I-Point", "IPT", 18) public {
320     }
321     function transfer(address to, uint256 value) public whenNotPaused returns (bool)
322     {
323         return super.transfer(to, value);
324     }
325 
326     function transferFrom(address from, address to, uint256 value ) public whenNotPaused returns (bool)
327     {
328         return super.transferFrom(from, to, value);
329     }
330 
331     function approve(address spender, uint256 value) public whenNotPaused returns (bool)
332     {
333         return super.approve(spender, value);
334     }
335 
336 }
337 
338 contract Crowdsale is Manageable, Withdrawable, Pausable {
339     using SafeMath for uint;
340 
341     Token public token;
342     bool public crowdsaleClosed = false;
343 
344     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
345     event CrowdsaleClose();
346 
347     constructor() public {
348         token = new Token();
349     }
350 
351     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
352         token.mint(_to, _tokens);
353         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
354     }
355 
356     function closeCrowdsale(address _to) onlyOwner public {
357         require(!crowdsaleClosed);
358 
359         token.finishMinting();
360         token.transferOwnership(_to);
361 
362         crowdsaleClosed = true;
363 
364         emit CrowdsaleClose();
365     }
366 
367     function transferTokenOwnership(address _to) onlyOwner public {
368         token.transferOwnership(_to);
369     }
370 
371     function tokenPause() onlyOwner public{
372         token.pause();
373     }
374     function tokenUnpause() onlyOwner public{
375         token.unpause();
376     }
377 
378 }