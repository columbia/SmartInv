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
46     function balanceOf(address _owner) constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60 
61     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of tokens to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
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
83     function balanceOf(address _owner) constant returns (uint256 balance) {
84         return balances[_owner];
85     }
86 
87     /// @dev Transfers sender's tokens to a given address. Returns success.
88     /// @param _to Address of token receiver.
89     /// @param _value Number of tokens to transfer.
90     function transfer(address _to, uint256 _value) returns (bool) {
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
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
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
116     function approve(address _spender, uint256 _value) returns (bool) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     /// @dev Returns number of allowed tokens for given address.
123     /// @param _owner Address of token owner.
124     /// @param _spender Address of token spender.
125     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
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
158     function addOwner(address owner) onlyOwner returns (bool) {
159         if (!isOwner(owner) && owner != 0) {
160             ownerMap[owner] = true;
161             owners.push(owner);
162 
163             OwnerAdded(owner);
164             return true;
165         } else return false;
166     }
167 
168     function removeOwner(address owner) onlyOwner returns (bool) {
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
191     bool public locked;
192 
193     string public name;
194     string public symbol;
195     uint256 public totalSupply;
196     uint8 public decimals = 18;
197     string public version = 'v0.1';
198 
199     address public creator;
200     address public seller;
201     uint256 public tokensSold;
202     uint256 public totalSales;
203 
204     event Sell(address indexed _seller, address indexed _buyer, uint256 _value);
205     event SellerChanged(address indexed _oldSeller, address indexed _newSeller);
206 
207     modifier onlyUnlocked() {
208         if (!isOwner(msg.sender) && locked) throw;
209         _;
210     }
211 
212     function CommonBsToken(string _name, string _symbol, uint256 _totalSupplyNoDecimals, address _seller) MultiOwnable() {
213 
214         // Lock the transfer function during the presale/crowdsale to prevent speculations.
215         locked = true;
216 
217         creator = msg.sender;
218         seller = _seller;
219 
220         name = _name;
221         symbol = _symbol;
222         totalSupply = _totalSupplyNoDecimals * 1e18;
223 
224         balances[seller] = totalSupply;
225         Transfer(0x0, seller, totalSupply);
226     }
227 
228     function changeSeller(address newSeller) onlyOwner returns (bool) {
229         require(newSeller != 0x0 && seller != newSeller);
230 
231         address oldSeller = seller;
232 
233         uint256 unsoldTokens = balances[oldSeller];
234         balances[oldSeller] = 0;
235         balances[newSeller] = safeAdd(balances[newSeller], unsoldTokens);
236         Transfer(oldSeller, newSeller, unsoldTokens);
237 
238         seller = newSeller;
239         SellerChanged(oldSeller, newSeller);
240         return true;
241     }
242 
243     function sellNoDecimals(address _to, uint256 _value) returns (bool) {
244         return sell(_to, _value * 1e18);
245     }
246 
247     function sell(address _to, uint256 _value) onlyOwner returns (bool) {
248         if (balances[seller] >= _value && _value > 0) {
249             balances[seller] = safeSub(balances[seller], _value);
250             balances[_to] = safeAdd(balances[_to], _value);
251             Transfer(seller, _to, _value);
252 
253             tokensSold = safeAdd(tokensSold, _value);
254             totalSales = safeAdd(totalSales, 1);
255             Sell(seller, _to, _value);
256             return true;
257         } else return false;
258     }
259 
260     function transfer(address _to, uint256 _value) onlyUnlocked returns (bool) {
261         return super.transfer(_to, _value);
262     }
263 
264     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns (bool) {
265         return super.transferFrom(_from, _to, _value);
266     }
267 
268     function lock() onlyOwner {
269         locked = true;
270     }
271 
272     function unlock() onlyOwner {
273         locked = false;
274     }
275 
276     function burn(uint256 _value) returns (bool) {
277         if (balances[msg.sender] >= _value && _value > 0) {
278             balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
279             totalSupply = safeSub(totalSupply, _value);
280             Transfer(msg.sender, 0x0, _value);
281             return true;
282         } else return false;
283     }
284 
285     /* Approve and then communicate the approved contract in a single tx */
286     function approveAndCall(address _spender, uint256 _value) {
287         TokenSpender spender = TokenSpender(_spender);
288         if (approve(_spender, _value)) {
289             spender.receiveApproval(msg.sender, _value);
290         }
291     }
292 }
293 
294 contract BsToken is CommonBsToken {
295 
296     function BsToken() CommonBsToken(
297         'TestJ Full',
298         'TestJ',
299         923076925,  // max token supply
300         0x1D2b0A204f9609c9d044Bde67b70D511d6273527       // TODO address _seller (main holder of all tokens)
301     ) { }
302 }