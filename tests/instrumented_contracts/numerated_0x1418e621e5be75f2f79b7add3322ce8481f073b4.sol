1 pragma solidity ^0.4.13;
2 
3 contract ApproveAndCallFallBack {
4     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
5 }
6 
7 contract ERC20Interface {
8     function totalSupply() public view returns (uint);
9     function balanceOf(address tokenOwner) public view returns (uint balance);
10     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 contract Owned {
20     address public owner;
21     address public newOwner;
22 
23     event OwnershipTransferred(
24         address indexed _from,
25         address indexed _to
26     );
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         emit OwnershipTransferred(owner, newOwner);
44         owner = newOwner;
45         newOwner = address(0);
46     }
47 }
48 
49 contract DataeumToken is Owned, ERC20Interface {
50     // Adding safe calculation methods to uint256
51     using SafeMath for uint256;
52 
53     // Defining balances mapping (ERC20)
54     mapping(address => uint256) balances;
55 
56     // Defining allowances mapping (ERC20)
57     mapping(address => mapping(address => uint256)) allowed;
58 
59     // Defining addresses allowed to bypass global freeze
60     mapping(address => bool) public freezeBypassing;
61 
62     // Defining addresses that have custom lockups periods
63     mapping(address => uint256) public lockupExpirations;
64 
65     // Token Symbol
66     string public constant symbol = "XDT";
67 
68     // Token Name
69     string public constant name = "Dataeum Token";
70 
71     // Token Decimals
72     uint8 public constant decimals = 18;
73 
74     // Current distributed supply
75     uint256 public circulatingSupply = 0;
76 
77     // global freeze one-way toggle
78     bool public tradingLive = false;
79 
80     // Total supply of token
81     uint256 public totalSupply;
82 
83     /**
84      * @notice Event for Lockup period applied to address
85      * @param owner Specific lockup address target
86      * @param until Timestamp when lockup end (seconds since epoch)
87      */
88     event LockupApplied(
89         address indexed owner,
90         uint256 until
91     );
92 
93     /**
94      * @notice Contract constructor
95      * @param _totalSupply Total supply of token wanted
96      */
97     constructor(uint256 _totalSupply) public {
98         totalSupply = _totalSupply;
99     }
100 
101     /**
102      * @notice distribute tokens to an address
103      * @param to Who will receive the token
104      * @param tokens How much token will be sent
105      */
106     function distribute(
107         address to,
108         uint256 tokens
109     )
110         public onlyOwner
111     {
112         uint newCirculatingSupply = circulatingSupply.add(tokens);
113         require(newCirculatingSupply <= totalSupply);
114         circulatingSupply = newCirculatingSupply;
115         balances[to] = balances[to].add(tokens);
116 
117         emit Transfer(address(this), to, tokens);
118     }
119 
120     /**
121      * @notice Prevents the given wallet to transfer its token for the given duration.
122      *      This methods resets the lock duration if one is already in place.
123      * @param wallet The wallet address to lock
124      * @param duration How much time is the token locked from now (in sec)
125      */
126     function lockup(
127         address wallet,
128         uint256 duration
129     )
130         public onlyOwner
131     {
132         uint256 lockupExpiration = duration.add(now);
133         lockupExpirations[wallet] = lockupExpiration;
134         emit LockupApplied(wallet, lockupExpiration);
135     }
136 
137     /**
138      * @notice choose if an address is allowed to bypass the global freeze
139      * @param to Target of the freeze bypass status update
140      * @param status New status (if true will bypass)
141      */
142     function setBypassStatus(
143         address to,
144         bool status
145     )
146         public onlyOwner
147     {
148         freezeBypassing[to] = status;
149     }
150 
151     /**
152      * @notice One-way toggle to allow trading (remove global freeze)
153      */
154     function setTradingLive() public onlyOwner {
155         tradingLive = true;
156     }
157 
158     /**
159      * @notice Modifier that checks if the conditions are met for a token to be
160      * tradable. To be so, it must :
161      *  - Global Freeze must be removed, or, "from" must be allowed to bypass it
162      *  - "from" must not be in a custom lockup period
163      * @param from Who to check the status
164      */
165     modifier tradable(address from) {
166         require(
167             (tradingLive || freezeBypassing[from]) && //solium-disable-line indentation
168             (lockupExpirations[from] <= now)
169         );
170         _;
171     }
172 
173     /**
174      * @notice Return the total supply of the token
175      * @dev This function is part of the ERC20 standard 
176      * @return {"supply": "The token supply"}
177      */
178     function totalSupply() public view returns (uint256 supply) {
179         return totalSupply;
180     }
181 
182     /**
183      * @notice Get the token balance of `owner`
184      * @dev This function is part of the ERC20 standard
185      * @param owner The wallet to get the balance of
186      * @return {"balance": "The balance of `owner`"}
187      */
188     function balanceOf(
189         address owner
190     )
191         public view returns (uint256 balance)
192     {
193         return balances[owner];
194     }
195 
196     /**
197      * @notice Transfers `amount` from msg.sender to `destination`
198      * @dev This function is part of the ERC20 standard
199      * @param destination The address that receives the tokens
200      * @param amount Token amount to transfer
201      * @return {"success": "If the operation completed successfuly"}
202      */
203     function transfer(
204         address destination,
205         uint256 amount
206     )
207         public tradable(msg.sender) returns (bool success)
208     {
209         balances[msg.sender] = balances[msg.sender].sub(amount);
210         balances[destination] = balances[destination].add(amount);
211         emit Transfer(msg.sender, destination, amount);
212         return true;
213     }
214 
215     /**
216      * @notice Transfer tokens from an address to another one
217      * through an allowance made before
218      * @dev This function is part of the ERC20 standard
219      * @param from The address that sends the tokens
220      * @param to The address that receives the tokens
221      * @param tokenAmount Token amount to transfer
222      * @return {"success": "If the operation completed successfuly"}
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 tokenAmount
228     )
229         public tradable(from) returns (bool success)
230     {
231         balances[from] = balances[from].sub(tokenAmount);
232         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokenAmount);
233         balances[to] = balances[to].add(tokenAmount);
234         emit Transfer(from, to, tokenAmount);
235         return true;
236     }
237 
238     /**
239      * @notice Approve an address to send `tokenAmount` tokens to `msg.sender` (make an allowance)
240      * @dev This function is part of the ERC20 standard
241      * @param spender The allowed address
242      * @param tokenAmount The maximum amount allowed to spend
243      * @return {"success": "If the operation completed successfuly"}
244      */
245     function approve(
246         address spender,
247         uint256 tokenAmount
248     )
249         public returns (bool success)
250     {
251         allowed[msg.sender][spender] = tokenAmount;
252         emit Approval(msg.sender, spender, tokenAmount);
253         return true;
254     }
255 
256     /**
257      * @notice Get the remaining allowance for a spender on a given address
258      * @dev This function is part of the ERC20 standard
259      * @param tokenOwner The address that owns the tokens
260      * @param spender The spender
261      * @return {"remaining": "The amount of tokens remaining in the allowance"}
262      */
263     function allowance(
264         address tokenOwner,
265         address spender
266     )
267         public view returns (uint256 remaining)
268     {
269         return allowed[tokenOwner][spender];
270     }
271 
272     /**
273      * @notice Permits to create an approval on a contract and then call a method
274      * on the approved contract right away.
275      * @param spender The allowed address
276      * @param tokenAmount The maximum amount allowed to spend
277      * @param data The data sent back as parameter to the contract (bytes array)
278      * @return {"success": "If the operation completed successfuly"}
279      */
280     function approveAndCall(
281         address spender,
282         uint256 tokenAmount,
283         bytes data
284     )
285         public tradable(spender) returns (bool success)
286     {
287         allowed[msg.sender][spender] = tokenAmount;
288         emit Approval(msg.sender, spender, tokenAmount);
289 
290         ApproveAndCallFallBack(spender)
291             .receiveApproval(msg.sender, tokenAmount, this, data);
292 
293         return true;
294     }
295 
296     /**
297      * @notice Permits to withdraw any ERC20 tokens that have been mistakingly sent to this contract
298      * @param tokenAddress The received ERC20 token address
299      * @param tokenAmount The amount of ERC20 tokens to withdraw from this contract
300      * @return {"success": "If the operation completed successfuly"}
301      */
302     function withdrawERC20Token(
303         address tokenAddress,
304         uint256 tokenAmount
305     )
306         public onlyOwner returns (bool success)
307     {
308         return ERC20Interface(tokenAddress).transfer(owner, tokenAmount);
309     }
310 }
311 
312 library SafeMath {
313     /**
314     * @notice Adds two numbers, throws on overflow.
315     */
316     function add(
317         uint256 a,
318         uint256 b
319     )
320         internal pure returns (uint256 c)
321     {
322         c = a + b;
323         assert(c >= a);
324         return c;
325     }
326 
327     /**
328     * @notice Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
329     */
330     function sub(
331         uint256 a,
332         uint256 b
333     )
334         internal pure returns (uint256)
335     {
336         assert(b <= a);
337         return a - b;
338     }
339 
340 
341     /**
342     * @notice Multiplies two numbers, throws on overflow.
343     */
344     function mul(
345         uint256 a,
346         uint256 b
347     )
348         internal pure returns (uint256 c)
349     {
350         if (a == 0) {
351             return 0;
352         }
353         c = a * b;
354         assert(c / a == b);
355         return c;
356     }
357 
358     /**
359     * @dev Integer division of two numbers, truncating the quotient.
360     */
361     function div(
362         uint256 a,
363         uint256 b
364     )
365         internal pure returns (uint256)
366     {
367         // assert(b > 0); // Solidity automatically throws when dividing by 0
368         // uint256 c = a / b;
369         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370         return a / b;
371     }
372 }