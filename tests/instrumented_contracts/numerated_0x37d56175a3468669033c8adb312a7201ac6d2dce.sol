1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80   
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transferWithoutDecimals(address _to, uint256 _value) public returns (bool) {
87     uint256 tokensNumber = _value.mul(10**18);
88   
89     require(_to != address(0));
90     require(tokensNumber <= balances[msg.sender]);
91 
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(tokensNumber);
94     balances[_to] = balances[_to].add(tokensNumber);
95     Transfer(msg.sender, _to, tokensNumber);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 /**
111  * @title Standard ERC20 token
112  *
113  * @dev Implementation of the basic standard token.
114  * @dev https://github.com/ethereum/EIPs/issues/20
115  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    *
143    * Beware that changing an allowance with this method brings the risk that someone may use both the old
144    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) public returns (bool) {
151     allowed[msg.sender][_spender] = _value;
152     Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 
166   /**
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    */
172   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
173     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 
192 /**
193  * @title Burnable Token
194  * @dev Token that can be irreversibly burned (destroyed).
195  */
196 contract BurnableToken is StandardToken {
197 
198     event Burn(address indexed burner, uint256 value);
199 
200     /**
201      * @dev Burns a specific amount of tokens.
202      * @param _value The amount of token to be burned.
203      */
204     function burn(uint256 _value) public {
205         require(_value > 0);
206         require(_value <= balances[msg.sender]);
207         // no need to require value <= totalSupply, since that would imply the
208         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
209 
210         address burner = msg.sender;
211         balances[burner] = balances[burner].sub(_value);
212         totalSupply = totalSupply.sub(_value);
213         Burn(burner, _value);
214     }
215 }
216 
217 
218 
219 /**
220  * @title SimpleToken
221  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
222  * Note they can later distribute these tokens as they wish using `transfer` and other
223  * `StandardToken` functions.
224  */
225 contract GlobexSci is BurnableToken {
226 
227   string public constant name = "GlobexSci";
228   string public constant symbol = "GSI";
229   uint8 public constant decimals = 18;
230 
231   uint256 public constant INITIAL_SUPPLY = 43500000 * (10 ** uint256(decimals));
232 
233   /**
234    * @dev Constructor that gives msg.sender all of existing tokens.
235    */
236   function GlobexSci() {
237     totalSupply = INITIAL_SUPPLY;
238     balances[msg.sender] = INITIAL_SUPPLY;
239   }
240   
241 }