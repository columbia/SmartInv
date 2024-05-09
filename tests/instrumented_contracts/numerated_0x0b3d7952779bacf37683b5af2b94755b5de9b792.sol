1 pragma solidity ^0.4.16;
2  
3  /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     
10   address public owner;
11   uint public start;
12  
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
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
29   modifier tokenIsOn() {
30     if (msg.sender != owner){
31     require(now > start);
32     _;}
33     _;
34   }
35  
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) onlyOwner {
41     require(newOwner != address(0));      
42     owner = newOwner;
43   }
44   
45   function startToken(uint startDate) onlyOwner {
46       start = startDate;
47   }
48  
49 }
50  
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic is Ownable {
57   uint256 public totalSupply;
58   function balanceOf(address who) constant returns (uint256);
59   function transfer(address to, uint256 value) returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62  
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) returns (bool);
70   function approve(address spender, uint256 value) returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73  
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79     
80   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85  
86   function div(uint256 a, uint256 b) internal constant returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92  
93   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
94     assert(b <= a);
95     return a - b;
96   }
97  
98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
99     uint256 c = a + b;
100     assert(c >= a);
101     return c;
102   }
103   
104 }
105  
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances. 
109  */
110 contract BasicToken is ERC20Basic {
111     
112   using SafeMath for uint256;
113  
114   mapping(address => uint256) balances;
115  
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) tokenIsOn returns (bool) {
122     balances[msg.sender] = balances[msg.sender].sub(_value);
123     balances[_to] = balances[_to].add(_value);
124     Transfer(msg.sender, _to, _value);
125     return true;
126   }
127  
128   /**
129   * @dev Gets the balance of the specified address.
130   * @param _owner The address to query the the balance of. 
131   * @return An uint256 representing the amount owned by the passed address.
132   */
133   function balanceOf(address _owner) constant returns (uint256 balance) {
134     return balances[_owner];
135   }
136  
137 }
138  
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147  
148   mapping (address => mapping (address => uint256)) allowed;
149  
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amout of tokens to be transfered
155    */
156   function transferFrom(address _from, address _to, uint256 _value) tokenIsOn returns (bool) {
157     var _allowance = allowed[_from][msg.sender];
158  
159     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
160     // require (_value <= _allowance);
161  
162     balances[_to] = balances[_to].add(_value);
163     balances[_from] = balances[_from].sub(_value);
164     allowed[_from][msg.sender] = _allowance.sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168  
169   /**
170    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) returns (bool) {
175  
176     // To change the approve amount you first have to reduce the addresses`
177     //  allowance to zero by calling `approve(_spender, 0)` if it is not
178     //  already 0 to mitigate the race condition described here:
179     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181  
182     allowed[msg.sender][_spender] = _value;
183     Approval(msg.sender, _spender, _value);
184     return true;
185   }
186  
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifing the amount of tokens still available for the spender.
192    */
193   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
194     return allowed[_owner][_spender];
195   }
196   
197    /**
198      * @dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param addedValue The amount of tokens to increase the allowance by.
206      */
207 
208     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
209         require(spender != address(0));
210 
211         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
212         Approval(msg.sender, spender, allowed[msg.sender][spender]);
213 
214         return true;
215     }
216 
217 
218 
219     /**
220      * @dev Decrease the amount of tokens that an owner allowed to a spender.
221      * approve should be called when allowed_[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * Emits an Approval event.
226      * @param spender The address which will spend the funds.
227      * @param subtractedValue The amount of tokens to decrease the allowance by.
228      */
229 
230     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
231 
232         require(spender != address(0));
233 
234         allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
235         Approval(msg.sender, spender, allowed[msg.sender][spender]);
236 
237         return true;
238 
239     }
240  
241 }
242 
243 contract HuobiRussiaToken is StandardToken {
244     
245   string public constant name = "Huobi Token Russia";
246    
247   string public constant symbol = "HTR";
248     
249   uint32 public constant decimals = 18;
250  
251   uint256 public INITIAL_SUPPLY = 200000000 * 1 ether;
252  
253   function HuobiRussiaToken() {
254     totalSupply = INITIAL_SUPPLY;
255     balances[msg.sender] = INITIAL_SUPPLY;
256   }
257     
258 }