1 pragma solidity ^0.4.18;
2 /**
3 * @title Pitch TOKEN
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9 * @title SafeMath by OpenZeppelin
10 * @dev Math operations with safety checks that throw on error
11 */
12 library SafeMath {
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 /**
27 * Token contract interface for external use
28 */
29 contract ERC20TokenInterface {
30 
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
36 
37     }
38 
39 /**
40 * @title Admin parameters
41 * @dev Define administration parameters for this contract
42 */
43 contract admined { //This token contract is administered
44     address public admin; //Admin address is public
45     bool public lockTransfer; //Transfer Lock flag
46     address public allowedAddress; //an address that can override lock condition
47 
48     /**
49     * @dev Contract constructor
50     * define initial administrator
51     */
52     function admined() internal {
53         admin = msg.sender; //Set initial admin to contract creator
54         allowedAddress = msg.sender;
55         AllowedSet(allowedAddress);
56         Admined(admin);
57     }
58 
59     /**
60     * @dev Function to set an allowed address
61     * @param _to The address to give privileges.
62     */
63     function setAllowedAddress(address _to) onlyAdmin public {
64         allowedAddress = _to;
65         AllowedSet(_to);
66     }
67 
68     modifier onlyAdmin() { //A modifier to define admin-only functions
69         require(msg.sender == admin);
70         _;
71     }
72 
73     modifier transferLock() { //A modifier to lock transactions
74         require(lockTransfer == false || allowedAddress == msg.sender);
75         _;
76     }
77 
78     /**
79     * @dev Function to set new admin address
80     * @param _newAdmin The address to transfer administration to
81     */
82     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
83         require(_newAdmin != address(0x0));
84         admin = _newAdmin;
85         TransferAdminship(admin);
86     }
87 
88     /**
89     * @dev Function to set transfer lock
90     */
91     function setTransferLockFree() onlyAdmin public { //Only the admin can set unlock on transfers
92         require(lockTransfer == true);
93         lockTransfer = false;
94         SetTransferLock(lockTransfer);
95     }
96 
97     //All admin actions have a log for public review
98     event AllowedSet(address _to);
99     event SetTransferLock(bool _set);
100     event TransferAdminship(address newAdminister);
101     event Admined(address administer);
102 
103 }
104 
105 /**
106 * @title Token definition
107 * @dev Define token paramters including ERC20 ones
108 */
109 contract ERC20Token is ERC20TokenInterface, admined { //Standar definition of a ERC20Token
110     using SafeMath for uint256;
111     uint256 public totalSupply;
112     mapping (address => uint256) balances; //A mapping of all balances per address
113     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
114     
115     /**
116     * @dev Get the balance of an specified address.
117     * @param _owner The address to be query.
118     */
119     function balanceOf(address _owner) public constant returns (uint256 balance) {
120       return balances[_owner];
121     }
122 
123     /**
124     * @dev transfer token to a specified address
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
129         require(_to != address(0)); //If you dont want that people destroy token
130         require(balances[msg.sender] >= _value);
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev transfer token from an address to another specified address using allowance
139     * @param _from The address where token comes.
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
144         require(_to != address(0)); //If you dont want that people destroy token
145         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
146         balances[_to] = balances[_to].add(_value);
147         balances[_from] = balances[_from].sub(_value);
148         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149         Transfer(_from, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Assign allowance to an specified address to use the owner balance
155     * @param _spender The address to be allowed to spend.
156     * @param _value The amount to be allowed.
157     */
158     function approve(address _spender, uint256 _value) public returns (bool success) {
159         allowed[msg.sender][_spender] = _value;
160         Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     /**
165     * @dev Get the allowance of an specified address to use another address balance.
166     * @param _owner The address of the owner of the tokens.
167     * @param _spender The address of the allowed spender.
168     */
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174     * This is an especial Admin-only function to make massive tokens assignments
175     */
176     function batch(address[] data,uint256[] amount) onlyAdmin public { //It takes an arrays of addresses and amount
177         
178         require(data.length == amount.length);
179         uint256 length = data.length;
180         address target;
181         uint256 value;
182 
183         for (uint i=0; i<length; i++) { //It moves over the array
184             target = data[i]; //Take an address
185             value = amount[i]; //Amount
186             transfer(target,value);
187         }
188     }
189 
190     /**
191     * @dev Log Events
192     */
193     event Transfer(address indexed _from, address indexed _to, uint256 _value);
194     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
195 }
196 
197 /**
198 * @title Asset
199 * @dev Initial supply creation
200 */
201 contract Asset is ERC20Token {
202     string public name = 'Pitch';
203     uint8 public decimals = 18;
204     string public symbol = 'PCH';
205     string public version = '1';
206 
207     function Asset() public {
208         totalSupply = 1500000000 * (10**uint256(decimals)); //1.500.000.000 initial token creation
209         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 1500000 * (10**uint256(decimals)); //0.1% for contract writer
210         balances[msg.sender] = 1498500000 * (10**uint256(decimals)); //99.9% of the tokens to creator address
211         
212         //Initially locked tokens for transfers, only allowedAddres can transfer
213         //until global unlock
214         lockTransfer = true;
215         SetTransferLock(lockTransfer);
216         
217         Transfer(0, this, totalSupply);
218         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
219         Transfer(this, msg.sender, balances[msg.sender]);
220     }
221     
222     /**
223     *@dev Function to handle callback calls
224     */
225     function() public {
226         revert();
227     }
228 }