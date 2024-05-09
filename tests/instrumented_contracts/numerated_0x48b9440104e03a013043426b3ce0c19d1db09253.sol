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
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 {
60   function totalSupply() public view returns (uint256);
61 
62   function balanceOf(address _who) public view returns (uint256);
63 
64   function allowance(address _owner, address _spender)
65     public view returns (uint256);
66 
67   function transfer(address _to, uint256 _value) public returns (bool);
68 
69   function approve(address _spender, uint256 _value)
70     public returns (bool);
71 
72   function transferFrom(address _from, address _to, uint256 _value)
73     public returns (bool);
74 
75   event Transfer(
76     address indexed from,
77     address indexed to,
78     uint256 value
79   );
80 
81   event Approval(
82     address indexed owner,
83     address indexed spender,
84     uint256 value
85   );
86 }
87 
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/issues/20
94  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20 {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   uint256 totalSupply_;
104 
105   /**
106   * @dev Total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return totalSupply_;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256) {
118     return balances[_owner];
119   }
120 
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param _owner address The address which owns the funds.
124    * @param _spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(
128     address _owner,
129     address _spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return allowed[_owner][_spender];
136   }
137 
138   /**
139   * @dev Transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_value <= balances[msg.sender]);
145     require(_to != address(0));
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     emit Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184     require(_to != address(0));
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(
203     address _spender,
204     uint256 _addedValue
205   )
206     public
207     returns (bool)
208   {
209     allowed[msg.sender][_spender] = (
210       allowed[msg.sender][_spender].add(_addedValue));
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To decrement
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _subtractedValue The amount of tokens to decrease the allowance by.
223    */
224   function decreaseApproval(
225     address _spender,
226     uint256 _subtractedValue
227   )
228     public
229     returns (bool)
230   {
231     uint256 oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue >= oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 
244 contract BitCnyToken is StandardToken {
245 
246   string public constant name = "bitCNY";
247   string public constant symbol = "bitCNY";
248   uint8 public constant decimals = 4;
249 
250   uint256 public constant INITIAL_SUPPLY = 8e9 * (10 ** uint256(decimals));
251 
252   constructor(address _address) public {
253     totalSupply_ = INITIAL_SUPPLY;
254     balances[_address] = INITIAL_SUPPLY;
255     emit Transfer(address(0), _address, INITIAL_SUPPLY);
256   }
257 
258 }