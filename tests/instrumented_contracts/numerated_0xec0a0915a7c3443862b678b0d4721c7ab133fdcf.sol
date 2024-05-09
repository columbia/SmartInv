1 pragma solidity ^0.7.0;
2 
3 interface IERC165 {
4     /**
5      * @dev Returns true if this contract implements the interface defined by
6      * `interfaceId`. See the corresponding
7      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
8      * to learn more about how these ids are created.
9      *
10      * This function call must use less than 30 000 gas.
11      */
12     function supportsInterface(bytes4 interfaceId) external view returns (bool);
13 }
14 
15 /**
16  * @dev Required interface of an ERC721 compliant contract.
17  */
18 interface IERC721 is IERC165 {
19     function balanceOf(address owner) external view returns (uint256 balance);
20     function ownerOf(uint256 tokenId) external view returns (address owner);
21     function safeTransferFrom(address from, address to, uint256 tokenId) external;
22     function transferFrom(address from, address to, uint256 tokenId) external;
23     function approve(address to, uint256 tokenId) external;
24     function getApproved(uint256 tokenId) external view returns (address operator);
25     function setApprovalForAll(address operator, bool _approved) external;
26     function isApprovedForAll(address owner, address operator) external view returns (bool);
27     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
28 }
29 
30 library SafeMath {
31 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
32 		uint256 c = a + b;
33 		require(c >= a, "SafeMath: addition overflow.");
34 		return c;
35 	}
36 
37 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38 		return sub(a, b, "SafeMath: subtraction overflow.");
39 	}
40 
41 	function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42 		require(b <= a, errorMessage);
43 		uint256 c = a - b;
44 		return c;
45 	}
46 
47 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48 		if (a == 0) {
49 			return 0;
50 		}
51 		uint256 c = a * b;
52 		require(c / a == b, "SafeMath: multiplication overflow.");
53 		return c;
54 	}
55 
56 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
57 		return div(a, b, "SafeMath: division by zero.");
58 	}
59 
60 	function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61 		// Solidity only automatically asserts when dividing by 0
62 		require(b > 0, errorMessage);
63 		uint256 c = a / b;
64 		return c;
65 	}
66 
67 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68 		return mod(a, b, "SafeMath: modulo by zero.");
69 	}
70 
71 	function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72 		require(b != 0, errorMessage);
73 		return a % b;
74 	}
75 }
76 
77 interface IERC20 {
78 	function totalSupply() external view returns (uint256);
79 	function balanceOf(address account) external view returns (uint256);
80 	function transfer(address recipient, uint256 amount) external returns (bool);
81 	function allowance(address owner, address spender) external view returns (uint256);
82 	function approve(address spender, uint256 amount) external returns (bool);
83 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 	event Transfer(address indexed from, address indexed to, uint256 value);
85 	event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 abstract contract ERC20 is IERC20 {
89 	using SafeMath for uint256;
90 
91 	string public name;
92 	string public symbol;
93 	uint8 public decimals;
94 
95 	uint256 public _totalSupply;
96 	mapping (address => uint256) public _balanceOf;
97 	mapping (address => mapping (address => uint256)) public _allowance;
98 
99 	constructor (string memory _name, string memory _symbol, uint8 _decimals) {
100 		name = _name;
101 		symbol = _symbol;
102 		decimals = _decimals;
103 	}
104 
105 	function totalSupply() public view override returns (uint256) {
106 		return _totalSupply;
107 	}
108 
109 	function balanceOf(address account) public view override returns (uint256) {
110 		return _balanceOf[account];
111 	}
112 
113 	function allowance(address owner, address spender) public view override returns (uint256) {
114 		return _allowance[owner][spender];
115 	}
116 
117 	function approve(address _spender, uint256 _value) public override returns (bool _success) {
118 		_allowance[msg.sender][_spender] = _value;
119 		emit Approval(msg.sender, _spender, _value);
120 		return true;
121 	}
122 
123 	function transfer(address _to, uint256 _value) public override returns (bool _success) {
124 		require(_to != address(0), "ERC20: Recipient address is null.");
125 		_balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
126 		_balanceOf[_to] = _balanceOf[_to].add(_value);
127 		emit Transfer(msg.sender, _to, _value);
128 		return true;
129 	}
130 
131 	function transferFrom(address _from, address _to, uint256 _value) public override returns (bool _success) {
132 		require(_to != address(0), "ERC20: Recipient address is null.");
133 		_balanceOf[_from] = _balanceOf[_from].sub(_value);
134 		_balanceOf[_to] = _balanceOf[_to].add(_value);
135 		_allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
136 		emit Transfer(_from, _to, _value);
137 		return true;
138 	}
139 
140 	function _mint(address _to, uint256 _amount) internal {
141 		_totalSupply = _totalSupply.add(_amount);
142 		_balanceOf[_to] = _balanceOf[_to].add(_amount);
143 		emit Transfer(address(0), _to, _amount);
144 	}
145 
146 	function _burn(address _from, uint256 _amount) internal {
147 		require(_from != address(0), "ERC20: Burning from address 0.");
148 		_balanceOf[_from] = _balanceOf[_from].sub(_amount, "ERC20: burn amount exceeds balance.");
149 		_totalSupply = _totalSupply.sub(_amount);
150 		emit Transfer(_from, address(0), _amount);
151 	}
152 }
153 
154 interface AxieCore is IERC721 {
155 	function getAxie(uint256 _axieId) external view returns (uint256 _genes, uint256 _bornAt);
156 }
157 
158 interface AxieExtraData {
159 	function getExtra(uint256 _axieId) external view returns (uint256, uint256, uint256, uint256 /* breed count */);
160 }
161 
162 contract Ownable {
163 	address public owner;
164 
165 	constructor () {
166 		owner = msg.sender;
167 	}
168 
169 	modifier onlyOwner() {
170 		require(msg.sender == owner, "Not owner");
171 		_;
172 	}
173 	
174 	function setOwnership(address _newOwner) external onlyOwner {
175 		owner = _newOwner;
176 	}
177 }
178 
179 contract Pausable is Ownable {
180 	bool public isPaused;
181 	
182 	constructor () {
183 		isPaused = false;
184 	}
185 	
186 	modifier notPaused() {
187 		require(!isPaused, "paused");
188 		_;
189 	}
190 	
191 	function pause() external onlyOwner {
192 		isPaused = true;
193 	}
194 	
195 	function unpause() external onlyOwner {
196 		isPaused = false;
197 	}
198 }
199 
200 contract WrappedOrigin is ERC20("Wrapped Origin Axie", "WOA", 18), Pausable {
201 	using SafeMath for uint256;
202 
203 	AxieCore public constant AXIE_CORE = AxieCore(0xF5b0A3eFB8e8E4c201e2A935F110eAaF3FFEcb8d);
204 	AxieExtraData public constant AXIE_EXTRA = AxieExtraData(0x10e304a53351B272dC415Ad049Ad06565eBDFE34);
205 
206 	uint256[] public axieIds;
207 
208 	event AxieWrapped(uint256 axieId);
209 	event AxieUnwrapped(uint256 axieId);
210 
211 	function isContract(address _addr) internal view returns (bool) {
212 		uint32 _size;
213 		assembly {
214 			_size:= extcodesize(_addr)
215 		}
216 		return (_size > 0);
217 	}
218 
219 	function _getSeed(uint256 _seed, address _sender) internal view returns (uint256) {
220 		if (_seed == 0)
221 			return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, _sender)));
222 		else
223 			return uint256(keccak256(abi.encodePacked(_seed)));
224 	}
225 
226 	// beast 0000 aqua 0100 plant 0011 bug 0001 bird 0010 reptile 0101
227 	function isValidCommonOrigin(uint256 _axieId) public view returns(bool) {
228 		(uint256 _genes,) = AXIE_CORE.getAxie(_axieId);
229 		uint256 _originGene = (_genes >> 238) & 1;
230 		if (_originGene != 1)
231 			return false;
232 		uint256 _classGenes = (_genes >> 252);
233 		if (!isCommonClass(_classGenes))
234 			return false;
235 		(,,,uint256 _breedCount) = AXIE_EXTRA.getExtra(_axieId);
236 		if (_breedCount > 2)
237 			return false;
238 		return !isMystic(_genes);
239 	}
240 
241 	function isCommonClass(uint256 _classGene) pure internal returns (bool) {
242 		if (_classGene == 0 || _classGene == 3 || _classGene == 4)
243 			return true;
244 		return false;
245 	}
246 
247 	function isMystic(uint256 _genes) pure internal returns (bool) {
248 		uint256 _part;
249 		uint256 _mysticSelector = 0xc0000000;
250 		for (uint256 i = 0; i < 6 ; i++) {
251 			_part = _genes & 0xffffffff;
252 			if (_part & _mysticSelector == _mysticSelector)
253 				return true;
254 			_genes = _genes >> 32;
255 		}
256 		return false;
257 	}
258 
259 	function wrap(uint256[] calldata _axieIdsToWrap) public notPaused {
260 		for (uint256 i = 0; i < _axieIdsToWrap.length; i++) {
261 			require(isValidCommonOrigin(_axieIdsToWrap[i]), "WrappedOrigin: Axie is not an Origin axie.");
262 			axieIds.push(_axieIdsToWrap[i]);
263 			AXIE_CORE.safeTransferFrom(msg.sender, address(this), _axieIdsToWrap[i]);
264 			emit AxieWrapped(_axieIdsToWrap[i]);
265 		}
266 		_mint(msg.sender, _axieIdsToWrap.length * (10**decimals));
267 	}
268 
269 	function unwrap(uint256 _amount) public notPaused{
270 		require(!isContract(msg.sender), "WrappedOrigin: Address must not be a contract.");
271 		unwrapFor(_amount, msg.sender);
272 	}
273 
274 	function unwrapFor(uint256 _amount, address _recipient) public notPaused {
275 		require(!isContract(_recipient), "WrappedOrigin: Recipient must not be a contract.");
276 		require(_recipient != address(0), "WrappedOrigin: Cannot send to void address.");
277 
278 		_burn(msg.sender, _amount * (10**decimals));
279 		uint256 _seed = 0;
280 		for (uint256 i = 0; i < _amount; i++) {
281 			_seed = _getSeed(_seed, msg.sender);
282 			uint256 _index = _seed % axieIds.length;
283 			uint256 _tokenId = axieIds[_index];
284 
285 			axieIds[_index] = axieIds[axieIds.length - 1];
286 			axieIds.pop();
287 			AXIE_CORE.safeTransferFrom(address(this), _recipient, _tokenId);
288 			emit AxieUnwrapped(_tokenId);
289 		}
290 	}
291 
292 	function onERC721Received(address _from, uint256 _tokenId, bytes calldata _data) external view returns (bytes4) {
293 		require(msg.sender == address(AXIE_CORE), "Not Axie NFT");
294 		return WrappedOrigin.onERC721Received.selector;
295 	}
296 }