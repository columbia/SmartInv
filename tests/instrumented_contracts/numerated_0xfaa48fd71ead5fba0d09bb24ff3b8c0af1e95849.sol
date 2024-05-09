1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) public view returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 // ----------------------------------------------------------------------------
51 // Owned contract
52 // ----------------------------------------------------------------------------
53 contract Owned {
54     address public owner;
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     modifier onlyOwner {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     // Return true if sender is owner or super-owner of the contract
69     function isOwner() internal view returns(bool success) {
70         if (msg.sender == owner) return true;
71         return false;
72     }
73 
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81         newOwner = address(0);
82     }
83 }
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90     using SafeMath for uint256;
91 
92     mapping(address => uint256) balances;
93 
94     /**
95     * @dev transfer token for a specified address
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     */
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         balances[msg.sender] = balances[msg.sender].safeSub(_value);
101         balances[_to] = balances[_to].safeAdd(_value);
102         emit Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     /**
107     * @dev Gets the balance of the specified address.
108     * @param _owner The address to query the the balance of.
109     * @return An uint256 representing the amount owned by the passed address.
110     */
111     function balanceOf(address _owner) public view returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) allowed;
127 
128 
129     /**
130      * @dev Transfer tokens from one address to another
131      * @param _from address The address which you want to send tokens from
132      * @param _to address The address which you want to transfer to
133      * @param _value uint256 the amout of tokens to be transfered
134      */
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136         uint256 _allowance = allowed[_from][msg.sender];
137 
138         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139         // require (_value <= _allowance);
140 
141         balances[_to] = balances[_to].safeAdd(_value);
142         balances[_from] = balances[_from].safeSub(_value);
143         allowed[_from][msg.sender] = _allowance.safeSub(_value);
144         emit Transfer(_from, _to, _value);
145         return true;
146     }
147 
148     /**
149      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      * @param _spender The address which will spend the funds.
151      * @param _value The amount of tokens to be spent.
152      */
153     function approve(address _spender, uint256 _value) public returns (bool) {
154 
155         // To change the approve amount you first have to reduce the addresses`
156         //  allowance to zero by calling `approve(_spender, 0)` if it is not
157         //  already 0 to mitigate the race condition described here:
158         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167     * approve should be called when allowed[_spender] == 0. To increment
168     * allowed value is better to use this function to avoid 2 calls (and wait until
169     * the first transaction is mined)
170     * From MonolithDAO Token.sol
171     */
172     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
173         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].safeAdd(_addedValue);
174         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175         return true;
176     }
177 
178     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
179         uint256 oldValue = allowed[msg.sender][_spender];
180         if (_subtractedValue >= oldValue) {
181             allowed[msg.sender][_spender] = 0;
182         } else {
183             allowed[msg.sender][_spender] = oldValue.safeSub(_subtractedValue);
184         }
185         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189     /**
190      * @dev Function to check the amount of tokens that an owner allowed to a spender.
191      * @param _owner address The address which owns the funds.
192      * @param _spender address The address which will spend the funds.
193      * @return A uint256 specifing the amount of tokens still avaible for the spender.
194      */
195     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
196         return allowed[_owner][_spender];
197     }
198 
199 }
200 
201 /**
202  * @title ENTA is Standard ERC20 token
203  */
204 contract ENTA is StandardToken,Owned {
205 
206     string public name = "ENTA";
207     string public symbol = "ENTA";
208     uint256 public decimals = 8;
209     uint256 public INITIAL_SUPPLY = 2000000000 * (10 ** decimals); // Two billion
210     uint256 public publicSell = 1530374400;//2018-07-01
211 
212     bool public allowTransfers = true; // if true then allow coin transfers
213     mapping (address => bool) public frozenAccount;
214 
215     event FrozenFunds(address indexed target, bool frozen);
216     event MinedBalancesUnlocked(address indexed target, uint256 amount);
217 
218     struct MinedBalance {
219         uint256 total;
220         uint256 left;
221     }
222 
223     mapping(address => MinedBalance) minedBalances;
224 
225     constructor() public {
226         totalSupply = INITIAL_SUPPLY;
227         balances[msg.sender] = INITIAL_SUPPLY;
228     }
229 
230     function transferMined(address to, uint256 tokens) public onlyOwner returns (bool success) {
231         balances[msg.sender] = balances[msg.sender].safeSub(tokens);
232         minedBalances[to].total = minedBalances[to].total.safeAdd(tokens);
233         minedBalances[to].left = minedBalances[to].left.safeAdd(tokens);
234         emit Transfer(msg.sender, to, tokens);
235         return true;
236     }
237 
238     // ------------------------------------------------------------------------
239     // Transfer the balance from token owner's account to to account
240     // - Owner's account must have sufficient balance to transfer
241     // - 0 value transfers are allowed
242     // - @dev override
243     // ------------------------------------------------------------------------
244     function transfer(address to, uint256 tokens) public returns (bool success) {
245         if (!isOwner()) {
246             require (allowTransfers);
247             require(!frozenAccount[msg.sender]);                                        // Check if sender is frozen
248             require(!frozenAccount[to]);                                               // Check if recipient is frozen
249         }
250         
251         if (now >= publicSell) {
252             uint256 month = (now-publicSell)/(30 days);
253             if(month>=7){
254                 unlockMinedBalances(100);
255             } else if(month>=6){
256                 unlockMinedBalances(90);
257             } else if(month>=3){
258                 unlockMinedBalances(80);
259             } else if(month>=2){
260                 unlockMinedBalances(60);
261             } else if(month>=1){
262                 unlockMinedBalances(40);
263             } else if(month>=0){
264                 unlockMinedBalances(20);
265             }
266         }
267         return super.transfer(to,tokens);
268     }
269 
270     function unlockMinedBalances(uint256 unlockPercent) internal {
271         uint256 lockedMinedTokens = minedBalances[msg.sender].total*(100-unlockPercent)/100;
272         if(minedBalances[msg.sender].left > lockedMinedTokens){
273             uint256 unlock = minedBalances[msg.sender].left.safeSub(lockedMinedTokens);
274             minedBalances[msg.sender].left = lockedMinedTokens;
275             balances[msg.sender] = balances[msg.sender].safeAdd(unlock);
276             emit MinedBalancesUnlocked(msg.sender,unlock);
277         }
278     }
279 
280     function setAllowTransfers(bool _allowTransfers) onlyOwner public {
281         allowTransfers = _allowTransfers;
282     }
283 
284     function destroyToken(address target, uint256 amount) onlyOwner public {
285         balances[target] = balances[target].safeSub(amount);
286         totalSupply = totalSupply.safeSub(amount);
287         emit Transfer(target, this, amount);
288         emit Transfer(this, 0, amount);
289     }
290 
291     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
292     /// @param target Address to be frozen
293     /// @param freeze either to freeze it or not
294     function freezeAccount(address target, bool freeze) onlyOwner public {
295         frozenAccount[target] = freeze;
296         emit FrozenFunds(target, freeze);
297     }
298 
299     // @dev override
300     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
301         if (!isOwner()) {
302             require (allowTransfers);
303             require(!frozenAccount[_from]);                                          // Check if sender is frozen
304             require(!frozenAccount[_to]);                                            // Check if recipient is frozen
305         }
306         return super.transferFrom(_from, _to, _value);
307     }
308     
309     // ------------------------------------------------------------------------
310     // Get the token balance for account tokenOwner
311     // ------------------------------------------------------------------------
312     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
313         return balances[tokenOwner].safeAdd(minedBalances[tokenOwner].left);
314     }
315 }