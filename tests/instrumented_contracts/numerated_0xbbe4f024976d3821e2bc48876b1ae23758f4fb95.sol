1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // @Name SafeMath
5 // @Desc Math operations with safety checks that throw on error
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a / b;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 // ----------------------------------------------------------------------------
35 // @title ERC20Basic
36 // @dev Simpler version of ERC20 interface
37 // See https://github.com/ethereum/EIPs/issues/179
38 // ----------------------------------------------------------------------------
39 contract ERC20Basic {
40     function totalSupply() public view returns (uint256);
41     function balanceOf(address who) public view returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 // ----------------------------------------------------------------------------
46 // @title ERC20 interface
47 // @dev See https://github.com/ethereum/EIPs/issues/20
48 // ----------------------------------------------------------------------------
49 contract ERC20 is ERC20Basic {
50     function allowance(address owner, address spender) public view returns (uint256);
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function approve(address spender, uint256 value) public returns (bool); 
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 // ----------------------------------------------------------------------------
56 // @title Basic token
57 // @dev Basic version of StandardToken, with no allowances.
58 // ----------------------------------------------------------------------------
59 contract BasicToken is ERC20Basic {
60     using SafeMath for uint256;
61 
62     mapping(address => uint256) balances;
63 
64     uint256 totalSupply_;
65 
66     function totalSupply() public view returns (uint256) {
67         return totalSupply_;
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_value <= balances[msg.sender]);
73 
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76     
77         emit Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public view returns (uint256) {
82         return balances[_owner];
83     }
84 }
85 // ----------------------------------------------------------------------------
86 // @title Ownable
87 // ----------------------------------------------------------------------------
88 contract Ownable {
89     address public owner;
90     address public operator;
91 
92     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
93     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
94 
95     constructor() public {
96         owner    = msg.sender;
97         operator = msg.sender;
98     }
99 
100     modifier onlyOwner() { require(msg.sender == owner); _; }
101     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
102     
103     function transferOwnership(address _newOwner) external onlyOwner {
104         require(_newOwner != address(0));
105         emit OwnershipTransferred(owner, _newOwner);
106         owner = _newOwner;
107     }
108   
109     function transferOperator(address _newOperator) external onlyOwner {
110         require(_newOperator != address(0));
111         emit OperatorTransferred(operator, _newOperator);
112         operator = _newOperator;
113     }
114 }
115 // ----------------------------------------------------------------------------
116 // @title BlackList
117 // ----------------------------------------------------------------------------
118 contract BlackList is Ownable {
119 
120     event Lock(address indexed LockedAddress);
121     event Unlock(address indexed UnLockedAddress);
122 
123     mapping( address => bool ) public blackList;
124 
125     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
126 
127     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
128         require(_lockAddress != address(0));
129         require(_lockAddress != owner);
130         require(blackList[_lockAddress] != true);
131         
132         blackList[_lockAddress] = true;
133         
134         emit Lock(_lockAddress);
135 
136         return true;
137     }
138 
139     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
140         require(blackList[_unlockAddress] != false);
141         
142         blackList[_unlockAddress] = false;
143         
144         emit Unlock(_unlockAddress);
145 
146         return true;
147     }
148 }
149 // ----------------------------------------------------------------------------
150 // @title Pausable
151 // ----------------------------------------------------------------------------
152 contract Pausable is Ownable {
153     event Pause();
154     event Unpause();
155 
156     bool public paused = false;
157 
158     modifier whenNotPaused() { require(!paused); _; }
159     modifier whenPaused() { require(paused); _; }
160 
161     function pause() external onlyOwnerOrOperator whenNotPaused {
162         paused = true;
163         emit Pause();
164     }
165 
166     function unpause() external onlyOwner whenPaused {
167         paused = false;
168         emit Unpause();
169     }
170 }
171 // ----------------------------------------------------------------------------
172 // @title Standard ERC20 token
173 // @dev Implementation of the basic standard token.
174 // https://github.com/ethereum/EIPs/issues/20
175 // ----------------------------------------------------------------------------
176 contract StandardToken is ERC20, BasicToken {
177   
178     mapping (address => mapping (address => uint256)) internal allowed;
179 
180     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value <= allowed[_from][msg.sender]);
184 
185         balances[_from] = balances[_from].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     
189         emit Transfer(_from, _to, _value);
190     
191         return true;
192     }
193 
194     function approve(address _spender, uint256 _value) public returns (bool) {
195         allowed[msg.sender][_spender] = _value;
196     
197         emit Approval(msg.sender, _spender, _value);
198     
199         return true;
200     }
201 
202     function allowance(address _owner, address _spender) public view returns (uint256) {
203         return allowed[_owner][_spender];
204     }
205 
206     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
207         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
208     
209         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     
211         return true;
212     }
213 
214     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
215         uint256 oldValue = allowed[msg.sender][_spender];
216     
217         if (_subtractedValue > oldValue) {
218         allowed[msg.sender][_spender] = 0;
219         } else {
220         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221         }
222     
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 }
227 // ----------------------------------------------------------------------------
228 // @title MultiTransfer Token
229 // @dev Only Admin (for Airdrop Event)
230 // ----------------------------------------------------------------------------
231 contract MultiTransferToken is StandardToken, Ownable {
232 
233     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
234         require(_to.length == _amount.length);
235 
236         uint16 ui;
237         uint256 amountSum = 0;
238     
239         for (ui = 0; ui < _to.length; ui++) {
240             require(_to[ui] != address(0));
241 
242             amountSum = amountSum.add(_amount[ui]);
243         }
244 
245         require(amountSum <= balances[msg.sender]);
246 
247         for (ui = 0; ui < _to.length; ui++) {
248             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
249             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
250         
251             emit Transfer(msg.sender, _to[ui], _amount[ui]);
252         }
253     
254         return true;
255     }
256     
257     function Airdrop(address[] _to, uint256 _amount) onlyOwner public returns (bool) {
258         uint16 ui;
259         uint256 amountSum;
260         
261         amountSum = _amount.mul(_to.length);
262         require(amountSum <= balances[msg.sender]);
263 
264         for (ui = 0; ui < _to.length; ui++) {
265             balances[msg.sender] = balances[msg.sender].sub(_amount);
266             balances[_to[ui]] = balances[_to[ui]].add(_amount);
267         
268             emit Transfer(msg.sender, _to[ui], _amount);
269         }
270     
271         return true;
272     }
273 }
274 // ----------------------------------------------------------------------------
275 // @title Burnable Token
276 // @dev Token that can be irreversibly burned (destroyed).
277 // ----------------------------------------------------------------------------
278 contract BurnableToken is StandardToken, Ownable {
279 
280     event BurnAdminAmount(address indexed burner, uint256 value);
281 
282     function burnAdminAmount(uint256 _value) onlyOwner public {
283         require(_value <= balances[msg.sender]);
284 
285         balances[msg.sender] = balances[msg.sender].sub(_value);
286         totalSupply_ = totalSupply_.sub(_value);
287     
288         emit BurnAdminAmount(msg.sender, _value);
289         emit Transfer(msg.sender, address(0), _value);
290     }
291 }
292 // ----------------------------------------------------------------------------
293 // @title Mintable token
294 // @dev Simple ERC20 Token example, with mintable token creation
295 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
296 // ----------------------------------------------------------------------------
297 contract MintableToken is StandardToken, Ownable {
298     event Mint(address indexed to, uint256 amount);
299     event MintFinished();
300 
301     bool public mintingFinished = false;
302 
303     modifier canMint() { require(!mintingFinished); _; }
304 
305     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
306         totalSupply_ = totalSupply_.add(_amount);
307         balances[_to] = balances[_to].add(_amount);
308     
309         emit Mint(_to, _amount);
310         emit Transfer(address(0), _to, _amount);
311     
312         return true;
313     }
314 
315     function finishMinting() onlyOwner canMint public returns (bool) {
316         mintingFinished = true;
317         emit MintFinished();
318         return true;
319     }
320 }
321 // ----------------------------------------------------------------------------
322 // @title Pausable token
323 // @dev StandardToken modified with pausable transfers.
324 // ----------------------------------------------------------------------------
325 contract PausableToken is StandardToken, Pausable, BlackList {
326 
327     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
328         return super.transfer(_to, _value);
329     }
330 
331     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
332         return super.transferFrom(_from, _to, _value);
333     }
334 
335     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
336         return super.approve(_spender, _value);
337     }
338 
339     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
340         return super.increaseApproval(_spender, _addedValue);
341     }
342 
343     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
344         return super.decreaseApproval(_spender, _subtractedValue);
345     }
346 }
347 // ----------------------------------------------------------------------------
348 // @Project KD2 Token (KD2)
349 // ----------------------------------------------------------------------------
350 contract KD2Token is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
351     string public name = "KD2 TOKEN";
352     string public symbol = "KD2";
353     uint256 public decimals = 18;
354 }