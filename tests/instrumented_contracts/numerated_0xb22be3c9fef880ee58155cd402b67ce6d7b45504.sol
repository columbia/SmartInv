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
57 /**
58  *Main contract
59  */
60 
61 contract ERC20Interface
62 {
63     function totalSupply() public view returns (uint256);
64     function balanceOf(address _who) public view returns (uint256);
65     function transfer(address _to, uint256 _value) public returns (bool);
66     function allowance(address _owner, address _spender) public view returns (uint256);
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
68     function approve(address _spender, uint256 _value) public returns (bool);
69 
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71     event Transfer(address indexed _from, address indexed _to, uint256 _value);
72 }
73 
74 /**
75  * @title Basic token
76  */
77 
78 contract DXG is ERC20Interface
79 {
80     using SafeMath for uint256;
81    
82     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
83     string public constant name            = "Dexage";
84     string public constant symbol          = "DXG";
85     uint256 public totalTokenSupply        = 5000000000 * TOKEN_DECIMALS;
86 
87     uint8 public constant decimals         = 18;
88     address public owner;
89     uint256 public totalBurned;
90     bool stopped = false;
91 
92     event Burn(address indexed _burner, uint256 _value);
93     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
94 
95     struct ClaimLimit 
96     {
97        uint256 time_limit_epoch;
98        bool    limitSet;
99     }
100     /** mappings **/ 
101     mapping(address => ClaimLimit) claimLimits;
102     mapping(address => uint256) public  balances;
103     mapping(address => mapping(address => uint256)) internal  allowed;
104  
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108 
109     modifier onlyOwner() 
110     {
111        require(msg.sender == owner);
112        _;
113     }
114     
115     /** constructor **/
116 
117     constructor() public
118     {
119        owner = msg.sender;
120        balances[address(this)] = totalTokenSupply;
121 
122        emit Transfer(address(0x0), address(this), balances[address(this)]);
123     }
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
144      * @dev Burn specified number of DXG tokens
145      * @param _value The amount of tokens to be burned
146      */
147 
148      function burn(uint256 _value) onlyOwner public returns (bool) 
149      {
150         require(!stopped);
151         require(_value <= balances[msg.sender]);
152 
153         address burner = msg.sender;
154 
155         balances[burner] = balances[burner].sub(_value);
156         totalTokenSupply = totalTokenSupply.sub(_value);
157         totalBurned      = totalBurned.add(_value);
158 
159         emit Burn(burner, _value);
160         emit Transfer(burner, address(0x0), _value);
161         return true;
162      }     
163 
164      /**
165       * @dev total number of tokens in existence
166       * @return An uint256 representing the total number of tokens in existence
167       */
168 
169      function totalSupply() public view returns(uint256 _totalSupply) 
170      {
171         _totalSupply = totalTokenSupply;
172         return _totalSupply;
173      }
174 
175     /**
176      * @dev Gets the balance of the specified address
177      * @param _owner The address to query the the balance of
178      * @return An uint256 representing the amount owned by the passed address
179      */
180 
181     function balanceOf(address _owner) public view returns (uint256) 
182     {
183        return balances[_owner];
184     }
185 
186     /**
187      * @dev Transfer tokens from one address to another
188      * @param _from address The address which you want to send tokens from
189      * @param _to address The address which you want to transfer to
190      * @param _value uint256 the amout of tokens to be transfered
191      */
192 
193     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
194     {
195        require(!stopped);
196 
197        if (_value == 0) 
198        {
199            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
200            return true;
201        }
202 
203        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
204        require(_to != address(0x0));
205        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
206 
207        balances[_from] = balances[_from].sub(_value);
208        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209        balances[_to] = balances[_to].add(_value);
210 
211        emit Transfer(_from, _to, _value);
212        return true;
213     }
214 
215     /**
216      * @dev transfer tokens from smart contract to another account, only by owner
217      * @param _address The address to transfer to
218      * @param _tokens The amount to be transferred
219      */
220 
221     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
222     {
223        require( _address != address(0x0)); 
224        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
225 
226        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
227        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
228 
229        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
230        return true;
231     }
232 
233     /**
234      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
235      *
236      * Beware that changing an allowance with this method brings the risk that someone may use both the old
237      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      * @param _spender The address which will spend the funds
241      * @param _tokens The amount of tokens to be spent
242      */
243 
244     function approve(address _spender, uint256 _tokens) public returns(bool)
245     {
246        require(!stopped);
247        require(_spender != address(0x0));
248 
249        allowed[msg.sender][_spender] = _tokens;
250 
251        emit Approval(msg.sender, _spender, _tokens);
252        return true;
253     }
254 
255     /**
256      * @dev Function to check the amount of tokens that an owner allowed to a spender
257      * @param _owner address The address which owns the funds
258      * @param _spender address The address which will spend the funds
259      * @return A uint256 specifing the amount of tokens still avaible for the spender
260      */
261 
262     function allowance(address _owner, address _spender) public view returns(uint256)
263     {
264        require(!stopped);
265        require(_owner != address(0x0) && _spender != address(0x0));
266 
267        return allowed[_owner][_spender];
268     }
269 
270     /**
271      * @dev transfer token for a specified address
272      * @param _address The address to transfer to
273      * @param _tokens The amount to be transferred
274      */
275 
276     function transfer(address _address, uint256 _tokens) public returns(bool)
277     {
278        require(!stopped);
279 
280        if (_tokens == 0) 
281        {
282            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
283            return true;
284        }
285 
286        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
287        require(_address != address(0x0));
288        require(balances[msg.sender] >= _tokens);
289 
290        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
291        balances[_address] = (balances[_address]).add(_tokens);
292 
293        emit Transfer(msg.sender, _address, _tokens);
294        return true;
295     }
296 
297     /**
298      * @dev transfer ownership of this contract, only by owner
299      * @param _newOwner The address of the new owner to transfer ownership
300      */
301 
302     function transferOwnership(address _newOwner)public onlyOwner
303     {
304        require(!stopped);
305        require( _newOwner != address(0x0));
306 
307        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
308        balances[owner] = 0;
309        owner = _newOwner;
310 
311        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
312    }
313 
314    /**
315     * @dev Increase the amount of tokens that an owner allowed to a spender
316     * approve should be called when allowed[_spender] == 0. To increment
317     * allowed value is better to use this function to avoid 2 calls (and wait until
318     * the first transaction is mined)
319     * From MonolithDAO Token.sol
320     * @param _spender The address which will spend the funds
321     * @param _addedValue The amount of tokens to increase the allowance by
322     */
323 
324    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
325    {
326       require(!stopped);
327 
328       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
329 
330       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331       return true;
332    }
333 
334    /**
335     * @dev Decrease the amount of tokens that an owner allowed to a spender
336     * approve should be called when allowed[_spender] == 0. To decrement
337     * allowed value is better to use this function to avoid 2 calls (and wait until
338     * the first transaction is mined)
339     * From MonolithDAO Token.sol
340     * @param _spender The address which will spend the funds
341     * @param _subtractedValue The amount of tokens to decrease the allowance by
342     */
343 
344    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) 
345    {
346       uint256 oldValue = allowed[msg.sender][_spender];
347 
348       require(!stopped);
349 
350       if (_subtractedValue > oldValue) 
351       {
352          allowed[msg.sender][_spender] = 0;
353       }
354       else 
355       {
356          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
357       }
358 
359       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360       return true;
361    }
362 
363    /**
364     * @dev Transfer tokens to another account, time limit apply
365     */
366 
367    function claim(address _recipient) public
368    {
369       require(_recipient != address(0x0), "Invalid recipient");
370       require(msg.sender != _recipient, "Self transfer");
371       require(claimLimits[msg.sender].limitSet, "Limit not set");
372 
373       require (now > claimLimits[msg.sender].time_limit_epoch, "Time limit");
374        
375       uint256 tokens = balances[msg.sender];
376        
377       balances[msg.sender] = (balances[msg.sender]).sub(tokens);
378       balances[_recipient] = (balances[_recipient]).add(tokens);
379        
380       emit Transfer(msg.sender, _recipient, tokens);
381    }
382  
383    /**
384     * @dev Set limit on a claim per address
385     */
386 
387    function setClaimLimit(address _address, uint256 _days) public onlyOwner
388    {
389       require(balances[_address] > 0, "No tokens");
390 
391       claimLimits[_address].time_limit_epoch = (now + ((_days).mul(1 days)));
392    		
393       claimLimits[_address].limitSet = true;
394    }
395 
396 }