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
74 contract OppOpenWiFi is ERC20
75 {
76     using SafeMath for uint256;
77    
78     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
79     string public constant name            = "OppOpenWiFi Token";
80     string public constant symbol          = "OPP";
81     uint256 public totalTokenSupply        = 4165000000 * TOKEN_DECIMALS;  
82     address public owner;
83     uint8 public constant decimals = 18;
84 
85     /** mappings **/ 
86     mapping(address => mapping(address => uint256)) allowed;
87     mapping(address => uint256) balances;
88  
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92 
93     modifier onlyOwner() 
94     {
95        require(msg.sender == owner);
96        _;
97     }
98     
99     /** constructor **/
100 
101     constructor() public
102     {
103        owner = msg.sender;
104        balances[address(this)] = totalTokenSupply;
105        emit Transfer(address(0x0), address(this), balances[address(this)]);
106     }
107     
108     /**
109      * @dev total number of tokens in existence
110     */
111 
112     function totalSupply() public view returns(uint256 _totalSupply) 
113     {
114        _totalSupply = totalTokenSupply;
115        return _totalSupply;
116     }
117 
118     /**
119      * @dev Gets the balance of the specified address.
120      * @param _owner The address to query the the balance of. 
121      * @return An uint256 representing the amount owned by the passed address.
122      */
123 
124     function balanceOf(address _owner) public view returns (uint256 balance) 
125     {
126        return balances[_owner];
127     }
128 
129     /**
130      * @dev Transfer tokens from one address to another
131      * @param _from address The address which you want to send tokens from
132      * @param _to address The address which you want to transfer to
133      * @param _value uint256 the amout of tokens to be transfered
134      */
135 
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
137     {
138        if (_value == 0) 
139        {
140            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
141            return;
142        }
143 
144        require(_to != address(0x0));
145        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
146 
147        balances[_from] = balances[_from].sub(_value);
148        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149        balances[_to] = balances[_to].add(_value);
150        emit Transfer(_from, _to, _value);
151        return true;
152     }
153 
154     /**
155     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156     *
157     * Beware that changing an allowance with this method brings the risk that someone may use both the old
158     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161     * @param _spender The address which will spend the funds.
162     * @param _tokens The amount of tokens to be spent.
163     */
164 
165     function approve(address _spender, uint256 _tokens)public returns(bool)
166     {
167        require(_spender != address(0x0));
168 
169        allowed[msg.sender][_spender] = _tokens;
170        emit Approval(msg.sender, _spender, _tokens);
171        return true;
172     }
173 
174     /**
175      * @dev Function to check the amount of tokens that an owner allowed to a spender.
176      * @param _owner address The address which owns the funds.
177      * @param _spender address The address which will spend the funds.
178      * @return A uint256 specifing the amount of tokens still avaible for the spender.
179      */
180 
181     function allowance(address _owner, address _spender) public view returns(uint256)
182     {
183        require(_owner != address(0x0) && _spender != address(0x0));
184 
185        return allowed[_owner][_spender];
186     }
187 
188     /**
189     * @dev transfer token for a specified address
190     * @param _address The address to transfer to.
191     * @param _tokens The amount to be transferred.
192     */
193 
194     function transfer(address _address, uint256 _tokens)public returns(bool)
195     {
196        if (_tokens == 0) 
197        {
198            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
199            return;
200        }
201 
202        require(_address != address(0x0));
203        require(balances[msg.sender] >= _tokens);
204 
205        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
206        balances[_address] = (balances[_address]).add(_tokens);
207        emit Transfer(msg.sender, _address, _tokens);
208        return true;
209     }
210     
211     /**
212     * @dev transfer token from smart contract to another account, only by owner
213     * @param _address The address to transfer to.
214     * @param _tokens The amount to be transferred.
215     */
216 
217     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
218     {
219        require( _address != address(0x0)); 
220        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
221 
222        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
223        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
224        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
225        return true;
226     }
227 	
228     /**
229     * @dev transfer ownership of this contract, only by owner
230     * @param _newOwner The address of the new owner to transfer ownership
231     */
232 
233     function transferOwnership(address _newOwner)public onlyOwner
234     {
235        require( _newOwner != address(0x0));
236 
237        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
238        balances[owner] = 0;
239        owner = _newOwner;
240        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
241    }
242 
243    /**
244    * @dev Increase the amount of tokens that an owner allowed to a spender
245    */
246 
247    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) 
248    {
249       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251       return true;
252    }
253 
254    /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender
256    */
257    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) 
258    {
259       uint256 oldValue = allowed[msg.sender][_spender];
260 
261       if (_subtractedValue > oldValue) 
262       {
263          allowed[msg.sender][_spender] = 0;
264       }
265       else 
266       {
267          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268       }
269       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270       return true;
271    }
272 
273 }