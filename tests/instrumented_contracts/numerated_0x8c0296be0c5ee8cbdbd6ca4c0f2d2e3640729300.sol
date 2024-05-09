1 pragma solidity ^0.4.26;
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
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 // ----------------------------------------------------------------------------
34 // @title ERC20Basic
35 // @dev Simpler version of ERC20 interface
36 // See https://github.com/ethereum/EIPs/issues/179
37 // ----------------------------------------------------------------------------
38 contract ERC20Basic {
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 // ----------------------------------------------------------------------------
45 // @title ERC20 interface
46 // @dev See https://github.com/ethereum/EIPs/issues/20
47 // ----------------------------------------------------------------------------
48 contract ERC20 is ERC20Basic {
49     function allowance(address owner, address spender) public view returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool); 
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 // ----------------------------------------------------------------------------
55 // @title Basic token
56 // @dev Basic version of StandardToken, with no allowances.
57 // ----------------------------------------------------------------------------
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint256;
60 
61     mapping(address => uint256) balances;
62 
63     uint256 totalSupply_;
64 
65     function totalSupply() public view returns (uint256) {
66         return totalSupply_;
67     }
68 
69     function transfer(address _to, uint256 _value) public returns (bool) {
70         require(_to != address(0));
71         require(_value <= balances[msg.sender]);
72 
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75     
76         emit Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) public view returns (uint256) {
81         return balances[_owner];
82     }
83 }
84 // ----------------------------------------------------------------------------
85 // @title Ownable
86 // ----------------------------------------------------------------------------
87 contract Ownable {
88 
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
117 // @dev Base contract which allows children to implement an emergency stop mechanism.
118 // ----------------------------------------------------------------------------
119 contract BlackList is BasicToken, Ownable {
120 
121     event Lock(address indexed LockedAddress);
122     event Unlock(address indexed UnLockedAddress);
123     event DestroyedBlackFunds(address _blackListedUser, uint256 _balance);
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
150 
151     function DestroyBlackFunds (address _blackListedUser) external onlyOwner {
152         require(blackList[_blackListedUser] != false);
153 
154         uint256 dirtyFunds = balanceOf(_blackListedUser);
155         balances[_blackListedUser] = 0;
156 
157         totalSupply_ = totalSupply_.sub(dirtyFunds);
158 
159         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
160     }
161 }
162 // ----------------------------------------------------------------------------
163 // @title Pausable
164 // @dev Base contract which allows children to implement an emergency stop mechanism.
165 // ----------------------------------------------------------------------------
166 contract Pausable is Ownable {
167     event Pause();
168     event Unpause();
169 
170     bool public paused = false;
171 
172     modifier whenNotPaused() { require(!paused); _; }
173     modifier whenPaused() { require(paused); _; }
174 
175     function pause() onlyOwnerOrOperator whenNotPaused public {
176         paused = true;
177         emit Pause();
178     }
179 
180     function unpause() onlyOwner whenPaused public {
181         paused = false;
182         emit Unpause();
183     }
184 }
185 // ----------------------------------------------------------------------------
186 // @title Standard ERC20 token
187 // @dev Implementation of the basic standard token.
188 // https://github.com/ethereum/EIPs/issues/20
189 // ----------------------------------------------------------------------------
190 contract StandardToken is ERC20, BasicToken {
191   
192     mapping (address => mapping (address => uint256)) internal allowed;
193 
194     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195         require(_to != address(0));
196         require(_value <= balances[_from]);
197         require(_value <= allowed[_from][msg.sender]);
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     
203         emit Transfer(_from, _to, _value);
204     
205         return true;
206     }
207 
208     function approve(address _spender, uint256 _value) public returns (bool) {
209         allowed[msg.sender][_spender] = _value;
210     
211         emit Approval(msg.sender, _spender, _value);
212     
213         return true;
214     }
215 
216     function allowance(address _owner, address _spender) public view returns (uint256) {
217         return allowed[_owner][_spender];
218     }
219 
220     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
221         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
222     
223         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     
225         return true;
226     }
227 
228     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
229         uint256 oldValue = allowed[msg.sender][_spender];
230     
231         if (_subtractedValue > oldValue) {
232         allowed[msg.sender][_spender] = 0;
233         } else {
234         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235         }
236     
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         return true;
239     }
240 }
241 // ----------------------------------------------------------------------------
242 // @title Burnable Token
243 // @dev Token that can be irreversibly burned (destroyed).
244 // ----------------------------------------------------------------------------
245 contract BurnableToken is StandardToken, Ownable {
246 
247     event BurnAdminAmount(address indexed burner, uint256 value);
248 
249     function burnAdminAmount(uint256 _value) onlyOwner public {
250         require(_value <= balances[msg.sender]);
251 
252         balances[msg.sender] = balances[msg.sender].sub(_value);
253         totalSupply_ = totalSupply_.sub(_value);
254     
255         emit BurnAdminAmount(msg.sender, _value);
256         emit Transfer(msg.sender, address(0), _value);
257     }
258 }
259 // ----------------------------------------------------------------------------
260 // @title Mintable token
261 // @dev Simple ERC20 Token example, with mintable token creation
262 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
263 // ----------------------------------------------------------------------------
264 contract MintableToken is StandardToken, Ownable {
265     event Mint(address indexed to, uint256 amount);
266     event MintFinished();
267     event MintRestarted();
268 
269     bool public mintingFinished = false;
270 
271     modifier canMint() { require(!mintingFinished); _; }
272     modifier cantMint() { require(mintingFinished); _; }
273 
274     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
275         totalSupply_ = totalSupply_.add(_amount);
276         balances[_to] = balances[_to].add(_amount);
277     
278         emit Mint(_to, _amount);
279         emit Transfer(address(0), _to, _amount);
280     
281         return true;
282     }
283 
284     function finishMinting() onlyOwner canMint public returns (bool) {
285         mintingFinished = true;
286         emit MintFinished();
287         return true;
288     }
289     
290     function reStartMint() onlyOwner cantMint public returns (bool) {
291         mintingFinished = false;
292         emit MintRestarted();
293         return true;
294     }
295 }
296 // ----------------------------------------------------------------------------
297 // @title Pausable token
298 // @dev StandardToken modified with pausable transfers.
299 // ----------------------------------------------------------------------------
300 contract PausableToken is StandardToken, Pausable, BlackList {
301     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
302         return super.transfer(_to, _value);
303     }
304 
305     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
306         return super.transferFrom(_from, _to, _value);
307     }
308 
309     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
310         return super.approve(_spender, _value);
311     }
312 
313     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
314         return super.increaseApproval(_spender, _addedValue);
315     }
316 
317     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
318         return super.decreaseApproval(_spender, _subtractedValue);
319     }
320 }
321 // ----------------------------------------------------------------------------
322 // @Project Hashshare (HSS)
323 // ----------------------------------------------------------------------------
324 contract Hashshare is PausableToken, MintableToken, BurnableToken {
325     string public name = "Hashshare";
326     string public symbol = "HSS";
327     uint256 public decimals = 8;
328 }