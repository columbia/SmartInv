1 /**
2  *Submitted for verification at Etherscan.io on 2018-08-16
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 library SafeMath {
8 
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
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   uint256 totalSupply_;
67 
68   /**
69   * @dev total number of tokens in existence
70   */
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[msg.sender]);
83 
84     balances[msg.sender] = balances[msg.sender].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     emit Transfer(msg.sender, _to, _value);
87     return true;
88   }
89 
90   /**
91   * @dev Gets the balance of the specified address.
92   * @param _owner The address to query the the balance of.
93   * @return An uint256 representing the amount owned by the passed address.
94   */
95   function balanceOf(address _owner) public view returns (uint256 balance) {
96     return balances[_owner];
97   }
98 
99 }
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
126     emit Transfer(_from, _to, _value);
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
142     emit Approval(msg.sender, _spender, _value);
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
168     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 /**
196  * @title Burnable Token
197  * @dev Token that can be irreversibly burned (destroyed).
198  */
199 contract BurnableToken is BasicToken {
200 
201   event Burn(address indexed burner, uint256 value);
202 
203   /**
204    * @dev Burns a specific amount of tokens.
205    * @param _value The amount of token to be burned.
206    */
207   function burn(uint256 _value) public {
208     require(_value <= balances[msg.sender]);
209     // no need to require value <= totalSupply, since that would imply the
210     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
211 
212     address burner = msg.sender;
213     balances[burner] = balances[burner].sub(_value);
214     totalSupply_ = totalSupply_.sub(_value);
215     emit Burn(burner, _value);
216     emit Transfer(burner, address(0), _value);
217   }
218 }
219 
220 /** 
221  * Detailed
222  */
223 contract MyCoin is StandardToken,BurnableToken {
224     string public name = "IMHT";
225     string public symbol = "IMHT";
226     uint256 public decimals = 18;
227     uint256 public INITIAL_SUPPLY = 50000000 * (10 ** uint256(decimals));
228 
229     function MyCoin() public {
230         totalSupply_ = INITIAL_SUPPLY;
231         balances[msg.sender] = INITIAL_SUPPLY;
232         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
233     }
234 }