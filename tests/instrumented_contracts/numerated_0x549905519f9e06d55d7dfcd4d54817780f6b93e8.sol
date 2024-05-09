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
71 
72     address public owner;
73     address public operator;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
77 
78     constructor() public {
79         owner    = msg.sender;
80         operator = msg.sender;
81     }
82 
83     modifier onlyOwner() { require(msg.sender == owner); _; }
84     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
85 
86     function transferOwnership(address _newOwner) external onlyOwner {
87         require(_newOwner != address(0));
88         emit OwnershipTransferred(owner, _newOwner);
89         owner = _newOwner;
90     }
91 
92     function transferOperator(address _newOperator) external onlyOwner {
93         require(_newOperator != address(0));
94         emit OperatorTransferred(operator, _newOperator);
95         operator = _newOperator;
96     }
97 }
98 
99 contract LockupList is Ownable {
100 
101     event Lock(address indexed LockedAddress);
102     event Unlock(address indexed UnLockedAddress);
103 
104     mapping( address => bool ) public lockupList;
105 
106     modifier CheckLockupList { require(lockupList[msg.sender] != true); _; }
107 
108     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
109         require(_lockAddress != address(0));
110         require(_lockAddress != owner);
111         require(lockupList[_lockAddress] != true);
112 
113         lockupList[_lockAddress] = true;
114 
115         emit Lock(_lockAddress);
116 
117         return true;
118     }
119 
120     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
121         require(lockupList[_unlockAddress] != false);
122 
123         lockupList[_unlockAddress] = false;
124 
125         emit Unlock(_unlockAddress);
126 
127         return true;
128     }
129 }
130 
131 contract Pausable is Ownable {
132     event Pause();
133     event Unpause();
134 
135     bool public paused = false;
136 
137     modifier whenNotPaused() { require(!paused); _; }
138     modifier whenPaused() { require(paused); _; }
139 
140     function pause() onlyOwnerOrOperator whenNotPaused public {
141         paused = true;
142         emit Pause();
143     }
144 
145     function unpause() onlyOwner whenPaused public {
146         paused = false;
147         emit Unpause();
148     }
149 }
150 
151 contract StandardToken is ERC20, BasicToken {
152 
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163 
164         emit Transfer(_from, _to, _value);
165 
166         return true;
167     }
168 
169     function approve(address _spender, uint256 _value) public returns (bool) {
170         allowed[msg.sender][_spender] = _value;
171 
172         emit Approval(msg.sender, _spender, _value);
173 
174         return true;
175     }
176 
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180 
181     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
182         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
183 
184         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185 
186         return true;
187     }
188 
189     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
190         uint256 oldValue = allowed[msg.sender][_spender];
191 
192         if (_subtractedValue > oldValue) {
193         allowed[msg.sender][_spender] = 0;
194         } else {
195         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196         }
197 
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 }
202 
203 contract BurnableToken is StandardToken, Ownable {
204 
205     event BurnAdminAmount(address indexed burner, uint256 value);
206     event BurnLockupListAmount(address indexed burner, uint256 value);
207 
208     function burnAdminAmount(uint256 _value) onlyOwner public {
209         require(_value <= balances[msg.sender]);
210 
211         balances[msg.sender] = balances[msg.sender].sub(_value);
212         totalSupply_ = totalSupply_.sub(_value);
213 
214         emit BurnAdminAmount(msg.sender, _value);
215         emit Transfer(msg.sender, address(0), _value);
216     }
217 
218     function burnLockupListAmount(address _user, uint256 _value) onlyOwner public {
219         require(_value <= balances[_user]);
220 
221         balances[_user] = balances[_user].sub(_value);
222         totalSupply_ = totalSupply_.sub(_value);
223 
224         emit BurnLockupListAmount(_user, _value);
225         emit Transfer(_user, address(0), _value);
226     }
227 }
228 
229 contract MintableToken is StandardToken, Ownable {
230     event Mint(address indexed to, uint256 amount);
231     event MintFinished();
232 
233     bool public mintingFinished = false;
234 
235     modifier canMint() { require(!mintingFinished); _; }
236     modifier cantMint() { require(mintingFinished); _; }
237 
238     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
239         totalSupply_ = totalSupply_.add(_amount);
240         balances[_to] = balances[_to].add(_amount);
241 
242         emit Mint(_to, _amount);
243         emit Transfer(address(0), _to, _amount);
244 
245         return true;
246     }
247 
248     function finishMinting() onlyOwner canMint public returns (bool) {
249         mintingFinished = true;
250         emit MintFinished();
251         return true;
252     }
253 
254 }
255 
256 contract PausableToken is StandardToken, Pausable, LockupList {
257 
258     function transfer(address _to, uint256 _value) public whenNotPaused CheckLockupList returns (bool) {
259         return super.transfer(_to, _value);
260     }
261 
262     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckLockupList returns (bool) {
263         return super.transferFrom(_from, _to, _value);
264     }
265 
266     function approve(address _spender, uint256 _value) public whenNotPaused CheckLockupList returns (bool) {
267         return super.approve(_spender, _value);
268     }
269 
270     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckLockupList returns (bool success) {
271         return super.increaseApproval(_spender, _addedValue);
272     }
273 
274     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckLockupList returns (bool success) {
275         return super.decreaseApproval(_spender, _subtractedValue);
276     }
277 }
278 
279 contract TouchCon is PausableToken, MintableToken, BurnableToken {
280     string public name = "TouchCon";
281     string public symbol = "TOC";
282     uint256 public decimals = 18;
283 }