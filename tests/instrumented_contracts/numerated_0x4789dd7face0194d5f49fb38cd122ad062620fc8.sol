1 pragma solidity 0.4.23;
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
70 interface tokenRecipient 
71 { 
72     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
73 }
74 
75 /**
76  * @title Basic token
77  */
78 
79 contract JIB is ERC20Interface
80 {
81     using SafeMath for uint256;
82    
83     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
84     string public constant name            = "Jibbit Token";
85     string public constant symbol          = "JIB";
86     uint256 public totalTokenSupply        = 700000000 * TOKEN_DECIMALS;
87     uint8 public constant decimals         = 18;
88     address public owner;
89     uint256 public totalBurned;
90     bool stopped    = false;
91     bool saleClosed = false;
92 
93     event Burn(address indexed _burner, uint256 _value);
94     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
95     event OwnershipRenounced(address indexed _previousOwner);
96 
97     /** mappings **/ 
98     mapping(address => uint256) public  balances;
99     mapping(address => mapping(address => uint256)) internal  allowed;
100     mapping(address => bool) public allowedAddresses;
101  
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105 
106     modifier onlyOwner() 
107     {
108        require(msg.sender == owner);
109        _;
110     }
111     
112     /** constructor **/
113 
114     constructor() public
115     {
116        owner = msg.sender;
117        balances[owner] = totalTokenSupply;
118        allowedAddresses[owner] = true;
119 
120        emit Transfer(address(0x0), owner, balances[owner]);
121     }
122 
123     /**
124      * @dev This function has to be triggered once after ICO sale is completed
125      */
126 
127     function saleCompleted() external onlyOwner
128     {
129         saleClosed = true;
130     }
131 
132     /**
133      * @dev To pause token transfer. In general pauseTransfer can be triggered
134      *      only on some specific error conditions 
135      */
136 
137     function pauseTransfer() external onlyOwner
138     {
139         stopped = true;
140     }
141 
142     /**
143      * @dev To resume token transfer
144      */
145 
146     function resumeTransfer() external onlyOwner
147     {
148         stopped = false;
149     }
150 
151     /**
152      * @dev To add address into whitelist
153      */
154 
155     function addToWhitelist(address _newAddr) public onlyOwner
156     {
157        allowedAddresses[_newAddr] = true;
158     }
159 
160     /**
161      * @dev To remove address from whitelist
162      */
163 
164     function removeFromWhitelist(address _newAddr) public onlyOwner
165     {
166        allowedAddresses[_newAddr] = false;
167     }
168 
169     /**
170      * @dev To check whether address is whitelist or not
171      */
172 
173     function isWhitelisted(address _addr) public view returns (bool) 
174     {
175        return allowedAddresses[_addr];
176     }
177 
178     /**
179      * @dev Burn specified number of GSCP tokens
180      * This function will be called once after all remaining tokens are transferred from
181      * smartcontract to owner wallet
182      */
183 
184     function burn(uint256 _value) onlyOwner public returns (bool) 
185     {
186        require(!stopped);
187        require(_value <= balances[msg.sender]);
188 
189        address burner = msg.sender;
190 
191        balances[burner] = balances[burner].sub(_value);
192        totalTokenSupply = totalTokenSupply.sub(_value);
193        totalBurned      = totalBurned.add(_value);
194 
195        emit Burn(burner, _value);
196        emit Transfer(burner, address(0x0), _value);
197        return true;
198     }     
199 
200     /**
201      * @dev total number of tokens in existence
202      * @return An uint256 representing the total number of tokens in existence
203      */
204 
205     function totalSupply() public view returns(uint256 _totalSupply) 
206     {
207        _totalSupply = totalTokenSupply;
208        return _totalSupply;
209     }
210 
211     /**
212      * @dev Gets the balance of the specified address
213      * @param _owner The address to query the the balance of 
214      * @return An uint256 representing the amount owned by the passed address
215      */
216 
217     function balanceOf(address _owner) public view returns (uint256) 
218     {
219        return balances[_owner];
220     }
221 
222     /**
223      * @dev Transfer tokens from one address to another
224      * @param _from address The address which you want to send tokens from
225      * @param _to address The address which you want to transfer to
226      * @param _value uint256 the amout of tokens to be transfered
227      */
228 
229     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
230     {
231        require(!stopped);
232 
233        if(!saleClosed && !isWhitelisted(msg.sender))
234           return false;
235 
236        if (_value == 0) 
237        {
238            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
239            return true;
240        }
241 
242        require(_to != address(0x0));
243        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
244 
245        balances[_from] = balances[_from].sub(_value);
246        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247        balances[_to] = balances[_to].add(_value);
248 
249        emit Transfer(_from, _to, _value);
250        return true;
251     }
252 
253     /**
254      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
255      *
256      * Beware that changing an allowance with this method brings the risk that someone may use both the old
257      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
258      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      * @param _spender The address which will spend the funds
261      * @param _tokens The amount of tokens to be spent
262      */
263 
264     function approve(address _spender, uint256 _tokens) public returns(bool)
265     {
266        require(!stopped);
267        require(_spender != address(0x0));
268 
269        allowed[msg.sender][_spender] = _tokens;
270 
271        emit Approval(msg.sender, _spender, _tokens);
272        return true;
273     }
274 
275     /**
276      * @dev Function to check the amount of tokens that an owner allowed to a spender
277      * @param _owner address The address which owns the funds
278      * @param _spender address The address which will spend the funds
279      * @return A uint256 specifing the amount of tokens still avaible for the spender
280      */
281 
282     function allowance(address _owner, address _spender) public view returns(uint256)
283     {
284        require(!stopped);
285        require(_owner != address(0x0) && _spender != address(0x0));
286 
287        return allowed[_owner][_spender];
288     }
289 
290     /**
291      * @dev transfer token for a specified address
292      * @param _address The address to transfer to
293      * @param _tokens The amount to be transferred
294      */
295 
296     function transfer(address _address, uint256 _tokens) public returns(bool)
297     {
298        require(!stopped);
299 
300        if(!saleClosed && !isWhitelisted(msg.sender))
301           return false;
302 
303        if (_tokens == 0) 
304        {
305            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
306            return true;
307        }
308 
309        require(_address != address(0x0));
310        require(balances[msg.sender] >= _tokens);
311 
312        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
313        balances[_address] = (balances[_address]).add(_tokens);
314 
315        emit Transfer(msg.sender, _address, _tokens);
316        return true;
317     }
318 
319     /**
320      * @dev transfer ownership of this contract, only by owner
321      * @param _newOwner The address of the new owner to transfer ownership
322      */
323 
324     function transferOwnership(address _newOwner)public onlyOwner
325     {
326        require(!stopped);
327        require( _newOwner != address(0x0));
328 
329        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
330        balances[owner] = 0;
331        owner = _newOwner;
332 
333        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
334    }
335 
336    /**
337     * @dev Allows the current owner to relinquish control of the contract
338     * @notice Renouncing to ownership will leave the contract without an owner
339     * It will not be possible to call the functions with the `onlyOwner`
340     * modifier anymore
341     */
342 
343    function renounceOwnership() public onlyOwner 
344    {
345       require(!stopped);
346 
347       owner = address(0x0);
348       emit OwnershipRenounced(owner);
349    }
350 
351    /**
352     * @dev Increase the amount of tokens that an owner allowed to a spender
353     */
354 
355    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) 
356    {
357       require(!stopped);
358 
359       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
360       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361       return true;
362    }
363 
364    /**
365     * @dev Decrease the amount of tokens that an owner allowed to a spender
366     */
367 
368    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) 
369    {
370       uint256 oldValue = allowed[msg.sender][_spender];
371 
372       require(!stopped);
373 
374       if (_subtractedValue > oldValue) 
375       {
376          allowed[msg.sender][_spender] = 0;
377       }
378       else 
379       {
380          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
381       }
382       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383       return true;
384    }
385 
386    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) 
387    {
388       require(!stopped);
389 
390       tokenRecipient spender = tokenRecipient(_spender);
391 
392       if (approve(_spender, _value)) 
393       {
394           spender.receiveApproval(msg.sender, _value, this, _extraData);
395           return true;
396       }
397    }
398 
399    /**
400     * @dev To transfer back any accidental ERC20 tokens sent to this contract by owner
401     */
402 
403    function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) 
404    {
405       require(!stopped);
406 
407       return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
408    }
409 
410    /* This unnamed function is called whenever someone tries to send ether to it */
411 
412    function () public payable 
413    {
414       revert();
415    }
416 }