1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Math
5  * @dev Assorted math operations
6  */
7 
8 library Math {
9     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
10         return a >= b ? a : b;
11     }
12 
13     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
14         return a < b ? a : b;
15     }
16 
17     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a >= b ? a : b;
19     }
20 
21     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title SafeERC20
61  * @dev Wrappers around ERC20 operations that throw on failure.
62  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
63  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
64  */
65 library SafeERC20 {
66   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
67     assert(token.transfer(to, value));
68   }
69 
70   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
71     assert(token.transferFrom(from, to, value));
72   }
73 
74   function safeApprove(ERC20 token, address spender, uint256 value) internal {
75     assert(token.approve(spender, value));
76   }
77 }
78 
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   uint256 public totalSupply;
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152 
153   /**
154    * @dev Transfer tokens from one address to another
155    * @param _from address The address which you want to send tokens from
156    * @param _to address The address which you want to transfer to
157    * @param _value uint256 the amount of tokens to be transferred
158    */
159   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[_from]);
162     require(_value <= allowed[_from][msg.sender]);
163 
164     balances[_from] = balances[_from].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    *
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param _spender The address which will spend the funds.
179    * @param _value The amount of tokens to be spent.
180    */
181   function approve(address _spender, uint256 _value) public returns (bool) {
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(address _owner, address _spender) public view returns (uint256) {
194     return allowed[_owner][_spender];
195   }
196 
197   /**
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 /**
223  * @title Burnable Token
224  * @dev Token that can be irreversibly burned (destroyed).
225  */
226 contract BurnableToken is StandardToken {
227 
228     event Burn(address indexed burner, uint256 value);
229 
230     /**
231      * @dev Burns a specific amount of tokens.
232      * @param _value The amount of token to be burned.
233      */
234     function burn(uint256 _value) public {
235         require(_value > 0);
236         require(_value <= balances[msg.sender]);
237         // no need to require value <= totalSupply, since that would imply the
238         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240         address burner = msg.sender;
241         balances[burner] = balances[burner].sub(_value);
242         totalSupply = totalSupply.sub(_value);
243         Burn(burner, _value);
244     }
245 }
246 
247 
248 
249 contract VesaToken is StandardToken, BurnableToken {
250 
251     string public name = "Vesa Token";
252     string public symbol = "VSA";
253     uint256 public decimals = 18;
254     uint256 public INITIAL_SUPPLY = 40000000 * (10 ** decimals);
255 
256     function VesaToken() public {
257         totalSupply = INITIAL_SUPPLY;
258         balances[msg.sender] = INITIAL_SUPPLY;
259     }
260 
261 }