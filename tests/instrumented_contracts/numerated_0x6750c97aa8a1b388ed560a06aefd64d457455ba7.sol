1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances. 
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**   
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) {
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of. 
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value);
85   function approve(address spender, uint256 value);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // if (_value > _allowance) throw;
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 
150 /**
151  * @title Blocktix Token Generation Event contract
152  *
153  * @dev Based on code by BAT: https://github.com/brave-intl/basic-attention-token-crowdsale/blob/master/contracts/BAToken.sol
154  */
155 contract TIXGeneration is StandardToken {
156     string public constant name = "Blocktix Token";
157     string public constant symbol = "TIX";
158     uint256 public constant decimals = 18;
159     string public version = "1.0";
160 
161     // crowdsale parameters
162     bool public isFinalized;              // switched to true in operational state
163     uint256 public startTime = 0;         // crowdsale start time (in seconds)
164     uint256 public endTime = 0;           // crowdsale end time (in seconds)
165     uint256 public constant tokenGenerationCap =  62.5 * (10**6) * 10**decimals; // 62.5m TIX
166     uint256 public constant t2tokenExchangeRate = 1250;
167     uint256 public constant t3tokenExchangeRate = 1041;
168     uint256 public constant tixFund = tokenGenerationCap / 100 * 24;     // 24%
169     uint256 public constant tixFounders = tokenGenerationCap / 100 * 10; // 10%
170     uint256 public constant tixPromo = tokenGenerationCap / 100 * 2;     // 2%
171     uint256 public constant tixPresale = 29.16 * (10**6) * 10**decimals;    // 29.16m TIX Presale
172 
173     uint256 public constant finalTier = 52.5 * (10**6) * 10**decimals; // last 10m
174     uint256 public tokenExchangeRate = t2tokenExchangeRate;
175 
176     // addresses
177     address public ethFundDeposit;      // deposit address for ETH for Blocktix
178     address public tixFundDeposit;      // deposit address for TIX for Blocktix
179     address public tixFoundersDeposit;  // deposit address for TIX for Founders
180     address public tixPromoDeposit;     // deposit address for TIX for Promotion
181     address public tixPresaleDeposit;   // deposit address for TIX for Presale
182 
183     /**
184     * @dev modifier to allow actions only when the contract IS finalized
185     */
186     modifier whenFinalized() {
187         if (!isFinalized) throw;
188         _;
189     }
190 
191     /**
192     * @dev modifier to allow actions only when the contract IS NOT finalized
193     */
194     modifier whenNotFinalized() {
195         if (isFinalized) throw;
196         _;
197     }
198 
199     // ensures that the current time is between _startTime (inclusive) and _endTime (exclusive)
200     modifier between(uint256 _startTime, uint256 _endTime) {
201         assert(now >= _startTime && now < _endTime);
202         _;
203     }
204 
205     // verifies that an amount is greater than zero
206     modifier validAmount() {
207         require(msg.value > 0);
208         _;
209     }
210 
211     // validates an address - currently only checks that it isn't null
212     modifier validAddress(address _address) {
213         require(_address != 0x0);
214         _;
215     }
216 
217     // events
218     event CreateTIX(address indexed _to, uint256 _value);
219 
220     /**
221     * @dev Contructor that assigns all presale tokens and starts the sale
222     */
223     function TIXGeneration(
224         address _ethFundDeposit,
225         address _tixFundDeposit,
226         address _tixFoundersDeposit,
227         address _tixPromoDeposit,
228         address _tixPresaleDeposit,
229         uint256 _startTime,
230         uint256 _endTime)
231     {
232         isFinalized = false; // Initialize presale
233 
234         ethFundDeposit = _ethFundDeposit;
235         tixFundDeposit = _tixFundDeposit;
236         tixFoundersDeposit = _tixFoundersDeposit;
237         tixPromoDeposit = _tixPromoDeposit;
238         tixPresaleDeposit = _tixPresaleDeposit;
239 
240         startTime = _startTime;
241         endTime = _endTime;
242 
243         // Allocate presale and founders tix
244         totalSupply = tixFund;
245         totalSupply += tixFounders;
246         totalSupply += tixPromo;
247         totalSupply += tixPresale;
248         balances[tixFundDeposit] = tixFund;         // Deposit TIX for Blocktix
249         balances[tixFoundersDeposit] = tixFounders; // Deposit TIX for Founders
250         balances[tixPromoDeposit] = tixPromo;       // Deposit TIX for Promotion
251         balances[tixPresaleDeposit] = tixPresale;   // Deposit TIX for Presale
252         CreateTIX(tixFundDeposit, tixFund);         // logs TIX for Blocktix
253         CreateTIX(tixFoundersDeposit, tixFounders); // logs TIX for Founders
254         CreateTIX(tixPromoDeposit, tixPromo);       // logs TIX for Promotion
255         CreateTIX(tixPresaleDeposit, tixPresale);   // logs TIX for Presale
256 
257     }
258 
259     /**
260     * @dev transfer token for a specified address
261     * @param _to The address to transfer to.
262     * @param _value The amount to be transferred.
263     *
264     * can only be called during once the the funding period has been finalized
265     */
266     function transfer(address _to, uint _value) whenFinalized {
267         super.transfer(_to, _value);
268     }
269 
270     /**
271     * @dev Transfer tokens from one address to another
272     * @param _from address The address which you want to send tokens from
273     * @param _to address The address which you want to transfer to
274     * @param _value uint256 the amout of tokens to be transfered
275     *
276     * can only be called during once the the funding period has been finalized
277     */
278     function transferFrom(address _from, address _to, uint _value) whenFinalized {
279         super.transferFrom(_from, _to, _value);
280     }
281 
282     /**
283      * @dev Accepts ETH and generates TIX tokens
284      *
285      * can only be called during the crowdsale
286      */
287     function generateTokens()
288         public
289         payable
290         whenNotFinalized
291         between(startTime, endTime)
292         validAmount
293     {
294         if (totalSupply == tokenGenerationCap)
295             throw;
296 
297         uint256 tokens = SafeMath.mul(msg.value, tokenExchangeRate); // check that we're not over totals
298         uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
299         uint256 diff;
300 
301         // switch to next tier
302         if (tokenExchangeRate != t3tokenExchangeRate && finalTier < checkedSupply)
303         {
304             diff = SafeMath.sub(checkedSupply, finalTier);
305             tokens = SafeMath.sub(tokens, diff);
306             uint256 ethdiff = SafeMath.div(diff, t2tokenExchangeRate);
307             tokenExchangeRate = t3tokenExchangeRate;
308             tokens = SafeMath.add(tokens, SafeMath.mul(ethdiff, tokenExchangeRate));
309             checkedSupply = SafeMath.add(totalSupply, tokens);
310         }
311 
312         // return money if something goes wrong
313         if (tokenGenerationCap < checkedSupply)
314         {
315             diff = SafeMath.sub(checkedSupply, tokenGenerationCap);
316             if (diff > 10**12)
317                 throw;
318             checkedSupply = SafeMath.sub(checkedSupply, diff);
319             tokens = SafeMath.sub(tokens, diff);
320         }
321 
322         totalSupply = checkedSupply;
323         balances[msg.sender] += tokens;
324         CreateTIX(msg.sender, tokens); // logs token creation
325     }
326 
327     /**
328     * @dev Ends the funding period and sends the ETH home
329     */
330     function finalize()
331         external
332         whenNotFinalized
333     {
334         if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
335         if (now <= endTime && totalSupply != tokenGenerationCap) throw;
336         // move to operational
337         isFinalized = true;
338         if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to Blocktix
339     }
340 
341     // fallback
342     function()
343         payable
344         whenNotFinalized
345     {
346         generateTokens();
347     }
348 }