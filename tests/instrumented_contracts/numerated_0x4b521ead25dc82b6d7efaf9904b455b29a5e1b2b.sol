1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4   address public owner;
5 
6   /**
7    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8    * account.
9    */
10   function Ownable() public {
11     owner = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newOwner The address to transfer ownership to.
25    */
26   function transferOwnership(address newOwner) onlyOwner public {
27     require(newOwner != address(0));      
28     owner = newOwner;
29   }
30 
31 }
32 
33 library AddressUtils {
34   function isContract(address addr) internal view returns (bool) {
35     uint256 size;
36     assembly { size := extcodesize(addr) }
37     return size > 0;
38   }
39 }
40 
41 interface ERC165ReceiverInterface {
42   function tokensReceived(address _from, address _to, uint _amount, bytes _data) external returns (bool);
43 }
44 
45 contract supportERC165Basic {
46 	bytes4 constant InvalidID = 0xffffffff;
47   bytes4 constant ERC165ID = 0x01ffc9a7;
48 	
49 	function transfer_erc165(address to, uint256 value, bytes _data) public returns (bool);
50 
51   function doesContractImplementInterface(address _contract, bytes4 _interfaceId) internal view returns (bool) {
52       uint256 success;
53       uint256 result;
54 
55       (success, result) = noThrowCall(_contract, ERC165ID);
56       if ((success==0)||(result==0)) {
57           return false;
58       }
59   
60       (success, result) = noThrowCall(_contract, InvalidID);
61       if ((success==0)||(result!=0)) {
62           return false;
63       }
64 
65       (success, result) = noThrowCall(_contract, _interfaceId);
66       if ((success==1)&&(result==1)) {
67           return true;
68       }
69       return false;
70   }
71 
72   function noThrowCall(address _contract, bytes4 _interfaceId) constant internal returns (uint256 success, uint256 result) {
73       bytes4 erc165ID = ERC165ID;
74 
75       assembly {
76               let x := mload(0x40)               // Find empty storage location using "free memory pointer"
77               mstore(x, erc165ID)                // Place signature at begining of empty storage
78               mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
79 
80               success := staticcall(
81                                   30000,         // 30k gas
82                                   _contract,     // To addr
83                                   x,             // Inputs are stored at location x
84                                   0x20,          // Inputs are 32 bytes long
85                                   x,             // Store output over input (saves space)
86                                   0x20)          // Outputs are 32 bytes long
87 
88               result := mload(x)                 // Load the result
89       }
90   }	
91 }
92 
93 
94 contract ERC20Basic is supportERC165Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 contract BasicToken is ERC20Basic {
102   using SafeMath for uint256;
103   using AddressUtils for address;
104 
105   mapping(address => uint256) balances;
106 
107   uint256 totalSupply_;
108 
109   /**
110   * @dev total number of tokens in existence
111   */
112   function totalSupply() public view returns (uint256) {
113     return totalSupply_;
114   }
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121   function transfer(address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[msg.sender]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126     balances[msg.sender] = balances[msg.sender].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     Transfer(msg.sender, _to, _value);
129 	
130     /** Support ERC165 */
131     if (_to.isContract()) {
132       ERC165ReceiverInterface i;
133       if(doesContractImplementInterface(_to, i.tokensReceived.selector)) {
134         ERC165ReceiverInterface app= ERC165ReceiverInterface(_to);
135         app.tokensReceived(msg.sender, _to, _value, "");
136       }
137 	  }
138     return true;
139   }
140   
141   /**
142   * transfer with ERC165 interface
143   **/
144   function transfer_erc165(address _to, uint256 _value, bytes _data) public returns (bool) {
145     //transfer(_to, _value);
146 
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154       
155     // Support ERC165
156     //don't need to check??
157     if (!_to.isContract()) revert();
158     
159     ERC165ReceiverInterface i;
160     if(!doesContractImplementInterface(_to, i.tokensReceived.selector)) revert(); 
161     ERC165ReceiverInterface app= ERC165ReceiverInterface(_to);
162     app.tokensReceived(msg.sender, _to, _value, _data);
163     
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public view returns (uint256 balance) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 library SafeMath {
179   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180     uint256 c = a * b;
181     assert(a == 0 || c / a == b);
182     return c;
183   }
184 
185   function div(uint256 a, uint256 b) internal pure returns (uint256) {
186     uint256 c = a / b;
187     return c;
188   }
189 
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     assert(b <= a);
192     return a - b;
193   }
194 
195   function add(uint256 a, uint256 b) internal pure returns (uint256) {
196     uint256 c = a + b;
197     assert(c >= a);
198     return c;
199   }
200 }
201 
202 contract ERC20 is ERC20Basic {
203   function allowance(address owner, address spender) public view returns (uint256);
204   function transferFrom(address from, address to, uint256 value) public returns (bool);
205   function approve(address spender, uint256 value) public returns (bool);
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285     uint oldValue = allowed[msg.sender][_spender];
286     if (_subtractedValue > oldValue) {
287       allowed[msg.sender][_spender] = 0;
288     } else {
289       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290     }
291     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295 }
296 
297 contract kinwa is StandardToken, Ownable {
298   string public name = "KINWA Token";
299   string public symbol = "KINWA";
300   uint public decimals = 8;
301     
302   function kinwa() public {
303     owner = msg.sender;
304 	
305     totalSupply_= 100 * 10 ** (8+9);  //100 Billion
306 	  balances[owner] = totalSupply_;
307 	
308 	  Transfer(address(0), owner, totalSupply_);
309   }
310 
311 }