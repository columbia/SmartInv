1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
7     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
8     // benefit is lost if 'b' is also tested.
9     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
10     if (_a == 0) {
11       return 0;
12     }
13 
14     c = _a * _b;
15     assert(c / _a == _b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
23     // assert(_b > 0); // Solidity automatically throws when dividing by 0
24     // uint256 c = _a / _b;
25     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
26     return _a / _b;
27   }
28 
29   /**
30   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     assert(_b <= _a);
34     return _a - _b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
41     c = _a + _b;
42     assert(c >= _a);
43     return c;
44   }
45 }
46 
47 contract ERC20Basic {
48   function totalSupply() public view returns (uint256);
49   function balanceOf(address _who) public view returns (uint256);
50   function transfer(address _to, uint256 _value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) internal balances;
58 
59   uint256 internal totalSupply_;
60 
61   /**
62   * @dev Total number of tokens in existence
63   */
64   function totalSupply() public view returns (uint256) {
65     return totalSupply_;
66   }
67 
68   /**
69   * @dev Transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_value <= balances[msg.sender]);
75     require(_to != address(0));
76 
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public view returns (uint256) {
89     return balances[_owner];
90   }
91 
92 }
93 
94 contract BurnableToken is BasicToken {
95 
96   event Burn(address indexed burner, uint256 value);
97 
98   /**
99    * @dev Burns a specific amount of tokens.
100    * @param _value The amount of token to be burned.
101    */
102   function burn(uint256 _value) public {
103     _burn(msg.sender, _value);
104   }
105 
106   function _burn(address _who, uint256 _value) internal {
107     require(_value <= balances[_who]);
108     // no need to require value <= totalSupply, since that would imply the
109     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
110 
111     balances[_who] = balances[_who].sub(_value);
112     totalSupply_ = totalSupply_.sub(_value);
113     emit Burn(_who, _value);
114     emit Transfer(_who, address(0), _value);
115   }
116 }
117 
118 contract ERC20 is ERC20Basic {
119   function allowance(address _owner, address _spender)
120     public view returns (uint256);
121 
122   function transferFrom(address _from, address _to, uint256 _value)
123     public returns (bool);
124 
125   function approve(address _spender, uint256 _value) public returns (bool);
126   event Approval(
127     address indexed owner,
128     address indexed spender,
129     uint256 value
130   );
131 }
132 
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(
145     address _from,
146     address _to,
147     uint256 _value
148   )
149     public
150     returns (bool)
151   {
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154     require(_to != address(0));
155 
156     balances[_from] = balances[_from].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159     emit Transfer(_from, _to, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _addedValue The amount of tokens to increase the allowance by.
203    */
204   function increaseApproval(
205     address _spender,
206     uint256 _addedValue
207   )
208     public
209     returns (bool)
210   {
211     allowed[msg.sender][_spender] = (
212       allowed[msg.sender][_spender].add(_addedValue));
213     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint256 _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint256 oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue >= oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 contract NeuronxCoin is StandardToken, BurnableToken {
246     string public name = "NeuronX.io blockchain token";
247     string public symbol = "NXBT";
248     uint8 public decimals = 8;
249 
250     uint256 public constant INITIAL_SUPPLY = 200 * 1e6 * 1e8; // 200.000.000 total with decimals
251 
252     constructor() public {
253         totalSupply_ = INITIAL_SUPPLY;
254         balances[msg.sender] = INITIAL_SUPPLY;
255     }
256 }