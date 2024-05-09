1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   /**
44   * @dev Integer division of two numbers, truncating the quotient.
45   */
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   /**
54   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55   */
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   /**
62   * @dev Adds two numbers, throws on overflow.
63   */
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     // SafeMath.sub will throw if there is not enough balance.
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint256 representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) public view returns (uint256 balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 
120 
121 
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) public view returns (uint256);
129   function transferFrom(address from, address to, uint256 value) public returns (bool);
130   function approve(address spender, uint256 value) public returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint256 value);
132 }
133 
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * @dev https://github.com/ethereum/EIPs/issues/20
141  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20, BasicToken {
144 
145   mapping (address => mapping (address => uint256)) internal allowed;
146 
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(address _owner, address _spender) public view returns (uint256) {
189     return allowed[_owner][_spender];
190   }
191 
192   /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    *
211    * approve should be called when allowed[_spender] == 0. To decrement
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    * @param _spender The address which will spend the funds.
216    * @param _subtractedValue The amount of tokens to decrease the allowance by.
217    */
218   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 
232 contract TRIPToken is StandardToken {
233 	string public name = "trip token"; 
234 	string public symbol = "TRIP";
235 	uint public decimals = 18;
236 	uint public INITIAL_SUPPLY = 100000000 * (10 ** decimals);
237 	
238 	function TRIPToken() public {
239 		totalSupply_ = INITIAL_SUPPLY;
240 		balances[msg.sender] = INITIAL_SUPPLY;
241 	}
242 }