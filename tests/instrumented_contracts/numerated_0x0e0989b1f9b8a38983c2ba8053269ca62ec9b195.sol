1 pragma solidity ^0.4.15;
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
166 /// @author Zerion - <zerion@inbox.com>
167 contract Token is StandardToken, SafeMath {
168     // Time of the contract creation
169     uint public creationTime;
170 
171     function Token() {
172         creationTime = now;
173     }
174 
175 
176     /// @dev Owner can transfer out any accidentally sent ERC20 tokens
177     function transferERC20Token(address tokenAddress)
178         public
179         onlyOwner
180         returns (bool)
181     {
182         uint balance = AbstractToken(tokenAddress).balanceOf(this);
183         return AbstractToken(tokenAddress).transfer(owner, balance);
184     }
185 
186     /// @dev Multiplies the given number by 10^(decimals)
187     function withDecimals(uint number, uint decimals)
188         internal
189         returns (uint)
190     {
191         return mul(number, pow(10, decimals));
192     }
193 }
194 
195 
196 /// @title Token contract - Implements Standard ERC20 Token with Po.et features.
197 /// @author Zerion - <zerion@inbox.com>
198 contract PoetToken is Token {
199 
200     /*
201      * Token meta data
202      */
203     string constant public name = "Po.et";
204     string constant public symbol = "POE";
205     uint8 constant public decimals = 8;
206 
207     // Address where all investors tokens created during the ICO stage initially allocated
208     address constant public icoAllocation = 0x1111111111111111111111111111111111111111;
209 
210     // Address where Foundation tokens are allocated
211     address constant public foundationReserve = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
212 
213     // Number of tokens initially allocated to Foundation
214     uint foundationTokens;
215 
216     // Store number of days in each month
217     mapping(uint8 => uint8) daysInMonth;
218 
219     // UNIX timestamp for September 1, 2017
220     // It's a date when first 2% of foundation reserve will be unlocked
221     uint Sept1_2017 = 1504224000;
222 
223     // Number of days since September 1, 2017 before all tokens will be unlocked
224     uint reserveDelta = 456;
225 
226 
227     /// @dev Contract constructor function sets totalSupply and allocates all ICO tokens to the icoAllocation address
228     function PoetToken()
229     {   
230         // Overall, 3,141,592,653 POE tokens are distributed
231         totalSupply = withDecimals(3141592653, decimals);
232 
233         // Allocate 32% of all tokens to Foundation
234         foundationTokens = div(mul(totalSupply, 32), 100);
235         balances[foundationReserve] = foundationTokens;
236 
237         // Allocate the rest to icoAllocation address
238         balances[icoAllocation] = sub(totalSupply, foundationTokens);
239 
240         // Allow owner to distribute tokens allocated on the icoAllocation address
241         allowed[icoAllocation][owner] = balanceOf(icoAllocation);
242 
243         // Fill mapping with numbers of days
244         // Note: we consider only February of 2018 that has 28 days
245         daysInMonth[1]  = 31; daysInMonth[2]  = 28; daysInMonth[3]  = 31;
246         daysInMonth[4]  = 30; daysInMonth[5]  = 31; daysInMonth[6]  = 30;
247         daysInMonth[7]  = 31; daysInMonth[8]  = 31; daysInMonth[9]  = 30;
248         daysInMonth[10] = 31; daysInMonth[11] = 30; daysInMonth[12] = 31;
249     }
250 
251     /// @dev Sends tokens from icoAllocation to investor
252     function distribute(address investor, uint amount)
253         public
254         onlyOwner
255     {
256         transferFrom(icoAllocation, investor, amount);
257     }
258 
259     /// @dev Overrides Owned.sol function
260     function confirmOwnership()
261         public
262         onlyPotentialOwner
263     {   
264         // Allow new owner to distribute tokens allocated on the icoAllocation address
265         allowed[icoAllocation][potentialOwner] = balanceOf(icoAllocation);
266 
267         // Forbid old owner to distribute tokens
268         allowed[icoAllocation][owner] = 0;
269 
270         // Forbid old owner to withdraw tokens from foundation reserve
271         allowed[foundationReserve][owner] = 0;
272 
273         // Change owner
274         super.confirmOwnership();
275     }
276 
277     /// @dev Overrides StandardToken.sol function
278     function allowance(address _owner, address _spender)
279         public
280         constant
281         returns (uint256 remaining)
282     {
283         if (_owner == foundationReserve && _spender == owner) {
284             return availableReserve();
285         }
286 
287         return allowed[_owner][_spender];
288     }
289 
290     /// @dev Returns max number of tokens that actually can be withdrawn from foundation reserve
291     function availableReserve() 
292         public
293         constant
294         returns (uint)
295     {   
296         // No tokens should be available for withdrawal before September 1, 2017
297         if (now < Sept1_2017) {
298             return 0;
299         }
300 
301         // Number of days passed  since September 1, 2017
302         uint daysPassed = div(sub(now, Sept1_2017), 1 days);
303 
304         // All tokens should be unlocked if reserveDelta days passed
305         if (daysPassed >= reserveDelta) {
306             return balanceOf(foundationReserve);
307         }
308 
309         // Percentage of unlocked tokens by the current date
310         uint unlockedPercentage = 0;
311 
312         uint16 _days = 0;  uint8 month = 9;
313         while (_days <= daysPassed) {
314             unlockedPercentage += 2;
315             _days += daysInMonth[month];
316             month = month % 12 + 1;
317         }
318 
319         // Number of unlocked tokens by the current date
320         uint unlockedTokens = div(mul(totalSupply, unlockedPercentage), 100);
321 
322         // Number of tokens that should remain locked
323         uint lockedTokens = foundationTokens - unlockedTokens;
324 
325         return balanceOf(foundationReserve) - lockedTokens;
326     }
327 
328     /// @dev Withdraws tokens from foundation reserve
329     function withdrawFromReserve(uint amount)
330         public
331         onlyOwner
332     {   
333         // Allow owner to withdraw no more than this amount of tokens
334         allowed[foundationReserve][owner] = availableReserve();
335 
336         // Withdraw tokens from foundation reserve to owner address
337         require(transferFrom(foundationReserve, owner, amount));
338     }
339 }