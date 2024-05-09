1 pragma solidity ^0.4.21;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26         uint256 c = a * b;
27         assert(c / a == b);
28         return c;
29     }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57 }
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63     using SafeMath for uint256;
64 
65     mapping(address => uint256) balances;
66 
67     uint256 totalSupply_;
68 
69     /**
70     * @dev total number of tokens in existence
71     */
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         // SafeMath.sub will throw if there is not enough balance.
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         emit Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101 }
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107     function allowance(address owner, address spender) public view returns (uint256);
108     function transferFrom(address from, address to, uint256 value) public returns (bool);
109     function approve(address spender, uint256 value) public returns (bool);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 contract DetailedERC20 is ERC20 {
113     string public name;
114     string public symbol;
115     uint8 public decimals;
116 
117     function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
118         name = _name;
119         symbol = _symbol;
120         decimals = _decimals;
121     }
122 }
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is DetailedERC20, BasicToken {
131 
132     mapping (address => mapping (address => uint256)) internal allowed;
133 
134     function StandardToken(string _name, string _symbol, uint8 _decimals) DetailedERC20(_name, _symbol, _decimals) public { }
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144         require(_to != address(0));
145         require(_value <= balances[_from]);
146         require(_value <= allowed[_from][msg.sender]);
147 
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151         emit Transfer(_from, _to, _value);
152         return true;
153     }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165     function approve(address _spender, uint256 _value) public returns (bool) {
166         allowed[msg.sender][_spender] = _value;
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177     function allowance(address _owner, address _spender) public view returns (uint256) {
178         return allowed[_owner][_spender];
179     }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194         return true;
195     }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217 
218 }
219 /**
220  * @title Burnable Token
221  * @dev Token that can be irreversibly burned (destroyed).
222  */
223 contract BurnableToken is BasicToken {
224 
225     event Burn(address indexed burner, uint256 value);
226 
227   /**
228    * @dev Burns a specific amount of tokens.
229    * @param _value The amount of token to be burned.
230    */
231     function burn(uint256 _value) public {
232         require(_value <= balances[msg.sender]);
233         // no need to require value <= totalSupply, since that would imply the
234         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
235 
236         address burner = msg.sender;
237         balances[burner] = balances[burner].sub(_value);
238         totalSupply_ = totalSupply_.sub(_value);
239         emit Burn(burner, _value);
240         emit Transfer(burner, address(0), _value);
241     }
242 }
243 contract Taur is StandardToken, BurnableToken {
244 
245     string NAME = "Taurus0x"; 
246     string SYMBOL = "TAUR";
247     uint8 DECIMALS = 18;
248     uint public INITIAL_SUPPLY = 250000000;
249 
250     function Taur() StandardToken(NAME, SYMBOL, DECIMALS) public {
251         totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(DECIMALS));
252         balances[msg.sender] = totalSupply_;
253     }
254 }