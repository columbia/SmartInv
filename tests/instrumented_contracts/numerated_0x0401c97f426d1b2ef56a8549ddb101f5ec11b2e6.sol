1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/francesco/WORK/Mangrovia/mangrovia-cannadabiz-ico/contracts/CBTok.sol
6 // flattened :  Monday, 10-Jun-19 08:48:23 UTC
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address _who) public view returns (uint256);
10   function transfer(address _to, uint256 _value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
20     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (_a == 0) {
24       return 0;
25     }
26 
27     c = _a * _b;
28     assert(c / _a == _b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
36     // assert(_b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = _a / _b;
38     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
39     return _a / _b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     assert(_b <= _a);
47     return _a - _b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
54     c = _a + _b;
55     assert(c >= _a);
56     return c;
57   }
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address _owner, address _spender)
62     public view returns (uint256);
63 
64   function transferFrom(address _from, address _to, uint256 _value)
65     public returns (bool);
66 
67   function approve(address _spender, uint256 _value) public returns (bool);
68   event Approval(
69     address indexed owner,
70     address indexed spender,
71     uint256 value
72   );
73 }
74 
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) internal balances;
79 
80   uint256 internal totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_value <= balances[msg.sender]);
96     require(_to != address(0));
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 contract DetailedERC20 is ERC20 {
116   string public name;
117   string public symbol;
118   uint8 public decimals;
119 
120   constructor(string _name, string _symbol, uint8 _decimals) public {
121     name = _name;
122     symbol = _symbol;
123     decimals = _decimals;
124   }
125 }
126 
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) internal allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(
139     address _from,
140     address _to,
141     uint256 _value
142   )
143     public
144     returns (bool)
145   {
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148     require(_to != address(0));
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(
179     address _owner,
180     address _spender
181    )
182     public
183     view
184     returns (uint256)
185   {
186     return allowed[_owner][_spender];
187   }
188 
189   /**
190    * @dev Increase the amount of tokens that an owner allowed to a spender.
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(
199     address _spender,
200     uint256 _addedValue
201   )
202     public
203     returns (bool)
204   {
205     allowed[msg.sender][_spender] = (
206       allowed[msg.sender][_spender].add(_addedValue));
207     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208     return true;
209   }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(
221     address _spender,
222     uint256 _subtractedValue
223   )
224     public
225     returns (bool)
226   {
227     uint256 oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue >= oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 contract CBTok is DetailedERC20, StandardToken {
240 
241     address owner;
242 
243     constructor() public
244         DetailedERC20("CannadaBiz Token", "CBTOK", 18)
245     {
246         totalSupply_ = 500000000 * (uint(10)**decimals);
247         balances[msg.sender] = totalSupply_;
248         owner = msg.sender;
249     }
250 }