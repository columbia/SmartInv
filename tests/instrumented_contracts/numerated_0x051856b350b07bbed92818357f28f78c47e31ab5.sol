1 pragma solidity ^"0.4.24";
2 
3 contract VestingBase {
4     using SafeMath for uint256;
5     CovaToken internal cova;
6     uint256 internal releaseTime;
7     uint256 internal genesisTime;
8     uint256 internal THREE_MONTHS = 7890000;
9     uint256 internal SIX_MONTHS = 15780000;
10 
11     address internal beneficiaryAddress;
12 
13     struct Claim {
14         bool fromGenesis;
15         uint256 pct;
16         uint256 delay;
17         bool claimed;
18     } 
19 
20     Claim [] internal beneficiaryClaims;
21     uint256 internal totalClaimable;
22 
23     event Claimed(
24         address indexed user,
25         uint256 amount,
26         uint256 timestamp
27     );
28 
29     function claim() public returns (bool){
30         require(msg.sender == beneficiaryAddress); 
31         for(uint256 i = 0; i < beneficiaryClaims.length; i++){
32             Claim memory cur_claim = beneficiaryClaims[i];
33             if(cur_claim.claimed == false){
34                 if((cur_claim.fromGenesis == false && (cur_claim.delay.add(releaseTime) < block.timestamp)) || (cur_claim.fromGenesis == true && (cur_claim.delay.add(genesisTime) < block.timestamp))){
35                     uint256 amount = cur_claim.pct.mul(totalClaimable).div(10000);
36                     require(cova.transfer(msg.sender, amount));
37                     beneficiaryClaims[i].claimed = true;
38                     emit Claimed(msg.sender, amount, block.timestamp);
39                 }
40             }
41         }
42     }
43 
44     function getBeneficiary() public view returns (address) {
45         return beneficiaryAddress;
46     }
47 
48     function getTotalClaimable() public view returns (uint256) {
49         return totalClaimable;
50     }
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 {
58   function totalSupply() public view returns (uint256);
59 
60   function balanceOf(address _who) public view returns (uint256);
61 
62   function allowance(address _owner, address _spender)
63     public view returns (uint256);
64 
65   function transfer(address _to, uint256 _value) public returns (bool);
66 
67   function approve(address _spender, uint256 _value)
68     public returns (bool);
69 
70   function transferFrom(address _from, address _to, uint256 _value)
71     public returns (bool);
72 
73   event Transfer(
74     address indexed from,
75     address indexed to,
76     uint256 value
77   );
78 
79   event Approval(
80     address indexed owner,
81     address indexed spender,
82     uint256 value
83   );
84 }
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that revert on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, reverts on overflow.
94   */
95   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
97     // benefit is lost if 'b' is also tested.
98     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
99     if (_a == 0) {
100       return 0;
101     }
102 
103     uint256 c = _a * _b;
104     require(c / _a == _b);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
111   */
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     require(_b > 0); // Solidity only automatically asserts when dividing by 0
114     uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116 
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
124     require(_b <= _a);
125     uint256 c = _a - _b;
126 
127     return c;
128   }
129 
130   /**
131   * @dev Adds two numbers, reverts on overflow.
132   */
133   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
134     uint256 c = _a + _b;
135     require(c >= _a);
136 
137     return c;
138   }
139 
140   /**
141   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
142   * reverts when dividing by zero.
143   */
144   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b != 0);
146     return a % b;
147   }
148 }
149 
150 
151 
152 
153 /**
154  * @title Standard ERC20, Cova Token
155  *
156  * @dev Implementation of the basic standard token.
157  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
158  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 
161 contract CovaToken is ERC20 {
162   using SafeMath for uint256;
163 
164   mapping (address => uint256) private balances;
165   mapping (address => mapping (address => uint256)) private allowed;
166 
167   uint256 private totalSupply_ = 65 * (10 ** (8 + 18));
168   string private constant name_ = 'Covalent Token';                                 // Set the token name for display
169   string private constant symbol_ = 'COVA';                                         // Set the token symbol for display
170   uint8 private constant decimals_ = 18;                                          // Set the number of decimals for display
171   
172 
173   constructor () public {
174     balances[msg.sender] = totalSupply_;
175     emit Transfer(address(0), msg.sender, totalSupply_);
176   }
177 
178   /**
179   * @dev Total number of tokens in existence
180   */
181   function totalSupply() public view returns (uint256) {
182     return totalSupply_;
183   }
184 
185   /**
186   * @dev Token name
187   */
188   function name() public view returns (string) {
189     return name_;
190   }
191 
192   /**
193   * @dev Token symbol
194   */
195   function symbol() public view returns (string) {
196     return symbol_;
197   }
198 
199   /**
200   * @dev Token decinal
201   */
202   function decimals() public view returns (uint8) {
203     return decimals_;
204   }
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param _owner The address to query the the balance of.
209   * @return An uint256 representing the amount owned by the passed address.
210   */
211   function balanceOf(address _owner) public view returns (uint256) {
212     return balances[_owner];
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(
222     address _owner,
223     address _spender
224    )
225     public
226     view
227     returns (uint256)
228   {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233   * @dev Transfer token for a specified address
234   * @param _to The address to transfer to.
235   * @param _value The amount to be transferred.
236   */
237   function transfer(address _to, uint256 _value) public returns (bool) {
238     require(_value <= balances[msg.sender]);
239     require(_to != address(0));
240 
241     balances[msg.sender] = balances[msg.sender].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     emit Transfer(msg.sender, _to, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Transfer tokens from one address to another
264    * @param _from address The address which you want to send tokens from
265    * @param _to address The address which you want to transfer to
266    * @param _value uint256 the amount of tokens to be transferred
267    */
268   function transferFrom(
269     address _from,
270     address _to,
271     uint256 _value
272   )
273     public
274     returns (bool)
275   {
276     require(_value <= balances[_from]);
277     require(_value <= allowed[_from][msg.sender]);
278     require(_to != address(0));
279 
280     balances[_from] = balances[_from].sub(_value);
281     balances[_to] = balances[_to].add(_value);
282     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
283     emit Transfer(_from, _to, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Increase the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To increment
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _addedValue The amount of tokens to increase the allowance by.
295    */
296   function increaseApproval(
297     address _spender,
298     uint256 _addedValue
299   )
300     public
301     returns (bool)
302   {
303     allowed[msg.sender][_spender] = (
304       allowed[msg.sender][_spender].add(_addedValue));
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309   /**
310    * @dev Decrease the amount of tokens that an owner allowed to a spender.
311    * approve should be called when allowed[_spender] == 0. To decrement
312    * allowed value is better to use this function to avoid 2 calls (and wait until
313    * the first transaction is mined)
314    * From MonolithDAO Token.sol
315    * @param _spender The address which will spend the funds.
316    * @param _subtractedValue The amount of tokens to decrease the allowance by.
317    */
318   function decreaseApproval(
319     address _spender,
320     uint256 _subtractedValue
321   )
322     public
323     returns (bool)
324   {
325     uint256 oldValue = allowed[msg.sender][_spender];
326     if (_subtractedValue >= oldValue) {
327       allowed[msg.sender][_spender] = 0;
328     } else {
329       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
330     }
331     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332     return true;
333   }
334 }
335 
336 contract VestingFoundation is VestingBase{
337     using SafeMath for uint256;
338 
339     constructor(CovaToken _cova, uint256 _releaseTime) public {
340         cova = _cova;
341         releaseTime = _releaseTime;
342         genesisTime = block.timestamp;
343         beneficiaryAddress = 0xC29cf578388A738868009a03fecCe7A262cda22a;
344         totalClaimable = 650000000 * (10 ** 18);
345         beneficiaryClaims.push(Claim(false, 10000, 0, false));
346     }
347 }