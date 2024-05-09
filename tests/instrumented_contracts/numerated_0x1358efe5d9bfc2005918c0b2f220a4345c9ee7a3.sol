1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
5         if(a == 0) return 0;
6         uint256 c = a * b;
7         require(c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         require(b > 0);
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
18         require(b <= a);
19         uint256 c = a - b;
20         return c;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns(uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 
29     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address public owner;
37 
38     event OwnershipRenounced(address indexed previousOwner);
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     modifier onlyOwner() { require(msg.sender == owner); _;  }
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     function _transferOwnership(address _newOwner) internal {
48         require(_newOwner != address(0));
49         emit OwnershipTransferred(owner, _newOwner);
50         owner = _newOwner;
51     }
52 
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipRenounced(owner);
55         owner = address(0);
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         _transferOwnership(_newOwner);
60     }
61 }
62 
63 contract ERC20 {
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 
67     function totalSupply() public view returns(uint256);
68     function balanceOf(address who) public view returns(uint256);
69     function transfer(address to, uint256 value) public returns(bool);
70     function transferFrom(address from, address to, uint256 value) public returns(bool);
71     function allowance(address owner, address spender) public view returns(uint256);
72     function approve(address spender, uint256 value) public returns(bool);
73 }
74 
75 contract StandardToken is ERC20 {
76     using SafeMath for uint256;
77 
78     uint256 internal totalSupply_;
79 
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     string public Contracts_Owner = "YOUSPE Holding Pte. Ltd.";
84     string public Country = "Singapore";
85     string public RegNumber = "201725897N";
86     string public email = "info@youspe.tech"; 
87     string public contact_number = "+6566225500";
88 
89     mapping(address => uint256) public balances;
90     mapping(address => mapping(address => uint256)) internal allowed;
91 
92     constructor(string _name, string _symbol, uint8 _decimals) public {
93         name = _name;
94         symbol = _symbol;
95         decimals = _decimals;
96     }
97 
98     function totalSupply() public view returns(uint256) {
99         return totalSupply_;
100     }
101 
102     function balanceOf(address _owner) public view returns(uint256) {
103         return balances[_owner];
104     }
105 
106     function transfer(address _to, uint256 _value) public returns(bool) {
107         require(_to != address(0));
108         require(_value <= balances[msg.sender]);
109 
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
118         require(_to.length == _value.length);
119 
120         for(uint i = 0; i < _to.length; i++) {
121             transfer(_to[i], _value[i]);
122         }
123 
124         return true;
125     }
126 
127     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
128         require(_to != address(0));
129         require(_value <= balances[_from]);
130         require(_value <= allowed[_from][msg.sender]);
131 
132         balances[_from] = balances[_from].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135 
136         emit Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     function allowance(address _owner, address _spender) public view returns(uint256) {
141         return allowed[_owner][_spender];
142     }
143 
144     function approve(address _spender, uint256 _value) public returns(bool) {
145         require(_spender != address(0));
146         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
147 
148         allowed[msg.sender][_spender] = _value;
149 
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
155         require(_spender != address(0));
156         require(_addedValue > 0);
157 
158         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
159 
160         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161         return true;
162     }
163 
164     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
165         require(_spender != address(0));
166         require(_subtractedValue > 0);
167 
168         uint oldValue = allowed[msg.sender][_spender];
169 
170         if(_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         }
173         else {
174             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
175         }
176 
177         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178         return true;
179     }
180 }
181 
182 contract MintableToken is StandardToken, Ownable {
183     bool public mintingFinished = false;
184 
185     event Mint(address indexed to, uint256 amount);
186     event MintFinished();
187 
188     modifier canMint() { require(!mintingFinished); _; }
189     modifier hasMintPermission() { require(msg.sender == owner); _; }
190 
191     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
192         totalSupply_ = totalSupply_.add(_amount);
193         balances[_to] = balances[_to].add(_amount);
194 
195         emit Mint(_to, _amount);
196         emit Transfer(address(0), _to, _amount);
197         return true;
198     }
199 
200     function finishMinting() onlyOwner canMint public returns(bool) {
201         mintingFinished = true;
202 
203         emit MintFinished();
204         return true;
205     }
206 }
207 
208 contract CappedToken is MintableToken {
209     uint256 public cap;
210 
211     constructor(uint256 _cap) public {
212         require(_cap > 0);
213         cap = _cap;
214     }
215 
216     function mint(address _to, uint256 _amount) public returns(bool) {
217         require(totalSupply_.add(_amount) <= cap);
218 
219         return super.mint(_to, _amount);
220     }
221 }
222 
223 contract Withdrawable is Ownable {
224     event WithdrawEther(address indexed to, uint value);
225 
226     function withdrawEther(address _to, uint _value) onlyOwner public {
227         require(_to != address(0));
228         require(address(this).balance >= _value);
229 
230         _to.transfer(_value);
231 
232         emit WithdrawEther(_to, _value);
233     }
234 
235     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
236         require(_token.transfer(_to, _value));
237     }
238 
239     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
240         require(_token.transferFrom(_from, _to, _value));
241     }
242 
243     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
244         require(_token.approve(_spender, _value));
245     }
246 }
247 
248 contract Pausable is Ownable {
249     bool public paused = false;
250 
251     event Pause();
252     event Unpause();
253 
254     modifier whenNotPaused() { require(!paused); _; }
255     modifier whenPaused() { require(paused); _; }
256 
257     function pause() onlyOwner whenNotPaused public {
258         paused = true;
259         emit Pause();
260     }
261 
262     function unpause() onlyOwner whenPaused public {
263         paused = false;
264         emit Unpause();
265     }
266 }
267 
268 contract Manageable is Ownable {
269     address[] public managers;
270 
271     event ManagerAdded(address indexed manager);
272     event ManagerRemoved(address indexed manager);
273 
274     modifier onlyManager() { require(isManager(msg.sender)); _; }
275 
276     function countManagers() view public returns(uint) {
277         return managers.length;
278     }
279 
280     function getManagers() view public returns(address[]) {
281         return managers;
282     }
283 
284     function isManager(address _manager) view public returns(bool) {
285         for(uint i = 0; i < managers.length; i++) {
286             if(managers[i] == _manager) {
287                 return true;
288             }
289         }
290         return false;
291     }
292 
293     function addManager(address _manager) onlyOwner public {
294         require(_manager != address(0));
295         require(!isManager(_manager));
296 
297         managers.push(_manager);
298 
299         emit ManagerAdded(_manager);
300     }
301 
302     function removeManager(address _manager) onlyOwner public {
303         uint index = managers.length;
304         for(uint i = 0; i < managers.length; i++) {
305             if(managers[i] == _manager) {
306                 index = i;
307             }
308         }
309 
310         if(index >= managers.length) revert();
311 
312         for(; index < managers.length - 1; index++) {
313             managers[index] = managers[index + 1];
314         }
315         
316         managers.length--;
317         emit ManagerRemoved(_manager);
318     }
319 }
320 
321 
322 contract YOUSPE is CappedToken, Withdrawable {
323     constructor() CappedToken(150000000e3) StandardToken("YSEY Utility Token", "YSEY ", 3) public {
324         
325     }
326 }
327 
328 contract Crowdsale is Manageable, Withdrawable, Pausable {
329     using SafeMath for uint;
330 
331     YOUSPE public token;
332     bool public crowdsaleClosed = false;
333 
334     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
335     event CrowdsaleClose();
336    
337     constructor() public {
338         token = new YOUSPE();
339     }
340 
341     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager external {
342         require(!crowdsaleClosed);
343         require(_to != address(0));
344 
345         token.mint(_to, _tokens);
346         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
347     }
348 
349     function closeCrowdsale(address _newTokenOwner) onlyOwner external {
350         require(!crowdsaleClosed);
351         require(_newTokenOwner != address(0));
352 
353         token.finishMinting();
354         token.transferOwnership(_newTokenOwner);
355 
356         crowdsaleClosed = true;
357 
358         emit CrowdsaleClose();
359     }
360 }