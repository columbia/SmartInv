1 pragma solidity ^0.4.21;
2 
3 // ----------------- 
4 //begin Ownable.sol
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   function Ownable() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 //end Ownable.sol
47 // ----------------- 
48 //begin ERC20Basic.sol
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 //end ERC20Basic.sol
63 // ----------------- 
64 //begin SafeMath.sol
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 //end SafeMath.sol
113 // ----------------- 
114 //begin BasicToken.sol
115 
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   uint256 totalSupply_;
128 
129   /**
130   * @dev total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   /**
137   * @dev transfer token for a specified address
138   * @param _to The address to transfer to.
139   * @param _value The amount to be transferred.
140   */
141   function transfer(address _to, uint256 _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[msg.sender]);
144 
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256 balance) {
157     return balances[_owner];
158   }
159 
160 }
161 
162 //end BasicToken.sol
163 // ----------------- 
164 //begin ERC20.sol
165 
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172   function allowance(address owner, address spender) public view returns (uint256);
173   function transferFrom(address from, address to, uint256 value) public returns (bool);
174   function approve(address spender, uint256 value) public returns (bool);
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 //end ERC20.sol
179 // ----------------- 
180 //begin StandardToken.sol
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) internal allowed;
193 
194 
195   /**
196    * @dev Transfer tokens from one address to another
197    * @param _from address The address which you want to send tokens from
198    * @param _to address The address which you want to transfer to
199    * @param _value uint256 the amount of tokens to be transferred
200    */
201   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203     require(_value <= balances[_from]);
204     require(_value <= allowed[_from][msg.sender]);
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215    *
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifying the amount of tokens still available for the spender.
234    */
235   function allowance(address _owner, address _spender) public view returns (uint256) {
236     return allowed[_owner][_spender];
237   }
238 
239   /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
250     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 //end StandardToken.sol
279 // ----------------- 
280 //begin TokensSpreader.sol
281 
282 contract TokensSpreader is Ownable {
283     StandardToken public token;
284     address public sender;
285     string public name = "TDR's Tokens Spreader";
286 
287     constructor(address _tokenAddress, address _sender) public {
288         token = StandardToken(_tokenAddress);
289         sender = _sender;
290     }
291 
292     function spread(address[] addresses, uint256[] amounts) public onlyOwner {
293         if (addresses.length != amounts.length) {
294             revert();
295         }
296         for (uint8 i = 0; i < addresses.length; i++) {
297             token.transferFrom(sender, addresses[i], amounts[i]);
298         }
299     }
300 
301     function setSender(address _sender) public onlyOwner {
302         sender = _sender;
303     }
304 
305     function setToken(address _tokenAddress) public onlyOwner {
306         token = StandardToken(_tokenAddress);
307     }
308 
309     function resetWith(address _sender, address _tokenAddress) public onlyOwner {
310         sender = _sender;
311         token = StandardToken(_tokenAddress);
312     }
313 }
314 
315 //end TokensSpreader.sol