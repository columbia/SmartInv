1 pragma solidity ^0.4.16;
2 // ERC20 Smartcontract for GanaEightCoin, for more information visit http://ganapati.io
3 // Symbol: G8C
4 // Status: ERC20 Verified
5 
6 contract GANAPATIToken { 
7 
8     
9     /// total amount of tokens
10     uint256 public totalSupply;
11     
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance);
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success);
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success);
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /**
46  * GANAPATIToken Math operations with safety checks to avoid unnecessary conflicts
47  */
48 
49 library EROMaths {
50 // Saftey Checks for Multiplication Tasks
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 // Saftey Checks for Divison Tasks
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     assert(b > 0);
59     uint256 c = a / b;
60     assert(a == b * c + a % b);
61     return c;
62   }
63 // Saftey Checks for Subtraction Tasks
64   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 // Saftey Checks for Addition Tasks
69   function add(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a + b;
71     assert(c>=a && c>=b);
72     return c;
73   }
74 }
75 
76 contract Ownable {
77     address public owner;
78     address public newOwner;
79 
80     /** 
81      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82      * account.
83      */
84     function Ownable() {
85         owner = msg.sender;
86     }
87 
88     modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93    // validates an address - currently only checks that it isn't null
94     modifier validAddress(address _address) {
95         require(_address != 0x0);
96         _;
97     }
98 
99     function transferOwnership(address _newOwner) onlyOwner {
100         if (_newOwner != address(0)) {
101             owner = _newOwner;
102         }
103     }
104 
105     function acceptOwnership() {
106         require(msg.sender == newOwner);
107         OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109     }
110     event OwnershipTransferred(address indexed _from, address indexed _to);
111 }
112 
113 
114 contract G8CStandardToken is GANAPATIToken, Ownable {
115     
116     using EROMaths for uint256;
117     mapping (address => uint256) balances;
118     mapping (address => mapping (address => uint256)) allowed;
119     mapping (address => bool) public frozenAccount;
120 
121     event FrozenFunds(address target, bool frozen);
122      
123     function balanceOf(address _owner) constant returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127     function freezeAccount(address target, bool freeze) onlyOwner {
128         frozenAccount[target] = freeze;
129         FrozenFunds(target, freeze);
130     }
131 
132     function transfer(address _to, uint256 _value) returns (bool success) {
133         if (frozenAccount[msg.sender]) return false;
134         require(
135             (balances[msg.sender] >= _value) // Check if the sender has enough
136             && (_value > 0) // Don't allow 0value transfer
137             && (_to != address(0)) // Prevent transfer to 0x0 address
138             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
139             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
140             //most of these things are not necesary
141 
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
149         if (frozenAccount[msg.sender]) return false;
150         require(
151             (allowed[_from][msg.sender] >= _value) // Check allowance
152             && (balances[_from] >= _value) // Check if the sender has enough
153             && (_value > 0) // Don't allow 0value transfer
154             && (_to != address(0)) // Prevent transfer to 0x0 address
155             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
156             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
157             //most of these things are not necesary
158         );
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     function approve(address _spender, uint256 _value) returns (bool success) {
167         /* To change the approve amount you first have to reduce the addresses`
168          * allowance to zero by calling `approve(_spender, 0)` if it is not
169          * already 0 to mitigate the race condition described here:
170          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
171         
172         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
173         allowed[msg.sender][_spender] = _value;
174 
175         // Notify anyone listening that this approval done
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179     
180     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181       return allowed[_owner][_spender];
182     }
183   
184 }
185 contract G8C is G8CStandardToken {
186 
187     /* Public variables of the token */
188     /*
189     NOTE:
190     The following variables are OPTIONAL vanities. One does not have to include them.
191     They allow one to customise the token contract & in no way influences the core functionality.
192     Some wallets/interfaces might not even bother to look at this information.
193     */
194     
195     uint256 constant public decimals = 8; //How many decimals to show.
196     uint256 public totalSupply = 100 * (10**7) * 10**8 ; // 1 billion tokens, 8 decimal places
197     string constant public name = "G8C"; 
198     string constant public symbol = "G8C"; 
199     string constant public version = "v2";  
200     
201     function G8C(){
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