1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract ERC20Basic {
30     function totalSupply() public view returns (uint256);
31     function balanceOf(address who) public view returns (uint256);
32     function transfer(address to, uint256 value) public returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37     function allowance(address owner, address spender) public view returns (uint256);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function approve(address spender, uint256 value) public returns (bool);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) balances;
47 
48     uint256 totalSupply_;
49 
50     function totalSupply() public view returns (uint256) {
51         return totalSupply_;
52     }
53 
54     function transfer(address _to, uint256 _value) public returns (bool) {
55         require(_to != address(0));
56         require(_value <= balances[msg.sender]);
57 
58         balances[msg.sender] = balances[msg.sender].sub(_value);
59         balances[_to] = balances[_to].add(_value);
60 
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function balanceOf(address _owner) public view returns (uint256) {
66         return balances[_owner];
67     }
68 }
69 
70 contract Ownable {
71     address public owner;
72     address public operator;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
76 
77     constructor() public {
78         owner    = msg.sender;
79         operator = msg.sender;
80     }
81 
82     modifier onlyOwner() { require(msg.sender == owner); _; }
83     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
84 
85     function transferOwnership(address _newOwner) external onlyOwner {
86         require(_newOwner != address(0));
87         emit OwnershipTransferred(owner, _newOwner);
88         owner = _newOwner;
89     }
90 
91     function transferOperator(address _newOperator) external onlyOwner {
92         require(_newOperator != address(0));
93         emit OperatorTransferred(operator, _newOperator);
94         operator = _newOperator;
95     }
96 }
97 
98 contract BlackList is Ownable {
99     event Lock(address indexed LockedAddress);
100     event Unlock(address indexed UnLockedAddress);
101 
102     mapping( address => bool ) public blackList;
103 
104     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
105 
106     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
107         require(_lockAddress != address(0));
108         require(_lockAddress != owner);
109         require(blackList[_lockAddress] != true);
110 
111         blackList[_lockAddress] = true;
112 
113         emit Lock(_lockAddress);
114 
115         return true;
116     }
117 
118     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
119         require(blackList[_unlockAddress] != false);
120 
121         blackList[_unlockAddress] = false;
122 
123         emit Unlock(_unlockAddress);
124 
125         return true;
126     }
127 }
128 
129 contract Pausable is Ownable {
130     event Pause();
131     event Unpause();
132 
133     bool public paused = false;
134 
135     modifier whenNotPaused() { require(!paused); _; }
136     modifier whenPaused() { require(paused); _; }
137 
138     function pause() onlyOwnerOrOperator whenNotPaused public {
139         paused = true;
140         emit Pause();
141     }
142 
143     function unpause() onlyOwner whenPaused public {
144         paused = false;
145         emit Unpause();
146     }
147 }
148 
149 contract StandardToken is ERC20, BasicToken {
150     mapping (address => mapping (address => uint256)) internal allowed;
151 
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[_from]);
155         require(_value <= allowed[_from][msg.sender]);
156 
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160 
161         emit Transfer(_from, _to, _value);
162         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
163 
164         return true;
165     }
166 
167     function approve(address _spender, uint256 _value) public returns (bool) {
168         allowed[msg.sender][_spender] = _value;
169 
170         emit Approval(msg.sender, _spender, _value);
171 
172         return true;
173     }
174 
175     function allowance(address _owner, address _spender) public view returns (uint256) {
176         return allowed[_owner][_spender];
177     }
178 
179     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
180         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
181 
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183 
184         return true;
185     }
186 
187     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
188         uint256 oldValue = allowed[msg.sender][_spender];
189 
190         if (_subtractedValue > oldValue) {
191         allowed[msg.sender][_spender] = 0;
192         } else {
193         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
194         }
195 
196         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 }
200 
201 contract MultiTransferToken is StandardToken, Ownable {
202     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
203         require(_to.length == _amount.length);
204 
205         uint256 ui;
206         uint256 amountSum = 0;
207 
208         for (ui = 0; ui < _to.length; ui++) {
209             require(_to[ui] != address(0));
210             amountSum = amountSum.add(_amount[ui]);
211         }
212 
213         require(amountSum <= balances[msg.sender]);
214 
215         for (ui = 0; ui < _to.length; ui++) {
216             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
217             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
218 
219             emit Transfer(msg.sender, _to[ui], _amount[ui]);
220         }
221 
222         return true;
223     }
224 }
225 
226 contract BurnableToken is StandardToken, Ownable {
227 
228     event BurnAdminAmount(address indexed burner, uint256 value);
229 
230     function burnAdminAmount(uint256 _value) onlyOwner public {
231         require(_value <= balances[msg.sender]);
232 
233         balances[msg.sender] = balances[msg.sender].sub(_value);
234         totalSupply_ = totalSupply_.sub(_value);
235 
236         emit BurnAdminAmount(msg.sender, _value);
237         emit Transfer(msg.sender, address(0), _value);
238     }
239 }
240 
241 contract MintableToken is StandardToken, Ownable {
242     event Mint(address indexed to, uint256 amount);
243     event MintFinished();
244 
245     bool public mintingFinished = false;
246 
247     modifier canMint() { require(!mintingFinished); _; }
248 
249     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250         totalSupply_ = totalSupply_.add(_amount);
251         balances[_to] = balances[_to].add(_amount);
252 
253         emit Mint(_to, _amount);
254         emit Transfer(address(0), _to, _amount);
255 
256         return true;
257     }
258 
259     function finishMinting() onlyOwner canMint public returns (bool) {
260         mintingFinished = true;
261         emit MintFinished();
262         return true;
263     }
264 }
265 
266 contract PausableToken is StandardToken, Pausable, BlackList {
267 
268     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
269         return super.transfer(_to, _value);
270     }
271 
272     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
273         require(blackList[_from] != true);
274         require(blackList[_to] != true);
275 
276         return super.transferFrom(_from, _to, _value);
277     }
278 
279     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
280         return super.approve(_spender, _value);
281     }
282 
283     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
284         return super.increaseApproval(_spender, _addedValue);
285     }
286 
287     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
288         return super.decreaseApproval(_spender, _subtractedValue);
289     }
290 }
291 
292 contract UQT is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
293     string public name = "Unified Quantative Token";
294     string public symbol = "UQT";
295     uint256 public decimals = 18;
296 }