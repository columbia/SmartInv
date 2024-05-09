1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address _who) public view returns (uint256);
52   function transfer(address _to, uint256 _value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) internal balances;
60 
61   uint256 internal totalSupply_;
62 
63   /**
64   * @dev Total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev Transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_value <= balances[msg.sender]);
77     require(_to != address(0));
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address _owner, address _spender)
98     public view returns (uint256);
99 
100   function transferFrom(address _from, address _to, uint256 _value)
101     public returns (bool);
102 
103   function approve(address _spender, uint256 _value) public returns (bool);
104   event Approval(
105     address indexed owner,
106     address indexed spender,
107     uint256 value
108   );
109 }
110 
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _value
126   )
127     public
128     returns (bool)
129   {
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132     require(_to != address(0));
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    * Beware that changing an allowance with this method brings the risk that someone may use both the old
144    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) public returns (bool) {
151     allowed[msg.sender][_spender] = _value;
152     emit Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(
163     address _owner,
164     address _spender
165    )
166     public
167     view
168     returns (uint256)
169   {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(
183     address _spender,
184     uint256 _addedValue
185   )
186     public
187     returns (bool)
188   {
189     allowed[msg.sender][_spender] = (
190       allowed[msg.sender][_spender].add(_addedValue));
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(
205     address _spender,
206     uint256 _subtractedValue
207   )
208     public
209     returns (bool)
210   {
211     uint256 oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue >= oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract ABCToken is StandardToken {
224   string public name = 'ABCToken';
225   string public token = 'ABC';
226   uint8 public decimals = 6;
227   uint public INITIAL_SUPPLY = 1000000*10**6;
228   uint public constant ONE_DECIMAL_QUANTUM_ABC_TOKEN_PRICE = 1 ether/(100*10**6);
229 
230   //EVENTS
231   event tokenOverriden(address investor, uint decimalTokenAmount);
232   event receivedEther(address sender, uint amount);
233   mapping (address => bool) administrators;
234 
235   // previous BDA token values
236   address public tokenAdministrator = 0xd31736788Fd9358372dDA7b2957e1FD6F4f57BDB;
237   address public vault= 0x809d55801590f83B999550F2ad3e6a3d149e1eE2;
238 
239   // MODIFIERS
240   modifier onlyAdministrators {
241       require(administrators[msg.sender]);
242       _;
243   }
244 
245   function isEqualLength(address[] x, uint[] y) pure internal returns (bool) { return x.length == y.length; }
246   modifier onlySameLengthArray(address[] x, uint[] y) {
247       require(isEqualLength(x,y));
248       _;
249   }
250 
251   constructor() public {
252     totalSupply_ = INITIAL_SUPPLY;
253     balances[this] = INITIAL_SUPPLY;
254     administrators[tokenAdministrator]=true;
255   }
256 
257   function()
258   payable
259   public
260   {
261       uint amountSentInWei = msg.value;
262       uint decimalTokenAmount = amountSentInWei/ONE_DECIMAL_QUANTUM_ABC_TOKEN_PRICE;
263       require(vault.send(msg.value));
264       require(this.transfer(msg.sender, decimalTokenAmount));
265       emit receivedEther(msg.sender, amountSentInWei);
266   }
267 
268   function addAdministrator(address newAdministrator)
269   public
270   onlyAdministrators
271   {
272         administrators[newAdministrator]=true;
273   }
274 
275   function overrideTokenHolders(address[] toOverride, uint[] decimalTokenAmount)
276   public
277   onlyAdministrators
278   onlySameLengthArray(toOverride, decimalTokenAmount)
279   {
280       for (uint i = 0; i < toOverride.length; i++) {
281       		uint previousAmount = balances[toOverride[i]];
282       		balances[toOverride[i]] = decimalTokenAmount[i];
283       		totalSupply_ = totalSupply_-previousAmount+decimalTokenAmount[i];
284           emit tokenOverriden(toOverride[i], decimalTokenAmount[i]);
285       }
286   }
287 
288   function overrideTokenHolder(address toOverride, uint decimalTokenAmount)
289   public
290   onlyAdministrators
291   {
292   		uint previousAmount = balances[toOverride];
293   		balances[toOverride] = decimalTokenAmount;
294   		totalSupply_ = totalSupply_-previousAmount+decimalTokenAmount;
295       emit tokenOverriden(toOverride, decimalTokenAmount);
296   }
297 
298   function resetContract()
299   public
300   onlyAdministrators
301   {
302     selfdestruct(vault);
303   }
304 
305 }