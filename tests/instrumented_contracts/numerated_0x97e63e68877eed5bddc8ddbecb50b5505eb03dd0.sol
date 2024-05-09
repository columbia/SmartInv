1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ImmVRse token contract
5 //
6 // Deployed to : 0x448858e6DB8E2e72De3593CbeC326dEdBA085A13
7 // Symbol      : IMV
8 // Name        : ImmVRseToken
9 // Total supply: 300000000000000000000000000
10 // Decimals    : 18
11 // ----------------------------------------------------------------------------
12 
13 contract owned {
14     address public owner;
15 
16     function owned() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) onlyOwner public {
26         owner = newOwner;
27     }
28 }
29 
30 /**
31  * @title ERC20Basic
32  * @dev Simpler version of ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/179
34  */
35  
36 contract ERC20Basic is owned {
37   uint256 public totalSupply;
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 /**
44  * @title ERC20 interface
45  * @dev see https://github.com/ethereum/EIPs/issues/20
46  */
47  
48 contract ERC20 is ERC20Basic {
49   function allowance(address owner, address spender) public view returns (uint256);
50   function transferFrom(address from, address to, uint256 value) public returns (bool);
51   function approve(address spender, uint256 value) public returns (bool);
52   event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59  
60  
61 library SafeMath {
62   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63     if (a == 0) {
64       return 0;
65     }
66     uint256 c = a * b;
67     assert(c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal pure returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances.
93  */
94 
95 
96 contract BasicToken is ERC20 {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 /**
129  * @title Burnable Token
130  * @dev Token that can be irreversibly burned (destroyed). 
131  */
132  
133 contract BurnableToken is BasicToken {
134 
135     event Burn(address indexed burner, uint256 value);
136 
137     /**
138      * @dev Burns a specific amount of tokens.
139      * @param _value The amount of token to be burned.
140      */
141     function burn(uint256 _value) public {
142         require(_value <= balances[msg.sender]);
143         // Only unsold tokens will be burned irreversibly
144         // no need to require value <= totalSupply, since that would imply the
145         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
146 
147         address burner = msg.sender;
148         balances[burner] = balances[burner].sub(_value);
149         totalSupply = totalSupply.sub(_value);
150         Burn(burner, _value);
151     }
152 }
153 
154 contract DetailedERC20 is BurnableToken {
155   string public name;
156   string public symbol;
157   uint8 public decimals;
158   
159   /* This creates an array with all balances */
160   mapping (address => uint256) public balanceOf;
161 
162   function DetailedERC20() public {
163     balanceOf[msg.sender] = 300000000000000000000000000;
164     totalSupply = 300000000000000000000000000;
165     name = 'ImmVRseToken';
166     symbol = 'IMV';
167     decimals = 18;
168   }
169 }
170 
171 /**
172  * @title Standard ERC20 token
173  *
174  * @dev Implementation of the basic standard token.
175  * @dev https://github.com/ethereum/EIPs/issues/20
176  */
177 
178 
179 contract ImmVRseToken is DetailedERC20 {
180 
181   mapping (address => mapping (address => uint256)) internal allowed;
182 
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
191     require(_to != address(0));
192     require(_value <= balances[_from]);
193     require(_value <= allowed[_from][msg.sender]);
194 
195     balances[_from] = balances[_from].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198     Transfer(_from, _to, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    *
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(address _owner, address _spender) public view returns (uint256) {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
239     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244   /**
245    * @dev Decrease the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
255     uint oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265 }