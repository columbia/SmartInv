1 pragma solidity ^0.4.18;
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
90 // File: zeppelin-solidity/contracts/token/ERC20.sol
91 
92 /**
93  * @title ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: zeppelin-solidity/contracts/token/StandardToken.sol
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117   /**
118    * @dev Transfer tokens from one address to another
119    * @param _from address The address which you want to send tokens from
120    * @param _to address The address which you want to transfer to
121    * @param _value uint256 the amount of tokens to be transferred
122    */
123   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126     require(_value <= allowed[_from][msg.sender]);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137    *
138    * Beware that changing an allowance with this method brings the risk that someone may use both the old
139    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Function to check the amount of tokens that an owner allowed to a spender.
153    * @param _owner address The address which owns the funds.
154    * @param _spender address The address which will spend the funds.
155    * @return A uint256 specifying the amount of tokens still available for the spender.
156    */
157   function allowance(address _owner, address _spender) public view returns (uint256) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * @dev Increase the amount of tokens that an owner allowed to a spender.
163    *
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    * @param _spender The address which will spend the funds.
169    * @param _addedValue The amount of tokens to increase the allowance by.
170    */
171   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177   /**
178    * @dev Decrease the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To decrement
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _subtractedValue The amount of tokens to decrease the allowance by.
186    */
187   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
188     uint oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue > oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 
200 // File: contracts/hodlcoin.sol
201 
202 contract HODLCoin is StandardToken {
203   using SafeMath for *;
204 
205   event Deposit(address indexed account, uint etherValue, uint tokenValue);
206   event Withdrawal(address indexed account, uint etherValue, uint tokenValue);
207 
208   string constant public name = "HODLCoin";
209   string constant public symbol = "HODL";
210   uint8 constant public decimals = 18;
211 
212   uint8 constant DEPOSIT_FEE = 2; // In percent
213   uint8 constant MULTIPLIER = 100; // HODL coins per ether
214 
215   /**
216    * @dev Returns the value in wei of the specified number of HODL tokens.
217    * @param amount The number of HODL tokens the value is for.
218    * @return The value in wei of the tokens.
219    */
220   function value(uint amount) public view returns(uint) {
221     return amount.mul(this.balance).div(totalSupply);
222   }
223 
224   function deposit() public payable {
225     uint amount;
226     // Allocate tokens proportional to the deposit and the current token price
227     if(totalSupply > 0) {
228       amount = totalSupply.mul(msg.value).div(this.balance - msg.value);
229       // Subtract deposit fee
230       amount -= amount.mul(DEPOSIT_FEE).div(100);
231     } else {
232       amount = msg.value.mul(MULTIPLIER);
233     }
234 
235     totalSupply = totalSupply.add(amount);
236     balances[msg.sender] = balances[msg.sender].add(amount);
237     Deposit(msg.sender, msg.value, amount);
238   }
239 
240   function() public payable {
241     deposit();
242   }
243 
244   function withdraw(uint tokens) public {
245     var amount = value(tokens);
246     totalSupply = totalSupply.sub(tokens);
247     balances[msg.sender] = balances[msg.sender].sub(tokens);
248     msg.sender.transfer(amount);
249     Withdrawal(msg.sender, amount, tokens);
250   }
251 }