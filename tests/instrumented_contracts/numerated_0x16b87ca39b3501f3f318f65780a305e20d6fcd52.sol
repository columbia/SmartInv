1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath 
9 {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14 
15   function mul(uint256 a, uint256 b) internal pure returns(uint256 c) 
16   {
17      if (a == 0) 
18      {
19      	return 0;
20      }
21      c = a * b;
22      assert(c / a == b);
23      return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29 
30   function div(uint256 a, uint256 b) internal pure returns(uint256) 
31   {
32      return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38 
39   function sub(uint256 a, uint256 b) internal pure returns(uint256) 
40   {
41      assert(b <= a);
42      return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48 
49   function add(uint256 a, uint256 b) internal pure returns(uint256 c) 
50   {
51      c = a + b;
52      assert(c >= a);
53      return c;
54   }
55 }
56 
57 contract ERC20Interface
58 {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address _who) public view returns (uint256);
61     function transfer(address _to, uint256 _value) public returns (bool);
62     function allowance(address _owner, address _spender) public view returns (uint256);
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
64     function approve(address _spender, uint256 _value) public returns (bool);
65 
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68 }
69 
70 /**
71  * @title Basic token
72  */
73 
74 contract LAAR is ERC20Interface
75 {
76     using SafeMath for uint256;
77    
78     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
79     string public constant name            = "LaariCoin";
80     string public constant symbol          = "LAAR";
81     uint256 public totalTokenSupply        = 42000000 * TOKEN_DECIMALS;
82     uint256 public totalSaleSupply         = 21000000 * TOKEN_DECIMALS;
83     uint256 public totalReserveSupply      = 21000000 * TOKEN_DECIMALS;
84 
85     uint8 public constant decimals         = 18;
86     address public owner;
87     uint256 public totalBurned;
88     bool public stopped = false;
89 
90     event Burn(address indexed _burner, uint256 _value);
91     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
92 
93     struct ClaimLimit 
94     {
95        uint256 time_limit_epoch;
96        bool    limitSet;
97     }
98 
99     /** mappings **/ 
100     mapping(address => ClaimLimit) public claimLimits;
101     mapping(address => uint256) public  balances;
102     mapping(address => mapping(address => uint256)) internal  allowed;
103  
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107 
108     modifier onlyOwner() 
109     {
110        require(msg.sender == owner);
111        _;
112     }
113     
114     /** constructor **/
115 
116     constructor() public
117     {
118        owner = msg.sender;
119        balances[address(this)] = totalSaleSupply;
120 
121        emit Transfer(address(0x0), address(this), balances[address(this)]);
122     }
123 
124 
125     /**
126      * @dev To pause CrowdSale
127      */
128 
129     function pauseCrowdSale() external onlyOwner
130     {
131         stopped = true;
132     }
133 
134     /**
135      * @dev To resume CrowdSale
136      */
137 
138     function resumeCrowdSale() external onlyOwner
139     {
140         stopped = false;
141     }
142 
143     /**
144      * @dev    initialize reserveWallet to store LAAR reserve tokens for future use
145      * @param  _reserveWallet  Address of reserve Wallet 
146      */
147 
148     function initReserveWallet(address _reserveWallet) onlyOwner public 
149     {
150        require(!stopped);
151        require( _reserveWallet != address(0x0)); 
152 
153        balances[_reserveWallet] = totalReserveSupply;
154 
155        emit Transfer(address(0x0), _reserveWallet, balances[_reserveWallet]);
156     }
157 
158     /**
159      * @dev Burn specified number of LAAR tokens
160      * @param _value The amount of tokens to be burned
161      */
162 
163      function burn(uint256 _value) onlyOwner public returns (bool) 
164      {
165         require(!stopped);
166         require(_value <= balances[msg.sender]);
167 
168         address burner = msg.sender;
169 
170         balances[burner] = balances[burner].sub(_value);
171         totalTokenSupply = totalTokenSupply.sub(_value);
172         totalBurned      = totalBurned.add(_value);
173 
174         emit Burn(burner, _value);
175         emit Transfer(burner, address(0x0), _value);
176         return true;
177      }     
178 
179      /**
180       * @dev total number of tokens in existence
181       * @return An uint256 representing the total number of tokens in existence
182       */
183 
184      function totalSupply() public view returns(uint256 _totalSupply) 
185      {
186         _totalSupply = totalTokenSupply;
187         return _totalSupply;
188      }
189 
190     /**
191      * @dev Gets the balance of the specified address
192      * @param _owner The address to query the the balance of
193      * @return An uint256 representing the amount owned by the passed address
194      */
195 
196     function balanceOf(address _owner) public view returns (uint256) 
197     {
198        return balances[_owner];
199     }
200 
201     /**
202      * @dev Transfer tokens from one address to another
203      * @param _from address The address which you want to send tokens from
204      * @param _to address The address which you want to transfer to
205      * @param _value uint256 the amout of tokens to be transfered
206      */
207 
208     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
209     {
210        require(!stopped);
211 
212        if (_value == 0) 
213        {
214            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
215            return true;
216        }
217 
218        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
219        require(_to != address(0x0));
220        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
221 
222        balances[_from] = balances[_from].sub(_value);
223        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224        balances[_to] = balances[_to].add(_value);
225 
226        emit Transfer(_from, _to, _value);
227        return true;
228     }
229 
230     /**
231      * @dev transfer tokens from smart contract to another account, only by owner
232      * @param _address The address to transfer to
233      * @param _tokens The amount to be transferred
234      */
235 
236     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
237     {
238        require( _address != address(0x0)); 
239        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
240 
241        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
242        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
243 
244        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
245        return true;
246     }
247 
248     /**
249      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
250      *
251      * Beware that changing an allowance with this method brings the risk that someone may use both the old
252      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      * @param _spender The address which will spend the funds
256      * @param _tokens The amount of tokens to be spent
257      */
258 
259     function approve(address _spender, uint256 _tokens) public returns(bool)
260     {
261        require(!stopped);
262        require(_spender != address(0x0));
263 
264        allowed[msg.sender][_spender] = _tokens;
265 
266        emit Approval(msg.sender, _spender, _tokens);
267        return true;
268     }
269 
270     /**
271      * @dev Function to check the amount of tokens that an owner allowed to a spender
272      * @param _owner address The address which owns the funds
273      * @param _spender address The address which will spend the funds
274      * @return A uint256 specifing the amount of tokens still avaible for the spender
275      */
276 
277     function allowance(address _owner, address _spender) public view returns(uint256)
278     {
279        require(!stopped);
280        require(_owner != address(0x0) && _spender != address(0x0));
281 
282        return allowed[_owner][_spender];
283     }
284 
285     /**
286      * @dev transfer token for a specified address
287      * @param _address The address to transfer to
288      * @param _tokens The amount to be transferred
289      */
290 
291     function transfer(address _address, uint256 _tokens) public returns(bool)
292     {
293        require(!stopped);
294 
295        if (_tokens == 0) 
296        {
297            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
298            return true;
299        }
300 
301        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
302        require(_address != address(0x0));
303        require(balances[msg.sender] >= _tokens);
304 
305        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
306        balances[_address] = (balances[_address]).add(_tokens);
307 
308        emit Transfer(msg.sender, _address, _tokens);
309        return true;
310     }
311 
312     /**
313      * @dev transfer ownership of this contract, only by owner
314      * @param _newOwner The address of the new owner to transfer ownership
315      */
316 
317     function transferOwnership(address _newOwner)public onlyOwner
318     {
319        require(!stopped);
320        require( _newOwner != address(0x0));
321 
322        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
323        balances[owner] = 0;
324        owner = _newOwner;
325 
326        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
327    }
328 
329    /**
330     * @dev Increase the amount of tokens that an owner allowed to a spender
331     * approve should be called when allowed[_spender] == 0. To increment
332     * allowed value is better to use this function to avoid 2 calls (and wait until
333     * the first transaction is mined)
334     * From MonolithDAO Token.sol
335     * @param _spender The address which will spend the funds
336     * @param _addedValue The amount of tokens to increase the allowance by
337     */
338 
339    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
340    {
341       require(!stopped);
342 
343       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
344 
345       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346       return true;
347    }
348 
349    /**
350     * @dev Decrease the amount of tokens that an owner allowed to a spender
351     * approve should be called when allowed[_spender] == 0. To decrement
352     * allowed value is better to use this function to avoid 2 calls (and wait until
353     * the first transaction is mined)
354     * From MonolithDAO Token.sol
355     * @param _spender The address which will spend the funds
356     * @param _subtractedValue The amount of tokens to decrease the allowance by
357     */
358 
359    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) 
360    {
361       uint256 oldValue = allowed[msg.sender][_spender];
362 
363       require(!stopped);
364 
365       if (_subtractedValue > oldValue) 
366       {
367          allowed[msg.sender][_spender] = 0;
368       }
369       else 
370       {
371          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
372       }
373 
374       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
375       return true;
376    }
377 
378    /**
379     * @dev Transfer tokens to another account, time limit apply
380     */
381 
382    function claim(address _recipient) public
383    {
384       require(_recipient != address(0x0), "Invalid recipient");
385       require(msg.sender != _recipient, "Self transfer");
386       require(claimLimits[msg.sender].limitSet, "Limit not set");
387 
388       require (now > claimLimits[msg.sender].time_limit_epoch, "Time limit");
389        
390       uint256 tokens = balances[msg.sender];
391        
392       balances[msg.sender] = (balances[msg.sender]).sub(tokens);
393       balances[_recipient] = (balances[_recipient]).add(tokens);
394        
395       emit Transfer(msg.sender, _recipient, tokens);
396    }
397  
398    /**
399     * @dev Set limit on a claim per address
400     */
401 
402    function setClaimLimit(address _address, uint256 _days) public onlyOwner
403    {
404       require(balances[_address] > 0, "No tokens");
405 
406       claimLimits[_address].time_limit_epoch = (now + ((_days).mul(1 days)));
407    		
408       claimLimits[_address].limitSet = true;
409    }
410 
411    /**
412     * @dev reset limit on address
413     */
414 
415    function resetClaimLimit(address _address) public onlyOwner
416    {
417       claimLimits[_address].limitSet = false;
418    }
419 
420 }