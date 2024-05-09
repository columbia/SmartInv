1 // File: contracts/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value, string calldata document) external returns (bool);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address who) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18 }
19 
20 // File: contracts/SafeMath.sol
21 
22 pragma solidity ^0.5.0;
23 
24 /**
25  * @title SafeMath
26  * @dev Unsigned math operations with safety checks that revert on error.
27  */
28 library SafeMath {
29     /**
30      * @dev Multiplies two unsigned integers, reverts on overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0, "SafeMath: division by zero");
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a, "SafeMath: subtraction overflow");
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Adds two unsigned integers, reverts on overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
80      * reverts when dividing by zero.
81      */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0, "SafeMath: modulo by zero");
84         return a % b;
85     }
86 }
87 
88 // File: contracts/ERC20.sol
89 
90 pragma solidity ^0.5.0;
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * https://eips.ethereum.org/EIPS/eip-20
99  * Originally based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  *
102  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
103  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
104  * compliant implementations may not do it.
105  */
106 contract ERC20 is IERC20 {
107     using SafeMath for uint256;
108 
109     address public _minter;
110 
111     mapping (address => uint256) private _balances;
112 
113     uint256 private _totalSupply;
114 
115     /**
116      * @dev Total number of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256) {
119         return _totalSupply;
120     }
121 
122     /**
123      * @dev Gets the balance of the specified address.
124      * @param owner The address to query the balance of.
125      * @return A uint256 representing the amount owned by the passed address.
126      */
127     function balanceOf(address owner) external view returns (uint256) {
128         return _balances[owner];
129     }
130 
131     /**
132      * @dev Transfer token to a specified address.
133      * @param to The address to transfer to.
134      * @param value The amount to be transferred.
135      * @param document The legal document pertaining to this token.
136      */
137     function transfer(address to, uint256 value, string calldata document) external returns (bool) {
138         _transfer(msg.sender, to, value);
139         return true;
140     }
141 
142     /**
143      * @dev Transfer token for a specified addresses.
144      * @param from The address to transfer from.
145      * @param to The address to transfer to.
146      * @param value The amount to be transferred.
147      */
148     function _transfer(address from, address to, uint256 value) internal {
149         require(from != address(0), "ERC20: transfer from the zero address");
150         require(to != address(0), "ERC20: transfer to the zero address");
151         require(value <= _balances[from], "Insufficient balance.");
152 
153         _balances[from] = _balances[from].sub(value);
154         _balances[to] = _balances[to].add(value);
155         emit Transfer(from, to, value);
156     }
157 
158     /**
159      * @dev Internal function that mints an amount of the token and assigns it to
160      * an account. This encapsulates the modification of balances such that the
161      * proper events are emitted.
162      * @param account The account that will receive the created tokens.
163      * @param value The amount that will be created.
164      */
165     function _mint(address account, uint256 value) internal {
166         require(account != address(0), "ERC20: mint to the zero address");
167         require(msg.sender == _minter);
168         require(value < 1e60);
169 
170         _totalSupply = _totalSupply.add(value);
171         _balances[account] = _balances[account].add(value);
172         emit Transfer(address(0), account, value);
173     }
174 }
175 
176 // File: contracts/ERC20Detailed.sol
177 
178 pragma solidity ^0.5.0;
179 
180 
181 /**
182  * @title ERC20Detailed token
183  * @dev The decimals are only for visualization purposes.
184  * All the operations are done using the smallest and indivisible token unit,
185  * just as on Ethereum all the operations are done in wei.
186  */
187 contract ERC20Detailed is IERC20 {
188     string private _name;
189     string private _symbol;
190     uint8 private _decimals;
191 
192     constructor (string memory name, string memory symbol, uint8 decimals) public {
193         _name = name;
194         _symbol = symbol;
195         _decimals = decimals;
196     }
197 
198     /**
199      * @return the name of the token.
200      */
201     function name() public view returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @return the symbol of the token.
207      */
208     function symbol() public view returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @return the number of decimals of the token.
214      */
215     function decimals() public view returns (uint8) {
216         return _decimals;
217     }
218 }
219 
220 // File: contracts/PB0.sol
221 
222 pragma solidity ^0.5.0;
223 
224 
225 
226 /**
227  * @title PB0
228  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
229  * Note they can later distribute these tokens as they wish using `transfer` and other
230  * `ERC20` functions.
231  */
232 
233 //군인은 현역을 면한 후가 아니면 국무총리로 임명될 수 없다. 대통령은 조약을 체결·비준하고, 외교사절을 신임·접수 또는 파견하며, 선전포고와 강화를 한다.
234 //
235 //위원은 정당에 가입하거나 정치에 관여할 수 없다. 국가는 평생교육을 진흥하여야 한다. 감사위원은 원장의 제청으로 대통령이 임명하고, 그 임기는 4년으로 하며, 1차에 한하여 중임할 수 있다.
236 //
237 //국채를 모집하거나 예산외에 국가의 부담이 될 계약을 체결하려 할 때에는 정부는 미리 국회의 의결을 얻어야 한다. 농업생산성의 제고와 농지의 합리적인 이용을 위하거나 불가피한 사정으로 발생하는 농지의 임대차와 위탁경영은 법률이 정하는 바에 의하여 인정된다.
238 //
239 //대법원장의 임기는 6년으로 하며, 중임할 수 없다. 피고인의 자백이 고문·폭행·협박·구속의 부당한 장기화 또는 기망 기타의 방법에 의하여 자의로 진술된 것이 아니라고 인정될 때 또는 정식재판에 있어서 피고인의 자백이 그에게 불리한 유일한 증거일 때에는 이를 유죄의 증거로 삼거나 이를 이유로 처벌할 수 없다.
240 //
241 //공공필요에 의한 재산권의 수용·사용 또는 제한 및 그에 대한 보상은 법률로써 하되, 정당한 보상을 지급하여야 한다. 지방자치단체는 주민의 복리에 관한 사무를 처리하고 재산을 관리하며, 법령의 범위안에서 자치에 관한 규정을 제정할 수 있다.
242 //
243 //새로운 회계연도가 개시될 때까지 예산안이 의결되지 못한 때에는 정부는 국회에서 예산안이 의결될 때까지 다음의 목적을 위한 경비는 전년도 예산에 준하여 집행할 수 있다.
244 //
245 //국회의원과 정부는 법률안을 제출할 수 있다. 모든 국민은 근로의 권리를 가진다. 국가는 사회적·경제적 방법으로 근로자의 고용의 증진과 적정임금의 보장에 노력하여야 하며, 법률이 정하는 바에 의하여 최저임금제를 시행하여야 한다.
246 //
247 //군인은 현역을 면한 후가 아니면 국무위원으로 임명될 수 없다. 대통령은 국회에 출석하여 발언하거나 서한으로 의견을 표시할 수 있다. 대통령은 전시·사변 또는 이에 준하는 국가비상사태에 있어서 병력으로써 군사상의 필요에 응하거나 공공의 안녕질서를 유지할 필요가 있을 때에는 법률이 정하는 바에 의하여 계엄을 선포할 수 있다.
248 //
249 //근로자는 근로조건의 향상을 위하여 자주적인 단결권·단체교섭권 및 단체행동권을 가진다. 국무총리는 국회의 동의를 얻어 대통령이 임명한다. 이 헌법에 의한 최초의 대통령의 임기는 이 헌법시행일로부터 개시한다.
250 //
251 //모든 국민은 신체의 자유를 가진다. 누구든지 법률에 의하지 아니하고는 체포·구속·압수·수색 또는 심문을 받지 아니하며, 법률과 적법한 절차에 의하지 아니하고는 처벌·보안처분 또는 강제노역을 받지 아니한다.
252 //
253 //국군의 조직과 편성은 법률로 정한다. 대통령은 내우·외환·천재·지변 또는 중대한 재정·경제상의 위기에 있어서 국가의 안전보장 또는 공공의 안녕질서를 유지하기 위하여 긴급한 조치가 필요하고 국회의 집회를 기다릴 여유가 없을 때에 한하여 최소한으로 필요한 재정·경제상의 처분을 하거나 이에 관하여 법률의 효력을 가지는 명령을 발할 수 있다.
254 //
255 //모든 국민은 그 보호하는 자녀에게 적어도 초등교육과 법률이 정하는 교육을 받게 할 의무를 진다. 감사원은 세입·세출의 결산을 매년 검사하여 대통령과 차년도국회에 그 결과를 보고하여야 한다.
256 //
257 //국가는 지역간의 균형있는 발전을 위하여 지역경제를 육성할 의무를 진다. 국가안전보장에 관련되는 대외정책·군사정책과 국내정책의 수립에 관하여 국무회의의 심의에 앞서 대통령의 자문에 응하기 위하여 국가안전보장회의를 둔다.
258 //
259 //국회의원은 국가이익을 우선하여 양심에 따라 직무를 행한다. 국무총리는 국무위원의 해임을 대통령에게 건의할 수 있다. 대통령후보자가 1인일 때에는 그 득표수가 선거권자 총수의 3분의 1 이상이 아니면 대통령으로 당선될 수 없다.
260 //
261 //국교는 인정되지 아니하며, 종교와 정치는 분리된다. 모든 국민은 법률이 정하는 바에 의하여 국가기관에 문서로 청원할 권리를 가진다. 대법관의 임기는 6년으로 하며, 법률이 정하는 바에 의하여 연임할 수 있다.
262 //
263 //대통령이 제1항의 기간내에 공포나 재의의 요구를 하지 아니한 때에도 그 법률안은 법률로서 확정된다. 형사피해자는 법률이 정하는 바에 의하여 당해 사건의 재판절차에서 진술할 수 있다.
264 //
265 //대통령은 법률이 정하는 바에 의하여 훈장 기타의 영전을 수여한다. 대통령은 국가의 원수이며, 외국에 대하여 국가를 대표한다. 대한민국은 국제평화의 유지에 노력하고 침략적 전쟁을 부인한다.
266 //
267 //예비비는 총액으로 국회의 의결을 얻어야 한다. 예비비의 지출은 차기국회의 승인을 얻어야 한다. 명령·규칙 또는 처분이 헌법이나 법률에 위반되는 여부가 재판의 전제가 된 경우에는 대법원은 이를 최종적으로 심사할 권한을 가진다.
268 //
269 //공개하지 아니한 회의내용의 공표에 관하여는 법률이 정하는 바에 의한다. 대통령이 임시회의 집회를 요구할 때에는 기간과 집회요구의 이유를 명시하여야 한다.
270 //
271 //제2항과 제3항의 처분에 대하여는 법원에 제소할 수 없다. 법관은 헌법과 법률에 의하여 그 양심에 따라 독립하여 심판한다. 언론·출판에 대한 허가나 검열과 집회·결사에 대한 허가는 인정되지 아니한다.
272 
273 contract PB0 is ERC20, ERC20Detailed {
274     uint8 public constant DECIMALS = 18;
275     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(DECIMALS));
276     string public legalDocument;
277 
278     /**
279      * @dev Constructor that gives msg.sender all of existing tokens.
280      */
281     constructor (string memory document) public ERC20Detailed("PB0", "PB0", DECIMALS) {
282         legalDocument = document;
283         _minter = msg.sender;
284         _mint(msg.sender, INITIAL_SUPPLY);
285     }
286 }