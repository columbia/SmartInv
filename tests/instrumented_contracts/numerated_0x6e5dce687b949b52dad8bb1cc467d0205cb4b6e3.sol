1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   uint256 totalSupply_;
126 
127   /**
128   * @dev total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[msg.sender]);
142 
143     // SafeMath.sub will throw if there is not enough balance.
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256 balance) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
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
230     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
251     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 
258 /**
259  * @title Burnable Token
260  * @dev Token that can be irreversibly burned (destroyed).
261  */
262 contract BurnableToken is BasicToken {
263 
264   event Burn(address indexed burner, uint256 value);
265 
266   /**
267    * @dev Burns a specific amount of tokens.
268    * @param _value The amount of token to be burned.     
269    */
270   function burn(uint256 _value) public {
271     require(_value <= balances[msg.sender]);
272     // no need to require value <= totalSupply, since that would imply the
273     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
274 
275     address burner = msg.sender;
276     balances[burner] = balances[burner].sub(_value);
277     totalSupply_ = totalSupply_.sub(_value);
278     Burn(burner, _value);
279     Transfer(burner, address(0), _value);
280   }
281 }
282  
283 /*
284  
285 
286 先发30%，3个月解锁30%，6个月解锁40% 
287 */
288 contract CAC is StandardToken, BurnableToken, Ownable {
289     // Constants
290     string  public constant name = "Candy Token";
291     string  public constant symbol = "CAC";
292     uint8   public constant decimals = 18;
293     uint256 public constant INITIAL_SUPPLY      = 50000000000 * (10 ** uint256(decimals));
294 
295     mapping(address => uint256) public balanceLocked;   //地址 - 锁定代币数量
296     mapping(address => uint256) public lockAtTime;      //地址 - 锁定起始时间点
297     
298     uint public amountRaised;
299     uint256 public buyPrice = 250000;
300     bool public crowdsaleClosed;
301     bool public transferEnabled = true;
302 
303 
304     function CAC() public {
305       totalSupply_ = INITIAL_SUPPLY;
306       balances[msg.sender] = INITIAL_SUPPLY;
307       Transfer(0x0, msg.sender, INITIAL_SUPPLY);
308     }
309 
310     function _lock(address _owner) internal {
311         balanceLocked[_owner] =  balances[_owner];  
312         lockAtTime[_owner] = now;
313     }
314 
315     function _transfer(address _from, address _to, uint _value) internal {     
316         require (balances[_from] >= _value);               // Check if the sender has enough
317         require (balances[_to] + _value > balances[_to]); // Check for overflows
318    
319         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
320         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
321          
322         _lock(_to);
323          
324         Transfer(_from, _to, _value);
325     }
326 
327     function setPrices(bool closebuy, uint256 newBuyPrice) onlyOwner public {
328         crowdsaleClosed = closebuy;
329         buyPrice = newBuyPrice;
330     }
331 
332     function () external payable {
333         require(!crowdsaleClosed);
334         uint amount = msg.value ;               // calculates the amount
335         amountRaised = amountRaised.add(amount);
336         _transfer(owner, msg.sender, amount.mul(buyPrice)); 
337     }
338 
339     //取回eth, 参数设为0 则全部取回, 否则取回指定数量的eth
340     function safeWithdrawal(uint _value ) onlyOwner public {
341        if (_value == 0) 
342            owner.transfer(address(this).balance);
343        else
344            owner.transfer(_value);
345     }
346 
347     /* Batch token transfer. Used by contract creator to distribute initial tokens to holders */
348     function batchTransfer(address[] _recipients, uint[] _values) onlyOwner public returns (bool) {
349         require( _recipients.length > 0 && _recipients.length == _values.length);
350 
351         uint total = 0;
352         for(uint i = 0; i < _values.length; i++){
353             total = total.add(_values[i]);
354         }
355         require(total <= balances[msg.sender]);
356 
357         for(uint j = 0; j < _recipients.length; j++){
358             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
359             Transfer(msg.sender, _recipients[j], _values[j]);
360         }
361 
362         balances[msg.sender] = balances[msg.sender].sub(total);
363         return true;
364     }
365 
366     function enableTransfer(bool _enable) onlyOwner external {
367         transferEnabled = _enable;
368     }
369 
370     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
371         require(transferEnabled);
372         require(checkLocked(_from, _value));
373 
374         return super.transferFrom(_from, _to, _value);
375     }
376 
377     function transfer(address _to, uint256 _value) public returns (bool) {
378         require(transferEnabled);
379         require(checkLocked(msg.sender, _value));
380         
381         return super.transfer(_to, _value);
382     }    
383      
384     //通过本函数发币, 不会被锁定 
385     function transferEx(address _to, uint256 _value) onlyOwner public returns (bool) {
386         return super.transfer(_to, _value);
387     }
388 
389     // 传入要锁定的地址, 锁定数量为地址当前拥有的数量
390     //流程:
391     //ICO 完成后,  调用此函数设置锁定地址, 然后调用 enableTransfer 函数允许转token
392     function lockAddress( address[] _addr ) onlyOwner external  {
393         for (uint i = 0; i < _addr.length; i++) {
394           _lock(_addr[i]);
395         }
396     }
397     
398     // 解锁地址
399     function unlockAddress( address[] _addr ) onlyOwner external  {
400         for (uint i = 0; i < _addr.length; i++) {
401           balanceLocked[_addr[i]] =  0;  
402         }
403     }
404 
405     // 传入地址, 返回当前可转币的数量
406    function getFreeBalances( address _addr ) public view returns(uint)  {
407       if (balanceLocked[_addr] > 0) {
408           if (now > lockAtTime[_addr] + 180 days) {
409               return balances[_addr];
410           } else if (now > lockAtTime[_addr]  + 90 days)   {
411               return balances[_addr] - balanceLocked[_addr] / 10 * 4;
412           } else {
413               return balances[_addr] - balanceLocked[_addr] / 10 * 7 ;
414           }  
415       }
416 
417       return balances[_addr];      
418    }
419 
420    function checkLocked(address _addr, uint256 _value) internal view returns (bool) {
421       if (balanceLocked[_addr] > 0) {   //address is locked
422          if (now > lockAtTime[_addr] + 180 days) {  
423              return true;
424          } else if (now > lockAtTime[_addr] + 90 days)   {
425              return (balances[_addr] - _value >= balanceLocked[_addr] / 10 * 4);
426          } else {
427              return (balances[_addr] - _value >= balanceLocked[_addr] / 10 * 7 );   
428          }  
429       }
430      
431       return true;
432    } 
433         
434 }