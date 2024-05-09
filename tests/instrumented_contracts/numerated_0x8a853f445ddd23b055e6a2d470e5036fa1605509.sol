1 pragma solidity ^0.4.16;
2 // Luxreum Token contract based on the full ERC20 Token standard
3 // https://github.com/ethereum/EIPs/issues/20
4 // Verified Status: ERC20 Verified Token
5 // Luxreum Symbol: LXR
6 
7 
8 contract LUXREUMToken { 
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13 
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17     
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of wei to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 /**
52  * Luxreum Token Math operations with safety checks to avoid unnecessary conflicts
53  */
54 
55 library ABCMaths {
56 // Saftey Checks for Multiplication Tasks
57   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 // Saftey Checks for Divison Tasks
63   function div(uint256 a, uint256 b) internal constant returns (uint256) {
64     assert(b > 0);
65     uint256 c = a / b;
66     assert(a == b * c + a % b);
67     return c;
68   }
69 // Saftey Checks for Subtraction Tasks
70   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 // Saftey Checks for Addition Tasks
75   function add(uint256 a, uint256 b) internal constant returns (uint256) {
76     uint256 c = a + b;
77     assert(c>=a && c>=b);
78     return c;
79   }
80 }
81 
82 contract Ownable {
83     address public owner;
84     address public newOwner;
85 
86     /** 
87      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
88      * account.
89      */
90     function Ownable() {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner() {
95     require(msg.sender == owner);
96     _;
97   }
98 
99    // validates an address - currently only checks that it isn't null
100     modifier validAddress(address _address) {
101         require(_address != 0x0);
102         _;
103     }
104 
105     function transferOwnership(address _newOwner) onlyOwner {
106         if (_newOwner != address(0)) {
107             owner = _newOwner;
108         }
109     }
110 
111     function acceptOwnership() {
112         require(msg.sender == newOwner);
113         OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115     }
116     event OwnershipTransferred(address indexed _from, address indexed _to);
117 }
118 
119 
120 contract LXRStandardToken is LUXREUMToken, Ownable {
121     
122     using ABCMaths for uint256;
123     mapping (address => uint256) balances;
124     mapping (address => mapping (address => uint256)) allowed;
125     mapping (address => bool) public frozenAccount;
126 
127     event FrozenFunds(address target, bool frozen);
128      
129     function balanceOf(address _owner) constant returns (uint256 balance) {
130         return balances[_owner];
131     }
132 
133     function freezeAccount(address target, bool freeze) onlyOwner {
134         frozenAccount[target] = freeze;
135         FrozenFunds(target, freeze);
136     }
137 
138     function transfer(address _to, uint256 _value) returns (bool success) {
139         if (frozenAccount[msg.sender]) return false;
140         require(
141             (balances[msg.sender] >= _value) // Check if the sender has enough
142             && (_value > 0) // Don't allow 0value transfer
143             && (_to != address(0)) // Prevent transfer to 0x0 address
144             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
145             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
146             //most of these things are not necesary
147 
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
155         if (frozenAccount[msg.sender]) return false;
156         require(
157             (allowed[_from][msg.sender] >= _value) // Check allowance
158             && (balances[_from] >= _value) // Check if the sender has enough
159             && (_value > 0) // Don't allow 0value transfer
160             && (_to != address(0)) // Prevent transfer to 0x0 address
161             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
162             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
163             //most of these things are not necesary
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
191 contract LUXREUM is LXRStandardToken {
192 
193     /* Public variables of the token */
194     /*
195     NOTE:
196  
197     */
198     
199     uint256 constant public decimals = 18;
200     uint256 public totalSupply = 60 * (10**7) * 10**18 ; // 600 million tokens, 16 decimal places
201     string constant public name = "Luxreum";
202     string constant public symbol = "LXR";
203     
204     function LUXREUM(){
205         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
206     }
207 
208     /* Approves and then calls the receiving contract */
209     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
210         allowed[msg.sender][_spender] = _value;
211         Approval(msg.sender, _spender, _value);
212 
213         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
214         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
215         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
216         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
217         return true;
218     }
219 }