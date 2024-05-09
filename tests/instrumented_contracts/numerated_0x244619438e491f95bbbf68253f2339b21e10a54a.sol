1 contract Math {
2   function mul(uint a, uint b) internal returns (uint) {
3     uint c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint a, uint b) internal returns (uint) {
9     assert(b > 0);
10     uint c = a / b;
11     assert(a == b * c + a % b);
12     return c;
13   }
14 
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 
26   function assert(bool assertion) internal {
27     if (!assertion) {
28       throw;
29     }
30   }
31 }
32 // Abstract contract for the full ERC 20 Token standard
33 // https://github.com/ethereum/EIPs/issues/20
34 
35 
36 contract Token {
37     /* This is a slight change to the ERC20 base standard.
38     function totalSupply() constant returns (uint256 supply);
39     is replaced with:
40     uint256 public totalSupply;
41     This automatically creates a getter function for the totalSupply.
42     This is moved to the base contract since public getter functions are not
43     currently recognised as an implementation of the matching abstract
44     function by the compiler.
45     */
46     /// total amount of tokens
47     uint256 public totalSupply;
48     uint256 public totalDividends;
49     uint public voteEnds = 1;
50     /// @param _owner The address from which the balance will be retrieved
51     /// @return The balance
52     function balanceOf(address _owner) constant returns (uint256 balance);
53 
54     function voteBalance(address _owner) constant returns (uint256 balance);
55 
56     function voteCount(address _proposal) constant returns (uint256 count);
57 
58     // /// @notice send `_value` token to `_to` from `msg.sender`
59     // /// @param _to The address of the recipient
60     // /// @param _value The amount of token to be transferred
61     // /// @return Whether the transfer was successful or not
62     // function transfer(address _to, uint256 _value) returns (bool success);
63 
64     // /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
65     // /// @param _from The address of the sender
66     // /// @param _to The address of the recipient
67     // /// @param _value The amount of token to be transferred
68     // /// @return Whether the transfer was successful or not
69     // function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
70 
71     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
72     /// @param _spender The address of the account able to transfer the tokens
73     /// @param _value The amount of tokens to be approved for transfer
74     /// @return Whether the approval was successful or not
75     function approve(address _spender, uint256 _value) returns (bool success);
76 
77     /// @param _owner The address of the account owning tokens
78     /// @param _spender The address of the account able to transfer the tokens
79     /// @return remaining of remaining tokens allowed to spent
80     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
81 
82     function transfer(address _to, uint256 _value) returns (bool success);
83 
84     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
85     /// @param _from The address of the sender
86     /// @param _to The address of the recipient
87     /// @param _value The amount of token to be transferred
88     /// @return Whether the transfer was successful or not
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94 }
95 /*
96 You should inherit from StandardToken or, for a token like you would want to
97 deploy in something like Mist, see HumanStandardToken.sol.
98 (This implements ONLY the standard functions and NOTHING else.
99 If you deploy this, you won't have anything useful.)
100 
101 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
102 .*/
103 
104 contract StandardToken is Token {
105 
106     struct Account {
107         uint votes;
108         uint lastVote;
109         uint lastDividends;
110     }
111 
112     modifier voteUpdater(address _to, address _from) {
113         if (accounts[_from].lastVote == voteEnds) {
114             if (accounts[_to].lastVote < voteEnds) {
115                 accounts[_to].votes = balances[_to];
116                 accounts[_to].lastVote = voteEnds;
117             }
118         } else if (accounts[_from].lastVote < voteEnds) {
119             accounts[_from].votes = balances[_from];
120             accounts[_from].lastVote = voteEnds;
121             if (accounts[_to].lastVote < voteEnds) {
122                 accounts[_to].votes = balances[_to];
123                 accounts[_to].lastVote = voteEnds;
124             }
125         }
126         _;
127 
128     }
129     modifier updateAccount(address account) {
130       var owing = dividendsOwing(account);
131       if(owing > 0) {
132         account.send(owing);
133         accounts[account].lastDividends = totalDividends;
134       }
135       _;
136     }
137     function dividendsOwing(address account) internal returns(uint) {
138       var newDividends = totalDividends - accounts[account].lastDividends;
139       return (balances[account] * newDividends) / totalSupply;
140     }
141     function balanceOf(address _owner) constant returns (uint256 balance) {
142         return balances[_owner];
143     }
144     function voteCount(address _proposal) constant returns (uint256 count) {
145         return votes[_proposal];
146     }
147     function voteBalance(address _owner) constant returns (uint256 balance)
148     {
149         return accounts[_owner].votes;
150 
151     }
152     function approve(address _spender, uint256 _value) returns (bool success) {
153         allowed[msg.sender][_spender] = _value;
154         Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159       return allowed[_owner][_spender];
160     }
161 
162     function transfer(address _to, uint256 _value) 
163     updateAccount(msg.sender)
164     voteUpdater(_to, msg.sender)
165     returns (bool success) 
166     {
167         //Default assumes totalSupply can't be over max (2^256 - 1).
168         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
169         //Replace the if with this one instead.
170         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
171         if (balances[msg.sender] >= _value && _value > 0) {
172             balances[msg.sender] -= _value;
173             balances[_to] += _value;
174             Transfer(msg.sender, _to, _value);
175             return true;
176         } else { return false; }
177     }
178 
179     function transferFrom(address _from, address _to, uint256 _value)
180     updateAccount(msg.sender) 
181     voteUpdater(_to, _from)
182     returns (bool success) 
183     {
184         //same as above. Replace this line with the following if you want to protect against wrapping uints.
185         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
186         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
187             balances[_to] += _value;
188             balances[_from] -= _value;
189             allowed[_from][msg.sender] -= _value;
190             Transfer(_from, _to, _value);
191             return true;
192         } else { return false; }
193     }
194     mapping (address => uint256) balances;
195     mapping (address => mapping (address => uint256)) allowed;
196     mapping (address => Account) accounts;
197     mapping (address => uint ) votes;
198 }
199 
200 // Created By: Strategic Investments in Strategic Areas Group
201 
202 contract SISA is StandardToken, Math {
203 
204 
205 	string constant public name = "SISA Token";
206 	string constant public symbol = "SISA";
207 	uint constant public decimals = 18;
208 
209 	address public ico_tokens = 0x1111111111111111111111111111111111111111;
210 	address public preICO_tokens = 0x2222222222222222222222222222222222222222;
211 	address public bounty_funds;
212 	address public founder;
213 	address public admin;
214 	address public team_funds;
215 	address public issuer;
216 	address public preseller;
217 
218 
219 
220 
221 
222 	function () payable {
223 	  totalDividends += msg.value;
224 	  //deduct(msg.sender, amount);
225 	}
226 
227 
228 	modifier onlyFounder() {
229 	    // Only founder is allowed to do this action.
230 	    if (msg.sender != founder) {
231 	        throw;
232 	    }
233 	    _;
234 	}
235 	modifier onlyAdmin() {
236 	    // Only admin is allowed to do this action.
237 	    if (msg.sender != admin) {
238 	        throw;
239 	    }
240 	    _;
241 	}
242     modifier onlyIssuer() {
243         // Only Issuer is allowed to proceed.
244         if (msg.sender != issuer) {
245             throw;
246         }
247         _;
248     }
249 
250 
251     // modifier hasNotVoted() {
252     // 	if (voted[msg.sender]){
253     // 		throw;
254     // 	}
255     // 	_;
256     // }
257     // function voteCount(address _proposal) 
258     //     public
259     //     returns (uint256) 
260     // {
261     //     return votes[_proposal];
262     // }
263     // function voteBalance(address _owner) 
264     //     public
265     //     constant returns (uint256)
266     // {
267     //     return accounts[_owner].votes;
268 
269     // }
270     function castVote(address proposal) 
271     	public
272     {
273     	if (accounts[msg.sender].lastVote < voteEnds) {
274     		accounts[msg.sender].votes = balances[msg.sender];
275     		accounts[msg.sender].lastVote = voteEnds;
276 
277     	} else if (accounts[msg.sender].votes == 0 ) {
278     		throw;
279     	}
280     	votes[proposal] = accounts[msg.sender].votes;
281     	accounts[msg.sender].votes = 0;
282     	
283     }
284     function callVote() 
285     	public
286     	onlyAdmin
287     	returns (bool)
288     {
289     	voteEnds = now + 7 days;
290 
291     }
292     function issueTokens(address _for, uint256 amount)
293         public
294         onlyIssuer
295         returns (bool)
296     {
297         if(allowed[ico_tokens][issuer] >= amount) { 
298             transferFrom(ico_tokens, _for, amount);
299 
300             // Issue(_for, msg.sender, amount);
301             return true;
302         } else {
303             throw;
304         }
305     }
306     function changePreseller(address newAddress)
307         external
308         onlyAdmin
309         returns (bool)
310     {    
311         delete allowed[preICO_tokens][preseller];
312         preseller = newAddress;
313 
314         allowed[preICO_tokens][preseller] = balanceOf(preICO_tokens);
315 
316         return true;
317     }
318     function changeIssuer(address newAddress)
319         external
320         onlyAdmin
321         returns (bool)
322     {    
323         delete allowed[ico_tokens][issuer];
324         issuer = newAddress;
325 
326         allowed[ico_tokens][issuer] = balanceOf(ico_tokens);
327 
328         return true;
329     }
330 	function SISA(address _founder, address _admin, address _bounty, address _team) {
331 		founder = _founder;
332 		admin = _admin;
333 		bounty_funds = _bounty;
334 		team_funds = _team;
335 		totalSupply = 50000000 * 1 ether;
336 		balances[preICO_tokens] = 5000000 * 1 ether;
337 		balances[bounty_funds] = 3000000 * 1 ether;
338 		balances[team_funds] = 7000000 * 1 ether;
339 		balances[ico_tokens] = 32500000 * 1 ether;
340 
341 
342 
343 	}
344 
345 }