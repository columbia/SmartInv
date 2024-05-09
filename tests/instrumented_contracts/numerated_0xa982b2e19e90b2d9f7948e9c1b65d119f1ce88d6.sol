1 pragma solidity 0.5.12;
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41   address public pendingOwner;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor () public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Throws if called by any account other than the pendingOwner.
65    */
66   modifier onlyPendingOwner() {
67     assert(msg.sender != address(0));
68     require(msg.sender == pendingOwner);
69     _;
70   }
71 
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     pendingOwner = newOwner;
80   }
81   
82   /**
83    * @dev Allows the pendingOwner address to finalize the transfer.
84    */
85   function claimOwnership() onlyPendingOwner public {
86     emit OwnershipTransferred(owner, pendingOwner);
87     owner = pendingOwner;
88     pendingOwner = address(0);
89   }
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) internal balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0) && _to != address(this));
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     emit Transfer(msg.sender, _to, _value);
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
137 }
138 
139 /**
140  * @title ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/20
142  */
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender) public view returns (uint256);
145   function transferFrom(address from, address to, uint256 value) public returns (bool);
146   function approve(address spender, uint256 value) public returns (bool);
147   event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) internal allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amount of tokens to be transferred
167    */
168   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0) && _to != address(this));
170 
171     uint256 _allowance = allowed[_from][msg.sender];
172 
173     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
174     // require (_value <= _allowance);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = _allowance.sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
206     return allowed[_owner][_spender];
207   }
208 
209   /**
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    */
214   function increaseApproval (address _spender, uint _addedValue)
215     public
216     returns (bool success) {
217     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   function decreaseApproval (address _spender, uint _subtractedValue)
223     public
224     returns (bool success) {
225     uint oldValue = allowed[msg.sender][_spender];
226     if (_subtractedValue > oldValue) {
227       allowed[msg.sender][_spender] = 0;
228     } else {
229       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230     }
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 }
235 
236 
237 interface tokenRecipient { 
238     function receiveApproval(address _from, uint256 _value, bytes calldata _extraData) external;
239 }
240 
241 contract WOMToken is StandardToken, Ownable {
242 
243     string public constant name = "WOM Token";
244     string public constant symbol = "WOM";
245     uint public constant decimals = 18;
246     // there is no problem in using * here instead of .mul()
247     uint256 public constant initialSupply = 1000000000 * (10 ** uint256(decimals));
248 
249     // Constructors
250     constructor () public {
251         totalSupply = initialSupply;
252         balances[msg.sender] = initialSupply; // Send all tokens to owner
253         emit Transfer(address(0), msg.sender, initialSupply);
254     }
255 
256     // this function allows one step transfer to contract
257     function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)
258         external
259         returns (bool success) 
260     {
261         tokenRecipient spender = tokenRecipient(_spender);
262         if (approve(_spender, _value)) {
263             spender.receiveApproval(msg.sender, _value, _extraData);
264             return true;
265         }
266     }
267 
268     // the below function allows admin to transfer out any 
269     // mistakenly sent ERC20 Tokens to `address(this)` 
270     // (the address of this smart contract)
271     function transferAnyERC20Token(address _tokenAddr, address _toAddr, uint _tokenAmount) public onlyOwner {
272       ERC20(_tokenAddr).transfer(_toAddr, _tokenAmount);
273     }
274 }