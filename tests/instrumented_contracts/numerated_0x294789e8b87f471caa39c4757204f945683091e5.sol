1 pragma solidity ^0.4.21;
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
13   
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31  
32 
33 }
34 
35 // File: contracts/math/SafeMath.sol
36 
37 /**
38  * @title SafeMath
39  * @dev Math operations with safety checks that throw on error
40  */
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, throws on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     if (a == 0) {
48       return 0;
49     }
50     c = a * b;
51     assert(c / a == b);
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers, truncating the quotient.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     // assert(b > 0); // Solidity automatically throws when dividing by 0
60     // uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62     return a / b;
63   }
64 
65   /**
66   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
67   */
68   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   /**
74   * @dev Adds two numbers, throws on overflow.
75   */
76   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
77     c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 // File: contracts/token/ERC20/ERC20Basic.sol
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   function totalSupply() public view returns (uint256);
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 // File: contracts/token/ERC20/BasicToken.sol
98 
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is ERC20Basic {
104   using SafeMath for uint256;
105 
106   mapping(address => uint256) balances;
107 
108   uint256 totalSupply_;
109 
110   /**
111   * @dev total number of tokens in existence
112   */
113   function totalSupply() public view returns (uint256) {
114     return totalSupply_;
115   }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125 
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     emit Transfer(msg.sender, _to, _value);
129     return true;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 // File: contracts/token/ERC20/BurnableToken.sol
144 
145 /**
146  * @title Burnable Token
147  * @dev Token that can be irreversibly burned (destroyed).
148  */
149 contract BurnableToken is BasicToken {
150 
151   event Burn(address indexed burner, uint256 value);
152 
153   /**
154    * @dev Burns a specific amount of tokens.
155    * @param _value The amount of token to be burned.
156    */
157   function burn(uint256 _value) public {
158     _burn(msg.sender, _value);
159   }
160 
161   function _burn(address _who, uint256 _value) internal {
162     require(_value <= balances[_who]);
163     // no need to require value <= totalSupply, since that would imply the
164     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
165 
166     balances[_who] = balances[_who].sub(_value);
167     totalSupply_ = totalSupply_.sub(_value);
168     emit Burn(_who, _value);
169     emit Transfer(_who, address(0), _value);
170   }
171 }
172 
173 // File: contracts/token/ERC20/ERC20.sol
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender) public view returns (uint256);
181   function transferFrom(address from, address to, uint256 value) public returns (bool);
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 // File: contracts/token/ERC20/StandardToken.sol
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     emit Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(address _owner, address _spender) public view returns (uint256) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
255     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Decrease the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282  
283 contract AMFC is StandardToken, BurnableToken, Ownable {
284     // Constants
285     string  public constant name = "Anything Macgic Fans";
286     string  public constant symbol = "AMFC";
287     uint8   public constant decimals = 18;
288     uint256 public constant INITIAL_SUPPLY      = 500000000 * (10 ** uint256(decimals));
289 
290     address constant LOCK_ADDR = 0xF63Fb7657B11B408eEdD263fE0753E1665E7400a;
291     uint256 constant LOCK_SUPPLY    = 300000000 * (10 ** uint256(decimals));  
292     uint256 constant UNLOCK_2Y    =   200000000 * (10 ** uint256(decimals)); 
293     uint256 constant UNLOCK_1Y    =   100000000 * (10 ** uint256(decimals)); 
294 
295     uint256 constant OWNER_SUPPLY      = INITIAL_SUPPLY - LOCK_SUPPLY;
296 
297     mapping(address => uint256)  balanceLocked;   //地址 - 锁定代币数量
298     mapping(address => uint256)  lockAtTime;      //地址 - 锁定起始时间点
299     
300   
301     uint256 public buyPrice = 585;
302     bool public crowdsaleClosed;
303     bool public transferEnabled = true;
304 
305 
306     constructor() public {
307       totalSupply_ = INITIAL_SUPPLY;
308 
309       balances[msg.sender] = OWNER_SUPPLY;
310       emit Transfer(0x0, msg.sender, OWNER_SUPPLY);
311 
312       balances[LOCK_ADDR] = LOCK_SUPPLY;
313       emit Transfer(0x0, LOCK_ADDR, LOCK_SUPPLY);
314 
315       _lock(LOCK_ADDR);
316     }
317 
318     function _lock(address _owner) internal {
319         balanceLocked[_owner] =  balances[_owner];  
320         lockAtTime[_owner] = now;
321     }
322 
323     function _transfer(address _from, address _to, uint _value) internal {     
324         require (balances[_from] >= _value);               // Check if the sender has enough
325         require (balances[_to] + _value > balances[_to]); // Check for overflows
326    
327         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
328         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
329 
330         emit Transfer(_from, _to, _value);
331     }
332 
333     function setPrices(bool closebuy, uint256 newBuyPrice) onlyOwner public {
334         crowdsaleClosed = closebuy;
335         buyPrice = newBuyPrice;
336     }
337 
338     function () external payable {
339         require(!crowdsaleClosed);
340         uint amount = msg.value ;               // calculates the amount
341  
342         _transfer(owner, msg.sender, amount.mul(buyPrice)); 
343         owner.transfer(amount);
344     }
345 
346     //取回eth, 参数设为0 则全部取回, 否则取回指定数量的eth
347     function safeWithdrawal(uint _value ) onlyOwner public {
348        if (_value == 0) 
349            owner.transfer(address(this).balance);
350        else
351            owner.transfer(_value);
352     }
353 
354  
355     function enableTransfer(bool _enable) onlyOwner external {
356         transferEnabled = _enable;
357     }
358 
359     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
360         require(transferEnabled);
361         require(checkLocked(_from, _value));
362 
363         return super.transferFrom(_from, _to, _value);
364     }
365 
366     function transfer(address _to, uint256 _value) public returns (bool) {
367         require(transferEnabled);
368         require(checkLocked(msg.sender, _value));
369         
370         return super.transfer(_to, _value);
371     }    
372   
373     // 传入要锁定的地址, 锁定数量为地址当前拥有的数量
374     //流程:
375     //ICO 完成后,  调用此函数设置锁定地址, 然后调用 enableTransfer 函数允许转token
376     function lockAddress( address[] _addr ) onlyOwner external  {
377         for (uint i = 0; i < _addr.length; i++) {
378           _lock(_addr[i]);
379         }
380     }
381     
382     // 解锁地址
383     function unlockAddress( address[] _addr ) onlyOwner external  {
384         for (uint i = 0; i < _addr.length; i++) {
385           balanceLocked[_addr[i]] =  0;  
386         }
387     }
388  
389 
390    function checkLocked(address _addr, uint256 _value) internal view returns (bool) {
391       if (balanceLocked[_addr] > 0) {   //address is locked
392          if (now > lockAtTime[_addr] + 3 years) {  
393              return true;
394          } else if (now > lockAtTime[_addr] + 2 years)   {
395              return (balances[_addr] - _value >= UNLOCK_1Y);
396          } else if (now > lockAtTime[_addr] + 1 years)   {
397              return (balances[_addr] - _value >= UNLOCK_2Y);    
398          }  else {
399              return false;   
400          }  
401       }
402      
403       return true;
404    } 
405         
406 }