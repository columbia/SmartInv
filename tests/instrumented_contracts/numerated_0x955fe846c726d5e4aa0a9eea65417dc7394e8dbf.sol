1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  * https://github.com/Dexaran/ERC223-token-standard/blob/master/SafeMath.sol
6  */
7 library SafeMath {
8   function mul(uint a, uint b) pure internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) pure internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) pure internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) pure internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49  /**
50  * @title Contract that will work with ERC223 tokens.
51  * https://github.com/Dexaran/ERC223-token-standard/blob/ERC20_compatible/ERC223_receiving_contract.sol
52  */
53  
54 contract ERC223ReceivingContract { 
55 /**
56  * @dev Standard ERC223 function that will handle incoming token transfers.
57  *
58  * @param _from  Token sender address.
59  * @param _value Amount of tokens.
60  * @param _data  Transaction metadata.
61  */
62     function tokenFallback(address _from, uint _value, bytes _data) public;
63 }
64 
65 /*
66  * @title ERC223 interface
67  * https://github.com/Dexaran/ERC223-token-standard/blob/ERC20_compatible/ERC223_interface.sol
68  */
69 contract ERC223Interface {
70     uint public totalSupply;
71     function balanceOf(address who) constant public returns (uint);
72     function transfer(address to, uint value) public;
73     function transfer(address to, uint value, bytes data) public;
74     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
75 }
76 
77 /*
78  * @title More compatibility with ERC20
79  * https://github.com/Dexaran/ERC223-token-standard/blob/ERC20_compatible/ERC20_functions.sol with additions from ERC223Token from https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/ERC223_Token.sol
80  */
81 contract ERC20CompatibleToken {
82     using SafeMath for uint;
83 
84     mapping(address => uint) balances; // List of user balances.
85     string public name;
86     string public symbol;
87     uint8 public decimals;
88     uint256 public totalSupply;
89 
90     event Transfer(address indexed from, address indexed to, uint value);
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92     mapping (address => mapping (address => uint256)) internal allowed;
93 
94     // Function to access name of token .
95     function name() public view returns (string _name) {
96         return name;
97     }
98     // Function to access symbol of token .
99     function symbol() public view returns (string _symbol) {
100         return symbol;
101     }
102     // Function to access decimals of token .
103     function decimals() public view returns (uint8 _decimals) {
104         return decimals;
105     }
106     // Function to access total supply of tokens .
107     function totalSupply() public view returns (uint256 _totalSupply) {
108         return totalSupply;
109     }
110 
111     /**
112     * @dev Transfer tokens from one address to another
113     * @param _from address The address which you want to send tokens from
114     * @param _to address The address which you want to transfer to
115     * @param _value uint256 the amount of tokens to be transferred
116     */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
118 
119   /**
120    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    *
122    * Beware that changing an allowance with this method brings the risk that someone may use both the old
123    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
124    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
125    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141   function allowance(address _owner, address _spender) public view returns (uint256) {
142     return allowed[_owner][_spender];
143   }
144 
145   /**
146    * approve should be called when allowed[_spender] == 0. To increment
147    * allowed value is better to use this function to avoid 2 calls (and wait until
148    * the first transaction is mined)
149    * From MonolithDAO Token.sol
150    */
151   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
152     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
153     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
158     uint oldValue = allowed[msg.sender][_spender];
159     if (_subtractedValue > oldValue) {
160       allowed[msg.sender][_spender] = 0;
161     } else {
162       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163     }
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 }
168 
169 /**
170  * @title Reference implementation of the ERC223 standard token.
171  * https://github.com/Dexaran/ERC223-token-standard/blob/ERC20_compatible/Token.sol
172  */
173 contract ERC223Token is ERC223Interface, ERC20CompatibleToken {
174     using SafeMath for uint;
175 
176     /**
177     * @dev Transfer tokens from one address to another
178     * @param _from address The address which you want to send tokens from
179     * @param _to address The address which you want to transfer to
180     * @param _value uint256 the amount of tokens to be transferred
181     */
182     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183       require(_to != address(0));
184       require(_value <= balances[_from]);
185       require(_value <= allowed[_from][msg.sender]);
186 
187       balances[_from] = balances[_from].sub(_value);
188       balances[_to] = balances[_to].add(_value);
189       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190       emit Transfer(_from, _to, _value);
191       bytes memory empty;
192       emit Transfer(_from, _to, _value, empty);
193       return true;
194     }
195 
196     /**
197      * @dev Transfer the specified amount of tokens to the specified address.
198      *      Invokes the `tokenFallback` function if the recipient is a contract.
199      *      The token transfer fails if the recipient is a contract
200      *      but does not implement the `tokenFallback` function
201      *      or the fallback function to receive funds.
202      *
203      * @param _to    Receiver address.
204      * @param _value Amount of tokens that will be transferred.
205      * @param _data  Transaction metadata.
206      */
207     function transfer(address _to, uint _value, bytes _data) public {
208         // Standard function transfer similar to ERC20 transfer with no _data .
209         // Added due to backwards compatibility reasons .
210         uint codeLength;
211 
212         assembly {
213             // Retrieve the size of the code on target address, this needs assembly .
214             codeLength := extcodesize(_to)
215         }
216 
217         balances[msg.sender] = balances[msg.sender].sub(_value);
218         balances[_to] = balances[_to].add(_value);
219         if(codeLength>0) {
220             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
221             receiver.tokenFallback(msg.sender, _value, _data);
222         }
223         emit Transfer(msg.sender, _to, _value);
224         emit Transfer(msg.sender, _to, _value, _data);
225     }
226 
227     /**
228      * @dev Transfer the specified amount of tokens to the specified address.
229      *      This function works the same with the previous one
230      *      but doesn't contain `_data` param.
231      *      Added due to backwards compatibility reasons.
232      *
233      * @param _to    Receiver address.
234      * @param _value Amount of tokens that will be transferred.
235      */
236     function transfer(address _to, uint _value) public {
237         uint codeLength;
238         bytes memory empty;
239 
240         assembly {
241             // Retrieve the size of the code on target address, this needs assembly .
242             codeLength := extcodesize(_to)
243         }
244 
245         balances[msg.sender] = balances[msg.sender].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247         if(codeLength>0) {
248             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
249             receiver.tokenFallback(msg.sender, _value, empty);
250         }
251         emit Transfer(msg.sender, _to, _value);
252         emit Transfer(msg.sender, _to, _value, empty);
253     }
254 
255 
256     /**
257      * @dev Returns balance of the `_owner`.
258      *
259      * @param _owner   The address whose balance will be returned.
260      * @return balance Balance of the `_owner`.
261      */
262     function balanceOf(address _owner) public constant returns (uint balance) {
263         return balances[_owner];
264     }
265 }
266 
267 contract QZToken is ERC223Token {
268     /* Initializes contract with initial supply tokens to the creator of the contract */
269     function QZToken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialSupply) public {
270         name = tokenName; // Set the name for display purposes
271         symbol = tokenSymbol; // Set the symbol for display purposes
272         decimals = decimalUnits; // Amount of decimals for display purposes
273         totalSupply = initialSupply * 10 ** uint(decimalUnits); // Update total supply
274         balances[msg.sender] = totalSupply; // Give the creator all initial tokens
275     }
276 }