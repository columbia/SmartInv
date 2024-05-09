1 pragma solidity ^0.4.15;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract ERC20Basic {
28   uint256 public totalSupply;
29   function balanceOf(address who) public constant returns (uint256);
30   function transfer(address to, uint256 value) public returns (bool);
31   event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) public constant returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   /**
45   * @dev transfer token for a specified address
46   * @param _to The address to transfer to.
47   * @param _value The amount to be transferred.
48   */
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51 
52     // SafeMath.sub will throw if there is not enough balance.
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   /**
60   * @dev Gets the balance of the specified address.
61   * @param _owner The address to query the the balance of.
62   * @return An uint256 representing the amount owned by the passed address.
63   */
64   function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67 
68 }
69 contract StandardToken is ERC20, BasicToken {
70 
71   mapping (address => mapping (address => uint256)) allowed;
72 
73 
74   /**
75    * @dev Transfer tokens from one address to another
76    * @param _from address The address which you want to send tokens from
77    * @param _to address The address which you want to transfer to
78    * @param _value uint256 the amount of tokens to be transferred
79    */
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82 
83     uint256 _allowance = allowed[_from][msg.sender];
84 
85     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86     // require (_value <= _allowance);
87 
88     balances[_from] = balances[_from].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     allowed[_from][msg.sender] = _allowance.sub(_value);
91     Transfer(_from, _to, _value);
92     return true;
93   }
94 
95   /**
96    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
97    *
98    * Beware that changing an allowance with this method brings the risk that someone may use both the old
99    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
100    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
101    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102    * @param _spender The address which will spend the funds.
103    * @param _value The amount of tokens to be spent.
104    */
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Function to check the amount of tokens that an owner allowed to a spender.
113    * @param _owner address The address which owns the funds.
114    * @param _spender address The address which will spend the funds.
115    * @return A uint256 specifying the amount of tokens still available for the spender.
116    */
117   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
118     return allowed[_owner][_spender];
119   }
120 
121   /**
122    * approve should be called when allowed[_spender] == 0. To increment
123    * allowed value is better to use this function to avoid 2 calls (and wait until
124    * the first transaction is mined)
125    * From MonolithDAO Token.sol
126    */
127   function increaseApproval (address _spender, uint _addedValue)
128     returns (bool success) {
129     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
130     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   function decreaseApproval (address _spender, uint _subtractedValue)
135     returns (bool success) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }
147 contract Ownable {
148   address public owner;
149 
150 
151   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153 
154   /**
155    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156    * account.
157    */
158   function Ownable() {
159     owner = msg.sender;
160   }
161 
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) onlyOwner public {
177     require(newOwner != address(0));
178     OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 contract MintableToken is StandardToken, Ownable {
184   event Mint(address indexed to, uint256 amount);
185   event MintFinished();
186 
187   bool public mintingFinished = false;
188 
189 
190   modifier canMint() {
191     require(!mintingFinished);
192     _;
193   }
194 
195   /**
196    * @dev Function to mint tokens
197    * @param _to The address that will receive the minted tokens.
198    * @param _amount The amount of tokens to mint.
199    * @return A boolean that indicates if the operation was successful.
200    */
201 
202   function mint(address _to, uint256 _amount) 
203   onlyOwner
204   canMint
205   public
206   returns (bool) {
207 
208     totalSupply = totalSupply.add(_amount);
209     balances[_to] = balances[_to].add(_amount);
210     Mint(_to, _amount);
211     Transfer(0x0, _to, _amount);
212     return true;
213   }
214 
215   /**
216    * @dev Function to stop minting new tokens.
217    * @return True if the operation was successful.
218    */
219   function finishMinting() onlyOwner public returns (bool) {
220     mintingFinished = true;
221     MintFinished();
222     return true;
223   }
224 }
225 contract BurnableToken is StandardToken {
226 
227     event Burn(address indexed burner, uint256 value);
228 
229     /**
230      * @dev Burns a specific amount of tokens.
231      * @param _value The amount of token to be burned.
232      */
233     function burn(uint256 _value) public {
234         require(_value > 0);
235 
236         address burner = msg.sender;
237         balances[burner] = balances[burner].sub(_value);
238         totalSupply = totalSupply.sub(_value);
239         Burn(burner, _value);
240     }
241 }
242 contract Fortitude is MintableToken, BurnableToken {
243 	//Token Metadata
244 	string public name = "Fortitude";
245 	string public symbol = "FRT";
246 	uint256 public decimals = 18;
247 
248 }