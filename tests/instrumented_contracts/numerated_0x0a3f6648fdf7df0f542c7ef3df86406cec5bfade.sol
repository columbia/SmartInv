1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract ERC223ReceivingContract { 
21   function tokenFallback(address _from, uint _value, bytes _data) public;
22 }
23 
24 contract ERC20CompatibleToken is owned {
25   using SafeMath for uint;
26 
27   // Public variables of the token
28   string public name;
29   string public symbol;
30   uint8 public decimals = 18;
31   uint256 public totalSupply;
32 
33   mapping(address => uint) balances; // List of user balances.
34 
35   event Transfer(address indexed from, address indexed to, uint value);
36   event Approval(address indexed owner, address indexed spender, uint256 value);
37   mapping (address => mapping (address => uint256)) internal allowed;
38   mapping (address => bool) public frozenAccount;
39 
40   /**
41    * Constrctor function
42    *
43    * Initializes contract with initial supply tokens to the creator of the contract
44    */
45   constructor(
46       uint256 initialSupply,
47       string memory tokenName,
48       string memory tokenSymbol, 
49       address owner
50   ) public {
51       totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
52       balances[owner] = totalSupply;                    // Give the creator all initial tokens
53       name = tokenName;                                       // Set the name for display purposes
54       symbol = tokenSymbol;                                   // Set the symbol for display purposes
55   }
56 
57   /**
58   * @dev Transfer tokens from one address to another
59   * @param _from address The address which you want to send tokens from
60   * @param _to address The address which you want to transfer to
61   * @param _value uint256 the amount of tokens to be transferred
62   */
63   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
64     uint codeLength;
65     bytes memory empty;
66 
67     require(_to != address(0));
68     require(_value <= balances[_from]);
69     require(_value <= allowed[_from][msg.sender]);
70 
71     require(!frozenAccount[_from]);                         // Check if sender is frozen
72     require(!frozenAccount[_to]);                           // Check if recipient is frozen
73 
74     assembly {
75       // Retrieve the size of the code on target address, this needs assembly .
76       codeLength := extcodesize(_to)
77     }
78     if(codeLength>0) {
79       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
80       receiver.tokenFallback(_from, _value, empty);
81     }
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     emit Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   /**
91    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
92    *
93    * @param _spender The address which will spend the funds.
94    * @param _value The amount of tokens to be spent.
95    */
96   function approve(address _spender, uint256 _value) public returns (bool) {
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   /**
103    * @dev Function to check the amount of tokens that an owner allowed to a spender.
104    * @param _owner address The address which owns the funds.
105    * @param _spender address The address which will spend the funds.
106    * @return A uint256 specifying the amount of tokens still available for the spender.
107    */
108   function allowance(address _owner, address _spender) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 
112   /**
113    * approve should be called when allowed[_spender] == 0. To increment
114    * allowed value is better to use this function to avoid 2 calls (and wait until
115    * the first transaction is mined)
116    * From MonolithDAO Token.sol
117    */
118   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
119     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
125     uint oldValue = allowed[msg.sender][_spender];
126     if (_subtractedValue > oldValue) {
127       allowed[msg.sender][_spender] = 0;
128     } else {
129       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130     }
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   /* This generates a public event on the blockchain that will notify clients */
136   event FrozenFunds(address target, bool frozen);
137 
138   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
139   /// @param target Address to be frozen
140   /// @param freeze either to freeze it or not
141   function freezeAccount(address target, bool freeze) onlyOwner public {
142       frozenAccount[target] = freeze;
143       emit FrozenFunds(target, freeze);
144   }
145 
146 }
147 
148 contract ERC223Interface {
149     function balanceOf(address who) public constant returns (uint);
150     function transfer(address to, uint value) public;
151     function transfer(address to, uint value, bytes data) public;
152     event Transfer(address indexed from, address indexed to, uint value, bytes data);
153 }
154 
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that throw on error
158  */
159 library SafeMath {
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     if (a == 0) {
162       return 0;
163     }
164     uint256 c = a * b;
165     assert(c / a == b);
166     return c;
167   }
168 
169   function div(uint256 a, uint256 b) internal pure returns (uint256) {
170     // assert(b > 0); // Solidity automatically throws when dividing by 0
171     uint256 c = a / b;
172     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173     return c;
174   }
175 
176   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177     assert(b <= a);
178     return a - b;
179   }
180 
181   function add(uint256 a, uint256 b) internal pure returns (uint256) {
182     uint256 c = a + b;
183     assert(c >= a);
184     return c;
185   }
186 }
187 
188 /**
189  * @title Mango Coin Main Contract
190  * @dev Reference implementation of the ERC223 standard token.
191  */
192 contract MangoCoin is owned, ERC223Interface, ERC20CompatibleToken {
193     using SafeMath for uint;
194 
195     mapping (address => bool) public frozenAccount;
196 
197     /* Initializes contract with initial supply tokens to the creator of the contract */
198     constructor(
199         uint256 initialSupply,
200         string memory tokenName,
201         string memory tokenSymbol, 
202         address owner
203     ) ERC20CompatibleToken(initialSupply, tokenName, tokenSymbol, owner) public {}
204 
205     /**
206      * @dev Transfer the specified amount of tokens to the specified address.
207      *      Invokes the `tokenFallback` function if the recipient is a contract.
208      *      The token transfer fails if the recipient is a contract
209      *      but does not implement the `tokenFallback` function
210      *      or the fallback function to receive funds.
211      *
212      * @param _to    Receiver address.
213      * @param _value Amount of tokens that will be transferred.
214      * @param _data  Transaction metadata.
215      */
216     function transfer(address _to, uint _value, bytes _data) public {
217         // Standard function transfer similar to ERC20 transfer with no _data .
218         // Added due to backwards compatibility reasons .
219         uint codeLength;
220 
221         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
222         require(!frozenAccount[_to]);                           // Check if recipient is frozen
223 
224         assembly {
225             // Retrieve the size of the code on target address, this needs assembly .
226             codeLength := extcodesize(_to)
227         }
228 
229         balances[msg.sender] = balances[msg.sender].sub(_value);
230         balances[_to] = balances[_to].add(_value);
231         if(codeLength>0) {
232             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
233             receiver.tokenFallback(msg.sender, _value, _data);
234         }
235         emit Transfer(msg.sender, _to, _value);
236         return ;
237     }
238 
239     /**
240      * @dev Transfer the specified amount of tokens to the specified address.
241      *      This function works the same with the previous one
242      *      but doesn't contain `_data` param.
243      *      Added due to backwards compatibility reasons.
244      *
245      * @param _to    Receiver address.
246      * @param _value Amount of tokens that will be transferred.
247      */
248     function transfer(address _to, uint _value) public {
249         uint codeLength;
250         bytes memory empty;
251 
252         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
253         require(!frozenAccount[_to]);                           // Check if recipient is frozen
254 
255         assembly {
256             // Retrieve the size of the code on target address, this needs assembly .
257             codeLength := extcodesize(_to)
258         }
259 
260         balances[msg.sender] = balances[msg.sender].sub(_value);
261         balances[_to] = balances[_to].add(_value);
262         if(codeLength>0) {
263             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
264             receiver.tokenFallback(msg.sender, _value, empty);
265         }
266         emit Transfer(msg.sender, _to, _value);
267         return ;
268     }
269 
270 
271     /**
272      * @dev Returns balance of the `_owner`.
273      *
274      * @param _owner   The address whose balance will be returned.
275      * @return balance Balance of the `_owner`.
276      */
277     function balanceOf(address _owner) public constant returns (uint balance) {
278         return balances[_owner];
279     }
280 
281     /* This generates a public event on the blockchain that will notify clients */
282     event FrozenFunds(address target, bool frozen);
283 
284     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
285     /// @param target Address to be frozen
286     /// @param freeze either to freeze it or not
287     function freezeAccount(address target, bool freeze) onlyOwner public {
288         frozenAccount[target] = freeze;
289         emit FrozenFunds(target, freeze);
290         return ;
291     }
292 
293 }