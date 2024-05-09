1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 contract Ownable {
43   address public owner;
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 }
71 contract ERC20Basic {
72   function totalSupply() public view returns (uint256);
73   function balanceOf(address who) public view returns (uint256);
74   function transfer(address to, uint256 value) public returns (bool);
75   event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 contract ERC20 is ERC20Basic {
79   function allowance(address owner, address spender) public view returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 contract TOKToken is ERC20, Ownable {
86 
87   using SafeMath for uint256;
88 
89   string public name;
90   string public symbol;
91   uint8 public decimals;
92   uint256 totalSupply_;
93   bool public paused;
94   // record balances of accounts
95   mapping(address => uint256) balances;
96   // record allowance of accounts
97   mapping (address => mapping (address => uint256)) internal allowed;
98 
99 
100   modifier onlyUnpaused() {
101     require(!paused);
102     _;
103    }
104 
105   /**
106   * @dev constructor of the token
107   */
108   function TOKToken() public {
109     name = 'Token of TOK';
110     symbol = 'TOK';
111     decimals = 6;
112     totalSupply_ = 10000000000000000;
113     balances[msg.sender] = totalSupply_;
114 
115   }
116   /**
117   * @dev total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public onlyUnpaused returns (bool) {
129     // Check if the sender has enough
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     // SafeMath.sub will throw if there is not enough balance.
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256 balance) {
146     return balances[_owner];
147   }
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public onlyUnpaused returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public onlyUnpaused returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public  view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public onlyUnpaused returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public onlyUnpaused returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   function pause() public onlyOwner returns (bool) {
231      paused = true;
232      return true;
233    }
234 
235    function unPause() public onlyOwner returns (bool) {
236      paused = false;
237      return true;
238   }
239 }