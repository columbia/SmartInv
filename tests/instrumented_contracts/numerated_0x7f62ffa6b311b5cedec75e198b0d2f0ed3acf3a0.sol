1 pragma solidity ^0.4.16;
2 // EROSCOIN Alpha contract based on the full ERC 20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Symbol: ERO
5 // Status: ERC20 Verified
6 
7 contract EROSToken { 
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
54  * EROSToken Math operations with safety checks to avoid unnecessary conflicts
55  */
56 
57 library EROMaths {
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
122 contract EroStandardToken is EROSToken, Ownable {
123     
124     using EROMaths for uint256;
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
143             (balances[msg.sender] >= _value)
144             && (_value > 0)
145             && (_to != address(0))
146             && (balances[_to].add(_value) >= balances[_to])
147             && (msg.data.length >= (2 * 32) + 4));
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
158             (allowed[_from][msg.sender] >= _value) 
159             && (balances[_from] >= _value) 
160             && (_value > 0) 
161             && (_to != address(0)) 
162             && (balances[_to].add(_value) >= balances[_to])
163             && (msg.data.length >= (2 * 32) + 4) 
164         );
165         balances[_from] = balances[_from].sub(_value);
166         balances[_to] = balances[_to].add(_value);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         Transfer(_from, _to, _value);
169         return true;
170     }
171 
172     function approve(address _spender, uint256 _value) returns (bool success) {
173         /* To change the approve amount you first have to reduce the addresses`
174          * allowance to zero by calling `approve(_spender, 0)` if it is not
175          * already 0 to mitigate the race condition described here:
176          * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
177         
178         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
179         allowed[msg.sender][_spender] = _value;
180 
181         // Notify anyone listening that this approval done
182         Approval(msg.sender, _spender, _value);
183         return true;
184     }
185     
186     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
187       return allowed[_owner][_spender];
188     }
189   
190 }
191 contract EROSCOIN is EroStandardToken {
192 
193     /* Public variables of the token */
194     /*
195     NOTE:
196     The following variables are OPTIONAL vanities. One does not have to include them.
197     They allow one to customise the token contract & in no way influences the core functionality.
198     Some wallets/interfaces might not even bother to look at this information.
199     */
200     
201     uint256 constant public decimals = 8; //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 TTC = 980 base units. It's like comparing 1 wei to 1 ether.
202     uint256 public totalSupply = 240 * (10**7) * 10**8 ; // 2.4 billion tokens, 8 decimal places
203     string constant public name = "EROSCOIN"; //fancy name: eg EROSCOIN Alpha
204     string constant public symbol = "ERO"; //An identifier: eg ERO
205     string constant public version = "v1.1.3";       //Version 0.1.6 standard. Just an arbitrary versioning scheme.
206     
207     function EROSCOIN(){
208         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
209     }
210 
211     /* Approves and then calls the receiving contract */
212     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
213         allowed[msg.sender][_spender] = _value;
214         Approval(msg.sender, _spender, _value);
215 
216         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
217         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
218         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
219         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
220         return true;
221     }
222 }