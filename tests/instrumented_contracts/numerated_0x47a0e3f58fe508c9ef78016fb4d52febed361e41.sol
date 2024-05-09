1 pragma solidity ^0.4.17;
2 
3 library SafeMathMod { // Partial SafeMath Library
4 
5     function mul(uint256 a, uint256 b) constant internal returns(uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) constant internal returns(uint256) {
12         assert(b != 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns(uint256 c) {
19         require((c = a - b) < a);
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
23         require((c = a + b) > a);
24     }
25 }
26 
27 contract Usdcoins { //is inherently ERC20
28     using SafeMathMod
29     for uint256;
30 
31     /**
32      * @constant name The name of the token
33      * @constant symbol  The symbol used to display the currency
34      * @constant decimals  The number of decimals used to dispay a balance
35      * @constant totalSupply The total number of tokens times 10^ of the number of decimals
36      * @constant MAX_UINT256 Magic number for unlimited allowance
37      * @storage balanceOf Holds the balances of all token holders
38      * @storage allowed Holds the allowable balance to be transferable by another address.
39      */
40 
41     address owner;
42 
43 
44 
45     string constant public name = "USDC";
46 
47     string constant public symbol = "USDC";
48 
49     uint256 constant public decimals = 18;
50 
51     uint256 constant public totalSupply = 100000000e18;
52 
53     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
54 
55     mapping(address => uint256) public balanceOf;
56 
57     mapping(address => mapping(address => uint256)) public allowed;
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 
61     event TransferFrom(address indexed _spender, address indexed _from, address indexed _to, uint256 _value);
62 
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65     function() payable {
66         revert();
67     }
68 
69     function Usdcoins() public {
70         balanceOf[msg.sender] = totalSupply;
71         owner = msg.sender;
72     }
73 
74 
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81 
82 
83 
84     /**
85      * @dev function that sells available tokens
86      */
87 
88 
89     function transfer(address _to, uint256 _value) public returns(bool success) {
90         /* Ensures that tokens are not sent to address "0x0" */
91         require(_to != address(0));
92         /* Prevents sending tokens directly to contracts. */
93 
94 
95         /* SafeMathMOd.sub will throw if there is not enough balance and if the transfer value is 0. */
96         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
97         balanceOf[_to] = balanceOf[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     /**
103      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
104      *
105      * @param _from The address of the sender
106      * @param _to The address of the recipient
107      * @param _value The amount of token to be transferred
108      * @return Whether the transfer was successful or not
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
111         /* Ensures that tokens are not sent to address "0x0" */
112         require(_to != address(0));
113         /* Ensures tokens are not sent to this contract */
114 
115 
116         uint256 allowance = allowed[_from][msg.sender];
117         /* Ensures sender has enough available allowance OR sender is balance holder allowing single transsaction send to contracts*/
118         require(_value <= allowance || _from == msg.sender);
119 
120         /* Use SafeMathMod to add and subtract from the _to and _from addresses respectively. Prevents under/overflow and 0 transfers */
121         balanceOf[_to] = balanceOf[_to].add(_value);
122         balanceOf[_from] = balanceOf[_from].sub(_value);
123 
124         /* Only reduce allowance if not MAX_UINT256 in order to save gas on unlimited allowance */
125         /* Balance holder does not need allowance to send from self. */
126         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
127             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         }
129         Transfer(_from, _to, _value);
130         return true;
131     }
132 
133     /**
134      * @dev Transfer the specified amounts of tokens to the specified addresses.
135      * @dev Be aware that there is no check for duplicate recipients.
136      *
137      * @param _toAddresses Receiver addresses.
138      * @param _amounts Amounts of tokens that will be transferred.
139      */
140     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
141         /* Ensures _toAddresses array is less than or equal to 255 */
142         require(_toAddresses.length <= 255);
143         /* Ensures _toAddress and _amounts have the same number of entries. */
144         require(_toAddresses.length == _amounts.length);
145 
146         for (uint8 i = 0; i < _toAddresses.length; i++) {
147             transfer(_toAddresses[i], _amounts[i]);
148         }
149     }
150 
151     /**
152      * @dev Transfer the specified amounts of tokens to the specified addresses from authorized balance of sender.
153      * @dev Be aware that there is no check for duplicate recipients.
154      *
155      * @param _from The address of the sender
156      * @param _toAddresses The addresses of the recipients (MAX 255)
157      * @param _amounts The amounts of tokens to be transferred
158      */
159     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
160         /* Ensures _toAddresses array is less than or equal to 255 */
161         require(_toAddresses.length <= 255);
162         /* Ensures _toAddress and _amounts have the same number of entries. */
163         require(_toAddresses.length == _amounts.length);
164 
165         for (uint8 i = 0; i < _toAddresses.length; i++) {
166             transferFrom(_from, _toAddresses[i], _amounts[i]);
167         }
168     }
169 
170     /**
171      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
172      *
173      * @param _spender The address of the account able to transfer the tokens
174      * @param _value The amount of tokens to be approved for transfer
175      * @return Whether the approval was successful or not
176      */
177     function approve(address _spender, uint256 _value) public returns(bool success) {
178         /* Ensures address "0x0" is not assigned allowance. */
179         require(_spender != address(0));
180 
181         allowed[msg.sender][_spender] = _value;
182         Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187      * @param _owner The address of the account owning tokens
188      * @param _spender The address of the account able to transfer the tokens
189      * @return Amount of remaining tokens allowed to spent
190      */
191     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
192         remaining = allowed[_owner][_spender];
193     }
194 
195     function isNotContract(address _addr) private view returns(bool) {
196         uint length;
197         assembly {
198             /* retrieve the size of the code on target address, this needs assembly */
199             length: = extcodesize(_addr)
200         }
201         return (length == 0);
202     }
203 
204 }
205 
206 contract icocontract { //is inherently ERC20
207     using SafeMathMod
208     for uint256;
209 
210     uint public raisedAmount = 0;
211     uint256 public RATE = 400;
212     bool public icostart = true;
213     address owner;
214 
215     Usdcoins public token;
216 
217     function icocontract() public {
218 
219         owner = msg.sender;
220 
221 
222     }
223 
224     modifier whenSaleIsActive() {
225         // Check if icostart is true
226         require(icostart == true);
227 
228         _;
229     }
230 
231     modifier onlyOwner() {
232         require(msg.sender == owner);
233         _;
234     }
235 
236     function setToken(Usdcoins _token) onlyOwner {
237 
238         token = _token;
239 
240     }
241 
242     function setRate(uint256 rate) onlyOwner {
243 
244         RATE = rate;
245 
246     }
247 
248 
249     function setIcostart(bool newicostart) onlyOwner {
250 
251         icostart = newicostart;
252     }
253 
254     function() external payable {
255         buyTokens();
256     }
257 
258     function buyTokens() payable whenSaleIsActive {
259 
260         // Calculate tokens to sell
261         uint256 weiAmount = msg.value;
262         uint256 tokens = weiAmount.mul(RATE);
263 
264 
265         // Increment raised amount
266         raisedAmount = raisedAmount.add(msg.value);
267 
268         token.transferFrom(owner, msg.sender, tokens);
269 
270 
271         // Send money to owner
272         owner.transfer(msg.value);
273     }
274 
275 
276 }