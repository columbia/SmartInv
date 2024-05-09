1 /**
2  * @title ERC20 interface
3  * @dev Implements ERC20 Token Standard: https://github.com/ethereum/EIPs/issues/20
4  */
5 contract ERC20 {
6     uint256 public totalSupply;
7 
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 library SafeMath {
20     function add(uint256 x, uint256 y) internal pure returns(uint256) {
21         uint256 z = x + y;
22         assert((z >= x) && (z >= y));
23         return z;
24     }
25 
26     function sub(uint256 x, uint256 y) internal pure returns(uint256) {
27         assert(x >= y);
28         uint256 z = x - y;
29         return z;
30     }
31 
32     function mul(uint256 x, uint256 y) internal pure returns(uint256) {
33         uint256 z = x * y;
34         assert((x == 0) || (z / x == y));
35         return z;
36     }
37 
38     function div(uint256 x, uint256 y) internal pure returns(uint256) {
39         assert(y != 0);
40         uint256 z = x / y;
41         assert(x == y * z + x % y);
42         return z;
43     }
44 }
45 
46 
47 /// @title Contract that will work with ERC223 tokens.
48 contract ERC223ReceivingContract { 
49     /*
50     * @dev Standard ERC223 function that will handle incoming token transfers.
51     * @param _from Token sender address.
52     * @param _value Amount of tokens.
53     * @param _data Transaction metadata.
54     */
55     function tokenFallback(address _from, uint _value, bytes _data) external;
56 }
57 
58 
59 /**
60  * @title Ownable contract
61  * @dev The Ownable contract has an owner address, and provides basic authorization control functions.
62  */
63 contract Ownable {
64     address public owner;
65 
66     // Modifiers
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     modifier validAddress(address _address) {
73         require(_address != address(0));
74         _;
75     }
76 
77     // Events
78     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
79 
80     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
81     constructor(address _owner) public validAddress(_owner) {
82         owner = _owner;
83     }
84 
85     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
86     /// @param _newOwner The address to transfer ownership to.
87     function transferOwnership(address _newOwner) public onlyOwner validAddress(_newOwner) {
88         emit OwnershipTransferred(owner, _newOwner);
89         owner = _newOwner;
90     }
91 }
92 
93 
94 
95 
96 
97 
98 
99 
100 
101 
102 contract ERC223 is ERC20 {
103     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
104     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
105 }
106 
107 
108 
109 
110 contract StandardToken is ERC223 {
111     using SafeMath for uint256;
112 
113     mapping(address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowed;
115 
116     // Modifiers
117     modifier validAddress(address _address) {
118         require(_address != address(0));
119         _;
120     }
121 
122     /*
123     * @dev ERC20 method to transfer token to a specified address.
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public returns (bool) {
128         bytes memory empty;
129         transfer(_to, _value, empty);
130     }
131 
132     /*
133     * @dev ERC223 method to transfer token to a specified address with data.
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     * @param _data Transaction metadata.
137     */
138     function transfer(address _to, uint256 _value, bytes _data) public validAddress(_to) returns (bool success) {
139         uint codeLength;
140 
141         assembly {
142             // Retrieve the size of the code on target address, this needs assembly
143             codeLength := extcodesize(_to)
144         }
145 
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148 
149         // Call token fallback function if _to is a contract. Rejects if not implemented.
150         if (codeLength > 0) {
151             ERC223ReceivingContract(_to).tokenFallback(msg.sender, _value, _data);
152         }
153 
154         emit Transfer(msg.sender, _to, _value, _data);
155         return true;
156     }
157 
158     /*
159     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160     * @param _spender The address which will spend the funds.
161     * @param _value The amount of tokens to be spent.
162     */
163     function approve(address _spender, uint256 _value) public returns (bool) {
164         // To change the approve amount you first have to reduce the addresses`
165         //  allowance to zero by calling `approve(_spender, 0)` if it is not
166         //  already 0 to mitigate the race condition described here:
167         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
169 
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /*
176     * @dev Transfer tokens from one address to another
177     * @param _from address The address which you want to send tokens from
178     * @param _to address The address which you want to transfer to
179     * @param _value uint256 the amount of tokens to be transferred
180     */
181     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
182         uint256 _allowance = allowed[_from][msg.sender];
183 
184         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
185         // require (_value <= _allowance);
186 
187         balances[_from] = balances[_from].sub(_value);
188         balances[_to] = balances[_to].add(_value);
189         allowed[_from][msg.sender] = _allowance.sub(_value);
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /*
195     * @dev Gets the balance of the specified address.
196     * @param _owner The address to query the the balance of.
197     * @return An uint256 representing the amount owned by the passed address.
198     */
199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return balances[_owner];
201     }
202 
203     /*
204     * @dev Function to check the amount of tokens that an owner allowed to a spender.
205     * @param _owner address The address which owns the funds.
206     * @param _spender address The address which will spend the funds.
207     * @return A uint256 specifying the amount of tokens still available for the spender.
208     */
209     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
210         return allowed[_owner][_spender];
211     }
212 }
213 
214 
215 
216 contract MintableToken is StandardToken, Ownable {
217     // Events
218     event Mint(uint256 supply, address indexed to, uint256 amount);
219 
220     function tokenTotalSupply() public pure returns (uint256);
221 
222     /// @dev Allows the owner to mint new tokens
223     /// @param _to Address to mint the tokens to
224     /// @param _amount Amount of tokens that will be minted
225     /// @return Boolean to signify successful minting
226     function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
227         require(totalSupply.add(_amount) <= tokenTotalSupply());
228 
229         totalSupply = totalSupply.add(_amount);
230         balances[_to] = balances[_to].add(_amount);
231 
232         emit Mint(totalSupply, _to, _amount);
233         emit Transfer(address(0), _to, _amount);
234 
235         return true;
236     }
237 }
238 
239 
240 contract BodhiEthereum is MintableToken {
241     // Token configurations
242     string public constant name = "Bodhi Ethereum";
243     string public constant symbol = "BOE";
244     uint256 public constant decimals = 8;
245 
246     constructor() Ownable(msg.sender) public {
247     }
248 
249     // 100 million BOE ever created
250     function tokenTotalSupply() public pure returns (uint256) {
251         return 100 * (10**6) * (10**decimals);
252     }
253 }