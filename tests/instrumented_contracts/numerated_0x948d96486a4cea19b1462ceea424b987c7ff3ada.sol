1 /**
2  *Submitted for verification at Etherscan.io on 2018-06-08
3 */
4 
5 pragma solidity ^0.4.21;
6 
7 // File: contracts/ownership/Ownable.sol
8 
9 /**
10  * @title Ownable
11  * @dev The Ownable contract has an owner address, and provides basic authorization control
12  * functions, this simplifies the implementation of "user permissions".
13  */
14 contract Ownable {
15   address public owner;
16 
17 
18   event OwnershipRenounced(address indexed previousOwner);
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48   /**
49    * @dev Allows the current owner to relinquish control of the contract.
50    */
51   function renounceOwnership() public onlyOwner {
52     emit OwnershipRenounced(owner);
53     owner = address(0);
54   }
55 }
56 
57 // File: contracts/math/SafeMath.sol
58 
59 /**
60  * @title SafeMath
61  * @dev Math operations with safety checks that throw on error
62  */
63 library SafeMath {
64 
65   /**
66   * @dev Multiplies two numbers, throws on overflow.
67   */
68   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     if (a == 0) {
70       return 0;
71     }
72     c = a * b;
73     assert(c / a == b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     // assert(b > 0); // Solidity automatically throws when dividing by 0
82     // uint256 c = a / b;
83     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
84     return a / b;
85   }
86 
87   /**
88   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
99     c = a + b;
100     assert(c >= a);
101     return c;
102   }
103 }
104 
105 // File: contracts/token/ERC20/ERC20Basic.sol
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic {
113   function totalSupply() public view returns (uint256);
114   function balanceOf(address who) public view returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 // File: contracts/token/ERC20/BasicToken.sol
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163 }
164 
165  
166 
167 // File: contracts/token/ERC20/ERC20.sol
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174   function allowance(address owner, address spender) public view returns (uint256);
175   function transferFrom(address from, address to, uint256 value) public returns (bool);
176   function approve(address spender, uint256 value) public returns (bool);
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 
180 // File: contracts/token/ERC20/StandardToken.sol
181 
182 /**
183  * @title Standard ERC20 token
184  *
185  * @dev Implementation of the basic standard token.
186  * @dev https://github.com/ethereum/EIPs/issues/20
187  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
188  */
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     emit Transfer(_from, _to, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
214    *
215    * Beware that changing an allowance with this method brings the risk that someone may use both the old
216    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
217    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
218    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222   function approve(address _spender, uint256 _value) public returns (bool) {
223     allowed[msg.sender][_spender] = _value;
224     emit Approval(msg.sender, _spender, _value);
225     return true;
226   }
227 
228   /**
229    * @dev Function to check the amount of tokens that an owner allowed to a spender.
230    * @param _owner address The address which owns the funds.
231    * @param _spender address The address which will spend the funds.
232    * @return A uint256 specifying the amount of tokens still available for the spender.
233    */
234   function allowance(address _owner, address _spender) public view returns (uint256) {
235     return allowed[_owner][_spender];
236   }
237 
238   /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _addedValue The amount of tokens to increase the allowance by.
247    */
248   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
249     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
250     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Decrease the amount of tokens that an owner allowed to a spender.
256    *
257    * approve should be called when allowed[_spender] == 0. To decrement
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _subtractedValue The amount of tokens to decrease the allowance by.
263    */
264   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 contract Aiqt is StandardToken, Ownable {
278     // Constants
279     string  public constant name = "AIQT";
280     string  public constant symbol = "AIQT";
281     uint8   public constant decimals = 18;
282     uint256 public constant INITIAL_SUPPLY      =  100000000 * (10 ** uint256(decimals));
283    
284     
285     mapping(address => bool) touched;
286  
287 
288     function Aiqt() public {
289       totalSupply_ = INITIAL_SUPPLY;
290 
291       
292 
293       balances[msg.sender] = INITIAL_SUPPLY;
294       emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
295     }
296 
297     function _transfer(address _from, address _to, uint _value) internal {     
298         require (balances[_from] >= _value);               // Check if the sender has enough
299         require (balances[_to] + _value > balances[_to]); // Check for overflows
300    
301         balances[_from] = balances[_from].sub(_value);                         // Subtract from the sender
302         balances[_to] = balances[_to].add(_value);                            // Add the same to the recipient
303          
304         emit Transfer(_from, _to, _value);
305     }
306  
307     
308     function safeWithdrawal(uint _value ) onlyOwner public {
309        if (_value == 0) 
310            owner.transfer(address(this).balance);
311        else
312            owner.transfer(_value);
313     }
314 
315 }