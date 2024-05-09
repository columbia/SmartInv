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
49 
50     address public owner;
51     
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56     * account.
57     */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63     * @dev Throws if called by any account other than the owner.
64     */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71     * @dev Allows the current owner to transfer control of the contract to a newOwner.
72     * @param newOwner The address to transfer ownership to.
73     */
74     function transferOwnership(address newOwner) onlyOwner public {
75         require(newOwner != address(0));
76         OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 
80 }
81 
82 // The  Exchange token
83 contract MultiToken is ERC20, Ownable {
84 
85     using SafeMath for uint;
86     // Public variables of the token
87     string public name;
88     string public symbol;
89     uint public decimals; // How many decimals to show.
90     string public version;
91     uint public totalSupply;
92     uint public tokenPrice;
93     bool public exchangeEnabled;
94     bool public codeExportEnabled;
95   
96     mapping(address => uint) public balances;
97     mapping(address => mapping(address => uint)) public allowed;
98 
99 
100     // The Token constructor     
101     function MultiToken(uint _initialSupply,
102                         string _tokenName,
103                         uint _decimalUnits,
104                         string _tokenSymbol,
105                         string _version,                       
106                         uint _tokenPrice
107                         ) public 
108     {
109 
110         totalSupply = _initialSupply * (10**_decimalUnits);                                             
111         name = _tokenName;          // Set the name for display purposes
112         symbol = _tokenSymbol;      // Set the symbol for display purposes
113         decimals = _decimalUnits;   // Amount of decimals for display purposes
114         version = _version;         // Version of token
115         tokenPrice = _tokenPrice;   // Token price in ETH           
116         balances[0xeadA6cDDC45656d0E72089997eE3d6D4383Bce89] = totalSupply;    
117         codeExportEnabled = true;
118         exchangeEnabled = true;            
119         
120              
121     }
122 
123     event TransferSold(address indexed to, uint value);
124     event TokenExchangeEnabled(address caller, uint exchangeCost);
125     event TokenExportEnabled(address caller, uint enableCost);
126 
127 
128     // @notice It will send tokens to sender based on the token price    
129     function swapTokens() public payable {     
130 
131         require(exchangeEnabled);   
132         uint tokensToSend;
133         tokensToSend = (msg.value * (10**decimals)) / tokenPrice; 
134         require(balances[owner] >= tokensToSend);
135         balances[msg.sender] += tokensToSend;
136         balances[owner] -= tokensToSend;
137         owner.transfer(msg.value);
138         emit Transfer(owner, msg.sender, tokensToSend);
139         emit TransferSold(msg.sender, tokensToSend);       
140     }
141 
142 
143     // @notice will be able to mint tokens in the future
144     // @param _target {address} address to which new tokens will be assigned
145     // @parm _mintedAmount {uint256} amouont of tokens to mint
146     function mintToken(address _target, uint256 _mintedAmount) public onlyOwner() {        
147         
148         balances[_target] += _mintedAmount;
149         totalSupply += _mintedAmount;
150         emit Transfer(0, _target, _mintedAmount);       
151     }
152   
153     // @notice transfer tokens to given address
154     // @param _to {address} address or recipient
155     // @param _value {uint} amount to transfer
156     // @return  {bool} true if successful
157     function transfer(address _to, uint _value) public returns(bool) {
158 
159         require(_to != address(0));
160         require(balances[msg.sender] >= _value);
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     // @notice transfer tokens from given address to another address
168     // @param _from {address} from whom tokens are transferred
169     // @param _to {address} to whom tokens are transferred
170     // @param _value {uint} amount of tokens to transfer
171     // @return  {bool} true if successful
172     function transferFrom(address _from, address _to, uint256 _value) public  returns(bool success) {
173 
174         require(_to != address(0));
175         require(balances[_from] >= _value); // Check if the sender has enough
176         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
177         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
178         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
179         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
180         emit Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     // @notice to query balance of account
185     // @return _owner {address} address of user to query balance
186     function balanceOf(address _owner) public view returns(uint balance) {
187         return balances[_owner];
188     }
189 
190     /**
191     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192     *
193     * Beware that changing an allowance with this method brings the risk that someone may use both the old
194     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197     * @param _spender The address which will spend the funds.
198     * @param _value The amount of tokens to be spent.
199     */
200     function approve(address _spender, uint _value) public returns(bool) {
201         allowed[msg.sender][_spender] = _value;
202         emit Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     // @notice to query of allowance of one user to the other
207     // @param _owner {address} of the owner of the account
208     // @param _spender {address} of the spender of the account
209     // @return remaining {uint} amount of remaining allowance
210     function allowance(address _owner, address _spender) public view returns(uint remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215     * approve should be called when allowed[_spender] == 0. To increment
216     * allowed value is better to use this function to avoid 2 calls (and wait until
217     * the first transaction is mined)
218     * From MonolithDAO Token.sol
219     */
220     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
221         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
227         uint oldValue = allowed[msg.sender][_spender];
228         if (_subtractedValue > oldValue) {
229             allowed[msg.sender][_spender] = 0;
230         } else {
231             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232         }
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237 }