1 pragma solidity ^0.4.24;
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
18     owner = 0x3df7390eA4f9D7Ca5A7f30ab52d18FD4F247bf44;
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
140 
141 // File: contracts/token/ERC20/ERC20.sol
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: contracts/token/ERC20/StandardToken.sol
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     // To change the approve amount you first have to reduce the addresses`
198     //  allowance to zero by calling `approve(_spender, 0)` if it is not
199     //  already 0 to mitigate the race condition described here:
200     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
202 
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * @dev Increase the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To increment
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _addedValue The amount of tokens to increase the allowance by.
227    */
228   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
245     uint oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 contract GSTT is StandardToken,  Ownable {
258     // Constants
259     string  public constant name = "Great International standard Token";
260     string  public constant symbol = "GSTT";
261     uint8   public constant decimals = 18;
262     uint256 public constant INITIAL_SUPPLY      = 1000000000 * (10 ** uint256(decimals));
263     uint256 public constant D      = 10 ** uint256(decimals);
264  
265     address constant holder = 0x3df7390eA4f9D7Ca5A7f30ab52d18FD4F247bf44;
266 
267     mapping(address => uint256) public balanceLocked;   
268    
269 
270     bool public transferEnabled = true;
271 
272     constructor() public {
273       totalSupply_ = INITIAL_SUPPLY;
274       balances[holder] = INITIAL_SUPPLY;
275       emit Transfer(0x0, holder, INITIAL_SUPPLY);
276     }
277  
278 
279 
280     function () external payable {
281         revert();
282     }
283  
284  
285     function enableTransfer(bool _enable) onlyOwner external {
286         transferEnabled = _enable;
287     }
288 
289     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
290         require(transferEnabled);
291         require((balances[_from] - _value) >= balanceLocked[_from]);
292 
293         return super.transferFrom(_from, _to, _value);
294     }
295 
296     function transfer(address _to, uint256 _value) public returns (bool) {
297         require(transferEnabled);
298         require((balances[msg.sender] - _value) >= balanceLocked[msg.sender]);
299         
300         return super.transfer(_to, _value);
301     }    
302   
303  
304     function lock ( address[] _addr ) onlyOwner external  {
305         for (uint i = 0; i < _addr.length; i++) {
306           balanceLocked[_addr[i]] =  balances[_addr[i]];  
307         }
308     }
309 
310   
311     function lockEx ( address[] _addr , uint256[] _value) onlyOwner external  {
312         for (uint i = 0; i < _addr.length; i++) {
313           balanceLocked[_addr[i]] = _value[i] * D;
314         }
315     }
316     
317   
318     function unlock ( address[] _addr ) onlyOwner external  {
319         for (uint i = 0; i < _addr.length; i++) {
320           balanceLocked[_addr[i]] =  0;  
321         }
322     }
323  
324  
325     function unlockEx ( address[] _addr , uint256[] _value ) onlyOwner external  {
326         for (uint i = 0; i < _addr.length; i++) {
327           uint256 v = (_value[i] * D) > balanceLocked[_addr[i]] ? balanceLocked[_addr[i]] : (_value[i] * D);
328           balanceLocked[_addr[i]] -= v;  
329         }
330     }
331         
332  
333    function getFreeBalances( address _addr ) public view returns(uint)  {
334       return balances[_addr] - balanceLocked[_addr];      
335    }
336 
337    function mint(address _to, uint256 _am) onlyOwner public returns (bool) {
338       uint256 _amount = _am * (10 ** uint256(decimals)) ;
339       totalSupply_ = totalSupply_.add(_amount);
340       balances[_to] = balances[_to].add(_amount);
341       
342       emit Transfer(address(0), _to, _amount);
343       return true;
344   }
345 
346   function burn(address _who, uint256 _value) onlyOwner public  {
347     require(_value <= balances[_who]);
348     // no need to require value <= totalSupply, since that would imply the
349     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
350 
351     balances[_who] = balances[_who].sub(_value);
352     totalSupply_ = totalSupply_.sub(_value);
353     emit Transfer(_who, address(0), _value);
354   }
355 
356 }