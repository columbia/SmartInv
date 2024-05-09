1 pragma solidity ^0.4.11;
2 /*
3 MOIRA TOKEN
4 
5 ERC-20 Token Standar Compliant
6 EIP-621 Compliant
7 
8 Contract developer: Fares A. Akel C.
9 f.antonio.akel@gmail.com
10 MIT PGP KEY ID: 078E41CB
11 */
12 
13 /**
14  * @title SafeMath by OpenZeppelin
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal constant returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 
30 }
31 
32 /**
33  * This contract is administered
34  */
35 
36 contract admined {
37     address public admin; //Admin address is public
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
48     modifier onlyAdmin() { //A modifier to define admin-only functions
49         require(msg.sender == admin);
50         _;
51     }
52 
53     modifier lock() { //A modifier to lock specific supply functions
54         require(locked == false);
55         _;
56     }
57     /**
58     * @dev Transfer the adminship of the contract
59     * @param _newAdmin The address of the new admin.
60     */
61     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
62         require(_newAdmin != address(0));
63         admin = _newAdmin;
64         TransferAdminship(admin);
65     }
66     /**
67     * @dev Enable or disable lock
68     * @param _locked Status.
69     */
70     function lockSupply(bool _locked) onlyAdmin public {
71         locked = _locked;
72         LockedSupply(locked);
73     }
74 
75     //All admin actions have a log for public review
76     event TransferAdminship(address newAdmin);
77     event Admined(address administrador);
78     event LockedSupply(bool status);
79 }
80 
81 
82 /**
83  * Token contract interface for external use
84  */
85 contract ERC20TokenInterface {
86 
87     function balanceOf(address _owner) public constant returns (uint256 balance);
88     function transfer(address _to, uint256 _value) public returns (bool success);
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
90     function approve(address _spender, uint256 _value) public returns (bool success);
91     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
92     }
93 
94 
95 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
96     using SafeMath for uint256;
97     uint256 totalSupply;
98     mapping (address => uint256) balances; //A mapping of all balances per address
99     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
100 
101     /**
102     * @dev Get the balance of an specified address.
103     * @param _owner The address to be query.
104     */
105     function balanceOf(address _owner) public constant returns (uint256 balance) {
106       return balances[_owner];
107     }
108 
109     /**
110     * @dev transfer token to a specified address
111     * @param _to The address to transfer to.
112     * @param _value The amount to be transferred.
113     */
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115         require(_to != address(0)); //If you dont want that people destroy token
116         require(balances[msg.sender] >= _value);
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         Transfer(msg.sender, _to, _value);
120         return true;
121     }
122     /**
123     * @dev transfer token from an address to another specified address using allowance
124     * @param _from The address where token comes.
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_to != address(0)); //If you dont want that people destroy token
130         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
131         balances[_to] = balances[_to].add(_value);
132         balances[_from] = balances[_from].sub(_value);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         Transfer(_from, _to, _value);
135         return true;
136     }
137     /**
138     * @dev Assign allowance to an specified address to use the owner balance
139     * @param _spender The address to be allowed to spend.
140     * @param _value The amount to be allowed.
141     */
142     function approve(address _spender, uint256 _value) public returns (bool success) {
143       allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         return true;
146     }
147     /**
148     * @dev Get the allowance of an specified address to use another address balance.
149     * @param _owner The address of the owner of the tokens.
150     * @param _spender The address of the allowed spender.
151     */
152     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154     }
155     /**
156     * @dev Increase the tokens of an specified address increasing totalSupply.
157     * @param _amount The amount to increase.
158     * @param _to The address of the owner of the tokens.
159     */
160     function increaseSupply(uint256 _amount, address _to) public onlyAdmin lock returns (bool success) {
161       totalSupply = totalSupply.add(_amount);
162       balances[_to] = balances[_to].add(_amount);
163       Transfer(0, _to, _amount);
164       return true;
165     }
166     /**
167     * @dev Decrease the tokens of an specified address decreasing totalSupply.
168     * @param _amount The amount to decrease.
169     * @param _from The address of the owner of the tokens.
170     */
171     function decreaseSupply(uint _amount, address _from) public onlyAdmin lock returns (bool success) {
172       balances[_from] = balances[_from].sub(_amount);
173       totalSupply = totalSupply.sub(_amount);  
174       Transfer(_from, 0, _amount);
175       return true;
176     }
177 
178     /**
179     *Log Events
180     */
181     event Transfer(address indexed _from, address indexed _to, uint256 _value);
182     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
183 }
184 
185 contract AssetMoira is admined, ERC20Token {
186     string public name = 'Moira';
187     uint8 public decimals = 18;
188     string public symbol = 'Moi';
189     string public version = '1';
190 
191     function AssetMoira(address _team) public {
192         totalSupply = 666000000 * (10**uint256(decimals));
193         balances[this] = 600000000 * (10**uint256(decimals));
194         balances[_team] = 66000000 * (10**uint256(decimals));
195         allowed[this][msg.sender] = balances[this];
196         /**
197         *Log Events
198         */
199         Transfer(0, this, balances[this]);
200         Transfer(0, _team, balances[_team]);
201         Approval(this, msg.sender, balances[_team]);
202 
203     }
204     /**
205     *@dev Function to handle callback calls
206     */
207     function() public {
208         revert();
209     }
210 }