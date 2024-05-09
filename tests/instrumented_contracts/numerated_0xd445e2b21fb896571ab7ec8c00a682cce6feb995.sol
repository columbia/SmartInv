1 pragma solidity 0.5.9;
2 /**
3 * TOKEN Contract
4 * ERC-20 Token Standard Compliant
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24 }
25 
26 /**
27  * Token contract interface for external use
28  */
29 contract ERC20TokenInterface {
30 
31     function balanceOf(address _owner) public view returns (uint256 value);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     }
38 
39 contract ApproveAndCallFallBack {
40  
41     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
42  
43 }
44 
45 /**
46 * @title Admin parameters
47 * @dev Define administration parameters for this contract
48 */
49 contract admined { //This token contract is administered
50     address public admin; //Admin address is public
51     bool public lockSupply; //Mint and Burn Lock flag
52     bool public lockTransfer; //Transfer Lock flag
53     address public allowedAddress; //an address that can override lock condition
54 
55     /**
56     * @dev Contract constructor
57     * define initial administrator
58     */
59     constructor() internal {
60         admin = 0x129e3B92f033d553E38599AD3aa9C45A2FACaF73; //Set initial admin to contract owner
61         emit Admined(admin);
62     }
63 
64    /**
65     * @dev Function to set an allowed address
66     * @param _to The address to give privileges.
67     */
68     function setAllowedAddress(address _to) onlyAdmin public {
69         allowedAddress = _to;
70         emit AllowedSet(_to);
71     }
72 
73     modifier onlyAdmin() { //A modifier to define admin-only functions
74         require(msg.sender == admin);
75         _;
76     }
77 
78     modifier supplyLock() { //A modifier to lock mint and burn transactions
79         require(lockSupply == false);
80         _;
81     }
82 
83     modifier transferLock() { //A modifier to lock transactions
84         require(lockTransfer == false || allowedAddress == msg.sender);
85         _;
86     }
87 
88    /**
89     * @dev Function to set new admin address
90     * @param _newAdmin The address to transfer administration to
91     */
92     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
93         require(_newAdmin != address(0));
94         admin = _newAdmin;
95         emit TransferAdminship(admin);
96     }
97 
98    /**
99     * @dev Function to set mint and burn locks
100     * @param _set boolean flag (true | false)
101     */
102     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
103         lockSupply = _set;
104         emit SetSupplyLock(_set);
105     }
106 
107    /**
108     * @dev Function to set transfer lock
109     * @param _set boolean flag (true | false)
110     */
111     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
112         lockTransfer = _set;
113         emit SetTransferLock(_set);
114     }
115 
116     //All admin actions have a log for public review
117     event AllowedSet(address _to);
118     event SetSupplyLock(bool _set);
119     event SetTransferLock(bool _set);
120     event TransferAdminship(address newAdminister);
121     event Admined(address administer);
122 
123 }
124 
125 /**
126 * @title Token definition
127 * @dev Define token paramters including ERC20 ones
128 */
129 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
130     using SafeMath for uint256;
131     uint256 public totalSupply;
132     mapping (address => uint256) balances; //A mapping of all balances per address
133     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
134     mapping (address => bool) frozen; //A mapping of frozen accounts
135 
136     /**
137     * @dev Get the balance of an specified address.
138     * @param _owner The address to be query.
139     */
140     function balanceOf(address _owner) public view returns (uint256 value) {
141       return balances[_owner];
142     }
143 
144     /**
145     * @dev transfer token to a specified address
146     * @param _to The address to transfer to.
147     * @param _value The amount to be transferred.
148     */
149     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
150         require(_to != address(0)); //If you dont want that people destroy token
151         require(frozen[msg.sender]==false);
152         balances[msg.sender] = balances[msg.sender].sub(_value);
153         balances[_to] = balances[_to].add(_value);
154         emit Transfer(msg.sender, _to, _value);
155         return true;
156     }
157 
158     /**
159     * @dev transfer token from an address to another specified address using allowance
160     * @param _from The address where token comes.
161     * @param _to The address to transfer to.
162     * @param _value The amount to be transferred.
163     */
164     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
165         require(_to != address(0)); //If you dont want that people destroy token
166         require(frozen[_from]==false);
167         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Assign allowance to an specified address to use the owner balance
176     * @param _spender The address to be allowed to spend.
177     * @param _value The amount to be allowed.
178     */
179     function approve(address _spender, uint256 _value) public returns (bool success) {
180         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
181         allowed[msg.sender][_spender] = _value;
182         emit Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187     * @dev Get the allowance of an specified address to use another address balance.
188     * @param _owner The address of the owner of the tokens.
189     * @param _spender The address of the allowed spender.
190     */
191     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
192         return allowed[_owner][_spender];
193     }
194 
195     function approveAndCall(address spender, uint256 _value, bytes memory data) public returns (bool success) {
196         require((_value == 0) || (allowed[msg.sender][spender] == 0));
197         allowed[msg.sender][spender] = _value;
198         emit Approval(msg.sender, spender, _value);
199         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, _value, address(this), data);
200         return true;
201     }
202 
203     /**
204     * @dev Mint token to an specified address.
205     * @param _target The address of the receiver of the tokens.
206     * @param _mintedAmount amount to mint.
207     */
208     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
209         require(totalSupply.add(_mintedAmount) <= 1000000000 * (10 ** 2) ); //max supply
210         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
211         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
212         emit Transfer(address(0), _target, _mintedAmount);
213     }
214 
215     /**
216     * @dev Burn token of own address.
217     * @param _burnedAmount amount to burn.
218     */
219     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
220         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
221         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
222         emit Burned(msg.sender, _burnedAmount);
223     }
224 
225     /**
226     * @dev Log Events
227     */
228     event Transfer(address indexed _from, address indexed _to, uint256 _value);
229     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
230     event Burned(address indexed _target, uint256 _value);
231 }
232 
233 /**
234 * @title Asset
235 * @dev Initial supply creation
236 */
237 contract Asset is ERC20Token {
238     string public name = 'PGcoin';
239     uint8 public decimals = 2;
240     string public symbol = 'PGC';
241     string public version = '2';
242 
243    constructor() public {
244         totalSupply = 200000000 * (10 ** uint256(decimals)); //initial token creation
245         balances[0x129e3B92f033d553E38599AD3aa9C45A2FACaF73] = totalSupply;
246 
247         emit Transfer(address(0), 0x129e3B92f033d553E38599AD3aa9C45A2FACaF73, balances[0x129e3B92f033d553E38599AD3aa9C45A2FACaF73]);
248     }
249     
250     /**
251     *@dev Function to handle callback calls
252     */
253     function() external {
254         revert();
255     }
256 
257 }