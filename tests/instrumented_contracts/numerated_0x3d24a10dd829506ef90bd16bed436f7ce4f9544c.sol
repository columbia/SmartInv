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
49     address[] public managers;
50 
51     event ManagerAdded(address indexed manager);
52     event ManagerRemoved(address indexed manager);
53 
54     modifier onlyManager() { require(isManager(msg.sender)); _; }
55 
56     function countManagers() view public returns(uint) {
57         return managers.length;
58     }
59 
60     function getManagers() view public returns(address[]) {
61         return managers;
62     }
63 
64     function isManager(address _manager) view public returns(bool) {
65         for(uint i = 0; i < managers.length; i++) {
66             if(managers[i] == _manager) {
67                 return true;
68             }
69         }
70         return false;
71     }
72 
73     function addManager(address _manager) onlyOwner public {
74         require(_manager != address(0));
75         require(!isManager(_manager));
76 
77         managers.push(_manager);
78 
79         ManagerAdded(_manager);
80     }
81 
82     function removeManager(address _manager) onlyOwner public {
83         require(isManager(_manager));
84 
85         uint index = 0;
86         for(uint i = 0; i < managers.length; i++) {
87             if(managers[i] == _manager) {
88                 index = i;
89             }
90         }
91 
92         for(; index < managers.length - 1; index++) {
93             managers[index] = managers[index + 1];
94         }
95         
96         managers.length--;
97         ManagerRemoved(_manager);
98     }
99 }
100 
101 contract Withdrawable is Ownable {
102     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
103         require(_to != address(0));
104         require(this.balance >= _value);
105 
106         _to.transfer(_value);
107 
108         return true;
109     }
110 
111     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
112         require(_to != address(0));
113 
114         return _token.transfer(_to, _value);
115     }
116 }
117 
118 contract Pausable is Ownable {
119     bool public paused = false;
120 
121     event Pause();
122     event Unpause();
123 
124     modifier whenNotPaused() { require(!paused); _; }
125     modifier whenPaused() { require(paused); _; }
126 
127     function pause() onlyOwner whenNotPaused public {
128         paused = true;
129         Pause();
130     }
131 
132     function unpause() onlyOwner whenPaused public {
133         paused = false;
134         Unpause();
135     }
136 }
137 
138 contract ERC20 {
139     uint256 public totalSupply;
140 
141     event Transfer(address indexed from, address indexed to, uint256 value);
142     event Approval(address indexed owner, address indexed spender, uint256 value);
143 
144     function balanceOf(address who) public view returns(uint256);
145     function transfer(address to, uint256 value) public returns(bool);
146     function transferFrom(address from, address to, uint256 value) public returns(bool);
147     function allowance(address owner, address spender) public view returns(uint256);
148     function approve(address spender, uint256 value) public returns(bool);
149 }
150 
151 contract StandardToken is ERC20 {
152     using SafeMath for uint256;
153 
154     string public name;
155     string public symbol;
156     uint8 public decimals;
157 
158     mapping(address => uint256) balances;
159     mapping (address => mapping (address => uint256)) internal allowed;
160 
161     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
162         name = _name;
163         symbol = _symbol;
164         decimals = _decimals;
165     }
166 
167     function balanceOf(address _owner) public view returns(uint256 balance) {
168         return balances[_owner];
169     }
170 
171     function transfer(address _to, uint256 _value) public returns(bool) {
172         require(_to != address(0));
173         require(_value <= balances[msg.sender]);
174 
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177 
178         Transfer(msg.sender, _to, _value);
179 
180         return true;
181     }
182     
183     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
184         require(_to.length == _value.length);
185 
186         for(uint i = 0; i < _to.length; i++) {
187             transfer(_to[i], _value[i]);
188         }
189 
190         return true;
191     }
192 
193     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
194         require(_to != address(0));
195         require(_value <= balances[_from]);
196         require(_value <= allowed[_from][msg.sender]);
197 
198         balances[_from] = balances[_from].sub(_value);
199         balances[_to] = balances[_to].add(_value);
200         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201 
202         Transfer(_from, _to, _value);
203 
204         return true;
205     }
206 
207     function allowance(address _owner, address _spender) public view returns(uint256) {
208         return allowed[_owner][_spender];
209     }
210 
211     function approve(address _spender, uint256 _value) public returns(bool) {
212         allowed[msg.sender][_spender] = _value;
213 
214         Approval(msg.sender, _spender, _value);
215 
216         return true;
217     }
218 
219     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
220         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221 
222         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223 
224         return true;
225     }
226 
227     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
228         uint oldValue = allowed[msg.sender][_spender];
229 
230         if(_subtractedValue > oldValue) {
231             allowed[msg.sender][_spender] = 0;
232         } else {
233             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234         }
235 
236         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237 
238         return true;
239     }
240 }
241 
242 contract MintableToken is StandardToken, Ownable {
243     event Mint(address indexed to, uint256 amount);
244     event MintFinished();
245 
246     bool public mintingFinished = false;
247 
248     modifier canMint() { require(!mintingFinished); _; }
249 
250     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
251         totalSupply = totalSupply.add(_amount);
252         balances[_to] = balances[_to].add(_amount);
253 
254         Mint(_to, _amount);
255         Transfer(address(0), _to, _amount);
256 
257         return true;
258     }
259 
260     function finishMinting() onlyOwner canMint public returns(bool) {
261         mintingFinished = true;
262 
263         MintFinished();
264 
265         return true;
266     }
267 }
268 
269 contract CappedToken is MintableToken {
270     uint256 public cap;
271 
272     function CappedToken(uint256 _cap) public {
273         require(_cap > 0);
274         cap = _cap;
275     }
276 
277     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
278         require(totalSupply.add(_amount) <= cap);
279 
280         return super.mint(_to, _amount);
281     }
282 }
283 
284 contract BurnableToken is StandardToken {
285     event Burn(address indexed burner, uint256 value);
286 
287     function burn(uint256 _value) public {
288         require(_value <= balances[msg.sender]);
289 
290         address burner = msg.sender;
291 
292         balances[burner] = balances[burner].sub(_value);
293         totalSupply = totalSupply.sub(_value);
294 
295         Burn(burner, _value);
296     }
297 }
298 
299 contract Token is CappedToken, BurnableToken, Withdrawable {
300     function Token() CappedToken(10000000000e8) StandardToken("MIRAMIND Token", "MIRA", 8) public {
301         
302     }
303 }
304 
305 contract Crowdsale is Manageable, Withdrawable, Pausable {
306     using SafeMath for uint;
307 
308     Token public token;
309     bool public crowdsaleClosed = false;
310 
311     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
312     event CrowdsaleClose();
313    
314     function Crowdsale() public {
315         token = new Token();
316 
317         token.mint(0xaC69e2AAB7E244EA6150CF09DFA2D7546bF55e37, 1300000000e8);     // Miners 13%
318         token.mint(0xf75693a703cEfc0318602859A49caa20b32FF155, 500000000e8);      // Team 5%
319         token.mint(0x711D8fB2222498d1ACe3378da2e16CE50258b2Bf, 500000000e8);      // Partners 5%
320         token.mint(0xCf94b6bbc18F35d3fF99A03B8238dF467fc3351D, 300000000e8);      // Advisors 3%
321 
322     }
323 
324     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
325         token.mint(_to, _tokens);
326         ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
327     }
328 
329     function closeCrowdsale(address _to) onlyOwner public {
330         require(!crowdsaleClosed);
331 
332         token.transferOwnership(_to);
333         crowdsaleClosed = true;
334 
335         CrowdsaleClose();
336     }
337         
338 }