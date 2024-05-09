1 pragma solidity 0.5.8;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
40   function balanceOf(address who) public view returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title Basic token
48  * @dev Basic version of StandardToken, with no allowances.
49  */
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     emit Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public view returns (uint256 balance) {
76     return balances[_owner];
77   }
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public view returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112 
113     uint256 _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     emit Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     emit Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval (address _spender, uint _addedValue) public
158     returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue) public
165     returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 }
176 
177 
178 contract ERC20Token is StandardToken {
179 
180     string public name;
181     string public symbol;
182     uint public decimals;
183     address public owner;
184 
185     // Constructors
186     constructor (
187         address benefeciary, 
188         string memory _name, 
189         string memory _symbol, 
190         uint _totalSupply, 
191         uint _decimals
192     )
193         public
194     {
195         
196         decimals = _decimals;
197         totalSupply = _totalSupply;
198         name = _name;
199         owner = benefeciary;
200         symbol = _symbol;
201         balances[benefeciary] = totalSupply; // Send all tokens to benefeciary
202         emit Transfer(address(0), benefeciary, totalSupply);
203     }
204 
205 }
206 
207 /**
208  * @title Ownable
209  * @dev The Ownable contract has an owner address, and provides basic authorization control
210  * functions, this simplifies the implementation of "user permissions".
211  */
212 contract Ownable {
213   address public owner;
214 
215 
216   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
217 
218 
219   /**
220    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
221    * account.
222    */
223   constructor() public {
224     owner = msg.sender;
225   }
226 
227 
228   /**
229    * @dev Throws if called by any account other than the owner.
230    */
231   modifier onlyOwner() {
232     require(msg.sender == owner);
233     _;
234   }
235 
236 
237   /**
238    * @dev Allows the current owner to transfer control of the contract to a newOwner.
239    * @param newOwner The address to transfer ownership to.
240    */
241   function transferOwnership(address newOwner) public onlyOwner {
242     require(newOwner != address(0));
243     emit OwnershipTransferred(owner, newOwner);
244     owner = newOwner;
245   }
246 }
247 
248 interface token {
249   function transferFrom(address, address, uint) external returns (bool);
250   function balanceOf(address) external returns (uint);
251   function transfer(address, uint) external returns (bool);
252 }
253 
254 contract TokenMaker is Ownable {
255     uint public fee_in_dc_units = 10e18;
256     address public dc_token_address;
257     token dcToken;
258     mapping (address => address[]) public myTokens;
259 
260 
261     function setFee(uint number_of_dc_uints) public onlyOwner {
262         fee_in_dc_units = number_of_dc_uints;
263     }
264 
265     function setDcTokenAddress(address _addr) public onlyOwner {
266       dc_token_address = _addr;
267       dcToken = token(_addr);
268     }
269 
270     function makeToken(string memory _name, string memory _symbol, uint _totalSupply, uint _decimals) public {
271         require(dcToken.transferFrom(msg.sender, address(this), fee_in_dc_units));
272 
273         ERC20Token newToken = new ERC20Token(msg.sender, _name, _symbol, _totalSupply, _decimals);
274         myTokens[msg.sender].push(address(newToken));
275 
276     }
277 
278     function getMyTokens() public view returns (address[] memory) {
279       return myTokens[msg.sender];
280     }
281 
282     function withdrawTokens() public onlyOwner {
283       dcToken.transfer(msg.sender, dcToken.balanceOf(address(this)));
284     }
285 }