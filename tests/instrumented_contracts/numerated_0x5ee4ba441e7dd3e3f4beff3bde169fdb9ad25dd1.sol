1 pragma solidity 0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         if(a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns(uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     modifier onlyOwner() { require(msg.sender == owner); _; }
36 
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     function transferOwnership(address newOwner) public onlyOwner {
42         require(newOwner != address(0));
43         owner = newOwner;
44         OwnershipTransferred(owner, newOwner);
45     }
46 }
47 
48 contract Manageable is Ownable {
49     mapping(address => bool) public managers;
50 
51     event ManagerAdded(address indexed manager);
52     event ManagerRemoved(address indexed manager);
53 
54     modifier onlyManager() { require(managers[msg.sender]); _; }
55 
56     function addManager(address _manager) onlyOwner public {
57         require(_manager != address(0));
58 
59         managers[_manager] = true;
60 
61         ManagerAdded(_manager);
62     }
63 
64     function removeManager(address _manager) onlyOwner public {
65         require(_manager != address(0));
66 
67         managers[_manager] = false;
68 
69         ManagerRemoved(_manager);
70     }
71 }
72 
73 contract Withdrawable is Ownable {
74     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
75         require(_to != address(0));
76         require(this.balance >= _value);
77 
78         _to.transfer(_value);
79 
80         return true;
81     }
82 
83     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
84         require(_to != address(0));
85 
86         return _token.transfer(_to, _value);
87     }
88 }
89 
90 contract Pausable is Ownable {
91     bool public paused = false;
92 
93     event Pause();
94     event Unpause();
95 
96     modifier whenNotPaused() { require(!paused); _; }
97     modifier whenPaused() { require(paused); _; }
98 
99     function pause() onlyOwner whenNotPaused public {
100         paused = true;
101         Pause();
102     }
103 
104     function unpause() onlyOwner whenPaused public {
105         paused = false;
106         Unpause();
107     }
108 }
109 
110 contract ERC20 {
111     uint256 public totalSupply;
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 
116     function balanceOf(address who) public view returns(uint256);
117     function transfer(address to, uint256 value) public returns(bool);
118     function transferFrom(address from, address to, uint256 value) public returns(bool);
119     function allowance(address owner, address spender) public view returns(uint256);
120     function approve(address spender, uint256 value) public returns(bool);
121 }
122 
123 contract StandardToken is ERC20 {
124     using SafeMath for uint256;
125 
126     string public name;
127     string public symbol;
128     uint8 public decimals;
129 
130     mapping(address => uint256) balances;
131     mapping (address => mapping (address => uint256)) internal allowed;
132 
133     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
134         name = _name;
135         symbol = _symbol;
136         decimals = _decimals;
137     }
138 
139     function balanceOf(address _owner) public view returns(uint256 balance) {
140         return balances[_owner];
141     }
142 
143     function transfer(address _to, uint256 _value) public returns(bool) {
144         require(_to != address(0));
145         require(_value <= balances[msg.sender]);
146 
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149 
150         Transfer(msg.sender, _to, _value);
151 
152         return true;
153     }
154     
155     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
156         require(_to.length == _value.length);
157 
158         for(uint i = 0; i < _to.length; i++) {
159             transfer(_to[i], _value[i]);
160         }
161 
162         return true;
163     }
164 
165     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
166         require(_to != address(0));
167         require(_value <= balances[_from]);
168         require(_value <= allowed[_from][msg.sender]);
169 
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173 
174         Transfer(_from, _to, _value);
175 
176         return true;
177     }
178 
179     function allowance(address _owner, address _spender) public view returns(uint256) {
180         return allowed[_owner][_spender];
181     }
182 
183     function approve(address _spender, uint256 _value) public returns(bool) {
184         allowed[msg.sender][_spender] = _value;
185 
186         Approval(msg.sender, _spender, _value);
187 
188         return true;
189     }
190 
191     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
192         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193 
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195 
196         return true;
197     }
198 
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
200         uint oldValue = allowed[msg.sender][_spender];
201 
202         if(_subtractedValue > oldValue) {
203             allowed[msg.sender][_spender] = 0;
204         } else {
205             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
206         }
207 
208         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209 
210         return true;
211     }
212 }
213 
214 contract MintableToken is StandardToken, Ownable {
215     event Mint(address indexed to, uint256 amount);
216     event MintFinished();
217 
218     bool public mintingFinished = false;
219 
220     modifier canMint() { require(!mintingFinished); _; }
221 
222     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
223         totalSupply = totalSupply.add(_amount);
224         balances[_to] = balances[_to].add(_amount);
225 
226         Mint(_to, _amount);
227         Transfer(address(0), _to, _amount);
228 
229         return true;
230     }
231 
232     function finishMinting() onlyOwner canMint public returns(bool) {
233         mintingFinished = true;
234 
235         MintFinished();
236 
237         return true;
238     }
239 }
240 
241 contract CappedToken is MintableToken {
242     uint256 public cap;
243 
244     function CappedToken(uint256 _cap) public {
245         require(_cap > 0);
246         cap = _cap;
247     }
248 
249     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
250         require(totalSupply.add(_amount) <= cap);
251 
252         return super.mint(_to, _amount);
253     }
254 }
255 
256 contract BurnableToken is StandardToken {
257     event Burn(address indexed burner, uint256 value);
258 
259     function burn(uint256 _value) public {
260         require(_value <= balances[msg.sender]);
261 
262         address burner = msg.sender;
263 
264         balances[burner] = balances[burner].sub(_value);
265         totalSupply = totalSupply.sub(_value);
266 
267         Burn(burner, _value);
268     }
269 }
270 
271 contract Token is CappedToken, BurnableToken, Withdrawable {
272     function Token() CappedToken(2000000000 * 1 ether) StandardToken("GEX", "GEX", 18) public {
273         
274     }
275 }
276 
277 contract Crowdsale is Manageable, Withdrawable, Pausable {
278     using SafeMath for uint;
279 
280     Token public token;
281     bool public crowdsaleClosed = false;
282 
283     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
284     event CrowdsaleClose();
285    
286     function Crowdsale() public {
287         token = new Token();
288         token.mint(0xfd4fA7d9278Df3c80312000760FB6d4ba080D8ab, 200000000 * 1 ether);      // collaboration fund
289 		token.mint(0x6d4E06DBB835bcb00B598D7B38E393c34015f002, 100000000 * 1 ether);      // reserve fund
290         token.mint(0x0f21F25f82b9d08c551a8Ad44f2EaAABE65115c0, 200000000 * 1 ether);      // GridEx team
291         token.mint(0x3535fB6463A1607159387199e63088A07adD7BcA, 100000000 * 1 ether);      // marketing, PR, advisers
292 
293         addManager(0x6a5Fee685Bd0a74F64A922cc03987eC0BaB91324);
294     }
295 
296     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
297         token.mint(_to, _tokens);
298         ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
299     }
300 
301     function closeCrowdsale(address _to) onlyOwner public {
302         require(!crowdsaleClosed);
303 
304         token.finishMinting();
305         token.transferOwnership(_to);
306 
307         crowdsaleClosed = true;
308 
309         CrowdsaleClose();
310     }
311 }