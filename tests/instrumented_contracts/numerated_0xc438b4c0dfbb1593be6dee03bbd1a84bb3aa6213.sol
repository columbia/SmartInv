1 pragma solidity ^0.4.18;
2 
3 
4 /// @title Abstract ERC20 token interface
5 contract AbstractToken {
6 
7     function totalSupply() constant returns (uint256) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16     event Issuance(address indexed to, uint256 value);
17 }
18 
19 
20 contract Owned {
21 
22     address public owner = msg.sender;
23     address public potentialOwner;
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     modifier onlyPotentialOwner {
31         require(msg.sender == potentialOwner);
32         _;
33     }
34 
35     event NewOwner(address old, address current);
36     event NewPotentialOwner(address old, address potential);
37 
38     function setOwner(address _new)
39         public
40         onlyOwner
41     {
42         NewPotentialOwner(owner, _new);
43         potentialOwner = _new;
44     }
45 
46     function confirmOwnership()
47         public
48         onlyPotentialOwner
49     {
50         NewOwner(owner, potentialOwner);
51         owner = potentialOwner;
52         potentialOwner = 0;
53     }
54 }
55 
56 
57 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 contract StandardToken is AbstractToken, Owned {
59 
60     /*
61      *  Data structures
62      */
63     mapping (address => uint256) balances;
64     mapping (address => mapping (address => uint256)) allowed;
65     uint256 public totalSupply;
66 
67     /*
68      *  Read and write storage functions
69      */
70     /// @dev Transfers sender's tokens to a given address. Returns success.
71     /// @param _to Address of token receiver.
72     /// @param _value Number of tokens to transfer.
73     function transfer(address _to, uint256 _value) returns (bool success) {
74         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
75             balances[msg.sender] -= _value;
76             balances[_to] += _value;
77             Transfer(msg.sender, _to, _value);
78             return true;
79         }
80         else {
81             return false;
82         }
83     }
84 
85     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
86     /// @param _from Address from where tokens are withdrawn.
87     /// @param _to Address to where tokens are sent.
88     /// @param _value Number of tokens to transfer.
89     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
90       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
91             balances[_to] += _value;
92             balances[_from] -= _value;
93             allowed[_from][msg.sender] -= _value;
94             Transfer(_from, _to, _value);
95             return true;
96         }
97         else {
98             return false;
99         }
100     }
101 
102     /// @dev Returns number of tokens owned by given address.
103     /// @param _owner Address of token owner.
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     /// @dev Sets approved amount of tokens for spender. Returns success.
109     /// @param _spender Address of allowed account.
110     /// @param _value Number of approved tokens.
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /*
118      * Read storage functions
119      */
120     /// @dev Returns number of allowed tokens for given address.
121     /// @param _owner Address of token owner.
122     /// @param _spender Address of token spender.
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124       return allowed[_owner][_spender];
125     }
126 
127 }
128 
129 
130 /// @title SafeMath contract - Math operations with safety checks.
131 /// @author OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
132 contract SafeMath {
133     function mul(uint a, uint b) internal returns (uint) {
134         uint c = a * b;
135         assert(a == 0 || c / a == b);
136         return c;
137     }
138 
139     function div(uint a, uint b) internal returns (uint) {
140         assert(b > 0);
141         uint c = a / b;
142         assert(a == b * c + a % b);
143         return c;
144     }
145 
146     function sub(uint a, uint b) internal returns (uint) {
147         assert(b <= a);
148         return a - b;
149     }
150 
151     function add(uint a, uint b) internal returns (uint) {
152         uint c = a + b;
153         assert(c >= a);
154         return c;
155     }
156 
157     function pow(uint a, uint b) internal returns (uint) {
158         uint c = a ** b;
159         assert(c >= a);
160         return c;
161     }
162 }
163 
164 
165 /// @title Token contract - Implements Standard ERC20 with additional features.
166 /// @author Zerion - <inbox@zerion.io>
167 contract Token is StandardToken, SafeMath {
168 
169     // Time of the contract creation
170     uint public creationTime;
171 
172     function Token() {
173         creationTime = now;
174     }
175 
176 
177     /// @dev Owner can transfer out any accidentally sent ERC20 tokens
178     function transferERC20Token(address tokenAddress)
179         public
180         onlyOwner
181         returns (bool)
182     {
183         uint balance = AbstractToken(tokenAddress).balanceOf(this);
184         return AbstractToken(tokenAddress).transfer(owner, balance);
185     }
186 
187     /// @dev Multiplies the given number by 10^(decimals)
188     function withDecimals(uint number, uint decimals)
189         internal
190         returns (uint)
191     {
192         return mul(number, pow(10, decimals));
193     }
194 }
195 
196 
197 /// @title Token contract - Implements Standard ERC20 Token for Qchain project.
198 /// @author Zerion - <inbox@zerion.io>
199 contract QchainToken is Token {
200 
201     /*
202      * Token meta data
203      */
204     string constant public name = "Ethereum Qchain Token";
205     string constant public symbol = "EQC";
206     uint8 constant public decimals = 8;
207 
208     // Address where Foundation tokens are allocated
209     address constant public foundationReserve = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
210 
211     // Address where all tokens for the ICO stage are initially allocated
212     address constant public icoAllocation = 0x1111111111111111111111111111111111111111;
213 
214     // Address where all tokens for the PreICO are initially allocated
215     address constant public preIcoAllocation = 0x2222222222222222222222222222222222222222;
216 
217     // ICO start date. 10/24/2017 @ 9:00pm (UTC)
218     uint256 constant public startDate = 1508878800;
219     uint256 constant public duration = 42 days;
220 
221     // Public key of the signer
222     address public signer;
223 
224     // Foundation multisignature wallet, all Ether is collected there
225     address public multisig;
226 
227     /// @dev Contract constructor, sets totalSupply
228     function QchainToken(address _signer, address _multisig)
229     {
230         // Overall, 375,000,000 EQC tokens are distributed
231         totalSupply = withDecimals(375000000, decimals);
232 
233         // 11,500,000 tokens were sold during the PreICO
234         uint preIcoTokens = withDecimals(11500000, decimals);
235 
236         // 40% of total supply is allocated for the Foundation
237         balances[foundationReserve] = div(mul(totalSupply, 40), 100);
238 
239         // PreICO tokens are allocated to the special address and will be distributed manually
240         balances[preIcoAllocation] = preIcoTokens;
241 
242         // The rest of the tokens is available for sale
243         balances[icoAllocation] = totalSupply - preIcoTokens - balanceOf(foundationReserve);
244 
245         // Allow the owner to distribute tokens from the PreICO allocation address
246         allowed[preIcoAllocation][msg.sender] = balanceOf(preIcoAllocation);
247 
248         // Allow the owner to withdraw tokens from the Foundation reserve
249         allowed[foundationReserve][msg.sender] = balanceOf(foundationReserve);
250 
251         signer = _signer;
252         multisig = _multisig;
253     }
254 
255     modifier icoIsActive {
256         require(now >= startDate && now < startDate + duration);
257         _;
258     }
259 
260     modifier icoIsCompleted {
261         require(now >= startDate + duration);
262         _;
263     }
264 
265     /// @dev Settle an investment and distribute tokens
266     function invest(address investor, uint256 tokenPrice, uint256 value, bytes32 hash, uint8 v, bytes32 r, bytes32 s)
267         public
268         icoIsActive
269         payable
270     {
271         // Check the hash
272         require(sha256(uint(investor) << 96 | tokenPrice) == hash);
273 
274         // Check the signature
275         require(ecrecover(hash, v, r, s) == signer);
276 
277         // Difference between the value argument and actual value should not be
278         // more than 0.005 ETH (gas commission)
279         require(sub(value, msg.value) <= withDecimals(5, 15));
280 
281         // Number of tokens to distribute
282         uint256 tokensNumber = div(withDecimals(value, decimals), tokenPrice);
283 
284         // Check if there is enough tokens left
285         require(balances[icoAllocation] >= tokensNumber);
286 
287         // Send Ether to the multisig
288         require(multisig.send(msg.value));
289 
290         // Allocate tokens to an investor
291         balances[icoAllocation] -= tokensNumber;
292         balances[investor] += tokensNumber;
293         Transfer(icoAllocation, investor, tokensNumber);
294     }
295 
296     /// @dev Overrides Owned.sol function
297     function confirmOwnership()
298         public
299         onlyPotentialOwner
300     {
301         // Allow new owner to withdraw tokens from Foundation reserve and
302         // preICO allocation address
303         allowed[foundationReserve][potentialOwner] = balanceOf(foundationReserve);
304         allowed[preIcoAllocation][potentialOwner] = balanceOf(preIcoAllocation);
305 
306         // Forbid old owner to withdraw tokens from Foundation reserve and
307         // preICO allocation address
308         allowed[foundationReserve][owner] = 0;
309         allowed[preIcoAllocation][owner] = 0;
310 
311         // Change owner
312         super.confirmOwnership();
313     }
314 
315     /// @dev Withdraws tokens from Foundation reserve
316     function withdrawFromReserve(uint amount)
317         public
318         onlyOwner
319     {
320         // Withdraw tokens from Foundation reserve to multisig address
321         require(transferFrom(foundationReserve, multisig, amount));
322     }
323 
324     /// @dev Changes multisig address
325     function changeMultisig(address _multisig)
326         public
327         onlyOwner
328     {
329         multisig = _multisig;
330     }
331 
332     /// @dev Burns the rest of the tokens after the crowdsale end
333     function burn()
334         public
335         onlyOwner
336         icoIsCompleted
337     {
338         totalSupply = sub(totalSupply, balanceOf(icoAllocation));
339         balances[icoAllocation] = 0;
340     }
341 }