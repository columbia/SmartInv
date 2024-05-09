1 pragma solidity 0.4.21;
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
48     bool public lockTransfer; //Transfer Lock flag
49     address public allowedAddress; //an address that can override lock condition
50 
51     /**
52     * @dev Contract constructor
53     * define initial administrator
54     */
55     function admined() internal {
56         admin = msg.sender; //Set initial admin to contract creator
57         emit Admined(admin);
58     }
59 
60    /**
61     * @dev Function to set an allowed address
62     * @param _to The address to give privileges.
63     */
64     function setAllowedAddress(address _to) onlyAdmin public {
65         allowedAddress = _to;
66         emit AllowedSet(_to);
67     }
68 
69     modifier onlyAdmin() { //A modifier to define admin-only functions
70         require(msg.sender == admin);
71         _;
72     }
73 
74     modifier supplyLock() { //A modifier to lock mint and burn transactions
75         require(lockSupply == false);
76         _;
77     }
78 
79     modifier transferLock() { //A modifier to lock transactions
80         require(lockTransfer == false || allowedAddress == msg.sender);
81         _;
82     }
83 
84    /**
85     * @dev Function to set new admin address
86     * @param _newAdmin The address to transfer administration to
87     */
88     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
89         require(_newAdmin != 0);
90         admin = _newAdmin;
91         emit TransferAdminship(admin);
92     }
93 
94    /**
95     * @dev Function to set mint and burn locks
96     * @param _set boolean flag (true | false)
97     */
98     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
99         lockSupply = _set;
100         emit SetSupplyLock(_set);
101     }
102 
103    /**
104     * @dev Function to set transfer lock
105     * @param _set boolean flag (true | false)
106     */
107     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
108         lockTransfer = _set;
109         emit SetTransferLock(_set);
110     }
111 
112     //All admin actions have a log for public review
113     event AllowedSet(address _to);
114     event SetSupplyLock(bool _set);
115     event SetTransferLock(bool _set);
116     event TransferAdminship(address newAdminister);
117     event Admined(address administer);
118 
119 }
120 
121 /**
122 * @title Token definition
123 * @dev Define token paramters including ERC20 ones
124 */
125 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
126     using SafeMath for uint256;
127     uint256 public totalSupply;
128     mapping (address => uint256) balances; //A mapping of all balances per address
129     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
130 
131     /**
132     * @dev Get the balance of an specified address.
133     * @param _owner The address to be query.
134     */
135     function balanceOf(address _owner) public constant returns (uint256 value) {
136       return balances[_owner];
137     }
138 
139     /**
140     * @dev transfer token to a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
145         require(_to != address(0)); //If you dont want that people destroy token
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev transfer token from an address to another specified address using allowance
154     * @param _from The address where token comes.
155     * @param _to The address to transfer to.
156     * @param _value The amount to be transferred.
157     */
158     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
159         require(_to != address(0)); //If you dont want that people destroy token
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         balances[_from] = balances[_from].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Assign allowance to an specified address to use the owner balance
169     * @param _spender The address to be allowed to spend.
170     * @param _value The amount to be allowed.
171     */
172     function approve(address _spender, uint256 _value) public returns (bool success) {
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Get the allowance of an specified address to use another address balance.
180     * @param _owner The address of the owner of the tokens.
181     * @param _spender The address of the allowed spender.
182     */
183     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 
187     /**
188     * @dev Mint token to own address.
189     * @param _mintedAmount amount to mint.
190     */
191     function mintToken(uint256 _mintedAmount) onlyAdmin supplyLock public {
192         require(totalSupply.add(_mintedAmount) < 250000000 * (10**18)); //Max supply ever
193         balances[msg.sender] = SafeMath.add(balances[msg.sender], _mintedAmount);
194         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
195         emit Transfer(0, this, _mintedAmount);
196         emit Transfer(this, msg.sender, _mintedAmount);
197     }
198 
199     /**
200     * @dev Burn token from own address.
201     * @param _burnedAmount amount to burn.
202     */
203     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
204         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
205         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
206         emit Burned(msg.sender, _burnedAmount);
207     }
208 
209     /**
210     * @dev This is an especial function to make massive tokens assignments
211     * @param data array of addresses to transfer to
212     * @param amount array of amounts to tranfer to each address
213     */
214     function batch(address[] data,uint256[] amount) public { //It takes an array of addresses and an amount
215         require(data.length == amount.length);//same array sizes
216         for (uint i=0; i<data.length; i++) { //It moves over the array
217             transfer(data[i],amount[i]);
218         }
219     }
220 
221     /**
222     * @dev Log Events
223     */
224     event Transfer(address indexed _from, address indexed _to, uint256 _value);
225     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
226     event Burned(address indexed _target, uint256 _value);
227 }
228 
229 /**
230 * @title Asset
231 * @dev Initial supply creation
232 * @notice Supply is initially unlocked for minting
233 */
234 contract Asset is ERC20Token {
235     string public name = 'Citereum';
236     uint8 public decimals = 18;
237     string public symbol = 'CTR';
238     string public version = '1';
239 
240     function Asset() public {
241         totalSupply = 12500000 * (10**uint256(decimals)); //initial token creation
242         balances[msg.sender] = totalSupply;
243 
244         emit Transfer(0, this, totalSupply);
245         emit Transfer(this, msg.sender, balances[msg.sender]);
246     }
247     
248     /**
249     *@dev Function to handle callback calls
250     */
251     function() public {
252         revert();
253     }
254 
255 }