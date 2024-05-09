1 pragma solidity ^0.4.18;
2 
3 
4 //HARDCAP:73000 ETH
5 //SOFTCAP:2400 ETH
6 //BONUSES
7 //1ST PHASE : 40%
8 //2ND PHASE : 35%
9 //3RD PHASE : 25%
10 //PRICE 500 TOKENS PER ETHER
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18   /**
19   * @dev Multiplies two numbers, throws on overflow.
20   */
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     //owner = 0x01D5b223873F254751BE548ea1E06a9118693e72;
76     owner=msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public view returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   mapping(address => uint256) balances;
130 
131   uint256 totalSupply_;
132 
133   /**
134   * @dev total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * @dev https://github.com/ethereum/EIPs/issues/20
172  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 }
260 
261 contract PTRT is StandardToken, Ownable {
262     
263   string public name;
264   string public symbol;
265   uint8 public decimals;
266   uint256 public initialSupply;
267 
268   constructor() public {
269     name = 'PLACETORENT';
270     symbol = 'PTRT';
271     decimals = 14;
272     initialSupply = 100000000 * 10 ** uint256(decimals);
273     totalSupply_ = initialSupply;
274     balances[owner] = initialSupply;
275     emit Transfer(0x0, owner, initialSupply);
276   }
277 }