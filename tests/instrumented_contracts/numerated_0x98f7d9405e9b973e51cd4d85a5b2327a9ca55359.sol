1 pragma solidity ^0.4.17;
2 
3 //Slightly modified SafeMath library - includes a min function
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function min(uint a, uint b) internal pure returns (uint256) {
30     return a < b ? a : b;
31   }
32 }
33 
34 //ERC20 function interface
35 interface ERC20_Interface {
36   function totalSupply() public constant returns (uint total_supply);
37   function balanceOf(address _owner) public constant returns (uint balance);
38   function transfer(address _to, uint _amount) public returns (bool success);
39   function transferFrom(address _from, address _to, uint _amount) public returns (bool success);
40   function approve(address _spender, uint _amount) public returns (bool success);
41   function allowance(address _owner, address _spender) public constant returns (uint amount);
42 }
43 
44 //Swap factory functions - descriptions can be found in Factory.sol
45 interface Factory_Interface {
46   function createToken(uint _supply, address _party, bool _long, uint _start_date) public returns (address created, uint token_ratio);
47   function payToken(address _party, address _token_add) public;
48   function deployContract(uint _start_date) public payable returns (address created);
49    function getBase() public view returns(address _base1, address base2);
50   function getVariables() public view returns (address oracle_addr, uint swap_duration, uint swap_multiplier, address token_a_addr, address token_b_addr);
51 }
52 
53 
54 //DRCT_Token functions - descriptions can be found in DRCT_Token.sol
55 interface DRCT_Token_Interface {
56   function addressCount(address _swap) public constant returns (uint count);
57   function getHolderByIndex(uint _ind, address _swap) public constant returns (address holder);
58   function getBalanceByIndex(uint _ind, address _swap) public constant returns (uint bal);
59   function getIndexByAddress(address _owner, address _swap) public constant returns (uint index);
60   function createToken(uint _supply, address _owner, address _swap) public;
61   function pay(address _party, address _swap) public;
62   function partyCount(address _swap) public constant returns(uint count);
63 }
64 
65 
66 //Swap Oracle functions - descriptions can be found in Oracle.sol
67 interface Oracle_Interface{
68   function RetrieveData(uint _date) public view returns (uint data);
69 }
70 
71 
72 //This contract is the specific DRCT base contract that holds the funds of the contract and redistributes them based upon the change in the underlying values
73 contract TokenToTokenSwap {
74 
75   using SafeMath for uint256;
76 
77   /*Enums*/
78   //Describes various states of the Swap
79   enum SwapState {
80     created,
81     open,
82     started,
83     tokenized,
84     ready,
85     ended
86   }
87 
88   /*Variables*/
89 
90   //Address of the person who created this contract through the Factory
91   address creator;
92   //The Oracle address (check for list at www.github.com/DecentralizedDerivatives/Oracles)
93   address oracle_address;
94   Oracle_Interface oracle;
95 
96   //Address of the Factory that created this contract
97   address public factory_address;
98   Factory_Interface factory;
99 
100   //Addresses of parties going short and long the rate
101   address public long_party;
102   address public short_party;
103 
104   //Enum state of the swap
105   SwapState public current_state;
106 
107   //Start and end dates of the swaps - format is the same as block.timestamp
108   uint start_date;
109   uint end_date;
110 
111   //This is the amount that the change will be calculated on.  10% change in rate on 100 Ether notional is a 10 Ether change
112   uint multiplier;
113 
114   //This is the calculated share for the long and short side of the swap (200,000 is a fully capped move)
115   uint share_long;
116   uint share_short;
117 
118   // pay_to_x refers to the amount of the base token (a or b) to pay to the long or short side based upon the share_long and share_short
119   uint pay_to_short_a;
120   uint pay_to_long_a;
121   uint pay_to_long_b;
122   uint pay_to_short_b;
123 
124   //Address of created long and short DRCT tokens
125   address long_token_address;
126   address short_token_address;
127 
128   //Number of DRCT Tokens distributed to both parties
129   uint num_DRCT_longtokens;
130   uint num_DRCT_shorttokens;
131 
132   //Addresses of ERC20 tokens used to enter the swap
133   address token_a_address;
134   address token_b_address;
135 
136   //Tokens A and B used for the notional
137   ERC20_Interface token_a;
138   ERC20_Interface token_b;
139 
140   //The notional that the payment is calculated on from the change in the reference rate
141   uint public token_a_amount;
142   uint public token_b_amount;
143 
144   uint public premium;
145 
146   //Addresses of the two parties taking part in the swap
147   address token_a_party;
148   address token_b_party;
149 
150   //Duration of the swap,pulled from the Factory contract
151   uint duration;
152   //Date by which the contract must be funded
153   uint enterDate;
154   DRCT_Token_Interface token;
155   address userContract;
156 
157   /*Events*/
158 
159   //Emitted when a Swap is created
160   event SwapCreation(address _token_a, address _token_b, uint _start_date, uint _end_date, address _creating_party);
161   //Emitted when the swap has been paid out
162   event PaidOut(address _long_token, address _short_token);
163 
164   /*Modifiers*/
165 
166   //Will proceed only if the contract is in the expected state
167   modifier onlyState(SwapState expected_state) {
168     require(expected_state == current_state);
169     _;
170   }
171 
172   /*Functions*/
173 
174   /*
175   * Constructor - Run by the factory at contract creation
176   *
177   * @param "_factory_address": Address of the factory that created this contract
178   * @param "_creator": Address of the person who created the contract
179   * @param "_userContract": Address of the _userContract that is authorized to interact with this contract
180   */
181   function TokenToTokenSwap (address _factory_address, address _creator, address _userContract, uint _start_date) public {
182     current_state = SwapState.created;
183     creator =_creator;
184     factory_address = _factory_address;
185     userContract = _userContract;
186     start_date = _start_date;
187   }
188 
189 
190   //A getter function for retriving standardized variables from the factory contract
191   function showPrivateVars() public view returns (address _userContract, uint num_DRCT_long, uint numb_DRCT_short, uint swap_share_long, uint swap_share_short, address long_token_addr, address short_token_addr, address oracle_addr, address token_a_addr, address token_b_addr, uint swap_multiplier, uint swap_duration, uint swap_start_date, uint swap_end_date){
192     return (userContract, num_DRCT_longtokens, num_DRCT_shorttokens,share_long,share_short,long_token_address,short_token_address, oracle_address, token_a_address, token_b_address, multiplier, duration, start_date, end_date);
193   }
194 
195   /*
196   * Allows the sender to create the terms for the swap
197   * @param "_amount_a": Amount of Token A that should be deposited for the notional
198   * @param "_amount_b": Amount of Token B that should be deposited for the notional
199   * @param "_sender_is_long": Denotes whether the sender is set as the short or long party
200   * @param "_senderAdd": States the owner of this side of the contract (does not have to be msg.sender)
201   */
202   function CreateSwap(
203     uint _amount_a,
204     uint _amount_b,
205     bool _sender_is_long,
206     address _senderAdd
207     ) payable public onlyState(SwapState.created) {
208 
209     require(
210       msg.sender == creator || (msg.sender == userContract && _senderAdd == creator)
211     );
212     factory = Factory_Interface(factory_address);
213     setVars();
214     end_date = start_date.add(duration.mul(86400));
215     token_a_amount = _amount_a;
216     token_b_amount = _amount_b;
217 
218     premium = this.balance;
219     token_a = ERC20_Interface(token_a_address);
220     token_a_party = _senderAdd;
221     if (_sender_is_long)
222       long_party = _senderAdd;
223     else
224       short_party = _senderAdd;
225     current_state = SwapState.open;
226   }
227 
228   function setVars() internal{
229       (oracle_address,duration,multiplier,token_a_address,token_b_address) = factory.getVariables();
230   }
231 
232   /*
233   * This function is for those entering the swap. The details of the swap are re-entered and checked
234   * to ensure the entering party is entering the correct swap. Note that the tokens you are entering with
235   * do not need to be entered as a variable, but you should ensure that the contract is funded.
236   *
237   * @param: all parameters have the same functions as those in the CreateSwap function
238   */
239   function EnterSwap(
240     uint _amount_a,
241     uint _amount_b,
242     bool _sender_is_long,
243     address _senderAdd
244     ) public onlyState(SwapState.open) {
245 
246     //Require that all of the information of the swap was entered correctly by the entering party.  Prevents partyA from exiting and changing details
247     require(
248       token_a_amount == _amount_a &&
249       token_b_amount == _amount_b &&
250       token_a_party != _senderAdd
251     );
252 
253     token_b = ERC20_Interface(token_b_address);
254     token_b_party = _senderAdd;
255 
256     //Set the entering party as the short or long party
257     if (_sender_is_long) {
258       require(long_party == 0);
259       long_party = _senderAdd;
260     } else {
261       require(short_party == 0);
262       short_party = _senderAdd;
263     }
264 
265     SwapCreation(token_a_address, token_b_address, start_date, end_date, token_b_party);
266     enterDate = now;
267     current_state = SwapState.started;
268   }
269 
270   /*
271   * This function creates the DRCT tokens for the short and long parties, and ensures the short and long parties
272   * have funded the contract with the correct amount of the ERC20 tokens A and B
273   *
274   */
275   function createTokens() public onlyState(SwapState.started){
276 
277     //Ensure the contract has been funded by tokens a and b within 1 day
278     require(
279       now < (enterDate + 86400) &&
280       token_a.balanceOf(address(this)) >= token_a_amount &&
281       token_b.balanceOf(address(this)) >= token_b_amount
282     );
283 
284     uint tokenratio = 1;
285     (long_token_address,tokenratio) = factory.createToken(token_a_amount, long_party,true,start_date);
286     num_DRCT_longtokens = token_a_amount.div(tokenratio);
287     (short_token_address,tokenratio) = factory.createToken(token_b_amount, short_party,false,start_date);
288     num_DRCT_shorttokens = token_b_amount.div(tokenratio);
289     current_state = SwapState.tokenized;
290     if (premium > 0){
291       if (creator == long_party){
292       short_party.transfer(premium);
293       }
294       else {
295         long_party.transfer(premium);
296       }
297     }
298   }
299 
300   /*
301   * This function calculates the payout of the swap. It can be called after the Swap has been tokenized.
302   * The value of the underlying cannot reach zero, but rather can only get within 0.001 * the precision
303   * of the Oracle.
304   */
305   function Calculate() internal {
306     require(now >= end_date + 86400);
307     //Comment out above for testing purposes
308     oracle = Oracle_Interface(oracle_address);
309     uint start_value = oracle.RetrieveData(start_date);
310     uint end_value = oracle.RetrieveData(end_date);
311 
312     uint ratio;
313     if (start_value > 0 && end_value > 0)
314       ratio = (end_value).mul(100000).div(start_value);
315     else if (end_value > 0)
316       ratio = 10e10;
317     else if (start_value > 0)
318       ratio = 0;
319     else
320       ratio = 100000;
321     if (ratio == 100000) {
322       share_long = share_short = ratio;
323     } else if (ratio > 100000) {
324       share_long = ((ratio).sub(100000)).mul(multiplier).add(100000);
325       if (share_long >= 200000)
326         share_short = 0;
327       else
328         share_short = 200000-share_long;
329     } else {
330       share_short = SafeMath.sub(100000,ratio).mul(multiplier).add(100000);
331        if (share_short >= 200000)
332         share_long = 0;
333       else
334         share_long = 200000- share_short;
335     }
336 
337     //Calculate the payouts to long and short parties based on the short and long shares
338     calculatePayout();
339 
340     current_state = SwapState.ready;
341   }
342 
343   /*
344   * Calculates the amount paid to the short and long parties per token
345   */
346   function calculatePayout() internal {
347     uint ratio;
348     token_a_amount = token_a_amount.mul(995).div(1000);
349     token_b_amount = token_b_amount.mul(995).div(1000);
350     //If ratio is flat just swap tokens, otherwise pay the winner the entire other token and only pay the other side a portion of the opposite token
351     if (share_long == 100000) {
352       pay_to_short_a = (token_a_amount).div(num_DRCT_longtokens);
353       pay_to_long_b = (token_b_amount).div(num_DRCT_shorttokens);
354       pay_to_short_b = 0;
355       pay_to_long_a = 0;
356     } else if (share_long > 100000) {
357       ratio = SafeMath.min(100000, (share_long).sub(100000));
358       pay_to_long_b = (token_b_amount).div(num_DRCT_shorttokens);
359       pay_to_short_a = (SafeMath.sub(100000,ratio)).mul(token_a_amount).div(num_DRCT_longtokens).div(100000);
360       pay_to_long_a = ratio.mul(token_a_amount).div(num_DRCT_longtokens).div(100000);
361       pay_to_short_b = 0;
362     } else {
363       ratio = SafeMath.min(100000, (share_short).sub(100000));
364       pay_to_short_a = (token_a_amount).div(num_DRCT_longtokens);
365       pay_to_long_b = (SafeMath.sub(100000,ratio)).mul(token_b_amount).div(num_DRCT_shorttokens).div(100000);
366       pay_to_short_b = ratio.mul(token_b_amount).div(num_DRCT_shorttokens).div(100000);
367       pay_to_long_a = 0;
368     }
369   }
370 
371   /*
372   * This function can be called after the swap is tokenized or after the Calculate function is called.
373   * If the Calculate function has not yet been called, this function will call it.
374   * The function then pays every token holder of both the long and short DRCT tokens
375   */
376   function forcePay(uint _begin, uint _end) public returns (bool) {
377     //Calls the Calculate function first to calculate short and long shares
378     if(current_state == SwapState.tokenized /*&& now > end_date + 86400*/){
379       Calculate();
380     }
381 
382     //The state at this point should always be SwapState.ready
383     require(current_state == SwapState.ready);
384 
385     //Loop through the owners of long and short DRCT tokens and pay them
386 
387     token = DRCT_Token_Interface(long_token_address);
388     uint count = token.addressCount(address(this));
389     uint loop_count = count < _end ? count : _end;
390     //Indexing begins at 1 for DRCT_Token balances
391     for(uint i = loop_count-1; i >= _begin ; i--) {
392       address long_owner = token.getHolderByIndex(i, address(this));
393       uint to_pay_long = token.getBalanceByIndex(i, address(this));
394       paySwap(long_owner, to_pay_long, true);
395     }
396 
397     token = DRCT_Token_Interface(short_token_address);
398     count = token.addressCount(address(this));
399     loop_count = count < _end ? count : _end;
400     for(uint j = loop_count-1; j >= _begin ; j--) {
401       address short_owner = token.getHolderByIndex(j, address(this));
402       uint to_pay_short = token.getBalanceByIndex(j, address(this));
403       paySwap(short_owner, to_pay_short, false);
404     }
405 
406     if (loop_count == count){
407         token_a.transfer(factory_address, token_a.balanceOf(address(this)));
408         token_b.transfer(factory_address, token_b.balanceOf(address(this)));
409         PaidOut(long_token_address, short_token_address);
410         current_state = SwapState.ended;
411       }
412     return true;
413   }
414 
415   /*
416   * This function pays the receiver an amount determined by the Calculate function
417   *
418   * @param "_receiver": The recipient of the payout
419   * @param "_amount": The amount of token the recipient holds
420   * @param "_is_long": Whether or not the reciever holds a long or short token
421   */
422   function paySwap(address _receiver, uint _amount, bool _is_long) internal {
423     if (_is_long) {
424       if (pay_to_long_a > 0)
425         token_a.transfer(_receiver, _amount.mul(pay_to_long_a));
426       if (pay_to_long_b > 0){
427         token_b.transfer(_receiver, _amount.mul(pay_to_long_b));
428       }
429         factory.payToken(_receiver,long_token_address);
430     } else {
431 
432       if (pay_to_short_a > 0)
433         token_a.transfer(_receiver, _amount.mul(pay_to_short_a));
434       if (pay_to_short_b > 0){
435         token_b.transfer(_receiver, _amount.mul(pay_to_short_b));
436       }
437        factory.payToken(_receiver,short_token_address);
438     }
439   }
440 
441 
442   /*
443   * This function allows both parties to exit. If only the creator has entered the swap, then the swap can be cancelled and the details modified
444   * Once two parties enter the swap, the contract is null after cancelled. Once tokenized however, the contract cannot be ended.
445   */
446   function Exit() public {
447    if (current_state == SwapState.open && msg.sender == token_a_party) {
448       token_a.transfer(token_a_party, token_a_amount);
449       if (premium>0){
450         msg.sender.transfer(premium);
451       }
452       delete token_a_amount;
453       delete token_b_amount;
454       delete premium;
455       current_state = SwapState.created;
456     } else if (current_state == SwapState.started && (msg.sender == token_a_party || msg.sender == token_b_party)) {
457       if (msg.sender == token_a_party || msg.sender == token_b_party) {
458         token_b.transfer(token_b_party, token_b.balanceOf(address(this)));
459         token_a.transfer(token_a_party, token_a.balanceOf(address(this)));
460         current_state = SwapState.ended;
461         if (premium > 0) { creator.transfer(premium);}
462       }
463     }
464   }
465 }
466 
467 
468 //Swap Deployer Contract-- purpose is to save gas for deployment of Factory contract
469 contract Deployer {
470   address owner;
471   address factory;
472 
473   function Deployer(address _factory) public {
474     factory = _factory;
475     owner = msg.sender;
476   }
477 
478   function newContract(address _party, address user_contract, uint _start_date) public returns (address created) {
479     require(msg.sender == factory);
480     address new_contract = new TokenToTokenSwap(factory, _party, user_contract, _start_date);
481     return new_contract;
482   }
483 
484    function setVars(address _factory, address _owner) public {
485     require (msg.sender == owner);
486     factory = _factory;
487     owner = _owner;
488   }
489 }