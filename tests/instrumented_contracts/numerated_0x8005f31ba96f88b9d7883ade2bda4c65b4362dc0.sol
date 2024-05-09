1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function toUINT112(uint256 a) internal pure returns(uint112) {
33     assert(uint112(a) == a);
34     return uint112(a);
35   }
36 
37   function toUINT120(uint256 a) internal pure returns(uint120) {
38     assert(uint120(a) == a);
39     return uint120(a);
40   }
41 
42   function toUINT128(uint256 a) internal pure returns(uint128) {
43     assert(uint128(a) == a);
44     return uint128(a);
45   }
46 }
47 
48 contract Owned {
49 
50     address public owner;
51 
52     function Owned() public{
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function setOwner(address _newOwner) public onlyOwner {
62         owner = _newOwner;
63     }
64 }
65 
66 // Abstract contract for the full ERC 20 Token standard
67 // https://github.com/ethereum/EIPs/issues/20
68 
69 contract Token {
70     /* This is a slight change to the ERC20 base standard.
71     function totalSupply() constant returns (uint256 supply);
72     is replaced with:
73     uint256 public totalSupply;
74     This automatically creates a getter function for the totalSupply.
75     This is moved to the base contract since public getter functions are not
76     currently recognised as an implementation of the matching abstract
77     function by the compiler.
78     */
79     /// total amount of tokens
80     //uint256 public totalSupply;
81     function totalSupply()public constant returns (uint256 supply);
82 
83     /// @param _owner The address from which the balance will be retrieved
84     /// @return The balance
85     function balanceOf(address _owner)public constant returns (uint256 balance);
86 
87     /// @notice send `_value` token to `_to` from `msg.sender`
88     /// @param _to The address of the recipient
89     /// @param _value The amount of token to be transferred
90     /// @return Whether the transfer was successful or not
91     function transfer(address _to, uint256 _value)public returns (bool success);
92 
93     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
94     /// @param _from The address of the sender
95     /// @param _to The address of the recipient
96     /// @param _value The amount of token to be transferred
97     /// @return Whether the transfer was successful or not
98     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
99 
100     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
101     /// @param _spender The address of the account able to transfer the tokens
102     /// @param _value The amount of wei to be approved for transfer
103     /// @return Whether the approval was successful or not
104     function approve(address _spender, uint256 _value)public returns (bool success);
105 
106     /// @param _owner The address of the account owning tokens
107     /// @param _spender The address of the account able to transfer the tokens
108     /// @return Amount of remaining tokens allowed to spent
109     function allowance(address _owner, address _spender)public constant returns (uint256 remaining);
110 
111 }
112 
113 
114 /// FFC token, ERC20 compliant
115 contract FFC is Token, Owned {
116     using SafeMath for uint256;
117 
118     string public constant name    = "Free Fair Chain Token";  //The Token's name
119     uint8 public constant decimals = 18;               //Number of decimals of the smallest unit
120     string public constant symbol  = "FFC";            //An identifier    
121 
122     // packed to 256bit to save gas usage.
123     struct Supplies {
124         // uint128's max value is about 3e38.
125         // it's enough to present amount of tokens
126         uint128 total;
127     }
128 
129     Supplies supplies;
130 
131     // Packed to 256bit to save gas usage.    
132     struct Account {
133         // uint112's max value is about 5e33.
134         // it's enough to present amount of tokens
135         uint112 balance;
136         // safe to store timestamp
137         uint32 lastMintedTimestamp;
138     }
139 
140     // Balances for each account
141     mapping(address => Account) accounts;
142 
143     // Owner of account approves the transfer of an amount to another account
144     mapping(address => mapping(address => uint256)) allowed;
145 
146 
147 	// 
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149 	
150     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 
152     // Constructor
153     function FFC() public{
154     	supplies.total = 1 * (10 ** 9) * (10 ** 18);
155     }
156 
157     function totalSupply()public constant returns (uint256 supply){
158         return supplies.total;
159     }
160 
161     // Send back ether sent to me
162     function ()public {
163         revert();
164     }
165 
166     // If sealed, transfer is enabled 
167     function isSealed()public constant returns (bool) {
168         return owner == 0;
169     }
170     
171     function lastMintedTimestamp(address _owner)public constant returns(uint32) {
172         return accounts[_owner].lastMintedTimestamp;
173     }
174 
175     // What is the balance of a particular account?
176     function balanceOf(address _owner)public constant returns (uint256 balance) {
177         return accounts[_owner].balance;
178     }
179 
180     // Transfer the balance from owner's account to another account
181     function transfer(address _to, uint256 _amount)public returns (bool success) {
182         require(isSealed());
183 		
184         // according to FFC's total supply, never overflow here
185         if ( accounts[msg.sender].balance >= _amount && _amount > 0) {            
186             accounts[msg.sender].balance -= uint112(_amount);
187             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
188             emit Transfer(msg.sender, _to, _amount);
189             return true;
190         } else {
191             return false;
192         }
193     }
194 
195     // Send _value amount of tokens from address _from to address _to
196     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
197     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
198     // fees in sub-currencies; the command should fail unless the _from account has
199     // deliberately authorized the sender of the message via some mechanism; we propose
200     // these standardized APIs for approval:
201     function transferFrom(
202         address _from,
203         address _to,
204         uint256 _amount
205     )public returns (bool success) {
206         require(isSealed());
207 
208         // according to FFC's total supply, never overflow here
209         if (accounts[_from].balance >= _amount
210             && allowed[_from][msg.sender] >= _amount
211             && _amount > 0) {
212             accounts[_from].balance -= uint112(_amount);
213             allowed[_from][msg.sender] -= _amount;
214             accounts[_to].balance = _amount.add(accounts[_to].balance).toUINT112();
215             emit Transfer(_from, _to, _amount);
216             return true;
217         } else {
218             return false;
219         }
220     }
221 
222     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
223     // If this function is called again it overwrites the current allowance with _value.
224     function approve(address _spender, uint256 _amount)public returns (bool success) {
225         allowed[msg.sender][_spender] = _amount;
226         emit Approval(msg.sender, _spender, _amount);
227         return true;
228     }
229 
230     /* Approves and then calls the receiving contract */
231     function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
232         allowed[msg.sender][_spender] = _value;
233         emit Approval(msg.sender, _spender, _value);
234 
235         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
236         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
237         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
238         //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
239         ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
240         return true;
241     }
242 
243     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
244         return allowed[_owner][_spender];
245     }
246     
247     function mint0(address _owner, uint256 _amount)public onlyOwner {
248     		accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();
249 
250         accounts[_owner].lastMintedTimestamp = uint32(block.timestamp);
251 
252         //supplies.total = _amount.add(supplies.total).toUINT128();
253         emit Transfer(0, _owner, _amount);
254     }
255     
256     // Mint tokens and assign to some one
257     function mint(address _owner, uint256 _amount, uint32 timestamp)public onlyOwner{
258         accounts[_owner].balance = _amount.add(accounts[_owner].balance).toUINT112();
259 
260         accounts[_owner].lastMintedTimestamp = timestamp;
261 
262         supplies.total = _amount.add(supplies.total).toUINT128();
263         emit Transfer(0, _owner, _amount);
264     }
265 
266     // Set owner to zero address, to disable mint, and enable token transfer
267     function seal()public onlyOwner {
268         setOwner(0);
269     }
270 }
271 
272 contract ApprovalReceiver {
273     function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)public;
274 }