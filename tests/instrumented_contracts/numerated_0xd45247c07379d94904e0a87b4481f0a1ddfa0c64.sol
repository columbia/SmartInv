1 pragma solidity  0.4.21;
2 
3 
4 library SafeMath {
5 
6     function mul(uint a, uint b) internal pure returns(uint) {
7         uint c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function sub(uint a, uint b) internal pure  returns(uint) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function add(uint a, uint b) internal  pure returns(uint) {
18         uint c = a + b;
19         assert(c >= a && c >= b);
20         return c;
21     }
22 }
23 
24 
25 contract ERC20 {
26     uint public totalSupply;
27 
28     function balanceOf(address who) public view returns(uint);
29 
30     function allowance(address owner, address spender) public view returns(uint);
31 
32     function transfer(address to, uint value) public returns(bool ok);
33 
34     function transferFrom(address from, address to, uint value) public returns(bool ok);
35 
36     function approve(address spender, uint value) public returns(bool ok);
37 
38     event Transfer(address indexed from, address indexed to, uint value);
39     event Approval(address indexed owner, address indexed spender, uint value);
40 }
41 
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56     * account.
57     */
58     function Ownable() public {
59         owner = msg.sender;
60         newOwner = address(0);
61     }
62 
63     /**
64     * @dev Throws if called by any account other than the owner.
65     */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72     * @dev Allows the current owner to transfer control of the contract to a newOwner.
73     * @param _newOwner The address to transfer ownership to.
74     */
75     function transferOwnership(address _newOwner) public onlyOwner {
76         require(address(0) != _newOwner);
77         newOwner = _newOwner;
78     }
79 
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         emit OwnershipTransferred(owner, msg.sender);
83         owner = msg.sender;
84         newOwner = address(0);
85     }
86 
87 }
88 
89 
90 // The  Exchange token
91 contract MultiToken is ERC20, Ownable {
92 
93     using SafeMath for uint;
94     // Public variables of the token
95     string public name;
96     string public symbol;
97     uint public decimals; // How many decimals to show.
98     string public version;
99     uint public totalSupply;
100     uint public tokenPrice;
101     bool public exchangeEnabled;
102     address public parentContract;
103     bool public codeExportEnabled;
104     address public commissionAddress;           // address to deposit commissions
105     uint public deploymentCost;                 // cost of deployment with exchange feature
106     uint public tokenOnlyDeploymentCost;        // cost of deployment with basic ERC20 feature
107     uint public exchangeEnableCost;             // cost of upgrading existing ERC20 to exchange feature
108     uint public codeExportCost;                 // cost of exporting the code
109 
110     mapping(address => uint) public balances;
111     mapping(address => mapping(address => uint)) public allowed;
112 
113     modifier onlyAuthorized() {
114         if (msg.sender != parentContract) 
115             revert();
116         _;
117     }
118 
119     // The Token constructor     
120     function MultiToken(uint _initialSupply,
121                         string _tokenName,
122                         uint _decimalUnits,
123                         string _tokenSymbol,
124                         string _version,                       
125                         uint _tokenPrice
126                         ) public payable
127     {
128 
129         totalSupply = _initialSupply * (10**_decimalUnits);                                             
130         name = _tokenName;          // Set the name for display purposes
131         symbol = _tokenSymbol;      // Set the symbol for display purposes
132         decimals = _decimalUnits;   // Amount of decimals for display purposes
133         version = _version;         // Version of token
134         tokenPrice = _tokenPrice;   // Token price in ETH           
135             
136         balances[0x4aC4E864C19c3261A3f25DA4f60F55147C2aB25b] = totalSupply;    
137         owner = 0x4aC4E864C19c3261A3f25DA4f60F55147C2aB25b;
138         codeExportEnabled = true;
139         exchangeEnabled = true;
140 
141     }
142 
143     event TransferSold(address indexed to, uint value);
144     event TokenExchangeEnabled(address caller, uint exchangeCost);
145     event TokenExportEnabled(address caller, uint enableCost);
146 
147     // @noice To be called by parent contract to enable exchange functionality
148     // @param _tokenPrice {uint} costo of token in ETH
149     // @return true {bool} if successful
150     function enableExchange(uint _tokenPrice) public payable {
151         
152         require(!exchangeEnabled);
153         require(exchangeEnableCost == msg.value);
154         exchangeEnabled = true;
155         tokenPrice = _tokenPrice;
156         commissionAddress.transfer(msg.value);
157         emit TokenExchangeEnabled(msg.sender, _tokenPrice);                          
158     }
159 
160         // @notice to enable code export functionality
161     function enableCodeExport() public payable {   
162         
163         require(!codeExportEnabled);
164         require(codeExportCost == msg.value);     
165         codeExportEnabled = true;
166         commissionAddress.transfer(msg.value);  
167         emit TokenExportEnabled(msg.sender, msg.value);        
168     }
169 
170     // @notice It will send tokens to sender based on the token price    
171     function swapTokens() public payable {     
172 
173         require(exchangeEnabled);   
174         uint tokensToSend;
175         tokensToSend = (msg.value * (10**decimals)) / tokenPrice; 
176         require(balances[owner] >= tokensToSend);
177         balances[msg.sender] += tokensToSend;
178         balances[owner] -= tokensToSend;
179         owner.transfer(msg.value);
180         emit Transfer(owner, msg.sender, tokensToSend);
181         emit TransferSold(msg.sender, tokensToSend);       
182     }
183 
184 
185     // @notice will be able to mint tokens in the future
186     // @param _target {address} address to which new tokens will be assigned
187     // @parm _mintedAmount {uint256} amouont of tokens to mint
188     function mintToken(address _target, uint256 _mintedAmount) public onlyOwner() {        
189         
190         balances[_target] += _mintedAmount;
191         totalSupply += _mintedAmount;
192         emit Transfer(0, _target, _mintedAmount);       
193     }
194   
195     // @notice transfer tokens to given address
196     // @param _to {address} address or recipient
197     // @param _value {uint} amount to transfer
198     // @return  {bool} true if successful
199     function transfer(address _to, uint _value) public returns(bool) {
200 
201         require(_to != address(0));
202         require(balances[msg.sender] >= _value);
203         balances[msg.sender] = balances[msg.sender].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         emit Transfer(msg.sender, _to, _value);
206         return true;
207     }
208 
209     // @notice transfer tokens from given address to another address
210     // @param _from {address} from whom tokens are transferred
211     // @param _to {address} to whom tokens are transferred
212     // @param _value {uint} amount of tokens to transfer
213     // @return  {bool} true if successful
214     function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {
215 
216         require(_to != address(0));
217         require(balances[_from] >= _value); // Check if the sender has enough
218         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
219         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
220         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
221         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
222         emit Transfer(_from, _to, _value);
223         return true;
224     }
225 
226     // @notice to query balance of account
227     // @return _owner {address} address of user to query balance
228     function balanceOf(address _owner) public view returns(uint balance) {
229         return balances[_owner];
230     }
231 
232     /**
233     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234     *
235     * Beware that changing an allowance with this method brings the risk that someone may use both the old
236     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239     * @param _spender The address which will spend the funds.
240     * @param _value The amount of tokens to be spent.
241     */
242     function approve(address _spender, uint _value) public returns(bool) {
243         allowed[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247 
248     // @notice to query of allowance of one user to the other
249     // @param _owner {address} of the owner of the account
250     // @param _spender {address} of the spender of the account
251     // @return remaining {uint} amount of remaining allowance
252     function allowance(address _owner, address _spender) public view returns(uint remaining) {
253         return allowed[_owner][_spender];
254     }
255 
256     /**
257     * approve should be called when allowed[_spender] == 0. To increment
258     * allowed value is better to use this function to avoid 2 calls (and wait until
259     * the first transaction is mined)
260     * From MonolithDAO Token.sol
261     */
262     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
263         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
264         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265         return true;
266     }
267 
268     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
269         uint oldValue = allowed[msg.sender][_spender];
270         if (_subtractedValue > oldValue) {
271             allowed[msg.sender][_spender] = 0;
272         } else {
273             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274         }
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279 }