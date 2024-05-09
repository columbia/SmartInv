1 pragma solidity ^0.4.16;
2 // HZMCOIN Token contract based on the full ERC 20 Token standard
3 // Symbol: HZM
4 // Status: ERC20 Verified
5 
6 contract HZMCOINToken { 
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18     
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 /**
53  * HZMCOIN Math operations with safety checks to avoid unnecessary conflicts
54  */
55 
56 library HZMMaths {
57 // Saftey Checks for Multiplication Tasks
58   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 // Saftey Checks for Divison Tasks
64   function div(uint256 a, uint256 b) internal constant returns (uint256) {
65     assert(b > 0);
66     uint256 c = a / b;
67     assert(a == b * c + a % b);
68     return c;
69   }
70 // Saftey Checks for Subtraction Tasks
71   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 // Saftey Checks for Addition Tasks
76   function add(uint256 a, uint256 b) internal constant returns (uint256) {
77     uint256 c = a + b;
78     assert(c>=a && c>=b);
79     return c;
80   }
81 }
82 
83 contract Ownable {
84     address public owner;
85     address public newOwner;
86 
87     /** 
88      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89      * account.
90      */
91     function Ownable() {
92         owner = msg.sender;
93     }
94 
95     modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100    // validates an address - currently only checks that it isn't null
101     modifier validAddress(address _address) {
102         require(_address != 0x0);
103         _;
104     }
105 
106     function transferOwnership(address _newOwner) onlyOwner {
107         if (_newOwner != address(0)) {
108             owner = _newOwner;
109         }
110     }
111 
112     function acceptOwnership() {
113         require(msg.sender == newOwner);
114         OwnershipTransferred(owner, newOwner);
115         owner = newOwner;
116     }
117     event OwnershipTransferred(address indexed _from, address indexed _to);
118 }
119 
120 
121 contract HZMStandardToken is HZMCOINToken, Ownable {
122     
123     using HZMMaths for uint256;
124     mapping (address => uint256) balances;
125     mapping (address => mapping (address => uint256)) allowed;
126     mapping (address => bool) public frozenAccount;
127 
128     event FrozenFunds(address target, bool frozen);
129      
130     function balanceOf(address _owner) constant returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function freezeAccount(address target, bool freeze) onlyOwner {
135         frozenAccount[target] = freeze;
136         FrozenFunds(target, freeze);
137     }
138 
139     function transfer(address _to, uint256 _value) returns (bool success) {
140         if (frozenAccount[msg.sender]) return false;
141         require(
142             (balances[msg.sender] >= _value) // Check if the sender has enough
143             && (_value > 0) // Don't allow 0value transfer
144             && (_to != address(0)) // Prevent transfer to 0x0 address
145             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
146             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
147             //most of these things are not necesary
148 
149         balances[msg.sender] = balances[msg.sender].sub(_value);
150         balances[_to] = balances[_to].add(_value);
151         Transfer(msg.sender, _to, _value);
152         return true;
153     }
154 
155     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
156         if (frozenAccount[msg.sender]) return false;
157         require(
158             (allowed[_from][msg.sender] >= _value) // Check allowance
159             && (balances[_from] >= _value) // Check if the sender has enough
160             && (_value > 0) // Don't allow 0value transfer
161             && (_to != address(0)) // Prevent transfer to 0x0 address
162             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
163             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
164             //most of these things are not necesary
165         );
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     function approve(address _spender, uint256 _value) returns (bool success) {
174         /* To change the approve amount you first have to reduce the addresses`
175          * allowance to zero by calling `approve(_spender, 0)` if it is not
176          * already 0 to mitigate the race condition described here:
177          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
178         
179         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
180         allowed[msg.sender][_spender] = _value;
181 
182         // Notify anyone listening that this approval done
183         Approval(msg.sender, _spender, _value);
184         return true;
185     }
186     
187     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
188       return allowed[_owner][_spender];
189     }
190   
191 }
192 contract HZMCOIN is HZMStandardToken {
193 
194     /* Public variables of the token */
195     /*
196     NOTE:
197     The following variables are OPTIONAL vanities. One does not have to include them.
198     They allow one to customise the token contract & in no way influences the core functionality.
199     Some wallets/interfaces might not even bother to look at this information.
200     */
201     
202     uint256 constant public decimals = 8; //How many decimals to show.
203     uint256 public totalSupply = 10 * (10**10) * 10**8 ; // 100 billion tokens, 8 decimal places
204     string constant public name = "HZMCOIN"; //fancy name: eg HZM COIN
205     string constant public symbol = "HZM"; //An identifier: eg HZM
206     string constant public version = "v2";       //Version 2 standard. Just an arbitrary versioning scheme.
207     
208     function HZMCOIN(){
209         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
210     }
211 
212     /* Approves and then calls the receiving contract */
213     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
214         allowed[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216 
217         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
218         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
219         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
220         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
221         return true;
222     }
223 }