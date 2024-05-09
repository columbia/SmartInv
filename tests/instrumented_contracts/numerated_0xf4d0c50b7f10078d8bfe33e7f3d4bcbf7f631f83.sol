1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     
5   /**
6   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
7   */
8   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9     assert(b <= a);
10     return a - b;
11   }
12 
13   /**
14   * @dev Adds two numbers, throws on overflow.
15   */
16   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     c = a + b;
18     assert(c >= a);
19     return c;
20   }
21   
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 }
41 
42 contract ERC20Basic {
43   function totalSupply() public view returns (uint256);
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   uint256 totalSupply_;
59 
60   /**
61   * @dev total number of tokens in existence
62   */
63   function totalSupply() public view returns (uint256) {
64     return totalSupply_;
65   }
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender)
95     public view returns (uint256);
96 
97   function transferFrom(address from, address to, uint256 value)
98     public returns (bool);
99 
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) internal allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(
120     address _from,
121     address _to,
122     uint256 _value
123   )
124     public
125     returns (bool)
126   {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     emit Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     emit Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(
161     address _owner,
162     address _spender
163    )
164     public
165     view
166     returns (uint256)
167   {
168     return allowed[_owner][_spender];
169   }
170 
171   /**
172    * @dev Increase the amount of tokens that an owner allowed to a spender.
173    *
174    * approve should be called when allowed[_spender] == 0. To increment
175    * allowed value is better to use this function to avoid 2 calls (and wait until
176    * the first transaction is mined)
177    * From MonolithDAO Token.sol
178    * @param _spender The address which will spend the funds.
179    * @param _addedValue The amount of tokens to increase the allowance by.
180    */
181   function increaseApproval(
182     address _spender,
183     uint _addedValue
184   )
185     public
186     returns (bool)
187   {
188     allowed[msg.sender][_spender] = (
189       allowed[msg.sender][_spender].add(_addedValue));
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(
205     address _spender,
206     uint _subtractedValue
207   )
208     public
209     returns (bool)
210   {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 }
221 
222 /**
223  * @title Ownable
224  * @dev The Ownable contract has an owner address, and provides basic authorization control
225  * functions, this simplifies the implementation of "user permissions".
226  */
227 contract Ownable {
228   address public owner;
229 
230   event OwnershipRenounced(address indexed previousOwner);
231   event OwnershipTransferred(
232     address indexed previousOwner,
233     address indexed newOwner
234   );
235     
236    /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   constructor() public {
241     owner = msg.sender;
242   }
243   
244   /**
245    * @dev Throws if called by any account other than the owner.
246    */
247   modifier onlyOwner() {
248     require(msg.sender == owner);
249     _;
250   }
251 
252   /**
253    * @dev Allows the current owner to transfer control of the contract to a newOwner.
254    * @param newOwner The address to transfer ownership to.
255    */
256   function transferOwnership(address newOwner) public onlyOwner {
257     require(newOwner != address(0));
258     emit OwnershipTransferred(owner, newOwner);
259     owner = newOwner;
260   }
261 }
262 
263 contract Eurufly is StandardToken, Ownable{
264     string  public  constant name = "Eurufly";
265     string  public  constant symbol = "EUR";
266     uint8   public  constant decimals = 18;
267     uint256 public priceOfToken = 2500; // 1 ether = 2500 EUR
268   uint256 public icoStartAt ;
269   uint256 public icoEndAt ;
270   uint256 public preIcoStartAt ;
271   uint256 public preIcoEndAt ;
272   uint256 public prePreIcoStartAt;
273   uint256 public prePreIcoEndAt;
274   STATE public state = STATE.UNKNOWN;
275   address wallet ; // Where all ether is transfered
276   // Amount of wei raised
277   uint256 public weiRaised;
278   address public owner ;
279   enum STATE{UNKNOWN, PREPREICO, PREICO, POSTICO}
280 
281   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
282 
283   
284   function transfer(address _to, uint _value)  public returns (bool success) {
285     // Call StandardToken.transfer()
286    return super.transfer(_to, _value);
287   }
288 
289   function transferFrom(address _from, address _to, uint _value)  public returns (bool success) {
290     // Call StandardToken.transferForm()
291     return super.transferFrom(_from, _to, _value);
292   }
293 
294     // Start Pre Pre ICO
295     function startPrePreIco(uint256 x) public onlyOwner{
296         require(state == STATE.UNKNOWN);
297         prePreIcoStartAt = block.timestamp ;
298         prePreIcoEndAt = block.timestamp + x * 1 days ; // pre pre
299         state = STATE.PREPREICO;
300         
301     }
302     
303     // Start Pre ICO
304     function startPreIco(uint256 x) public onlyOwner{
305         require(state == STATE.PREPREICO);
306         preIcoStartAt = block.timestamp ;
307         preIcoEndAt = block.timestamp + x * 1 days ; // pre 
308         state = STATE.PREICO;
309         
310     }
311     
312     // Start POSTICO
313     function startPostIco(uint256 x) public onlyOwner{
314          require(state == STATE.PREICO);
315          icoStartAt = block.timestamp ;
316          icoEndAt = block.timestamp + x * 1 days;
317          state = STATE.POSTICO;
318           
319      }
320     
321   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
322     return _weiAmount.mul(priceOfToken);
323   }
324 
325  
326   function _forwardFunds() internal {
327      wallet.transfer(msg.value);
328   }
329   
330   function () external payable {
331     require(totalSupply_<= 10 ** 26);
332     require(state != STATE.UNKNOWN);
333     buyTokens(msg.sender);
334   }
335 
336   /**
337    * @dev low level token purchase ***DO NOT OVERRIDE***
338    * @param _beneficiary Address performing the token purchase
339    */
340   function buyTokens(address _beneficiary) public payable {
341     
342      require(_beneficiary != address(0x0));
343      if(state == STATE.PREPREICO){
344         require(now >= prePreIcoStartAt && now <= prePreIcoEndAt);
345         require(msg.value <= 10 ether);
346       }else if(state == STATE.PREICO){
347        require(now >= preIcoStartAt && now <= preIcoEndAt);
348        require(msg.value <= 15 ether);
349       }else if(state == STATE.POSTICO){
350         require(now >= icoStartAt && now <= icoEndAt);
351         require(msg.value <= 20 ether);
352       }
353       
354       uint256 weiAmount = msg.value;
355       uint256 tokens = _getTokenAmount(weiAmount);
356       
357       if(state == STATE.PREPREICO){                 // bonuses
358          tokens = tokens.add(tokens.mul(30).div(100));
359       }else if(state == STATE.PREICO){
360         tokens = tokens.add(tokens.mul(25).div(100));
361       }else if(state == STATE.POSTICO){
362         tokens = tokens.add(tokens.mul(20).div(100));
363       }
364      totalSupply_ = totalSupply_.add(tokens);
365      balances[msg.sender] = balances[msg.sender].add(tokens);
366      emit Transfer(address(0), msg.sender, tokens);
367     // update state
368      weiRaised = weiRaised.add(weiAmount);
369      emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
370      _forwardFunds();
371    }
372     
373     constructor(address ethWallet) public{
374         wallet = ethWallet;
375         owner = msg.sender;
376     }
377     
378     function emergencyERC20Drain(ERC20 token, uint amount) public onlyOwner {
379         // owner can drain tokens that are sent here by mistake
380         token.transfer( owner, amount );
381     }
382     
383     function allocate(address user, uint256 amount) public onlyOwner{
384        
385         require(totalSupply_.add(amount) <= 10 ** 26 );
386         uint256 tokens = amount * (10 ** 18);
387         totalSupply_ = totalSupply_.add(tokens);
388         balances[user] = balances[user].add(tokens);
389         emit Transfer(address(0), user , tokens);
390    
391     }
392 }