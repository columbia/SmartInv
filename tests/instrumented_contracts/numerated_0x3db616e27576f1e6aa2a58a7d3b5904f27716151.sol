1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 
31 contract ERC20Basic {
32     function totalSupply() public view returns (uint256);
33     function balanceOf(address who) public view returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic {
39     function allowance(address owner, address spender) public view returns (uint256);
40     function transferFrom(address from, address to, uint256 value) public returns (bool);
41     function approve(address spender, uint256 value) public returns (bool); 
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20Basic {
46     using SafeMath for uint256;
47 
48     mapping(address => uint256) balances;
49 
50     uint256 totalSupply_;
51 
52     function totalSupply() public view returns (uint256) {
53         return totalSupply_;
54     }
55 
56     function transfer(address _to, uint256 _value) public returns (bool) {
57         require(_to != address(0));
58         require(_value <= balances[msg.sender]);
59 
60         balances[msg.sender] = balances[msg.sender].sub(_value);
61         balances[_to] = balances[_to].add(_value);
62     
63         emit Transfer(msg.sender, _to, _value);
64         return true;
65     }
66 
67     function balanceOf(address _owner) public view returns (uint256) {
68         return balances[_owner];
69     }
70 }
71 
72 contract Ownable {
73     
74     address public owner;
75 
76     constructor() public {
77         owner    = msg.sender;
78     }
79 
80     modifier onlyOwner() { require(msg.sender == owner); _; }
81 }
82 
83 contract BlackList is Ownable {
84 
85     event Lock(address indexed LockedAddress);
86     event Unlock(address indexed UnLockedAddress);
87 
88     mapping( address => bool ) public blackList;
89 
90     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
91 
92     function SetLockAddress(address _lockAddress) external onlyOwner returns (bool) {
93         require(_lockAddress != address(0));
94         require(_lockAddress != owner);
95         require(blackList[_lockAddress] != true);
96         
97         blackList[_lockAddress] = true;
98         
99         emit Lock(_lockAddress);
100 
101         return true;
102     }
103 
104     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
105         require(blackList[_unlockAddress] != false);
106         
107         blackList[_unlockAddress] = false;
108         
109         emit Unlock(_unlockAddress);
110 
111         return true;
112     }
113 }
114 
115 contract Pausable is Ownable {
116     event Pause();
117     event Unpause();
118 
119     bool public paused = false;
120 
121     modifier whenNotPaused() { require(!paused); _; }
122     modifier whenPaused() { require(paused); _; }
123 
124     function pause() onlyOwner whenNotPaused public {
125         paused = true;
126         emit Pause();
127     }
128 
129     function unpause() onlyOwner whenPaused public {
130         paused = false;
131         emit Unpause();
132     }
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136   
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140         require(_to != address(0));
141         require(_value <= balances[_from]);
142         require(_value <= allowed[_from][msg.sender]);
143 
144         balances[_from] = balances[_from].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     
148         emit Transfer(_from, _to, _value);
149     
150         return true;
151     }
152 
153     function approve(address _spender, uint256 _value) public returns (bool) {
154         allowed[msg.sender][_spender] = _value;
155     
156         emit Approval(msg.sender, _spender, _value);
157     
158         return true;
159     }
160 
161     function allowance(address _owner, address _spender) public view returns (uint256) {
162         return allowed[_owner][_spender];
163     }
164 
165     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
166         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
167     
168         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     
170         return true;
171     }
172 
173     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
174         uint256 oldValue = allowed[msg.sender][_spender];
175     
176         if (_subtractedValue > oldValue) {
177         allowed[msg.sender][_spender] = 0;
178         } else {
179         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180         }
181     
182         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183         return true;
184     }
185 }
186 
187 contract MultiTransferToken is StandardToken, Ownable {
188 
189     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
190         require(_to.length == _amount.length);
191 
192         uint256 ui;
193         uint256 amountSum = 0;
194     
195         for (ui = 0; ui < _to.length; ui++) {
196             require(_to[ui] != address(0));
197 
198             amountSum = amountSum.add(_amount[ui]);
199         }
200 
201         require(amountSum <= balances[msg.sender]);
202 
203         for (ui = 0; ui < _to.length; ui++) {
204             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
205             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
206         
207             emit Transfer(msg.sender, _to[ui], _amount[ui]);
208         }
209     
210         return true;
211     }
212 }
213 
214 contract BurnableToken is StandardToken, Ownable {
215 
216     event BurnAdminAmount(address indexed burner, uint256 value);
217 
218     function burnAdminAmount(uint256 _value) onlyOwner public {
219         require(_value <= balances[msg.sender]);
220 
221         balances[msg.sender] = balances[msg.sender].sub(_value);
222         totalSupply_ = totalSupply_.sub(_value);
223     
224         emit BurnAdminAmount(msg.sender, _value);
225         emit Transfer(msg.sender, address(0), _value);
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
236     modifier cannotMint() { require(mintingFinished); _; }
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
253 }
254 
255 contract PausableToken is StandardToken, Pausable, BlackList {
256 
257     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
258         return super.transfer(_to, _value);
259     }
260 
261     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
262         return super.transferFrom(_from, _to, _value);
263     }
264 
265     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
266         return super.approve(_spender, _value);
267     }
268 
269     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
270         return super.increaseApproval(_spender, _addedValue);
271     }
272 
273     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
274         return super.decreaseApproval(_spender, _subtractedValue);
275     }
276 }
277 // ----------------------------------------------------------------------------
278 // @Project Community 활성화를 위한상평통보
279 // @Creator Ryan_KIM
280 // @Source 
281 // ----------------------------------------------------------------------------
282 contract Sangpyeongtongbo is PausableToken, MintableToken, BurnableToken, MultiTransferToken {
283     string public name = "Sangpyeongtongbo";
284     string public symbol = "SPTB";
285     uint256 public decimals = 18;
286 }