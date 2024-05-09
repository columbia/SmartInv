1 pragma solidity ^0.4.25;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12  
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28  
29 
30 }
31 
32 // File: contracts/math/SafeMath.sol
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     if (a == 0) {
45       return 0;
46     }
47     c = a * b;
48     assert(c / a == b);
49     return c;
50   }
51 
52   /**
53   * @dev Integer division of two numbers, truncating the quotient.
54   */
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     // uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return a / b;
60   }
61 
62   /**
63   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64   */
65   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 
70   /**
71   * @dev Adds two numbers, throws on overflow.
72   */
73   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 // File: contracts/token/ERC20/ERC20Basic.sol
81 
82 /**
83  * @title ERC20Basic
84  * @dev Simpler version of ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/179
86  */
87 contract ERC20Basic {
88   function totalSupply() public view returns (uint256);
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 // File: contracts/token/ERC20/BasicToken.sol
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   uint256 totalSupply_;
106 
107   /**
108   * @dev total number of tokens in existence
109   */
110   function totalSupply() public view returns (uint256) {
111     return totalSupply_;
112   }
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     emit Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 // File: contracts/token/ERC20/BurnableToken.sol
141 
142 /**
143  * @title Burnable Token
144  * @dev Token that can be irreversibly burned (destroyed).
145  */
146 contract BurnableToken is BasicToken {
147 
148   event Burn(address indexed burner, uint256 value);
149 
150   /**
151    * @dev Burns a specific amount of tokens.
152    * @param _value The amount of token to be burned.
153    */
154   function burn(uint256 _value) public {
155     _burn(msg.sender, _value);
156   }
157 
158   function _burn(address _who, uint256 _value) internal {
159     require(_value <= balances[_who]);
160     // no need to require value <= totalSupply, since that would imply the
161     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
162 
163     balances[_who] = balances[_who].sub(_value);
164     totalSupply_ = totalSupply_.sub(_value);
165     emit Burn(_who, _value);
166     emit Transfer(_who, address(0), _value);
167   }
168 }
169 
170 // File: contracts/token/ERC20/ERC20.sol
171 
172 /**
173  * @title ERC20 interface
174  * @dev see https://github.com/ethereum/EIPs/issues/20
175  */
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender) public view returns (uint256);
178   function transferFrom(address from, address to, uint256 value) public returns (bool);
179   function approve(address spender, uint256 value) public returns (bool);
180   event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 // File: contracts/token/ERC20/StandardToken.sol
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value <= allowed[_from][msg.sender]);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     emit Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     emit Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public view returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To increment
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _addedValue The amount of tokens to increase the allowance by.
250    */
251   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
252     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To decrement
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _subtractedValue The amount of tokens to decrease the allowance by.
266    */
267   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
268     uint oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279  
280 contract HyperBolicToken is StandardToken, BurnableToken, Ownable {
281     // Constants
282     string  public constant name = "HyperBolic";
283     string  public constant symbol = "HBC";
284     uint8   public constant decimals = 18;
285     uint256 public constant INITIAL_SUPPLY      = 500000000 * (10 ** uint256(decimals));
286 
287     mapping(address => bool) public balanceLocked;   
288     
289     
290     uint public amountRaised;
291     uint256 public buyPrice = 120000;
292     bool public crowdsaleClosed = false;
293     bool public transferEnabled = false;
294 
295 
296     constructor() public {
297       totalSupply_ = INITIAL_SUPPLY;
298       balances[msg.sender] = INITIAL_SUPPLY;
299       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
300     }
301  
302 
303     function _transfer(address _from, address _to, uint _value) internal {     
304         require (balances[_from] >= _value);               // Check if the sender has enough
305         require (balances[_to] + _value > balances[_to]); // Check for overflows
306    
307         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
308         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
309  
310         emit Transfer(_from, _to, _value);
311     }
312 
313     function setPrice( uint256 newBuyPrice) onlyOwner public {
314         buyPrice = newBuyPrice;
315     }
316 
317     function closeBuy(bool closebuy) onlyOwner public {
318         crowdsaleClosed = closebuy;
319     }
320 
321     function () external payable {
322         require(!crowdsaleClosed);
323         uint amount = msg.value ;               // calculates the amount
324         amountRaised = amountRaised.add(amount);
325         _transfer(owner, msg.sender, amount.mul(buyPrice)); 
326         owner.transfer(amount);
327     }
328  
329     function enableTransfer(bool _enable) onlyOwner external {
330         transferEnabled = _enable;
331     }
332 
333     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
334         require(transferEnabled);
335         require(!balanceLocked[_from] );
336 
337         return super.transferFrom(_from, _to, _value);
338     }
339 
340     function transfer(address _to, uint256 _value) public returns (bool) {
341         require(transferEnabled);
342         require(!balanceLocked[msg.sender] );
343         
344         return super.transfer(_to, _value);
345     }    
346   
347     function lock ( address[] _addr ) onlyOwner external  {
348         for (uint i = 0; i < _addr.length; i++) {
349           balanceLocked[_addr[i]] =  true;  
350         }
351     }
352     
353    
354     function unlock ( address[] _addr ) onlyOwner external  {
355         for (uint i = 0; i < _addr.length; i++) {
356           balanceLocked[_addr[i]] =  false;  
357         }
358     }
359  
360         
361 }