1 pragma solidity 0.4.20;
2 /**
3 * TOKEN Contract
4 * ERC-20 Token Standard Compliant
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
26 
27 /**
28  * Token contract interface for external use
29  */
30 contract ERC20TokenInterface {
31 
32     function balanceOf(address _owner) public constant returns (uint256 value);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38     }
39 
40 
41 /**
42 * @title Admin parameters
43 * @dev Define administration parameters for this contract
44 */
45 contract admined { //This token contract is administered
46     address public admin; //Admin address is public
47     bool public lockSupply; //Mint and Burn Lock flag
48 
49     /**
50     * @dev Contract constructor
51     * define initial administrator
52     */
53     function admined() internal {
54         admin = msg.sender; //Set initial admin to contract creator
55         Admined(admin);
56     }
57 
58     modifier onlyAdmin() { //A modifier to define admin-only functions
59         require(msg.sender == admin);
60         _;
61     }
62 
63     modifier supplyLock() { //A modifier to lock mint and burn transactions
64         require(lockSupply == false);
65         _;
66     }
67 
68    /**
69     * @dev Function to set new admin address
70     * @param _newAdmin The address to transfer administration to
71     */
72     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
73         require(_newAdmin != 0);
74         admin = _newAdmin;
75         TransferAdminship(admin);
76     }
77 
78    /**
79     * @dev Function to set mint and burn locks
80     * @param _set boolean flag (true | false)
81     */
82     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
83         lockSupply = _set;
84         SetSupplyLock(_set);
85     }
86 
87     //All admin actions have a log for public review
88     event SetSupplyLock(bool _set);
89     event TransferAdminship(address newAdminister);
90     event Admined(address administer);
91 
92 }
93 
94 /**
95 * @title Token definition
96 * @dev Define token paramters including ERC20 ones
97 */
98 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
99     using SafeMath for uint256;
100     uint256 public totalSupply;
101     mapping (address => uint256) balances; //A mapping of all balances per address
102     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
103 
104     /**
105     * @dev Get the balance of an specified address.
106     * @param _owner The address to be query.
107     */
108     function balanceOf(address _owner) public constant returns (uint256 value) {
109       return balances[_owner];
110     }
111 
112     /**
113     * @dev transfer token to a specified address
114     * @param _to The address to transfer to.
115     * @param _value The amount to be transferred.
116     */
117     function transfer(address _to, uint256 _value) public returns (bool success) {
118         require(_to != address(0)); //If you dont want that people destroy token
119         balances[msg.sender] = balances[msg.sender].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         Transfer(msg.sender, _to, _value);
122         return true;
123     }
124 
125     /**
126     * @dev transfer token from an address to another specified address using allowance
127     * @param _from The address where token comes.
128     * @param _to The address to transfer to.
129     * @param _value The amount to be transferred.
130     */
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_to != address(0)); //If you dont want that people destroy token
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141     * @dev Assign allowance to an specified address to use the owner balance
142     * @param _spender The address to be allowed to spend.
143     * @param _value The amount to be allowed.
144     */
145     function approve(address _spender, uint256 _value) public returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     /**
152     * @dev Get the allowance of an specified address to use another address balance.
153     * @param _owner The address of the owner of the tokens.
154     * @param _spender The address of the allowed spender.
155     */
156     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157         return allowed[_owner][_spender];
158     }
159 
160     /**
161     * @dev Mint token to an specified address.
162     * @param _target The address of the receiver of the tokens.
163     * @param _mintedAmount amount to mint.
164     */
165     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
166         require(_target != address(0));
167         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
168         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
169         Transfer(0, this, _mintedAmount);
170         Transfer(this, _target, _mintedAmount);
171     }
172 
173     /**
174     * @dev Burn token.
175     * @param _burnedAmount amount to burn.
176     */
177     function burnToken(uint256 _burnedAmount) supplyLock public {
178         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
179         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
180         Burned(msg.sender, _burnedAmount);
181     }
182 
183     /**
184     * @dev Log Events
185     */
186     event Transfer(address indexed _from, address indexed _to, uint256 _value);
187     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
188     event Burned(address indexed _target, uint256 _value);
189 }
190 
191 /**
192 * @title Asset
193 * @dev Initial supply creation
194 */
195 contract Asset is ERC20Token {
196     string public name = 'Equitybase';
197     uint8 public decimals = 18;
198     string public symbol = 'BASE';
199     string public version = '2';
200 
201     /**
202     * @dev Asset constructor.
203     * @param _privateSaleWallet The wallet address for the private sale distribution.
204     * @param _companyReserveAndBountyWallet The wallet address of the company to handle also reserve and bounties.
205     */
206     function Asset(address _privateSaleWallet, address _companyReserveAndBountyWallet) public {
207         //Sanity checks
208         require(msg.sender != _privateSaleWallet);
209         require(msg.sender != _companyReserveAndBountyWallet);
210         require(_privateSaleWallet != _companyReserveAndBountyWallet);
211         require(_privateSaleWallet != 0);
212         require(_companyReserveAndBountyWallet != 0);
213 
214         totalSupply = 360000000 * (10**uint256(decimals)); //initial token creation
215         
216         balances[msg.sender] = 180000000 * (10**uint256(decimals)); //180 Million for crowdsale
217         balances[_privateSaleWallet] = 14400000 * (10**uint256(decimals)); //14.4 Million for crowdsale
218         balances[_companyReserveAndBountyWallet] = 165240000 * (10**uint256(decimals)); //165.24 Million for crowdsale
219         balances[0xA6bc924715A0B63C6E0a7653d3262D26F254EcFd] = 360000 * (10**uint256(decimals)); //360k for contract writer (0.1%)
220 
221         setSupplyLock(true);
222 
223         Transfer(0, this, totalSupply);
224         Transfer(this, msg.sender, balances[msg.sender]);
225         Transfer(this, _privateSaleWallet, balances[_privateSaleWallet]);
226         Transfer(this, _companyReserveAndBountyWallet, balances[_companyReserveAndBountyWallet]);
227         Transfer(this, 0xA6bc924715A0B63C6E0a7653d3262D26F254EcFd, balances[0xA6bc924715A0B63C6E0a7653d3262D26F254EcFd]);
228     }
229     
230     /**
231     *@dev Function to handle callback calls
232     */
233     function() public {
234         revert();
235     }
236 }