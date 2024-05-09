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
78 contract StandardToken is Token {
79 
80     struct Account {
81         uint votes;
82         uint lastVote;
83         uint lastDividends;
84     }
85 
86     modifier voteUpdater(address _to, address _from) {
87         if (accounts[_from].lastVote == voteEnds) {
88             if (accounts[_to].lastVote < voteEnds) {
89                 accounts[_to].votes = balances[_to];
90                 accounts[_to].lastVote = voteEnds;
91             }
92         } else if (accounts[_from].lastVote < voteEnds) {
93             accounts[_from].votes = balances[_from];
94             accounts[_from].lastVote = voteEnds;
95             if (accounts[_to].lastVote < voteEnds) {
96                 accounts[_to].votes = balances[_to];
97                 accounts[_to].lastVote = voteEnds;
98             }
99         }
100         _;
101 
102     }
103     modifier updateAccount(address account) {
104       var owing = dividendsOwing(account);
105       if(owing > 0) {
106         account.send(owing);
107         accounts[account].lastDividends = totalDividends;
108       }
109       _;
110     }
111     function dividendsOwing(address account) internal returns(uint) {
112       var newDividends = totalDividends - accounts[account].lastDividends;
113       return (balances[account] * newDividends) / totalSupply;
114     }
115     function balanceOf(address _owner) constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118     function voteCount(address _proposal) constant returns (uint256 count) {
119         return votes[_proposal];
120     }
121     function voteBalance(address _owner) constant returns (uint256 balance)
122     {
123         return accounts[_owner].votes;
124 
125     }
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
133       return allowed[_owner][_spender];
134     }
135 
136     function transfer(address _to, uint256 _value) 
137     updateAccount(msg.sender)
138     voteUpdater(_to, msg.sender)
139     returns (bool success) 
140     {
141         //Default assumes totalSupply can't be over max (2^256 - 1).
142         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
143         //Replace the if with this one instead.
144         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
145         if (balances[msg.sender] >= _value && _value > 0) {
146             balances[msg.sender] -= _value;
147             balances[_to] += _value;
148             Transfer(msg.sender, _to, _value);
149             return true;
150         } else { return false; }
151     }
152 
153     function transferFrom(address _from, address _to, uint256 _value)
154     updateAccount(msg.sender) 
155     voteUpdater(_to, _from)
156     returns (bool success) 
157     {
158         //same as above. Replace this line with the following if you want to protect against wrapping uints.
159         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
160         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
161             balances[_to] += _value;
162             balances[_from] -= _value;
163             allowed[_from][msg.sender] -= _value;
164             Transfer(_from, _to, _value);
165             return true;
166         } else { return false; }
167     }
168     mapping (address => uint256) balances;
169     mapping (address => mapping (address => uint256)) allowed;
170     mapping (address => Account) accounts;
171     mapping (address => uint ) votes;
172 }
173 contract SISA is StandardToken, Math {
174 
175 
176 	string constant public name = "SISA Token";
177 	string constant public symbol = "SISA";
178 	uint constant public decimals = 18;
179 
180 	address public ico_tokens = 0x1111111111111111111111111111111111111111;
181 	address public preICO_tokens = 0x2222222222222222222222222222222222222222;
182 	address public bounty_funds;
183 	address public founder;
184 	address public admin;
185 	address public team_funds;
186 	address public issuer;
187 	address public preseller;
188 
189 
190 
191 
192 
193 	function () payable {
194 	  totalDividends += msg.value;
195 	  //deduct(msg.sender, amount);
196 	}
197 
198 
199 	modifier onlyFounder() {
200 	    // Only founder is allowed to do this action.
201 	    if (msg.sender != founder) {
202 	        throw;
203 	    }
204 	    _;
205 	}
206 	modifier onlyAdmin() {
207 	    // Only admin is allowed to do this action.
208 	    if (msg.sender != admin) {
209 	        throw;
210 	    }
211 	    _;
212 	}
213     modifier onlyIssuer() {
214         // Only Issuer is allowed to proceed.
215         if (msg.sender != issuer) {
216             throw;
217         }
218         _;
219     }
220 
221 
222     function castVote(address proposal) 
223     	public
224     {
225     	if (accounts[msg.sender].lastVote < voteEnds) {
226     		accounts[msg.sender].votes = balances[msg.sender];
227     		accounts[msg.sender].lastVote = voteEnds;
228 
229     	} else if (accounts[msg.sender].votes == 0 ) {
230     		throw;
231     	}
232     	votes[proposal] = accounts[msg.sender].votes;
233     	accounts[msg.sender].votes = 0;
234     	
235     }
236     function callVote() 
237     	public
238     	onlyAdmin
239     	returns (bool)
240     {
241     	voteEnds = now + 7 days;
242 
243     }
244     function issueTokens(address _for, uint256 amount)
245         public
246         onlyIssuer
247         returns (bool)
248     {
249         if(allowed[ico_tokens][issuer] >= amount) { 
250             transferFrom(ico_tokens, _for, amount);
251 
252             // Issue(_for, msg.sender, amount);
253             return true;
254         } else {
255             throw;
256         }
257     }
258     function changePreseller(address newAddress)
259         external
260         onlyAdmin
261         returns (bool)
262     {    
263         delete allowed[preICO_tokens][preseller];
264         preseller = newAddress;
265 
266         allowed[preICO_tokens][preseller] = balanceOf(preICO_tokens);
267 
268         return true;
269     }
270     function changeIssuer(address newAddress)
271         external
272         onlyAdmin
273         returns (bool)
274     {    
275         delete allowed[ico_tokens][issuer];
276         issuer = newAddress;
277 
278         allowed[ico_tokens][issuer] = balanceOf(ico_tokens);
279 
280         return true;
281     }
282 	function SISA(address _founder, address _admin, address _bounty, address _team) {
283 		founder = _founder;
284 		admin = _admin;
285 		bounty_funds = _bounty;
286 		team_funds = _team;
287 		totalSupply = 50000000 * 1 ether;
288 		balances[preICO_tokens] = 5000000 * 1 ether;
289 		balances[bounty_funds] += 3000000 * 1 ether;
290 		balances[team_funds] += 7000000 * 1 ether;
291 		balances[ico_tokens] = 32500000 * 1 ether;
292 
293 
294 
295 	}
296 
297 }