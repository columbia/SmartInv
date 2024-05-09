1 pragma solidity ^0.4.18;
2 /*
3 The Secure Egg
4 
5 ERC-20 Token Standard Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Oyewole Samuel bitcert@gmail.com
9 */
10 /**
11  * @title SafeMath by OpenZeppelin
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a * b;
18         assert(a == 0 || c / a == b);
19         return c;
20     }
21 
22     function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a / b;
24     return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32     
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }    
37 }
38 
39 /**
40  * This contract is administered
41  */
42 
43 contract admined {
44     address public admin; //Admin address is public
45     address public allowed;//Allowed addres is public
46 
47     bool public locked = true; //initially locked
48     /**
49     * @dev This constructor set the initial admin of the contract
50     */
51     function admined() internal {
52         admin = msg.sender; //Set initial admin to contract creator
53         Admined(admin);
54     }
55 
56     modifier onlyAdmin() { //A modifier to define admin-allowed functions
57         require(msg.sender == admin || msg.sender == allowed);
58         _;
59     }
60 
61     modifier lock() { //A modifier to lock specific supply functions
62         require(locked == false);
63         _;
64     }
65 
66 
67     function allowedAddress(address _allowed) onlyAdmin public {
68         allowed = _allowed;
69         Allowed(_allowed);
70     }
71     /**
72     * @dev Transfer the adminship of the contract
73     * @param _newAdmin The address of the new admin.
74     */
75     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
76         require(_newAdmin != address(0));
77         admin = _newAdmin;
78         TransferAdminship(admin);
79     }
80     /**
81     * @dev Enable or disable lock
82     * @param _locked Status.
83     */
84     function lockSupply(bool _locked) onlyAdmin public {
85         locked = _locked;
86         LockedSupply(locked);
87     }
88 
89     //All admin actions have a log for public review
90     event TransferAdminship(address newAdmin);
91     event Admined(address administrador);
92     event LockedSupply(bool status);
93     event Allowed(address allow);
94 }
95 
96 
97 /**
98  * Token contract interface for external use
99  */
100 contract ERC20TokenInterface {
101 
102     function balanceOf(address _owner) public constant returns (uint256 balance);
103     function transfer(address _to, uint256 _value) public returns (bool success);
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105     function approve(address _spender, uint256 _value) public returns (bool success);
106 }
107 
108 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
109     using SafeMath for uint256;
110     
111     uint256 totalSupply_;
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
124     * @dev total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }    
129 
130     /**
131     * @dev transfer token to a specified address
132     * @param _to The address to transfer to.
133     * @param _value The amount to be transferred.
134     */
135     function transfer(address _to, uint256 _value) public returns (bool success) {
136         require(_to != address(0)); //If you dont want that people destroy token
137         require(balances[msg.sender] >= _value);
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     /**
145     * @dev transfer token from an address to another specified address using allowance
146     * @param _from The address where token comes.
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
151         require(_to != address(0)); //If you dont want that people destroy token
152         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
153         balances[_to] = balances[_to].add(_value);
154         balances[_from] = balances[_from].sub(_value);
155         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156         Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Assign allowance to an specified address to use the owner balance
162     * @param _spender The address to be allowed to spend.
163     * @param _value The amount to be allowed.
164     */
165     function approve(address _spender, uint256 _value) public returns (bool success) {
166       allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172     * @dev Get the allowance of an specified address to use another address balance.
173     * @param _owner The address of the owner of the tokens.
174     * @param _spender The address of the allowed spender.
175     */
176     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177         return allowed[_owner][_spender];
178     }
179 
180     /**
181     *Log Events
182     */
183     event Transfer(address indexed _from, address indexed _to, uint256 _value);
184     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
185 }
186 
187 contract SecureEgg is admined, ERC20Token {
188     string public name = "Secure Egg";
189     string public symbol = "SEG";
190     string public version = "1.0";
191     uint8 public decimals = 18;
192     address public owner = 0xC365aa1d5C71A61c5b05Dc953a79a125D40ce472;
193 
194     function SecureEgg() public {
195         totalSupply_ = 1000000000000 * (10**uint256(decimals)); //100 Million total supply.
196         balances[this] = totalSupply_;
197         allowed[this][owner] = balances[this]; //Contract balance is allowed to creator
198         
199         _transferTokenToOwner();
200 
201         /**
202         *Log Events
203         */
204         Transfer(0, this, totalSupply_);
205         Approval(this, msg.sender, balances[this]);
206 
207     }
208     
209     function _transferTokenToOwner() internal {
210         balances[this] = balances[this].sub(totalSupply_);
211         balances[owner] = balances[owner].add(totalSupply_);
212         Transfer(this, owner, totalSupply_);
213     }
214     /**
215     *@dev Function to handle callback calls
216     */
217     function() public {
218         revert();
219     }
220 }