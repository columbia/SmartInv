1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a / b;
22     return c;
23   }
24 
25   /**
26   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address who) public view returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88 
89   mapping(address => uint256) balances;
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     // SafeMath.sub will throw if there is not enough balance.
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256 balance) {
121     return balances[_owner];
122   }
123 }
124 
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 contract StandardToken is ERC20, BasicToken {
133   mapping (address => mapping (address => uint256)) internal allowed;
134   address owner;
135 
136   modifier onlyOwner() {
137     require(msg.sender == owner);
138     _;
139   }
140   
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149     require(_value <= balances[_from]);
150     require(_value <= allowed[_from][msg.sender]);
151 
152     balances[_from] = balances[_from].sub(_value);
153     balances[_to] = balances[_to].add(_value);
154     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
155     emit Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    *
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint256 _value) public returns (bool) {
170     allowed[msg.sender][_spender] = _value;
171     emit Approval(msg.sender, _spender, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifying the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) public view returns (uint256) {
182     return allowed[_owner][_spender];
183   }
184 
185   /**
186    * @dev Increase the amount of tokens that an owner allowed to a spender.
187    *
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param _spender The address which will spend the funds.
193    * @param _addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   /**
202    * @dev Decrease the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To decrement
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _subtractedValue The amount of tokens to decrease the allowance by.
210    */
211   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
212     uint oldValue = allowed[msg.sender][_spender];
213     if (_subtractedValue > oldValue) {
214       allowed[msg.sender][_spender] = 0;
215     } else {
216       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
217     }
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 }
222 
223 contract TokenBankToken is StandardToken{
224   string public name = "TokenBankToken";
225   string public symbol = "TBT";
226   uint8 public decimals = 6;
227   constructor(address _address) public {
228     owner = msg.sender;
229     totalSupply_ = 1000000000000000;
230     balances[_address] = totalSupply_;
231   }
232 }