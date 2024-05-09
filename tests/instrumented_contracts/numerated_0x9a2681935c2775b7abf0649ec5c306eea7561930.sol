1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title DetailedERC20 token
36  * @dev The decimals are only for visualization purposes.
37  * All the operations are done using the smallest and indivisible token unit,
38  * just as on Ethereum all the operations are done in wei.
39  */
40 contract DetailedERC20 is ERC20 {
41   string public name;
42   string public symbol;
43   uint8 public decimals;
44 
45   constructor(string _name, string _symbol, uint8 _decimals) public {
46     name = _name;
47     symbol = _symbol;
48     decimals = _decimals;
49   }
50 }
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (a == 0) {
66       return 0;
67     }
68 
69     c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     // uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return a / b;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
96     c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   uint256 totalSupply_;
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     emit Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256) {
141     return balances[_owner];
142   }
143 
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * @dev Increase the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint _addedValue
229   )
230     public
231     returns (bool)
232   {
233     allowed[msg.sender][_spender] = (
234       allowed[msg.sender][_spender].add(_addedValue));
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(
250     address _spender,
251     uint _subtractedValue
252   )
253     public
254     returns (bool)
255   {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 // File: contracts/EasyoptionToken.sol
269 
270 contract EasyoptionToken is StandardToken, DetailedERC20 {
271     constructor(string _name, string _symbol, uint8 _decimals, uint256 _supply)
272         DetailedERC20(_name, _symbol, _decimals)
273         public
274     {
275         totalSupply_ = _supply;
276         balances[msg.sender] = _supply;
277     }
278 }