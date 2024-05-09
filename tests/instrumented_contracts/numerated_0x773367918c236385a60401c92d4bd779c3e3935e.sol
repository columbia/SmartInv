1 pragma solidity ^0.4.18;
2 /*
3 The Cowboy coin
4 
5 ERC-20 Token Standard Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Oyewole Samuel bitcert@gmail.com
9 
10 Token name is Cowboy coin
11 Token symbol is CWBY
12 Total Token supply is 100 million tokens with associated digital format (1.00)
13 Token decimals can be standard
14 Order: FO71192BC2945
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
50         emit Admined(admin);
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
66         emit Allowed(_allowed);
67     }
68     /**
69     * @dev Transfer the adminship of the contract
70     * @param _newAdmin The address of the new admin.
71     */
72     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
73         require(_newAdmin != address(0));
74         admin = _newAdmin;
75         emit TransferAdminship(admin);
76     }
77     /**
78     * @dev Enable or disable lock
79     * @param _locked Status.
80     */
81     function lockSupply(bool _locked) onlyAdmin public {
82         locked = _locked;
83         emit LockedSupply(locked);
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
107     
108     using SafeMath for uint256;
109     
110     uint256 totalSupply_;
111     
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
140         emit Transfer(msg.sender, _to, _value);
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
156         emit Transfer(_from, _to, _value);
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
167         emit Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172     * @dev Get the allowance of an specified address to use another address balance.
173     * @param _owner The address of the owner of the tokens.
174     * @param _spender The address of the allowed spender.
175     */
176     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178     }
179 
180     /**
181     *Log Events
182     */
183     event Transfer(address indexed _from, address indexed _to, uint256 _value);
184     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
185 }
186 
187 contract Cowboy is admined, ERC20Token {
188     
189     string public name = "Cowboy Coin";
190     string public symbol = "CWBY";
191     string public version = "1.0";
192     uint8 public decimals = 18;
193     
194     //address of the beneficiary
195     address public beneficiary = 0x9bF52817A5103A9095706FB0b9a027fCEA0e18Cf;
196 
197     function Cowboy() public {
198         totalSupply_ = 100000000 * (10**uint256(decimals));
199         balances[this] = totalSupply_;
200         //Allow owner contract
201         allowed[this][beneficiary] = balances[this]; //Contract balance is allowed to creator
202         
203         _transferTokenToOwner();
204 
205         /**
206         *Log Events
207         */
208         emit Transfer(0, this, totalSupply_);
209         emit Approval(this, beneficiary, balances[this]);
210 
211     }
212     
213     function _transferTokenToOwner() internal {
214         balances[this] = balances[this].sub(totalSupply_);
215         balances[beneficiary] = balances[beneficiary].add(totalSupply_);
216         emit Transfer(this, beneficiary, totalSupply_);
217     }    
218     
219     function giveReward(address _from, address _buyer, uint256 _value) public returns (bool success) {
220         require(_buyer != address(0));
221         require(balances[_from] >= _value);
222 
223         balances[_buyer] = balances[_buyer].add(_value);
224         balances[_from] = balances[_from].sub(_value);
225         emit Transfer(_from, _buyer, _value);
226         return true;
227     }
228     
229     /**
230     *@dev Function to handle callback calls
231     */
232     function() public {
233         revert();
234     }
235 }