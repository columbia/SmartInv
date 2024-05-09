1 /*! prt.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.24;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
7         if(a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         return a / b;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Ownable {
32     address public owner;
33 
34     event OwnershipRenounced(address indexed previousOwner);
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _;  }
38 
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     function _transferOwnership(address _newOwner) internal {
44         require(_newOwner != address(0));
45         emit OwnershipTransferred(owner, _newOwner);
46         owner = _newOwner;
47     }
48 
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipRenounced(owner);
51         owner = address(0);
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         _transferOwnership(_newOwner);
56     }
57 }
58 
59 contract ERC20 {
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63     function totalSupply() public view returns(uint256);
64     function balanceOf(address who) public view returns(uint256);
65     function transfer(address to, uint256 value) public returns(bool);
66     function transferFrom(address from, address to, uint256 value) public returns(bool);
67     function allowance(address owner, address spender) public view returns(uint256);
68     function approve(address spender, uint256 value) public returns(bool);
69 }
70 
71 contract StandardToken is ERC20 {
72     using SafeMath for uint256;
73 
74     uint256 totalSupply_;
75 
76     string public name;
77     string public symbol;
78     uint8 public decimals;
79 
80     mapping(address => uint256) balances;
81     mapping(address => mapping(address => uint256)) internal allowed;
82 
83     constructor(string _name, string _symbol, uint8 _decimals) public {
84         name = _name;
85         symbol = _symbol;
86         decimals = _decimals;
87     }
88 
89     function totalSupply() public view returns(uint256) {
90         return totalSupply_;
91     }
92 
93     function balanceOf(address _owner) public view returns(uint256) {
94         return balances[_owner];
95     }
96 
97     function transfer(address _to, uint256 _value) public returns(bool) {
98         require(_to != address(0));
99         require(_value <= balances[msg.sender]);
100 
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         
104         emit Transfer(msg.sender, _to, _value);
105         return true;
106     }
107 
108     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
109         require(_to.length == _value.length);
110 
111         for(uint i = 0; i < _to.length; i++) {
112             transfer(_to[i], _value[i]);
113         }
114 
115         return true;
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
119         require(_to != address(0));
120         require(_value <= balances[_from]);
121         require(_value <= allowed[_from][msg.sender]);
122 
123         balances[_from] = balances[_from].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126 
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function allowance(address _owner, address _spender) public view returns(uint256) {
132         return allowed[_owner][_spender];
133     }
134 
135     function approve(address _spender, uint256 _value) public returns(bool) {
136         allowed[msg.sender][_spender] = _value;
137 
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
143         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
144 
145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 
149     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
150         uint oldValue = allowed[msg.sender][_spender];
151 
152         if(_subtractedValue > oldValue) {
153             allowed[msg.sender][_spender] = 0;
154         }
155         else {
156             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157         }
158 
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 }
163 
164 contract MintableToken is StandardToken, Ownable {
165     bool public mintingFinished = false;
166 
167     event Mint(address indexed to, uint256 amount);
168     event MintFinished();
169 
170     modifier canMint() { require(!mintingFinished); _; }
171     modifier hasMintPermission() { require(msg.sender == owner); _; }
172 
173     function mint(address _to, uint256 _amount) hasMintPermission canMint public returns(bool) {
174         totalSupply_ = totalSupply_.add(_amount);
175         balances[_to] = balances[_to].add(_amount);
176 
177         emit Mint(_to, _amount);
178         emit Transfer(address(0), _to, _amount);
179         return true;
180     }
181 
182     function finishMinting() onlyOwner canMint public returns(bool) {
183         mintingFinished = true;
184 
185         emit MintFinished();
186         return true;
187     }
188 }
189 
190 contract CappedToken is MintableToken {
191     uint256 public cap;
192 
193     constructor(uint256 _cap) public {
194         require(_cap > 0);
195         cap = _cap;
196     }
197 
198     function mint(address _to, uint256 _amount) public returns(bool) {
199         require(totalSupply_.add(_amount) <= cap);
200 
201         return super.mint(_to, _amount);
202     }
203 }
204 
205 contract BurnableToken is StandardToken {
206     event Burn(address indexed burner, uint256 value);
207 
208     function _burn(address _who, uint256 _value) internal {
209         require(_value <= balances[_who]);
210 
211         balances[_who] = balances[_who].sub(_value);
212         totalSupply_ = totalSupply_.sub(_value);
213 
214         emit Burn(_who, _value);
215         emit Transfer(_who, address(0), _value);
216     }
217 
218     function burn(uint256 _value) public {
219         _burn(msg.sender, _value);
220     }
221 
222     function burnFrom(address _from, uint256 _value) public {
223         require(_value <= allowed[_from][msg.sender]);
224         
225         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226         _burn(_from, _value);
227     }
228 }
229 
230 contract Withdrawable is Ownable {
231     function withdrawEther(address _to, uint _value) onlyOwner public {
232         require(_to != address(0));
233         require(address(this).balance >= _value);
234 
235         _to.transfer(_value);
236     }
237 
238     function withdrawTokensTransfer(ERC20 _token, address _to, uint256 _value) onlyOwner public {
239         require(_token.transfer(_to, _value));
240     }
241 
242     function withdrawTokensTransferFrom(ERC20 _token, address _from, address _to, uint256 _value) onlyOwner public {
243         require(_token.transferFrom(_from, _to, _value));
244     }
245 
246     function withdrawTokensApprove(ERC20 _token, address _spender, uint256 _value) onlyOwner public {
247         require(_token.approve(_spender, _value));
248     }
249 }
250 
251 contract Pausable is Ownable {
252     bool public paused = false;
253 
254     event Pause();
255     event Unpause();
256 
257     modifier whenNotPaused() { require(!paused); _; }
258     modifier whenPaused() { require(paused); _; }
259 
260     function pause() onlyOwner whenNotPaused public {
261         paused = true;
262         emit Pause();
263     }
264 
265     function unpause() onlyOwner whenPaused public {
266         paused = false;
267         emit Unpause();
268     }
269 }
270 
271 contract Manageable is Ownable {
272     address[] public managers;
273 
274     event ManagerAdded(address indexed manager);
275     event ManagerRemoved(address indexed manager);
276 
277     modifier onlyManager() { require(isManager(msg.sender)); _; }
278 
279     function countManagers() view public returns(uint) {
280         return managers.length;
281     }
282 
283     function getManagers() view public returns(address[]) {
284         return managers;
285     }
286 
287     function isManager(address _manager) view public returns(bool) {
288         for(uint i = 0; i < managers.length; i++) {
289             if(managers[i] == _manager) {
290                 return true;
291             }
292         }
293         return false;
294     }
295 
296     function addManager(address _manager) onlyOwner public {
297         require(_manager != address(0));
298         require(!isManager(_manager));
299 
300         managers.push(_manager);
301 
302         emit ManagerAdded(_manager);
303     }
304 
305     function removeManager(address _manager) onlyOwner public {
306         require(isManager(_manager));
307 
308         uint index = 0;
309         for(uint i = 0; i < managers.length; i++) {
310             if(managers[i] == _manager) {
311                 index = i;
312             }
313         }
314 
315         for(; index < managers.length - 1; index++) {
316             managers[index] = managers[index + 1];
317         }
318         
319         managers.length--;
320         emit ManagerRemoved(_manager);
321     }
322 }
323 
324 
325 /*
326     Papusha Token
327 */
328 contract Token is CappedToken, BurnableToken, Withdrawable {
329     constructor() CappedToken(100000000e18) StandardToken("Papusha Rocket Token", "PRT", 18) public {
330         
331     }
332 }
333 
334 contract Crowdsale is Manageable, Withdrawable, Pausable {
335     using SafeMath for uint;
336 
337     Token public token;
338     bool public crowdsaleClosed = false;
339 
340     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
341     event CrowdsaleClose();
342    
343     constructor() public {
344         token = new Token();
345     }
346 
347     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
348         token.mint(_to, _tokens);
349         emit ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
350     }
351 
352     function closeCrowdsale(address _to) onlyOwner public {
353         require(!crowdsaleClosed);
354 
355         token.transferOwnership(_to);
356         crowdsaleClosed = true;
357 
358         emit CrowdsaleClose();
359     }
360 }