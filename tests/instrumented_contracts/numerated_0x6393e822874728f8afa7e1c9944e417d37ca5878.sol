1 // CryptoIndex token smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 
4 pragma solidity ^0.4.24;
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address private _owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     _owner = msg.sender;
28   }
29 
30   /**
31    * @return the address of the owner.
32    */
33   function owner() public view returns(address) {
34     return _owner;
35   }
36 
37   /**
38    * @dev Throws if called by any account other than the owner.
39    */
40   modifier onlyOwner() {
41     require(isOwner());
42     _;
43   }
44 
45   /**
46    * @return true if `msg.sender` is the owner of the contract.
47    */
48   function isOwner() public view returns(bool) {
49     return msg.sender == _owner;
50   }
51 
52   /**
53    * @dev Allows the current owner to relinquish control of the contract.
54    * @notice Renouncing to ownership will leave the contract without an owner.
55    * It will not be possible to call the functions with the `onlyOwner`
56    * modifier anymore.
57    */
58   function renounceOwnership() public onlyOwner {
59     emit OwnershipRenounced(_owner);
60     _owner = address(0);
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     _transferOwnership(newOwner);
69   }
70 
71   /**
72    * @dev Transfers control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function _transferOwnership(address newOwner) internal {
76     require(newOwner != address(0));
77     emit OwnershipTransferred(_owner, newOwner);
78     _owner = newOwner;
79   }
80 }
81 
82 /**
83  *   @title ERC20
84  *   @dev Standart ERC20 token interface
85  */
86 
87 contract ERC20 {
88     mapping(address => uint) balances;
89     mapping(address => mapping (address => uint)) allowed;
90 
91     function balanceOf(address _owner) public view returns (uint);
92     function transfer(address _to, uint _value) public returns (bool);
93     function transferFrom(address _from, address _to, uint _value) public returns (bool);
94     function approve(address _spender, uint _value) public returns (bool);
95     function allowance(address _owner, address _spender) public view returns (uint);
96 
97     event Transfer(address indexed _from, address indexed _to, uint _value);
98     event Approval(address indexed _owner, address indexed _spender, uint _value);
99 
100 } 
101 
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint a, uint b) internal pure returns (uint) {
113     if (a == 0) {
114       return 0;
115     }
116     uint c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint a, uint b) internal pure returns (uint) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint a, uint b) internal pure returns (uint) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint a, uint b) internal pure returns (uint) {
143     uint c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 /**
150  *   @title CryptoIndexToken
151  *   @dev СryptoIndexToken smart-contract
152  */
153 contract CryptoIndexToken is ERC20, Ownable() {
154     using SafeMath for uint;
155 
156     string public name = "Cryptoindex 100";
157     string public symbol = "CIX100";
158     uint public decimals = 18;
159 
160     uint public totalSupply = 300000000*1e18;
161     uint public mintedAmount;
162 
163     uint public advisorsFundPercent = 3; // 3% of private sale for advisors fund 
164     uint public teamFundPercent = 7; // 7% of private sale for team fund
165 
166     uint public bonusFundValue;
167     uint public forgetFundValue;
168 
169     bool public mintingIsStarted;
170     bool public mintingIsFinished;
171 
172     address public teamFund;
173     address public advisorsFund;
174     address public bonusFund;
175     address public forgetFund;
176     address public reserveFund;
177 
178     modifier onlyController() {
179         require(controllers[msg.sender] == true);
180         _;
181     }
182 
183     // controllers
184     mapping(address => bool) public controllers;
185 
186     //event
187     event Burn(address indexed from, uint value);
188     event MintingStarted(uint timestamp);
189     event MintingFinished(uint timestamp);
190     
191 
192    /**
193     *   @dev Contract constructor function sets Ico address
194     *   @param _teamFund       team fund address
195     */
196     constructor(address _forgetFund, address _teamFund, address _advisorsFund, address _bonusFund, address _reserveFund) public {
197         controllers[msg.sender] = true;
198         forgetFund = _forgetFund;
199         teamFund = _teamFund;
200         advisorsFund = _advisorsFund;
201         bonusFund = _bonusFund;
202         reserveFund = _reserveFund;
203     }
204 
205    /**
206     *   @dev Start minting
207     *   @param _forgetFundValue        number of tokens for forgetFund
208     *   @param _bonusFundValue         number of tokens for bonusFund
209     */
210     function startMinting(uint _forgetFundValue, uint _bonusFundValue) public onlyOwner {
211         forgetFundValue = _forgetFundValue;
212         bonusFundValue = _bonusFundValue;
213         mintingIsStarted = true;
214         emit MintingStarted(now);
215     }
216 
217    /**
218     *   @dev Finish minting
219     */
220     function finishMinting() public onlyOwner {
221         require(mint(forgetFund, forgetFundValue));
222         uint currentMintedAmount = mintedAmount;
223         require(mint(teamFund, currentMintedAmount.mul(teamFundPercent).div(100)));
224         require(mint(advisorsFund, currentMintedAmount.mul(advisorsFundPercent).div(100)));
225         require(mint(bonusFund, bonusFundValue));
226         require(mint(reserveFund, totalSupply.sub(mintedAmount)));
227         mintingIsFinished = true;
228         emit MintingFinished(now);
229     }
230 
231    /**
232     *   @dev Get balance of tokens holder
233     *   @param _holder        holder's address
234     *   @return               balance of investor
235     */
236     function balanceOf(address _holder) public view returns (uint) {
237         return balances[_holder];
238     }
239 
240    /**
241     *   @dev Send coins
242     *   throws on any error rather then return a false flag to minimize
243     *   user errors
244     *   @param _to           target address
245     *   @param _amount       transfer amount
246     *
247     *   @return true if the transfer was successful
248     */
249     function transfer(address _to, uint _amount) public returns (bool) {
250         require(mintingIsFinished);
251         require(_to != address(0) && _to != address(this));
252         balances[msg.sender] = balances[msg.sender].sub(_amount);
253         balances[_to] = balances[_to].add(_amount);
254         emit Transfer(msg.sender, _to, _amount);
255         return true;
256     }
257 
258     /**
259     *   @dev Transfer token in batches
260     *   
261     *   @param _adresses     token holders' adresses
262     *   @param _values       token holders' values
263     */
264     function batchTransfer(address[] _adresses, uint[] _values) public returns (bool) {
265         require(_adresses.length == _values.length);
266         for (uint i = 0; i < _adresses.length; i++) {
267             require(transfer(_adresses[i], _values[i]));
268         }
269         return true;
270     }
271 
272    /**
273     *   @dev An account/contract attempts to get the coins
274     *   throws on any error rather then return a false flag to minimize user errors
275     *
276     *   @param _from         source address
277     *   @param _to           target address
278     *   @param _amount       transfer amount
279     *
280     *   @return true if the transfer was successful
281     */
282     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
283         require(mintingIsFinished);
284 
285         require(_to != address(0) && _to != address(this));
286         balances[_from] = balances[_from].sub(_amount);
287         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
288         balances[_to] = balances[_to].add(_amount);
289         emit Transfer(_from, _to, _amount);
290         return true;
291     }
292 
293     /**
294     *   @dev Add controller address
295     *   
296     *   @param _controller     controller's address
297     */
298     function addController(address _controller) public onlyOwner {
299         require(mintingIsStarted);
300         controllers[_controller] = true;
301     }
302     
303     /**
304     *   @dev Remove controller address
305     *   
306     *   @param _controller     controller's address
307     */
308     function removeController(address _controller) public onlyOwner {
309         controllers[_controller] = false;
310     }
311     
312     /**
313     *   @dev Mint token in batches
314     *   
315     *   @param _adresses     token holders' adresses
316     *   @param _values       token holders' values
317     */
318     function batchMint(address[] _adresses, uint[] _values) public onlyController {
319         require(_adresses.length == _values.length);
320         for (uint i = 0; i < _adresses.length; i++) {
321             require(mint(_adresses[i], _values[i]));
322             emit Transfer(address(0), _adresses[i], _values[i]);
323         }
324     }
325 
326     function burn(address _from, uint _value) public {
327         if (msg.sender != _from) {
328           require(!mintingIsFinished);
329           // burn tokens from _from only if minting stage is not finished
330           // allows owner to correct initial balance before finishing minting
331           require(msg.sender == this.owner());
332           mintedAmount = mintedAmount.sub(_value);          
333         } else {
334           require(mintingIsFinished);
335           totalSupply = totalSupply.sub(_value);
336         }
337         balances[_from] = balances[_from].sub(_value);
338         emit Burn(_from, _value);
339     }
340    /**
341     *   @dev Allows another account/contract to spend some tokens on its behalf
342     *   throws on any error rather then return a false flag to minimize user errors
343     *
344     *   also, to minimize the risk of the approve/transferFrom attack vector
345     *   approve has to be called twice in 2 separate transactions - once to
346     *   change the allowance to 0 and secondly to change it to the new allowance
347     *   value
348     *
349     *   @param _spender      approved address
350     *   @param _amount       allowance amount
351     *
352     *   @return true if the approval was successful
353     */
354     function approve(address _spender, uint _amount) public returns (bool) {
355         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
356         allowed[msg.sender][_spender] = _amount;
357         emit Approval(msg.sender, _spender, _amount);
358         return true;
359     }
360 
361 
362    /**
363     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
364     *
365     *   @param _owner        the address which owns the funds
366     *   @param _spender      the address which will spend the funds
367     *
368     *   @return              the amount of tokens still avaible for the spender
369     */
370     function allowance(address _owner, address _spender) public view returns (uint) {
371         return allowed[_owner][_spender];
372     }
373 
374     /** 
375     *   @dev Allows to transfer out any accidentally sent ERC20 tokens
376     *   @param _tokenAddress  token address
377     *   @param _amount        transfer amount
378     */
379     function transferAnyTokens(address _tokenAddress, uint _amount) 
380         public
381         returns (bool success) {
382         return ERC20(_tokenAddress).transfer(this.owner(), _amount);
383     }
384 
385     function mint(address _to, uint _value) internal returns (bool) {
386         // Mint tokens only if minting stage is not finished
387         require(mintingIsStarted);
388         require(!mintingIsFinished);
389         require(mintedAmount.add(_value) <= totalSupply);
390         balances[_to] = balances[_to].add(_value);
391         mintedAmount = mintedAmount.add(_value);
392         return true;
393     }
394 }