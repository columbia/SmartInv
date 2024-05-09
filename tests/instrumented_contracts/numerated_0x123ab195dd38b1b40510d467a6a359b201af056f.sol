1 pragma solidity ^0.4.13;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract Ownable {
50     address public owner;
51     address public newOwner;
52 
53     event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function Ownable() public {
61         owner = msg.sender;
62     }
63 
64     /// @notice Transfer ownership from `owner` to `newOwner`
65     /// @param _newOwner The new contract owner
66     function transferOwnership(address _newOwner) public onlyOwner {
67         if (_newOwner != address(0)) {
68             newOwner = _newOwner;
69         }
70     }
71 
72     /// @notice accept ownership of the contract
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 
79 }
80 
81 contract LegolasBase is Ownable {
82 
83     mapping (address => uint256) public balances;
84 
85     // Initial amount received from the pre-sale (doesn't include bonus)
86     mapping (address => uint256) public initialAllocations;
87     // Initial amount received from the pre-sale (includes bonus)
88     mapping (address => uint256) public allocations;
89     // False if part of the allocated amount is spent
90     mapping (uint256 => mapping(address => bool)) public eligibleForBonus;
91     // unspent allocated amount by period
92     mapping (uint256 => uint256) public unspentAmounts;
93     // List of founders addresses
94     mapping (address => bool) public founders;
95     // List of advisors addresses
96     mapping (address => bool) public advisors;
97 
98     // Release dates for adviors: one twelfth released each month.
99     uint256[12] public ADVISORS_LOCK_DATES = [1521072000, 1523750400, 1526342400,
100                                        1529020800, 1531612800, 1534291200,
101                                        1536969600, 1539561600, 1542240000,
102                                        1544832000, 1547510400, 1550188800];
103     // Release dates for founders: After one year, one twelfth released each month.
104     uint256[12] public FOUNDERS_LOCK_DATES = [1552608000, 1555286400, 1557878400,
105                                        1560556800, 1563148800, 1565827200,
106                                        1568505600, 1571097600, 1573776000,
107                                        1576368000, 1579046400, 1581724800];
108 
109     // Bonus dates: each 6 months during 2 years
110     uint256[4] public BONUS_DATES = [1534291200, 1550188800, 1565827200, 1581724800];
111 
112     /// @param _address The address from which the locked amount will be retrieved
113     /// @return The amount locked for _address.
114     function getLockedAmount(address _address) internal view returns (uint256 lockedAmount) {
115         // Only founders and advisors have locks
116         if (!advisors[_address] && !founders[_address]) return 0;
117         // Determine release dates
118         uint256[12] memory lockDates = advisors[_address] ? ADVISORS_LOCK_DATES : FOUNDERS_LOCK_DATES;
119         // Determine how many twelfths are locked
120         for (uint8 i = 11; i >= 0; i--) {
121             if (now >= lockDates[i]) {
122                 return (allocations[_address] / 12) * (11 - i);
123             }
124         }
125         return allocations[_address];
126     }
127 
128     function updateBonusEligibity(address _from) internal {
129         if (now < BONUS_DATES[3] &&
130             initialAllocations[_from] > 0 &&
131             balances[_from] < allocations[_from]) {
132             for (uint8 i = 0; i < 4; i++) {
133                 if (now < BONUS_DATES[i] && eligibleForBonus[BONUS_DATES[i]][_from]) {
134                     unspentAmounts[BONUS_DATES[i]] -= initialAllocations[_from];
135                     eligibleForBonus[BONUS_DATES[i]][_from] = false;
136                 }
137             }
138         }
139     }
140 }
141 
142 contract EIP20 is EIP20Interface, LegolasBase {
143 
144     uint256 constant private MAX_UINT256 = 2**256 - 1;
145     mapping (address => mapping (address => uint256)) public allowed;
146 
147 
148     /*
149     NOTE:
150     The following variables are OPTIONAL vanities. One does not have to include them.
151     They allow one to customise the token contract & in no way influences the core functionality.
152     Some wallets/interfaces might not even bother to look at this information.
153     */
154     string public name;                   //fancy name: eg Simon Bucks
155     uint8 public decimals;                //How many decimals to show.
156     string public symbol;                 //An identifier: eg SBX
157 
158     function EIP20(
159         uint256 _initialAmount,
160         string _tokenName,
161         uint8 _decimalUnits,
162         string _tokenSymbol
163     ) public {
164         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
165         totalSupply = _initialAmount;                        // Update total supply
166         name = _tokenName;                                   // Set the name for display purposes
167         decimals = _decimalUnits;                            // Amount of decimals for display purposes
168         symbol = _tokenSymbol;                               // Set the symbol for display purposes
169     }
170 
171     function transfer(address _to, uint256 _value) public returns (bool success) {
172         require(balances[msg.sender] >= _value);
173         // Check locked amount
174         require(balances[msg.sender] - _value >= getLockedAmount(msg.sender));
175         balances[msg.sender] -= _value;
176         balances[_to] += _value;
177 
178         // Bonus lost if balance is lower than the original allocation
179         updateBonusEligibity(msg.sender);
180 
181         Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
186         uint256 allowance = allowed[_from][msg.sender];
187         require(balances[_from] >= _value && allowance >= _value);
188 
189         // Check locked amount
190         require(balances[_from] - _value >= getLockedAmount(_from));
191 
192         balances[_to] += _value;
193         balances[_from] -= _value;
194         if (allowance < MAX_UINT256) {
195             allowed[_from][msg.sender] -= _value;
196         }
197 
198         // Bonus lost if balance is lower than the original allocation
199         updateBonusEligibity(_from);
200 
201         Transfer(_from, _to, _value);
202         return true;
203     }
204 
205     function balanceOf(address _owner) public view returns (uint256 balance) {
206         return balances[_owner];
207     }
208 
209     function approve(address _spender, uint256 _value) public returns (bool success) {
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
216         return allowed[_owner][_spender];
217     }
218 }
219 
220 contract Legolas is EIP20 {
221 
222     // Standard ERC20 information
223     string  constant NAME = "LGO Token";
224     string  constant SYMBOL = "LGO";
225     uint8   constant DECIMALS = 8;
226     uint256 constant UNIT = 10**uint256(DECIMALS);
227 
228     uint256 constant onePercent = 181415052000000;
229 
230     // 5% for advisors
231     uint256 constant ADVISORS_AMOUNT =   5 * onePercent;
232     // 15% for founders
233     uint256 constant FOUNDERS_AMOUNT =  15 * onePercent;
234     // 60% sold in pre-sale
235     uint256 constant HOLDERS_AMOUNT  =  60 * onePercent;
236     // 20% reserve
237     uint256 constant RESERVE_AMOUNT  =  20 * onePercent;
238     // ADVISORS_AMOUNT + FOUNDERS_AMOUNT + HOLDERS_AMOUNT +RESERVE_AMOUNT
239     uint256 constant INITIAL_AMOUNT  = 100 * onePercent;
240     // 20% for holder bonus
241     uint256 constant BONUS_AMOUNT    =  20 * onePercent;
242     // amount already allocated to advisors
243     uint256 public advisorsAllocatedAmount = 0;
244     // amount already allocated to funders
245     uint256 public foundersAllocatedAmount = 0;
246     // amount already allocated to holders
247     uint256 public holdersAllocatedAmount = 0;
248     // list of all initial holders
249     address[] initialHolders;
250     // not distributed because the defaut value is false
251     mapping (uint256 => mapping(address => bool)) bonusNotDistributed;
252 
253     event Allocate(address _address, uint256 _value);
254 
255     function Legolas() EIP20( // EIP20 constructor
256         INITIAL_AMOUNT + BONUS_AMOUNT,
257         NAME,
258         DECIMALS,
259         SYMBOL
260     ) public {}
261 
262     /// @param _address The address of the recipient
263     /// @param _amount Amount of the allocation
264     /// @param _type Type of the recipient. 0 for advisor, 1 for founders.
265     /// @return Whether the allocation was successful or not
266     function allocate(address _address, uint256 _amount, uint8 _type) public onlyOwner returns (bool success) {
267         // one allocations by address
268         require(allocations[_address] == 0);
269 
270         if (_type == 0) { // advisor
271             // check allocated amount
272             require(advisorsAllocatedAmount + _amount <= ADVISORS_AMOUNT);
273             // increase allocated amount
274             advisorsAllocatedAmount += _amount;
275             // mark address as advisor
276             advisors[_address] = true;
277         } else if (_type == 1) { // founder
278             // check allocated amount
279             require(foundersAllocatedAmount + _amount <= FOUNDERS_AMOUNT);
280             // increase allocated amount
281             foundersAllocatedAmount += _amount;
282             // mark address as founder
283             founders[_address] = true;
284         } else {
285             // check allocated amount
286             require(holdersAllocatedAmount + _amount <= HOLDERS_AMOUNT + RESERVE_AMOUNT);
287             // increase allocated amount
288             holdersAllocatedAmount += _amount;
289         }
290         // set allocation
291         allocations[_address] = _amount;
292         initialAllocations[_address] = _amount;
293 
294         // increase balance
295         balances[_address] += _amount;
296 
297         // update variables for bonus distribution
298         for (uint8 i = 0; i < 4; i++) {
299             // increase unspent amount
300             unspentAmounts[BONUS_DATES[i]] += _amount;
301             // initialize bonus eligibility
302             eligibleForBonus[BONUS_DATES[i]][_address] = true;
303             bonusNotDistributed[BONUS_DATES[i]][_address] = true;
304         }
305 
306         // add to initial holders list
307         initialHolders.push(_address);
308 
309         Allocate(_address, _amount);
310 
311         return true;
312     }
313 
314     /// @param _address Holder address.
315     /// @param _bonusDate Date of the bonus to distribute.
316     /// @return Whether the bonus distribution was successful or not
317     function claimBonus(address _address, uint256 _bonusDate) public returns (bool success) {
318         /// bonus date must be past
319         require(_bonusDate <= now);
320         /// disrtibute bonus only once
321         require(bonusNotDistributed[_bonusDate][_address]);
322         /// disrtibute bonus only if eligible
323         require(eligibleForBonus[_bonusDate][_address]);
324 
325         // calculate the bonus for one holded LGO
326         uint256 bonusByLgo = (BONUS_AMOUNT / 4) / unspentAmounts[_bonusDate];
327 
328         // distribute the bonus
329         uint256 holderBonus = initialAllocations[_address] * bonusByLgo;
330         balances[_address] += holderBonus;
331         allocations[_address] += holderBonus;
332 
333         // set bonus as distributed
334         bonusNotDistributed[_bonusDate][_address] = false;
335         return true;
336     }
337 }