1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // @Name SafeMath
5 // @Desc Math operations with safety checks that throw on error
6 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
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
89 
90     address public owner;
91     address public operator;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
95 
96     constructor() public {
97         owner    = msg.sender;
98         operator = msg.sender;
99     }
100 
101     modifier onlyOwner() { require(msg.sender == owner); _; }
102     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
103 
104     function transferOwnership(address _newOwner) external onlyOwner {
105         require(_newOwner != address(0));
106         emit OwnershipTransferred(owner, _newOwner);
107         owner = _newOwner;
108     }
109   
110     function transferOperator(address _newOperator) external onlyOwner {
111         require(_newOperator != address(0));
112         emit OperatorTransferred(operator, _newOperator);
113         operator = _newOperator;
114     }
115 }
116 // ----------------------------------------------------------------------------
117 // @title BlackList
118 // @dev Base contract which allows children to implement an emergency stop mechanism.
119 // ----------------------------------------------------------------------------
120 contract BlackList is Ownable {
121 
122     event Lock(address indexed LockedAddress);
123     event Unlock(address indexed UnLockedAddress);
124 
125     mapping( address => bool ) public blackList;
126 
127     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
128 
129     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
130         require(_lockAddress != address(0));
131         require(_lockAddress != owner);
132         require(blackList[_lockAddress] != true);
133         
134         blackList[_lockAddress] = true;
135         
136         emit Lock(_lockAddress);
137 
138         return true;
139     }
140 
141     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
142         require(blackList[_unlockAddress] != false);
143         
144         blackList[_unlockAddress] = false;
145         
146         emit Unlock(_unlockAddress);
147 
148         return true;
149     }
150 }
151 // ----------------------------------------------------------------------------
152 // @title Pausable
153 // @dev Base contract which allows children to implement an emergency stop mechanism.
154 // ----------------------------------------------------------------------------
155 contract Pausable is Ownable {
156     event Pause();
157     event Unpause();
158 
159     bool public paused = false;
160 
161     modifier whenNotPaused() { require(!paused); _; }
162     modifier whenPaused() { require(paused); _; }
163 
164     function pause() onlyOwnerOrOperator whenNotPaused public {
165         paused = true;
166         emit Pause();
167     }
168 
169     function unpause() onlyOwner whenPaused public {
170         paused = false;
171         emit Unpause();
172     }
173 }
174 // ----------------------------------------------------------------------------
175 // @title Standard ERC20 token
176 // @dev Implementation of the basic standard token.
177 // https://github.com/ethereum/EIPs/issues/20
178 // ----------------------------------------------------------------------------
179 contract StandardToken is ERC20, BasicToken {
180   
181     mapping (address => mapping (address => uint256)) internal allowed;
182 
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     
192         emit Transfer(_from, _to, _value);
193     
194         return true;
195     }
196 
197     function approve(address _spender, uint256 _value) public returns (bool) {
198         allowed[msg.sender][_spender] = _value;
199     
200         emit Approval(msg.sender, _spender, _value);
201     
202         return true;
203     }
204 
205     function allowance(address _owner, address _spender) public view returns (uint256) {
206         return allowed[_owner][_spender];
207     }
208 
209     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
210         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
211     
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     
214         return true;
215     }
216 
217     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
218         uint256 oldValue = allowed[msg.sender][_spender];
219     
220         if (_subtractedValue > oldValue) {
221         allowed[msg.sender][_spender] = 0;
222         } else {
223         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224         }
225     
226         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227         return true;
228     }
229 }
230 // ----------------------------------------------------------------------------
231 // @title MultiTransfer Token
232 // @dev Only Admin
233 // ----------------------------------------------------------------------------
234 contract MultiTransferToken is StandardToken, Ownable {
235 
236     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
237         require(_to.length == _amount.length);
238 
239         uint256 ui;
240         uint256 amountSum = 0;
241     
242         for (ui = 0; ui < _to.length; ui++) {
243             require(_to[ui] != address(0));
244 
245             amountSum = amountSum.add(_amount[ui]);
246         }
247 
248         require(amountSum <= balances[msg.sender]);
249 
250         for (ui = 0; ui < _to.length; ui++) {
251             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
252             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
253         
254             emit Transfer(msg.sender, _to[ui], _amount[ui]);
255         }
256     
257         return true;
258     }
259 }
260 // ----------------------------------------------------------------------------
261 // @title Burnable Token
262 // @dev Token that can be irreversibly burned (destroyed).
263 // ----------------------------------------------------------------------------
264 contract BurnableToken is StandardToken, Ownable {
265 
266     event BurnAdminAmount(address indexed burner, uint256 value);
267 
268     function burnAdminAmount(uint256 _value) onlyOwner public {
269         require(_value <= balances[msg.sender]);
270 
271         balances[msg.sender] = balances[msg.sender].sub(_value);
272         totalSupply_ = totalSupply_.sub(_value);
273     
274         emit BurnAdminAmount(msg.sender, _value);
275         emit Transfer(msg.sender, address(0), _value);
276     }
277 }
278 // ----------------------------------------------------------------------------
279 // @title Mintable token
280 // @dev Simple ERC20 Token example, with mintable token creation
281 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
282 // ----------------------------------------------------------------------------
283 contract MintableToken is StandardToken, Ownable {
284     event Mint(address indexed to, uint256 amount);
285     event MintFinished();
286 
287     bool public mintingFinished = false;
288 
289     modifier canMint() { require(!mintingFinished); _; }
290 
291     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292         totalSupply_ = totalSupply_.add(_amount);
293         balances[_to] = balances[_to].add(_amount);
294     
295         emit Mint(_to, _amount);
296         emit Transfer(address(0), _to, _amount);
297     
298         return true;
299     }
300 
301     function finishMinting() onlyOwner canMint public returns (bool) {
302         mintingFinished = true;
303         emit MintFinished();
304         return true;
305     }
306 }
307 // ----------------------------------------------------------------------------
308 // @title Pausable token
309 // @dev StandardToken modified with pausable transfers.
310 // ----------------------------------------------------------------------------
311 contract PausableToken is StandardToken, Pausable, BlackList {
312 
313     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
314         return super.transfer(_to, _value);
315     }
316 
317     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
318         return super.transferFrom(_from, _to, _value);
319     }
320 
321     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
322         return super.approve(_spender, _value);
323     }
324 
325     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
326         return super.increaseApproval(_spender, _addedValue);
327     }
328 
329     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
330         return super.decreaseApproval(_spender, _subtractedValue);
331     }
332 }
333 // ----------------------------------------------------------------------------
334 // @Project RyuCoin (RC)
335 // @Creator Johnson Ryu (BlockSmith Developer)
336 // @Source Code Verification ()
337 // ----------------------------------------------------------------------------
338 contract HuHuRan is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
339     string public name = "후후란코인";
340     string public symbol = "HuHuRan";
341     uint256 public decimals = 18;
342 }