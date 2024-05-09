1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9 
10   function balanceOf(address _who) public view returns (uint256);
11 
12   function allowance(address _owner, address _spender)
13     public view returns (uint256);
14 
15   function transfer(address _to, uint256 _value) public returns (bool);
16 
17   function approve(address _spender, uint256 _value)
18     public returns (bool);
19 
20   function transferFrom(address _from, address _to, uint256 _value)
21     public returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (_a == 0) {
50       return 0;
51     }
52 
53     uint256 c = _a * _b;
54     assert(c / _a == _b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers, truncating the quotient.
61   */
62   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63     // assert(_b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = _a / _b;
65     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     assert(_b <= _a);
75     uint256 c = _a - _b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     uint256 c = _a + _b;
85     assert(c >= _a);
86 
87     return c;
88   }
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://github.com/ethereum/EIPs/issues/20
96  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20 {
99   using SafeMath for uint256;
100 
101   mapping(address => uint256) balances;
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105   uint256 totalSupply_;
106 
107   /**
108   * @dev Total number of tokens in existence
109   */
110   function totalSupply() public view returns (uint256) {
111     return totalSupply_;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123   /**
124    * @dev Function to check the amount of tokens that an owner allowed to a spender.
125    * @param _owner address The address which owns the funds.
126    * @param _spender address The address which will spend the funds.
127    * @return A uint256 specifying the amount of tokens still available for the spender.
128    */
129   function allowance(
130     address _owner,
131     address _spender
132    )
133     public
134     view
135     returns (uint256)
136   {
137     return allowed[_owner][_spender];
138   }
139 
140   /**
141   * @dev Transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_value <= balances[msg.sender]);
147     require(_to != address(0));
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     emit Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_value <= balances[_from]);
185     require(_value <= allowed[_from][msg.sender]);
186     require(_to != address(0));
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
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
245 contract FixedDecimalsStandardToken is StandardToken {
246   string public name;
247   string public symbol;
248   uint8 public constant decimals = 18;
249 
250   constructor(string _name, string _symbol, uint256 _total) public {
251     name = _name;
252     symbol = _symbol;
253     totalSupply_ = _total * (10 ** uint256(decimals));
254     balances[msg.sender] = totalSupply_;
255     emit Transfer(address(0), msg.sender, totalSupply_);
256   }
257 
258 }