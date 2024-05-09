1 pragma solidity ^0.4.21 ;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 
6 contract ERC20Basic {
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     if (a == 0) {
27       return 0;
28     }
29     c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     // uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return a / b;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
56     c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   uint256 totalSupply_;
68 
69   /**
70   * @dev total number of tokens in existence
71   */
72   function totalSupply() public view returns (uint256) {
73     return totalSupply_;
74   }
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     emit Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public view returns (uint256) {
97     return balances[_owner];
98   }
99 
100 }
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     emit Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public view returns (uint256) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * @dev Increase the amount of tokens that an owner allowed to a spender.
152    *
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    * @param _spender The address which will spend the funds.
158    * @param _addedValue The amount of tokens to increase the allowance by.
159    */
160   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
161     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
162     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   /**
167    * @dev Decrease the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To decrement
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _subtractedValue The amount of tokens to decrease the allowance by.
175    */
176   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187 }
188 contract BurnableToken is BasicToken {
189 
190   event Burn(address indexed burner, uint256 value);
191 
192   /**
193    * @dev Burns a specific amount of tokens.
194    * @param _value The amount of token to be burned.
195    */
196   function burn(uint256 _value) public {
197     _burn(msg.sender, _value);
198   }
199 
200   function _burn(address _who, uint256 _value) internal {
201     require(_value <= balances[_who]);
202     // no need to require value <= totalSupply, since that would imply the
203     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
204 
205     balances[_who] = balances[_who].sub(_value);
206     totalSupply_ = totalSupply_.sub(_value);
207     emit Burn(_who, _value);
208     emit Transfer(_who, address(0), _value);
209   }
210 }
211 contract StandardBurnableToken is BurnableToken, StandardToken {
212 
213   /**
214    * @dev Burns a specific amount of tokens from the target address and decrements allowance
215    * @param _from address The address which you want to send tokens from
216    * @param _value uint256 The amount of token to be burned
217    */
218   function burnFrom(address _from, uint256 _value) public {
219     require(_value <= allowed[_from][msg.sender]);
220     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
221     // this function needs to emit an event with the updated approval.
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     _burn(_from, _value);
224   }
225 }
226 contract DVCToken is StandardBurnableToken{
227     string public name = "Dragonvein Coin";
228     string public symbol = "DVC";
229     uint8 public decimals = 8;
230     uint256 public INITIAL_SUPPLY = 1000000000000000000;
231     constructor() public {
232         totalSupply_ = INITIAL_SUPPLY;
233         balances[msg.sender] = INITIAL_SUPPLY;
234     }
235 }