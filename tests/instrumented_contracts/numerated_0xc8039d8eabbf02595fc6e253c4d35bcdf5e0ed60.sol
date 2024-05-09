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
57 contract ERC20
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
74 contract GSCP is ERC20
75 {
76     using SafeMath for uint256;
77    
78     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
79     string public constant name            = "Genesis Supply Chain Platform";
80     string public constant symbol          = "GSCP";
81     uint256 public totalTokenSupply        = 999999999 * TOKEN_DECIMALS;
82     uint8 public constant decimals         = 18;
83     address public owner;
84 
85     event Burn(address indexed _burner, uint256 _value);
86 
87     /** mappings **/ 
88     mapping(address => uint256) public  balances;
89     mapping(address => mapping(address => uint256)) internal  allowed;
90  
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94 
95     modifier onlyOwner() 
96     {
97        require(msg.sender == owner);
98        _;
99     }
100     
101     /** constructor **/
102 
103     constructor() public
104     {
105        owner = msg.sender;
106        balances[address(this)] = totalTokenSupply;
107        emit Transfer(address(0x0), address(this), balances[address(this)]);
108     }
109 
110     /**
111      * @dev Burn specified number of GSCP tokens
112      * This function will be called once after all remaining tokens are transferred from
113      * smartcontract to owner wallet
114      */
115 
116      function burn(uint256 _value) onlyOwner public returns (bool) 
117      {
118         require(_value <= balances[msg.sender]);
119 
120         address burner = msg.sender;
121 
122         balances[burner] = balances[burner].sub(_value);
123         totalTokenSupply = totalTokenSupply.sub(_value);
124 
125         emit Burn(burner, _value);
126         return true;
127      }     
128 
129      /**
130       * @dev total number of tokens in existence
131       */
132 
133      function totalSupply() public view returns(uint256 _totalSupply) 
134      {
135         _totalSupply = totalTokenSupply;
136         return _totalSupply;
137      }
138 
139     /**
140      * @dev Gets the balance of the specified address.
141      * @param _owner The address to query the the balance of. 
142      * @return An uint256 representing the amount owned by the passed address.
143      */
144 
145     function balanceOf(address _owner) public view returns (uint256) 
146     {
147        return balances[_owner];
148     }
149 
150     /**
151      * @dev Transfer tokens from one address to another
152      * @param _from address The address which you want to send tokens from
153      * @param _to address The address which you want to transfer to
154      * @param _value uint256 the amout of tokens to be transfered
155      */
156 
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
158     {
159        if (_value == 0) 
160        {
161            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
162            return;
163        }
164 
165        require(_to != address(0x0));
166        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
167 
168        balances[_from] = balances[_from].sub(_value);
169        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170        balances[_to] = balances[_to].add(_value);
171        emit Transfer(_from, _to, _value);
172        return true;
173     }
174 
175     /**
176     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177     *
178     * Beware that changing an allowance with this method brings the risk that someone may use both the old
179     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     * @param _spender The address which will spend the funds.
183     * @param _tokens The amount of tokens to be spent.
184     */
185 
186     function approve(address _spender, uint256 _tokens) public returns(bool)
187     {
188        require(_spender != address(0x0));
189 
190        allowed[msg.sender][_spender] = _tokens;
191        emit Approval(msg.sender, _spender, _tokens);
192        return true;
193     }
194 
195     /**
196      * @dev Function to check the amount of tokens that an owner allowed to a spender.
197      * @param _owner address The address which owns the funds.
198      * @param _spender address The address which will spend the funds.
199      * @return A uint256 specifing the amount of tokens still avaible for the spender.
200      */
201 
202     function allowance(address _owner, address _spender) public view returns(uint256)
203     {
204        require(_owner != address(0x0) && _spender != address(0x0));
205 
206        return allowed[_owner][_spender];
207     }
208 
209     /**
210     * @dev transfer token for a specified address
211     * @param _address The address to transfer to.
212     * @param _tokens The amount to be transferred.
213     */
214 
215     function transfer(address _address, uint256 _tokens) public returns(bool)
216     {
217        if (_tokens == 0) 
218        {
219            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
220            return;
221        }
222 
223        require(_address != address(0x0));
224        require(balances[msg.sender] >= _tokens);
225 
226        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
227        balances[_address] = (balances[_address]).add(_tokens);
228        emit Transfer(msg.sender, _address, _tokens);
229        return true;
230     }
231     
232     /**
233     * @dev transfer token from smart contract to another account, only by owner
234     * @param _address The address to transfer to.
235     * @param _tokens The amount to be transferred.
236     */
237 
238     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
239     {
240        require( _address != address(0x0)); 
241        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
242 
243        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
244        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
245        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
246        return true;
247     }
248 	
249     /**
250     * @dev transfer ownership of this contract, only by owner
251     * @param _newOwner The address of the new owner to transfer ownership
252     */
253 
254     function transferOwnership(address _newOwner)public onlyOwner
255     {
256        require( _newOwner != address(0x0));
257 
258        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
259        balances[owner] = 0;
260        owner = _newOwner;
261        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
262    }
263 
264    /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender
266    */
267 
268    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) 
269    {
270       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
271       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272       return true;
273    }
274 
275    /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender
277    */
278 
279    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) 
280    {
281       uint256 oldValue = allowed[msg.sender][_spender];
282 
283       if (_subtractedValue > oldValue) 
284       {
285          allowed[msg.sender][_spender] = 0;
286       }
287       else 
288       {
289          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290       }
291       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292       return true;
293    }
294 
295    /* This unnamed function is called whenever someone tries to send ether to it */
296 
297    function () public payable 
298    {
299       revert();
300    }
301 }