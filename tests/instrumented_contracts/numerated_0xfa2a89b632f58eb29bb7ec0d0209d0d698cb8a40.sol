1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address _who) public view returns (uint256);
6   function transfer(address _to, uint256 _value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 contract ERC20 is ERC20Basic {
10   function allowance(address _owner, address _spender)
11     public view returns (uint256);
12 
13   function transferFrom(address _from, address _to, uint256 _value)
14     public returns (bool);
15 
16   function approve(address _spender, uint256 _value) public returns (bool);
17   event Approval(
18     address indexed owner,
19     address indexed spender,
20     uint256 value
21   );
22 }
23 
24 library SafeMath {
25 
26   /**
27   * @dev Multiplies two numbers, throws on overflow.
28   */
29   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
30     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
31     // benefit is lost if 'b' is also tested.
32     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33     if (_a == 0) {
34       return 0;
35     }
36 
37     c = _a * _b;
38     assert(c / _a == _b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
46     // assert(_b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = _a / _b;
48     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
49     return _a / _b;
50   }
51 
52   /**
53   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56     assert(_b <= _a);
57     return _a - _b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
64     c = _a + _b;
65     assert(c >= _a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances.
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint256;
76 
77   mapping(address => uint256) internal balances;
78 
79   uint256 internal totalSupply_;
80 
81   /**
82   * @dev Total number of tokens in existence
83   */
84   function totalSupply() public view returns (uint256) {
85     return totalSupply_;
86   }
87 
88   /**
89   * @dev Transfer token for a specified address
90   * @param _to The address to transfer to.
91   * @param _value The amount to be transferred.
92   */
93   function transfer(address _to, uint256 _value) public returns (bool) {
94     require(_value <= balances[msg.sender]);
95     require(_to != address(0));
96 
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     emit Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   /**
104   * @dev Gets the balance of the specified address.
105   * @param _owner The address to query the the balance of.
106   * @return An uint256 representing the amount owned by the passed address.
107   */
108   function balanceOf(address _owner) public view returns (uint256) {
109     return balances[_owner];
110   }
111 
112 }
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://github.com/ethereum/EIPs/issues/20
119  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122 
123   mapping (address => mapping (address => uint256)) internal allowed;
124 
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(
133     address _from,
134     address _to,
135     uint256 _value
136   )
137     public
138     returns (bool)
139   {
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142     require(_to != address(0));
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     emit Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     emit Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(
173     address _owner,
174     address _spender
175    )
176     public
177     view
178     returns (uint256)
179   {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(
193     address _spender,
194     uint256 _addedValue
195   )
196     public
197     returns (bool)
198   {
199     allowed[msg.sender][_spender] = (
200       allowed[msg.sender][_spender].add(_addedValue));
201     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   /**
206    * @dev Decrease the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(
215     address _spender,
216     uint256 _subtractedValue
217   )
218     public
219     returns (bool)
220   {
221     uint256 oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue >= oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 contract Token is
234     StandardToken
235 {
236 
237     string public name = "Snow Land Token";
238     string public symbol = "sonwl🐈";
239     string public unit = "sl";
240     uint public decimals = 18;
241     uint256 internal supplyLimit = 9119190519 * (10 ** decimals);
242 
243     constructor () public {
244         balances[0x006016cED2484bdc1E78bbdC0Ca95fA021cA5ba6] = supplyLimit;
245         // balances[0xa06b79E655Db7D7C3B3E7B2ccEEb068c3259d0C9] = supplyLimit;
246         totalSupply_ =  supplyLimit;
247     } 
248 }