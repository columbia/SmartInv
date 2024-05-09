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
20 contract ERC20CompatibleToken {
21     using SafeMath for uint;
22 
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping(address => uint) balances; // List of user balances.
30 
31     event Transfer(address indexed from, address indexed to, uint value);
32   	event Approval(address indexed owner, address indexed spender, uint256 value);
33   	mapping (address => mapping (address => uint256)) internal allowed;
34 
35     /**
36      * Constrctor function
37      *
38      * Initializes contract with initial supply tokens to the creator of the contract
39      */
40     constructor(
41         uint256 initialSupply,
42         string memory tokenName,
43         string memory tokenSymbol
44     ) public {
45         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
46         balances[msg.sender] = totalSupply;                    // Give the creator all initial tokens
47         name = tokenName;                                       // Set the name for display purposes
48         symbol = tokenSymbol;                                   // Set the symbol for display purposes
49     }
50 
51     /**
52     * @dev Transfer tokens from one address to another
53     * @param _from address The address which you want to send tokens from
54     * @param _to address The address which you want to transfer to
55     * @param _value uint256 the amount of tokens to be transferred
56     */
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[_from]);
60     require(_value <= allowed[_from][msg.sender]);
61 
62     balances[_from] = balances[_from].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
65     emit Transfer(_from, _to, _value);
66     return true;
67   }
68 
69   /**
70    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
71    *
72    * @param _spender The address which will spend the funds.
73    * @param _value The amount of tokens to be spent.
74    */
75     function approve(address _spender, uint256 _value) public returns (bool) {
76     allowed[msg.sender][_spender] = _value;
77     emit Approval(msg.sender, _spender, _value);
78     return true;
79   }
80 
81   /**
82    * @dev Function to check the amount of tokens that an owner allowed to a spender.
83    * @param _owner address The address which owns the funds.
84    * @param _spender address The address which will spend the funds.
85    * @return A uint256 specifying the amount of tokens still available for the spender.
86    */
87   function allowance(address _owner, address _spender) public view returns (uint256) {
88     return allowed[_owner][_spender];
89   }
90 
91   /**
92    * approve should be called when allowed[_spender] == 0. To increment
93    * allowed value is better to use this function to avoid 2 calls (and wait until
94    * the first transaction is mined)
95    * From MonolithDAO Token.sol
96    */
97   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104     uint oldValue = allowed[msg.sender][_spender];
105     if (_subtractedValue > oldValue) {
106       allowed[msg.sender][_spender] = 0;
107     } else {
108       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109     }
110     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111     return true;
112   }
113 }
114 
115 contract ERC223Interface {
116     uint public totalSupply;
117     function balanceOf(address who) public constant returns (uint);
118     function transfer(address to, uint value) public;
119     function transfer(address to, uint value, bytes data) public;
120     event Transfer(address indexed from, address indexed to, uint value, bytes data);
121 }
122 
123 contract ERC223ReceivingContract { 
124   function tokenFallback(address _from, uint _value, bytes _data) public;
125 }
126 
127 
128 /**
129  * @title SafeMath
130  * @dev Math operations with safety checks that throw on error
131  */
132 library SafeMath {
133   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134     if (a == 0) {
135       return 0;
136     }
137     uint256 c = a * b;
138     assert(c / a == b);
139     return c;
140   }
141 
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     // assert(b > 0); // Solidity automatically throws when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146     return c;
147   }
148 
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
160 
161 /**
162  * @title VMembers Coin Main Contract
163  * @dev Reference implementation of the ERC223 standard token.
164  */
165 contract VMembersCoin is owned, ERC223Interface, ERC20CompatibleToken {
166     using SafeMath for uint;
167 
168     mapping (address => bool) public frozenAccount;
169 
170     /* Initializes contract with initial supply tokens to the creator of the contract */
171     constructor(
172         uint256 initialSupply,
173         string memory tokenName,
174         string memory tokenSymbol
175     ) ERC20CompatibleToken(initialSupply, tokenName, tokenSymbol) public {}
176 
177     /**
178      * @dev Transfer the specified amount of tokens to the specified address.
179      *      Invokes the `tokenFallback` function if the recipient is a contract.
180      *      The token transfer fails if the recipient is a contract
181      *      but does not implement the `tokenFallback` function
182      *      or the fallback function to receive funds.
183      *
184      * @param _to    Receiver address.
185      * @param _value Amount of tokens that will be transferred.
186      * @param _data  Transaction metadata.
187      */
188     function transfer(address _to, uint _value, bytes _data) public {
189         // Standard function transfer similar to ERC20 transfer with no _data .
190         // Added due to backwards compatibility reasons .
191         uint codeLength;
192 
193         //require(!frozenAccount[msg.sender]);                    // Check if sender is frozen
194         //require(!frozenAccount[_to]);                           // Check if recipient is frozen
195 
196         assembly {
197             // Retrieve the size of the code on target address, this needs assembly .
198             codeLength := extcodesize(_to)
199         }
200 
201         balances[msg.sender] = balances[msg.sender].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         if(codeLength>0) {
204             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
205             receiver.tokenFallback(msg.sender, _value, _data);
206         }
207         emit Transfer(msg.sender, _to, _value, _data);
208     }
209 
210     /**
211      * @dev Transfer the specified amount of tokens to the specified address.
212      *      This function works the same with the previous one
213      *      but doesn't contain `_data` param.
214      *      Added due to backwards compatibility reasons.
215      *
216      * @param _to    Receiver address.
217      * @param _value Amount of tokens that will be transferred.
218      */
219     function transfer(address _to, uint _value) public {
220         uint codeLength;
221         bytes memory empty;
222 
223         assembly {
224             // Retrieve the size of the code on target address, this needs assembly .
225             codeLength := extcodesize(_to)
226         }
227 
228         balances[msg.sender] = balances[msg.sender].sub(_value);
229         balances[_to] = balances[_to].add(_value);
230         if(codeLength>0) {
231             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
232             receiver.tokenFallback(msg.sender, _value, empty);
233         }
234         emit Transfer(msg.sender, _to, _value, empty);
235     }
236 
237 
238     /**
239      * @dev Returns balance of the `_owner`.
240      *
241      * @param _owner   The address whose balance will be returned.
242      * @return balance Balance of the `_owner`.
243      */
244     function balanceOf(address _owner) public constant returns (uint balance) {
245         return balances[_owner];
246     }
247 
248     /* This generates a public event on the blockchain that will notify clients */
249     event FrozenFunds(address target, bool frozen);
250 
251     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
252     /// @param target Address to be frozen
253     /// @param freeze either to freeze it or not
254     function freezeAccount(address target, bool freeze) onlyOwner public {
255         frozenAccount[target] = freeze;
256         emit FrozenFunds(target, freeze);
257     }
258 
259 }