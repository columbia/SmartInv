1 /**
2  *Submitted for verification at Etherscan.io on 2017-10-03
3 */
4 
5 pragma solidity ^0.4.15;
6 /*
7     Utilities & Common Modifiers
8 */
9 contract Utils {
10     /**
11         constructor
12     */
13     function Utils() {
14     }
15 
16     // validates an address - currently only checks that it isn'tteam view online! xD null
17     modifier validAddress(address _address) {
18         require(_address != 0x0);
19         _;
20     }
21 
22     // verifies that the address is different than this contract address
23     modifier notThis(address _address) {
24         require(_address != address(this));
25         _;
26     }
27 
28     // Overflow protected math functions
29 
30     /**
31         @dev returns the sum of _x and _y, asserts if the calculation overflows
32 
33         @param _x   value 1
34         @param _y   value 2
35 
36         @return sum
37     */
38     function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {
39         uint256 z = _x + _y;
40         assert(z >= _x);
41         return z;
42     }
43 
44     /**
45         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
46 
47         @param _x   minuend
48         @param _y   subtrahend
49 
50         @return difference
51     */
52     function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {
53         assert(_x >= _y);
54         return _x - _y;
55     }
56 
57     /**
58         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
59 
60         @param _x   factor 1
61         @param _y   factor 2
62 
63         @return product
64     */
65     function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {
66         uint256 z = _x * _y;
67         assert(_x == 0 || z / _x == _y);
68         return z;
69     }
70 }
71 
72 /*
73     ERC20 Standard Token interface
74 */
75 contract IERC20Token {
76     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
77     function name() public constant returns (string) { name; }
78     function symbol() public constant returns (string) { symbol; }
79     function decimals() public constant returns (uint8) { decimals; }
80     function totalSupply() public constant returns (uint256) { totalSupply; }
81     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
82     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
83 
84     function transfer(address _to, uint256 _value) public returns (bool success);
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
86     function approve(address _spender, uint256 _value) public returns (bool success);
87 }
88 
89 
90 /**
91     ERC20 Standard Token implementation
92 */
93 contract ERC20Token is IERC20Token, Utils {
94     string public standard = "Token 0.1";
95     string public name = "";
96     string public symbol = "";
97     uint8 public decimals = 0;
98     uint256 public totalSupply = 0;
99     mapping (address => uint256) public balanceOf;
100     mapping (address => mapping (address => uint256)) public allowance;
101 
102     event Transfer(address indexed _from, address indexed _to, uint256 _value);
103     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
104 
105     /**
106         @dev constructor
107 
108         @param _name        token name
109         @param _symbol      token symbol
110         @param _decimals    decimal points, for display purposes
111     */
112     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
113         require(bytes(_name).length > 0 && bytes(_symbol).length > 0); // validate input
114 
115         name = _name;
116         symbol = _symbol;
117         decimals = _decimals;
118     }
119 
120     /**
121         @dev send coins
122         throws on any error rather then return a false flag to minimize user errors
123 
124         @param _to      target address
125         @param _value   transfer amount
126 
127         @return true if the transfer was successful, false if it wasn't
128     */
129     function transfer(address _to, uint256 _value)
130         public
131         validAddress(_to)
132         returns (bool success)
133     {
134         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
135         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     /**
141         @dev an account/contract attempts to get the coins
142         throws on any error rather then return a false flag to minimize user errors
143 
144         @param _from    source address
145         @param _to      target address
146         @param _value   transfer amount
147 
148         @return true if the transfer was successful, false if it wasn't
149     */
150     function transferFrom(address _from, address _to, uint256 _value)
151         public
152         validAddress(_from)
153         validAddress(_to)
154         returns (bool success)
155     {
156         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
157         balanceOf[_from] = safeSub(balanceOf[_from], _value);
158         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
159         Transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164         @dev allow another account/contract to spend some tokens on your behalf
165         throws on any error rather then return a false flag to minimize user errors
166 
167         also, to minimize the risk of the approve/transferFrom attack vector
168         (see https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/), approve has to be called twice
169         in 2 separate transactions - once to change the allowance to 0 and secondly to change it to the new allowance value
170 
171         @param _spender approved address
172         @param _value   allowance amount
173 
174         @return true if the approval was successful, false if it wasn't
175     */
176     function approve(address _spender, uint256 _value)
177         public
178         validAddress(_spender)
179         returns (bool success)
180     {
181         // if the allowance isn't 0, it can only be updated to 0 to prevent an allowance change immediately after withdrawal
182         require(_value == 0 || allowance[msg.sender][_spender] == 0);
183 
184         allowance[msg.sender][_spender] = _value;
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 }
189 
190 /*
191     Owned contract interface
192 */
193 contract IOwned {
194     // this function isn't abstract since the compiler emits automatically generated getter functions as external
195     function owner() public constant returns (address) { owner; }
196 
197     function transferOwnership(address _newOwner) public;
198     function acceptOwnership() public;
199 }
200 
201 /*
202     Provides support and utilities for contract ownership
203 */
204 contract Owned is IOwned {
205     address public owner;
206     address public newOwner;
207 
208     event OwnerUpdate(address _prevOwner, address _newOwner);
209 
210     /**
211         @dev constructor
212     */
213     function Owned() {
214         owner = msg.sender;
215     }
216 
217     // allows execution by the owner only
218     modifier ownerOnly {
219         assert(msg.sender == owner);
220         _;
221     }
222 
223     /**
224         @dev allows transferring the contract ownership
225         the new owner still needs to accept the transfer
226         can only be called by the contract owner
227 
228         @param _newOwner    new contract owner
229     */
230     function transferOwnership(address _newOwner) public ownerOnly {
231         require(_newOwner != owner);
232         newOwner = _newOwner;
233     }
234 
235     /**
236         @dev used by a new owner to accept an ownership transfer
237     */
238     function acceptOwnership() public {
239         require(msg.sender == newOwner);
240         OwnerUpdate(owner, newOwner);
241         owner = newOwner;
242         newOwner = 0x0;
243     }
244 }
245 
246 /*
247     Token Holder interface
248 */
249 contract ITokenHolder is IOwned {
250     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
251 }
252 
253 /*
254     We consider every contract to be a 'token holder' since it's currently not possible
255     for a contract to deny receiving tokens.
256 
257     The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
258     the owner to send tokens that were sent to the contract by mistake back to their sender.
259 */
260 contract TokenHolder is ITokenHolder, Owned, Utils {
261     /**
262         @dev constructor
263     */
264     function TokenHolder() {
265     }
266 
267     /**
268         @dev withdraws tokens held by the contract and sends them to an account
269         can only be called by the owner
270 
271         @param _token   ERC20 token contract address
272         @param _to      account to receive the new amount
273         @param _amount  amount to withdraw
274     */
275     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
276         public
277         ownerOnly
278         validAddress(_token)
279         validAddress(_to)
280         notThis(_to)
281     {
282         assert(_token.transfer(_to, _amount));
283     }
284 }
285 
286 
287 contract KUBToken is ERC20Token, TokenHolder {
288 
289 ///////////////////////////////////////// VARIABLE INITIALIZATION /////////////////////////////////////////
290 
291     uint256 constant public KUB_UNIT = 10 ** 10;
292     uint256 public totalSupply = 500 * (10**6) * KUB_UNIT;
293 
294     //  Constants
295     address public kublaiWalletOwner;                                            // Wallet to receive tokens
296 
297     //  Variables
298 
299     uint256 public totalAllocated = 0;                                           // Counter to keep track of overall token allocation
300     uint256 constant public endTime = 1509494340;                                // 10/31/2017 @ 11:59pm (UTC) crowdsale end time (in seconds)
301 
302     bool internal isReleasedToPublic = false;                         // Flag to allow transfer/transferFrom before the end of the crowdfund
303 
304     uint256 internal teamTranchesReleased = 0;                          // Track how many tranches (allocations of 12.5% team tokens) have been released
305     uint256 internal maxTeamTranches = 8;                               // The number of tranches allowed to the team until depleted
306 
307 ///////////////////////////////////////// MODIFIERS /////////////////////////////////////////
308 
309     // Enjin Team timelock
310     modifier safeTimelock() {
311         require(now >= endTime + 6 * 4 weeks);
312         _;
313     }
314 
315     // Advisor Team timelock
316     modifier advisorTimelock() {
317         require(now >= endTime + 2 * 4 weeks);
318         _;
319     }
320 
321     function KUBToken(address _kublaiWalletOwner)
322     ERC20Token("kublaicoin", "KUB", 10)
323      {
324         kublaiWalletOwner = _kublaiWalletOwner;
325         //advisorAddress = _advisorAddress;
326         //kublaiTeamAddress = _kublaiTeamAddress;
327         //incentivisationFundAddress = _incentivisationFundAddress;
328         //balanceOf[_crowdFundAddress] = minCrowdsaleAllocation + maxPresaleSupply;
329         //balanceOf[_incentivisationFundAddress] = incentivisationAllocation;
330     }
331 
332 
333     function releaseApolloTokens(uint256 _value) safeTimelock ownerOnly returns(bool success) {
334         uint256 apolloAmount = _value * KUB_UNIT;
335         require(apolloAmount + totalAllocated < totalSupply);
336         balanceOf[kublaiWalletOwner] = safeAdd(balanceOf[kublaiWalletOwner], apolloAmount);
337         Transfer(0x0, kublaiWalletOwner, apolloAmount);
338         totalAllocated = safeAdd(totalAllocated, apolloAmount);
339         return true;
340     }
341 
342 
343     function allowTransfers() ownerOnly {
344         isReleasedToPublic = true;
345     }
346 
347     function isTransferAllowed() internal constant returns(bool) {
348         if (now > endTime || isReleasedToPublic == true) {
349             return true;
350         }
351         return false;
352     }
353 }