1 pragma solidity ^0.4.18;
2 /**
3 * @title OMEGON TOKEN
4 * @dev ERC-20 Token Standar Compliant
5 */
6 
7 /**
8 * @title SafeMath by OpenZeppelin
9 * @dev Math operations with safety checks that throw on error
10 */
11 library SafeMath {
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 }
24 
25 /**
26 * Token contract interface for external use
27 */
28 contract ERC20TokenInterface {
29 
30     function balanceOf(address _owner) public constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) public returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33     function approve(address _spender, uint256 _value) public returns (bool success);
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35 
36     }
37 
38 /**
39 * @title Admin parameters
40 * @dev Define administration parameters for this contract
41 */
42 contract admined { //This token contract is administered
43     address public admin; //Admin address is public
44     bool public lockTransfer; //Transfer Lock flag
45     address public allowedAddress; //an address that can override lock condition
46 
47     /**
48     * @dev Contract constructor
49     * define initial administrator
50     */
51     function admined() internal {
52         admin = msg.sender; //Set initial admin to contract creator
53         Admined(admin);
54     }
55 
56     /**
57     * @dev Function to set an allowed address
58     * @param _to The address to give privileges.
59     */
60     function setAllowedAddress(address _to) public {
61         allowedAddress = _to;
62         AllowedSet(_to);
63     }
64 
65     modifier onlyAdmin() { //A modifier to define admin-only functions
66         require(msg.sender == admin);
67         _;
68     }
69 
70     modifier transferLock() { //A modifier to lock transactions
71         require(lockTransfer == false || allowedAddress == msg.sender);
72         _;
73     }
74 
75     /**
76     * @dev Function to set new admin address
77     * @param _newAdmin The address to transfer administration to
78     */
79     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
80         admin = _newAdmin;
81         TransferAdminship(admin);
82     }
83 
84     /**
85     * @dev Function to set transfer lock
86     * @param _set boolean flag (true | false)
87     */
88     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
89         lockTransfer = _set;
90         SetTransferLock(_set);
91     }
92 
93     //All admin actions have a log for public review
94     event AllowedSet(address _to);
95     event SetTransferLock(bool _set);
96     event TransferAdminship(address newAdminister);
97     event Admined(address administer);
98 
99 }
100 
101 /**
102 * @title Token definition
103 * @dev Define token paramters including ERC20 ones
104 */
105 contract ERC20Token is ERC20TokenInterface, admined { //Standar definition of a ERC20Token
106     using SafeMath for uint256;
107     uint256 public totalSupply;
108     mapping (address => uint256) balances; //A mapping of all balances per address
109     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
110     mapping (address => bool) public frozen; //A mapping of frozen accounts
111 
112     /**
113     * @dev Get the balance of an specified address.
114     * @param _owner The address to be query.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 balance) {
117       return balances[_owner];
118     }
119 
120     /**
121     * @dev transfer token to a specified address
122     * @param _to The address to transfer to.
123     * @param _value The amount to be transferred.
124     */
125     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
126         require(_to != address(0)); //If you dont want that people destroy token
127         require(balances[msg.sender] >= _value);
128         require(frozen[msg.sender]==false);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         Transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     /**
136     * @dev transfer token from an address to another specified address using allowance
137     * @param _from The address where token comes.
138     * @param _to The address to transfer to.
139     * @param _value The amount to be transferred.
140     */
141     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
142         require(_to != address(0)); //If you dont want that people destroy token
143         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
144         require(frozen[_from]==false);
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Assign allowance to an specified address to use the owner balance
154     * @param _spender The address to be allowed to spend.
155     * @param _value The amount to be allowed.
156     */
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158       allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Get the allowance of an specified address to use another address balance.
165     * @param _owner The address of the owner of the tokens.
166     * @param _spender The address of the allowed spender.
167     */
168     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
169     return allowed[_owner][_spender];
170     }
171 
172     /**
173     * @dev Frozen account.
174     * @param _target The address to being frozen.
175     * @param _flag The status of the frozen
176     */
177     function setFrozen(address _target,bool _flag) onlyAdmin public {
178         frozen[_target]=_flag;
179         FrozenStatus(_target,_flag);
180     }
181 
182 
183     /**
184     * @dev Log Events
185     */
186     event Transfer(address indexed _from, address indexed _to, uint256 _value);
187     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
188     event FrozenStatus(address _target,bool _flag);
189 }
190 
191 /**
192 * @title Asset
193 * @dev Initial supply creation
194 */
195 contract Asset is ERC20Token {
196     string public name = 'OMEGON';
197     uint8 public decimals = 18;
198     string public symbol = 'OMGN';
199     string public version = '1';
200 
201     function Asset() public {
202         totalSupply = 2000000000 * (10**uint256(decimals)); //2.000.000.000 initial token creation
203         balances[0x72046e44d7a3A92bE433E7bFD08cDb49B0A39e43] = 1000000000 * (10**uint256(decimals)); //1.000.000.000 To Dev Address
204         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 4000000 * (10**uint256(decimals)); //0.2% for contract writer
205         balances[msg.sender] = 996000000 * (10**uint256(decimals)); //Tokens for sale
206         
207         Transfer(0, this, totalSupply);
208         Transfer(this, 0x1789bD78712815e7Fc955DbbA6803303f4Ef15AC, balances[0x1789bD78712815e7Fc955DbbA6803303f4Ef15AC]);
209         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
210         Transfer(this, msg.sender, balances[msg.sender]);
211     }
212     
213     /**
214     *@dev Function to handle callback calls
215     */
216     function() public {
217         revert();
218     }
219 
220 }