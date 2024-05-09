1 /*! eft.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.21;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns(uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     modifier onlyOwner() { require(msg.sender == owner); _; }
38 
39     function Ownable() public {
40         owner = msg.sender;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         owner = newOwner;
46         OwnershipTransferred(owner, newOwner);
47     }
48 }
49 
50 contract Manageable is Ownable {
51     address[] public managers;
52 
53     event ManagerAdded(address indexed manager);
54     event ManagerRemoved(address indexed manager);
55 
56     modifier onlyManager() { require(isManager(msg.sender)); _; }
57 
58     function countManagers() view public returns(uint) {
59         return managers.length;
60     }
61 
62     function getManagers() view public returns(address[]) {
63         return managers;
64     }
65 
66     function isManager(address _manager) view public returns(bool) {
67         for(uint i = 0; i < managers.length; i++) {
68             if(managers[i] == _manager) {
69                 return true;
70             }
71         }
72         return false;
73     }
74 
75     function addManager(address _manager) onlyOwner public {
76         require(_manager != address(0));
77         require(!isManager(_manager));
78 
79         managers.push(_manager);
80 
81         ManagerAdded(_manager);
82     }
83 
84     function removeManager(address _manager) onlyOwner public {
85         require(isManager(_manager));
86 
87         uint index = 0;
88         for(uint i = 0; i < managers.length; i++) {
89             if(managers[i] == _manager) {
90                 index = i;
91             }
92         }
93 
94         for(; index < managers.length - 1; index++) {
95             managers[index] = managers[index + 1];
96         }
97         
98         managers.length--;
99         ManagerRemoved(_manager);
100     }
101 }
102 
103 contract Withdrawable is Ownable {
104     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
105         require(_to != address(0));
106         require(this.balance >= _value);
107 
108         _to.transfer(_value);
109 
110         return true;
111     }
112 
113     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
114         require(_to != address(0));
115 
116         return _token.transfer(_to, _value);
117     }
118 }
119 
120 contract Pausable is Ownable {
121     bool public paused = false;
122 
123     event Pause();
124     event Unpause();
125 
126     modifier whenNotPaused() { require(!paused); _; }
127     modifier whenPaused() { require(paused); _; }
128 
129     function pause() onlyOwner whenNotPaused public {
130         paused = true;
131         Pause();
132     }
133 
134     function unpause() onlyOwner whenPaused public {
135         paused = false;
136         Unpause();
137     }
138 }
139 
140 contract ERC20 {
141     uint256 public totalSupply;
142 
143     event Transfer(address indexed from, address indexed to, uint256 value);
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 
146     function balanceOf(address who) public view returns(uint256);
147     function transfer(address to, uint256 value) public returns(bool);
148     function transferFrom(address from, address to, uint256 value) public returns(bool);
149     function allowance(address owner, address spender) public view returns(uint256);
150     function approve(address spender, uint256 value) public returns(bool);
151 }
152 
153 contract StandardToken is ERC20 {
154     using SafeMath for uint256;
155 
156     string public name;
157     string public symbol;
158     uint8 public decimals;
159 
160     mapping(address => uint256) balances;
161     mapping (address => mapping (address => uint256)) internal allowed;
162 
163     function StandardToken(string _name, string _symbol, uint8 _decimals) public {
164         name = _name;
165         symbol = _symbol;
166         decimals = _decimals;
167     }
168 
169     function balanceOf(address _owner) public view returns(uint256 balance) {
170         return balances[_owner];
171     }
172 
173     function transfer(address _to, uint256 _value) public returns(bool) {
174         require(_to != address(0));
175         require(_value <= balances[msg.sender]);
176 
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179 
180         Transfer(msg.sender, _to, _value);
181 
182         return true;
183     }
184     
185     function multiTransfer(address[] _to, uint256[] _value) public returns(bool) {
186         require(_to.length == _value.length);
187 
188         for(uint i = 0; i < _to.length; i++) {
189             transfer(_to[i], _value[i]);
190         }
191 
192         return true;
193     }
194 
195     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
196         require(_to != address(0));
197         require(_value <= balances[_from]);
198         require(_value <= allowed[_from][msg.sender]);
199 
200         balances[_from] = balances[_from].sub(_value);
201         balances[_to] = balances[_to].add(_value);
202         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203 
204         Transfer(_from, _to, _value);
205 
206         return true;
207     }
208 
209     function allowance(address _owner, address _spender) public view returns(uint256) {
210         return allowed[_owner][_spender];
211     }
212 
213     function approve(address _spender, uint256 _value) public returns(bool) {
214         allowed[msg.sender][_spender] = _value;
215 
216         Approval(msg.sender, _spender, _value);
217 
218         return true;
219     }
220 
221     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
222         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223 
224         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225 
226         return true;
227     }
228 
229     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
230         uint oldValue = allowed[msg.sender][_spender];
231 
232         if(_subtractedValue > oldValue) {
233             allowed[msg.sender][_spender] = 0;
234         } else {
235             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236         }
237 
238         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239 
240         return true;
241     }
242 }
243 
244 contract MintableToken is StandardToken, Ownable {
245     event Mint(address indexed to, uint256 amount);
246     event MintFinished();
247 
248     bool public mintingFinished = false;
249 
250     modifier canMint() { require(!mintingFinished); _; }
251 
252     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
253         totalSupply = totalSupply.add(_amount);
254         balances[_to] = balances[_to].add(_amount);
255 
256         Mint(_to, _amount);
257         Transfer(address(0), _to, _amount);
258 
259         return true;
260     }
261 
262     function finishMinting() onlyOwner canMint public returns(bool) {
263         mintingFinished = true;
264 
265         MintFinished();
266 
267         return true;
268     }
269 }
270 
271 contract CappedToken is MintableToken {
272     uint256 public cap;
273 
274     function CappedToken(uint256 _cap) public {
275         require(_cap > 0);
276         cap = _cap;
277     }
278 
279     function mint(address _to, uint256 _amount) onlyOwner canMint public returns(bool) {
280         require(totalSupply.add(_amount) <= cap);
281 
282         return super.mint(_to, _amount);
283     }
284 }
285 
286 contract BurnableToken is StandardToken {
287     event Burn(address indexed burner, uint256 value);
288 
289     function burn(uint256 _value) public {
290         require(_value <= balances[msg.sender]);
291 
292         address burner = msg.sender;
293 
294         balances[burner] = balances[burner].sub(_value);
295         totalSupply = totalSupply.sub(_value);
296 
297         Burn(burner, _value);
298     }
299 }
300 
301 /*
302     Exit Factory Token
303 */
304 contract Token is CappedToken, BurnableToken, Withdrawable {
305     uint public mintingFinishedTime;
306 
307     function Token() CappedToken(2000000000 ether) StandardToken("Exit Factory Token", "EXIT", 18) public {
308         
309     }
310 
311     function transfer(address _to, uint256 _value) public returns(bool) {
312         require(mintingFinishedTime > 0 && now + 2 weeks >= mintingFinishedTime);
313         return super.transfer(_to, _value);
314     }
315 
316     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
317         require(mintingFinishedTime > 0 && now + 2 weeks >= mintingFinishedTime);
318         return super.transferFrom(_from, _to, _value);
319     }
320 
321     function finishMinting() onlyOwner canMint public returns(bool) {
322         mintingFinishedTime = now;
323         return super.finishMinting();
324     }
325 }
326 
327 contract Crowdsale is Manageable, Withdrawable, Pausable {
328     using SafeMath for uint;
329 
330     Token public token;
331     uint public timeEnd;
332     bool public crowdsaleClosed = false;
333 
334     uint public commandTookAway;
335 
336     event ExternalPurchase(address indexed holder, string tx, string currency, uint256 currencyAmount, uint256 rateToEther, uint256 tokenAmount);
337     event CrowdsaleClose();
338    
339     function Crowdsale() public {
340         token = new Token();
341 
342         token.mint(0x8871147bbF3f664e086F6F9f49F493Fcead5a8a9, 240000000 ether);     // Reserve Fund
343         token.mint(0x1e2aD7B66914bf432F66295604A66a3279DDEB1D, 200000000 ether);     // Founders
344         token.mint(0x235112Ca8A7c6c143b0E0902564f992955894BB1, 20000000 ether);      // Bounty
345         token.mint(0x9246714faF8781c5D896eBBC0D09F93B6Ca6807e, 20000000 ether);      // IT Security
346         token.mint(0xBB197831f6A2EA90cEff94Cf94A23aA16fdB77a4, 20000000 ether);      // Legal Compliance
347 
348         token.mint(this, 300000000 ether);                                           // Team, Advisors, Affiliate program
349 
350         addManager(0x3915029Dc964F32b7dE52cefd859Eb66A5f80c96);
351     }
352 
353     function externalPurchase(address _to, string _tx, string _currency, uint _value, uint256 _rate, uint256 _tokens) whenNotPaused onlyManager public {
354         token.mint(_to, _tokens);
355         ExternalPurchase(_to, _tx, _currency, _value, _rate, _tokens);
356     }
357 
358     function closeCrowdsale(address _to) onlyOwner public {
359         require(!crowdsaleClosed);
360 
361         token.finishMinting();
362         token.transferOwnership(_to);
363 
364         crowdsaleClosed = true;
365         timeEnd = now;
366 
367         CrowdsaleClose();
368     }
369     
370     function getCommandTokens() onlyOwner public {
371         require(crowdsaleClosed);
372 
373         uint months = now.sub(timeEnd).div(30 days);
374 
375         require(months > 0);
376 
377         uint right = months.mul(12500000 ether);
378         uint send = right.sub(commandTookAway);
379 
380         require(send > 0);
381         
382         commandTookAway = commandTookAway.add(send);
383 
384         token.transfer(0x7Ba026aBb24c55fFFfaE612E498efb1a22c12438, send.div(3));                    // Advisors
385         token.transfer(0x1763D74a1B3c3C8844336Be3DC302ff77012aC81, send.div(3));                    // Team
386         token.transfer(0xe1de68015AD6dCB0f79c34a6CaD58Dc097C76023, send.sub(send.div(3).mul(2)));   // Affiliate program
387     }
388     
389     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
390         require(_token != token || commandTookAway >= 300000000 ether);
391         
392         return super.withdrawTokens(_token, _to, _value);
393     }
394 }