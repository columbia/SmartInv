1 // SPDX-License-Identifier: MIT
2 
3 // Dual Staking contract for DeFi Platform. Easy access for projects to have asset to asset staking earning interest based on APY % 
4 // from token to another desired token or currency from the same chain.
5 
6 pragma solidity ^0.8.2;
7 
8 /**
9  * @title Owner
10  * @dev Set & change owner
11  */
12 contract Owner {
13 
14     address private owner;
15     
16     // event for EVM logging
17     event OwnerSet(address indexed oldOwner, address indexed newOwner);
18     
19     // modifier to check if caller is owner
20     modifier isOwner() {
21         // If the first argument of 'require' evaluates to 'false', execution terminates and all
22         // changes to the state and to Ether balances are reverted.
23         // This used to consume all gas in old EVM versions, but not anymore.
24         // It is often a good idea to use 'require' to check if functions are called correctly.
25         // As a second argument, you can also provide an explanation about what went wrong.
26         require(msg.sender == owner, "Caller is not owner");
27         _;
28     }
29     
30     /**
31      * @dev Set contract deployer as owner
32      */
33     constructor(address _owner) {
34         owner = _owner;
35         emit OwnerSet(address(0), owner);
36     }
37 
38     /**
39      * @dev Change owner
40      * @param newOwner address of new owner
41      */
42     function changeOwner(address newOwner) public isOwner {
43         emit OwnerSet(owner, newOwner);
44         owner = newOwner;
45     }
46 
47     /**
48      * @dev Return owner address 
49      * @return address of owner
50      */
51     function getOwner() public view returns (address) {
52         return owner;
53     }
54 }
55 
56 /**
57  * @dev Contract module that helps prevent reentrant calls to a function.
58  *
59  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
60  * available, which can be applied to functions to make sure there are no nested
61  * (reentrant) calls to them.
62  *
63  * Note that because there is a single `nonReentrant` guard, functions marked as
64  * `nonReentrant` may not call one another. This can be worked around by making
65  * those functions `private`, and then adding `external` `nonReentrant` entry
66  * points to them.
67  *
68  * TIP: If you would like to learn more about reentrancy and alternative ways
69  * to protect against it, check out our blog post
70  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
71  */
72 abstract contract ReentrancyGuard {
73     // Booleans are more expensive than uint256 or any type that takes up a full
74     // word because each write operation emits an extra SLOAD to first read the
75     // slot's contents, replace the bits taken up by the boolean, and then write
76     // back. This is the compiler's defense against contract upgrades and
77     // pointer aliasing, and it cannot be disabled.
78 
79     // The values being non-zero value makes deployment a bit more expensive,
80     // but in exchange the refund on every call to nonReentrant will be lower in
81     // amount. Since refunds are capped to a percentage of the total
82     // transaction's gas, it is best to keep them low in cases like this one, to
83     // increase the likelihood of the full refund coming into effect.
84     uint256 private constant _NOT_ENTERED = 1;
85     uint256 private constant _ENTERED = 2;
86 
87     uint256 private _status;
88 
89     constructor() {
90         _status = _NOT_ENTERED;
91     }
92 
93     /**
94      * @dev Prevents a contract from calling itself, directly or indirectly.
95      * Calling a `nonReentrant` function from another `nonReentrant`
96      * function is not supported. It is possible to prevent this from happening
97      * by making the `nonReentrant` function external, and making it call a
98      * `private` function that does the actual work.
99      */
100     modifier nonReentrant() {
101         // On the first call to nonReentrant, _notEntered will be true
102         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
103 
104         // Any calls to nonReentrant after this point will fail
105         _status = _ENTERED;
106 
107         _;
108 
109         // By storing the original value once again, a refund is triggered (see
110         // https://eips.ethereum.org/EIPS/eip-2200)
111         _status = _NOT_ENTERED;
112     }
113 }
114 
115 // Using consensys implementation of ERC-20, because of decimals
116 
117 // Abstract contract for the full ERC 20 Token standard
118 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
119 
120 abstract contract EIP20Interface {
121     /* This is a slight change to the EIP20 base standard.
122     function totalSupply() constant returns (uint256 supply);
123     is replaced with:
124     uint256 public totalSupply;
125     This automatically creates a getter function for the totalSupply.
126     This is moved to the base contract since public getter functions are not
127     currently recognised as an implementation of the matching abstract
128     function by the compiler.
129     */
130     /// total amount of tokens
131     uint256 public totalSupply;
132 
133     /// @param _owner The address from which the balance will be retrieved
134     /// @return balance The balance
135     function balanceOf(address _owner) virtual public view returns (uint256 balance);
136 
137     /// @notice send `_value` token to `_to` from `msg.sender`
138     /// @param _to The address of the recipient
139     /// @param _value The amount of token to be transferred
140     /// @return success Whether the transfer was successful or not
141     function transfer(address _to, uint256 _value) virtual public returns (bool success);
142 
143     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
144     /// @param _from The address of the sender
145     /// @param _to The address of the recipient
146     /// @param _value The amount of token to be transferred
147     /// @return success Whether the transfer was successful or not
148     function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);
149 
150     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
151     /// @param _spender The address of the account able to transfer the tokens
152     /// @param _value The amount of tokens to be approved for transfer
153     /// @return success Whether the approval was successful or not
154     function approve(address _spender, uint256 _value) virtual public returns (bool success);
155 
156     /// @param _owner The address of the account owning tokens
157     /// @param _spender The address of the account able to transfer the tokens
158     /// @return remaining Amount of remaining tokens allowed to spent
159     function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);
160 
161     // solhint-disable-next-line no-simple-event-func-name
162     event Transfer(address indexed _from, address indexed _to, uint256 _value);
163     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
164 }
165 
166 /*
167 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
168 */
169 
170 contract EIP20 is EIP20Interface {
171 
172     uint256 constant private MAX_UINT256 = 2**256 - 1;
173     mapping (address => uint256) public balances;
174     mapping (address => mapping (address => uint256)) public allowed;
175     /*
176     NOTE:
177     The following variables are OPTIONAL vanities. One does not have to include them.
178     They allow one to customise the token contract & in no way influences the core functionality.
179     Some wallets/interfaces might not even bother to look at this information.
180     */
181     string public name;                   //fancy name: eg Simon Bucks
182     uint8 public decimals;                //How many decimals to show.
183     string public symbol;                 //An identifier: eg SBX
184 
185     constructor(
186         uint256 _initialAmount,
187         string memory _tokenName,
188         uint8 _decimalUnits,
189         string memory _tokenSymbol
190     ) {
191         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
192         totalSupply = _initialAmount;                        // Update total supply
193         name = _tokenName;                                   // Set the name for display purposes
194         decimals = _decimalUnits;                            // Amount of decimals for display purposes
195         symbol = _tokenSymbol;                               // Set the symbol for display purposes
196     }
197 
198     function transfer(address _to, uint256 _value) override public returns (bool success) {
199         require(balances[msg.sender] >= _value);
200         balances[msg.sender] -= _value;
201         balances[_to] += _value;
202         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
203         return true;
204     }
205 
206     function transferFrom(address _from, address _to, uint256 _value) override public returns (bool success) {
207         uint256 the_allowance = allowed[_from][msg.sender];
208         require(balances[_from] >= _value && the_allowance >= _value);
209         balances[_to] += _value;
210         balances[_from] -= _value;
211         if (the_allowance < MAX_UINT256) {
212             allowed[_from][msg.sender] -= _value;
213         }
214         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
215         return true;
216     }
217 
218     function balanceOf(address _owner) override public view returns (uint256 balance) {
219         return balances[_owner];
220     }
221 
222     function approve(address _spender, uint256 _value) override public returns (bool success) {
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
225         return true;
226     }
227 
228     function allowance(address _owner, address _spender) override public view returns (uint256 remaining) {
229         return allowed[_owner][_spender];
230     }
231 }
232 
233 /**
234  * 
235  * Dual Staking is an interest gain contract for ERC-20 tokens to earn revenue staking token A and earn token B
236  * 
237  * asset is the EIP20 token to deposit in
238  * asset2 is the EIP20 token to get interest in
239  * interest_rate: percentage earning rate of token1 based on APY (annual yield)
240  * interest_rate2: percentage earning rate of token2 based on APY (annual yield)
241  * maturity is the time in seconds after which is safe to end the stake
242  * penalization is for ending a stake before maturity time of the stake taking loss quitting the commitment
243  * lower_amount is the minimum amount for creating the stake in tokens
244  * 
245  */
246 contract DualStaking is Owner, ReentrancyGuard {
247 
248     // Token to deposit
249     EIP20 public asset;
250 
251     // Token to pay interest in | (Can be the same but suggested to use Single Staking for this)
252     EIP20 public asset2;
253 
254     // stakes history
255     struct Record {
256         uint256 from;
257         uint256 amount;
258         uint256 gain;
259         uint256 gain2;
260         uint256 penalization;
261         uint256 to;
262         bool ended;
263     }
264 
265     // contract parameters
266     uint16 public interest_rate;
267     uint16 public interest_rate2;
268     uint256 public maturity;
269     uint8 public penalization;
270     uint256 public lower_amount;
271 
272     // conversion ratio for token1 and token2
273     // 1:10 ratio will be: 
274     // ratio1 = 1 
275     // ratio2 = 10
276     uint256 public ratio1;
277     uint256 public ratio2;
278 
279     mapping(address => Record[]) public ledger;
280 
281     event StakeStart(address indexed user, uint256 value, uint256 index);
282     event StakeEnd(address indexed user, uint256 value, uint256 penalty, uint256 interest, uint256 index);
283     
284     constructor(
285         EIP20 _erc20, EIP20 _erc20_2, address _owner, uint16 _rate, uint16 _rate2, uint256 _maturity, 
286         uint8 _penalization, uint256 _lower, uint256 _ratio1, uint256 _ratio2) Owner(_owner) {
287         require(_penalization<=100, "Penalty has to be an integer between 0 and 100");
288         asset = _erc20;
289         asset2 = _erc20_2;
290         ratio1 = _ratio1;
291         ratio2 = _ratio2;
292         interest_rate = _rate;
293         interest_rate2 = _rate2;
294         maturity = _maturity;
295         penalization = _penalization;
296         lower_amount = _lower;
297     }
298     
299     function start(uint256 _value) external nonReentrant {
300         require(_value >= lower_amount, "Invalid value");
301         require(asset.transferFrom(msg.sender, address(this), _value));
302         ledger[msg.sender].push(Record(block.timestamp, _value, 0, 0, 0, 0, false));
303         emit StakeStart(msg.sender, _value, ledger[msg.sender].length-1);
304     }
305 
306     function end(uint256 i) external nonReentrant {
307 
308         require(i < ledger[msg.sender].length, "Invalid index");
309         require(ledger[msg.sender][i].ended==false, "Invalid stake");
310         
311         // penalization
312         if(block.timestamp - ledger[msg.sender][i].from < maturity) {
313 
314             uint256 _penalization = ledger[msg.sender][i].amount * penalization / 100;
315             require(asset.transfer(msg.sender, ledger[msg.sender][i].amount - _penalization));
316             require(asset.transfer(getOwner(), _penalization));
317             ledger[msg.sender][i].penalization = _penalization;
318             ledger[msg.sender][i].to = block.timestamp;
319             ledger[msg.sender][i].ended = true;
320             emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, _penalization, 0, i);
321 
322         // interest gained
323         } else {
324             
325             // interest is calculated in asset2
326             uint256 _interest = get_gains(msg.sender, i);
327 
328             // check that the owner can pay interest before trying to pay, token 1
329             if (_interest>0 && asset.allowance(getOwner(), address(this)) >= _interest && asset.balanceOf(getOwner()) >= _interest) {
330                 require(asset.transferFrom(getOwner(), msg.sender, _interest));
331             } else {
332                 _interest = 0;
333             }
334 
335             // interest is calculated in asset2
336             uint256 _interest2 = get_gains2(msg.sender, i);
337 
338             // check that the owner can pay interest before trying to pay, token 1
339             if (_interest2>0 && asset2.allowance(getOwner(), address(this)) >= _interest2 && asset2.balanceOf(getOwner()) >= _interest2) {
340                 require(asset2.transferFrom(getOwner(), msg.sender, _interest2));
341             } else {
342                 _interest2 = 0;
343             }
344 
345             // the original asset is returned to the investor
346             require(asset.transfer(msg.sender, ledger[msg.sender][i].amount));
347             ledger[msg.sender][i].gain = _interest;
348             ledger[msg.sender][i].gain2 = _interest2;
349             ledger[msg.sender][i].to = block.timestamp;
350             ledger[msg.sender][i].ended = true;
351             emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, 0, _interest, i);
352 
353         }
354     }
355 
356     function set(EIP20 _erc20, EIP20 _erc20_2, uint256 _lower, uint256 _maturity, uint16 _rate, uint16 _rate2, uint8 _penalization, uint256 _ratio1, uint256 _ratio2) external isOwner {
357         require(_penalization<=100, "Invalid value");
358         asset = _erc20;
359         asset2 = _erc20_2;
360         ratio1 = _ratio1;
361         ratio2 = _ratio2;
362         lower_amount = _lower;
363         maturity = _maturity;
364         interest_rate = _rate;
365         interest_rate2 = _rate2;
366         penalization = _penalization;
367     }
368 
369     // calculate interest of the token 1 to the current date time
370     function get_gains(address _address, uint256 _rec_number) public view returns (uint256) {
371         uint256 _record_seconds = block.timestamp - ledger[_address][_rec_number].from;
372         uint256 _year_seconds = 365*24*60*60;
373         return _record_seconds * 
374             ledger[_address][_rec_number].amount * interest_rate / 100
375         / _year_seconds;
376     }
377 
378     // calculate interest to the current date time
379     function get_gains2(address _address, uint256 _rec_number) public view returns (uint256) {
380         uint256 _record_seconds = block.timestamp - ledger[_address][_rec_number].from;
381         uint256 _year_seconds = 365*24*60*60;
382         
383         /**
384          *
385          * Oririginal code:
386          * 
387          *   // now we calculate the value of the transforming the staked asset (asset) into the asset2
388          *   // first we calculate the ratio
389          *   uint256 value_in_asset2 = ledger[_address][_rec_number].amount * ratio2 / ratio1;
390          *   // now we transform into decimals of the asset2
391          *   value_in_asset2 = value_in_asset2 * 10**asset2.decimals() / 10**asset.decimals();
392          *   uint256 interest = _record_seconds * value_in_asset2 * interest_rate2 / 100 / _year_seconds;
393          *   // now lets calculate the interest rate based on the converted value in asset 2
394          *
395          * Simplified into:
396          * 
397          */
398 
399         return (_record_seconds * ledger[_address][_rec_number].amount * ratio2 * 10**asset2.decimals() * interest_rate2) / 
400                (ratio1 * 10**asset.decimals() * 100 * _year_seconds);
401 
402     }
403 
404     function ledger_length(address _address) external view 
405         returns (uint256) {
406         return ledger[_address].length;
407     }
408 
409 }