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
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33     mapping (address => mapping (address => uint256)) internal allowed;
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
45         totalSupply = initialSupply * 10 ** uint256(decimals);
46         // Update total supply with the decimal amount
47         balances[msg.sender] = totalSupply;
48         // Give the creator all initial tokens
49         name = tokenName;
50         // Set the name for display purposes
51         symbol = tokenSymbol;
52         // Set the symbol for display purposes
53     }
54 
55     /**
56      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
57      *
58      * @param _spender The address which will spend the funds.
59      * @param _value The amount of tokens to be spent.
60      */
61     function approve(address _spender, uint256 _value) public returns (bool) {
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     /**
68      * @dev Function to check the amount of tokens that an owner allowed to a spender.
69      * @param _owner address The address which owns the funds.
70      * @param _spender address The address which will spend the funds.
71      * @return A uint256 specifying the amount of tokens still available for the spender.
72      */
73     function allowance(address _owner, address _spender) public view returns (uint256) {
74         return allowed[_owner][_spender];
75     }
76 
77     /**
78      * approve should be called when allowed[_spender] == 0. To increment
79      * allowed value is better to use this function to avoid 2 calls (and wait until
80      * the first transaction is mined)
81      * From MonolithDAO Token.sol
82      */
83     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
84         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
85         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86         return true;
87     }
88 
89     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
90         uint oldValue = allowed[msg.sender][_spender];
91         if (_subtractedValue > oldValue) {
92             allowed[msg.sender][_spender] = 0;
93         } else {
94             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
95         }
96         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
97         return true;
98     }
99 }
100 
101 contract ERC223Interface {
102     function balanceOf(address who) public constant returns (uint);
103 
104     function transfer(address to, uint value) public returns (bool);
105 
106     function transfer(address to, uint value, bytes data) public returns (bool);
107 
108     event Transfer(address indexed from, address indexed to, uint value, bytes data);
109 }
110 
111 contract ERC223ReceivingContract {
112     function tokenFallback(address _from, uint _value, bytes _data) public;
113 }
114 
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         if (a == 0) {
123             return 0;
124         }
125         uint256 c = a * b;
126         assert(c / a == b);
127         return c;
128     }
129 
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // assert(b > 0); // Solidity automatically throws when dividing by 0
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134         return c;
135     }
136 
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         assert(b <= a);
139         return a - b;
140     }
141 
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         assert(c >= a);
145         return c;
146     }
147 }
148 
149 /**
150  * @title VMembers Coin Main Contract
151  * @dev Reference implementation of the ERC223 standard token.
152  */
153 contract VMembersCoin is owned, ERC223Interface, ERC20CompatibleToken {
154     using SafeMath for uint;
155 
156     mapping(address => bool) public frozenAccount;
157 
158     /* Initializes contract with initial supply tokens to the creator of the contract */
159     constructor(
160         uint256 initialSupply,
161         string memory tokenName,
162         string memory tokenSymbol
163     ) ERC20CompatibleToken(initialSupply, tokenName, tokenSymbol) public {}
164 
165     /**
166      * @dev Transfer the specified amount of tokens to the specified address.
167      *      Invokes the `tokenFallback` function if the recipient is a contract.
168      *      The token transfer fails if the recipient is a contract
169      *      but does not implement the `tokenFallback` function
170      *      or the fallback function to receive funds.
171      *
172      * @param _to    Receiver address.
173      * @param _value Amount of tokens that will be transferred.
174      * @param _data  Transaction metadata.
175      */
176     function transfer(address _to, uint _value, bytes _data) public returns (bool){
177         // Standard function transfer similar to ERC20 transfer with no _data .
178         // Added due to backwards compatibility reasons .
179         uint codeLength;
180 
181         require(!frozenAccount[msg.sender]);
182         // Check if sender is frozen
183         require(!frozenAccount[_to]);
184         // Check if recipient is frozen
185 
186         assembly {
187         // Retrieve the size of the code on target address, this needs assembly .
188             codeLength := extcodesize(_to)
189         }
190 
191         balances[msg.sender] = balances[msg.sender].sub(_value);
192         balances[_to] = balances[_to].add(_value);
193         if (codeLength > 0) {
194             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
195             receiver.tokenFallback(msg.sender, _value, _data);
196         }
197         emit Transfer(msg.sender, _to, _value, _data);
198         emit Transfer(msg.sender, _to, _value);
199         return true;
200     }
201 
202     /**
203      * @dev Transfer the specified amount of tokens to the specified address.
204      *      This function works the same with the previous one
205      *      but doesn't contain `_data` param.
206      *      Added due to backwards compatibility reasons.
207      *
208      * @param _to    Receiver address.
209      * @param _value Amount of tokens that will be transferred.
210      */
211     function transfer(address _to, uint _value) public returns (bool) {
212         uint codeLength;
213         bytes memory empty;
214 
215         require(!frozenAccount[msg.sender]);
216         // Check if sender is frozen
217         require(!frozenAccount[_to]);
218         // Check if recipient is frozen
219 
220         assembly {
221         // Retrieve the size of the code on target address, this needs assembly .
222             codeLength := extcodesize(_to)
223         }
224 
225         balances[msg.sender] = balances[msg.sender].sub(_value);
226         balances[_to] = balances[_to].add(_value);
227         if (codeLength > 0) {
228             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
229             receiver.tokenFallback(msg.sender, _value, empty);
230         }
231         emit Transfer(msg.sender, _to, _value, empty);
232         emit Transfer(msg.sender, _to, _value);
233         return true;
234     }
235 
236     /**
237     * @dev Transfer tokens from one address to another
238     * @param _from address The address which you want to send tokens from
239     * @param _to address The address which you want to transfer to
240     * @param _value uint256 the amount of tokens to be transferred
241     */
242     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
243         uint codeLength;
244         bytes memory empty;
245 
246         require(_to != address(0));
247         require(_value <= balances[_from]);
248         require(_value <= allowed[_from][msg.sender]);
249 
250 
251         require(!frozenAccount[_from]);
252         // Check if sender is frozen
253         require(!frozenAccount[_to]);
254         // Check if recipient is frozen
255 
256 
257         assembly {
258         // Retrieve the size of the code on target address, this needs assembly .
259             codeLength := extcodesize(_to)
260         }
261 
262         balances[_from] = balances[_from].sub(_value);
263         balances[_to] = balances[_to].add(_value);
264         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
265         if (codeLength > 0) {
266             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
267             receiver.tokenFallback(_from, _value, empty);
268         }
269         emit Transfer(msg.sender, _to, _value, empty);
270         emit Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274     /**
275      * @dev Returns balance of the `_owner`.
276      *
277      * @param _owner   The address whose balance will be returned.
278      * @return balance Balance of the `_owner`.
279      */
280     function balanceOf(address _owner) public constant returns (uint balance) {
281         return balances[_owner];
282     }
283 
284     /* This generates a public event on the blockchain that will notify clients */
285     event FrozenFunds(address target, bool frozen);
286 
287     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
288     /// @param target Address to be frozen
289     /// @param freeze either to freeze it or not
290     function freezeAccount(address target, bool freeze) onlyOwner public {
291         frozenAccount[target] = freeze;
292         emit FrozenFunds(target, freeze);
293     }
294 
295 }