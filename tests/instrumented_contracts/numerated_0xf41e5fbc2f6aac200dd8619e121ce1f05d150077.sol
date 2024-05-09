1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
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
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) allowed;
112 
113 
114   /**
115    * @dev Transfer tokens from one address to another
116    * @param _from address The address which you want to send tokens from
117    * @param _to address The address which you want to transfer to
118    * @param _value uint256 the amount of tokens to be transferred
119    */
120   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122 
123     uint256 _allowance = allowed[_from][msg.sender];
124 
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127 
128     balances[_from] = balances[_from].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     allowed[_from][msg.sender] = _allowance.sub(_value);
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
157   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
158     return allowed[_owner][_spender];
159   }
160 
161   /**
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    */
167   function increaseApproval (address _spender, uint _addedValue)
168     returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval (address _spender, uint _subtractedValue)
175     returns (bool success) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 
189 
190 /**
191  * @title CryCashToken
192  */
193 contract CryCashToken is StandardToken {
194 
195   using SafeMath for uint256;
196 
197   /**
198   * Initial token state
199   **/
200 
201   string public constant name = "CryCash Token";
202   string public constant symbol = "CRC";
203   uint8 public constant decimals = 18;
204 
205   uint256 public constant INITIAL_SUPPLY = 0;
206   address public ico;
207 
208   /////
209 
210   event Mint(address indexed to, uint256 amount);
211   event MintFinished();
212 
213   bool public mintingFinished = false;
214 
215   modifier canMint() {
216     require(!mintingFinished);
217     _;
218   }
219 
220   /**
221    * @dev Constructor for creatte token.
222    */
223   function CryCashToken(address _ico) public {
224     totalSupply = INITIAL_SUPPLY;
225     balances[msg.sender] = INITIAL_SUPPLY;
226     ico = _ico;
227   }
228 
229   /**
230    * @dev Function to mint tokens for ico contract
231    * @param _to The address that will receive the minted tokens.
232    * @param _amount The amount of tokens to mint.
233    * @return A boolean that indicates if the operation was successful.
234    */
235   function mint(address _to, uint256 _amount) canMint public returns (bool) {
236     require(msg.sender == ico);
237     require(_amount != 0);
238 
239     totalSupply = totalSupply.add(_amount);
240     balances[_to] = balances[_to].add(_amount);
241     Mint(_to, _amount);
242     Transfer(0x0, _to, _amount);
243     return true;
244   }
245 
246   function finishMinting() public returns (bool) {
247     require(msg.sender == ico);
248     
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 }