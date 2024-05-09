1 pragma solidity ^0.4.18;
2 /*
3 The Regen Coin
4 
5 ERC-20 Token Standard Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Oyewole Samuel bitcert@gmail.com
9 */
10 
11 /**
12  * @title SafeMath by OpenZeppelin
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a * b;
19         assert(a == 0 || c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33     
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }    
38 }
39 
40 /**
41  * This contract is administered
42  */
43 
44 contract admined {
45     address public admin; //Admin address is public
46     address public allowed;//Allowed addres is public
47 
48     bool public locked = true; //initially locked
49     /**
50     * @dev This constructor set the initial admin of the contract
51     */
52     function admined() internal {
53         admin = msg.sender; //Set initial admin to contract creator
54         Admined(admin);
55     }
56 
57     modifier onlyAdmin() { //A modifier to define admin-allowed functions
58         require(msg.sender == admin || msg.sender == allowed);
59         _;
60     }
61 
62     modifier lock() { //A modifier to lock specific supply functions
63         require(locked == false);
64         _;
65     }
66 
67 
68     function allowedAddress(address _allowed) onlyAdmin public {
69         allowed = _allowed;
70         Allowed(_allowed);
71     }
72     /**
73     * @dev Transfer the adminship of the contract
74     * @param _newAdmin The address of the new admin.
75     */
76     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
77         require(_newAdmin != address(0));
78         admin = _newAdmin;
79         TransferAdminship(admin);
80     }
81     /**
82     * @dev Enable or disable lock
83     * @param _locked Status.
84     */
85     function lockSupply(bool _locked) onlyAdmin public {
86         locked = _locked;
87         LockedSupply(locked);
88     }
89 
90     //All admin actions have a log for public review
91     event TransferAdminship(address newAdmin);
92     event Admined(address administrador);
93     event LockedSupply(bool status);
94     event Allowed(address allow);
95 }
96 
97 
98 /**
99  * Token contract interface for external use
100  */
101 contract ERC20TokenInterface {
102 
103     function balanceOf(address _owner) public constant returns (uint256 balance);
104     function transfer(address _to, uint256 _value) public returns (bool success);
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
106     function approve(address _spender, uint256 _value) public returns (bool success);
107 }
108 
109 
110 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
111     using SafeMath for uint256;
112     uint256 totalSupply_;
113     mapping (address => uint256) balances; //A mapping of all balances per address
114     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
115 
116     /**
117     * @dev Get the balance of an specified address.
118     * @param _owner The address to be query.
119     */
120     function balanceOf(address _owner) public constant returns (uint256 balance) {
121       return balances[_owner];
122     }
123 
124     /**
125     * @dev total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }    
130 
131     /**
132     * @dev transfer token to a specified address
133     * @param _to The address to transfer to.
134     * @param _value The amount to be transferred.
135     */
136     function transfer(address _to, uint256 _value) public returns (bool success) {
137         require(_to != address(0)); //If you dont want that people destroy token
138         require(balances[msg.sender] >= _value);
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     /**
146     * @dev transfer token from an address to another specified address using allowance
147     * @param _from The address where token comes.
148     * @param _to The address to transfer to.
149     * @param _value The amount to be transferred.
150     */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         require(_to != address(0)); //If you dont want that people destroy token
153         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
154         balances[_to] = balances[_to].add(_value);
155         balances[_from] = balances[_from].sub(_value);
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157         Transfer(_from, _to, _value);
158         return true;
159     }
160 
161     /**
162     * @dev Assign allowance to an specified address to use the owner balance
163     * @param _spender The address to be allowed to spend.
164     * @param _value The amount to be allowed.
165     */
166     function approve(address _spender, uint256 _value) public returns (bool success) {
167       allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Get the allowance of an specified address to use another address balance.
174     * @param _owner The address of the owner of the tokens.
175     * @param _spender The address of the allowed spender.
176     */
177     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182     *Log Events
183     */
184     event Transfer(address indexed _from, address indexed _to, uint256 _value);
185     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
186 }
187 
188 contract DropdCoin is admined, ERC20Token {
189     string public name = "Dropd Coin";
190     string public symbol = "DPD";
191     string public version = "1.0";
192     uint8 public decimals = 18;
193 
194     function DropdCoin() public {
195         totalSupply_ = 500000000 * (10**uint256(decimals));
196         balances[0x3C94676FD9D27195895A8D1F4e20719C2cA01069] = totalSupply_; //move all tokens to owners contract
197         //balances[this] = totalSupply_;
198         
199         /**
200         *Log Events
201         */
202         Transfer(0, this, totalSupply_);
203         Approval(this, msg.sender, balances[this]);
204 
205     }
206     /**
207     *@dev Function to handle callback calls
208     */
209     function() public {
210         revert();
211     }
212 }