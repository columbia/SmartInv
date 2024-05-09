1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath 
5 {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10 
11   function mul(uint256 a, uint256 b) internal pure returns(uint256 c) 
12   {
13      if (a == 0) 
14      {
15      	return 0;
16      }
17      c = a * b;
18      assert(c / a == b);
19      return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25 
26   function div(uint256 a, uint256 b) internal pure returns(uint256) 
27   {
28      return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34 
35   function sub(uint256 a, uint256 b) internal pure returns(uint256) 
36   {
37      assert(b <= a);
38      return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44 
45   function add(uint256 a, uint256 b) internal pure returns(uint256 c) 
46   {
47      c = a + b;
48      assert(c >= a);
49      return c;
50   }
51 }
52 
53 
54 contract ERC20Interface
55 {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address _who) public view returns (uint256);
58     function transfer(address _to, uint256 _value) public returns (bool);
59     function allowance(address _owner, address _spender) public view returns (uint256);
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
61     function approve(address _spender, uint256 _value) public returns (bool);
62 
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65 }
66 
67 
68 contract NEXT is ERC20Interface
69 {
70     using SafeMath for uint256;
71    
72     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
73     string public constant name            = "Next Token";
74     string public constant symbol          = "NEXT";
75     uint256 public totalTokenSupply        = 10000000000 * TOKEN_DECIMALS;
76 
77     uint8 public constant decimals         = 18;
78     address public owner;
79     uint256 public totalBurned;
80     bool stopped = false;
81 
82     event Burn(address indexed _burner, uint256 _value);
83     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
84 
85     struct ClaimLimit 
86     {
87        uint256 time_limit_epoch;
88        bool    limitSet;
89     }
90     /** mappings **/ 
91     mapping(address => ClaimLimit) claimLimits;
92     mapping(address => uint256) public  balances;
93     mapping(address => mapping(address => uint256)) internal  allowed;
94  
95     /**
96      * @dev Throws if called by any account other than the owner.
97      */
98 
99     modifier onlyOwner() 
100     {
101        require(msg.sender == owner);
102        _;
103     }
104     
105     /** constructor **/
106 
107     constructor() public
108     {
109        owner = msg.sender;
110        balances[address(this)] = totalTokenSupply;
111 
112        emit Transfer(address(0x0), address(this), balances[address(this)]);
113     }
114 
115     /**
116      * @dev To pause CrowdSale
117      */
118 
119     function pauseCrowdSale() external onlyOwner
120     {
121         stopped = true;
122     }
123 
124     /**
125      * @dev To resume CrowdSale
126      */
127 
128     function resumeCrowdSale() external onlyOwner
129     {
130         stopped = false;
131     }
132 
133     /**
134      * @dev Burn specified number of DXG tokens
135      * @param _value The amount of tokens to be burned
136      */
137 
138      function burn(uint256 _value) onlyOwner public returns (bool) 
139      {
140         require(!stopped);
141         require(_value <= balances[msg.sender]);
142 
143         address burner = msg.sender;
144 
145         balances[burner] = balances[burner].sub(_value);
146         totalTokenSupply = totalTokenSupply.sub(_value);
147         totalBurned      = totalBurned.add(_value);
148 
149         emit Burn(burner, _value);
150         emit Transfer(burner, address(0x0), _value);
151         return true;
152      }     
153 
154      /**
155       * @dev total number of tokens in existence
156       * @return An uint256 representing the total number of tokens in existence
157       */
158 
159      function totalSupply() public view returns(uint256 _totalSupply) 
160      {
161         _totalSupply = totalTokenSupply;
162         return _totalSupply;
163      }
164 
165     /**
166      * @dev Gets the balance of the specified address
167      * @param _owner The address to query the the balance of
168      * @return An uint256 representing the amount owned by the passed address
169      */
170 
171     function balanceOf(address _owner) public view returns (uint256) 
172     {
173        return balances[_owner];
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amout of tokens to be transfered
181      */
182 
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
184     {
185        require(!stopped);
186 
187        if (_value == 0) 
188        {
189            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
190            return true;
191        }
192 
193        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
194        require(_to != address(0x0));
195        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
196 
197        balances[_from] = balances[_from].sub(_value);
198        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199        balances[_to] = balances[_to].add(_value);
200 
201        emit Transfer(_from, _to, _value);
202        return true;
203     }
204 
205     /**
206      * @dev transfer tokens from smart contract to another account, only by owner
207      * @param _address The address to transfer to
208      * @param _tokens The amount to be transferred
209      */
210 
211     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
212     {
213        require( _address != address(0x0)); 
214        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
215 
216        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
217        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
218 
219        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
220        return true;
221     }
222 
223     /**
224      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
225      *
226      * Beware that changing an allowance with this method brings the risk that someone may use both the old
227      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      * @param _spender The address which will spend the funds
231      * @param _tokens The amount of tokens to be spent
232      */
233 
234     function approve(address _spender, uint256 _tokens) public returns(bool)
235     {
236        require(!stopped);
237        require(_spender != address(0x0));
238 
239        allowed[msg.sender][_spender] = _tokens;
240 
241        emit Approval(msg.sender, _spender, _tokens);
242        return true;
243     }
244 
245     /**
246      * @dev Function to check the amount of tokens that an owner allowed to a spender
247      * @param _owner address The address which owns the funds
248      * @param _spender address The address which will spend the funds
249      * @return A uint256 specifing the amount of tokens still avaible for the spender
250      */
251 
252     function allowance(address _owner, address _spender) public view returns(uint256)
253     {
254        require(!stopped);
255        require(_owner != address(0x0) && _spender != address(0x0));
256 
257        return allowed[_owner][_spender];
258     }
259 
260     /**
261      * @dev transfer token for a specified address
262      * @param _address The address to transfer to
263      * @param _tokens The amount to be transferred
264      */
265 
266     function transfer(address _address, uint256 _tokens) public returns(bool)
267     {
268        require(!stopped);
269 
270        if (_tokens == 0) 
271        {
272            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
273            return true;
274        }
275 
276        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
277        require(_address != address(0x0));
278        require(balances[msg.sender] >= _tokens);
279 
280        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
281        balances[_address] = (balances[_address]).add(_tokens);
282 
283        emit Transfer(msg.sender, _address, _tokens);
284        return true;
285     }
286 
287     /**
288      * @dev transfer ownership of this contract, only by owner
289      * @param _newOwner The address of the new owner to transfer ownership
290      */
291 
292     function transferOwnership(address _newOwner)public onlyOwner
293     {
294        require(!stopped);
295        require( _newOwner != address(0x0));
296 
297        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
298        balances[owner] = 0;
299        owner = _newOwner;
300 
301        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
302    }
303 
304    /**
305     * @dev Increase the amount of tokens that an owner allowed to a spender
306     * approve should be called when allowed[_spender] == 0. To increment
307     * allowed value is better to use this function to avoid 2 calls (and wait until
308     * the first transaction is mined)
309     * From MonolithDAO Token.sol
310     * @param _spender The address which will spend the funds
311     * @param _addedValue The amount of tokens to increase the allowance by
312     */
313 
314    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
315    {
316       require(!stopped);
317 
318       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
319 
320       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
321       return true;
322    }
323 
324    /**
325     * @dev Decrease the amount of tokens that an owner allowed to a spender
326     * approve should be called when allowed[_spender] == 0. To decrement
327     * allowed value is better to use this function to avoid 2 calls (and wait until
328     * the first transaction is mined)
329     * From MonolithDAO Token.sol
330     * @param _spender The address which will spend the funds
331     * @param _subtractedValue The amount of tokens to decrease the allowance by
332     */
333 
334    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) 
335    {
336       uint256 oldValue = allowed[msg.sender][_spender];
337 
338       require(!stopped);
339 
340       if (_subtractedValue > oldValue) 
341       {
342          allowed[msg.sender][_spender] = 0;
343       }
344       else 
345       {
346          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
347       }
348 
349       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350       return true;
351    }
352 
353    /**
354     * @dev Transfer tokens to another account, time limit apply
355     */
356 
357    function claim(address _recipient) public
358    {
359       require(_recipient != address(0x0), "Invalid recipient");
360       require(msg.sender != _recipient, "Self transfer");
361       require(claimLimits[msg.sender].limitSet, "Limit not set");
362 
363       require (now > claimLimits[msg.sender].time_limit_epoch, "Time limit");
364        
365       uint256 tokens = balances[msg.sender];
366        
367       balances[msg.sender] = (balances[msg.sender]).sub(tokens);
368       balances[_recipient] = (balances[_recipient]).add(tokens);
369        
370       emit Transfer(msg.sender, _recipient, tokens);
371    }
372  
373    /**
374     * @dev Set limit on a claim per address
375     */
376 
377    function setClaimLimit(address _address, uint256 _days) public onlyOwner
378    {
379       require(balances[_address] > 0, "No tokens");
380 
381       claimLimits[_address].time_limit_epoch = (now + ((_days).mul(1 days)));
382    		
383       claimLimits[_address].limitSet = true;
384    }
385 
386 }