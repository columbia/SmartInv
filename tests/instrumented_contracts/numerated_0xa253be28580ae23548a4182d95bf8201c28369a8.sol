1 pragma solidity 0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
91 
92 /**
93  * @title Burnable Token
94  * @dev Token that can be irreversibly burned (destroyed).
95  */
96 contract BurnableToken is BasicToken {
97 
98     event Burn(address indexed burner, uint256 value);
99 
100     /**
101      * @dev Burns a specific amount of tokens.
102      * @param _value The amount of token to be burned.
103      */
104     function burn(uint256 _value) public {
105         require(_value <= balances[msg.sender]);
106         // no need to require value <= totalSupply, since that would imply the
107         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
108 
109         address burner = msg.sender;
110         balances[burner] = balances[burner].sub(_value);
111         totalSupply = totalSupply.sub(_value);
112         Burn(burner, _value);
113     }
114 }
115 
116 // File: zeppelin-solidity/contracts/token/ERC20.sol
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 // File: zeppelin-solidity/contracts/token/StandardToken.sol
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * @dev Increase the amount of tokens that an owner allowed to a spender.
189    *
190    * approve should be called when allowed[_spender] == 0. To increment
191    * allowed value is better to use this function to avoid 2 calls (and wait until
192    * the first transaction is mined)
193    * From MonolithDAO Token.sol
194    * @param _spender The address which will spend the funds.
195    * @param _addedValue The amount of tokens to increase the allowance by.
196    */
197   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   /**
204    * @dev Decrease the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To decrement
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _subtractedValue The amount of tokens to decrease the allowance by.
212    */
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 // File: contracts/DIW.sol
227 
228 contract DIW is StandardToken, BurnableToken {
229   string public constant name = "DIW Token";
230   string public constant symbol = "DIW";
231   uint8 public constant decimals = 18;
232 
233   function DIW (address _supplier, uint256 _totalSupply) public {
234     totalSupply = _totalSupply;
235     balances[_supplier] = _totalSupply;
236   }
237 }