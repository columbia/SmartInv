1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5     function safeMul(uint256 a, uint256 b) internal constant returns (uint256 ) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint256 a, uint256 b) internal constant returns (uint256 ) {
12         assert(b > 0);
13         uint256 c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint256 a, uint256 b) internal constant returns (uint256 ) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256 ) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20 {
31 
32     /* This is a slight change to the ERC20 base standard.
33     function totalSupply() constant returns (uint256 supply);
34     is replaced with:
35     uint256 public totalSupply;
36     This automatically creates a getter function for the totalSupply.
37     This is moved to the base contract since public getter functions are not
38     currently recognised as an implementation of the matching abstract
39     function by the compiler.
40     */
41     /// total amount of tokens
42     uint256 public totalSupply;
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) public constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) public returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) public returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 }
75 
76 contract StandardToken is ERC20, SafeMath {
77 
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) allowed;
80 
81     /// @dev Returns number of tokens owned by given address.
82     /// @param _owner Address of token owner.
83     function balanceOf(address _owner) public constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     /// @dev Transfers sender's tokens to a given address. Returns success.
88     /// @param _to Address of token receiver.
89     /// @param _value Number of tokens to transfer.
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         if (balances[msg.sender] >= _value && _value > 0) {
92             balances[msg.sender] = safeSub(balances[msg.sender], _value);
93             balances[_to] = safeAdd(balances[_to], _value);
94             Transfer(msg.sender, _to, _value);
95             return true;
96         } else return false;
97     }
98 
99     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
100     /// @param _from Address from where tokens are withdrawn.
101     /// @param _to Address to where tokens are sent.
102     /// @param _value Number of tokens to transfer.
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
104         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105             balances[_to] = safeAdd(balances[_to], _value);
106             balances[_from] = safeSub(balances[_from], _value);
107             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
108             Transfer(_from, _to, _value);
109             return true;
110         } else return false;
111     }
112 
113     /// @dev Sets approved amount of tokens for spender. Returns success.
114     /// @param _spender Address of allowed account.
115     /// @param _value Number of approved tokens.
116     function approve(address _spender, uint256 _value) public returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /// @dev Returns number of allowed tokens for given address.
123     /// @param _owner Address of token owner.
124     /// @param _spender Address of token spender.
125     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
126         return allowed[_owner][_spender];
127     }
128 }
129 
130 contract MultiOwnable {
131 
132     mapping (address => bool) ownerMap;
133     address[] public owners;
134 
135     event OwnerAdded(address indexed _newOwner);
136     event OwnerRemoved(address indexed _oldOwner);
137 
138     modifier onlyOwner() {
139         require(isOwner(msg.sender));
140         _;
141     }
142 
143     function MultiOwnable() {
144         // Add default owner
145         address owner = msg.sender;
146         ownerMap[owner] = true;
147         owners.push(owner);
148     }
149 
150     function ownerCount() public constant returns (uint256) {
151         return owners.length;
152     }
153 
154     function isOwner(address owner) public constant returns (bool) {
155         return ownerMap[owner];
156     }
157 
158     function addOwner(address owner) onlyOwner public returns (bool) {
159         if (!isOwner(owner) && owner != 0) {
160             ownerMap[owner] = true;
161             owners.push(owner);
162 
163             OwnerAdded(owner);
164             return true;
165         } else return false;
166     }
167 
168     function removeOwner(address owner) onlyOwner public returns (bool) {
169         if (isOwner(owner)) {
170             ownerMap[owner] = false;
171             for (uint i = 0; i < owners.length - 1; i++) {
172                 if (owners[i] == owner) {
173                     owners[i] = owners[owners.length - 1];
174                     break;
175                 }
176             }
177             owners.length -= 1;
178 
179             OwnerRemoved(owner);
180             return true;
181         } else return false;
182     }
183 }
184 
185 contract TokenSpender {
186     function receiveApproval(address _from, uint256 _value);
187 }
188 
189 contract CommonBsToken is StandardToken, MultiOwnable {
190 
191     string public name;
192     string public symbol;
193     uint256 public totalSupply;
194     uint8 public decimals = 18;
195     string public version = 'v0.1';
196 
197     address public creator;
198     address public seller;     // The main account that holds all tokens at the beginning.
199 
200     uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.
201     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
202     uint256 public totalSales; // Total number of sale (including external sales) made through all tiers or tokensales.
203 
204     bool public locked;
205 
206     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
207     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
208 
209     event Lock();
210     event Unlock();
211 
212     event Burn(address indexed _burner, uint256 _value);
213 
214     modifier onlyUnlocked() {
215         if (!isOwner(msg.sender) && locked) throw;
216         _;
217     }
218 
219     function CommonBsToken(
220         address _seller,
221         string _name,
222         string _symbol,
223         uint256 _totalSupplyNoDecimals,
224         uint256 _saleLimitNoDecimals
225     ) MultiOwnable() {
226 
227         // Lock the transfer function during the presale/crowdsale to prevent speculations.
228         locked = true;
229 
230         creator = msg.sender;
231         seller = _seller;
232 
233         name = _name;
234         symbol = _symbol;
235         totalSupply = _totalSupplyNoDecimals * 1e18;
236         saleLimit = _saleLimitNoDecimals * 1e18;
237 
238         balances[seller] = totalSupply;
239         Transfer(0x0, seller, totalSupply);
240     }
241 
242     function changeSeller(address newSeller) onlyOwner public returns (bool) {
243         require(newSeller != 0x0 && seller != newSeller);
244 
245         address oldSeller = seller;
246         uint256 unsoldTokens = balances[oldSeller];
247         balances[oldSeller] = 0;
248         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
249         Transfer(oldSeller, newSeller, unsoldTokens);
250 
251         seller = newSeller;
252         SellerChanged(oldSeller, newSeller);
253         return true;
254     }
255 
256     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
257         return sell(_to, _value * 1e18);
258     }
259 
260     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
261 
262         // Check that we are not out of limit and still can sell tokens:
263         if (saleLimit > 0) require(safeSub(saleLimit, safeAdd(tokensSold, _value)) >= 0);
264 
265         require(_to != address(0));
266         require(_value > 0);
267         require(_value <= balances[seller]);
268 
269         balances[seller] = safeSub(balances[seller], _value);
270         balances[_to] = safeAdd(balances[_to], _value);
271         Transfer(seller, _to, _value);
272 
273         tokensSold = safeAdd(tokensSold, _value);
274         totalSales = safeAdd(totalSales, 1);
275         Sell(seller, _to, _value);
276 
277         return true;
278     }
279 
280     function transfer(address _to, uint256 _value) onlyUnlocked public returns (bool) {
281         return super.transfer(_to, _value);
282     }
283 
284     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked public returns (bool) {
285         return super.transferFrom(_from, _to, _value);
286     }
287 
288     function lock() onlyOwner public {
289         locked = true;
290         Lock();
291     }
292 
293     function unlock() onlyOwner public {
294         locked = false;
295         Unlock();
296     }
297 
298     function burn(uint256 _value) public returns (bool) {
299         require(_value > 0);
300         require(_value <= balances[msg.sender]);
301 
302         balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
303         totalSupply = safeSub(totalSupply, _value);
304         Transfer(msg.sender, 0x0, _value);
305         Burn(msg.sender, _value);
306 
307         return true;
308     }
309 
310     /* Approve and then communicate the approved contract in a single tx */
311     function approveAndCall(address _spender, uint256 _value) public {
312         TokenSpender spender = TokenSpender(_spender);
313         if (approve(_spender, _value)) {
314             spender.receiveApproval(msg.sender, _value);
315         }
316     }
317 }
318 
319 contract XToken is CommonBsToken {
320 
321     function XToken() public CommonBsToken(
322         0xE3E9F66E5Ebe9E961662da34FF9aEA95c6795fd0,     // TODO address _seller (main holder of all tokens)
323         'X full',
324         'X short',
325         100 * 1e6, // Max token supply.
326         40 * 1e6   // Sale limit - max tokens that can be sold through all tiers of tokensale.
327     ) { }
328 }