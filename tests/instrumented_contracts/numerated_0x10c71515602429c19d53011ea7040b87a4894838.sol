1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    */
79   function renounceOwnership() public onlyOwner {
80     emit OwnershipRenounced(owner);
81     owner = address(0);
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param _newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address _newOwner) public onlyOwner {
89     _transferOwnership(_newOwner);
90   }
91 
92   /**
93    * @dev Transfers control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function _transferOwnership(address _newOwner) internal {
97     require(_newOwner != address(0));
98     emit OwnershipTransferred(owner, _newOwner);
99     owner = _newOwner;
100   }
101 }
102 
103 contract ERC20Basic {
104   function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint256 value);
108 }
109 
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256) {
145     return balances[_owner];
146   }
147 
148 }
149 
150 contract BurnableToken is BasicToken {
151 
152   event Burn(address indexed burner, uint256 value);
153 
154   /**
155    * @dev Burns a specific amount of tokens.
156    * @param _value The amount of token to be burned.
157    */
158   function burn(uint256 _value) public {
159     _burn(msg.sender, _value);
160   }
161 
162   function _burn(address _who, uint256 _value) internal {
163     require(_value <= balances[_who]);
164     // no need to require value <= totalSupply, since that would imply the
165     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
166 
167     balances[_who] = balances[_who].sub(_value);
168     totalSupply_ = totalSupply_.sub(_value);
169     emit Burn(_who, _value);
170     emit Transfer(_who, address(0), _value);
171   }
172 }
173 
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender)
176     public view returns (uint256);
177 
178   function transferFrom(address from, address to, uint256 value)
179     public returns (bool);
180 
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(
183     address indexed owner,
184     address indexed spender,
185     uint256 value
186   );
187 }
188 
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(
201     address _from,
202     address _to,
203     uint256 _value
204   )
205     public
206     returns (bool)
207   {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     emit Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(
242     address _owner,
243     address _spender
244    )
245     public
246     view
247     returns (uint256)
248   {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(
263     address _spender,
264     uint _addedValue
265   )
266     public
267     returns (bool)
268   {
269     allowed[msg.sender][_spender] = (
270       allowed[msg.sender][_spender].add(_addedValue));
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 contract StandardBurnableToken is BurnableToken, StandardToken {
305 
306   /**
307    * @dev Burns a specific amount of tokens from the target address and decrements allowance
308    * @param _from address The address which you want to send tokens from
309    * @param _value uint256 The amount of token to be burned
310    */
311   function burnFrom(address _from, uint256 _value) public {
312     require(_value <= allowed[_from][msg.sender]);
313     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
314     // this function needs to emit an event with the updated approval.
315     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
316     _burn(_from, _value);
317   }
318 }
319 
320 contract DPT is StandardBurnableToken, Ownable {
321 
322     string public constant name = "DPT";
323     string public constant symbol = "DPT";
324     uint8 public constant decimals = 18;
325     uint256 public rate = 1 ether;
326 
327     /**
328     * @dev Constructor that gives msg.sender all of existing tokens.
329     */
330     constructor() public {
331         totalSupply_ = 10000000 * (10 ** uint256(decimals));
332         balances[msg.sender] = totalSupply_;
333         emit Transfer(address(0), msg.sender, totalSupply_);
334     }
335 
336     function setRate(uint256 newRate) public onlyOwner {
337         rate = newRate;
338     }
339 
340     /**
341     * @dev Fallback function is used to buy tokens.
342     */
343     function () external payable {
344         buyTokens();
345     }
346 
347     /**
348     * @dev Low level token purchase function.
349     */
350     function buyTokens() public payable {
351         require(validPurchase());
352         uint256 weiAmount = msg.value;
353         // calculate token amount to be transfered
354         uint256 tokens = rate.mul(weiAmount).div(1 ether);
355         forwardFundsToOwner();
356         transferFromOwner(tokens);
357     }
358 
359     /**
360     * @dev Transfer tokens from owner.
361     */
362     function transferFromOwner(uint256 _value) private returns (bool) {
363         require(msg.sender != address(0));
364         require(_value <= balances[owner]);
365         // SafeMath.sub will throw if there is not enough balance.
366         balances[owner] = balances[owner].sub(_value);
367         balances[msg.sender] = balances[msg.sender].add(_value);
368         emit Transfer(owner, msg.sender, _value);
369         return true;
370     }
371 
372     /**
373     * @dev Transfer eth to owner.
374     */
375     function forwardFundsToOwner() internal {
376         owner.transfer(msg.value);
377     }
378 
379     /**
380     * @dev Return true if the transaction can buy tokens.
381     */
382     function validPurchase() internal view returns (bool) {
383         bool nonZeroPurchase = msg.value != 0;
384         return nonZeroPurchase;
385     }
386 
387 }