1 pragma solidity ^0.4.16;
2 /*
3 Node TOKEN
4 
5 ERC-20 Token Standar Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Oyewole Samuel.
9 bitcert@gmail.com
10 */
11 
12 /**
13  * @title SafeMath by OpenZeppelin
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29 }
30 
31 /**
32  * This contract is administered
33  */
34 
35 contract admined {
36     address public admin; //Admin address is public
37     address public allowed;//Allowed addres is public
38 
39     bool public locked = true; //initially locked
40     /**
41     * @dev This constructor set the initial admin of the contract
42     */
43     function admined() internal {
44         admin = msg.sender; //Set initial admin to contract creator
45         Admined(admin);
46     }
47 
48     modifier onlyAdmin() { //A modifier to define admin-allowed functions
49         require(msg.sender == admin || msg.sender == allowed);
50         _;
51     }
52 
53     modifier lock() { //A modifier to lock specific supply functions
54         require(locked == false);
55         _;
56     }
57 
58 
59     function allowedAddress(address _allowed) onlyAdmin public {
60         allowed = _allowed;
61         Allowed(_allowed);
62     }
63     /**
64     * @dev Transfer the adminship of the contract
65     * @param _newAdmin The address of the new admin.
66     */
67     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
68         require(_newAdmin != address(0));
69         admin = _newAdmin;
70         TransferAdminship(admin);
71     }
72     /**
73     * @dev Enable or disable lock
74     * @param _locked Status.
75     */
76     function lockSupply(bool _locked) onlyAdmin public {
77         locked = _locked;
78         LockedSupply(locked);
79     }
80 
81     //All admin actions have a log for public review
82     event TransferAdminship(address newAdmin);
83     event Admined(address administrador);
84     event LockedSupply(bool status);
85     event Allowed(address allow);
86 }
87 
88 
89 /**
90  * Token contract interface for external use
91  */
92 contract ERC20TokenInterface {
93 
94     function balanceOf(address _owner) public constant returns (uint256 balance);
95     function transfer(address _to, uint256 _value) public returns (bool success);
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
97     function approve(address _spender, uint256 _value) public returns (bool success);
98 }
99 
100 
101 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
102     using SafeMath for uint256;
103     uint256 totalSupply_;
104     mapping (address => uint256) balances; //A mapping of all balances per address
105     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
106 
107     /**
108     * @dev Get the balance of an specified address.
109     * @param _owner The address to be query.
110     */
111     function balanceOf(address _owner) public constant returns (uint256 balance) {
112       return balances[_owner];
113     }
114 
115     /**
116     * @dev total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }    
121 
122     /**
123     * @dev transfer token to a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public returns (bool success) {
128         require(_to != address(0)); //If you dont want that people destroy token
129         require(balances[msg.sender] >= _value);
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137     * @dev transfer token from an address to another specified address using allowance
138     * @param _from The address where token comes.
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
143         require(_to != address(0)); //If you dont want that people destroy token
144         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
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
173     *Log Events
174     */
175     event Transfer(address indexed _from, address indexed _to, uint256 _value);
176     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
177 }
178 
179 contract RingCoin is admined, ERC20Token {
180     string public name = "RingCoin";
181     string public symbol = "RC";
182     string public version = "1.0";
183     uint8 public decimals = 18;
184 
185     function RingCoin() public {
186         totalSupply_ = 90800000 * (10**uint256(decimals));
187         balances[this] = totalSupply_;
188         allowed[this][msg.sender] = balances[this]; //Contract balance is allowed to creator
189         /**
190         *Log Events
191         */
192         Transfer(0, this, totalSupply_);
193         Approval(this, msg.sender, balances[this]);
194 
195     }
196     /**
197     *@dev Function to handle callback calls
198     */
199     function() public {
200         revert();
201     }
202 }