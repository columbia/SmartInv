1 pragma solidity ^0.4.11;
2 
3 // By contributing you agree to our terms & conditions.
4 // https://harbour.tokenate.io/HarbourTermsOfSale.pdf
5 
6 library SafeMath {
7     function mul(uint a, uint b) internal returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal returns (uint) {
14         assert(b > 0);
15         uint c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44         return a < b ? a : b;
45     }
46 
47     function assert(bool assertion) internal {
48         if (!assertion) {
49             throw;
50         }
51     }
52 }
53 
54 contract ownable {
55 
56     address public owner;
57 
58     modifier onlyOwner {
59         if (!isOwner(msg.sender)) throw;
60         _;
61     }
62 
63     function ownable() {
64         owner = msg.sender;
65     }
66 
67     function transferOwnership(address _newOwner) onlyOwner {
68         owner = _newOwner;
69     }
70 
71     function isOwner(address _address) returns (bool) {
72         return owner == _address;
73     }
74 }
75 
76 contract Burnable {
77 
78     event Burn(address indexed owner, uint amount);
79     function burn(address _owner, uint _amount) public;
80 
81 }
82 
83 contract ERC20 {
84     uint public totalSupply;
85     
86     function totalSupply() constant returns (uint);
87     function balanceOf(address _owner) constant returns (uint);
88     function allowance(address _owner, address _spender) constant returns (uint);
89     function transfer(address _to, uint _value) returns (bool);
90     function transferFrom(address _from, address _to, uint _value) returns (bool);
91     function approve(address _spender, uint _value) returns (bool);
92     
93     event Approval(address indexed owner, address indexed spender, uint value);
94     event Transfer(address indexed from, address indexed to, uint value);
95 }
96 
97 contract Mintable {
98 
99     event Mint(address indexed to, uint value);
100     function mint(address _to, uint _amount) public;
101 }
102 
103 contract Token is ERC20, Mintable, Burnable, ownable {
104     using SafeMath for uint;
105 
106     string public name;
107     string public symbol;
108 
109     uint public decimals = 18;
110     uint public maxSupply;
111     uint public totalSupply;
112     uint public freezeMintUntil;
113 
114     mapping (address => mapping (address => uint)) allowed;
115     mapping (address => uint) balances;
116 
117     modifier canMint {
118         require(totalSupply < maxSupply);
119         _;
120     }
121 
122     modifier mintIsNotFrozen {
123         require(freezeMintUntil < now);
124         _;
125     }
126 
127     function Token(string _name, string _symbol, uint _maxSupply) {
128         name = _name;
129         symbol = _symbol;
130         maxSupply = _maxSupply;
131         totalSupply = 0;
132         freezeMintUntil = 0;
133     }
134 
135     function totalSupply() constant returns (uint) {
136         return totalSupply;
137     }
138 
139     function balanceOf(address _owner) constant returns (uint) {
140         return balances[_owner];
141     }
142 
143     function allowance(address _owner, address _spender) constant returns (uint) {
144         return allowed[_owner][_spender];
145     }
146 
147     function transfer(address _to, uint _value) returns (bool) {
148         if (_value <= 0) {
149             return false;
150         }
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154 
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     function transferFrom(address _from, address _to, uint _value) returns (bool) {
160         if (_value <= 0) {
161             return false;
162         }
163 
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166 
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     function approve(address _spender, uint _value) returns (bool) {
173         allowed[msg.sender][_spender] = _value;
174         Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     function mint(address _to, uint _amount) public canMint mintIsNotFrozen onlyOwner {
179         if (maxSupply < totalSupply.add(_amount)) throw;
180 
181         totalSupply = totalSupply.add(_amount);
182         balances[_to] = balances[_to].add(_amount);
183 
184         Mint(_to, _amount);
185     }
186 
187     function burn(address _owner, uint _amount) public onlyOwner {
188         totalSupply = totalSupply.sub(_amount);
189         balances[_owner] = balances[_owner].sub(_amount);
190 
191         Burn(_owner, _amount);
192     }
193 
194     function freezeMintingFor(uint _weeks) public onlyOwner {
195         freezeMintUntil = now + _weeks * 1 weeks;
196     }
197 }
198 
199 contract TokenSale is ownable {
200     using SafeMath for uint;
201 
202     uint256 public constant MINT_LOCK_DURATION_IN_WEEKS = 26;
203 
204     Token public token;
205 
206     address public beneficiary;
207 
208     uint public cap;
209     uint public collected;
210     uint public price;
211     uint public purchaseLimit;
212 
213     uint public whitelistStartBlock;
214     uint public startBlock;
215     uint public endBlock;
216 
217     bool public capReached = false;
218     bool public isFinalized = false;
219 
220     mapping (address => uint) contributed;
221     mapping (address => bool) whitelisted;
222 
223     event GoalReached(uint amountRaised);
224     event NewContribution(address indexed holder, uint256 tokens, uint256 contributed);
225     event Refunded(address indexed beneficiary, uint amount);
226 
227     modifier onlyAfterSale { require(block.number > endBlock); _; }
228 
229     modifier onlyWhenFinalized { require(isFinalized); _; }
230 
231     modifier onlyDuringSale {
232         require(block.number >= startBlock(msg.sender));
233         require(block.number <= endBlock);
234         _;
235     }
236 
237     modifier onlyWhenEnded {
238         if (block.number < endBlock && !capReached) throw;
239         _;
240     }
241 
242     function TokenSale(
243         uint _cap,
244         uint _whitelistStartBlock,
245         uint _startBlock,
246         uint _endBlock,
247         address _token,
248         uint _price,
249         uint _purchaseLimit,
250         address _beneficiary
251     )
252     {
253         cap = _cap * 1 ether;
254         price = _price;
255         purchaseLimit = (_purchaseLimit * 1 ether) * price;
256         token = Token(_token);
257         beneficiary = _beneficiary;
258 
259         whitelistStartBlock = _whitelistStartBlock;
260         startBlock = _startBlock;
261         endBlock = _endBlock;
262     }
263 
264     function () payable {
265         doPurchase(msg.sender);
266     }
267 
268     function refund() public onlyWhenFinalized {
269         if (capReached) throw;
270 
271         uint balance = token.balanceOf(msg.sender);
272         if (balance == 0) throw;
273 
274         uint refund = balance.div(price);
275         if (refund > this.balance) {
276             refund = this.balance;
277         }
278 
279         token.burn(msg.sender, balance);
280         contributed[msg.sender] = 0;
281 
282         msg.sender.transfer(refund);
283         Refunded(msg.sender, refund);
284     }
285 
286     function finalize() public onlyWhenEnded onlyOwner {
287         require(!isFinalized);
288         isFinalized = true;
289 
290         if (!capReached) {
291             return;
292         }
293 
294         if (!beneficiary.send(collected)) throw;
295         token.freezeMintingFor(MINT_LOCK_DURATION_IN_WEEKS);
296     }
297 
298     function doPurchase(address _owner) internal onlyDuringSale {
299         if (msg.value <= 0) throw;
300         if (collected >= cap) throw;
301 
302         uint value = msg.value;
303         if (collected.add(value) > cap) {
304             uint difference = cap.sub(collected);
305             msg.sender.transfer(value.sub(difference));
306             value = difference;
307         }
308 
309         uint tokens = value.mul(price);
310         if (token.balanceOf(msg.sender) + tokens > purchaseLimit) throw;
311 
312         collected = collected.add(value);
313         token.mint(msg.sender, tokens);
314         NewContribution(_owner, tokens, value);
315 
316         if (collected != cap) {
317             return;
318         }
319 
320         GoalReached(collected);
321         capReached = true;
322     }
323 
324     function addToWhitelist(address _address) public onlyOwner {
325         whitelisted[_address] = true;
326     }
327 
328     function startBlock(address contributor) constant returns (uint) {
329         if (whitelisted[contributor]) {
330             return whitelistStartBlock;
331         }
332 
333         return startBlock;
334     }
335 
336     function tokenTransferOwnership(address _newOwner) public onlyWhenFinalized {
337         if (!capReached) throw; // only transfer if cap reached, otherwise we need burning for refund
338         token.transferOwnership(_newOwner);
339     }
340 }