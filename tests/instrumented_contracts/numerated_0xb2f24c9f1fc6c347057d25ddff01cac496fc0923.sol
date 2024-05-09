1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract Ownable {
23   address public owner;
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   /**
27    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28    * account.
29    */
30   function Ownable() public {
31     owner = msg.sender;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) public onlyOwner {
47     require(newOwner != address(0));
48     emit OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 }
52 
53 contract ERC20Basic {
54   function totalSupply() public view returns (uint256);
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) public view returns (uint256);
66   function transferFrom(address from, address to, uint256 value) public returns (bool);
67   function approve(address spender, uint256 value) public returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract ERC223Interface {
72     function transfer(address to, uint value, bytes data) public returns (bool);
73 }
74 
75 contract ERC223ReceivingContract {
76 /**
77  * @dev Standard ERC223 function that will handle incoming token transfers.
78  *
79  * @param _from  Token sender address.
80  * @param _value Amount of tokens.
81  * @param _data  Transaction metadata.
82  */
83     function tokenFallback(address _from, uint _value, bytes _data) public;
84 }
85 
86 /**
87  * @title Basic token
88  * @dev Basic version of StandardToken, with no allowances.
89  */
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   /**
98   * @dev total number of tokens in existence
99   */
100   function totalSupply() public view returns (uint256) {
101     return totalSupply_;
102   }
103 
104   /**
105   * @dev transfer token for a specified address
106   * @param _to The address to transfer to.
107   * @param _value The amount to be transferred.
108   */
109   function transfer(address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[msg.sender]);
112 
113     // SafeMath.sub will throw if there is not enough balance.
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   /**
121   * @dev Gets the balance of the specified address.
122   * @param _owner The address to query the the balance of.
123   * @return An uint256 representing the amount owned by the passed address.
124   */
125   function balanceOf(address _owner) public view returns (uint256 balance) {
126     return balances[_owner];
127   }
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 
226 /**
227  * @title Reference implementation of the ERC223 standard token.
228  */
229 contract ERC223Token is ERC223Interface, StandardToken {
230     using SafeMath for uint;
231     /**
232      * @dev Transfer the specified amount of tokens to the specified address.
233      *      Invokes the `tokenFallback` function if the recipient is a contract.
234      *      The token transfer fails if the recipient is a contract
235      *      but does not implement the `tokenFallback` function
236      *      or the fallback function to receive funds.
237      *
238      * @param _to    Receiver address.
239      * @param _value Amount of tokens that will be transferred.
240      * @param _data  Transaction metadata.
241      */
242     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
243         uint codeLength;
244 
245         assembly {
246             codeLength := extcodesize(_to)
247         }
248 
249         balances[msg.sender] = balances[msg.sender].sub(_value);
250         balances[_to] = balances[_to].add(_value);
251         if (codeLength > 0) {
252             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
253             receiver.tokenFallback(msg.sender, _value, _data);
254         }
255         emit Transfer(msg.sender, _to, _value);
256         return true;
257     }
258 
259     /**
260      * @dev Transfer the specified amount of tokens to the specified address.
261      *      This function works the same with the previous one
262      *      but doesn't contain `_data` param.
263      *      Added due to backwards compatibility reasons.
264      *
265      * @param _to    Receiver address.
266      * @param _value Amount of tokens that will be transferred.
267      */
268     function transfer(address _to, uint _value) public returns (bool) {
269         bytes memory empty;
270         return transfer(_to, _value, empty);
271     }
272 
273     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
274         return super.transferFrom(_from, _to, _value);
275     }
276 
277     function approve(address _spender, uint256 _value) public returns (bool) {
278         return super.approve(_spender, _value);
279     }
280 
281     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
282         return super.increaseApproval(_spender, _addedValue);
283     }
284 
285     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
286         return super.decreaseApproval(_spender, _subtractedValue);
287     }
288 }
289 
290 contract BDC is ERC223Token, Ownable {
291     string public name = "BitDigitalCoin";
292     string public symbol = "BDC";
293     uint256 public decimals = 18;
294 
295     using SafeMath for uint;
296 
297     function BDC() public {
298         owner = msg.sender;
299         totalSupply_ = 1000000000 * (10 ** decimals);
300         balances[owner] = totalSupply_;
301         emit Transfer(address(0), owner, totalSupply_);
302     }
303 
304     function() payable public {
305         revert();
306     }
307 }