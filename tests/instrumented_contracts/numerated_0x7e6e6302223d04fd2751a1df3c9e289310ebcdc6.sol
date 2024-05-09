1 pragma solidity ^0.4.16;
2 // Obsidian Smart Pay contract based on the full ERC20 Token Standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Smartcontract for Obsidian Smart Pay (OSP), for more information visit http://obsidianpaymentsolutions.com/
5 // Verified Status: ERC20 Verified Token
6 // Obsidian Smart Pay Symbol: OSP
7 
8 
9 contract ObsidianSmartPayToken { 
10     /* This is a slight change to the ERC20 base standard.
11     function totalSupply() constant returns (uint256 supply);
12     is replaced with:
13     uint256 public totalSupply;
14     This automatically creates a getter function for the totalSupply.
15     This is moved to the base contract since public getter functions are not
16     currently recognised as an implementation of the matching abstract
17     function by the compiler.
18     */
19     /// total amount of tokens
20     uint256 public totalSupply;
21     
22     /// @param _owner The address from which the balance will be retrieved
23     /// @return The balance
24     function balanceOf(address _owner) constant returns (uint256 balance);
25 
26     /// @notice send `_value` token to `_to` from `msg.sender`
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transfer(address _to, uint256 _value) returns (bool success);
31 
32     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
33     /// @param _from The address of the sender
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
38 
39     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @param _value The amount of wei to be approved for transfer
42     /// @return Whether the approval was successful or not
43     function approve(address _spender, uint256 _value) returns (bool success);
44 
45     /// @param _owner The address of the account owning tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @return Amount of remaining tokens allowed to spent
48     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 /**
56  * Obsidian Smart Pay Token Math operations with safety checks to avoid unnecessary conflicts
57  */
58 
59 library OSPMaths {
60 // Saftey Checks for Multiplication Tasks
61   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
62     uint256 c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 // Saftey Checks for Divison Tasks
67   function div(uint256 a, uint256 b) internal constant returns (uint256) {
68     assert(b > 0);
69     uint256 c = a / b;
70     assert(a == b * c + a % b);
71     return c;
72   }
73 // Saftey Checks for Subtraction Tasks
74   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 // Saftey Checks for Addition Tasks
79   function add(uint256 a, uint256 b) internal constant returns (uint256) {
80     uint256 c = a + b;
81     assert(c>=a && c>=b);
82     return c;
83   }
84 }
85 
86 contract Ownable {
87     address public owner;
88     address public newOwner;
89 
90     /** 
91      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92      * account.
93      */
94     function Ownable() {
95         owner = msg.sender;
96     }
97 
98     modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103    // validates an address - currently only checks that it isn't null
104     modifier validAddress(address _address) {
105         require(_address != 0x0);
106         _;
107     }
108 
109     function transferOwnership(address _newOwner) onlyOwner {
110         if (_newOwner != address(0)) {
111             owner = _newOwner;
112         }
113     }
114 
115     function acceptOwnership() {
116         require(msg.sender == newOwner);
117         OwnershipTransferred(owner, newOwner);
118         owner = newOwner;
119     }
120     event OwnershipTransferred(address indexed _from, address indexed _to);
121 }
122 
123 
124 contract OSPStandardToken is ObsidianSmartPayToken, Ownable {
125     
126     using OSPMaths for uint256;
127     mapping (address => uint256) balances;
128     mapping (address => mapping (address => uint256)) allowed;
129     mapping (address => bool) public frozenAccount;
130 
131     event FrozenFunds(address target, bool frozen);
132      
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function freezeAccount(address target, bool freeze) onlyOwner {
138         frozenAccount[target] = freeze;
139         FrozenFunds(target, freeze);
140     }
141 
142     function transfer(address _to, uint256 _value) returns (bool success) {
143         if (frozenAccount[msg.sender]) return false;
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
158     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
159         if (frozenAccount[msg.sender]) return false;
160         require(
161             (allowed[_from][msg.sender] >= _value) // Check allowance
162             && (balances[_from] >= _value) // Check if the sender has enough
163             && (_value > 0) // Don't allow 0value transfer
164             && (_to != address(0)) // Prevent transfer to 0x0 address
165             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
166             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
167             //most of these things are not necesary
168         );
169         balances[_from] = balances[_from].sub(_value);
170         balances[_to] = balances[_to].add(_value);
171         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172         Transfer(_from, _to, _value);
173         return true;
174     }
175 
176     function approve(address _spender, uint256 _value) returns (bool success) {
177         /* To change the approve amount you first have to reduce the addresses`
178          * allowance to zero by calling `approve(_spender, 0)` if it is not
179          * already 0 to mitigate the race condition described here:
180          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
181         
182         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183         allowed[msg.sender][_spender] = _value;
184 
185         // Notify anyone listening that this approval done
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189     
190     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
191       return allowed[_owner][_spender];
192     }
193   
194 }
195 contract ObsidianSmartPay is OSPStandardToken {
196 
197     /* Public variables of the token */
198     /*
199     NOTE:
200     The following variables are OPTIONAL vanities. One does not have to include them.
201     They allow one to customise the token contract & in no way influences the core functionality.
202     Some wallets/interfaces might not even bother to look at this information.
203     */
204     
205     uint256 constant public decimals = 8;
206     uint256 public totalSupply = 21400000000000000 ; // 214 million tokens, 8 decimal places
207     string constant public name = "Obsidian Smart Pay";
208     string constant public symbol = "OSP";
209     
210     function ObsidianSmartPay(){
211         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
212     }
213 
214     /* Approves and then calls the receiving contract */
215     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
216         allowed[msg.sender][_spender] = _value;
217         Approval(msg.sender, _spender, _value);
218 
219         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
220         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
221         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
222         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
223         return true;
224     }
225 }