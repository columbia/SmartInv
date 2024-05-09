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
89     // Development Team Leader
90     address public owner;
91 
92     constructor() public {
93         owner    = msg.sender;
94     }
95 
96     modifier onlyOwner() { require(msg.sender == owner); _; }
97 }
98 // ----------------------------------------------------------------------------
99 // @title BlackList
100 // @dev Base contract which allows children to implement an emergency stop mechanism.
101 // ----------------------------------------------------------------------------
102 contract BlackList is Ownable {
103 
104     event Lock(address indexed LockedAddress);
105     event Unlock(address indexed UnLockedAddress);
106 
107     mapping( address => bool ) public blackList;
108 
109     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
110 
111     function SetLockAddress(address _lockAddress) external onlyOwner returns (bool) {
112         require(_lockAddress != address(0));
113         require(_lockAddress != owner);
114         require(blackList[_lockAddress] != true);
115         
116         blackList[_lockAddress] = true;
117         
118         emit Lock(_lockAddress);
119 
120         return true;
121     }
122 
123     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
124         require(blackList[_unlockAddress] != false);
125         
126         blackList[_unlockAddress] = false;
127         
128         emit Unlock(_unlockAddress);
129 
130         return true;
131     }
132 }
133 // ----------------------------------------------------------------------------
134 // @title Pausable
135 // @dev Base contract which allows children to implement an emergency stop mechanism.
136 // ----------------------------------------------------------------------------
137 contract Pausable is Ownable {
138     event Pause();
139     event Unpause();
140 
141     bool public paused = false;
142 
143     modifier whenNotPaused() { require(!paused); _; }
144     modifier whenPaused() { require(paused); _; }
145 
146     function pause() onlyOwner whenNotPaused public {
147         paused = true;
148         emit Pause();
149     }
150 
151     function unpause() onlyOwner whenPaused public {
152         paused = false;
153         emit Unpause();
154     }
155 }
156 // ----------------------------------------------------------------------------
157 // @title Standard ERC20 token
158 // @dev Implementation of the basic standard token.
159 // https://github.com/ethereum/EIPs/issues/20
160 // ----------------------------------------------------------------------------
161 contract StandardToken is ERC20, BasicToken {
162   
163     mapping (address => mapping (address => uint256)) internal allowed;
164 
165     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166         require(_to != address(0));
167         require(_value <= balances[_from]);
168         require(_value <= allowed[_from][msg.sender]);
169 
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     
174         emit Transfer(_from, _to, _value);
175     
176         return true;
177     }
178 
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181     
182         emit Approval(msg.sender, _spender, _value);
183     
184         return true;
185     }
186 
187     function allowance(address _owner, address _spender) public view returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190 
191     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
192         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
193     
194         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     
196         return true;
197     }
198 
199     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
200         uint256 oldValue = allowed[msg.sender][_spender];
201     
202         if (_subtractedValue > oldValue) {
203         allowed[msg.sender][_spender] = 0;
204         } else {
205         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207     
208         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209         return true;
210     }
211 }
212 // ----------------------------------------------------------------------------
213 // @title MultiTransfer Token
214 // @dev Only Admin
215 // ----------------------------------------------------------------------------
216 contract MultiTransferToken is StandardToken, Ownable {
217 
218     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
219         require(_to.length == _amount.length);
220 
221         uint256 ui;
222         uint256 amountSum = 0;
223     
224         for (ui = 0; ui < _to.length; ui++) {
225             require(_to[ui] != address(0));
226 
227             amountSum = amountSum.add(_amount[ui]);
228         }
229 
230         require(amountSum <= balances[msg.sender]);
231 
232         for (ui = 0; ui < _to.length; ui++) {
233             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
234             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
235         
236             emit Transfer(msg.sender, _to[ui], _amount[ui]);
237         }
238     
239         return true;
240     }
241 }
242 // ----------------------------------------------------------------------------
243 // @title Burnable Token
244 // @dev Token that can be irreversibly burned (destroyed).
245 // ----------------------------------------------------------------------------
246 contract BurnableToken is StandardToken, Ownable {
247 
248     event BurnAdminAmount(address indexed burner, uint256 value);
249 
250     function burnAdminAmount(uint256 _value) onlyOwner public {
251         require(_value <= balances[msg.sender]);
252 
253         balances[msg.sender] = balances[msg.sender].sub(_value);
254         totalSupply_ = totalSupply_.sub(_value);
255     
256         emit BurnAdminAmount(msg.sender, _value);
257         emit Transfer(msg.sender, address(0), _value);
258     }
259 }
260 // ----------------------------------------------------------------------------
261 // @title Mintable token
262 // @dev Simple ERC20 Token example, with mintable token creation
263 // Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
264 // ----------------------------------------------------------------------------
265 contract MintableToken is StandardToken, Ownable {
266     event Mint(address indexed to, uint256 amount);
267     event MintFinished();
268 
269     bool public mintingFinished = false;
270 
271     modifier canMint() { require(!mintingFinished); _; }
272     modifier cannotMint() { require(mintingFinished); _; }
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
289 }
290 // ----------------------------------------------------------------------------
291 // @title Pausable token
292 // @dev StandardToken modified with pausable transfers.
293 // ----------------------------------------------------------------------------
294 contract PausableToken is StandardToken, Pausable, BlackList {
295 
296     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
297         return super.transfer(_to, _value);
298     }
299 
300     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
301         return super.transferFrom(_from, _to, _value);
302     }
303 
304     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
305         return super.approve(_spender, _value);
306     }
307 
308     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
309         return super.increaseApproval(_spender, _addedValue);
310     }
311 
312     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
313         return super.decreaseApproval(_spender, _subtractedValue);
314     }
315 }
316 // ----------------------------------------------------------------------------
317 // @Project 
318 // @Creator
319 // @Source
320 // ----------------------------------------------------------------------------
321 contract kimjunyong is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
322     string public name = "김준용임경진";
323     string public symbol = "KJY";
324     uint256 public decimals = 18;
325 }