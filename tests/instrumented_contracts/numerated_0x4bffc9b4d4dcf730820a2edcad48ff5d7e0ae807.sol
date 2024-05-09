1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6 
7     function Owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function setOwner(address _newOwner) onlyOwner {
17         owner = _newOwner;
18     }
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal constant returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal constant returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 
50   function toUINT112(uint256 a) internal constant returns(uint112) {
51     assert(uint112(a) == a);
52     return uint112(a);
53   }
54 
55   function toUINT120(uint256 a) internal constant returns(uint120) {
56     assert(uint120(a) == a);
57     return uint120(a);
58   }
59 
60   function toUINT128(uint256 a) internal constant returns(uint128) {
61     assert(uint128(a) == a);
62     return uint128(a);
63   }
64 }
65 
66 
67 // Abstract contract for the full ERC 20 Token standard
68 // https://github.com/ethereum/EIPs/issues/20
69 
70 contract Token {
71     /* This is a slight change to the ERC20 base standard.
72     function totalSupply() constant returns (uint256 supply);
73     is replaced with:
74     uint256 public totalSupply;
75     This automatically creates a getter function for the totalSupply.
76     This is moved to the base contract since public getter functions are not
77     currently recognised as an implementation of the matching abstract
78     function by the compiler.
79     */
80     /// total amount of tokens
81     //uint256 public totalSupply;
82     function totalSupply() constant returns (uint256 supply);
83 
84     /// @param _owner The address from which the balance will be retrieved
85     /// @return The balance
86     function balanceOf(address _owner) constant returns (uint256 balance);
87 
88     /// @notice send `_value` token to `_to` from `msg.sender`
89     /// @param _to The address of the recipient
90     /// @param _value The amount of token to be transferred
91     /// @return Whether the transfer was successful or not
92     function transfer(address _to, uint256 _value) returns (bool success);
93 
94     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
95     /// @param _from The address of the sender
96     /// @param _to The address of the recipient
97     /// @param _value The amount of token to be transferred
98     /// @return Whether the transfer was successful or not
99     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
100 
101     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
102     /// @param _spender The address of the account able to transfer the tokens
103     /// @param _value The amount of wei to be approved for transfer
104     /// @return Whether the approval was successful or not
105     function approve(address _spender, uint256 _value) returns (bool success);
106 
107     /// @param _owner The address of the account owning tokens
108     /// @param _spender The address of the account able to transfer the tokens
109     /// @return Amount of remaining tokens allowed to spent
110     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
111 
112     event Transfer(address indexed _from, address indexed _to, uint256 _value);
113     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 }
115 
116 
117 /// INC token, ERC20 compliant
118 contract INC is Token, Owned {
119     using SafeMath for uint256;
120 
121     string public constant name    = "Influence Chain Token";  //The Token's name
122     uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
123     string public constant symbol  = "INC";            //An identifier    
124 
125     // packed to 256bit to save gas usage.
126     struct Supplies {
127         // uint128's max value is about 3e38.
128         // it's enough to present amount of tokens
129         uint128 total;
130     }
131 
132     Supplies supplies;
133 
134     // Packed to 256bit to save gas usage.    
135     struct Account {
136         // uint112's max value is about 5e33.
137         // it's enough to present amount of tokens
138         uint112 balance;
139         // safe to store timestamp
140         uint32 lastMintedTimestamp;
141     }
142 
143     // Balances for each account
144     mapping(address => Account) accounts;
145 
146     // Owner of account approves the transfer of an amount to another account
147     mapping(address => mapping(address => uint256)) allowed;
148 
149 
150     // Constructor
151     function INC() {
152     	supplies.total = 1 * (10 ** 9) * (10 ** 18);
153     }
154 
155     function totalSupply() constant returns (uint256 supply){
156         return supplies.total;
157     }
158 
159     // Send back ether sent to me
160     function () {
161         revert();
162     }
163 
164     // If sealed, transfer is enabled 
165     function isSealed() constant returns (bool) {
166         return owner == 0;
167     }
168     
169     function lastMintedTimestamp(address _owner) constant returns(uint32) {
170         return accounts[_owner].lastMintedTimestamp;
171     }
172 
173     // What is the balance of a particular account?
174     function balanceOf(address _owner) constant returns (uint256 balance) {
175         return accounts[_owner].balance;
176     }
177 
178     // Transfer the balance from owner's account to another account
179     function transfer(address _to, uint256 _amount) returns (bool success) {
180         require(isSealed());
181 
182         // according to INC's total supply, never overflow here
183         if (accounts[msg.sender].balance >= _amount
184             && _amount > 0) {            
185             accounts[msg.sender].balance -= uint112(_amount);
186             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
187             Transfer(msg.sender, _to, _amount);
188             return true;
189         } else {
190             return false;
191         }
192     }
193 
194     // Send _value amount of tokens from address _from to address _to
195     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
196     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
197     // fees in sub-currencies; the command should fail unless the _from account has
198     // deliberately authorized the sender of the message via some mechanism; we propose
199     // these standardized APIs for approval:
200     function transferFrom(
201         address _from,
202         address _to,
203         uint256 _amount
204     ) returns (bool success) {
205         require(isSealed());
206 
207         // according to INC's total supply, never overflow here
208         if (accounts[_from].balance >= _amount
209             && allowed[_from][msg.sender] >= _amount
210             && _amount > 0) {
211             accounts[_from].balance -= uint112(_amount);
212             allowed[_from][msg.sender] -= _amount;
213             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
214             Transfer(_from, _to, _amount);
215             return true;
216         } else {
217             return false;
218         }
219     }
220 
221     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
222     // If this function is called again it overwrites the current allowance with _value.
223     function approve(address _spender, uint256 _amount) returns (bool success) {
224         allowed[msg.sender][_spender] = _amount;
225         Approval(msg.sender, _spender, _amount);
226         return true;
227     }
228 
229     /* Approves and then calls the receiving contract */
230     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
231         allowed[msg.sender][_spender] = _value;
232         Approval(msg.sender, _spender, _value);
233 
234         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
235         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
236         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
237         //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
238         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
239         return true;
240     }
241 
242     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
243         return allowed[_owner][_spender];
244     }
245     
246     function mint0(address _owner, uint256 _amount) onlyOwner {
247     		accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();
248 
249         accounts[_owner].lastMintedTimestamp = uint32(block.timestamp);
250 
251         //supplies.total = _amount.add(supplies.total).toUINT128();
252         Transfer(0, _owner, _amount);
253     }
254     
255     // Mint tokens and assign to some one
256     function mint(address _owner, uint256 _amount, uint32 timestamp) onlyOwner{
257         accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();
258 
259         accounts[_owner].lastMintedTimestamp = timestamp;
260 
261         supplies.total = _amount.add(supplies.total).toUINT128();
262         Transfer(0, _owner, _amount);
263     }
264 
265     // Set owner to zero address, to disable mint, and enable token transfer
266     function seal() onlyOwner {
267         setOwner(0);
268     }
269 }
270 
271 contract ApprovalReceiver {
272     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData);
273 }