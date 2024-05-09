1 pragma solidity ^0.4.11;
2 
3 contract SafeMath {
4 
5     function safeMul(uint256 a, uint256 b) internal returns (uint256 ) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function safeDiv(uint256 a, uint256 b) internal returns (uint256 ) {
12         assert(b > 0);
13         uint256 c = a / b;
14         assert(a == b * c + a % b);
15         return c;
16     }
17 
18     function safeSub(uint256 a, uint256 b) internal returns (uint256 ) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function safeAdd(uint256 a, uint256 b) internal returns (uint256 ) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30         return a >= b ? a : b;
31     }
32 
33     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34         return a < b ? a : b;
35     }
36 
37     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38         return a >= b ? a : b;
39     }
40 
41     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42         return a < b ? a : b;
43     }
44 
45     function assert(bool assertion) internal {
46         if (!assertion) {
47             throw;
48         }
49     }
50 }
51 
52 contract ERC20 {
53 
54     /* This is a slight change to the ERC20 base standard.
55     function totalSupply() constant returns (uint256 supply);
56     is replaced with:
57     uint256 public totalSupply;
58     This automatically creates a getter function for the totalSupply.
59     This is moved to the base contract since public getter functions are not
60     currently recognised as an implementation of the matching abstract
61     function by the compiler.
62     */
63     /// total amount of tokens
64     uint256 public totalSupply;
65 
66     /// @param _owner The address from which the balance will be retrieved
67     /// @return The balance
68     function balanceOf(address _owner) constant returns (uint256 balance);
69 
70     /// @notice send `_value` token to `_to` from `msg.sender`
71     /// @param _to The address of the recipient
72     /// @param _value The amount of token to be transferred
73     /// @return Whether the transfer was successful or not
74     function transfer(address _to, uint256 _value) returns (bool success);
75 
76     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
77     /// @param _from The address of the sender
78     /// @param _to The address of the recipient
79     /// @param _value The amount of token to be transferred
80     /// @return Whether the transfer was successful or not
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
82 
83     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
84     /// @param _spender The address of the account able to transfer the tokens
85     /// @param _value The amount of tokens to be approved for transfer
86     /// @return Whether the approval was successful or not
87     function approve(address _spender, uint256 _value) returns (bool success);
88 
89     /// @param _owner The address of the account owning tokens
90     /// @param _spender The address of the account able to transfer the tokens
91     /// @return Amount of remaining tokens allowed to spent
92     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
93 
94     event Transfer(address indexed _from, address indexed _to, uint256 _value);
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }
97 
98 contract StandardToken is ERC20, SafeMath {
99 
100     mapping(address => uint256) balances;
101     mapping(address => mapping(address => uint256)) allowed;
102 
103     /// @dev Returns number of tokens owned by given address.
104     /// @param _owner Address of token owner.
105     function balanceOf(address _owner) constant returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     /// @dev Transfers sender's tokens to a given address. Returns success.
110     /// @param _to Address of token receiver.
111     /// @param _value Number of tokens to transfer.
112     function transfer(address _to, uint256 _value) returns (bool) {
113         if (balances[msg.sender] >= _value && _value > 0) {
114             balances[msg.sender] = safeSub(balances[msg.sender], _value);
115             balances[_to] = safeAdd(balances[_to], _value);
116             Transfer(msg.sender, _to, _value);
117             return true;
118         } else return false;
119     }
120 
121     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
122     /// @param _from Address from where tokens are withdrawn.
123     /// @param _to Address to where tokens are sent.
124     /// @param _value Number of tokens to transfer.
125     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
126         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
127             balances[_to] = safeAdd(balances[_to], _value);
128             balances[_from] = safeSub(balances[_from], _value);
129             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
130             Transfer(_from, _to, _value);
131             return true;
132         } else return false;
133     }
134 
135     /// @dev Sets approved amount of tokens for spender. Returns success.
136     /// @param _spender Address of allowed account.
137     /// @param _value Number of approved tokens.
138     function approve(address _spender, uint256 _value) returns (bool) {
139         allowed[msg.sender][_spender] = _value;
140         Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /// @dev Returns number of allowed tokens for given address.
145     /// @param _owner Address of token owner.
146     /// @param _spender Address of token spender.
147     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }
150 }
151 
152 contract MultiOwnable {
153 
154     mapping (address => bool) ownerMap;
155     address[] public owners;
156 
157     event OwnerAdded(address indexed _newOwner);
158     event OwnerRemoved(address indexed _oldOwner);
159 
160     modifier onlyOwner() {
161         if (!isOwner(msg.sender)) throw;
162         _;
163     }
164 
165     function MultiOwnable() {
166         // Add default owner
167         address owner = msg.sender;
168         ownerMap[owner] = true;
169         owners.push(owner);
170     }
171 
172     function ownerCount() constant returns (uint256) {
173         return owners.length;
174     }
175 
176     function isOwner(address owner) constant returns (bool) {
177         return ownerMap[owner];
178     }
179 
180     function addOwner(address owner) onlyOwner returns (bool) {
181         if (!isOwner(owner) && owner != 0) {
182             ownerMap[owner] = true;
183             owners.push(owner);
184 
185             OwnerAdded(owner);
186             return true;
187         } else return false;
188     }
189 
190     function removeOwner(address owner) onlyOwner returns (bool) {
191         if (isOwner(owner)) {
192             ownerMap[owner] = false;
193             for (uint i = 0; i < owners.length - 1; i++) {
194                 if (owners[i] == owner) {
195                     owners[i] = owners[owners.length - 1];
196                     break;
197                 }
198             }
199             owners.length -= 1;
200 
201             OwnerRemoved(owner);
202             return true;
203         } else return false;
204     }
205 }
206 
207 contract TokenSpender {
208     function receiveApproval(address _from, uint256 _value);
209 }
210 
211 contract BsToken is StandardToken, MultiOwnable {
212 
213     bool public locked;
214 
215     string public name;
216     string public symbol;
217     uint256 public totalSupply;
218     uint8 public decimals = 18;
219     string public version = 'v0.1';
220 
221     address public creator;
222     address public seller;
223     uint256 public tokensSold;
224     uint256 public totalSales;
225 
226     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
227     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
228 
229     modifier onlyUnlocked() {
230         if (!isOwner(msg.sender) && locked) throw;
231         _;
232     }
233 
234     function BsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {
235 
236         // Lock the transfer function during the presale/crowdsale to prevent speculations.
237         locked = true;
238 
239         creator = msg.sender;
240         seller = _seller;
241 
242         name = _name;
243         symbol = _symbol;
244         totalSupply = _totalSupplyNoDecimals * 1e18;
245 
246         balances[seller] = totalSupply;
247         Transfer(0x0, seller, totalSupply);
248     }
249 
250     function changeSeller(address newSeller) onlyOwner returns (bool) {
251         if (newSeller == 0x0 || seller == newSeller) throw;
252 
253         address oldSeller = seller;
254 
255         uint256 unsoldTokens = balances[oldSeller];
256         balances[oldSeller] = 0;
257         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
258         Transfer(oldSeller, newSeller, unsoldTokens);
259 
260         seller = newSeller;
261         SellerChanged(oldSeller, newSeller);
262         return true;
263     }
264 
265     function sellNoDecimals(address _to, uint256 _value) returns (bool) {
266         return sell(_to, _value * 1e18);
267     }
268 
269     function sell(address _to, uint256 _value) onlyOwner returns (bool) {
270         if (balances[seller] >= _value && _value > 0) {
271             balances[seller] = safeSub(balances[seller], _value);
272             balances[_to] = safeAdd(balances[_to], _value);
273             Transfer(seller, _to, _value);
274 
275             tokensSold = safeAdd(tokensSold, _value);
276             totalSales = safeAdd(totalSales, 1);
277             Sell(seller, _to, _value);
278             return true;
279         } else return false;
280     }
281 
282     function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
283         return super.transfer(_to, _value);
284     }
285 
286     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
287         return super.transferFrom(_from, _to, _value);
288     }
289 
290     function lock() onlyOwner {
291         locked = true;
292     }
293 
294     function unlock() onlyOwner {
295         locked = false;
296     }
297 
298     function burn(uint256 _value) returns (bool) {
299         if (balances[msg.sender] >= _value && _value > 0) {
300             balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
301             totalSupply = safeSub(totalSupply, _value);
302             Transfer(msg.sender, 0x0, _value);
303             return true;
304         } else return false;
305     }
306 
307     /* Approve and then communicate the approved contract in a single tx */
308     function approveAndCall(address _spender, uint256 _value) {
309         TokenSpender spender = TokenSpender(_spender);
310         if (approve(_spender, _value)) {
311             spender.receiveApproval(msg.sender, _value);
312         }
313     }
314 }
315 
316 contract BsToken_SNOV is BsToken {
317 
318     function BsToken_SNOV()
319         BsToken(
320             'Snovio',
321             'SNOV',
322             2500000000,
323             0xDaE3f1D824127754Aca9Eb5E5bFBAC22d8A04A52
324         ) { }
325 }