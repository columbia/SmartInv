1 pragma solidity ^0.4.18;
2 /*
3 The MedCann
4 
5 ERC-20 Token Standard Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Oyewole Samuel bitcert@gmail.com
9 
10 Token name is MedCann
11 Token symbol is Mcan
12 Total Token supply is 500 million tokens with associated digital format (1.00)
13 Token decimals can be standard
14 Order: FO1BB7AA0387
15 */
16 
17 /**
18  * @title SafeMath by OpenZeppelin
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 
34 }
35 
36 /**
37  * This contract is administered
38  */
39 
40 contract admined {
41     address public admin; //Admin address is public
42     address public allowed;//Allowed addres is public
43 
44     bool public locked = true; //initially locked
45     /**
46     * @dev This constructor set the initial admin of the contract
47     */
48     function admined() internal {
49         admin = msg.sender; //Set initial admin to contract creator
50         Admined(admin);
51     }
52 
53     modifier onlyAdmin() { //A modifier to define admin-allowed functions
54         require(msg.sender == admin || msg.sender == allowed);
55         _;
56     }
57 
58     modifier lock() { //A modifier to lock specific supply functions
59         require(locked == false);
60         _;
61     }
62 
63 
64     function allowedAddress(address _allowed) onlyAdmin public {
65         allowed = _allowed;
66         Allowed(_allowed);
67     }
68     /**
69     * @dev Transfer the adminship of the contract
70     * @param _newAdmin The address of the new admin.
71     */
72     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
73         require(_newAdmin != address(0));
74         admin = _newAdmin;
75         TransferAdminship(admin);
76     }
77     /**
78     * @dev Enable or disable lock
79     * @param _locked Status.
80     */
81     function lockSupply(bool _locked) onlyAdmin public {
82         locked = _locked;
83         LockedSupply(locked);
84     }
85 
86     //All admin actions have a log for public review
87     event TransferAdminship(address newAdmin);
88     event Admined(address administrador);
89     event LockedSupply(bool status);
90     event Allowed(address allow);
91 }
92 
93 
94 /**
95  * Token contract interface for external use
96  */
97 contract ERC20TokenInterface {
98 
99     function balanceOf(address _owner) public constant returns (uint256 balance);
100     function transfer(address _to, uint256 _value) public returns (bool success);
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
102     function approve(address _spender, uint256 _value) public returns (bool success);
103 }
104 
105 
106 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
107     using SafeMath for uint256;
108     uint256 totalSupply_;
109     mapping (address => uint256) balances; //A mapping of all balances per address
110     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
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
121     * @dev total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return totalSupply_;
125     }    
126 
127     /**
128     * @dev transfer token to a specified address
129     * @param _to The address to transfer to.
130     * @param _value The amount to be transferred.
131     */
132     function transfer(address _to, uint256 _value) public returns (bool success) {
133         require(_to != address(0)); //If you dont want that people destroy token
134         require(balances[msg.sender] >= _value);
135         balances[msg.sender] = balances[msg.sender].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         Transfer(msg.sender, _to, _value);
138         return true;
139     }
140 
141     /**
142     * @dev transfer token from an address to another specified address using allowance
143     * @param _from The address where token comes.
144     * @param _to The address to transfer to.
145     * @param _value The amount to be transferred.
146     */
147     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
148         require(_to != address(0)); //If you dont want that people destroy token
149         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
150         balances[_to] = balances[_to].add(_value);
151         balances[_from] = balances[_from].sub(_value);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153         Transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /**
158     * @dev Assign allowance to an specified address to use the owner balance
159     * @param _spender The address to be allowed to spend.
160     * @param _value The amount to be allowed.
161     */
162     function approve(address _spender, uint256 _value) public returns (bool success) {
163       allowed[msg.sender][_spender] = _value;
164         Approval(msg.sender, _spender, _value);
165         return true;
166     }
167 
168     /**
169     * @dev Get the allowance of an specified address to use another address balance.
170     * @param _owner The address of the owner of the tokens.
171     * @param _spender The address of the allowed spender.
172     */
173     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
174     return allowed[_owner][_spender];
175     }
176 
177     /**
178     *Log Events
179     */
180     event Transfer(address indexed _from, address indexed _to, uint256 _value);
181     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
182 }
183 
184 contract MedCann is admined, ERC20Token {
185     string public name = "MedCann";
186     string public symbol = "MCAN";
187     string public version = "1.0";
188     uint8 public decimals = 18;
189 
190     function MedCann() public {
191         totalSupply_ = 500000000 * (10**uint256(decimals));
192         balances[0xA852f72B6C074B99A9d3BA5661B6426398A35891] = totalSupply_;
193 
194         /**
195         *Log Events
196         */
197         Transfer(0, this, totalSupply_);
198         Approval(this, 0xA852f72B6C074B99A9d3BA5661B6426398A35891, balances[this]);
199 
200     }
201     /**
202     *@dev Function to handle callback calls
203     */
204     function() public {
205         revert();
206     }
207 }