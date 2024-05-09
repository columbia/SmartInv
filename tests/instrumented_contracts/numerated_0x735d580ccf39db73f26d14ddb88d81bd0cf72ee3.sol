1 pragma solidity ^0.4.11;
2 
3 // Token Issue Smart Contract for Bitconch Coin
4 // Symbol       : BUS
5 // Name         : Bitconch Coin
6 // Total Supply : 50 Billion
7 // Decimal      : 18
8 // Compiler     : 0.4.11+commit.68ef5810.Emscripten.clang
9 // Optimazation : Yes
10 
11 
12 // @title SafeMath
13 // @dev Math operations with safety checks that throw on error
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16         uint256 c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b > 0);
23         uint256 c = a / b;
24         assert(a == b * c + a % b);
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal constant returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control functions
44  */
45 contract Ownable {
46     address public owner;
47 
48     // @dev Constructor sets the original `owner` of the contract to the sender account.
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53     // @dev Throws if called by any account other than the owner.
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59 
60     // @dev Allows the current owner to transfer control of the contract to a newOwner.
61     // @param newOwner The address to transfer ownership to.
62     function transferOwnership(address newOwner) onlyOwner {
63         if (newOwner != address(0)) {
64             owner = newOwner;
65         }
66     }
67 
68 }
69 
70 
71 /**
72  * @title Claimable
73  * @dev the ownership of contract needs to be claimed.
74  * This allows the new owner to accept the transfer.
75  */
76 contract Claimable is Ownable {
77     address public pendingOwner;
78 
79     // @dev Modifier throws if called by any account other than the pendingOwner.
80     modifier onlyPendingOwner() {
81         require(msg.sender == pendingOwner);
82         _;
83     }
84 
85     // @dev Allows the current owner to set the pendingOwner address.
86     // @param newOwner The address to transfer ownership to.
87     function transferOwnership(address newOwner) onlyOwner {
88         pendingOwner = newOwner;
89     }
90 
91     // @dev Allows the pendingOwner address to finalize the transfer.
92     function claimOwnership() onlyPendingOwner {
93         owner = pendingOwner;
94         pendingOwner = 0x0;
95     }
96 }
97 
98 
99 /**
100  * @title Contactable token
101  * @dev Allowing the owner to provide a string with their contact information.
102  */
103 contract Contactable is Ownable{
104 
105     string public contactInformation;
106 
107     // @dev Allows the owner to set a string with their contact information.
108     // @param info The contact information to attach to the contract.
109     function setContactInformation(string info) onlyOwner{
110         contactInformation = info;
111     }
112 }
113 
114 
115 /**
116  * @title Contracts that should not own Ether
117  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
118  * in the contract, it will allow the owner to reclaim this ether.
119  * @notice Ether can still be send to this contract by:
120  * calling functions labeled `payable`
121  * `selfdestruct(contract_address)`
122  * mining directly to the contract address
123 */
124 contract HasNoEther is Ownable {
125 
126     /**
127     * @dev Constructor that rejects incoming Ether
128     * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
129     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
130     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
131     * we could use assembly to access msg.value.
132     */
133     function HasNoEther() payable {
134         require(msg.value == 0);
135     }
136 
137     /**
138      * @dev Disallows direct send by settings a default function without the `payable` flag.
139      */
140     function() external {
141     }
142 
143     /**
144      * @dev Transfer all Ether held by the contract to the owner.
145      */
146     function reclaimEther() external onlyOwner {
147         assert(owner.send(this.balance));
148     }
149 }
150 
151 
152 /**
153  * @title Standard ERC20 token
154  * @dev Implementation of the ERC20Interface
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 {
158     using SafeMath for uint256;
159 
160     // private
161     mapping(address => uint256) balances;
162     mapping (address => mapping (address => uint256)) allowed;
163     uint256 _totalSupply;
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 
168     // @dev Get the total token supply
169     function totalSupply() constant returns (uint256) {
170         return _totalSupply;
171     }
172 
173     // @dev Gets the balance of the specified address.
174     // @param _owner The address to query the the balance of.
175     // @return An uint256 representing the amount owned by the passed address.
176     function balanceOf(address _owner) constant returns (uint256 balance) {
177         return balances[_owner];
178     }
179 
180     // @dev transfer token for a specified address
181     // @param _to The address to transfer to.
182     // @param _value The amount to be transferred.
183     function transfer(address _to, uint256 _value) returns (bool) {
184         require(_to != 0x0 );
185         require(_value > 0 );
186 
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189 
190         Transfer(msg.sender, _to, _value);
191         return true;
192     }
193 
194     // @dev Transfer tokens from one address to another
195     // @param _from address The address which you want to send tokens from
196     // @param _to address The address which you want to transfer to
197     // @param _value uint256 the amout of tokens to be transfered
198     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
199         require(_from != 0x0 );
200         require(_to != 0x0 );
201         require(_value > 0 );
202 
203         var _allowance = allowed[_from][msg.sender];
204 
205         balances[_to] = balances[_to].add(_value);
206         balances[_from] = balances[_from].sub(_value);
207         allowed[_from][msg.sender] = _allowance.sub(_value);
208 
209         Transfer(_from, _to, _value);
210         return true;
211     }
212 
213     // @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
214     // @param _spender The address which will spend the funds.
215     // @param _value The amount of tokens to be spent.
216     function approve(address _spender, uint256 _value) returns (bool) {
217         require(_spender != 0x0 );
218         // To change the approve amount you first have to reduce the addresses`
219         // allowance to zero by calling `approve(_spender, 0)` if it is not
220         // already 0 to mitigate the race condition described here:
221         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223 
224         allowed[msg.sender][_spender] = _value;
225 
226         Approval(msg.sender, _spender, _value);
227         return true;
228     }
229 
230     // @dev Function to check the amount of tokens that an owner allowed to a spender.
231     // @param _owner address The address which owns the funds.
232     // @param _spender address The address which will spend the funds.
233     // @return A uint256 specifing the amount of tokens still avaible for the spender.
234     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
235         return allowed[_owner][_spender];
236     }
237 }
238 
239 contract StandardToken is ERC20 {
240     string public name;
241     string public symbol;
242     uint256 public decimals;
243 
244     function isToken() public constant returns (bool) {
245         return true;
246     }
247 }
248 
249 /**
250  * @dev FreezableToken
251  *
252  */
253 contract FreezableToken is StandardToken, Ownable {
254     mapping (address => bool) public frozenAccounts;
255     event FrozenFunds(address target, bool frozen);
256 
257     // @dev freeze account or unfreezen.
258     function freezeAccount(address target, bool freeze) onlyOwner {
259         frozenAccounts[target] = freeze;
260         FrozenFunds(target, freeze);
261     }
262 
263     // @dev Limit token transfer if _sender is frozen.
264     modifier canTransfer(address _sender) {
265         require(!frozenAccounts[_sender]);
266 
267         _;
268     }
269 
270     function transfer(address _to, uint256 _value) canTransfer(msg.sender) returns (bool success) {
271         // Call StandardToken.transfer()
272         return super.transfer(_to, _value);
273     }
274 
275     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) returns (bool success) {
276         // Call StandardToken.transferForm()
277         return super.transferFrom(_from, _to, _value);
278     }
279 }
280 
281 /**
282  * @title BusToken
283  * @dev The BusToken contract is Claimable, and provides ERC20 standard token.
284  */
285 contract BusToken is Claimable, Contactable, HasNoEther, FreezableToken {
286     // @dev Constructor initial token info
287     function BusToken(){
288         uint256 _decimals = 18;
289         uint256 _supply = 50000000000*(10**_decimals);
290 
291         _totalSupply = _supply;
292         balances[msg.sender] = _supply;
293         name = "Bitconch Coin";
294         symbol = "BUS";
295         decimals = _decimals;
296         contactInformation = "Bitconch Contact Email:info@bitconch.io";
297     }
298 }
299 
300 
301 contract BusTokenLock is Ownable, HasNoEther {
302     using SafeMath for uint256;
303 
304     // @dev How many investors we have now
305     uint256 public investorCount;
306     // @dev How many tokens investors have claimed so far
307     uint256 public totalClaimed;
308     // @dev How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded
309     uint256 public tokensAllocatedTotal;
310 
311     // must hold as much as tokens
312     uint256 public tokensAtLeastHold;
313 
314     struct balance{
315         address investor;
316         uint256 amount;
317         uint256 freezeEndAt;
318         bool claimed;
319     }
320 
321     mapping(address => balance[]) public balances;
322     // @dev How many tokens investors have claimed
323     mapping(address => uint256) public claimed;
324 
325     // @dev token
326     FreezableToken public token;
327 
328     // @dev We allocated tokens for investor
329     event Invested(address investor, uint256 amount, uint256 hour);
330 
331     // @dev We distributed tokens to an investor
332     event Distributed(address investors, uint256 count);
333 
334     /**
335      * @dev Create contract where lock up period is given days
336      *
337      * @param _owner Who can load investor data and lock
338      * @param _token Token contract address we are distributing
339      *
340      */
341     function BusTokenLock(address _owner, address _token) {
342         require(_owner != 0x0);
343         require(_token != 0x0);
344 
345         owner = _owner;
346         token = FreezableToken(_token);
347     }
348 
349     // @dev Add investor
350     function addInvestor(address investor, uint256 _amount, uint256 hour) public onlyOwner {
351         require(investor != 0x0);
352         require(_amount > 0); // No empty buys
353 
354         uint256 amount = _amount *(10**token.decimals());
355         if(balances[investor].length == 0) {
356             investorCount++;
357         }
358 
359         balances[investor].push(balance(investor, amount, now + hour*60*60, false));
360         tokensAllocatedTotal += amount;
361         tokensAtLeastHold += amount;
362         // Do not lock if the given tokens are not on this contract
363         require(token.balanceOf(address(this)) >= tokensAtLeastHold);
364 
365         Invested(investor, amount, hour);
366     }
367 
368     // @dev can only withdraw rest of investor's tokens
369     function withdrawLeftTokens() onlyOwner {
370         token.transfer(owner, token.balanceOf(address(this))-tokensAtLeastHold);
371     }
372 
373     // @dev Get the current balance of tokens
374     // @return uint256 How many tokens there are currently
375     function getBalance() public constant returns (uint256) {
376         return token.balanceOf(address(this));
377     }
378 
379     // @dev Claim N bought tokens to the investor as the msg sender
380     function claim() {
381         withdraw(msg.sender);
382     }
383 
384     function withdraw(address investor) internal {
385         require(balances[investor].length > 0);
386 
387         uint256 nowTS = now;
388         uint256 withdrawTotal;
389         for (uint i = 0; i < balances[investor].length; i++){
390             if(balances[investor][i].claimed){
391                 continue;
392             }
393             if(nowTS<balances[investor][i].freezeEndAt){
394                 continue;
395             }
396 
397             balances[investor][i].claimed=true;
398             withdrawTotal += balances[investor][i].amount;
399         }
400 
401         claimed[investor] += withdrawTotal;
402         totalClaimed += withdrawTotal;
403         token.transfer(investor, withdrawTotal);
404         tokensAtLeastHold -= withdrawTotal;
405         require(token.balanceOf(address(this)) >= tokensAtLeastHold);
406 
407         Distributed(investor, withdrawTotal);
408     }
409 }