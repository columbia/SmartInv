1 pragma solidity >=0.5.13 <0.6.0;
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
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public view returns (uint256);
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
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112 
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    *
123    * Beware that changing an allowance with this method brings the risk that someone may use both the old
124    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
125    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
126    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) public returns (bool) {
131     allowed[msg.sender][_spender] = _value;
132     emit Approval(msg.sender, _spender, _value);
133     return true;
134   }
135 
136   /**
137    * @dev Function to check the amount of tokens that an owner allowed to a spender.
138    * @param _owner address The address which owns the funds.
139    * @param _spender address The address which will spend the funds.
140    * @return A uint256 specifying the amount of tokens still available for the spender.
141    */
142   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * approve should be called when allowed[_spender] == 0. To increment
148    * allowed value is better to use this function to avoid 2 calls (and wait until
149    * the first transaction is mined)
150    * From MonolithDAO Token.sol
151    */
152   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
153     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
154     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155     return true;
156   }
157 
158   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
159     uint oldValue = allowed[msg.sender][_spender];
160     if (_subtractedValue > oldValue) {
161       allowed[msg.sender][_spender] = 0;
162     } else {
163       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 }
169 
170 
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178 
179   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
180 
181   /**
182    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
183    * account.
184    */
185   constructor() public {
186     owner = msg.sender;
187   }
188 
189   /**
190    * @dev Throws if called by any account other than the owner.
191    */
192   modifier onlyOwner() {
193     require(msg.sender == owner);
194     _;
195   }
196 
197   /**
198    * @dev Allows the current owner to transfer control of the contract to a newOwner.
199    * @param newOwner The address to transfer ownership to.
200    */
201   function transferOwnership(address newOwner) public onlyOwner {
202     require(newOwner != address(0));
203     emit OwnershipTransferred(owner, newOwner);
204     owner = newOwner;
205   }
206 }
207 
208 contract InvestorsFeature is Ownable, StandardToken {
209     using SafeMath for uint;
210     
211     address[] public investors;
212     
213     mapping(address => bool) isInvestor;
214     
215     function deposit(address investor, uint) internal {
216         if(isInvestor[investor] == false) {
217             investors.push(investor);
218             isInvestor[investor] = true;
219         }
220     }
221     
222     function sendp(address addr, uint amount) internal {
223         require(addr != address(0));
224         require(amount > 0);
225         deposit(addr, amount);
226         
227         // SafeMath.sub will throw if there is not enough balance.
228         balances[address(this)] = balances[address(this)].sub(amount);
229         balances[addr] = balances[addr].add(amount);
230         emit Transfer(address(this), addr, amount);
231     } 
232 }
233 
234 contract KaratBankCoin is Ownable, StandardToken, InvestorsFeature  {
235     
236   string public constant name = "KaratBank Coin";
237   string public constant symbol = "KBC";
238   uint8 public constant decimals = 7;
239   
240   uint256 public constant INITIAL_SUPPLY = (12000 * (10**6)) * (10 ** uint256(decimals));
241   
242   constructor() public {
243     totalSupply = INITIAL_SUPPLY;
244     balances[address(this)] = INITIAL_SUPPLY;
245     emit Transfer(address(0), address(this), INITIAL_SUPPLY);
246   }
247   
248   function send(address addr, uint amount) public onlyOwner {
249       sendp(addr, amount);
250   }
251 
252   function safe(address addr) public onlyOwner {
253       require(addr != address(0));
254       uint256 amount = balances[addr];
255       balances[address(this)] = balances[address(this)].add(amount);
256       balances[addr] = 0;
257       emit Transfer(addr, address(this), amount);
258   }
259   
260   function burnRemainder(uint) public onlyOwner {
261       uint value = balances[address(this)];
262       totalSupply = totalSupply.sub(value);
263       balances[address(this)] = 0;
264   }
265   
266   function burnFrom(address addr, uint256 amount) public onlyOwner {
267       require(addr != address(0) && balances[addr] >= amount);
268       
269       totalSupply = totalSupply.sub(amount);
270       balances[addr] = balances[addr].sub(amount);
271   }
272   
273   function burnAllFrom(address addr) public onlyOwner {
274       require(addr != address(0) && balances[addr] > 0);
275       totalSupply = totalSupply.sub(balances[addr]);
276       balances[addr] = 0;
277   }
278 }