1 pragma solidity ^0.4.16;
2 // VIRAL Token contract based on the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Symbol: VRT
5 // Status: ERC20 Verified
6 
7 contract VIRALToken { 
8     /* This is a slight change to the ERC20 base standard.
9     function totalSupply() constant returns (uint256 supply);
10     is replaced with:
11     uint256 public totalSupply;
12     This automatically creates a getter function for the totalSupply.
13     This is moved to the base contract since public getter functions are not
14     currently recognised as an implementation of the matching abstract
15     function by the compiler.
16     */
17     /// total amount of tokens
18     uint256 public totalSupply;
19     
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) constant returns (uint256 balance);
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) returns (bool success);
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) returns (bool success);
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 /**
54  * VIRALToken Math operations with safety checks to avoid unnecessary conflicts
55  */
56 
57 library VRTMaths {
58 // Saftey Checks for Multiplication Tasks
59   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
60     uint256 c = a * b;
61     assert(a == 0 || c / a == b);
62     return c;
63   }
64 // Saftey Checks for Divison Tasks
65   function div(uint256 a, uint256 b) internal constant returns (uint256) {
66     assert(b > 0);
67     uint256 c = a / b;
68     assert(a == b * c + a % b);
69     return c;
70   }
71 // Saftey Checks for Subtraction Tasks
72   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
73     assert(b <= a);
74     return a - b;
75   }
76 // Saftey Checks for Addition Tasks
77   function add(uint256 a, uint256 b) internal constant returns (uint256) {
78     uint256 c = a + b;
79     assert(c>=a && c>=b);
80     return c;
81   }
82 }
83 
84 contract Ownable {
85     address public owner;
86     address public newOwner;
87 
88     /** 
89      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
90      * account.
91      */
92     function Ownable() {
93         owner = msg.sender;
94     }
95 
96     modifier onlyOwner() {
97     require(msg.sender == owner);
98     _;
99   }
100 
101    // validates an address - currently only checks that it isn't null
102     modifier validAddress(address _address) {
103         require(_address != 0x0);
104         _;
105     }
106 
107     function transferOwnership(address _newOwner) onlyOwner {
108         if (_newOwner != address(0)) {
109             owner = _newOwner;
110         }
111     }
112 
113     function acceptOwnership() {
114         require(msg.sender == newOwner);
115         OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117     }
118     event OwnershipTransferred(address indexed _from, address indexed _to);
119 }
120 
121 
122 contract VRTStandardToken is VIRALToken, Ownable {
123     
124     using VRTMaths for uint256;
125     mapping (address => uint256) balances;
126     mapping (address => mapping (address => uint256)) allowed;
127     mapping (address => bool) public frozenAccount;
128 
129     event FrozenFunds(address target, bool frozen);
130      
131     function balanceOf(address _owner) constant returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135     function freezeAccount(address target, bool freeze) onlyOwner {
136         frozenAccount[target] = freeze;
137         FrozenFunds(target, freeze);
138     }
139 
140     function transfer(address _to, uint256 _value) returns (bool success) {
141         if (frozenAccount[msg.sender]) return false;
142         require(
143             (balances[msg.sender] >= _value) // Check if the sender has enough
144             && (_value > 0) // Don't allow 0value transfer
145             && (_to != address(0)) // Prevent transfer to 0x0 address
146             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
147             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
148             //most of these things are not necesary
149 
150         balances[msg.sender] = balances[msg.sender].sub(_value);
151         balances[_to] = balances[_to].add(_value);
152         Transfer(msg.sender, _to, _value);
153         return true;
154     }
155 
156     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
157         if (frozenAccount[msg.sender]) return false;
158         require(
159             (allowed[_from][msg.sender] >= _value) // Check allowance
160             && (balances[_from] >= _value) // Check if the sender has enough
161             && (_value > 0) // Don't allow 0value transfer
162             && (_to != address(0)) // Prevent transfer to 0x0 address
163             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
164             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
165             //most of these things are not necesary
166         );
167         balances[_from] = balances[_from].sub(_value);
168         balances[_to] = balances[_to].add(_value);
169         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170         Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function approve(address _spender, uint256 _value) returns (bool success) {
175         /* To change the approve amount you first have to reduce the addresses`
176          * allowance to zero by calling `approve(_spender, 0)` if it is not
177          * already 0 to mitigate the race condition described here:
178          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
179         
180         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181         allowed[msg.sender][_spender] = _value;
182 
183         // Notify anyone listening that this approval done
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187     
188     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
189       return allowed[_owner][_spender];
190     }
191   
192 }
193 contract VIRALTOKEN is VRTStandardToken {
194 
195     /* Public variables of the token */
196     /*
197     NOTE:
198     The following variables are OPTIONAL vanities. One does not have to include them.
199     They allow one to customise the token contract & in no way influences the core functionality.
200     Some wallets/interfaces might not even bother to look at this information.
201     */
202     
203     uint256 constant public decimals = 18; //How many decimals to show.
204     uint256 public totalSupply = 25 * (10**6) * 10**18 ; // 25 million tokens, 18 decimal places
205     string constant public name = "ViralToken"; //fancy name: eg VIRAL
206     string constant public symbol = "VRT"; //An identifier: eg VRT
207     string constant public version = "v2";       //Version 2 standard. Just an arbitrary versioning scheme.
208     
209     function VIRALTOKEN(){
210         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
211     }
212 
213     /* Approves and then calls the receiving contract */
214     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
215         allowed[msg.sender][_spender] = _value;
216         Approval(msg.sender, _spender, _value);
217 
218         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
219         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
220         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
221         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
222         return true;
223     }
224 }