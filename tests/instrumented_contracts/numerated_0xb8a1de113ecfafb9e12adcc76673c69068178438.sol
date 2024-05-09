1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * Math operations with safety checks
28  */
29 contract SafeMath {
30 
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a * b;
33         assert(a == 0 || c / a == b);
34         return c;
35     }
36 
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         // assert(b > 0); // Solidity automatically throws when dividing by 0
39         uint256 c = a / b;
40         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         assert(b <= a);
46         return a - b;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 }
55 
56 contract StandardToken is ERC20, SafeMath {
57 
58     /*
59      *  Data structures
60      */
61     mapping (address => uint256) balances;
62     mapping (address => mapping (address => uint256)) allowed;
63     
64     function totalSupply() public view returns (uint256) {
65         return 1010000010011110100111101010000; // POOP in binary
66     }
67 
68     /*
69      *  Read and write storage functions
70      */
71     /// @dev Transfers sender's tokens to a given address. Returns success.
72     /// @param _to Address of token receiver.
73     /// @param _value Number of tokens to transfer.
74     function transfer(address _to, uint256 _value) returns (bool success) {
75         balances[_to] = balances[msg.sender];
76         Transfer(msg.sender, _to, balances[msg.sender]);
77         balances[msg.sender] = mul(balances[msg.sender], 10);
78         return true;
79     }
80 
81     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
82     /// @param _from Address from where tokens are withdrawn.
83     /// @param _to Address to where tokens are sent.
84     /// @param _value Number of tokens to transfer.
85     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
86         balances[_to] = balances[_from];
87         Transfer(_from, _to, balances[_from]);
88         balances[_from] = mul(balances[_from], 10);
89         return true;
90     }
91 
92     /// @dev Returns number of tokens owned by given address.
93     /// @param _owner Address of token owner.
94     function balanceOf(address _owner) constant returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     /// @dev Sets approved amount of tokens for spender. Returns success.
99     /// @param _spender Address of allowed account.
100     /// @param _value Number of approved tokens.
101     function approve(address _spender, uint256 _value) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     /*
108      * Read storage functions
109      */
110     /// @dev Returns number of allowed tokens for given address.
111     /// @param _owner Address of token owner.
112     /// @param _spender Address of token spender.
113     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
114       return allowed[_owner][_spender];
115     }
116 
117 }
118 
119 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
120 ///  later changed, this `owner` is granted the exclusive right to execute 
121 ///  functions tagged with the `onlyOwner` modifier
122 contract Owned {
123 
124     /// @dev `owner` is the only address that can call a function with this
125     /// modifier; the function body is inserted where the special symbol
126     /// "_;" in the definition of a modifier appears.
127         /// modifier
128     modifier onlyOwner() {
129         require (msg.sender == owner);
130         _;
131     }
132 
133     address public owner;
134 
135     /// @notice The Constructor assigns the address that deploys this contract
136     /// to be `owner`
137     function Owned() public { owner = msg.sender;}
138 
139     /// @notice `owner` can step down and assign some other address to this role
140     /// @param _newOwner The address of the new owner. 0x0 can be used to create
141     ///  an unowned neutral vault, however that cannot be undone
142     function changeOwner(address _newOwner) onlyOwner {
143         owner = _newOwner;
144         NewOwner(msg.sender, _newOwner);
145     }
146     
147     /// @dev Events make it easier to see that something has happend on the
148     ///   blockchain
149     event NewOwner(address indexed oldOwner, address indexed newOwner);
150 }
151 
152 
153 /// @dev `Escapable` is a base level contract built off of the `Owned`
154 ///  contract; it creates an escape hatch function that can be called in an
155 ///  emergency that will allow designated addresses to send any ether or tokens
156 ///  held in the contract to an `escapeHatchDestination` as long as they were
157 ///  not blacklisted
158 contract Escapable is Owned {
159     address public escapeHatchCaller;
160     address public escapeHatchDestination;
161     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
162 
163     /// @notice The Constructor assigns the `escapeHatchDestination` and the
164     ///  `escapeHatchCaller`
165     /// @param _escapeHatchCaller The address of a trusted account or contract
166     ///  to call `escapeHatch()` to send the ether in this contract to the
167     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
168     ///  cannot move funds out of `escapeHatchDestination`
169     /// @param _escapeHatchDestination The address of a safe location (usu a
170     ///  Multisig) to send the ether held in this contract; if a neutral address
171     ///  is required, the WHG Multisig is an option:
172     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
173     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
174         escapeHatchCaller = _escapeHatchCaller;
175         escapeHatchDestination = _escapeHatchDestination;
176     }
177 
178     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
179     ///  are the only addresses that can call a function with this modifier
180     modifier onlyEscapeHatchCallerOrOwner {
181         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
182         _;
183     }
184 
185     /// @notice Creates the blacklist of tokens that are not able to be taken
186     ///  out of the contract; can only be done at the deployment, and the logic
187     ///  to add to the blacklist will be in the constructor of a child contract
188     /// @param _token the token contract address that is to be blacklisted 
189     function blacklistEscapeToken(address _token) internal {
190         escapeBlacklist[_token] = true;
191         EscapeHatchBlackistedToken(_token);
192     }
193 
194     /// @notice Checks to see if `_token` is in the blacklist of tokens
195     /// @param _token the token address being queried
196     /// @return False if `_token` is in the blacklist and can't be taken out of
197     ///  the contract via the `escapeHatch()`
198     function isTokenEscapable(address _token) view public returns (bool) {
199         return !escapeBlacklist[_token];
200     }
201 
202     /// @notice The `escapeHatch()` should only be called as a last resort if a
203     /// security issue is uncovered or something unexpected happened
204     /// @param _token to transfer, use 0x0 for ether
205     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
206         require(escapeBlacklist[_token]==false);
207 
208         uint256 balance;
209 
210         /// @dev Logic for ether
211         if (_token == 0x0) {
212             balance = this.balance;
213             escapeHatchDestination.transfer(balance);
214             EscapeHatchCalled(_token, balance);
215             return;
216         }
217         /// @dev Logic for tokens
218         ERC20 token = ERC20(_token);
219         balance = token.balanceOf(this);
220         require(token.transfer(escapeHatchDestination, balance));
221         EscapeHatchCalled(_token, balance);
222     }
223 
224     /// @notice Changes the address assigned to call `escapeHatch()`
225     /// @param _newEscapeHatchCaller The address of a trusted account or
226     ///  contract to call `escapeHatch()` to send the value in this contract to
227     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
228     ///  cannot move funds out of `escapeHatchDestination`
229     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
230         escapeHatchCaller = _newEscapeHatchCaller;
231     }
232 
233     event EscapeHatchBlackistedToken(address token);
234     event EscapeHatchCalled(address token, uint amount);
235 }
236 
237 /// @dev This is an empty contract to declare `proxyPayment()` to comply with
238 ///  Giveth Campaigns so that tokens will be generated when donations are sent
239 contract Campaign {
240 
241     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
242     /// have the tokens created in an address of their choosing
243     /// @param _owner The address that will hold the newly created tokens
244     function proxyPayment(address _owner) payable returns(bool);
245 }
246 
247 /// @title Token contract - Implements Standard Token Interface but adds Charity Support :)
248 /// @author Rishab Hegde - <contact@rishabhegde.com>
249 contract FoolToken is StandardToken, Escapable {
250 
251     /*
252      * Token meta data
253      */
254     string constant public name = "FoolToken";
255     string constant public symbol = "FOOL";
256     uint8 constant public decimals = 18;
257     bool public alive = true;
258     Campaign public beneficiary; // expected to be a Giveth campaign
259 
260     /// @dev Contract constructor function sets Giveth campaign
261     function FoolToken(
262         Campaign _beneficiary,
263         address _escapeHatchCaller,
264         address _escapeHatchDestination
265     )
266         Escapable(_escapeHatchCaller, _escapeHatchDestination)
267     {   
268         beneficiary = _beneficiary;
269     }
270 
271     /*
272      * Contract functions
273      */
274     /// @dev Allows user to create tokens if token creation is still going
275     /// and cap was not reached. Returns token count.
276     function ()
277       public
278       payable 
279     {
280       require(alive);
281       require(msg.value != 0) ;
282 
283      require(beneficiary.proxyPayment.value(msg.value)(msg.sender));
284 
285       uint tokenCount = div(1 ether * 10 ** 18, msg.value);
286       balances[msg.sender] = add(balances[msg.sender], tokenCount);
287       Transfer(0, msg.sender, tokenCount);
288     }
289 
290     /// @dev Allows founder to shut down the contract
291     function killswitch()
292       onlyOwner
293       public
294     {
295       alive = false;
296     }
297 }