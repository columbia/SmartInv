1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic, Ownable {
106   using SafeMath for uint256;
107 
108   struct BalancesStruct {
109     uint256 amount;
110     bool exist;
111   }
112   mapping(address => BalancesStruct) balances;
113   address[] addressList;
114 
115   uint256 totalSupply_;
116 
117   function isExist(address accountAddress) internal constant returns(bool exist) {
118       return balances[accountAddress].exist;
119   }
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[msg.sender].amount);
136 
137     // SafeMath.sub will throw if there is not enough balance.
138     balances[msg.sender].amount = balances[msg.sender].amount.sub(_value);
139     balances[_to].amount = balances[_to].amount.add(_value);
140     if(!isExist(_to) && _to != owner){
141       balances[_to].exist = true;
142       addressList.push(_to);
143     }
144     emit Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return balances[_owner].amount;
155   }
156 
157 }
158 
159 /**
160  * @title ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/20
162  */
163 contract ERC20 is ERC20Basic {
164   function allowance(address owner, address spender) public view returns (uint256);
165   function transferFrom(address from, address to, uint256 value) public returns (bool);
166   function approve(address spender, uint256 value) public returns (bool);
167   event Approval(address indexed owner, address indexed spender, uint256 value);
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from].amount);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from].amount = balances[_from].amount.sub(_value);
193     balances[_to].amount = balances[_to].amount.add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(address _owner, address _spender) public view returns (uint256) {
218     return allowed[_owner][_spender];
219   }
220 
221   /**
222    * @dev Increase the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To increment
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _addedValue The amount of tokens to increase the allowance by.
230    */
231   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237   /**
238    * @dev Decrease the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 contract PeopleSeedCapitalCoin is StandardToken {
260   string public symbol;
261   string public  name;
262   uint8 constant public decimals = 18;
263   function PeopleSeedCapitalCoin() public {
264     symbol = "PSCC";
265     name = "People Seed Capital Coin";
266     totalSupply_ = 10 * 10000 * 10000 * 10**uint(decimals);
267     balances[msg.sender].amount = totalSupply_;
268   }
269 
270     // ------------------------------------------------------------------------
271     // Don't accept ETH
272     // ------------------------------------------------------------------------
273     function () public payable {
274         revert();
275     }
276 }