1 pragma solidity ^0.4.4;
2 // OOST Token contract based on the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Smartcontract for OOST, for more information visit https://www.meetup.com/nl-NL/NET-Oost/
5 // Symbol: OOST
6 // Status: ERC20 Verified
7 
8 contract OOSTToken { 
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20     
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public constant returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /**
55  * OOSTToken Math operations with safety checks to avoid unnecessary conflicts
56  */
57 
58 library OOSTMaths {
59 // Saftey Checks for Multiplication Tasks
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 // Saftey Checks for Divison Tasks
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b > 0);
68     uint256 c = a / b;
69     assert(a == b * c + a % b);
70     return c;
71   }
72 // Saftey Checks for Subtraction Tasks
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 // Saftey Checks for Addition Tasks
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c>=a && c>=b);
81     return c;
82   }
83 }
84 
85 contract Ownable {
86     address public owner;
87     address public newOwner;
88 
89     /** 
90      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
91      * account.
92      */
93     function Ownable() public {
94         owner = msg.sender;
95     }
96 
97     modifier onlyOwner() {
98     require(msg.sender == owner);
99     _;
100   }
101 
102    // validates an address - currently only checks that it isn't null
103     modifier validAddress(address _address) {
104         require(_address != 0x0);
105         _;
106     }
107 
108     function transferOwnership(address _newOwner) public onlyOwner {
109         if (_newOwner != address(0)) {
110             owner = _newOwner;
111         }
112     }
113 
114     function acceptOwnership() public {
115         require(msg.sender == newOwner);
116         OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119     event OwnershipTransferred(address indexed _from, address indexed _to);
120 }
121 
122 
123 contract OostStandardToken is OOSTToken, Ownable {
124     
125     using OOSTMaths for uint256;
126     mapping (address => uint256) balances;
127     mapping (address => mapping (address => uint256)) allowed;
128     mapping (address => bool) public frozenAccount;
129 
130     event FrozenFunds(address target, bool frozen);
131      
132     function balanceOf(address _owner) public constant returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136     function freezeAccount(address target, bool freeze) public onlyOwner {
137         frozenAccount[target] = freeze;
138         FrozenFunds(target, freeze);
139     }
140 
141     function transfer(address _to, uint256 _value) public returns (bool success) {
142         if (frozenAccount[msg.sender]) 
143             return false;
144         require(
145             (balances[msg.sender] >= _value) // Check if the sender has enough
146             && (_value > 0) // Don't allow 0value transfer
147             && (_to != address(0)) // Prevent transfer to 0x0 address
148             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
149             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
150             //most of these things are not necesary
151 
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
159         if (frozenAccount[msg.sender]) 
160             return false;
161         require(
162             (allowed[_from][msg.sender] >= _value) // Check allowance
163             && (balances[_from] >= _value) // Check if the sender has enough
164             && (_value > 0) // Don't allow 0value transfer
165             && (_to != address(0)) // Prevent transfer to 0x0 address
166             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
167             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
168             //most of these things are not necesary
169         );
170         balances[_from] = balances[_from].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173         Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     function approve(address _spender, uint256 _value) public returns (bool success) {
178         /* To change the approve amount you first have to reduce the addresses`
179          * allowance to zero by calling `approve(_spender, 0)` if it is not
180          * already 0 to mitigate the race condition described here:
181          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
182         
183         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
184         allowed[msg.sender][_spender] = _value;
185 
186         // Notify anyone listening that this approval done
187         Approval(msg.sender, _spender, _value);
188         return true;
189     }
190     
191     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
192       return allowed[_owner][_spender];
193     }
194   
195 }
196 contract OOST is OostStandardToken {
197 
198     /* Public variables of the token */
199     /*
200     NOTE:
201     The following variables are OPTIONAL vanities. One does not have to include them.
202     They allow one to customise the token contract & in no way influences the core functionality.
203     Some wallets/interfaces might not even bother to look at this information.
204     */
205     
206     uint256 constant public DECIMALS = 8;               //How many decimals to show.
207     uint256 public totalSupply = 24 * (10**7) * 10**8 ; // 240 million tokens, 8 decimal places
208     string constant public NAME = "OOST";               //fancy name
209     string constant public SYMBOL = "OOST";             //An identifier
210     string constant public VERSION = "v1";              //Version 2 standard. Just an arbitrary versioning scheme.
211     
212     function OOST() public {
213         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
214     }
215 
216     /* Approves and then calls the receiving contract */
217     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
218         allowed[msg.sender][_spender] = _value;
219         Approval(msg.sender, _spender, _value);
220 
221         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
222         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
223         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
224         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
225         return true;
226     }
227 }