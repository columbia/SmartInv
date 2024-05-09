1 pragma solidity ^0.4.16;
2 /**
3 * @title UNR ERC20 TOKEN CONTRACT
4 * @dev ERC-20 Token Standar Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
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
24 
25 }
26 /**
27  * @title ERC20TokenInterface
28  * @dev Token contract interface for external use
29  */
30 contract ERC20TokenInterface {
31 
32     function balanceOf(address _owner) public constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38     }
39 
40 /**
41  * @title admined
42  * @notice This contract is administered
43  */
44 contract admined {
45     address public admin; //Admin address is public
46     
47     /**
48     * @dev This contructor takes the msg.sender as the first administer
49     */
50     function admined() internal {
51         admin = msg.sender; //Set initial admin to contract creator
52         Admined(admin);
53     }
54 
55     /**
56     * @dev This modifier limits function execution to the admin
57     */
58     modifier onlyAdmin() { //A modifier to define admin-only functions
59         require(msg.sender == admin);
60         _;
61     }
62 
63     /**
64     * @notice This function transfer the adminship of the contract to _newAdmin
65     * @param _newAdmin The new admin of the contract
66     */
67     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
68         admin = _newAdmin;
69         TransferAdminship(admin);
70     }
71 
72     /**
73     * @dev Log Events
74     */
75     event TransferAdminship(address newAdminister);
76     event Admined(address administer);
77 
78 }
79 
80 /**
81 * @title ERC20Token
82 * @notice Token definition contract
83 */
84 contract ERC20Token is ERC20TokenInterface, admined { //Standar definition of a ERC20Token
85     using SafeMath for uint256; //SafeMath is used for uint256 operations
86     mapping (address => uint256) balances; //A mapping of all balances per address
87     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
88     uint256 public totalSupply;
89 
90     /**
91     * @notice Get the balance of an _owner address.
92     * @param _owner The address to be query.
93     */
94     function balanceOf(address _owner) public constant returns (uint256 balance) {
95       return balances[_owner];
96     }
97 
98     /**
99     * @notice transfer _value tokens to address _to
100     * @param _to The address to transfer to.
101     * @param _value The amount to be transferred.
102     * @return success with boolean value true if done
103     */
104     function transfer(address _to, uint256 _value) public returns (bool success) {
105         require(_to != address(0)); //Dont want that any body destroy token
106         require(balances[msg.sender] >= _value);
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
115     * @param _from The address where tokens comes.
116     * @param _to The address to transfer to.
117     * @param _value The amount to be transferred.
118     * @return success with boolean value true if done
119     */
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121         require(_to != address(0)); //If you dont want that people destroy token
122         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
123         balances[_to] = balances[_to].add(_value);
124         balances[_from] = balances[_from].sub(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         Transfer(_from, _to, _value);
127         return true;
128     }
129 
130     /**
131     * @notice Assign allowance _value to _spender address to use the msg.sender balance
132     * @param _spender The address to be allowed to spend.
133     * @param _value The amount to be allowed.
134     * @return success with boolean value true
135     */
136     function approve(address _spender, uint256 _value) public returns (bool success) {
137       allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /**
143     * @notice Get the allowance of an specified address to use another address balance.
144     * @param _owner The address of the owner of the tokens.
145     * @param _spender The address of the allowed spender.
146     * @return remaining with the allowance value
147     */
148     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150     }
151 
152 
153     /**
154     * @notice Mint _mintedAmount tokens to _target address.
155     * @param _target The address of the receiver of the tokens.
156     * @param _mintedAmount amount to mint.
157     */
158     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin public {
159         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
160         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
161         Transfer(0, this, _mintedAmount);
162         Transfer(this, _target, _mintedAmount);
163     }
164 
165     /**
166     * @notice Burn _burnedAmount tokens form _target address.
167     * @param _target The address of the holder of the tokens.
168     * @param _burnedAmount amount to burn.
169     */
170     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin public {
171         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
172         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
173         Burned(_target, _burnedAmount);
174     }
175 
176     /**
177     * @dev Log Events
178     */
179     event Transfer(address indexed _from, address indexed _to, uint256 _value);
180     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
181     event Burned(address indexed _target, uint256 _value);
182 }
183 
184 /**
185 * @title AssetUNR
186 * @notice ERC20 token creation.
187 */
188 contract AssetUNR is ERC20Token {
189     string public constant name = 'UnitedARCoin';
190     uint256 public constant decimals = 8;
191     string public constant symbol = 'UNR';
192     string public constant version = '1';
193     
194     /**
195     * @notice token contructor.
196     * @param _teamAddress is the address of the developer team
197     */
198     function AssetUNR(address _teamAddress) public {
199         require(msg.sender != _teamAddress);
200         totalSupply = 100000000 * (10 ** decimals); //100 million tokens initial supply;
201         balances[msg.sender] = 88000000 * (10 ** decimals); //88 million supply is initially holded by contract creator for the ICO, marketing and bounty
202         balances[_teamAddress] = 11900000 * (10 ** decimals); //11.9 million supply is initially holded by developer team
203         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 100000 * (10 ** decimals); //0.1 million supply is initially holded by contract writer
204         
205         Transfer(0, this, totalSupply);
206         Transfer(this, msg.sender, balances[msg.sender]);
207         Transfer(this, _teamAddress, balances[_teamAddress]);
208         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
209     }
210     
211     /**
212     * @notice this contract will revert on direct non-function calls
213     * @dev Function to handle callback calls
214     */
215     function() public {
216         revert();
217     }
218 
219 }