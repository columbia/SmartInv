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
70 /**
71  * @title Basic token
72  */
73 
74 contract PLTC is ERC20Interface
75 {
76     using SafeMath for uint256;
77    
78     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
79     string public constant name            = "PlatonCoin";
80     string public constant symbol          = "PLTC";
81     uint256 public totalTokenSupply        = 21000000 * TOKEN_DECIMALS;
82 
83     uint256 public totalSaleSupply         = 13860000 * TOKEN_DECIMALS; // Pre-sale + Sale 
84     uint256 public totalTeamSupply         =  2310000 * TOKEN_DECIMALS;
85     uint256 public totalAdvisorsSupply     =   840000 * TOKEN_DECIMALS;
86     uint256 public totalBountySupply       =   840000 * TOKEN_DECIMALS;
87     uint256 public totalEarlyInvSupply     =  3150000 * TOKEN_DECIMALS;
88 
89     uint8 public constant decimals         = 18;
90     address public owner;
91     uint256 public totalBurned;
92     bool stopped = false;
93 
94     event Burn(address indexed _burner, uint256 _value);
95     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
96     event OwnershipRenounced(address indexed _previousOwner);
97 
98     /** mappings **/ 
99     mapping(address => uint256) public  balances;
100     mapping(address => mapping(address => uint256)) internal  allowed;
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
117        balances[owner] = totalSaleSupply;
118 
119        emit Transfer(address(0x0), owner, balances[owner]);
120     }
121 
122     /**
123      * @dev To pause CrowdSale
124      */
125 
126     function pauseCrowdSale() external onlyOwner
127     {
128         stopped = true;
129     }
130 
131     /**
132      * @dev To resume CrowdSale
133      */
134 
135     function resumeCrowdSale() external onlyOwner
136     {
137         stopped = false;
138     }
139 
140     /**
141      * @dev initialize all wallets like team, advisors, bounty etc only by owner
142      * @param _teamWallet     Address of team Wallet 
143      * @param _advisorWallet  Address of advisor Wallet 
144      * @param _bountyWallet   Address of bounty Wallet 
145      * @param _earlyInvWallet Address of early investor Wallet 
146      */
147 
148     function initWallets(address _teamWallet, address _advisorWallet, address _bountyWallet, address _earlyInvWallet) public onlyOwner
149     {
150        require(!stopped);
151        require( _teamWallet != address(0x0) && _advisorWallet != address(0x0) && _bountyWallet != address(0x0) && _earlyInvWallet != address(0x0));
152 
153        balances[_teamWallet]     = totalTeamSupply;
154        balances[_advisorWallet]  = totalAdvisorsSupply;
155        balances[_bountyWallet]   = totalBountySupply;
156        balances[_earlyInvWallet] = totalEarlyInvSupply;
157 
158        emit Transfer(address(0x0), _teamWallet,     balances[_teamWallet]);
159        emit Transfer(address(0x0), _advisorWallet,  balances[_advisorWallet]);
160        emit Transfer(address(0x0), _bountyWallet,   balances[_bountyWallet]);
161        emit Transfer(address(0x0), _earlyInvWallet, balances[_earlyInvWallet]);
162     }
163 
164     /**
165      * @dev Burn specified number of PLTN tokens
166      * @param _value The amount of tokens to be burned
167      */
168 
169      function burn(uint256 _value) onlyOwner public returns (bool) 
170      {
171         require(!stopped);
172         require(_value <= balances[msg.sender]);
173 
174         address burner = msg.sender;
175 
176         balances[burner] = balances[burner].sub(_value);
177         totalTokenSupply = totalTokenSupply.sub(_value);
178         totalBurned      = totalBurned.add(_value);
179 
180         emit Burn(burner, _value);
181         emit Transfer(burner, address(0x0), _value);
182         return true;
183      }     
184 
185      /**
186       * @dev total number of tokens in existence
187       * @return An uint256 representing the total number of tokens in existence
188       */
189 
190      function totalSupply() public view returns(uint256 _totalSupply) 
191      {
192         _totalSupply = totalTokenSupply;
193         return _totalSupply;
194      }
195 
196     /**
197      * @dev Gets the balance of the specified address
198      * @param _owner The address to query the the balance of
199      * @return An uint256 representing the amount owned by the passed address
200      */
201 
202     function balanceOf(address _owner) public view returns (uint256) 
203     {
204        return balances[_owner];
205     }
206 
207     /**
208      * @dev Transfer tokens from one address to another
209      * @param _from address The address which you want to send tokens from
210      * @param _to address The address which you want to transfer to
211      * @param _value uint256 the amout of tokens to be transfered
212      */
213 
214     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
215     {
216        require(!stopped);
217 
218        if (_value == 0) 
219        {
220            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
221            return true;
222        }
223 
224        require(_to != address(0x0));
225        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
226 
227        balances[_from] = balances[_from].sub(_value);
228        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229        balances[_to] = balances[_to].add(_value);
230 
231        emit Transfer(_from, _to, _value);
232        return true;
233     }
234 
235     /**
236      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
237      *
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param _spender The address which will spend the funds
243      * @param _tokens The amount of tokens to be spent
244      */
245 
246     function approve(address _spender, uint256 _tokens) public returns(bool)
247     {
248        require(!stopped);
249        require(_spender != address(0x0));
250 
251        allowed[msg.sender][_spender] = _tokens;
252 
253        emit Approval(msg.sender, _spender, _tokens);
254        return true;
255     }
256 
257     /**
258      * @dev Function to check the amount of tokens that an owner allowed to a spender
259      * @param _owner address The address which owns the funds
260      * @param _spender address The address which will spend the funds
261      * @return A uint256 specifing the amount of tokens still avaible for the spender
262      */
263 
264     function allowance(address _owner, address _spender) public view returns(uint256)
265     {
266        require(!stopped);
267        require(_owner != address(0x0) && _spender != address(0x0));
268 
269        return allowed[_owner][_spender];
270     }
271 
272     /**
273      * @dev transfer token for a specified address
274      * @param _address The address to transfer to
275      * @param _tokens The amount to be transferred
276      */
277 
278     function transfer(address _address, uint256 _tokens) public returns(bool)
279     {
280        require(!stopped);
281 
282        if (_tokens == 0) 
283        {
284            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
285            return true;
286        }
287 
288        require(_address != address(0x0));
289        require(balances[msg.sender] >= _tokens);
290 
291        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
292        balances[_address] = (balances[_address]).add(_tokens);
293 
294        emit Transfer(msg.sender, _address, _tokens);
295        return true;
296     }
297 
298     /**
299      * @dev transfer ownership of this contract, only by owner
300      * @param _newOwner The address of the new owner to transfer ownership
301      */
302 
303     function transferOwnership(address _newOwner)public onlyOwner
304     {
305        require(!stopped);
306        require( _newOwner != address(0x0));
307 
308        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
309        balances[owner] = 0;
310        owner = _newOwner;
311 
312        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
313    }
314 
315    /**
316     * @dev Allows the current owner to relinquish control of the contract
317     * @notice Renouncing to ownership will leave the contract without an owner
318     * It will not be possible to call the functions with the `onlyOwner`
319     * modifier anymore
320     */
321 
322    function renounceOwnership() public onlyOwner 
323    {
324       require(!stopped);
325 
326       owner = address(0x0);
327 
328       emit OwnershipRenounced(owner);
329    }
330 
331    /**
332     * @dev Increase the amount of tokens that an owner allowed to a spender
333     * approve should be called when allowed[_spender] == 0. To increment
334     * allowed value is better to use this function to avoid 2 calls (and wait until
335     * the first transaction is mined)
336     * From MonolithDAO Token.sol
337     * @param _spender The address which will spend the funds
338     * @param _addedValue The amount of tokens to increase the allowance by
339     */
340 
341    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) 
342    {
343       require(!stopped);
344 
345       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
346 
347       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
348       return true;
349    }
350 
351    /**
352     * @dev Decrease the amount of tokens that an owner allowed to a spender
353     * approve should be called when allowed[_spender] == 0. To decrement
354     * allowed value is better to use this function to avoid 2 calls (and wait until
355     * the first transaction is mined)
356     * From MonolithDAO Token.sol
357     * @param _spender The address which will spend the funds
358     * @param _subtractedValue The amount of tokens to decrease the allowance by
359     */
360 
361    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) 
362    {
363       uint256 oldValue = allowed[msg.sender][_spender];
364 
365       require(!stopped);
366 
367       if (_subtractedValue > oldValue) 
368       {
369          allowed[msg.sender][_spender] = 0;
370       }
371       else 
372       {
373          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
374       }
375 
376       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
377       return true;
378    }
379 
380    /**
381     * @dev To transfer back any accidental ERC20 tokens sent to this contract by owner
382     */
383 
384    function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool) 
385    {
386       require(!stopped);
387 
388       return ERC20Interface(_tokenAddress).transfer(owner, _tokens);
389    }
390 
391    /* This unnamed function is called whenever someone tries to send ether to it */
392 
393    function () public payable 
394    {
395       revert();
396    }
397 }