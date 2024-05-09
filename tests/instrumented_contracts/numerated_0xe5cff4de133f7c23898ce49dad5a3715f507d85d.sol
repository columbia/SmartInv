1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() {
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
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 
77 /**
78  * @title Contactable token
79  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
80  * contact information.
81  */
82 contract Contactable is Ownable{
83 
84     string public contactInformation;
85 
86     /**
87      * @dev Allows the owner to set a string with their contact information.
88      * @param info The contact information to attach to the contract.
89      */
90     function setContactInformation(string info) onlyOwner public {
91          contactInformation = info;
92      }
93 }
94 
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   uint256 public totalSupply;
103   function balanceOf(address who) public constant returns (uint256);
104   function transfer(address to, uint256 value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113   function allowance(address owner, address spender) public constant returns (uint256);
114   function transferFrom(address from, address to, uint256 value) public returns (bool);
115   function approve(address spender, uint256 value) public returns (bool);
116   event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   /**
129   * @dev transfer token for a specified address
130   * @param _to The address to transfer to.
131   * @param _value The amount to be transferred.
132   */
133   function transfer(address _to, uint256 _value) public returns (bool) {
134     require(_to != address(0));
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public constant returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163   mapping (address => mapping (address => uint256)) allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _value uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174 
175     uint256 _allowance = allowed[_from][msg.sender];
176 
177     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
178     // require (_value <= _allowance);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = _allowance.sub(_value);
183     Transfer(_from, _to, _value);
184     return true;
185   }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197   function approve(address _spender, uint256 _value) public returns (bool) {
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param _owner address The address which owns the funds.
206    * @param _spender address The address which will spend the funds.
207    * @return A uint256 specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
210     return allowed[_owner][_spender];
211   }
212 
213   /**
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    */
219   function increaseApproval (address _spender, uint _addedValue)
220     returns (bool success) {
221     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226   function decreaseApproval (address _spender, uint _subtractedValue)
227     returns (bool success) {
228     uint oldValue = allowed[msg.sender][_spender];
229     if (_subtractedValue > oldValue) {
230       allowed[msg.sender][_spender] = 0;
231     } else {
232       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
233     }
234     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238 }
239 
240 contract LOCIairdropper is Ownable, Contactable {
241     using SafeMath for uint256;
242     
243     // this is the already deployed coin from the token sale
244     StandardToken token;
245         
246     event AirDroppedTokens(uint256 addressCount);       
247 
248     // After this contract is deployed, we will grant access to this contract
249     // by calling methods on the LOCIcoin since we are using the same owner
250     // and granting the distribution of tokens to this contract
251     function LOCIairdropper( address _token, string _contactInformation ) public {
252         require(_token != 0x0);
253 
254         token = StandardToken(_token);
255         contactInformation = _contactInformation;                                
256     }      
257     
258     function transfer(address[] _address, uint256[] _values) onlyOwner public {
259         require(_address.length == _values.length);
260 
261         for (uint i = 0; i < _address.length; i += 1) {
262             token.transfer(_address[i],_values[i]);
263         }
264 
265         AirDroppedTokens(_address.length);
266     }    
267 
268     // in the event ether is accidentally sent to our contract, we can retrieve it
269     function ownerTransferWei(address _beneficiary, uint256 _value) external onlyOwner {
270         require(_beneficiary != 0x0);
271         require(_beneficiary != address(token));
272     
273         // if zero requested, send the entire amount, otherwise the amount requested
274         uint256 _amount = _value > 0 ? _value : this.balance;
275 
276         _beneficiary.transfer(_amount);
277     }
278 
279     // after we distribute the bonus tokens, we will send them back to the coin itself
280     function ownerRecoverTokens(address _beneficiary) external onlyOwner {
281         require(_beneficiary != 0x0);
282         require(_beneficiary != address(token));
283         
284         uint256 _tokensRemaining = token.balanceOf(address(this));
285         if (_tokensRemaining > 0) {
286             token.transfer(_beneficiary, _tokensRemaining);
287         }
288     }
289 }