1 pragma solidity ^0.5.0;
2 
3 
4 // Safe math
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22     
23      //not a SafeMath function
24     function max(uint a, uint b) private pure returns (uint) {
25         return a > b ? a : b;
26     }
27     
28 }
29 
30 
31 // ERC Token Standard #20 Interface
32 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
33 contract ERC20Interface {
34     function totalSupply() public view returns (uint);
35     function balanceOf(address tokenOwner) public view returns (uint balance);
36     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 
46 // Owned contract
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 /// @title  Version 0.1 of the InchWorm Contract, which allows INCH tokens to be traded for Dai and Ether at an adjustable peg. 
74 /// @author Fakuterin
75 /// @notice In order to use, permission must be given to the Dai token contract and the InchWorm token contract.
76 ///         Call the "allow" function on each, passing this address and the number of tokens to allow as parameters.
77 ///         Use the 4 withdrawel and deposit functions in your this contract to buy and sell INCH for Ether and Dai
78 ///         Because there is no UI for this contract, KEEP IN MIND THAT ALL VALUES ARE IN MINIMUM DENOMINATIONS
79 ///         IN OTHER WORDS ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AND INPUT AS 10^-18 * THE BASE UNIT OF CURRENCY
80 ///         Other warnings: This is a test contract. Do not risk any significant value. You are not guaranteed a 
81 ///         refund, even if it's my fault. Do not send any tokens or assets directly to the contract. 
82 ///         DO NOT SEND ANY TOKENS OR ASSETS DIRECTLY TO THE CONTRACT. Use only the withdrawel and deposit functions
83 /// @dev    Addresses and 'deployership' should be initialized before use. INCH must be deposited in contract
84 ///         Ownership should be set to 0x0 after initialization
85 contract InchWormVaultLiveTest is Owned {
86     using SafeMath for uint;
87 
88 
89     event SellInchForWei(uint inch, uint _wei);
90     event SellInchForDai(uint inch, uint dai);
91     event BuyInchWithWei(uint inch, uint _wei);
92     event BuyInchWithDai(uint inch, uint dai);
93     event PremiumIncreased(uint inchSold, uint premiumIncrease);
94 
95     // The premium controls both the INCH/Dai price and the INCH/ETH price. It increases as fees are paid. If 1 dai 
96     // worth of fees are paid  and there are 10 circulating tokens, the premium will increase by 100,000,
97     // or 10% of the base premium. The premium may decrease as the peg changes over time
98     uint public premium = 1000000; 
99     
100     // Used for internal calculations. Represents the initial value of premium
101     uint internal constant premiumDigits = 1000000;
102     
103     // The etherPeg controls the Dai/ETH price. There is no way to exchange Dai and ETH directly, so the peg actually changes the rate of 
104     // INCH/Dai and INCH/ETH simultaneously. The peg can be increased or decreased by increments of 2%, given certain global conditions
105     uint public etherPeg = 300;
106     
107     // Used for internal mathematics, represents fee rate. Fees = (10,000 - conserveRate)/100
108     uint internal constant conserveRate = 9700; //out of 10,000
109     uint internal constant conserveRateDigits = 10000;
110     
111     // Defines the minimum time to wait in between Dai/Ether peg adjustments
112     uint public pegMoveCooldown = 12 hours; 
113     // Represents the next unix time that a call can be made to the increase and decrease peg functions
114     uint public pegMoveReadyTime;
115     
116     ERC20Interface inchWormContract; // must be initialized to the ERC20 InchWorm Contract
117     ERC20Interface daiContract; // must be initialized to the ERC20 Dai Contract (check on compatitbility with MCD)
118     
119     // Retains ability to transfer mistaken ERC20s after ownership is revoked. Recieves portion of fees. In future versions
120     // these fees will be distributed to holders of the "Ownership Token", and not to the deployer.
121     address payable deployer; 
122     
123     
124     // Formula: premium += (FeeAmountInDai *1000000) / CirculatingSupplyAfterTransaction
125     
126     /// @param  _inchFeesPaid: the amount of INCH sent to this contract, which adjusts the premium using the same logic as used in withdrawal 
127     ///         methods below.
128     /// @notice This method allows other contracts to buy into the InchWorm System. They can pay INCH in order to adjust the 
129     ///         premium, allowing them to create vaults which can hold ERC20 assets instead of Ether.
130     function increasePremium(uint _inchFeesPaid) external {
131         //need to get permissions for this. AddOnVault needs to approve vault address for payments
132         inchWormContract.transferFrom(msg.sender, address(this), _inchFeesPaid);
133         
134         uint _premiumIncrease = _inchFeesPaid.mul(premium).div((inchWormContract.totalSupply().sub(inchWormContract.balanceOf(address(this)))));
135         premium = premium.add(_premiumIncrease);
136     }
137     
138     
139     
140     
141     
142     /*____________________________________________________________________________________*/
143     /*______________________________Inititialization Functions____________________________*/
144     
145     /// @param  _inchwormAddress: deployment address of the InchWorm contract
146     /// @param  _daiAddress: deployment address of the ERC20 Dai token contract
147     /// @param  _deployer: address of initial deployer. Receives fees and can transfer unrelated ERC20s
148     /// @notice Sets the address for the INCH and Dai tokens, as well as the deployer
149     ///         Sets the pegMoveReadyTime to now, allowing the peg to be moved immediately (if balances are correct)
150     function initialize(address _inchwormAddress, address _daiAddress, address payable _deployer) external onlyOwner {
151         inchWormContract = ERC20Interface(_inchwormAddress);
152         daiContract = ERC20Interface(_daiAddress);
153         deployer = _deployer;
154         pegMoveReadyTime = now;
155     }
156     
157 
158     /*^__^__^__^__^__^__^__^__^__^__Inititialization Functions__^__^__^__^__^__^__^__^__^ */
159     /*____________________________________________________________________________________*/
160     
161     
162     
163     
164     
165     
166     /*____________________________________________________________________________________*/
167     /*_________________________________Peg Functions______________________________________*/
168     
169     /// @notice A public call to increase the peg by 4%. Can only be called once every 12 hours, and only if
170     ///         there is there is <= 2% as much Ether value in the contract as there is Dai value.
171     ///         Example: with a peg of 100, and 10000 total Dai in the vault, the ether balance of the
172     ///         vault must be less than or equal to 2 to execute this function.
173     function increasePeg() external {
174         // check that the total value of eth in contract is <= 2% the total value of dai in the contract
175         require (address(this).balance.mul(etherPeg) <= daiContract.balanceOf(address(this)).div(50)); 
176         // check that peg hasn't been changed in last 12 hours
177         require (now > pegMoveReadyTime);
178         // increase peg
179         etherPeg = etherPeg.mul(104).div(100);
180         // reset cooldown
181         pegMoveReadyTime = now+pegMoveCooldown;
182     }
183     
184     /// @notice A public call to decrease the peg by 4%. Can only be called once every 12 hours, and only if
185     ///         there is there is < 2% as much Dai value in the contract as there is Ether value.
186     ///         Example: with a peg of 100, and 100 total Ether in the vault, the dai balance of the
187     ///         vault must be less than or equal to 200 to execute this function. 
188     function decreasePeg() external {
189          // check that the total value of eth in contract is <= 2% the total value of dai in the contract
190         require (daiContract.balanceOf(address(this)) <= address(this).balance.mul(etherPeg).div(50));
191         // check that peg hasn't been changed in last 12 hours
192         require (now > pegMoveReadyTime);
193         // increase peg
194         etherPeg = etherPeg.mul(96).div(100);
195         // reset cooldown
196         pegMoveReadyTime = now+pegMoveCooldown;
197         
198         premium = premium.mul(96).div(100);
199     }
200     
201     /* ^__^__^__^__^__^__^__^__^__^__^__^__Peg Functions__^__^__^__^__^__^__^__^__^__^__^ */
202     /*____________________________________________________________________________________*/
203     
204     
205     
206     
207     /*____________________________________________________________________________________*/
208     /*__________________________Deposit and Withdrawel Functions_________________________ */
209     // All functions begin with __ in order to help with organization. Will be changed after UI is developed
210 
211     /// @notice All units are minimum denomination, ie base unit *10**-18
212     ///         Use this payable function to buy INCH from the contract with Wei. Rates are based on premium
213     ///         and etherPeg. For every Wei deposited, msg.sender recieves etherPeg/(0.000001*premium) INCH.
214     ///         Example: If the peg is 100, and the premium is 2000000, msg.sender will recieve 50 INCH.
215     /// @dev    Transaction reverts if payment results in 0 INCH returned
216     function __buyInchWithWei() external payable {
217         // Calculate the amount of inch give to msg.sender
218         uint _inchToBuy = msg.value.mul(etherPeg).mul(premiumDigits).div(premium);
219         // Require that INCH returned is not 0
220         require(_inchToBuy > 0);
221         // Transfer INCH to Purchaser
222         inchWormContract.transfer(msg.sender, _inchToBuy);
223         
224         emit BuyInchWithWei(_inchToBuy, msg.value);
225     }
226     
227     /// @param  _inchToBuy: amount of INCH (in mininum denomination) msg.sender wishes to purchase
228     /// @notice All units are in minimum denomination, ie base unit *10**-18
229     ///         Use this payable to buy INCH from the contract using Dai. Rates are based on premium.
230     ///         For every Dai deposited, msg.sender recieves 1/(0.000001*premium) INCH.
231     ///         Example: If the premium is 5000000, calling the function with input 1 will result in 
232     ///         msg.sender paying 5 DaiSats. 
233     function __buyInchWithDai(uint _inchToBuy) external {
234         // Calculate the amount of Dai to extract from the purchaser's wallet based on the premium
235         uint _daiOwed = _inchToBuy.mul(premium).div(premiumDigits);
236         // Take Dai from the purchaser and transfer to vault contract
237         daiContract.transferFrom(msg.sender, address(this), _daiOwed);
238         // Send INCH to purchaser
239         inchWormContract.transfer(msg.sender, _inchToBuy);
240         
241         emit BuyInchWithDai(_inchToBuy, _daiOwed);
242     }
243     
244     
245     /// @param  _inchToSell: amount of INCH (in mininum denomination) msg.sender wishes to sell to the vault contract
246     /// @notice All units are in minimum denomination, ie base unit *10**-18
247     ///         Use this payable to sell INCH to the contract and withdraw Wei. Rates are based on premium and etherPeg.
248     ///         Fees are paid automatically and increase the premium for remaining tokens. Fee is currently 3%
249     ///         For every Inch sold, msg.sender recieves (0.97 * 0.000001*premium) / (etherPeg)   Ether.
250     ///         Example: If the peg is 100, and the premium is 2000000, each unit of INCHSat sold will return 0.0194 Wei. 
251     ///         Because fractions of a Wei are not possible, no value will be returned for miniscule sales of INCH
252     ///         With a peg of 100, values of less than 104 will return 0
253     /// @dev    Future versions may add a require (_etherToReturn >0). This should be an edge case. However, rounding 
254     ///         will still result in negligible losses for user. This could be fixed by rounding user input down to the nearest
255     ///         viable withdrawal amount. 
256     ///         Premium increases are functionally the same as distributing fees to all remaining INCH tokens
257     function __sellInchForEth(uint _inchToSell) external {
258         // Deduct fee (currenly 3%)
259         uint _trueInchToSell = _inchToSell.mul(conserveRate).div(conserveRateDigits);
260         // Calculate Ether to send to user based on premium and peg
261         uint _etherToReturn = _trueInchToSell.mul(premium).div(premiumDigits.mul(etherPeg));
262        
263         // Send Ether to user
264         msg.sender.transfer(_etherToReturn);
265         // Deposit INCH from user into vault
266         inchWormContract.transferFrom(msg.sender, address(this), _inchToSell);
267         // Transfer 1% to deployer. In the future, this will go to holders of the "ownership Token"
268         uint _deployerPayment = _inchToSell.mul(100).div(10000).mul(premium).div(premiumDigits.mul(etherPeg));
269         deployer.transfer(_deployerPayment);
270         
271         // Increase the premium. Premium increases are based on fees. It is functionally equivalent to distributing the fee to 
272         // remaining INCH tokens in the form of a redeemable dividend. Example: Given 1 Ether worth of fees paid and a peg of 100.
273         // Convert to dai value, so fees = 100 Dai. If 1000 tokens remain after the transaction, the premium must increase by an amount
274         // such that each INCH is worth 0.1 more Dai. If the premium was previously 1500000, then the new premium should be 1600000.
275         // Formula: premium += (FeeAmountInDai *1000000) / CirculatingSupplyAfterTransaction
276         uint _premiumIncrease = _inchToSell.sub(_trueInchToSell).mul(premium).div(inchWormContract.totalSupply().sub(inchWormContract.balanceOf(address(this))));
277         premium = premium.add(_premiumIncrease);
278         
279         emit PremiumIncreased(_inchToSell, _premiumIncrease);
280         emit SellInchForWei(_inchToSell, _etherToReturn);
281     }
282     
283     
284     
285     /// @param  _inchToSell: amount of INCH (in mininum denomination) msg.sender wishes to sell to the vault contract
286     /// @notice All units are in minimum denomination, ie base unit *10**-18
287     ///         Use this payable to sell INCH to the contract and withdraw Dai. Rates are based on premium.
288     ///         Fees are paid automatically and increase the premium for remaining tokens. Fee is currently 3%
289     ///         For every Inch sold, msg.sender recieves (0.97 * 0.000001*premium) Dai.
290     ///         Example: If the premium is 5000000, each unit of INCHSat sold will return 4.85 DaiSat. 
291     ///         Because fee functions round down, this does not work for low values of INCHSat. For instance, a single 
292     ///         INCHSat will return 0 DaiSats and 101 INCHSats will return 485, instead of 489.85 INCHSats
293     /// @dev    Rounding down for minimum denomination units will result in negligible losses for user. 
294     ///         Premium increases are functionally the same as distributing fees to all remaining INCH tokens
295     function __sellInchForDai(uint _inchToSell) external {
296         // Deduct fee (currenly 3%). Rounds down to nearest INCH. Input of 1 will return 0. Input of 3 will return 2
297         // Input of 101 will return 97
298         uint _trueInchToSell = _inchToSell.mul(conserveRate).div(conserveRateDigits);
299         // Calculate Dai to send to user based on premium
300         uint _daiToReturn = _trueInchToSell.mul(premium).div(premiumDigits);
301         
302         // Send Dai to user
303         daiContract.transfer(msg.sender, _daiToReturn);
304         // Deposit INCH from user into vault
305         inchWormContract.transferFrom(msg.sender, address(this), _inchToSell);
306         // Transfer 1% to deployer. In the future, this will go to holders of the "ownership Token"
307         uint _deployerPayment = _inchToSell.mul(100).div(10000).mul(premium).div(premiumDigits);
308         daiContract.transfer(deployer, _deployerPayment);
309         
310         // Increase the premium. Premium increases are based on fees. It is functionally equivalent to distributing the fee to 
311         // remaining INCH tokens in the form of a redeemable dividend. Example: Given 100 Dai worth of fees paid  and 5000 tokens
312         // remaining after the transaction, the premium must increase by an amount such that each INCH is worth 0.02 more Dai.
313         // If the premium was previously 2000000, then the new premium should be 2020000.
314         // Formula: premium += (FeeAmountInDai *1000000) / CirculatingSupplyAfterTransaction
315         uint _premiumIncrease = _inchToSell.sub(_trueInchToSell).mul(premium).div(inchWormContract.totalSupply().sub(inchWormContract.balanceOf(address(this))));
316         premium = premium.add(_premiumIncrease);
317         
318         emit PremiumIncreased(_inchToSell, _premiumIncrease);
319         emit SellInchForDai(_inchToSell, _daiToReturn);
320     }
321     
322     /* ^__^__^__^__^__^__^__^__Deposit and Withdrawel Functions__^__^__^__^__^__^__^__^__^*/
323     /*____________________________________________________________________________________*/
324     
325     
326     
327     
328     /*____________________________________________________________________________________*/
329     /*___________________________________View Functions___________________________________*/
330     
331 
332     /// @return The current premium, which is initially 1,000,000
333     /// @notice The premium changes the rate at which INCH is exchanged for Dai and Ether
334     function getPremium() external view returns(uint){
335         return premium;
336     } 
337     
338     /// @return The percentage fee that is paid when withdrawing Ether or Dai
339     function getFeePercent() external pure returns(uint) {
340         return (conserveRateDigits - conserveRate)/100;    
341     }
342     
343     function canPegBeIncreased() external view returns(bool) {
344         return (address(this).balance.mul(etherPeg) <= daiContract.balanceOf(address(this)).div(50) && (now > pegMoveReadyTime)); 
345     }
346     
347     /// @return true if a call can be made to decrease peg
348     function canPegBeDecreased() external view returns(bool) {
349         return (daiContract.balanceOf(address(this)) <= address(this).balance.mul(etherPeg).div(50) && (now > pegMoveReadyTime));
350     }
351     
352     /// @return true if a call can be made to increase peg
353     function vzgetCirculatingSupply() public view returns(uint) {
354         return inchWormContract.totalSupply().sub(inchWormContract.balanceOf(address(this)));
355     }
356     
357     
358     /// @return The amount of ETH you will get after selling X INCH
359     function afterFeeEthReturns(uint _inchToSell) public view returns(uint) {
360         uint _trueInchToSell = _inchToSell.mul(conserveRate).div(conserveRateDigits);
361         return _trueInchToSell.mul(premium).div(premiumDigits.mul(etherPeg));
362     }
363     
364     /// @return The amount of ETH you will get after selling X INCH
365     function afterFeeDaiReturns(uint _inchToSell) public view returns(uint) {
366         uint _trueInchToSell = _inchToSell.mul(conserveRate).div(conserveRateDigits);
367         return _trueInchToSell.mul(premium).div(premiumDigits);
368     }
369     
370     /// @return The Wei balance of the vault contract
371     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
372     function getEthBalance() public view returns(uint) {
373         return address(this).balance;
374     }
375     
376     /// @return The INCH balance of the vault contract
377     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
378     function getInchBalance() public view returns(uint) {
379         return inchWormContract.balanceOf(address(this));
380     }
381     
382     /// @return The Dai balance of the vault contract
383     ///         ALL TOKENS UNCLUDING ETHER ARE DISPLAYED AS 10^-18 * THE BASE UNIT OF CURRENCY
384     function getDaiBalance() public view returns(uint) {
385         return daiContract.balanceOf(address(this));
386     }
387     
388     /// @param _a: the address to check balance of
389     /// @return INCH balance of target address
390     /// @notice This is just the balanceOf function from inchWormContract. Put here for ease of access
391     function getOwnerInch(address _a) public view returns(uint) {
392         return inchWormContract.balanceOf(_a);
393     }
394     
395     /* ^__^__^__^__^__^__^__^__^__^__^__View Functions__^__^__^__^__^__^__^__^__^__^__^__^*/
396     /*____________________________________________________________________________________*/
397 
398 
399     
400     
401     /*____________________________________________________________________________________*/
402     /*__________________________Emergency and Fallback Functions__________________________*/
403     
404     /// @notice Original deployer can transfer out tokens other than Dai and INCH
405     /// @dev    This function can be used to steal funds if there is any way to alter the inchWormContract address or daiContract address
406     function transferAccidentalERC20Tokens(address tokenAddress, uint tokens) external returns (bool success) {
407         require(msg.sender == deployer);
408         require(tokenAddress != address(inchWormContract));
409         require(tokenAddress != address(daiContract));
410         
411         return ERC20Interface(tokenAddress).transfer(owner, tokens);
412     }
413     
414     // fallback function
415     function () external payable {
416         revert();
417     }
418     
419     /* ^__^__^__^__^__^__^__^__emergency and fallback functions__^__^__^__^__^__^__^__^__^*/
420     /*____________________________________________________________________________________*/
421     
422 }