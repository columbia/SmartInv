1 library SafeMath
2 {
3     uint256 constant public MAX_UINT256 =
4     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
5 
6     function GET_MAX_UINT256() pure internal returns(uint256){
7         return MAX_UINT256;
8     }
9 
10     function mul(uint a, uint b) internal returns(uint){
11         uint c = a * b;
12         assertSafe(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint a, uint b) pure internal returns(uint){
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint a, uint b) internal returns(uint){
24         assertSafe(b <= a);
25         return a - b;
26     }
27 
28     function add(uint a, uint b) internal returns(uint){
29         uint c = a + b;
30         assertSafe(c >= a);
31         return c;
32     }
33 
34     function max64(uint64 a, uint64 b) internal view returns(uint64){
35         return a >= b ? a : b;
36     }
37 
38     function min64(uint64 a, uint64 b) internal view returns(uint64){
39         return a < b ? a : b;
40     }
41 
42     function max256(uint256 a, uint256 b) internal view returns(uint256){
43         return a >= b ? a : b;
44     }
45 
46     function min256(uint256 a, uint256 b) internal view returns(uint256){
47         return a < b ? a : b;
48     }
49 
50     function assertSafe(bool assertion) internal {
51         if (!assertion) {
52             revert();
53         }
54     }
55 }
56 
57 
58 contract ERC223Interface {
59       
60     function balanceOf(address _who) view public returns (uint);
61     function transfer(address _to, uint _value) public returns (bool success);
62     function transfer(address _to, uint _value, bytes _data) public returns (bool success);
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
64     function approve(address _spender, uint256 _value) public returns (bool success);
65     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
66     function totalSupply() public view returns (uint256 supply);
67 
68     event Transfer(address indexed _from, address indexed _to, uint _value);
69     event Transfer(address indexed _from, address indexed _to, uint _value, bytes _data);
70     event Approval(address indexed _from, address indexed _spender, uint256 _value);
71     
72 }
73 
74 contract ERC223Token is ERC223Interface {
75     using SafeMath for uint;
76 
77     mapping(address => uint) balances; // List of user balances.
78     mapping (address => mapping (address => uint256)) private allowances;
79     
80     uint256 public supply;
81     
82     function ERC223Token(uint256 _totalSupply) public
83     {
84         supply = _totalSupply;
85     }       
86 
87     /**
88      * @dev Transfer the specified amount of tokens to the specified address.
89      *      Invokes the `tokenFallback` function if the recipient is a contract.
90      *      The token transfer fails if the recipient is a contract
91      *      but does not implement the `tokenFallback` function
92      *      or the fallback function to receive funds.
93      *
94      * @param _to    Receiver address.
95      * @param _value Amount of tokens that will be transferred.
96      * @param _data  Transaction metadata.
97      */
98     function transfer(address _to, uint _value, bytes _data) public returns (bool success){
99         // Standard function transfer similar to ERC20 transfer with no _data .
100         // Added due to backwards compatibility reasons .
101         uint codeLength;
102 
103         assembly {
104             // Retrieve the size of the code on target address, this needs assembly .
105             codeLength := extcodesize(_to)
106         }
107 
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         if(codeLength>0) {
111             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
112             receiver.tokenFallback(msg.sender, _value, _data);
113         }
114 
115         emit Transfer(msg.sender, _to, _value, _data);
116         emit Transfer (msg.sender, _to, _value);
117 
118         return true;
119     }
120     
121     /**
122      * @dev Transfer the specified amount of tokens to the specified address.
123      *      This function works the same with the previous one
124      *      but doesn't contain `_data` param.
125      *      Added due to backwards compatibility reasons.
126      *
127      * @param _to    Receiver address.
128      * @param _value Amount of tokens that will be transferred.
129      */
130     function transfer(address _to, uint _value) public returns (bool success){
131         uint codeLength;
132         bytes memory empty;
133 
134         assembly {
135             // Retrieve the size of the code on target address, this needs assembly .
136             codeLength := extcodesize(_to)
137         }
138 
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         
142         if(codeLength>0) {
143             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
144             receiver.tokenFallback(msg.sender, _value, empty);
145         }
146 
147         emit Transfer(msg.sender, _to, _value, empty);
148         emit Transfer (msg.sender, _to, _value);
149 
150         return true;
151     }
152 
153     
154     /**
155      * @dev Returns balance of the `_owner`.
156      *
157      * @param _owner   The address whose balance will be returned.
158      * @return balance Balance of the `_owner`.
159      */
160     function balanceOf(address _owner) view public returns (uint balance) {
161         return balances[_owner];
162     }
163 
164     /*
165     ERC 20 compatible functions
166     */
167 
168     function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
169         if (allowances [_from][msg.sender] < _value) return false;
170         if (balances [_from] < _value) return false;
171 
172         allowances [_from][msg.sender] = allowances [_from][msg.sender].sub(_value);
173 
174         if (_value > 0 && _from != _to) {
175             balances [_from] = balances [_from].sub(_value);
176             balances [_to] = balances [_to].add(_value);
177             emit Transfer (_from, _to, _value);
178         }
179 
180         return true;
181     }
182 
183     function approve (address _spender, uint256 _value) public returns (bool success) {
184         allowances [msg.sender][_spender] = _value;
185         emit Approval (msg.sender, _spender, _value);
186 
187         return true;
188     }
189 
190     function allowance (address _owner, address _spender) view public returns (uint256 remaining) {
191         return allowances [_owner][_spender];
192     }
193 }
194 
195 contract ERC223ReceivingContract { 
196 /**
197  * @dev Standard ERC223 function that will handle incoming token transfers.
198  *
199  * @param _from  Token sender address.
200  * @param _value Amount of tokens.
201  * @param _data  Transaction metadata.
202  */
203     function tokenFallback(address _from, uint _value, bytes _data) public;
204 }
205 
206 contract LykkeTokenErc223Base is ERC223Token {
207 
208     address internal _issuer;
209     string public standard;
210     string public name;
211     string public symbol;
212     uint8 public decimals;
213 
214     function LykkeTokenErc223Base(
215         address issuer,
216         string tokenName,
217         uint8 divisibility,
218         string tokenSymbol, 
219         string version,
220         uint256 totalSupply) ERC223Token(totalSupply) public{
221         symbol = tokenSymbol;
222         standard = version;
223         name = tokenName;
224         decimals = divisibility;
225         _issuer = issuer;
226     }
227 }
228 
229 contract EmissiveErc223Token is LykkeTokenErc223Base {
230     using SafeMath for uint;
231     
232     function EmissiveErc223Token(
233         address issuer,
234         string tokenName,
235         uint8 divisibility,
236         string tokenSymbol, 
237         string version) LykkeTokenErc223Base(issuer, tokenName, divisibility, tokenSymbol, version, 0) public{
238         balances [_issuer] = SafeMath.GET_MAX_UINT256();
239     }
240 
241     function totalSupply () view public returns (uint256 supply) {
242         return SafeMath.GET_MAX_UINT256().sub(balances [_issuer]);
243     }
244 
245     function balanceOf (address _owner) view public returns (uint256 balance) {
246         return _owner == _issuer ? 0 : ERC223Token.balanceOf (_owner);
247     }
248 }
249 
250 contract LyCI is EmissiveErc223Token {
251     using SafeMath for uint;
252     string public termsAndConditionsUrl;
253     address public owner;
254 
255     function LyCI(
256         address issuer,
257         string tokenName,
258         uint8 divisibility,
259         string tokenSymbol, 
260         string version) EmissiveErc223Token(issuer, tokenName, divisibility, tokenSymbol, version) public{
261         owner = msg.sender;
262     }
263 
264     function getTermsAndConditions () public view returns (string tc) {
265         return termsAndConditionsUrl;
266     }
267 
268     function setTermsAndConditions (string _newTc) public {
269         if (msg.sender != owner){
270             revert("Only owner is allowed to change T & C");
271         }
272         termsAndConditionsUrl = _newTc;
273     }
274 }