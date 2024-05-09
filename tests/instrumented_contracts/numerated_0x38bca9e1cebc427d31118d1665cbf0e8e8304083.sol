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
157     event OwnerAdded(address indexed newOwner);
158     event OwnerRemoved(address indexed oldOwner);
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
172     function isOwner(address owner) constant returns (bool) {
173         return ownerMap[owner];
174     }
175 
176     function addOwner(address owner) onlyOwner returns (bool) {
177         if (!isOwner(owner) && owner != 0) {
178             ownerMap[owner] = true;
179             owners.push(owner);
180 
181             OwnerAdded(owner);
182             return true;
183         } else return false;
184     }
185 
186     function removeOwner(address owner) onlyOwner returns (bool) {
187         if (isOwner(owner)) {
188             ownerMap[owner] = false;
189             for (uint i = 0; i < owners.length - 1; i++) {
190                 if (owners[i] == owner) {
191                     owners[i] = owners[owners.length - 1];
192                     break;
193                 }
194             }
195             owners.length -= 1;
196 
197             OwnerRemoved(owner);
198             return true;
199         } else return false;
200     }
201 }
202 
203 contract TokenSpender {
204     function receiveApproval(address _from, uint256 _value);
205 }
206 
207 contract BsToken is StandardToken, MultiOwnable {
208 
209     bool public locked;
210 
211     string public name;
212     string public symbol;
213     uint256 public totalSupply;
214     uint8 public decimals = 18;
215     string public version = 'v0.1';
216 
217     address public creator;
218     address public seller;
219     uint256 public tokensSold;
220     uint256 public totalSales;
221 
222     event Sell(address indexed seller, address indexed buyer, uint256 value);
223     event SellerChanged(address indexed oldSeller, address indexed newSeller);
224 
225     modifier onlyUnlocked() {
226         if (!isOwner(msg.sender) && locked) throw;
227         _;
228     }
229 
230     function BsToken(string _name, string _symbol, uint256 _totalSupply, address _seller) MultiOwnable() {
231         creator = msg.sender;
232         seller = _seller;
233 
234         name = _name;
235         symbol = _symbol;
236         totalSupply = _totalSupply;
237 
238         balances[seller] = totalSupply;
239     }
240 
241     function changeSeller(address newSeller) onlyOwner returns (bool) {
242         if (newSeller == 0x0 || seller == newSeller) throw;
243 
244         address oldSeller = seller;
245 
246         uint256 unsoldTokens = balances[oldSeller];
247         balances[oldSeller] = 0;
248         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
249 
250         seller = newSeller;
251         SellerChanged(oldSeller, newSeller);
252         return true;
253     }
254 
255     function sell(address _to, uint256 _value) onlyOwner returns (bool) {
256         if (balances[seller] >= _value && _value > 0) {
257             balances[seller] = safeSub(balances[seller], _value);
258             balances[_to] = safeAdd(balances[_to], _value);
259             tokensSold = safeAdd(tokensSold, _value);
260             totalSales = safeAdd(totalSales, 1);
261             Sell(seller, _to, _value);
262             return true;
263         } else return false;
264     }
265 
266     function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
267         return super.transfer(_to, _value);
268     }
269 
270     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
271         return super.transferFrom(_from, _to, _value);
272     }
273 
274     function lock() onlyOwner {
275         locked = true;
276     }
277 
278     function unlock() onlyOwner {
279         locked = false;
280     }
281 
282     function burn(uint256 _value) returns (bool) {
283         if (balances[msg.sender] >= _value && _value > 0) {
284             balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
285             totalSupply = safeSub(totalSupply, _value);
286             Transfer(msg.sender, 0x0, _value);
287             return true;
288         } else return false;
289     }
290 
291     /* Approve and then communicate the approved contract in a single tx */
292     function approveAndCall(address _spender, uint256 _value) {
293         TokenSpender spender = TokenSpender(_spender);
294         if (approve(_spender, _value)) {
295             spender.receiveApproval(msg.sender, _value);
296         }
297     }
298 }
299 
300 contract BsToken_SNOV is BsToken {
301 
302     function BsToken_SNOV()
303         BsToken(
304             'Snovio',
305             'SNOV',
306             2500000000 * 1e18,
307             0x0697ec0e4F90E7D7c92E7eDD1c039f442d7F1d1D
308         ) { }
309 }