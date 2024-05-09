1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------------------------------
4 // @title SafeMath
5 // @dev Math operations with safety checks that throw on error
6 // @dev see https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7 // ----------------------------------------------------------------------------------------------------
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
34 
35 // ----------------------------------------------------------------------------------------------------
36 // @title ERC20Basic
37 // @dev Simpler version of ERC20 interface
38 // @dev See https://github.com/ethereum/EIPs/issues/179
39 // ----------------------------------------------------------------------------------------------------
40 contract ERC20Basic {
41     function totalSupply() public view returns (uint256);
42     function balanceOf(address who) public view returns (uint256);
43     function transfer(address to, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 // ----------------------------------------------------------------------------------------------------
48 // @title ERC20 interface
49 // @dev See https://github.com/ethereum/EIPs/issues/20
50 // ----------------------------------------------------------------------------------------------------
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public view returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool); 
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 // ----------------------------------------------------------------------------------------------------
59 // @title Basic token
60 // @dev Basic version of StandardToken, with no allowances.
61 // ----------------------------------------------------------------------------------------------------
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) balances;
66 
67     uint256 totalSupply_;
68 
69     function totalSupply() public view returns (uint256) {
70         return totalSupply_;
71     }
72 
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79     
80         emit Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256) {
85         return balances[_owner];
86     }
87 }
88 
89 // ----------------------------------------------------------------------------------------------------
90 // @title Ownable
91 // ----------------------------------------------------------------------------------------------------
92 contract Ownable {
93     // Development Team Leader
94     address public owner;
95 
96     constructor() public {
97         owner = msg.sender;
98     }
99 
100     modifier onlyOwner() { require(msg.sender == owner); _; }
101 }
102 
103 // ----------------------------------------------------------------------------------------------------
104 // @title BlackList
105 // @dev Base contract which allows children to implement an emergency stop mechanism.
106 // ----------------------------------------------------------------------------------------------------
107 contract BlackList is Ownable {
108 
109     event Lock(address indexed LockedAddress);
110     event Unlock(address indexed UnLockedAddress);
111 
112     mapping( address => bool ) public blackList;
113 
114     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
115 
116     function SetLockAddress(address _lockAddress) external onlyOwner returns (bool) {
117         require(_lockAddress != address(0));
118         require(_lockAddress != owner);
119         require(blackList[_lockAddress] != true);
120         
121         blackList[_lockAddress] = true;
122         
123         emit Lock(_lockAddress);
124 
125         return true;
126     }
127 
128     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
129         require(blackList[_unlockAddress] != false);
130         
131         blackList[_unlockAddress] = false;
132         
133         emit Unlock(_unlockAddress);
134 
135         return true;
136     }
137 }
138 
139 // ----------------------------------------------------------------------------------------------------
140 // @title Pausable
141 // @dev Base contract which allows children to implement an emergency stop mechanism.
142 // ----------------------------------------------------------------------------------------------------
143 contract Pausable is Ownable {
144 
145     event Pause();
146     event Unpause();
147 
148     bool public paused = false;
149 
150     modifier whenNotPaused() { require(!paused); _; }
151     modifier whenPaused() { require(paused); _; }
152 
153     function pause() onlyOwner whenNotPaused public {
154         paused = true;
155         emit Pause();
156     }
157 
158     function unpause() onlyOwner whenPaused public {
159         paused = false;
160         emit Unpause();
161     }
162 }
163 
164 // ----------------------------------------------------------------------------------------------------
165 // @title Standard ERC20 token
166 // @dev Implementation of the basic standard token.
167 // @dev see https://github.com/ethereum/EIPs/issues/20
168 // ----------------------------------------------------------------------------------------------------
169 contract StandardToken is ERC20, BasicToken {
170 
171     mapping (address => mapping (address => uint256)) internal allowed;
172 
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174         require(_to != address(0));
175         require(_value <= balances[_from]);
176         require(_value <= allowed[_from][msg.sender]);
177 
178         balances[_from] = balances[_from].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     
182         emit Transfer(_from, _to, _value);
183     
184         return true;
185     }
186 
187     function approve(address _spender, uint256 _value) public returns (bool) {
188         allowed[msg.sender][_spender] = _value;
189     
190         emit Approval(msg.sender, _spender, _value);
191     
192         return true;
193     }
194 
195     function allowance(address _owner, address _spender) public view returns (uint256) {
196         return allowed[_owner][_spender];
197     }
198 
199     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
200         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
201     
202         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     
204         return true;
205     }
206 
207     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
208         uint256 oldValue = allowed[msg.sender][_spender];
209     
210         if (_subtractedValue > oldValue) {
211         allowed[msg.sender][_spender] = 0;
212         } else {
213         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215     
216         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217         return true;
218     }
219 }
220 
221 // ----------------------------------------------------------------------------------------------------
222 // @title MultiTransfer Token
223 // @dev Only Admin
224 // ----------------------------------------------------------------------------------------------------
225 contract MultiTransferToken is StandardToken, Ownable {
226 
227     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
228         require(_to.length == _amount.length);
229 
230         uint256 ui;
231         uint256 amountSum = 0;
232     
233         for (ui = 0; ui < _to.length; ui++) {
234             require(_to[ui] != address(0));
235 
236             amountSum = amountSum.add(_amount[ui]);
237         }
238 
239         require(amountSum <= balances[msg.sender]);
240 
241         for (ui = 0; ui < _to.length; ui++) {
242             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
243             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
244         
245             emit Transfer(msg.sender, _to[ui], _amount[ui]);
246         }
247     
248         return true;
249     }
250 }
251 
252 // ----------------------------------------------------------------------------------------------------
253 // @title Burnable Token
254 // @dev Token that can be irreversibly burned (destroyed).
255 // ----------------------------------------------------------------------------------------------------
256 contract BurnableToken is StandardToken, Ownable {
257 
258     event BurnAdminAmount(address indexed burner, uint256 value);
259 
260     function burnAdminAmount(uint256 _value) onlyOwner public {
261         require(_value <= balances[msg.sender]);
262 
263         balances[msg.sender] = balances[msg.sender].sub(_value);
264         totalSupply_ = totalSupply_.sub(_value);
265     
266         emit BurnAdminAmount(msg.sender, _value);
267         emit Transfer(msg.sender, address(0), _value);
268     }
269 }
270 
271 // ----------------------------------------------------------------------------------------------------
272 // @title Mintable token
273 // @dev Simple ERC20 Token example, with mintable token creation
274 // @dev Based on https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
275 // ----------------------------------------------------------------------------------------------------
276 contract MintableToken is StandardToken, Ownable {
277 
278     event Mint(address indexed to, uint256 amount);
279     event MintFinished();
280 
281     bool public mintingFinished = false;
282 
283     modifier canMint() { require(!mintingFinished); _; }
284     modifier cannotMint() { require(mintingFinished); _; }
285 
286     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
287         totalSupply_ = totalSupply_.add(_amount);
288         balances[_to] = balances[_to].add(_amount);
289     
290         emit Mint(_to, _amount);
291         emit Transfer(address(0), _to, _amount);
292     
293         return true;
294     }
295 
296     function finishMinting() onlyOwner canMint public returns (bool) {
297         mintingFinished = true;
298         emit MintFinished();
299         return true;
300     }
301 }
302 
303 // ----------------------------------------------------------------------------------------------------
304 // @title Pausable token
305 // @dev StandardToken modified with pausable transfers.
306 // ----------------------------------------------------------------------------------------------------
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
329 
330 // ----------------------------------------------------------------------------------------------------
331 // @Project Victory Rocket
332 // @Creator TIBS Korea
333 // ----------------------------------------------------------------------------------------------------
334 contract VketCoin is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
335 
336     string public name = "vKet";
337     string public symbol = "KET";
338     uint256 public decimals = 18;
339 
340 }