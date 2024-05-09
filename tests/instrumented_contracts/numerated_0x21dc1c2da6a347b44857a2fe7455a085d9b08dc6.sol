1 /*
2           ,/A.
3         ,'/ __`.
4       ,'_/_  _ _`.
5     ,'__/_ ___ __ `.
6   ,'_  /___ __ _ __ `.
7  '-.._/____ ___ _ ____`.
8 B    C                  D
9 
10  Electrim 2. A no-bullshit, transparent, self-sustaining pyramid scheme.
11  
12  Inspired by https://Electrim.io/
13 */
14 
15 pragma solidity ^0.4.18;
16 // Smartcontract ECM Coin
17 // https://github.com/ethereum/EIPs/issues/20
18 
19 // Verified Status: ERC20 Verified Token
20 // Lexon Coin Symbol: ECM
21 
22 
23 contract ElectrimToken { 
24     /* This is a slight change to the ERC20 base standard.
25     function totalSupply() constant returns (uint256 supply);
26     is replaced with:
27     uint256 public totalSupply;
28     This automatically creates a getter function for the totalSupply.
29     This is moved to the base contract since public getter functions are not
30     currently recognised as an implementation of the matching abstract
31     function by the compiler.
32     */
33     /// total amount of tokens
34     uint256 public totalSupply;
35     
36     /// @param _owner The address from which the balance will be retrieved
37     /// @return The balance
38     function balanceOf(address _owner) constant returns (uint256 balance);
39 
40     /// @notice send `_value` token to `_to` from `msg.sender`
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transfer(address _to, uint256 _value) returns (bool success);
45 
46     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
47     /// @param _from The address of the sender
48     /// @param _to The address of the recipient
49     /// @param _value The amount of token to be transferred
50     /// @return Whether the transfer was successful or not
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
52 
53     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
54     /// @param _spender The address of the account able to transfer the tokens
55     /// @param _value The amount of wei to be approved for transfer
56     /// @return Whether the approval was successful or not
57     function approve(address _spender, uint256 _value) returns (bool success);
58 
59     /// @param _owner The address of the account owning tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @return Amount of remaining tokens allowed to spent
62     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 }
67 
68 
69 /**
70  * Electrim Token Math operations with safety checks to avoid unnecessary conflicts
71  */
72 
73 library ECMMaths {
74 // Saftey Checks for Multiplication Tasks
75   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
76     uint256 c = a * b;
77     assert(a == 0 || c / a == b);
78     return c;
79   }
80 // Saftey Checks for Divison Tasks
81   function div(uint256 a, uint256 b) internal constant returns (uint256) {
82     assert(b > 0);
83     uint256 c = a / b;
84     assert(a == b * c + a % b);
85     return c;
86   }
87 // Saftey Checks for Subtraction Tasks
88   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 // Saftey Checks for Addition Tasks
93   function add(uint256 a, uint256 b) internal constant returns (uint256) {
94     uint256 c = a + b;
95     assert(c>=a && c>=b);
96     return c;
97   }
98 }
99 
100 contract Ownable {
101     address public owner;
102     address public newOwner;
103 
104     /** 
105      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
106      * account.
107      */
108     function Ownable() {
109         owner = msg.sender;
110     }
111 
112     modifier onlyOwner() {
113     require(msg.sender == owner);
114     _;
115   }
116 
117    // validates an address - currently only checks that it isn't null
118     modifier validAddress(address _address) {
119         require(_address != 0x0);
120         _;
121     }
122 
123     function transferOwnership(address _newOwner) onlyOwner {
124         if (_newOwner != address(0)) {
125             owner = _newOwner;
126         }
127     }
128 
129     function acceptOwnership() {
130         require(msg.sender == newOwner);
131         OwnershipTransferred(owner, newOwner);
132         owner = newOwner;
133     }
134     event OwnershipTransferred(address indexed _from, address indexed _to);
135 }
136 
137 
138 contract ECMStandardToken is ElectrimToken, Ownable {
139     
140     using ECMMaths for uint256;
141     mapping (address => uint256) balances;
142     mapping (address => mapping (address => uint256)) allowed;
143     mapping (address => bool) public frozenAccount;
144 
145     event FrozenFunds(address target, bool frozen);
146      
147     function balanceOf(address _owner) constant returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151     function freezeAccount(address target, bool freeze) onlyOwner {
152         frozenAccount[target] = freeze;
153         FrozenFunds(target, freeze);
154     }
155 
156     function transfer(address _to, uint256 _value) returns (bool success) {
157         if (frozenAccount[msg.sender]) return false;
158         require(
159             (balances[msg.sender] >= _value) // Check if the sender has enough
160             && (_value > 0) // Don't allow 0value transfer
161             && (_to != address(0)) // Prevent transfer to 0x0 address
162             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
163             && (msg.data.length >= (2 * 32) + 4)); //mitigates the ERC20 short address attack
164             //most of these things are not necesary
165 
166         balances[msg.sender] = balances[msg.sender].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         Transfer(msg.sender, _to, _value);
169         return true;
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
173         if (frozenAccount[msg.sender]) return false;
174         require(
175             (allowed[_from][msg.sender] >= _value) // Check allowance
176             && (balances[_from] >= _value) // Check if the sender has enough
177             && (_value > 0) // Don't allow 0value transfer
178             && (_to != address(0)) // Prevent transfer to 0x0 address
179             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
180             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
181             //most of these things are not necesary
182         );
183         balances[_from] = balances[_from].sub(_value);
184         balances[_to] = balances[_to].add(_value);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     function approve(address _spender, uint256 _value) returns (bool success) {
191         /* To change the approve amount you first have to reduce the addresses`
192          * allowance to zero by calling `approve(_spender, 0)` if it is not
193          * already 0 to mitigate the race condition described here:*/
194         
195         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
196         allowed[msg.sender][_spender] = _value;
197 
198         // Notify anyone listening that this approval done
199         Approval(msg.sender, _spender, _value);
200         return true;
201     }
202     
203     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
204       return allowed[_owner][_spender];
205     }
206   
207 }
208 contract Electrim is ECMStandardToken {
209 
210     /* Public variables of the token */
211     /*
212     NOTE:
213     The following variables are OPTIONAL vanities. One does not have to include them.
214     They allow one to customise the token contract & in no way influences the core functionality.
215     Some wallets/interfaces might not even bother to look at this information.
216     */
217     
218     uint256 constant public decimals = 18;
219     uint256 public totalSupply = 1000000000000000000000000000 ; // 1 billion tokens, 18 decimal places
220     string constant public name = "Electrim";
221     string constant public symbol = "ECM";
222     string  public constant website = "Electrim.io"; 
223     
224     function Electrim(){
225         balances[msg.sender] = totalSupply;               // Give the creator all initial tokens
226     }
227 
228     /* Approves and then calls the receiving contract */
229     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
230         allowed[msg.sender][_spender] = _value;
231         Approval(msg.sender, _spender, _value);
232 
233         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
234         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
235         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
236         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
237         return true;
238     }
239 }