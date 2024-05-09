1 pragma solidity ^0.4.25;
2 // ----------------------------------------------------------------------------
3 // @Name SafeMath
4 // @Desc Math operations with safety checks that throw on error
5 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6 // ----------------------------------------------------------------------------
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         
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
88     address public owner;
89     address public operator;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
93 
94     constructor() public {
95         owner    = msg.sender;
96         operator = msg.sender;
97     }
98 
99     modifier onlyOwner() { require(msg.sender == owner); _; }
100     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
101     
102     function transferOwnership(address _newOwner) external onlyOwner {
103         require(_newOwner != address(0));
104         emit OwnershipTransferred(owner, _newOwner);
105         owner = _newOwner;
106     }
107   
108     function transferOperator(address _newOperator) external onlyOwner {
109         require(_newOperator != address(0));
110         emit OperatorTransferred(operator, _newOperator);
111         operator = _newOperator;
112     }
113 }
114 // ----------------------------------------------------------------------------
115 // @title BlackList
116 // ----------------------------------------------------------------------------
117 contract BlackList is Ownable {
118 
119     event Lock(address indexed LockedAddress);
120     event Unlock(address indexed UnLockedAddress);
121 
122     mapping( address => bool ) public blackList;
123 
124     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
125 
126     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
127         require(_lockAddress != address(0));
128         require(_lockAddress != owner);
129         require(blackList[_lockAddress] != true);
130         
131         blackList[_lockAddress] = true;
132         
133         emit Lock(_lockAddress);
134 
135         return true;
136     }
137 
138     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
139         require(blackList[_unlockAddress] != false);
140         
141         blackList[_unlockAddress] = false;
142         
143         emit Unlock(_unlockAddress);
144 
145         return true;
146     }
147 }
148 // ----------------------------------------------------------------------------
149 // @title Pausable
150 // ----------------------------------------------------------------------------
151 contract Pausable is Ownable {
152     event Pause();
153     event Unpause();
154 
155     bool public paused = false;
156 
157     modifier whenNotPaused() { require(!paused); _; }
158     modifier whenPaused() { require(paused); _; }
159 
160     function pause() external onlyOwnerOrOperator whenNotPaused {
161         paused = true;
162         emit Pause();
163     }
164 
165     function unpause() external onlyOwner whenPaused {
166         paused = false;
167         emit Unpause();
168     }
169 }
170 // ----------------------------------------------------------------------------
171 // @title Standard ERC20 token
172 // @dev Implementation of the basic standard token.
173 // https://github.com/ethereum/EIPs/issues/20
174 // ----------------------------------------------------------------------------
175 contract StandardToken is ERC20, BasicToken {
176   
177     mapping (address => mapping (address => uint256)) internal allowed;
178 
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180         require(_to != address(0));
181         require(_value <= balances[_from]);
182         require(_value <= allowed[_from][msg.sender]);
183 
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     
188         emit Transfer(_from, _to, _value);
189     
190         return true;
191     }
192 
193     function approve(address _spender, uint256 _value) public returns (bool) {
194         allowed[msg.sender][_spender] = _value;
195     
196         emit Approval(msg.sender, _spender, _value);
197     
198         return true;
199     }
200 
201     function allowance(address _owner, address _spender) public view returns (uint256) {
202         return allowed[_owner][_spender];
203     }
204 
205     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
207     
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     
210         return true;
211     }
212 
213     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
214         uint256 oldValue = allowed[msg.sender][_spender];
215     
216         if (_subtractedValue > oldValue) {
217         allowed[msg.sender][_spender] = 0;
218         } else {
219         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220         }
221     
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 }
226 // ----------------------------------------------------------------------------
227 // @title MultiTransfer Token
228 // @dev Only Admin (for Airdrop Event)
229 // ----------------------------------------------------------------------------
230 contract MultiTransferToken is StandardToken, Ownable {
231 
232     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
233         require(_to.length == _amount.length);
234 
235         uint16 ui;
236         uint256 amountSum = 0;
237     
238         for (ui = 0; ui < _to.length; ui++) {
239             require(_to[ui] != address(0));
240 
241             amountSum = amountSum.add(_amount[ui]);
242         }
243 
244         require(amountSum <= balances[msg.sender]);
245 
246         for (ui = 0; ui < _to.length; ui++) {
247             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
248             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
249         
250             emit Transfer(msg.sender, _to[ui], _amount[ui]);
251         }
252     
253         return true;
254     }
255 }
256 // ----------------------------------------------------------------------------
257 // @title Burnable Token
258 // @dev Token that can be irreversibly burned (destroyed).
259 // ----------------------------------------------------------------------------
260 contract BurnableToken is StandardToken, Ownable {
261 
262     event BurnAdminAmount(address indexed burner, uint256 value);
263 
264     function burnAdminAmount(uint256 _value) onlyOwner public {
265         require(_value <= balances[msg.sender]);
266 
267         balances[msg.sender] = balances[msg.sender].sub(_value);
268         totalSupply_ = totalSupply_.sub(_value);
269     
270         emit BurnAdminAmount(msg.sender, _value);
271         emit Transfer(msg.sender, address(0), _value);
272     }
273 }
274 // ----------------------------------------------------------------------------
275 // @title Mintable token
276 // @dev Simple ERC20 Token example, with mintable token creation
277 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278 // ----------------------------------------------------------------------------
279 contract MintableToken is StandardToken, Ownable {
280     event Mint(address indexed to, uint256 amount);
281     event MintFinished();
282 
283     bool public mintingFinished = false;
284 
285     modifier canMint() { require(!mintingFinished); _; }
286 
287     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
288         totalSupply_ = totalSupply_.add(_amount);
289         balances[_to] = balances[_to].add(_amount);
290     
291         emit Mint(_to, _amount);
292         emit Transfer(address(0), _to, _amount);
293     
294         return true;
295     }
296 
297     function finishMinting() onlyOwner canMint public returns (bool) {
298         mintingFinished = true;
299         emit MintFinished();
300         return true;
301     }
302 }
303 // ----------------------------------------------------------------------------
304 // @title Pausable token
305 // @dev StandardToken modified with pausable transfers.
306 // ----------------------------------------------------------------------------
307 contract PausableToken is StandardToken, Pausable, BlackList {
308 
309     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
310         return super.transfer(_to, _value);
311     }
312 
313     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
314         return super.transferFrom(_from, _to, _value);
315     }
316 
317     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
318         return super.approve(_spender, _value);
319     }
320 
321     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
322         return super.increaseApproval(_spender, _addedValue);
323     }
324 
325     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
326         return super.decreaseApproval(_spender, _subtractedValue);
327     }
328 }
329 // ----------------------------------------------------------------------------
330 // @Project IN PAY TOKEN (IPT)
331 // @Creator Johnson Ryu (Blockchain Developer)
332 // @Source Code Verification (Noah Kim)
333 // ----------------------------------------------------------------------------
334 contract IPToken is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
335     string public name = "IN PAY TOKEN";
336     string public symbol = "IPT";
337     uint256 public decimals = 18;
338 }