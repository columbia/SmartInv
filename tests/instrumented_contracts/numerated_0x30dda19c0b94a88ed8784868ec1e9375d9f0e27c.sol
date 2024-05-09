1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * @dev https://github.com/ethereum/EIPs/issues/20
108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    */
165   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182 }
183 
184 /**
185  * @title Spade PreSale Token
186  */
187 contract DSPXToken is StandardToken {
188 
189   string public constant name = "SP8DE PreSale Token";
190   string public constant symbol = "DSPX";
191   uint8 public constant decimals = 18;
192   address public preSale;
193   address public team;
194   bool public isFrozen = true;  
195   uint public constant TOKEN_LIMIT = 888888888 * (1e18);
196 
197   // Constructor
198   function DSPXToken(address _preSale, address _team) {
199       require(_preSale != address(0));
200       require(_team != address(0));
201       preSale = _preSale;
202       team = _team;
203   }
204 
205   // Create tokens
206   function mint(address holder, uint value) {
207     require(msg.sender == preSale);
208     require(value > 0);
209     require(totalSupply + value <= TOKEN_LIMIT);
210 
211     balances[holder] += value;
212     totalSupply += value;
213     Transfer(0x0, holder, value);
214   }
215 
216   // Allow token transfer
217   function unfreeze() external {
218       require(msg.sender == team);
219       isFrozen = false;
220   }
221 
222   // ERC20 functions
223   // =========================
224   function transfer(address _to, uint _value) public returns (bool) {
225       require(!isFrozen);
226       return super.transfer(_to, _value);
227   }
228 
229   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
230       require(!isFrozen);
231       return super.transferFrom(_from, _to, _value);
232   }
233 
234   function approve(address _spender, uint _value) public returns (bool) {
235       require(!isFrozen);
236       return super.approve(_spender, _value);
237   }
238 }