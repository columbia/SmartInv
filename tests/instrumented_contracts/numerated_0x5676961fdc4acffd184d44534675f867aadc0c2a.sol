1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16        if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 contract ERC20 is ERC20Basic {
59   function allowance(address owner, address spender)
60     public view returns (uint256);
61 
62   function transferFrom(address from, address to, uint256 value)
63     public returns (bool);
64 
65   function approve(address spender, uint256 value) public returns (bool);
66   event Approval(
67     address indexed owner,
68     address indexed spender,
69     uint256 value
70   );
71 }
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev Total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev Transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
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
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
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
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 contract DetailedERC20 is ERC20 {
223   string public name;
224   string public symbol;
225   uint8 public decimals;
226 
227   constructor(string _name, string _symbol, uint8 _decimals) public {
228     name = _name;
229     symbol = _symbol;
230     decimals = _decimals;
231   }
232 }
233 contract NativeCoins is StandardToken {
234 
235   string public constant name = "NATIVECOINS"; // solium-disable-line uppercase
236   string public constant symbol = "NTC"; // solium-disable-line uppercase
237   uint8 public constant decimals = 18; // solium-disable-line uppercase
238 
239   uint256 public constant INITIAL_SUPPLY = 21 * 10 ** (6 + uint256(decimals));
240 
241   /**
242    * @dev Constructor that gives msg.sender all of existing tokens.
243    */
244   constructor() public {
245     totalSupply_ = INITIAL_SUPPLY;
246     balances[msg.sender] = INITIAL_SUPPLY;
247     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
248   }
249 
250 }