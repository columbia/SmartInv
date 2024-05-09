1 pragma solidity ^0.4.18;
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
40 contract ApproveAndCallFallBack {
41  
42     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
43  
44 }
45 
46 /**
47 * @title Admin parameters
48 * @dev Define administration parameters for this contract
49 */
50 contract admined { //This token contract is administered
51     address public admin; //Admin address is public
52     bool public lockSupply; //Mint and Burn Lock flag
53     bool public lockTransfer; //Transfer Lock flag
54     address public allowedAddress; //an address that can override lock condition
55 
56     /**
57     * @dev Contract constructor
58     * define initial administrator
59     */
60     function admined() internal {
61         admin = msg.sender; //Set initial admin to contract creator
62         Admined(admin);
63     }
64 
65    /**
66     * @dev Function to set an allowed address
67     * @param _to The address to give privileges.
68     */
69     function setAllowedAddress(address _to) onlyAdmin public {
70         allowedAddress = _to;
71         AllowedSet(_to);
72     }
73 
74     modifier onlyAdmin() { //A modifier to define admin-only functions
75         require(msg.sender == admin);
76         _;
77     }
78 
79     modifier supplyLock() { //A modifier to lock mint and burn transactions
80         require(lockSupply == false);
81         _;
82     }
83 
84     modifier transferLock() { //A modifier to lock transactions
85         require(lockTransfer == false || allowedAddress == msg.sender);
86         _;
87     }
88 
89    /**
90     * @dev Function to set new admin address
91     * @param _newAdmin The address to transfer administration to
92     */
93     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
94         require(_newAdmin != 0);
95         admin = _newAdmin;
96         TransferAdminship(admin);
97     }
98 
99    /**
100     * @dev Function to set mint and burn locks
101     * @param _set boolean flag (true | false)
102     */
103     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
104         lockSupply = _set;
105         SetSupplyLock(_set);
106     }
107 
108    /**
109     * @dev Function to set transfer lock
110     * @param _set boolean flag (true | false)
111     */
112     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
113         lockTransfer = _set;
114         SetTransferLock(_set);
115     }
116 
117     //All admin actions have a log for public review
118     event AllowedSet(address _to);
119     event SetSupplyLock(bool _set);
120     event SetTransferLock(bool _set);
121     event TransferAdminship(address newAdminister);
122     event Admined(address administer);
123 
124 }
125 
126 /**
127 * @title Token definition
128 * @dev Define token paramters including ERC20 ones
129 */
130 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
131     using SafeMath for uint256;
132     uint256 public totalSupply;
133     mapping (address => uint256) balances; //A mapping of all balances per address
134     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
135     mapping (address => bool) frozen; //A mapping of frozen accounts
136 
137     /**
138     * @dev Get the balance of an specified address.
139     * @param _owner The address to be query.
140     */
141     function balanceOf(address _owner) public constant returns (uint256 value) {
142       return balances[_owner];
143     }
144 
145     /**
146     * @dev transfer token to a specified address
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
151         require(_to != address(0)); //If you dont want that people destroy token
152         require(frozen[msg.sender]==false);
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     /**
160     * @dev transfer token from an address to another specified address using allowance
161     * @param _from The address where token comes.
162     * @param _to The address to transfer to.
163     * @param _value The amount to be transferred.
164     */
165     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
166         require(_to != address(0)); //If you dont want that people destroy token
167         require(frozen[_from]==false);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         balances[_from] = balances[_from].sub(_value);
170         balances[_to] = balances[_to].add(_value);
171         Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     /**
176     * @dev Assign allowance to an specified address to use the owner balance
177     * @param _spender The address to be allowed to spend.
178     * @param _value The amount to be allowed.
179     */
180     function approve(address _spender, uint256 _value) public returns (bool success) {
181         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182         allowed[msg.sender][_spender] = _value;
183         Approval(msg.sender, _spender, _value);
184         return true;
185     }
186 
187     /**
188     * @dev Get the allowance of an specified address to use another address balance.
189     * @param _owner The address of the owner of the tokens.
190     * @param _spender The address of the allowed spender.
191     */
192     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
193         return allowed[_owner][_spender];
194     }
195 
196     function approveAndCall(address spender, uint256 _value, bytes data) public returns (bool success) {
197         require((_value == 0) || (allowed[msg.sender][spender] == 0));
198         allowed[msg.sender][spender] = _value;
199         Approval(msg.sender, spender, _value);
200         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, _value, this, data);
201         return true;
202     }
203 
204     /**
205     * @dev Mint token to an specified address.
206     * @param _target The address of the receiver of the tokens.
207     * @param _mintedAmount amount to mint.
208     */
209     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
210         require(totalSupply.add(_mintedAmount) <= 1000000000 * (10 ** 2) ); //max supply, 18 decimals
211         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
212         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
213         Transfer(0, this, _mintedAmount);
214         Transfer(this, _target, _mintedAmount);
215     }
216 
217     /**
218     * @dev Burn token of own address.
219     * @param _burnedAmount amount to burn.
220     */
221     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
222         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
223         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
224         Burned(msg.sender, _burnedAmount);
225     }
226 
227     /**
228     * @dev Log Events
229     */
230     event Transfer(address indexed _from, address indexed _to, uint256 _value);
231     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
232     event Burned(address indexed _target, uint256 _value);
233 }
234 
235 /**
236 * @title Asset
237 * @dev Initial supply creation
238 */
239 contract Asset is ERC20Token {
240     string public name = 'PGcoin';
241     uint8 public decimals = 2;
242     string public symbol = 'PGC';
243     string public version = '1';
244 
245     function Asset() public {
246         totalSupply = 200000000 * (10 ** uint256(decimals)); //initial token creation
247         balances[msg.sender] = totalSupply;
248         setSupplyLock(true);
249 
250         Transfer(0, this, totalSupply);
251         Transfer(this, msg.sender, balances[msg.sender]);
252     }
253     
254     /**
255     *@dev Function to handle callback calls
256     */
257     function() public {
258         revert();
259     }
260 
261 }