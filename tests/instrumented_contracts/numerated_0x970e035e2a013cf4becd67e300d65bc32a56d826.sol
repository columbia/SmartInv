1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20 interface
5  * @dev Implements ERC20 Token Standard: https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8     uint256 public totalSupply;
9 
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function approve(address _spender, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function balanceOf(address _owner) public view returns (uint256 balance);
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 library SafeMath {
22     function add(uint256 x, uint256 y) internal pure returns(uint256) {
23         uint256 z = x + y;
24         assert((z >= x) && (z >= y));
25         return z;
26     }
27 
28     function sub(uint256 x, uint256 y) internal pure returns(uint256) {
29         assert(x >= y);
30         uint256 z = x - y;
31         return z;
32     }
33 
34     function mul(uint256 x, uint256 y) internal pure returns(uint256) {
35         uint256 z = x * y;
36         assert((x == 0) || (z / x == y));
37         return z;
38     }
39 
40     function div(uint256 x, uint256 y) internal pure returns(uint256) {
41         assert(y != 0);
42         uint256 z = x / y;
43         assert(x == y * z + x % y);
44         return z;
45     }
46 }
47 
48 
49 /// @title Contract that will work with ERC223 tokens.
50 contract ERC223ReceivingContract { 
51     /*
52     * @dev Standard ERC223 function that will handle incoming token transfers.
53     * @param _from Token sender address.
54     * @param _value Amount of tokens.
55     * @param _data Transaction metadata.
56     */
57     function tokenFallback(address _from, uint _value, bytes _data) external;
58 }
59 
60 
61 /**
62  * @title Ownable contract
63  * @dev The Ownable contract has an owner address, and provides basic authorization control functions.
64  */
65 contract Ownable {
66     address public owner;
67 
68     // Modifiers
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     modifier validAddress(address _address) {
75         require(_address != address(0));
76         _;
77     }
78 
79     // Events
80     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
81 
82     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
83     constructor(address _owner) public validAddress(_owner) {
84         owner = _owner;
85     }
86 
87     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
88     /// @param _newOwner The address to transfer ownership to.
89     function transferOwnership(address _newOwner) public onlyOwner validAddress(_newOwner) {
90         emit OwnershipTransferred(owner, _newOwner);
91         owner = _newOwner;
92     }
93 }
94 
95 
96 
97 
98 
99 
100 
101 
102 
103 
104 contract ERC223 is ERC20 {
105     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
106     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
107 }
108 
109 
110 
111 
112 contract StandardToken is ERC223 {
113     using SafeMath for uint256;
114 
115     mapping(address => uint256) balances;
116     mapping (address => mapping (address => uint256)) allowed;
117 
118     // Modifiers
119     modifier validAddress(address _address) {
120         require(_address != address(0));
121         _;
122     }
123 
124     /*
125     * @dev ERC20 method to transfer token to a specified address.
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint256 _value) public returns (bool) {
130         bytes memory empty;
131         transfer(_to, _value, empty);
132     }
133 
134     /*
135     * @dev ERC223 method to transfer token to a specified address with data.
136     * @param _to The address to transfer to.
137     * @param _value The amount to be transferred.
138     * @param _data Transaction metadata.
139     */
140     function transfer(address _to, uint256 _value, bytes _data) public validAddress(_to) returns (bool success) {
141         uint codeLength;
142 
143         assembly {
144             // Retrieve the size of the code on target address, this needs assembly
145             codeLength := extcodesize(_to)
146         }
147 
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150 
151         // Call token fallback function if _to is a contract. Rejects if not implemented.
152         if (codeLength > 0) {
153             ERC223ReceivingContract(_to).tokenFallback(msg.sender, _value, _data);
154         }
155 
156         emit Transfer(msg.sender, _to, _value);
157         emit Transfer(msg.sender, _to, _value, _data);
158         return true;
159     }
160 
161     /*
162     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163     * @param _spender The address which will spend the funds.
164     * @param _value The amount of tokens to be spent.
165     */
166     function approve(address _spender, uint256 _value) public returns (bool) {
167         // To change the approve amount you first have to reduce the addresses`
168         //  allowance to zero by calling `approve(_spender, 0)` if it is not
169         //  already 0 to mitigate the race condition described here:
170         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
172 
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /*
179     * @dev Transfer tokens from one address to another
180     * @param _from address The address which you want to send tokens from
181     * @param _to address The address which you want to transfer to
182     * @param _value uint256 the amount of tokens to be transferred
183     */
184     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
185         uint256 _allowance = allowed[_from][msg.sender];
186 
187         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
188         // require (_value <= _allowance);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = _allowance.sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     /*
198     * @dev Gets the balance of the specified address.
199     * @param _owner The address to query the the balance of.
200     * @return An uint256 representing the amount owned by the passed address.
201     */
202     function balanceOf(address _owner) public view returns (uint256 balance) {
203         return balances[_owner];
204     }
205 
206     /*
207     * @dev Function to check the amount of tokens that an owner allowed to a spender.
208     * @param _owner address The address which owns the funds.
209     * @param _spender address The address which will spend the funds.
210     * @return A uint256 specifying the amount of tokens still available for the spender.
211     */
212     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 }
216 
217 
218 
219 contract MintableToken is StandardToken, Ownable {
220     // Events
221     event Mint(uint256 supply, address indexed to, uint256 amount);
222 
223     function tokenTotalSupply() public pure returns (uint256);
224 
225     /// @dev Allows the owner to mint new tokens
226     /// @param _to Address to mint the tokens to
227     /// @param _amount Amount of tokens that will be minted
228     /// @return Boolean to signify successful minting
229     function mint(address _to, uint256 _amount) external onlyOwner returns (bool) {
230         require(totalSupply.add(_amount) <= tokenTotalSupply());
231 
232         totalSupply = totalSupply.add(_amount);
233         balances[_to] = balances[_to].add(_amount);
234 
235         emit Mint(totalSupply, _to, _amount);
236         emit Transfer(address(0), _to, _amount);
237 
238         return true;
239     }
240 }
241 
242 
243 contract BodhiEthereum is MintableToken {
244     // Token configurations
245     string public constant name = "Bodhi Ethereum";
246     string public constant symbol = "BOE";
247     uint256 public constant decimals = 8;
248 
249     constructor() Ownable(msg.sender) public {
250     }
251 
252     // 100 million BOE ever created
253     function tokenTotalSupply() public pure returns (uint256) {
254         return 100 * (10**6) * (10**decimals);
255     }
256 }