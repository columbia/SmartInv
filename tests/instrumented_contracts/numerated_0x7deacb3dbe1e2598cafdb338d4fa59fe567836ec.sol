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
101 
102 contract Withdrawable is Ownable {
103     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
104         require(_to != address(0));
105         require(this.balance >= _value);
106 
107         _to.transfer(_value);
108 
109         return true;
110     }
111 
112     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
113         require(_to != address(0));
114 
115         return _token.transfer(_to, _value);
116     }
117 }
118 
119 contract Pausable is Ownable {
120     bool public paused = false;
121 
122     event Pause();
123     event Unpause();
124 
125     modifier whenNotPaused() { require(!paused); _; }
126     modifier whenPaused() { require(paused); _; }
127 
128     function pause() onlyOwner whenNotPaused public {
129         paused = true;
130         Pause();
131     }
132 
133     function unpause() onlyOwner whenPaused public {
134         paused = false;
135         Unpause();
136     }
137 }
138 
139 contract ERC20 {
140     uint256 public totalSupply;
141 
142     event Transfer(address indexed from, address indexed to, uint256 value);
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145     function balanceOf(address who) public view returns(uint256);
146     function transfer(address to, uint256 value) public returns(bool);
147     function transferFrom(address from, address to, uint256 value) public returns(bool);
148     function allowance(address owner, address spender) public view returns(uint256);
149     function approve(address spender, uint256 value) public returns(bool);
150 }
151 
152 contract StandardToken is ERC20 {
153     using SafeMath for uint256;
154 
155     string public name;
156     string public symbol;
157     uint8 public decimals;
158 
159     mapping(address => uint256) balances;
160     mapping (address => mapping (address => uint256)) internal allowed;
161 
162     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
163         name = _name;
164         symbol = _symbol;
165         decimals = _decimals;
166     }
167 
168     function balanceOf(address _owner) public view returns(uint256 balance) {
169         return balances[_owner];
170     }
171 
172     function transfer(address _to, uint256 _value) public returns(bool) {
173         require(_to != address(0));
174         require(_value <= balances[msg.sender]);
175 
176         balances[msg.sender] = balances[msg.sender].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178 
179         Transfer(msg.sender, _to, _value);
180 
181         return true;
182     }
183     
184     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
185         require(_to.length == _value.length);
186 
187         for(uint i = 0; i < _to.length; i++) {
188             transfer(_to[i], _value[i]);
189         }
190 
191         return true;
192     }
193 
194     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
195         require(_to != address(0));
196         require(_value <= balances[_from]);
197         require(_value <= allowed[_from][msg.sender]);
198 
199         balances[_from] = balances[_from].sub(_value);
200         balances[_to] = balances[_to].add(_value);
201         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202 
203         Transfer(_from, _to, _value);
204 
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) public view returns(uint256) {
209         return allowed[_owner][_spender];
210     }
211 
212     function approve(address _spender, uint256 _value) public returns(bool) {
213         allowed[msg.sender][_spender] = _value;
214 
215         Approval(msg.sender, _spender, _value);
216 
217         return true;
218     }
219 
220     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222 
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224 
225         return true;
226     }
227 
228     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
229         uint oldValue = allowed[msg.sender][_spender];
230 
231         if(_subtractedValue > oldValue) {
232             allowed[msg.sender][_spender] = 0;
233         } else {
234             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235         }
236 
237         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238 
239         return true;
240     }
241 }
242 
243 contract MintableToken is StandardToken, Ownable {
244     event Mint(address indexed to, uint256 amount);
245     event MintFinished();
246 
247     bool public mintingFinished = false;
248 
249     modifier canMint() { require(!mintingFinished); _; }
250 
251     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
252         totalSupply = totalSupply.add(_amount);
253         balances[_to] = balances[_to].add(_amount);
254 
255         Mint(_to, _amount);
256         Transfer(address(0), _to, _amount);
257 
258         return true;
259     }
260 
261     function finishMinting() onlyOwner canMint public returns(bool) {
262         mintingFinished = true;
263 
264         MintFinished();
265 
266         return true;
267     }
268 }
269 
270 contract BurnableToken is StandardToken {
271     event Burn(address indexed burner, uint256 value);
272 
273     function burn(uint256 _value) public {
274         require(_value <= balances[msg.sender]);
275 
276         address burner = msg.sender;
277 
278         balances[burner] = balances[burner].sub(_value);
279         totalSupply = totalSupply.sub(_value);
280 
281         Burn(burner, _value);
282     }
283 }
284 
285 
286 contract Token is MintableToken, BurnableToken, Withdrawable {
287     function Token() StandardToken("ADGEX Limited", "AGE", 8) public {
288         
289     }
290 }
291 
292 contract Crowdsale is Manageable, Withdrawable, Pausable {
293     using SafeMath for uint;
294 
295     Token public token;
296     bool public crowdsaleClosed = false;
297 
298     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
299     event CrowdsaleClose();
300    
301     function Crowdsale() public {
302         token = Token(0xcd0f39E201bfAf9Fc30F62f77C7E9AfdcE9D4D42);
303 
304         addManager(0xB25297425110dAeeF6f67A76b5Afa393E0e1ffB3);
305     }
306 
307     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
308         token.mint(_to, _tokens);
309         ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
310     }
311 
312     function closeCrowdsale(address _to) onlyOwner public {
313         require(!crowdsaleClosed);
314 
315         token.transferOwnership(_to);
316 
317         crowdsaleClosed = true;
318 
319         CrowdsaleClose();
320     }
321 }