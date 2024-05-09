1 pragma solidity ^0.4.16;
2 // Litecore contract based on the full ERC20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Verified Status: ERC20 Verified Token
5 // LITECORE Symbol: LTX
6 
7 
8 contract LITECOREToken { 
9 
10     /// total amount of tokens
11     uint256 public totalSupply;
12     
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) constant returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 
46 /**
47  * LITECORE Token Math operations with safety checks to avoid unnecessary conflicts
48  */
49 
50 library ABCMaths {
51 // Saftey Checks for Multiplication Tasks
52   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57 // Saftey Checks for Divison Tasks
58   function div(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b > 0);
60     uint256 c = a / b;
61     assert(a == b * c + a % b);
62     return c;
63   }
64 // Saftey Checks for Subtraction Tasks
65   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69 // Saftey Checks for Addition Tasks
70   function add(uint256 a, uint256 b) internal constant returns (uint256) {
71     uint256 c = a + b;
72     assert(c>=a && c>=b);
73     return c;
74   }
75 }
76 
77 contract Ownable {
78     address public owner;
79     address public newOwner;
80 
81     /** 
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     function Ownable() {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner() {
90     require(msg.sender == owner);
91     _;
92   }
93 
94    // validates an address - currently only checks that it isn't null
95     modifier validAddress(address _address) {
96         require(_address != 0x0);
97         _;
98     }
99 
100     function transferOwnership(address _newOwner) onlyOwner {
101         if (_newOwner != address(0)) {
102             owner = _newOwner;
103         }
104     }
105 
106     function acceptOwnership() {
107         require(msg.sender == newOwner);
108         OwnershipTransferred(owner, newOwner);
109         owner = newOwner;
110     }
111     event OwnershipTransferred(address indexed _from, address indexed _to);
112 }
113 
114 
115 contract LTXStandardToken is LITECOREToken, Ownable {
116     
117     using ABCMaths for uint256;
118     mapping (address => uint256) balances;
119     mapping (address => mapping (address => uint256)) allowed;
120     mapping (address => bool) public frozenAccount;
121 
122     event FrozenFunds(address target, bool frozen);
123      
124     function balanceOf(address _owner) constant returns (uint256 balance) {
125         return balances[_owner];
126     }
127 
128     function freezeAccount(address target, bool freeze) onlyOwner {
129         frozenAccount[target] = freeze;
130         FrozenFunds(target, freeze);
131     }
132 
133     function transfer(address _to, uint256 _value) returns (bool success) {
134         if (frozenAccount[msg.sender]) return false;
135         require(
136             (balances[msg.sender] >= _value) // Check if the sender has enough
137             && (_value > 0) // Don't allow 0value transfer
138             && (_to != address(0)) // Prevent transfer to 0x0 address
139             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
140             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
141             //most of these things are not necesary
142 
143         balances[msg.sender] = balances[msg.sender].sub(_value);
144         balances[_to] = balances[_to].add(_value);
145         Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
150         if (frozenAccount[msg.sender]) return false;
151         require(
152             (allowed[_from][msg.sender] >= _value) // Check allowance
153             && (balances[_from] >= _value) // Check if the sender has enough
154             && (_value > 0) // Don't allow 0value transfer
155             && (_to != address(0)) // Prevent transfer to 0x0 address
156             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
157             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
158             //most of these things are not necesary
159         );
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function approve(address _spender, uint256 _value) returns (bool success) {
168         /* To change the approve amount you first have to reduce the addresses`
169          * allowance to zero by calling `approve(_spender, 0)` if it is not
170          * already 0 to mitigate the race condition described here:
171          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
172         
173         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
174         allowed[msg.sender][_spender] = _value;
175 
176         // Notify anyone listening that this approval done
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180     
181     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182       return allowed[_owner][_spender];
183     }
184   
185 }
186 contract LITECORE is LTXStandardToken {
187 
188     /* Public variables of the token */
189     /*
190     NOTE:
191     The following variables are OPTIONAL vanities. One does not have to include them.
192     They allow one to customise the token contract & in no way influences the core functionality.
193     Some wallets/interfaces might not even bother to look at this information.
194     */
195     
196     uint256 constant public decimals = 8;
197     uint256 public totalSupply = 3000000000000000 ; // 30 million tokens, 8 decimal places
198     string constant public name = "LITECORE";
199     string constant public symbol = "LTX";
200     
201     function LITECORE(){
202         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
203     }
204 
205     /* Approves and then calls the receiving contract */
206     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209 
210         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
211         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
212         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
213         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
214         return true;
215     }
216 }