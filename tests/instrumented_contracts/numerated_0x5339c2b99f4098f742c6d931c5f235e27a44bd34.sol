1 pragma solidity 0.4.23;
2 
3 contract ERC223Interface {
4     function transfer(address _to, uint _value, bytes _data) external;
5     event Transfer(address indexed _from, address indexed _to, uint _value, bytes indexed _data);
6 }
7 
8  /**
9  * @title Contract that will work with ERC223 tokens.
10  */
11 
12 contract ERC223ReceivingContract {
13 /**
14  * @dev Standard ERC223 function that will handle incoming token transfers.
15  *
16  * @param _from  Token sender address.
17  * @param _value Amount of tokens.
18  * @param _data  Transaction metadata.
19  */
20     function tokenFallback(address _from, uint _value, bytes _data) public;
21 }
22 
23 contract ERC20Interface {
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint _value) external returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint _value) external returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) external constant returns (uint remaining);
48 
49     /// @return total amount of tokens
50     function totalSupply() external constant returns (uint supply);
51 
52     /// @param _owner The address from which the balance will be retrieved
53     /// @return The balance
54     function balanceOf(address _owner) external constant returns (uint balance);
55 
56     event Transfer(address indexed _from, address indexed _to, uint _value);
57     event Approval(address indexed _owner, address indexed _spender, uint _value);
58 }
59 
60 library SafeMath {
61     function mul(uint a, uint b) internal pure returns (uint) {
62         uint c = a * b;
63         assert(a == 0 || c / a == b);
64         return c;
65     }
66 
67     function div(uint a, uint b) internal pure returns (uint) {
68         // assert(b > 0); // Solidity automatically throws when dividing by 0
69         uint c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71         return c;
72     }
73 
74     function sub(uint a, uint b) internal pure returns (uint) {
75         assert(b <= a);
76         return a - b;
77     }
78 
79     function add(uint a, uint b) internal pure returns (uint) {
80         uint c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 
85     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
86         return a >= b ? a : b;
87     }
88 
89     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
90         return a < b ? a : b;
91     }
92 
93     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a >= b ? a : b;
95     }
96 
97     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a < b ? a : b;
99     }
100 
101     function assert(bool assertion) internal pure {
102         require(assertion);
103     }
104 }
105 
106 contract ERC20Token is ERC20Interface {
107     using SafeMath for uint;
108 
109     uint public totalSupply;
110 
111     mapping (address => uint) public balances;
112     mapping (address => mapping (address => uint)) public allowed;
113 
114     function transfer(address _to, uint _value) external returns (bool success) {
115         // Default assumes totalSupply can't be over max (2^256 - 1).
116         if (balances[msg.sender] >= _value && _value > 0) {
117             balances[msg.sender] -= _value;
118             balances[_to] += _value;
119             emit Transfer(msg.sender, _to, _value);
120             return true;
121         } else { return false; }
122     }
123 
124     function transferFrom(address _from, address _to, uint _value) external returns (bool success) {
125         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
126             balances[_to] += _value;
127             balances[_from] -= _value;
128             allowed[_from][msg.sender] -= _value;
129             emit Transfer(_from, _to, _value);
130             return true;
131         } else { return false; }
132     }
133 
134     function totalSupply() external constant returns (uint) {
135         return totalSupply;
136     }
137 
138     function balanceOf(address _owner) external constant returns (uint balance) {
139         return balances[_owner];
140     }
141 
142     function approve(address _spender, uint _value) external returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function allowance(address _owner, address _spender) external constant returns (uint remaining) {
149         return allowed[_owner][_spender];
150     }
151 }
152 
153 
154 contract ERC223Token is ERC20Token, ERC223Interface {
155     using SafeMath for uint;
156 
157     /**
158      * @dev Transfer the specified amount of tokens to the specified address.
159      *      Invokes the `tokenFallback` function if the recipient is a contract.
160      *      The token transfer fails if the recipient is a contract
161      *      but does not implement the `tokenFallback` function
162      *      or the fallback function to receive funds.
163      *
164      * @param _to    Receiver address.
165      * @param _value Amount of tokens that will be transferred.
166      * @param _data  Transaction metadata.
167      */
168     function transfer(address _to, uint _value, bytes _data) external {
169         // Standard function transfer similar to ERC20 transfer with no _data .
170         // Added due to backwards compatibility reasons .
171         uint codeLength;
172 
173         assembly {
174             // Retrieve the size of the code on target address, this needs assembly .
175             codeLength := extcodesize(_to)
176         }
177 
178         balances[msg.sender] = balances[msg.sender].sub(_value);
179         balances[_to] = balances[_to].add(_value);
180         if (codeLength > 0) {
181             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
182             receiver.tokenFallback(msg.sender, _value, _data);
183         }
184         emit Transfer(msg.sender, _to, _value, _data);
185     }
186 }
187 
188 /**
189  * @title Ownable
190  * @dev The Ownable contract has an owner address, and provides basic authorization control
191  * functions, this simplifies the implementation of "user permissions".
192  */
193 contract Ownable {
194     address public owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200     * account.
201     */
202     constructor() public {
203         owner = msg.sender;
204     }
205 
206     /**
207     * @dev Throws if called by any account other than the owner.
208     */
209     modifier onlyOwner() {
210         require(
211             msg.sender == owner,
212             "Only owner can call this function."
213         );
214         _;
215     }
216 
217     /**
218     * @dev Allows the current owner to transfer control of the contract to a newOwner.
219     * @param newOwner The address to transfer ownership to.
220     */
221     function transferOwnership(address newOwner) public onlyOwner {
222         require(newOwner != address(0));
223         emit OwnershipTransferred(owner, newOwner);
224         owner = newOwner;
225     }
226 
227 }
228 
229 // ----------------------------------------------------------------------------
230 // PayBlok token contract
231 //
232 // Symbol      : PBLK
233 // Name        : PayBlok
234 // Total supply: 250000000
235 // Decimals    : 18
236 //
237 // (c) by Tim Huegdon, Peter Featherstone for Prodemic Ltd 2018.
238 // ----------------------------------------------------------------------------
239 contract PayBlokToken is ERC223Token, Ownable {
240     using SafeMath for uint;
241 
242     string public symbol;
243     string public name;
244     address public contractOwner;
245     uint8 public decimals;
246 
247     // ------------------------------------------------------------------------
248     // Constructor
249     // ------------------------------------------------------------------------
250     constructor() public {
251         symbol = "PBLK";
252         name = "PayBlok";
253         decimals = 18;
254         totalSupply = 250000000000000000000000000;
255         balances[msg.sender] = totalSupply;
256         emit Transfer(address(0), msg.sender, totalSupply);
257     }
258 
259     event Burn(address indexed burner, uint256 value);
260 
261     /**
262     * @dev Burns a specific amount of tokens.
263     * @param _value The amount of token to be burned.
264     */
265     function burn(uint256 _value) public onlyOwner {
266         _burn(msg.sender, _value);
267     }
268 
269     function _burn(address _who, uint256 _value) internal {
270         require(_value <= balances[_who]);
271 
272         balances[_who] = balances[_who].sub(_value);
273         totalSupply = totalSupply.sub(_value);
274         emit Burn(_who, _value);
275         emit Transfer(_who, address(0), _value);
276     }
277 }