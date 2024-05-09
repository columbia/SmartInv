1 pragma solidity 0.4.19;
2 /**
3 * @title TOKEN Contract
4 * @dev ERC-20 Token Standard Compliant
5 * @notice Website: Ze.cash
6 * @author Fares A. Akel C. f.antonio.akel@gmail.com
7 */
8 
9 /**
10 * @title SafeMath by OpenZeppelin
11 * @dev Math operations with safety checks that throw on error
12 */
13 library SafeMath {
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26 }
27 
28 /**
29 * Token contract interface for external use
30 */
31 contract ERC20TokenInterface {
32 
33     function balanceOf(address _owner) public constant returns (uint256 value);
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
38 
39     }
40 
41 
42 /**
43 * @title Admin parameters
44 * @dev Define administration parameters for this contract
45 */
46 contract admined { //This token contract is administered
47     address public admin; //Admin address is public
48     bool public lockSupply; //Supply Lock flag
49 
50     /**
51     * @dev Contract constructor
52     * define initial administrator
53     */
54     function admined() internal {
55         admin = msg.sender; //Set initial admin to contract creator
56         Admined(admin);
57     }
58 
59     modifier onlyAdmin() { //A modifier to define admin-only functions
60         require(msg.sender == admin);
61         _;
62     }
63 
64     modifier supplyLock() { //A modifier to lock mint and burn transactions
65         require(lockSupply == false);
66         _;
67     }
68 
69     /**
70     * @dev Function to set new admin address
71     * @param _newAdmin The address to transfer administration to
72     */
73     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
74         require(_newAdmin != address(0));
75         admin = _newAdmin;
76         TransferAdminship(admin);
77     }
78 
79     /**
80     * @dev Function to set mint and burn locks
81     * @param _set boolean flag (true | false)
82     */
83     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
84         lockSupply = _set;
85         SetSupplyLock(_set);
86     }
87 
88     //All admin actions have a log for public review
89     event SetSupplyLock(bool _set);
90     event TransferAdminship(address newAdminister);
91     event Admined(address administer);
92 
93 }
94 
95 /**
96 * @title Token definition
97 * @dev Define token paramters including ERC20 ones
98 */
99 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
100     using SafeMath for uint256;
101     uint256 public totalSupply;
102     mapping (address => uint256) balances; //A mapping of all balances per address
103     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
104 
105     /**
106     * @dev Get the balance of an specified address.
107     * @param _owner The address to be query.
108     */
109     function balanceOf(address _owner) public constant returns (uint256 value) {
110         return balances[_owner];
111     }
112 
113     /**
114     * @dev transfer token to a specified address
115     * @param _to The address to transfer to.
116     * @param _value The amount to be transferred.
117     */
118     function transfer(address _to, uint256 _value) public returns (bool success) {
119         require(_to != address(0)); //If you dont want that people destroy token
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @dev transfer token from an address to another specified address using allowance
128     * @param _from The address where token comes.
129     * @param _to The address to transfer to.
130     * @param _value The amount to be transferred.
131     */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_to != address(0)); //If you dont want that people destroy token
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135         balances[_from] = balances[_from].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142     * @dev Assign allowance to an specified address to use the owner balance
143     * @param _spender The address to be allowed to spend.
144     * @param _value The amount to be allowed.
145     */
146     function approve(address _spender, uint256 _value) public returns (bool success) {
147         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Get the allowance of an specified address to use another address balance.
155     * @param _owner The address of the owner of the tokens.
156     * @param _spender The address of the allowed spender.
157     */
158     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
159         return allowed[_owner][_spender];
160     }
161 
162     /**
163     * @dev Burn token of an specified address.
164     * @param _burnedAmount amount to burn.
165     */
166     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
167         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
168         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
169         Burned(msg.sender, _burnedAmount);
170     }
171 
172     /**
173     * @dev Log Events
174     */
175     event Transfer(address indexed _from, address indexed _to, uint256 _value);
176     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
177     event Burned(address indexed _target, uint256 _value);
178 }
179 
180 /**
181 * @title Asset
182 * @dev Initial supply creation
183 */
184 contract Asset is ERC20Token {
185     string public name = 'ZECASH';
186     uint8 public decimals = 18;
187     string public symbol = 'ZCH';
188     string public version = '1';
189 
190     function Asset() public {
191         totalSupply = 500000000 * (10**uint256(decimals)); //initial token creation
192         balances[msg.sender] = totalSupply;
193 
194         Transfer(0, this, totalSupply);
195         Transfer(this, msg.sender, balances[msg.sender]);
196     }
197     
198     /**
199     * @dev Function to handle callback calls
200     */
201     function() public {
202         revert();
203     }
204 
205 }