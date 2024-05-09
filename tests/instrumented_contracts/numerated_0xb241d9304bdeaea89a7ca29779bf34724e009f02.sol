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
48       string memory tokenSymbol
49   ) public {
50       totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51       balances[msg.sender] = totalSupply;                    // Give the creator all initial tokens
52       name = tokenName;                                       // Set the name for display purposes
53       symbol = tokenSymbol;                                   // Set the symbol for display purposes
54   }
55 
56   /**
57   * @dev Transfer tokens from one address to another
58   * @param _from address The address which you want to send tokens from
59   * @param _to address The address which you want to transfer to
60   * @param _value uint256 the amount of tokens to be transferred
61   */
62   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
63     uint codeLength;
64     bytes memory empty;
65 
66     require(_to != address(0));
67     require(_value <= balances[_from]);
68     require(_value <= allowed[_from][msg.sender]);
69 
70     require(!frozenAccount[_from]);                         // Check if sender is frozen
71     require(!frozenAccount[_to]);                           // Check if recipient is frozen
72 
73     assembly {
74       // Retrieve the size of the code on target address, this needs assembly .
75       codeLength := extcodesize(_to)
76     }
77     if(codeLength>0) {
78       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
79       receiver.tokenFallback(_from, _value, empty);
80     }
81 
82     balances[_from] = balances[_from].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85     emit Transfer(_from, _to, _value);
86     return true;
87   }
88 
89   /**
90    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
91    *
92    * @param _spender The address which will spend the funds.
93    * @param _value The amount of tokens to be spent.
94    */
95   function approve(address _spender, uint256 _value) public returns (bool) {
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Function to check the amount of tokens that an owner allowed to a spender.
103    * @param _owner address The address which owns the funds.
104    * @param _spender address The address which will spend the funds.
105    * @return A uint256 specifying the amount of tokens still available for the spender.
106    */
107   function allowance(address _owner, address _spender) public view returns (uint256) {
108     return allowed[_owner][_spender];
109   }
110 
111   /**
112    * approve should be called when allowed[_spender] == 0. To increment
113    * allowed value is better to use this function to avoid 2 calls (and wait until
114    * the first transaction is mined)
115    * From MonolithDAO Token.sol
116    */
117   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
119     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 
123   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
124     uint oldValue = allowed[msg.sender][_spender];
125     if (_subtractedValue > oldValue) {
126       allowed[msg.sender][_spender] = 0;
127     } else {
128       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
129     }
130     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131     return true;
132   }
133 
134   /* This generates a public event on the blockchain that will notify clients */
135   event FrozenFunds(address target, bool frozen);
136 
137   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
138   /// @param target Address to be frozen
139   /// @param freeze either to freeze it or not
140   function freezeAccount(address target, bool freeze) onlyOwner public {
141       frozenAccount[target] = freeze;
142       emit FrozenFunds(target, freeze);
143   }
144 
145 }
146 
147 contract ERC223Interface {
148     function balanceOf(address who) public constant returns (uint);
149     function transfer(address to, uint value) public;
150     function transfer(address to, uint value, bytes data) public;
151     event Transfer(address indexed from, address indexed to, uint value, bytes data);
152 }
153 
154 /**
155  * @title SafeMath
156  * @dev Math operations with safety checks that throw on error
157  */
158 library SafeMath {
159   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160     if (a == 0) {
161       return 0;
162     }
163     uint256 c = a * b;
164     assert(c / a == b);
165     return c;
166   }
167 
168   function div(uint256 a, uint256 b) internal pure returns (uint256) {
169     // assert(b > 0); // Solidity automatically throws when dividing by 0
170     uint256 c = a / b;
171     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172     return c;
173   }
174 
175   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176     assert(b <= a);
177     return a - b;
178   }
179 
180   function add(uint256 a, uint256 b) internal pure returns (uint256) {
181     uint256 c = a + b;
182     assert(c >= a);
183     return c;
184   }
185 }
186 
187 /**
188  * @title Rich Coin Main Contract
189  * @dev Reference implementation of the ERC223 standard token.
190  */
191 contract RichCoin is owned, ERC223Interface, ERC20CompatibleToken {
192     using SafeMath for uint;
193 
194     mapping (address => bool) public frozenAccount;
195 
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     constructor(
198         uint256 initialSupply,
199         string memory tokenName,
200         string memory tokenSymbol
201     ) ERC20CompatibleToken(initialSupply, tokenName, tokenSymbol) public {}
202 
203     /**
204      * @dev Transfer the specified amount of tokens to the specified address.
205      *      Invokes the `tokenFallback` function if the recipient is a contract.
206      *      The token transfer fails if the recipient is a contract
207      *      but does not implement the `tokenFallback` function
208      *      or the fallback function to receive funds.
209      *
210      * @param _to    Receiver address.
211      * @param _value Amount of tokens that will be transferred.
212      * @param _data  Transaction metadata.
213      */
214     function transfer(address _to, uint _value, bytes _data) public {
215         // Standard function transfer similar to ERC20 transfer with no _data .
216         // Added due to backwards compatibility reasons .
217         uint codeLength;
218 
219         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
220         require(!frozenAccount[_to]);                           // Check if recipient is frozen
221 
222         assembly {
223             // Retrieve the size of the code on target address, this needs assembly .
224             codeLength := extcodesize(_to)
225         }
226 
227         balances[msg.sender] = balances[msg.sender].sub(_value);
228         balances[_to] = balances[_to].add(_value);
229         if(codeLength>0) {
230             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
231             receiver.tokenFallback(msg.sender, _value, _data);
232         }
233         emit Transfer(msg.sender, _to, _value);
234         return ;
235     }
236 
237     /**
238      * @dev Transfer the specified amount of tokens to the specified address.
239      *      This function works the same with the previous one
240      *      but doesn't contain `_data` param.
241      *      Added due to backwards compatibility reasons.
242      *
243      * @param _to    Receiver address.
244      * @param _value Amount of tokens that will be transferred.
245      */
246     function transfer(address _to, uint _value) public {
247         uint codeLength;
248         bytes memory empty;
249 
250         require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
251         require(!frozenAccount[_to]);                           // Check if recipient is frozen
252 
253         assembly {
254             // Retrieve the size of the code on target address, this needs assembly .
255             codeLength := extcodesize(_to)
256         }
257 
258         balances[msg.sender] = balances[msg.sender].sub(_value);
259         balances[_to] = balances[_to].add(_value);
260         if(codeLength>0) {
261             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
262             receiver.tokenFallback(msg.sender, _value, empty);
263         }
264         emit Transfer(msg.sender, _to, _value);
265         return ;
266     }
267 
268     function transferGasByOwner(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
269         balances[_from] = balances[_from].sub(_value);
270         balances[_to] = balances[_to].add(_value);
271         emit Transfer(_from, _to, _value);
272         return true;
273     }
274 
275     /**
276      * @dev Returns balance of the `_owner`.
277      *
278      * @param _owner   The address whose balance will be returned.
279      * @return balance Balance of the `_owner`.
280      */
281     function balanceOf(address _owner) public constant returns (uint balance) {
282         return balances[_owner];
283     }
284 
285     /* This generates a public event on the blockchain that will notify clients */
286     event FrozenFunds(address target, bool frozen);
287 
288     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
289     /// @param target Address to be frozen
290     /// @param freeze either to freeze it or not
291     function freezeAccount(address target, bool freeze) onlyOwner public {
292         frozenAccount[target] = freeze;
293         emit FrozenFunds(target, freeze);
294         return ;
295     }
296 
297 }