1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5       if (a == 0) {
6           return 0;
7       }
8       uint256 c = a * b;
9       assert(c / a == b);
10       return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14       uint256 c = a / b;
15       return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19       assert(b <= a);
20       return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24       uint256 c = a + b;
25       assert(c >= a);
26       return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     function Ownable() public {
36       owner = msg.sender;
37     }
38 
39     modifier onlyOwner() {
40       require(msg.sender == owner);
41       _;
42     }
43 
44     function transferOwnership(address newOwner) public onlyOwner {
45       require(newOwner != address(0));
46 
47       OwnershipTransferred(owner, newOwner);
48       owner = newOwner;
49     }
50 }
51 
52 contract Authorizable {
53     mapping(address => bool) authorizers;
54 
55     modifier onlyAuthorized {
56       require(isAuthorized(msg.sender));
57       _;
58     }
59 
60     function Authorizable() public {
61       authorizers[msg.sender] = true;
62     }
63 
64 
65     function isAuthorized(address _addr) public constant returns(bool) {
66       require(_addr != address(0));
67 
68       bool result = bool(authorizers[_addr]);
69       return result;
70     }
71 
72     function addAuthorized(address _addr) external onlyAuthorized {
73       require(_addr != address(0));
74 
75       authorizers[_addr] = true;
76     }
77 
78     function delAuthorized(address _addr) external onlyAuthorized {
79       require(_addr != address(0));
80       require(_addr != msg.sender);
81 
82       //authorizers[_addr] = false;
83       delete authorizers[_addr];
84     }
85 }
86 
87 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
88 
89 contract ERC20Basic {
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract ERC20 is ERC20Basic {
97     function allowance(address owner, address spender) public view returns (uint256);
98     function transferFrom(address from, address to, uint256 value) public returns (bool);
99     function approve(address spender, uint256 value) public returns (bool);
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 contract BasicToken is ERC20Basic {
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) balances;
107 
108     uint256 totalSupply_;
109 
110     //modifier onlyPayloadSize(uint size) {
111     //  require(msg.data.length < size + 4);
112     //  _;
113     //}
114 
115     function totalSupply() public view returns (uint256) {
116       return totalSupply_;
117     }
118 
119     function transfer(address _to, uint256 _value) public returns (bool) {
120       //requeres in FrozenToken
121       //require(_to != address(0));
122       //require(_value <= balances[msg.sender]);
123 
124       balances[msg.sender] = balances[msg.sender].sub(_value);
125       balances[_to] = balances[_to].add(_value);
126       Transfer(msg.sender, _to, _value);
127       return true;
128     }
129 
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131       return balances[_owner];
132     }
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140       //requires in FrozenToken
141       //require(_to != address(0));
142       //require(_value <= balances[_from]);
143       //require(_value <= allowed[_from][msg.sender]);
144 
145       balances[_from] = balances[_from].sub(_value);
146       balances[_to] = balances[_to].add(_value);
147       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148       Transfer(_from, _to, _value);
149       return true;
150     }
151 
152     function approve(address _spender, uint256 _value) public returns (bool) {
153       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154       allowed[msg.sender][_spender] = _value;
155       Approval(msg.sender, _spender, _value);
156       return true;
157     }
158 
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160       return allowed[_owner][_spender];
161     }
162 
163     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166       return true;
167     }
168 
169     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
170       uint oldValue = allowed[msg.sender][_spender];
171       if (_subtractedValue > oldValue) {
172         allowed[msg.sender][_spender] = 0;
173       } else {
174         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175       }
176       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177       return true;
178     }
179 
180     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, this, _extraData);
184             return true;
185         }
186     }
187 }
188 
189 contract FrozenToken is StandardToken, Ownable {
190     mapping(address => bool) frozens;
191     mapping(address => uint256) frozenTokens;
192 
193     event FrozenAddress(address addr);
194     event UnFrozenAddress(address addr);
195     event FrozenTokenEvent(address addr, uint256 amount);
196     event UnFrozenTokenEvent(address addr, uint256 amount);
197 
198     modifier isNotFrozen() {
199       require(frozens[msg.sender] == false);
200       _;
201     }
202 
203     function frozenAddress(address _addr) onlyOwner public returns (bool) {
204       require(_addr != address(0));
205 
206       frozens[_addr] = true;
207       FrozenAddress(_addr);
208       return frozens[_addr];
209     }
210 
211     function unFrozenAddress(address _addr) onlyOwner public returns (bool) {
212       require(_addr != address(0));
213 
214       delete frozens[_addr];
215       //frozens[_addr] = false;
216       UnFrozenAddress(_addr);
217       return frozens[_addr];
218     }
219 
220     function isFrozenByAddress(address _addr) public constant returns(bool) {
221       require(_addr != address(0));
222 
223       bool result = bool(frozens[_addr]);
224       return result;
225     }
226 
227     function balanceFrozenTokens(address _addr) public constant returns(uint256) {
228       require(_addr != address(0));
229 
230       uint256 result = uint256(frozenTokens[_addr]);
231       return result;
232     }
233 
234     function balanceAvailableTokens(address _addr) public constant returns(uint256) {
235       require(_addr != address(0));
236 
237       uint256 frozen = uint256(frozenTokens[_addr]);
238       uint256 balance = uint256(balances[_addr]);
239       require(balance >= frozen);
240 
241       uint256 result = balance.sub(frozen);
242 
243       return result;
244     }
245 
246     function frozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
247       require(_addr != address(0));
248       require(_amount > 0);
249 
250       uint256 balance = uint256(balances[_addr]);
251       require(balance >= _amount);
252 
253       frozenTokens[_addr] = frozenTokens[_addr].add(_amount);
254       FrozenTokenEvent(_addr, _amount);
255       return true;
256     }
257     
258 
259     function unFrozenToken(address _addr, uint256 _amount) onlyOwner public returns(bool) {
260       require(_addr != address(0));
261       require(_amount > 0);
262       require(frozenTokens[_addr] >= _amount);
263 
264       frozenTokens[_addr] = frozenTokens[_addr].sub(_amount);
265       UnFrozenTokenEvent(_addr, _amount);
266       return true;
267     }
268 
269     function transfer(address _to, uint256 _value) isNotFrozen() public returns (bool) {
270       require(_to != address(0));
271       require(_value <= balances[msg.sender]);
272 
273       uint256 balance = balances[msg.sender];
274       uint256 frozen = frozenTokens[msg.sender];
275       uint256 availableBalance = balance.sub(frozen);
276       require(availableBalance >= _value);
277 
278       return super.transfer(_to, _value);
279     }
280 
281     function transferFrom(address _from, address _to, uint256 _value) isNotFrozen() public returns (bool) {
282       require(_to != address(0));
283       require(_value <= balances[_from]);
284       require(_value <= allowed[_from][msg.sender]);
285 
286       uint256 balance = balances[_from];
287       uint256 frozen = frozenTokens[_from];
288       uint256 availableBalance = balance.sub(frozen);
289       require(availableBalance >= _value);
290 
291       return super.transferFrom(_from ,_to, _value);
292     }
293 }
294 
295 contract MallcoinToken is FrozenToken, Authorizable {
296       string public constant name = "Mallcoin Token";
297       string public constant symbol = "MLC";
298       uint8 public constant decimals = 18;
299       uint256 public MAX_TOKEN_SUPPLY = 250000000 * 1 ether;
300 
301       event CreateToken(address indexed to, uint256 amount);
302       event CreateTokenByAtes(address indexed to, uint256 amount, string data);
303 
304       modifier onlyOwnerOrAuthorized {
305         require(msg.sender == owner || isAuthorized(msg.sender));
306         _;
307       }
308 
309       function createToken(address _to, uint256 _amount) onlyOwnerOrAuthorized public returns (bool) {
310         require(_to != address(0));
311         require(_amount > 0);
312         require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);
313 
314         totalSupply_ = totalSupply_.add(_amount);
315         balances[_to] = balances[_to].add(_amount);
316 
317         // KYC
318         frozens[_to] = true;
319         FrozenAddress(_to);
320 
321         CreateToken(_to, _amount);
322         Transfer(address(0), _to, _amount);
323         return true;
324       }
325 
326       function createTokenByAtes(address _to, uint256 _amount, string _data) onlyOwnerOrAuthorized public returns (bool) {
327         require(_to != address(0));
328         require(_amount > 0);
329         require(bytes(_data).length > 0);
330         require(MAX_TOKEN_SUPPLY >= totalSupply_ + _amount);
331 
332         totalSupply_ = totalSupply_.add(_amount);
333         balances[_to] = balances[_to].add(_amount);
334 
335         // KYC
336         frozens[_to] = true;
337         FrozenAddress(_to);
338 
339         CreateTokenByAtes(_to, _amount, _data);
340         Transfer(address(0), _to, _amount);
341         return true;
342       }
343 }