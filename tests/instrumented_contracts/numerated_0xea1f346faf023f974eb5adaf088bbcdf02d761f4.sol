1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title ERC20Basic
37  * @dev Simpler version of ERC20 interface
38  * @dev see https://github.com/ethereum/EIPs/issues/20
39  */
40 contract ERC20Basic {
41   uint256 public totalSupply;
42   function balanceOf(address who) constant returns (uint256);
43   function transfer(address to, uint256 value);
44   event Transfer(address indexed from, address indexed to, uint256 value);
45 }
46 
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances. 
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) {
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of. 
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value);
87   function approve(address spender, uint256 value);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amout of tokens to be transfered
109    */
110   function transferFrom(address _from, address _to, uint256 _value) {
111     var _allowance = allowed[_from][msg.sender];
112 
113     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
114     // if (_value > _allowance) throw;
115 
116     balances[_to] = balances[_to].add(_value);
117     balances[_from] = balances[_from].sub(_value);
118     allowed[_from][msg.sender] = _allowance.sub(_value);
119     Transfer(_from, _to, _value);
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still avaible for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 
152 /**
153  * @title Stalled ERC20 token
154  */
155 contract TIXStalledToken {
156   uint256 public totalSupply;
157   bool public isFinalized; // switched to true in operational state
158   address public ethFundDeposit; // deposit address for ETH for Blocktix
159 
160   function balanceOf(address who) constant returns (uint256);
161 }
162 
163 
164 /**
165  * @title Blocktix Token Generation Event contract
166  *
167  * @dev Based on code by BAT: https://github.com/brave-intl/basic-attention-token-crowdsale/blob/master/contracts/BAToken.sol
168  */
169 contract TIXToken is StandardToken {
170     mapping(address => bool) converted; // Converting from old token contract
171 
172     string public constant name = "Blocktix Token";
173     string public constant symbol = "TIX";
174     uint256 public constant decimals = 18;
175     string public version = "1.0.1";
176 
177     // crowdsale parameters
178     bool public isFinalized;                      // switched to true in operational state
179     uint256 public startTime = 1501271999;        // crowdsale start time (in seconds) - this will be set once the conversion is done
180     uint256 public constant endTime = 1501271999; // crowdsale end time (in seconds)
181     uint256 public constant tokenGenerationCap =  62.5 * (10**6) * 10**decimals; // 62.5m TIX
182     uint256 public constant tokenExchangeRate = 1041;
183 
184     // addresses
185     address public tixGenerationContract; // contract address for TIX v1 Funding
186     address public ethFundDeposit;        // deposit address for ETH for Blocktix
187 
188     /**
189     * @dev modifier to allow actions only when the contract IS finalized
190     */
191     modifier whenFinalized() {
192         if (!isFinalized) throw;
193         _;
194     }
195 
196     /**
197     * @dev modifier to allow actions only when the contract IS NOT finalized
198     */
199     modifier whenNotFinalized() {
200         if (isFinalized) throw;
201         _;
202     }
203 
204     // ensures that the current time is between _startTime (inclusive) and _endTime (exclusive)
205     modifier between(uint256 _startTime, uint256 _endTime) {
206         assert(now >= _startTime && now < _endTime);
207         _;
208     }
209 
210     // verifies that an amount is greater than zero
211     modifier validAmount() {
212         require(msg.value > 0);
213         _;
214     }
215 
216     // validates an address - currently only checks that it isn't null
217     modifier validAddress(address _address) {
218         require(_address != 0x0);
219         _;
220     }
221 
222     // events
223     event CreateTIX(address indexed _to, uint256 _value);
224 
225     /**
226     * @dev Contructor that assigns all presale tokens and starts the sale
227     */
228     function TIXToken(address _tixGenerationContract)
229     {
230         isFinalized = false; // Initialize presale
231         tixGenerationContract = _tixGenerationContract;
232         ethFundDeposit = TIXStalledToken(tixGenerationContract).ethFundDeposit();
233     }
234 
235 
236     /**
237     * @dev transfer token for a specified address
238     * @param _to The address to transfer to.
239     * @param _value The amount to be transferred.
240     *
241     * can only be called during once the the funding period has been finalized
242     */
243     function transfer(address _to, uint _value) whenFinalized {
244         super.transfer(_to, _value);
245     }
246 
247     /**
248     * @dev Transfer tokens from one address to another
249     * @param _from address The address which you want to send tokens from
250     * @param _to address The address which you want to transfer to
251     * @param _value uint256 the amout of tokens to be transfered
252     *
253     * can only be called during once the the funding period has been finalized
254     */
255     function transferFrom(address _from, address _to, uint _value) whenFinalized {
256         super.transferFrom(_from, _to, _value);
257     }
258 
259     /**
260      * @dev Accepts ETH and generates TIX tokens
261      *
262      * can only be called during the crowdsale
263      */
264     function generateTokens()
265         public
266         payable
267         whenNotFinalized
268         between(startTime, endTime)
269         validAmount
270     {
271         if (totalSupply == tokenGenerationCap)
272             throw;
273 
274         uint256 tokens = SafeMath.mul(msg.value, tokenExchangeRate); // check that we're not over totals
275         uint256 checkedSupply = SafeMath.add(totalSupply, tokens);
276         uint256 diff;
277 
278         // return if something goes wrong
279         if (tokenGenerationCap < checkedSupply)
280         {
281             diff = SafeMath.sub(checkedSupply, tokenGenerationCap);
282             if (diff > 10**12)
283                 throw;
284             checkedSupply = SafeMath.sub(checkedSupply, diff);
285             tokens = SafeMath.sub(tokens, diff);
286         }
287 
288         totalSupply = checkedSupply;
289         balances[msg.sender] += tokens;
290         CreateTIX(msg.sender, tokens); // logs token creation
291     }
292 
293     function hasConverted(address who) constant returns (bool)
294     {
295       return converted[who];
296     }
297 
298     function convert(address _owner)
299         external
300     {
301         TIXStalledToken tixStalled = TIXStalledToken(tixGenerationContract);
302         if (tixStalled.isFinalized()) throw; // We can't convert tokens after the contract is finalized
303         if (converted[_owner]) throw; // Throw if they have already converted
304         uint256 balanceOf = tixStalled.balanceOf(_owner);
305         if (balanceOf <= 0) throw; // Throw if they don't have an existing balance
306         converted[_owner] = true;
307         totalSupply += balanceOf;
308         balances[_owner] += balanceOf;
309         Transfer(this, _owner, balanceOf);
310     }
311 
312     function continueGeneration()
313         external
314     {
315         TIXStalledToken tixStalled = TIXStalledToken(tixGenerationContract);
316         // Allow the sale to continue
317         if (totalSupply == tixStalled.totalSupply() && tixStalled.isFinalized())
318           startTime = now;
319         else
320           throw;
321     }
322 
323     /**
324     * @dev Ends the funding period and sends the ETH home
325     */
326     function finalize()
327         external
328         whenNotFinalized
329     {
330         if (msg.sender != ethFundDeposit) throw; // locks finalize to the ultimate ETH owner
331         if (now <= endTime && totalSupply != tokenGenerationCap) throw;
332         // move to operational
333         isFinalized = true;
334         if(!ethFundDeposit.send(this.balance)) throw;  // send the eth to Blocktix
335     }
336 
337     // fallback
338     function()
339         payable
340         whenNotFinalized
341     {
342         generateTokens();
343     }
344 }