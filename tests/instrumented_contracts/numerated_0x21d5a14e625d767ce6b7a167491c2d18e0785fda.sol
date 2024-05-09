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
102     bool public codeExportEnabled;
103     address public commissionAddress;           // address to deposit commissions
104     uint public deploymentCost;                 // cost of deployment with exchange feature
105     uint public tokenOnlyDeploymentCost;        // cost of deployment with basic ERC20 feature
106     uint public exchangeEnableCost;             // cost of upgrading existing ERC20 to exchange feature
107     uint public codeExportCost;                 // cost of exporting the code
108 
109     mapping(address => uint) public balances;
110     mapping(address => mapping(address => uint)) public allowed;
111 
112     // The Token constructor
113     function MultiToken(
114         uint _initialSupply,
115         string _tokenName,
116         uint _decimalUnits,
117         string _tokenSymbol,
118         string _version,
119         uint _tokenPrice
120                         ) public
121     {
122 
123         totalSupply = _initialSupply * (10**_decimalUnits);
124         name = _tokenName;          // Set the name for display purposes
125         symbol = _tokenSymbol;      // Set the symbol for display purposes
126         decimals = _decimalUnits;   // Amount of decimals for display purposes
127         version = _version;         // Version of token
128         tokenPrice = _tokenPrice;   // Token price in ETH
129 
130         balances[owner] = totalSupply;
131 
132         deploymentCost = 25e17;
133         tokenOnlyDeploymentCost = 15e17;
134         exchangeEnableCost = 15e17;
135         codeExportCost = 1e19;
136 
137         codeExportEnabled = true;
138         exchangeEnabled = true;
139 
140         // if (deploymentCost + codeExportCost == msg.value) {
141         //     codeExportEnabled = true;
142         //     exchangeEnabled = true;
143         // }else if (tokenOnlyDeploymentCost + codeExportCost == msg.value)
144         //     codeExportEnabled = true;
145         // else if (deploymentCost == msg.value)
146         //     exchangeEnabled = true;
147         // else if (tokenOnlyDeploymentCost == msg.value)
148         //     exchangeEnabled = false;
149         // else {
150         //     revert();  // fail if wrong amount sent.
151         // }
152         commissionAddress = 0x80eFc17CcDC8fE6A625cc4eD1fdaf71fD81A2C99;
153         // commissionAddress.transfer(msg.value);
154     }
155 
156     event TransferSold(address indexed to, uint value);
157     event TokenExchangeEnabled(address caller, uint exchangeCost);
158     event TokenExportEnabled(address caller, uint enableCost);
159 
160     // @noice To be called by parent contract to enable exchange functionality
161     // @param _tokenPrice {uint} costo of token in ETH
162     // @return true {bool} if successful
163     function enableExchange(uint _tokenPrice) public payable {
164 
165         require(!exchangeEnabled);
166         require(exchangeEnableCost == msg.value);
167         exchangeEnabled = true;
168         tokenPrice = _tokenPrice;
169         commissionAddress.transfer(msg.value);
170         emit TokenExchangeEnabled(msg.sender, _tokenPrice);
171     }
172 
173         // @notice to enable code export functionality
174     function enableCodeExport() public payable {
175 
176         require(!codeExportEnabled);
177         require(codeExportCost == msg.value);
178         codeExportEnabled = true;
179         commissionAddress.transfer(msg.value);
180         emit TokenExportEnabled(msg.sender, msg.value);
181     }
182 
183     // @notice It will send tokens to sender based on the token price
184     function swapTokens() public payable {
185 
186         require(exchangeEnabled);
187         uint tokensToSend;
188         tokensToSend = (msg.value * (10**decimals)) / tokenPrice;
189         require(balances[owner] >= tokensToSend);
190         balances[msg.sender] = balances[msg.sender].add(tokensToSend);
191         balances[owner] = balances[owner].sub(tokensToSend);
192         owner.transfer(msg.value);
193         emit Transfer(owner, msg.sender, tokensToSend);
194         emit TransferSold(msg.sender, tokensToSend);
195     }
196 
197 
198     // @notice will be able to mint tokens in the future
199     // @param _target {address} address to which new tokens will be assigned
200     // @parm _mintedAmount {uint256} amouont of tokens to mint
201     function mintToken(address _target, uint256 _mintedAmount) public onlyOwner() {
202 
203         balances[_target] += _mintedAmount;
204         totalSupply += _mintedAmount;
205         emit Transfer(0, _target, _mintedAmount);
206     }
207 
208     // @notice transfer tokens to given address
209     // @param _to {address} address or recipient
210     // @param _value {uint} amount to transfer
211     // @return  {bool} true if successful
212     function transfer(address _to, uint _value) public returns(bool) {
213 
214         require(_to != address(0));
215         require(balances[msg.sender] >= _value);
216         balances[msg.sender] = balances[msg.sender].sub(_value);
217         balances[_to] = balances[_to].add(_value);
218         emit Transfer(msg.sender, _to, _value);
219         return true;
220     }
221 
222     // @notice transfer tokens from given address to another address
223     // @param _from {address} from whom tokens are transferred
224     // @param _to {address} to whom tokens are transferred
225     // @param _value {uint} amount of tokens to transfer
226     // @return  {bool} true if successful
227     function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {
228 
229         require(_to != address(0));
230         require(balances[_from] >= _value); // Check if the sender has enough
231         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
232         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
233         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
234         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
235         emit Transfer(_from, _to, _value);
236         return true;
237     }
238 
239     // @notice to query balance of account
240     // @return _owner {address} address of user to query balance
241     function balanceOf(address _owner) public view returns(uint balance) {
242         return balances[_owner];
243     }
244 
245     /**
246     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247     *
248     * Beware that changing an allowance with this method brings the risk that someone may use both the old
249     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252     * @param _spender The address which will spend the funds.
253     * @param _value The amount of tokens to be spent.
254     */
255     function approve(address _spender, uint _value) public returns(bool) {
256         allowed[msg.sender][_spender] = _value;
257         emit Approval(msg.sender, _spender, _value);
258         return true;
259     }
260 
261     // @notice to query of allowance of one user to the other
262     // @param _owner {address} of the owner of the account
263     // @param _spender {address} of the spender of the account
264     // @return remaining {uint} amount of remaining allowance
265     function allowance(address _owner, address _spender) public view returns(uint remaining) {
266         return allowed[_owner][_spender];
267     }
268 
269     /**
270     * approve should be called when allowed[_spender] == 0. To increment
271     * allowed value is better to use this function to avoid 2 calls (and wait until
272     * the first transaction is mined)
273     * From MonolithDAO Token.sol
274     */
275     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
276         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
282         uint oldValue = allowed[msg.sender][_spender];
283         if (_subtractedValue > oldValue) {
284             allowed[msg.sender][_spender] = 0;
285         } else {
286             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287         }
288         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289         return true;
290     }
291 
292 }