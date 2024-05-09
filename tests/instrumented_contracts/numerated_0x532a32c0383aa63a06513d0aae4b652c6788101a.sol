1 pragma solidity ^0.4.25;
2 
3 // File: contracts/ownership/Ownable.sol
4 // Block Eslip Token
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13  
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29  
30 
31 }
32 
33 // File: contracts/math/SafeMath.sol
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40 
41   /**
42   * @dev Multiplies two numbers, throws on overflow.
43   */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     if (a == 0) {
46       return 0;
47     }
48     c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return a / b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 // File: contracts/token/ERC20/ERC20Basic.sol
82 
83 /**
84  * @title ERC20Basic
85  * @dev Simpler version of ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/179
87  */
88 contract ERC20Basic {
89   function totalSupply() public view returns (uint256);
90   function balanceOf(address who) public view returns (uint256);
91   function transfer(address to, uint256 value) public returns (bool);
92   event Transfer(address indexed from, address indexed to, uint256 value);
93 }
94 
95 // File: contracts/token/ERC20/BasicToken.sol
96 
97 /**
98  * @title Basic token
99  * @dev Basic version of StandardToken, with no allowances.
100  */
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103 
104   mapping(address => uint256) balances;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256) {
136     return balances[_owner];
137   }
138 
139 }
140 
141 // File: contracts/token/ERC20/BurnableToken.sol
142 
143 /**
144  * @title Burnable Token
145  * @dev Token that can be irreversibly burned (destroyed).
146  */
147 contract BurnableToken is BasicToken {
148 
149   event Burn(address indexed burner, uint256 value);
150 
151   /**
152    * @dev Burns a specific amount of tokens.
153    * @param _value The amount of token to be burned.
154    */
155   function burn(uint256 _value) public {
156     _burn(msg.sender, _value);
157   }
158 
159   function _burn(address _who, uint256 _value) internal {
160     require(_value <= balances[_who]);
161     // no need to require value <= totalSupply, since that would imply the
162     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
163 
164     balances[_who] = balances[_who].sub(_value);
165     totalSupply_ = totalSupply_.sub(_value);
166     emit Burn(_who, _value);
167     emit Transfer(_who, address(0), _value);
168   }
169 }
170 
171 // File: contracts/token/ERC20/ERC20.sol
172 
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: contracts/token/ERC20/StandardToken.sol
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280  
281 contract BlockEslip is StandardToken, BurnableToken, Ownable {
282     // Constants
283     string  public constant name = "Block Eslip";
284     string  public constant symbol = "BEP";
285     uint8   public constant decimals = 18;
286     uint256 public constant INITIAL_SUPPLY      = 1000000000 * (10 ** uint256(decimals));
287 
288     mapping(address => bool) public balanceLocked;   
289     
290     
291     uint public amountRaised;
292     uint256 public buyPrice = 2000000;
293     bool public crowdsaleClosed = false;
294     bool public transferEnabled = false;
295 
296 
297     constructor() public {
298       totalSupply_ = INITIAL_SUPPLY;
299       balances[msg.sender] = INITIAL_SUPPLY;
300       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
301     }
302  
303 
304     function _transfer(address _from, address _to, uint _value) internal {     
305         require (balances[_from] >= _value);               // Check if the sender has enough
306         require (balances[_to] + _value > balances[_to]); // Check for overflows
307    
308         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
309         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
310  
311         emit Transfer(_from, _to, _value);
312     }
313 
314     function setPrice( uint256 newBuyPrice) onlyOwner public {
315         buyPrice = newBuyPrice;
316     }
317 
318     function closeBuy(bool closebuy) onlyOwner public {
319         crowdsaleClosed = closebuy;
320     }
321 
322     function () external payable {
323         require(!crowdsaleClosed);
324         uint amount = msg.value ;               // calculates the amount
325         amountRaised = amountRaised.add(amount);
326         _transfer(owner, msg.sender, amount.mul(buyPrice)); 
327         owner.transfer(amount);
328     }
329  
330     function enableTransfer(bool _enable) onlyOwner external {
331         transferEnabled = _enable;
332     }
333 
334     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335         require(transferEnabled);
336         require(!balanceLocked[_from] );
337 
338         return super.transferFrom(_from, _to, _value);
339     }
340 
341     function transfer(address _to, uint256 _value) public returns (bool) {
342         require(transferEnabled);
343         require(!balanceLocked[msg.sender] );
344         
345         return super.transfer(_to, _value);
346     }    
347   
348     function lock ( address[] _addr ) onlyOwner external  {
349         for (uint i = 0; i < _addr.length; i++) {
350           balanceLocked[_addr[i]] =  true;  
351         }
352     }
353     
354    
355     function unlock ( address[] _addr ) onlyOwner external  {
356         for (uint i = 0; i < _addr.length; i++) {
357           balanceLocked[_addr[i]] =  false;  
358         }
359     }
360  
361         
362 }