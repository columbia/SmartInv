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
30 }
31 
32 library AddressUtils {
33   function isContract(address addr) internal view returns (bool) {
34     uint256 size;
35     assembly { size := extcodesize(addr) }
36     return size > 0;
37   }
38 }
39 
40 interface ERC165ReceiverInterface {
41   function tokensReceived(address _from, address _to, uint _amount, bytes _data) external returns (bool);
42 }
43 
44 contract supportERC165Basic {
45   bytes4 constant InvalidID = 0xffffffff;
46   bytes4 constant ERC165ID = 0x01ffc9a7;
47 	
48   function transfer_erc165(address to, uint256 value, bytes _data) public returns (bool);
49 
50   function doesContractImplementInterface(address _contract, bytes4 _interfaceId) internal view returns (bool) {
51       uint256 success;
52       uint256 result;
53 
54       (success, result) = noThrowCall(_contract, ERC165ID);
55       if ((success==0)||(result==0)) {
56           return false;
57       }
58   
59       (success, result) = noThrowCall(_contract, InvalidID);
60       if ((success==0)||(result!=0)) {
61           return false;
62       }
63 
64       (success, result) = noThrowCall(_contract, _interfaceId);
65       if ((success==1)&&(result==1)) {
66           return true;
67       }
68       return false;
69   }
70 
71   function noThrowCall(address _contract, bytes4 _interfaceId) constant internal returns (uint256 success, uint256 result) {
72       bytes4 erc165ID = ERC165ID;
73 
74       assembly {
75               let x := mload(0x40)               // Find empty storage location using "free memory pointer"
76               mstore(x, erc165ID)                // Place signature at begining of empty storage
77               mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature
78 
79               success := staticcall(
80                                   30000,         // 30k gas
81                                   _contract,     // To addr
82                                   x,             // Inputs are stored at location x
83                                   0x20,          // Inputs are 32 bytes long
84                                   x,             // Store output over input (saves space)
85                                   0x20)          // Outputs are 32 bytes long
86 
87               result := mload(x)                 // Load the result
88       }
89   }	
90 }
91 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
92 
93 contract ERC20Basic is supportERC165Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102   using AddressUtils for address;
103 
104   mapping(address => uint256) balances;
105 
106   uint256 totalSupply_;
107 
108   /**
109   * @dev total number of tokens in existence
110   */
111   function totalSupply() public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   /**
116   * @dev transfer token for a specified address
117   * @param _to The address to transfer to.
118   * @param _value The amount to be transferred.
119   */
120   function transfer(address _to, uint256 _value) public returns (bool) {
121     require(_to != address(0));
122     require(_value <= balances[msg.sender]);
123 
124     // SafeMath.sub will throw if there is not enough balance.
125     balances[msg.sender] = balances[msg.sender].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     Transfer(msg.sender, _to, _value);
128   }
129     
130   /**
131   * transfer with ERC165 interface
132   **/
133   function transfer_erc165(address _to, uint256 _value, bytes _data) public returns (bool) {
134     transfer(_to, _value);
135       
136     if (!_to.isContract()) revert();
137     
138     ERC165ReceiverInterface i;
139     if(!doesContractImplementInterface(_to, i.tokensReceived.selector)) revert(); 
140 
141     ERC165ReceiverInterface app= ERC165ReceiverInterface(_to);
142     app.tokensReceived(msg.sender, _to, _value, _data);
143     
144     return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public view returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 }
157 
158 library SafeMath {
159   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160     uint256 c = a * b;
161     assert(a == 0 || c / a == b);
162     return c;
163   }
164 
165   function div(uint256 a, uint256 b) internal pure returns (uint256) {
166     // assert(b > 0); // Solidity automatically throws when dividing by 0
167     uint256 c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169     return c;
170   }
171 
172   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173     assert(b <= a);
174     return a - b;
175   }
176 
177   function add(uint256 a, uint256 b) internal pure returns (uint256) {
178     uint256 c = a + b;
179     assert(c >= a);
180     return c;
181   }
182 }
183 
184 contract ERC20 is ERC20Basic {
185   function allowance(address owner, address spender) public view returns (uint256);
186   function transferFrom(address from, address to, uint256 value) public returns (bool);
187   function approve(address spender, uint256 value) public returns (bool);
188   event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract RoboAiCoin is StandardToken, Ownable {
280 
281   string public name = "RoboAi Coin";
282   string public symbol = "R2R";
283   uint public decimals = 8;
284     
285   function RoboAiCoin() public {
286     owner = msg.sender;
287     totalSupply_ = 0;
288     
289     totalSupply_= 1 * 10 ** (9+8);  //1 Billion
290 
291     balances[owner] = totalSupply_;
292 	Transfer(address(0), owner, balances[owner]);
293   }
294 }