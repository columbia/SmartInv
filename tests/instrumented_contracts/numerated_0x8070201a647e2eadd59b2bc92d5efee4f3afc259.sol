1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 /**
39  * @title ERC20Basic
40  * @dev Simpler version of ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/179
42  */
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 
50 
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public view returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     // SafeMath.sub will throw if there is not enough balance.
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of.
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111 
112   /**
113    * @dev Transfer tokens from one address to another
114    * @param _from address The address which you want to send tokens from
115    * @param _to address The address which you want to transfer to
116    * @param _value uint256 the amount of tokens to be transferred
117    */
118   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[_from]);
121     require(_value <= allowed[_from][msg.sender]);
122 
123     balances[_from] = balances[_from].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    *
133    * Beware that changing an allowance with this method brings the risk that someone may use both the old
134    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137    * @param _spender The address which will spend the funds.
138    * @param _value The amount of tokens to be spent.
139    */
140   function approve(address _spender, uint256 _value) public returns (bool) {
141     allowed[msg.sender][_spender] = _value;
142     Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Function to check the amount of tokens that an owner allowed to a spender.
148    * @param _owner address The address which owns the funds.
149    * @param _spender address The address which will spend the funds.
150    * @return A uint256 specifying the amount of tokens still available for the spender.
151    */
152   function allowance(address _owner, address _spender) public view returns (uint256) {
153     return allowed[_owner][_spender];
154   }
155 
156   /**
157    * @dev Increase the amount of tokens that an owner allowed to a spender.
158    *
159    * approve should be called when allowed[_spender] == 0. To increment
160    * allowed value is better to use this function to avoid 2 calls (and wait until
161    * the first transaction is mined)
162    * From MonolithDAO Token.sol
163    * @param _spender The address which will spend the funds.
164    * @param _addedValue The amount of tokens to increase the allowance by.
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   /**
173    * @dev Decrease the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To decrement
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _subtractedValue The amount of tokens to decrease the allowance by.
181    */
182   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 
196 /**
197  * @title SimpleToken
198  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
199  * Note they can later distribute these tokens as they wish using `transfer` and other
200  * `StandardToken` functions.
201  */
202 contract SimpleTokenSARAS is StandardToken {
203 
204   string public constant name = "Saras Coin";
205   string public constant symbol = "SARAS";
206   uint8 public constant decimals = 6;
207 
208   uint256 public constant INITIAL_SUPPLY = 6800000000 * (10 ** uint256(decimals));
209 
210   /**
211    * @dev Constructor that gives msg.sender all of existing tokens.
212    */
213   function SimpleTokenSARAS() public {
214     totalSupply = INITIAL_SUPPLY;
215     balances[msg.sender] = INITIAL_SUPPLY;
216   }
217 
218 }