1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath by OpenZeppelin
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
10         assert(b <= a);
11         return a - b;
12     }
13 
14     function add(uint256 a, uint256 b) internal constant returns (uint256) {
15         uint256 c = a + b;
16         assert(c >= a);
17         return c;
18     }
19 
20 }
21 /**
22  * @title ERC20TokenInterface
23  * @dev Token contract interface for external use
24  */
25 contract ERC20TokenInterface {
26 
27     function balanceOf(address _owner) public constant returns (uint256 balance);
28     function transfer(address _to, uint256 _value) public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30     function approve(address _spender, uint256 _value) public returns (bool success);
31     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
32 
33     }
34 
35 
36 /**
37  * @title admined
38  * @notice This contract is administered
39  */
40 contract admined {
41     address public admin; //Admin address is public
42     
43     /**
44     * @dev This contructor takes the msg.sender as the first administer
45     */
46     function admined() internal {
47         admin = msg.sender; //Set initial admin to contract creator
48         Admined(admin);
49     }
50 
51     /**
52     * @dev This modifier limits function execution to the admin
53     */
54     modifier onlyAdmin() { //A modifier to define admin-only functions
55         require(msg.sender == admin);
56         _;
57     }
58 
59     /**
60     * @notice This function transfer the adminship of the contract to _newAdmin
61     * @param _newAdmin The new admin of the contract
62     */
63     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
64         admin = _newAdmin;
65         TransferAdminship(admin);
66     }
67 
68     /**
69     * @dev Log Events
70     */
71     event TransferAdminship(address newAdminister);
72     event Admined(address administer);
73 
74 }
75 
76 /**
77 * @title ERC20Token
78 * @notice Token definition contract
79 */
80 contract ERC20Token is ERC20TokenInterface,admined { //Standar definition of a ERC20Token
81     using SafeMath for uint256; //SafeMath is used for uint256 operations
82     mapping (address => uint256) balances; //A mapping of all balances per address
83     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
84     uint256 public totalSupply;
85 
86     /**
87     * @notice Get the balance of an _owner address.
88     * @param _owner The address to be query.
89     */
90     function balanceOf(address _owner) public constant returns (uint256 balance) {
91       return balances[_owner];
92     }
93 
94     /**
95     * @notice transfer _value tokens to address _to
96     * @param _to The address to transfer to.
97     * @param _value The amount to be transferred.
98     * @return success with boolean value true if done
99     */
100     function transfer(address _to, uint256 _value) public returns (bool success) {
101         require(_to != address(0)); //Dont want that any body destroy token
102         require(balances[msg.sender] >= _value);
103         balances[msg.sender] = balances[msg.sender].sub(_value);
104         balances[_to] = balances[_to].add(_value);
105         Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     /**
110     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
111     * @param _from The address where tokens comes.
112     * @param _to The address to transfer to.
113     * @param _value The amount to be transferred.
114     * @return success with boolean value true if done
115     */
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_to != address(0)); //If you dont want that people destroy token
118         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
119         balances[_to] = balances[_to].add(_value);
120         balances[_from] = balances[_from].sub(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127     * @notice Assign allowance _value to _spender address to use the msg.sender balance
128     * @param _spender The address to be allowed to spend.
129     * @param _value The amount to be allowed.
130     * @return success with boolean value true
131     */
132     function approve(address _spender, uint256 _value) public returns (bool success) {
133       allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     /**
139     * @notice Get the allowance of an specified address to use another address balance.
140     * @param _owner The address of the owner of the tokens.
141     * @param _spender The address of the allowed spender.
142     * @return remaining with the allowance value
143     */
144     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146     }
147 
148     /**
149     * @notice Mint _mintedAmount tokens to _target address.
150     * @param _target The address of the receiver of the tokens.
151     * @param _mintedAmount amount to mint.
152     */
153     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin public {
154         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
155         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
156         Transfer(0, this, _mintedAmount);
157         Transfer(this, _target, _mintedAmount);
158     }
159 
160     /**
161     * @notice Burn _burnedAmount tokens form _target address.
162     * @param _target The address of the holder of the tokens.
163     * @param _burnedAmount amount to burn.
164     */
165     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin public {
166         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
167         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
168         Burned(_target, _burnedAmount);
169     }
170 
171     /**
172     * @dev Log Events
173     */
174     event Transfer(address indexed _from, address indexed _to, uint256 _value);
175     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
176     event Burned(address indexed _target, uint256 _value);
177 }
178 
179 /**
180 * @title RFL_Token
181 * @notice ERC20 token creation.
182 */
183 contract RFL_Token is ERC20Token {
184     string public name;
185     uint256 public decimals = 18;
186     string public symbol;
187     string public version = '1';
188     
189     /**
190     * @notice token contructor.
191     * @param _name is the name of the token
192     * @param _symbol is the symbol of the token
193     * @param _teamAddress is the address of the developer team
194     */
195     function RFL_Token(string _name, string _symbol, address _teamAddress) public {
196         name = _name;
197         symbol = _symbol;
198         totalSupply = 100000000 * (10 ** decimals); //100 million tokens initial supply;
199         balances[this] = 80000000 * (10 ** decimals); //80 million supply is initially holded on contract
200         balances[_teamAddress] = 19000000 * (10 ** decimals); //19 million supply is initially holded by developer team
201         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 1000000 * (10 ** decimals); //1 million supply is initially holded for bounty
202         allowed[this][msg.sender] = balances[this]; //the sender has allowance on total balance on contract
203         Transfer(0, this, balances[this]);
204         Transfer(this, _teamAddress, balances[_teamAddress]);
205         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
206         Approval(this, msg.sender, balances[this]);
207     }
208     
209     /**
210     * @notice this contract will revert on direct non-function calls
211     * @dev Function to handle callback calls
212     */
213     function() public {
214         revert();
215     }
216 
217 }