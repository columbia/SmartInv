1 pragma solidity ^0.4.21;
2 
3 // File: contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12  
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28  
29 }
30 
31 // File: contracts/math/SafeMath.sol
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38 
39   /**
40   * @dev Multiplies two numbers, throws on overflow.
41   */
42   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     if (a == 0) {
44       return 0;
45     }
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 // File: contracts/token/ERC20/ERC20Basic.sol
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 // File: contracts/token/ERC20/BasicToken.sol
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint256;
101 
102   mapping(address => uint256) balances;
103 
104   uint256 totalSupply_;
105 
106   /**
107   * @dev total number of tokens in existence
108   */
109   function totalSupply() public view returns (uint256) {
110     return totalSupply_;
111   }
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     emit Transfer(msg.sender, _to, _value);
125     return true;
126   }
127 
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of.
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) public view returns (uint256) {
134     return balances[_owner];
135   }
136 
137 }
138 
139  
140 
141 // File: contracts/token/ERC20/ERC20.sol
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender) public view returns (uint256);
149   function transferFrom(address from, address to, uint256 value) public returns (bool);
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(address indexed owner, address indexed spender, uint256 value);
152 }
153 
154 // File: contracts/token/ERC20/StandardToken.sol
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(address _owner, address _spender) public view returns (uint256) {
209     return allowed[_owner][_spender];
210   }
211 
212   /**
213    * @dev Increase the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   /**
229    * @dev Decrease the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 contract yupay is StandardToken, Ownable {
252     // Constants
253     string  public constant name = "YunPay Token";
254     string  public constant symbol = "yupay";
255     uint8   public constant decimals = 18;
256     uint256 public constant INITIAL_SUPPLY      = 500000000 * (10 ** uint256(decimals));
257     uint256 public constant FREE_SUPPLY         = 200000000 * (10 ** uint256(decimals));
258 
259     uint256 public nextFreeCount = 6000 * (10 ** uint256(decimals)) ;
260     uint256 public constant decr = 1125 * (10 ** 14) ;
261     
262     mapping(address => bool) touched;
263  
264 
265     constructor() public {
266       totalSupply_ = INITIAL_SUPPLY;
267 
268       balances[address(this)] = FREE_SUPPLY;
269       emit Transfer(0x0, address(this), FREE_SUPPLY);
270 
271       balances[msg.sender] = INITIAL_SUPPLY - FREE_SUPPLY;
272       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY - FREE_SUPPLY);
273     }
274 
275     function _transfer(address _from, address _to, uint _value) internal {     
276         require (balances[_from] >= _value);               // Check if the sender has enough
277         require (balances[_to] + _value > balances[_to]); // Check for overflows
278    
279         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
280         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
281          
282         emit Transfer(_from, _to, _value);
283     }
284  
285     function () external payable {
286         if (!touched[msg.sender] )
287         {
288           touched[msg.sender] = true;
289           _transfer(address(this), msg.sender, nextFreeCount ); 
290           nextFreeCount = nextFreeCount - decr;
291         }
292     }
293 
294    
295     function safeWithdrawal(uint _value ) onlyOwner public {
296        if (_value == 0) 
297            owner.transfer(address(this).balance);
298        else
299            owner.transfer(_value);
300     }
301 
302 }