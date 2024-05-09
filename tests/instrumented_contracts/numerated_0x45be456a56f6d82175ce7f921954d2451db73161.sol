1 pragma solidity ^0.4.16;
2 
3 // ----------------------------------------------------------------------------
4 // GBC 'Gaze Bounty Coin' token contract
5 //
6 // Deployed to : 0x45bE456a56f6D82175Ce7f921954d2451Db73161
7 // Symbol      : GBC
8 // Name        : Gaze Bounty Coin
9 // Total supply: Allocate as required
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Gaze 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // ERC Token Standard #20 Interface
20 // https://github.com/ethereum/EIPs/issues/20
21 // ----------------------------------------------------------------------------
22 contract ERC20Interface {
23     uint public totalSupply;
24     function balanceOf(address _account) constant returns (uint balance);
25     function transfer(address _to, uint _value) returns (bool success);
26     function transferFrom(address _from, address _to, uint _value)
27         returns (bool success);
28     function approve(address _spender, uint _value) returns (bool success);
29     function allowance(address _owner, address _spender) constant
30         returns (uint remaining);
31     event Transfer(address indexed _from, address indexed _to, uint _value);
32     event Approval(address indexed _owner, address indexed _spender,
33         uint _value);
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // Owned contract
39 // ----------------------------------------------------------------------------
40 contract Owned {
41 
42     // ------------------------------------------------------------------------
43     // Current owner, and proposed new owner
44     // ------------------------------------------------------------------------
45     address public owner;
46     address public newOwner;
47 
48     // ------------------------------------------------------------------------
49     // Constructor - assign creator as the owner
50     // ------------------------------------------------------------------------
51     function Owned() {
52         owner = msg.sender;
53     }
54 
55 
56     // ------------------------------------------------------------------------
57     // Modifier to mark that a function can only be executed by the owner
58     // ------------------------------------------------------------------------
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63 
64 
65     // ------------------------------------------------------------------------
66     // Owner can initiate transfer of contract to a new owner
67     // ------------------------------------------------------------------------
68     function transferOwnership(address _newOwner) onlyOwner {
69         newOwner = _newOwner;
70     }
71 
72 
73     // ------------------------------------------------------------------------
74     // New owner has to accept transfer of contract
75     // ------------------------------------------------------------------------
76     function acceptOwnership() {
77         require(msg.sender == newOwner);
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = 0x0;
81     }
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // Safe maths, borrowed from OpenZeppelin
88 // ----------------------------------------------------------------------------
89 library SafeMath {
90 
91     // ------------------------------------------------------------------------
92     // Add a number to another number, checking for overflows
93     // ------------------------------------------------------------------------
94     function add(uint a, uint b) internal returns (uint) {
95         uint c = a + b;
96         assert(c >= a && c >= b);
97         return c;
98     }
99 
100     // ------------------------------------------------------------------------
101     // Subtract a number from another number, checking for underflows
102     // ------------------------------------------------------------------------
103     function sub(uint a, uint b) internal returns (uint) {
104         assert(b <= a);
105         return a - b;
106     }
107 }
108 
109 
110 // ----------------------------------------------------------------------------
111 // Administrators, borrowed from Gimli
112 // ----------------------------------------------------------------------------
113 contract Administered is Owned {
114 
115     // ------------------------------------------------------------------------
116     // Mapping of administrators
117     // ------------------------------------------------------------------------
118     mapping (address => bool) public administrators;
119 
120     // ------------------------------------------------------------------------
121     // Add and delete adminstrator events
122     // ------------------------------------------------------------------------
123     event AdminstratorAdded(address adminAddress);
124     event AdminstratorRemoved(address adminAddress);
125 
126 
127     // ------------------------------------------------------------------------
128     // Modifier for functions that can only be executed by adminstrator
129     // ------------------------------------------------------------------------
130     modifier onlyAdministrator() {
131         require(administrators[msg.sender] || owner == msg.sender);
132         _;
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Owner can add a new administrator
138     // ------------------------------------------------------------------------
139     function addAdministrators(address _adminAddress) onlyOwner {
140         administrators[_adminAddress] = true;
141         AdminstratorAdded(_adminAddress);
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Owner can remove an administrator
147     // ------------------------------------------------------------------------
148     function removeAdministrators(address _adminAddress) onlyOwner {
149         delete administrators[_adminAddress];
150         AdminstratorRemoved(_adminAddress);
151     }
152 }
153 
154 
155 // ----------------------------------------------------------------------------
156 // ERC20 Token, with the addition of symbol, name and decimals
157 // ----------------------------------------------------------------------------
158 contract GazeBountyCoin is ERC20Interface, Administered {
159     using SafeMath for uint;
160 
161     // ------------------------------------------------------------------------
162     // Token parameters
163     // ------------------------------------------------------------------------
164     string public constant symbol = "GBC";
165     string public constant name = "Gaze Bounty Coin";
166     uint8 public constant decimals = 18;
167     uint public totalSupply = 0;
168 
169     // ------------------------------------------------------------------------
170     // Administrators can mint until sealed
171     // ------------------------------------------------------------------------
172     bool public sealed;
173 
174     // ------------------------------------------------------------------------
175     // Balances for each account
176     // ------------------------------------------------------------------------
177     mapping(address => uint) balances;
178 
179     // ------------------------------------------------------------------------
180     // Owner of account approves the transfer of an amount to another account
181     // ------------------------------------------------------------------------
182     mapping(address => mapping (address => uint)) allowed;
183 
184 
185     // ------------------------------------------------------------------------
186     // Constructor
187     // ------------------------------------------------------------------------
188     function GazeBountyCoin() Owned() {
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Get the account balance of another account with address _account
194     // ------------------------------------------------------------------------
195     function balanceOf(address _account) constant returns (uint balance) {
196         return balances[_account];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Transfer the balance from owner's account to another account
202     // ------------------------------------------------------------------------
203     function transfer(address _to, uint _amount) returns (bool success) {
204         if (balances[msg.sender] >= _amount             // User has balance
205             && _amount > 0                              // Non-zero transfer
206             && balances[_to] + _amount > balances[_to]  // Overflow check
207         ) {
208             balances[msg.sender] = balances[msg.sender].sub(_amount);
209             balances[_to] = balances[_to].add(_amount);
210             Transfer(msg.sender, _to, _amount);
211             return true;
212         } else {
213             return false;
214         }
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Allow _spender to withdraw from your account, multiple times, up to the
220     // _value amount. If this function is called again it overwrites the
221     // current allowance with _value.
222     // ------------------------------------------------------------------------
223     function approve(
224         address _spender,
225         uint _amount
226     ) returns (bool success) {
227         allowed[msg.sender][_spender] = _amount;
228         Approval(msg.sender, _spender, _amount);
229         return true;
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Spender of tokens transfer an amount of tokens from the token owner's
235     // balance to another account. The owner of the tokens must already
236     // have approve(...)-d this transfer
237     // ------------------------------------------------------------------------
238     function transferFrom(
239         address _from,
240         address _to,
241         uint _amount
242     ) returns (bool success) {
243         if (balances[_from] >= _amount                  // From a/c has balance
244             && allowed[_from][msg.sender] >= _amount    // Transfer approved
245             && _amount > 0                              // Non-zero transfer
246             && balances[_to] + _amount > balances[_to]  // Overflow check
247         ) {
248             balances[_from] = balances[_from].sub(_amount);
249             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
250             balances[_to] = balances[_to].add(_amount);
251             Transfer(_from, _to, _amount);
252             return true;
253         } else {
254             return false;
255         }
256     }
257 
258 
259     // ------------------------------------------------------------------------
260     // Returns the amount of tokens approved by the owner that can be
261     // transferred to the spender's account
262     // ------------------------------------------------------------------------
263     function allowance(
264         address _owner,
265         address _spender
266     ) constant returns (uint remaining) {
267         return allowed[_owner][_spender];
268     }
269 
270 
271     // ------------------------------------------------------------------------
272     // After sealing, no more minting is possible
273     // ------------------------------------------------------------------------
274     function seal() onlyOwner {
275         require(!sealed);
276         sealed = true;
277     }
278 
279 
280     // ------------------------------------------------------------------------
281     // Mint coins for a single account
282     // ------------------------------------------------------------------------
283     function mint(address _to, uint _amount) onlyAdministrator {
284         require(!sealed);
285         require(_to != 0x0);
286         require(_amount != 0);
287         balances[_to] = balances[_to].add(_amount);
288         totalSupply = totalSupply.add(_amount);
289         Transfer(0x0, _to, _amount);
290     }
291 
292 
293     // ------------------------------------------------------------------------
294     // Mint coins for a multiple accounts
295     // ------------------------------------------------------------------------
296     function multiMint(address[] _to, uint[] _amount) onlyAdministrator {
297         require(!sealed);
298         require(_to.length != 0);
299         require(_to.length == _amount.length);
300         for (uint i = 0; i < _to.length; i++) {
301             require(_to[i] != 0x0);
302             require(_amount[i] != 0);
303             balances[_to[i]] = balances[_to[i]].add(_amount[i]);
304             totalSupply = totalSupply.add(_amount[i]);
305             Transfer(0x0, _to[i], _amount[i]);
306         }
307     }
308 
309 
310     // ------------------------------------------------------------------------
311     // Don't accept ethers - no payable modifier
312     // ------------------------------------------------------------------------
313     function () {
314     }
315 
316 
317     // ------------------------------------------------------------------------
318     // Owner can transfer out any accidentally sent ERC20 tokens
319     // ------------------------------------------------------------------------
320     function transferAnyERC20Token(address tokenAddress, uint amount)
321       onlyOwner returns (bool success)
322     {
323         return ERC20Interface(tokenAddress).transfer(owner, amount);
324     }
325 }