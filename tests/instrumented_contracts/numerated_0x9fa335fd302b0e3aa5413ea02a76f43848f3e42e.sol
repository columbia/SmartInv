1 pragma solidity ^0.4.16;
2 // VIRTUAL TALK Token Smart contract based on the full ERC20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Verified Status: ERC20 Verified Token
5 // VIRTUAL TALK tokens Symbol: VTT 
6 
7 
8 contract VIRTUALTALKToken { 
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
23     function balanceOf(address _owner) constant returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /**
55  * VIRTUAL TALK tokens Math operations with safety checks to avoid unnecessary conflicts
56  */
57 
58 library ABCMaths {
59 // Saftey Checks for Multiplication Tasks
60   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 // Saftey Checks for Divison Tasks
66   function div(uint256 a, uint256 b) internal constant returns (uint256) {
67     assert(b > 0);
68     uint256 c = a / b;
69     assert(a == b * c + a % b);
70     return c;
71   }
72 // Saftey Checks for Subtraction Tasks
73   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 // Saftey Checks for Addition Tasks
78   function add(uint256 a, uint256 b) internal constant returns (uint256) {
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
93     function Ownable() {
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
108     function transferOwnership(address _newOwner) onlyOwner {
109         if (_newOwner != address(0)) {
110             owner = _newOwner;
111         }
112     }
113 
114     function acceptOwnership() {
115         require(msg.sender == newOwner);
116         OwnershipTransferred(owner, newOwner);
117         owner = newOwner;
118     }
119     event OwnershipTransferred(address indexed _from, address indexed _to);
120 }
121 
122 
123 contract VTTStandardToken is VIRTUALTALKToken, Ownable {
124     
125     using ABCMaths for uint256;
126     mapping (address => uint256) balances;
127     mapping (address => mapping (address => uint256)) allowed;
128     mapping (address => bool) public frozenAccount;
129 
130     event FrozenFunds(address target, bool frozen);
131      
132     function balanceOf(address _owner) constant returns (uint256 balance) {
133         return balances[_owner];
134     }
135 
136     function freezeAccount(address target, bool freeze) onlyOwner {
137         frozenAccount[target] = freeze;
138         FrozenFunds(target, freeze);
139     }
140 
141     function transfer(address _to, uint256 _value) returns (bool success) {
142         if (frozenAccount[msg.sender]) return false;
143         require(
144             (balances[msg.sender] >= _value) // Check if the sender has enough
145             && (_value > 0) // Don't allow 0value transfer
146             && (_to != address(0)) // Prevent transfer to 0x0 address
147             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
148             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
149             //most of these things are not necesary
150 
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         balances[_to] = balances[_to].add(_value);
153         Transfer(msg.sender, _to, _value);
154         return true;
155     }
156 
157     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
158         if (frozenAccount[msg.sender]) return false;
159         require(
160             (allowed[_from][msg.sender] >= _value) // Check allowance
161             && (balances[_from] >= _value) // Check if the sender has enough
162             && (_value > 0) // Don't allow 0value transfer
163             && (_to != address(0)) // Prevent transfer to 0x0 address
164             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
165             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
166             //most of these things are not necesary
167         );
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171         Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     function approve(address _spender, uint256 _value) returns (bool success) {
176         /* To change the approve amount you first have to reduce the addresses`
177          * allowance to zero by calling `approve(_spender, 0)` if it is not
178          * already 0 to mitigate the race condition described here:
179          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
180         
181         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182         allowed[msg.sender][_spender] = _value;
183 
184         // Notify anyone listening that this approval done
185         Approval(msg.sender, _spender, _value);
186         return true;
187     }
188     
189     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
190       return allowed[_owner][_spender];
191     }
192   
193 }
194 contract VIRTUALTALK is VTTStandardToken {
195 
196     /* Public variables of the token */
197     /*
198     NOTE:
199     The following variables are OPTIONAL vanities. One does not have to include them.
200     They allow one to customise the token contract & in no way influences the core functionality.
201     Some wallets/interfaces might not even bother to look at this information.
202     */
203     
204     uint256 constant public decimals = 8;
205     uint256 public totalSupply = 300 * (10**7) * 10**8 ; // 3 BILLIONS tokens, 8 decimal places, 
206     string constant public name = "VIRTUAL TALK";
207     string constant public symbol = "VTT";
208     
209     function VIRTUALTALK(){
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