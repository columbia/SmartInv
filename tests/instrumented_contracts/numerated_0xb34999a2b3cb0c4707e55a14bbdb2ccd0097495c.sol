1 /*! Smartcontract Token | (c) 2018 BelovITLab LLC | License: MIT */
2 //
3 //                                     _
4 //                                _.-~~.)              SMARTCONTRACT.RU
5 //          _.--~~~~~---....__  .' . .,'          
6 //        ,'. . . . . . . . . .~- ._ (                 Development smart-contracts
7 //       ( .. .g. . . . . . . . . . .~-._              Investor's office for ICO
8 //    .~__.-~    ~`. . . . . . . . . . . -.
9 //    `----..._      ~-=~~-. . . . . . . . ~-.         Telegram: https://goo.gl/FRP4nz    
10 //              ~-._   `-._ ~=_~~--. . . . . .~.
11 //               | .~-.._  ~--._-.    ~-. . . . ~-.
12 //                \ .(   ~~--.._~'       `. . . . .~-.                ,
13 //                 `._\         ~~--.._    `. . . . . ~-.    .- .   ,'/
14 // _  . _ . -~\        _ ..  _          ~~--.`_. . . . . ~-_     ,-','`  .
15 //              ` ._           ~                ~--. . . . .~=.-'. /. `
16 //        - . -~            -. _ . - ~ - _   - ~     ~--..__~ _,. /   \  - ~
17 //               . __ ..                   ~-               ~~_. (  `
18 // )`. _ _               `-       ..  - .    . - ~ ~ .    \    ~-` ` `  `. _
19 //                                                     - .  `  .   \  \ `.
20 
21 
22 pragma solidity 0.4.18;
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
26         if(a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns(uint256) {
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns(uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     modifier onlyOwner() { require(msg.sender == owner); _; }
57 
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     function transferOwnership(address newOwner) public onlyOwner {
63         require(newOwner != address(0));
64         owner = newOwner;
65         OwnershipTransferred(owner, newOwner);
66     }
67 }
68 
69 contract Manageable is Ownable {
70     address[] public managers;
71 
72     event ManagerAdded(address indexed manager);
73     event ManagerRemoved(address indexed manager);
74 
75     modifier onlyManager() { require(isManager(msg.sender)); _; }
76 
77     function countManagers() view public returns(uint) {
78         return managers.length;
79     }
80 
81     function getManagers() view public returns(address[]) {
82         return managers;
83     }
84 
85     function isManager(address _manager) view public returns(bool) {
86         for(uint i = 0; i < managers.length; i++) {
87             if(managers[i] == _manager) {
88                 return true;
89             }
90         }
91         return false;
92     }
93 
94     function addManager(address _manager) onlyOwner public {
95         require(_manager != address(0));
96         require(!isManager(_manager));
97 
98         managers.push(_manager);
99 
100         ManagerAdded(_manager);
101     }
102 
103     function removeManager(address _manager) onlyOwner public {
104         require(isManager(_manager));
105 
106         uint index = 0;
107         for(uint i = 0; i < managers.length; i++) {
108             if(managers[i] == _manager) {
109                 index = i;
110             }
111         }
112 
113         for(; index < managers.length - 1; index++) {
114             managers[index] = managers[index + 1];
115         }
116         
117         managers.length--;
118         ManagerRemoved(_manager);
119     }
120 }
121 
122 contract Withdrawable is Ownable {
123     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
124         require(_to != address(0));
125         require(this.balance >= _value);
126 
127         _to.transfer(_value);
128 
129         return true;
130     }
131 
132     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
133         require(_to != address(0));
134 
135         return _token.transfer(_to, _value);
136     }
137 }
138 
139 contract Pausable is Ownable {
140     bool public paused = false;
141 
142     event Pause();
143     event Unpause();
144 
145     modifier whenNotPaused() { require(!paused); _; }
146     modifier whenPaused() { require(paused); _; }
147 
148     function pause() onlyOwner whenNotPaused public {
149         paused = true;
150         Pause();
151     }
152 
153     function unpause() onlyOwner whenPaused public {
154         paused = false;
155         Unpause();
156     }
157 }
158 
159 contract ERC20 {
160     uint256 public totalSupply;
161 
162     event Transfer(address indexed from, address indexed to, uint256 value);
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 
165     function balanceOf(address who) public view returns(uint256);
166     function transfer(address to, uint256 value) public returns(bool);
167     function transferFrom(address from, address to, uint256 value) public returns(bool);
168     function allowance(address owner, address spender) public view returns(uint256);
169     function approve(address spender, uint256 value) public returns(bool);
170 }
171 
172 contract StandardToken is ERC20 {
173     using SafeMath for uint256;
174 
175     string public name;
176     string public symbol;
177     uint8 public decimals;
178 
179     mapping(address => uint256) balances;
180     mapping (address => mapping (address => uint256)) internal allowed;
181 
182     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
183         name = _name;
184         symbol = _symbol;
185         decimals = _decimals;
186     }
187 
188     function balanceOf(address _owner) public view returns(uint256 balance) {
189         return balances[_owner];
190     }
191 
192     function transfer(address _to, uint256 _value) public returns(bool) {
193         require(_to != address(0));
194         require(_value <= balances[msg.sender]);
195 
196         balances[msg.sender] = balances[msg.sender].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198 
199         Transfer(msg.sender, _to, _value);
200 
201         return true;
202     }
203     
204     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
205         require(_to.length == _value.length);
206 
207         for(uint i = 0; i < _to.length; i++) {
208             transfer(_to[i], _value[i]);
209         }
210 
211         return true;
212     }
213 
214     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
215         require(_to != address(0));
216         require(_value <= balances[_from]);
217         require(_value <= allowed[_from][msg.sender]);
218 
219         balances[_from] = balances[_from].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
222 
223         Transfer(_from, _to, _value);
224 
225         return true;
226     }
227 
228     function allowance(address _owner, address _spender) public view returns(uint256) {
229         return allowed[_owner][_spender];
230     }
231 
232     function approve(address _spender, uint256 _value) public returns(bool) {
233         allowed[msg.sender][_spender] = _value;
234 
235         Approval(msg.sender, _spender, _value);
236 
237         return true;
238     }
239 
240     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
241         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
242 
243         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244 
245         return true;
246     }
247 
248     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
249         uint oldValue = allowed[msg.sender][_spender];
250 
251         if(_subtractedValue > oldValue) {
252             allowed[msg.sender][_spender] = 0;
253         } else {
254             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255         }
256 
257         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258 
259         return true;
260     }
261 }
262 
263 contract MintableToken is StandardToken, Ownable {
264     event Mint(address indexed to, uint256 amount);
265     event MintFinished();
266 
267     bool public mintingFinished = false;
268 
269     modifier canMint() { require(!mintingFinished); _; }
270     modifier notMint() { require(mintingFinished); _; }
271 
272     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
273         totalSupply = totalSupply.add(_amount);
274         balances[_to] = balances[_to].add(_amount);
275 
276         Mint(_to, _amount);
277         Transfer(address(0), _to, _amount);
278 
279         return true;
280     }
281 
282     function finishMinting() onlyOwner canMint public returns(bool) {
283         mintingFinished = true;
284 
285         MintFinished();
286 
287         return true;
288     }
289 }
290 
291 contract CappedToken is MintableToken {
292     uint256 public cap;
293 
294     function CappedToken(uint256 _cap) public {
295         require(_cap > 0);
296         cap = _cap;
297     }
298 
299     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
300         require(totalSupply.add(_amount) <= cap);
301 
302         return super.mint(_to, _amount);
303     }
304 }
305 
306 contract BurnableToken is StandardToken {
307     event Burn(address indexed burner, uint256 value);
308 
309     function burn(uint256 _value) public {
310         require(_value <= balances[msg.sender]);
311 
312         address burner = msg.sender;
313 
314         balances[burner] = balances[burner].sub(_value);
315         totalSupply = totalSupply.sub(_value);
316 
317         Burn(burner, _value);
318     }
319 }
320 
321 /* This is your discount for development smartcontract 5% */
322 /* For order smart-contract please contact at Telegram: https://t.me/joinchat/Bft2vxACXWjuxw8jH15G6w */
323 
324 /* We develop inverstor's office for ICO, operator's dashboard for ICO, Token Air Drop  */
325 /* info@smartcontract.ru */
326 
327 contract Token is CappedToken, BurnableToken {
328 
329     string public URL = "http://smartcontract.ru";
330 
331     function Token() CappedToken(100000000 * 1 ether) StandardToken("SMARTCONTRACT.RU", "SMART", 18) public {
332         
333     }
334     
335     function transfer(address _to, uint256 _value) public returns(bool) {
336         return super.transfer(_to, _value);
337     }
338     
339     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
340         return super.multiTransfer(_to, _value);
341     }
342 
343     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
344         return super.transferFrom(_from, _to, _value);
345     }
346 }
347 
348 
349 contract Crowdsale is Manageable, Withdrawable, Pausable {
350     using SafeMath for uint;
351 
352     Token public token;
353     bool public crowdsaleClosed = false;
354 
355     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
356     event CrowdsaleClose();
357    
358     function Crowdsale() public {
359         token = Token(0x5DD98e580f8a12C4048C26d4f489dcf2C5Cfc936);
360         addManager(0x3c64B86cEE4E60EDdA517521b46Ac74134442058);
361     }
362 
363     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
364         token.mint(_to, _tokens);
365         ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
366     }
367 
368     function closeCrowdsale(address _to) onlyOwner public {
369         require(!crowdsaleClosed);
370 
371         token.transferOwnership(_to);
372         crowdsaleClosed = true;
373 
374         CrowdsaleClose();
375     }
376 }