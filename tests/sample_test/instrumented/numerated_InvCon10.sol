1 1 pragma solidity ^0.4.24;
2 
3 
4 2 library SafeMath {
5     
6 3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7 4         if (a == 0) {
8 5             return 0;
9 6         }
10 7         uint256 c = a * b;
11 8         assert(c / a == b);
12 9         return c;
13 10     }
14 
15 11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 12         return a / b;
17 13     }
18 
19 14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20 15         assert(b <= a);
21 16         return a - b;
22 17     }
23 
24 18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25 19         uint256 c = a + b;
26 20         assert(c >= a);
27 21         return c;
28 22     }
29 23 }
30 
31 24 contract ERC20Basic {
32 25     function totalSupply() public view returns (uint256);
33 26     function balanceOf(address who) public view returns (uint256);
34 27     function transfer(address to, uint256 value) public returns (bool);
35 28     event Transfer(address indexed from, address indexed to, uint256 value);
36 29 }
37 
38 30 contract ERC20 is ERC20Basic {
39 31     function allowance(address owner, address spender) public view returns (uint256);
40 32     function transferFrom(address from, address to, uint256 value) public returns (bool);
41 33     function approve(address spender, uint256 value) public returns (bool); 
42 34     event Approval(address indexed owner, address indexed spender, uint256 value);
43 35 }
44 
45 36 contract BasicToken is ERC20Basic {
46 37     using SafeMath for uint256;
47 
48 38     mapping(address => uint256) balances;
49 
50 39     uint256 totalSupply_;
51 
52 40     function totalSupply() public view returns (uint256) {
53 41         return totalSupply_;
54 42     }
55 
56 43     function transfer(address _to, uint256 _value) public returns (bool) {
57 44         require(_to != address(0));
58 45         require(_value <= balances[msg.sender]);
59 
60 46         balances[msg.sender] = balances[msg.sender].sub(_value);
61 47         balances[_to] = balances[_to].add(_value);
62     
63 48         emit Transfer(msg.sender, _to, _value);
64 49         return true;
65 50     }
66 
67 51     function balanceOf(address _owner) public view returns (uint256) {
68 52         return balances[_owner];
69 53     }
70 54 }
71 
72 55 contract Ownable {
73 
74 56     address public owner;
75 57     address public operator;
76 
77 58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 59     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
79 
80 60     constructor() public {
81 61         owner    = msg.sender;
82 62         operator = msg.sender;
83 63     }
84 
85 64     modifier onlyOwner() { require(msg.sender == owner); _; }
86 65     modifier onlyOwnerOrOperator() { require(msg.sender == owner || msg.sender == operator); _; }
87 
88 66     function transferOwnership(address _newOwner) external onlyOwner {
89 67         require(_newOwner != address(0));
90 68         emit OwnershipTransferred(owner, _newOwner);
91 69         owner = _newOwner;
92 70     }
93   
94 71     function transferOperator(address _newOperator) external onlyOwner {
95 72         require(_newOperator != address(0));
96 73         emit OperatorTransferred(operator, _newOperator);
97 74         operator = _newOperator;
98 75     }
99 76 }
100 
101 77 contract BlackList is Ownable {
102 
103 78     event Lock(address indexed LockedAddress);
104 79     event Unlock(address indexed UnLockedAddress);
105 
106 80     mapping( address => bool ) public blackList;
107 
108 81     modifier CheckBlackList { require(blackList[msg.sender] != true); _; }
109 
110 82     function SetLockAddress(address _lockAddress) external onlyOwnerOrOperator returns (bool) {
111 83         require(_lockAddress != address(0));
112 84         require(_lockAddress != owner);
113 85         require(blackList[_lockAddress] != true);
114         
115 86         blackList[_lockAddress] = true;
116         
117 87         emit Lock(_lockAddress);
118 
119 88         return true;
120 89     }
121 
122 90     function UnLockAddress(address _unlockAddress) external onlyOwner returns (bool) {
123 91         require(blackList[_unlockAddress] != false);
124         
125 92         blackList[_unlockAddress] = false;
126         
127 93         emit Unlock(_unlockAddress);
128 
129 94         return true;
130 95     }
131 96 }
132 
133 97 contract Pausable is Ownable {
134 98     event Pause();
135 99     event Unpause();
136 
137 100     bool public paused = false;
138 
139 101     modifier whenNotPaused() { require(!paused); _; }
140 102     modifier whenPaused() { require(paused); _; }
141 
142 103     function pause() onlyOwnerOrOperator whenNotPaused public {
143 104         paused = true;
144 105         emit Pause();
145 106     }
146 
147 107     function unpause() onlyOwner whenPaused public {
148 108         paused = false;
149 109         emit Unpause();
150 110     }
151 111 }
152 
153 112 contract StandardToken is ERC20, BasicToken {
154   
155 113     mapping (address => mapping (address => uint256)) internal allowed;
156 
157 114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158 115         require(_to != address(0));
159 116         require(_value <= balances[_from]);
160 117         require(_value <= allowed[_from][msg.sender]);
161 
162 118         balances[_from] = balances[_from].sub(_value);
163 119         balances[_to] = balances[_to].add(_value);
164 120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     
166 121         emit Transfer(_from, _to, _value);
167 122         emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
168     
169 123         return true;
170 124     }
171 
172 125     function approve(address _spender, uint256 _value) public returns (bool) {
173 126         allowed[msg.sender][_spender] = _value;
174     
175 127         emit Approval(msg.sender, _spender, _value);
176     
177 128         return true;
178 129     }
179 
180 130     function allowance(address _owner, address _spender) public view returns (uint256) {
181 131         return allowed[_owner][_spender];
182 132     }
183 
184 133     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
185 134         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
186     
187 135         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     
189 136         return true;
190 137     }
191 
192 138     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
193 139         uint256 oldValue = allowed[msg.sender][_spender];
194     
195 140         if (_subtractedValue > oldValue) {
196 141             allowed[msg.sender][_spender] = 0;
197 142         } else {
198 143             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199 144         }
200     
201 145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202 146         return true;
203 147     }
204 148 }
205 
206 149 contract MultiTransferToken is StandardToken, Ownable {
207 
208 150     function MultiTransfer(address[] _to, uint256[] _amount) onlyOwner public returns (bool) {
209 151         require(_to.length == _amount.length);
210 
211 152         uint256 ui;
212 153         uint256 amountSum = 0;
213     
214 154         for (ui = 0; ui < _to.length; ui++) {
215 155             require(_to[ui] != address(0));
216 
217 156             amountSum = amountSum.add(_amount[ui]);
218 157         }
219 
220 158         require(amountSum <= balances[msg.sender]);
221 
222 159         for (ui = 0; ui < _to.length; ui++) {
223 160             balances[msg.sender] = balances[msg.sender].sub(_amount[ui]);
224 161             balances[_to[ui]] = balances[_to[ui]].add(_amount[ui]);
225         
226 162             emit Transfer(msg.sender, _to[ui], _amount[ui]);
227 163         }
228     
229 164         return true;
230 165     }
231 166 }
232 
233 167 contract BurnableToken is StandardToken, Ownable {
234 
235 168     event BurnAdminAmount(address indexed burner, uint256 value);
236 
237 169     function burnAdminAmount(uint256 _value) onlyOwner public {
238 170         require(_value <= balances[msg.sender]);
239 
240 171         balances[msg.sender] = balances[msg.sender].sub(_value);
241 172         totalSupply_ = totalSupply_.sub(_value);
242     
243 173         emit BurnAdminAmount(msg.sender, _value);
244 174         emit Transfer(msg.sender, address(0), _value);
245 175     }
246 176 }
247 
248 177 contract MintableToken is StandardToken, Ownable {
249 178     event Mint(address indexed to, uint256 amount);
250 179     event MintFinished();
251 
252 180     bool public mintingFinished = false;
253 
254 181     modifier canMint() { require(!mintingFinished); _; }
255 
256 182     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
257 183         totalSupply_ = totalSupply_.add(_amount);
258 184         balances[_to] = balances[_to].add(_amount);
259     
260 185         emit Mint(_to, _amount);
261 186         emit Transfer(address(0), _to, _amount);
262     
263 187         return true;
264 188     }
265 
266 189     function finishMinting() onlyOwner canMint public returns (bool) {
267 190         mintingFinished = true;
268 191         emit MintFinished();
269 192         return true;
270 193     }
271 194 }
272 
273 195 contract PausableToken is StandardToken, Pausable, BlackList {
274 
275 196     function transfer(address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
276 197         return super.transfer(_to, _value);
277 198     }
278 
279 199     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
280 200         require(blackList[_from] != true);
281 201         require(blackList[_to] != true);
282 
283 202         return super.transferFrom(_from, _to, _value);
284 203     }
285 
286 204     function approve(address _spender, uint256 _value) public whenNotPaused CheckBlackList returns (bool) {
287 205         return super.approve(_spender, _value);
288 206     }
289 
290 207     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused CheckBlackList returns (bool success) {
291 208         return super.increaseApproval(_spender, _addedValue);
292 209     }
293 
294 210     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused CheckBlackList returns (bool success) {
295 211         return super.decreaseApproval(_spender, _subtractedValue);
296 212     }
297 213 }