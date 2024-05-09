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
32 contract Token {
33     /* This is a slight change to the ERC20 base standard.
34     function totalSupply() constant returns (uint256 supply);
35     is replaced with:
36     uint256 public totalSupply;
37     This automatically creates a getter function for the totalSupply.
38     This is moved to the base contract since public getter functions are not
39     currently recognised as an implementation of the matching abstract
40     function by the compiler.
41     */
42     /// total amount of tokens
43     uint256 public totalSupply;
44     uint256 public totalDividends;
45     uint public voteEnds = 1;
46     /// @param _owner The address from which the balance will be retrieved
47     /// @return The balance
48     function balanceOf(address _owner) constant returns (uint256 balance);
49 
50     function voteBalance(address _owner) constant returns (uint256 balance);
51 
52     function voteCount(address _proposal) constant returns (uint256 count);
53 
54     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @param _value The amount of tokens to be approved for transfer
57     /// @return Whether the approval was successful or not
58     function approve(address _spender, uint256 _value) returns (bool success);
59 
60     /// @param _owner The address of the account owning tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @return remaining of remaining tokens allowed to spent
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
64 
65     function transfer(address _to, uint256 _value) returns (bool success);
66 
67     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
68     /// @param _from The address of the sender
69     /// @param _to The address of the recipient
70     /// @param _value The amount of token to be transferred
71     /// @return Whether the transfer was successful or not
72     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
73 
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77 }
78 
79 contract StandardToken is Token {
80 
81     struct Account {
82         uint votes;
83         uint lastVote;
84         uint lastDividends;
85     }
86 
87     modifier voteUpdater(address _to, address _from) {
88         if (accounts[_from].lastVote == voteEnds) {
89             if (accounts[_to].lastVote < voteEnds) {
90                 accounts[_to].votes = balances[_to];
91                 accounts[_to].lastVote = voteEnds;
92             }
93         } else if (accounts[_from].lastVote < voteEnds) {
94             accounts[_from].votes = balances[_from];
95             accounts[_from].lastVote = voteEnds;
96             if (accounts[_to].lastVote < voteEnds) {
97                 accounts[_to].votes = balances[_to];
98                 accounts[_to].lastVote = voteEnds;
99             }
100         }
101         _;
102 
103     }
104     modifier updateAccount(address account) {
105       var owing = dividendsOwing(account);
106       if(owing > 0) {
107         account.send(owing);
108         accounts[account].lastDividends = totalDividends;
109       }
110       _;
111     }
112     function dividendsOwing(address account) internal returns(uint) {
113       var newDividends = totalDividends - accounts[account].lastDividends;
114       return (balances[account] * newDividends) / totalSupply;
115     }
116     function balanceOf(address _owner) constant returns (uint256 balance) {
117         return balances[_owner];
118     }
119     function voteCount(address _proposal) constant returns (uint256 count) {
120         return votes[_proposal];
121     }
122     function voteBalance(address _owner) constant returns (uint256 balance)
123     {
124         return accounts[_owner].votes;
125 
126     }
127     function approve(address _spender, uint256 _value) returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
134       return allowed[_owner][_spender];
135     }
136 
137     function transfer(address _to, uint256 _value) 
138     updateAccount(msg.sender)
139     updateAccount(_to)
140     voteUpdater(_to, msg.sender)
141     returns (bool success) 
142     {
143         //Default assumes totalSupply can't be over max (2^256 - 1).
144         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
145         //Replace the if with this one instead.
146         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
147         if (balances[msg.sender] >= _value && _value > 0) {
148             balances[msg.sender] -= _value;
149             balances[_to] += _value;
150             Transfer(msg.sender, _to, _value);
151             return true;
152         } else { return false; }
153     }
154 
155     function transferFrom(address _from, address _to, uint256 _value)
156     updateAccount(_from)
157     updateAccount(_to)  
158     voteUpdater(_to, _from)
159     returns (bool success) 
160     {
161         //same as above. Replace this line with the following if you want to protect against wrapping uints.
162         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
163         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
164             balances[_to] += _value;
165             balances[_from] -= _value;
166             allowed[_from][msg.sender] -= _value;
167             Transfer(_from, _to, _value);
168             return true;
169         } else { return false; }
170     }
171     mapping (address => uint256) balances;
172     mapping (address => mapping (address => uint256)) allowed;
173     mapping (address => Account) accounts;
174     mapping (address => uint ) votes;
175 }
176 
177 contract SISA is StandardToken, Math {
178 
179 
180 	string constant public name = "SISA Token";
181 	string constant public symbol = "SISA";
182 	uint constant public decimals = 18;
183 
184 	address public ico_tokens = 0x1111111111111111111111111111111111111111;
185 	address public preICO_tokens = 0x2222222222222222222222222222222222222222;
186 	address public bounty_funds;
187 	address public founder;
188 	address public admin;
189 	address public team_funds;
190 	address public issuer;
191 	address public preseller;
192 
193 
194 
195 
196 
197 	function () payable {
198 	  totalDividends += msg.value;
199 	  //deduct(msg.sender, amount);
200 	}
201 
202 
203 	modifier onlyFounder() {
204 	    // Only founder is allowed to do this action.
205 	    if (msg.sender != founder) {
206 	        throw;
207 	    }
208 	    _;
209 	}
210 	modifier onlyAdmin() {
211 	    // Only admin is allowed to do this action.
212 	    if (msg.sender != admin) {
213 	        throw;
214 	    }
215 	    _;
216 	}
217     modifier onlyIssuer() {
218         // Only Issuer is allowed to proceed.
219         if (msg.sender != issuer) {
220             throw;
221         }
222         _;
223     }
224 
225 
226     function castVote(address proposal) 
227     	public
228     {
229     	if (accounts[msg.sender].lastVote < voteEnds) {
230     		accounts[msg.sender].votes = balances[msg.sender];
231     		accounts[msg.sender].lastVote = voteEnds;
232 
233     	} else if (accounts[msg.sender].votes == 0 ) {
234     		throw;
235     	}
236     	votes[proposal] = accounts[msg.sender].votes;
237     	accounts[msg.sender].votes = 0;
238     	
239     }
240     function callVote() 
241     	public
242     	onlyAdmin
243     	returns (bool)
244     {
245     	voteEnds = now + 7 days;
246 
247     }
248     function issueTokens(address _for, uint256 amount)
249         public
250         onlyIssuer
251         returns (bool)
252     {
253         if(allowed[ico_tokens][issuer] >= amount) { 
254             transferFrom(ico_tokens, _for, amount);
255 
256             // Issue(_for, msg.sender, amount);
257             return true;
258         } else {
259             throw;
260         }
261     }
262     function changePreseller(address newAddress)
263         external
264         onlyAdmin
265         returns (bool)
266     {    
267         delete allowed[preICO_tokens][preseller];
268         preseller = newAddress;
269 
270         allowed[preICO_tokens][preseller] = balanceOf(preICO_tokens);
271 
272         return true;
273     }
274     function changeIssuer(address newAddress)
275         external
276         onlyAdmin
277         returns (bool)
278     {    
279         delete allowed[ico_tokens][issuer];
280         issuer = newAddress;
281 
282         allowed[ico_tokens][issuer] = balanceOf(ico_tokens);
283 
284         return true;
285     }
286 	function SISA(address _founder, address _admin, address _bounty, address _team) {
287 		founder = _founder;
288 		admin = _admin;
289 		bounty_funds = _bounty;
290 		team_funds = _team;
291 		totalSupply = 50000000 * 1 ether;
292 		balances[preICO_tokens] = 5000000 * 1 ether;
293 		balances[bounty_funds] += 3000000 * 1 ether;
294 		balances[team_funds] += 7000000 * 1 ether;
295 		balances[ico_tokens] = 32500000 * 1 ether;
296 
297 
298 
299 	}
300 
301 }