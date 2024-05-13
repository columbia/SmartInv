1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.9;
3 
4 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { Context } from "@openzeppelin/contracts/utils/Context.sol";
6 import { Address } from "@openzeppelin/contracts/utils/Address.sol";
7 import "./interfaces/IUpgradeAgent.sol";
8 
9 contract MystToken is Context, IERC20, IUpgradeAgent {
10     using Address for address;
11 
12     address immutable _originalToken;                        // Address of MYSTv1 token
13     uint256 immutable _originalSupply;                       // Token supply of MYSTv1 token
14 
15     // The original MYST token and the new MYST token have a decimal difference of 10.
16     // As such, minted values as well as the total supply comparisons need to offset all values
17     // by 10 zeros to properly compare them.
18     uint256 constant private DECIMAL_OFFSET = 1e10;
19 
20     bool constant public override isUpgradeAgent = true;     // Upgradeability interface marker
21     address private _upgradeMaster;                          // He can enable future token migration
22     IUpgradeAgent private _upgradeAgent;                     // The next contract where the tokens will be migrated
23     uint256 private _totalUpgraded;                          // How many tokens we have upgraded by now
24 
25     mapping(address => uint256) private _balances;
26     uint256 private _totalSupply;
27 
28     string constant public name = "Mysterium";
29     string constant public symbol = "MYST";
30     uint8 constant public decimals = 18;
31 
32     // EIP712
33     bytes32 public DOMAIN_SEPARATOR;
34 
35     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
36     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
37 
38     // The nonces mapping is given for replay protection in permit function.
39     mapping(address => uint) public nonces;
40 
41     // ERC20-allowances
42     mapping (address => mapping (address => uint256)) private _allowances;
43 
44     event Minted(address indexed to, uint256 amount);
45     event Burned(address indexed from, uint256 amount);
46 
47     // State of token upgrade
48     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading, Completed}
49 
50     // Token upgrade events
51     event Upgrade(address indexed from, address agent, uint256 _value);
52     event UpgradeAgentSet(address agent);
53     event UpgradeMasterSet(address master);
54 
55     constructor(address tokenAddress) {
56         // upgradability settings
57         _originalToken  = tokenAddress;
58         _originalSupply = IERC20(tokenAddress).totalSupply();
59 
60         // set upgrade master
61         _upgradeMaster = _msgSender();
62 
63         // construct EIP712 domain separator
64         DOMAIN_SEPARATOR = keccak256(
65             abi.encode(
66                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
67                 keccak256(bytes(name)),
68                 keccak256(bytes('1')),
69                 _chainID(),
70                 address(this)
71             )
72         );
73     }
74 
75     function totalSupply() public view override(IERC20) returns (uint256) {
76         return _totalSupply;
77     }
78 
79     function balanceOf(address tokenHolder) public view override(IERC20) returns (uint256) {
80         return _balances[tokenHolder];
81     }
82 
83     function transfer(address recipient, uint256 amount) public override returns (bool) {
84         _move(_msgSender(), recipient, amount);
85         return true;
86     }
87 
88     function burn(uint256 amount) public {
89         _burn(_msgSender(), amount);
90     }
91 
92     function allowance(address holder, address spender) public view override returns (uint256) {
93         return _allowances[holder][spender];
94     }
95 
96     function approve(address spender, uint256 value) public override returns (bool) {
97         _approve(_msgSender(), spender, value);
98         return true;
99     }
100 
101     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
103         return true;
104     }
105 
106     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
108         return true;
109     }
110 
111     /**
112      * ERC2612 `permit`: 712-signed token approvals
113      */
114     function permit(address holder, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
115         require(deadline >= block.timestamp, 'MYST: Permit expired');
116         bytes32 digest = keccak256(
117             abi.encodePacked(
118                 '\x19\x01',
119                 DOMAIN_SEPARATOR,
120                 keccak256(abi.encode(PERMIT_TYPEHASH, holder, spender, value, nonces[holder]++, deadline))
121             )
122         );
123         address recoveredAddress = ecrecover(digest, v, r, s);
124         require(recoveredAddress != address(0) && recoveredAddress == holder, 'MYST: invalid signature');
125         _approve(holder, spender, value);
126     }
127 
128     /**
129     * Note that we're not decreasing allowance of uint(-1). This makes it simple to ERC777 operator.
130     */
131     function transferFrom(address holder, address recipient, uint256 amount) public override returns (bool) {
132         // require(recipient != address(0), "MYST: transfer to the zero address");
133         require(holder != address(0), "MYST: transfer from the zero address");
134         address spender = _msgSender();
135 
136         // Allowance for uint256(-1) means "always allowed" and is analog for erc777 operators but in erc20 semantics.
137         if (holder != spender && _allowances[holder][spender] != type(uint256).max) {
138             _approve(holder, spender, _allowances[holder][spender] - amount);
139         }
140 
141         _move(holder, recipient, amount);
142         return true;
143     }
144 
145     /**
146      * Creates `amount` tokens and assigns them to `holder`, increasing
147      * the total supply.
148      */
149     function _mint(address holder, uint256 amount) internal {
150         require(holder != address(0), "MYST: mint to the zero address");
151 
152         // Update state variables
153         _totalSupply = _totalSupply + amount;
154         _balances[holder] = _balances[holder] + amount;
155 
156         emit Minted(holder, amount);
157         emit Transfer(address(0), holder, amount);
158     }
159 
160     function _burn(address from, uint256 amount) internal {
161         require(from != address(0), "MYST: burn from the zero address");
162 
163         // Update state variables
164         _balances[from] = _balances[from] - amount;
165         _totalSupply = _totalSupply - amount;
166 
167         emit Transfer(from, address(0), amount);
168         emit Burned(from, amount);
169     }
170 
171     function _move(address from, address to, uint256 amount) private {
172         // Sending to zero address is equal burning
173         if (to == address(0)) {
174             _burn(from, amount);
175             return;
176         }
177 
178         _balances[from] = _balances[from] - amount;
179         _balances[to] = _balances[to] + amount;
180 
181         emit Transfer(from, to, amount);
182     }
183 
184     function _approve(address holder, address spender, uint256 value) internal {
185         require(holder != address(0), "MYST: approve from the zero address");
186         require(spender != address(0), "MYST: approve to the zero address");
187 
188         _allowances[holder][spender] = value;
189         emit Approval(holder, spender, value);
190     }
191 
192     // -------------- UPGRADE FROM v1 TOKEN --------------
193 
194     function originalToken() public view override returns (address) {
195         return _originalToken;
196     }
197 
198     function originalSupply() public view override returns (uint256) {
199         return _originalSupply;
200     }
201 
202     function upgradeFrom(address _account, uint256 _value) public override {
203         require(msg.sender == originalToken(), "only original token can call upgradeFrom");
204 
205         // Value is multiplied by 0e10 as old token had decimals = 8?
206         _mint(_account, _value * DECIMAL_OFFSET);
207 
208         require(totalSupply() <= originalSupply() * DECIMAL_OFFSET, "can not mint more tokens than in original contract");
209     }
210 
211 
212     // -------------- PREPARE FOR FUTURE UPGRADABILITY --------------
213 
214     function upgradeMaster() public view returns (address) {
215         return _upgradeMaster;
216     }
217 
218     function upgradeAgent() public view returns (address) {
219         return address(_upgradeAgent);
220     }
221 
222     function totalUpgraded() public view returns (uint256) {
223         return _totalUpgraded;
224     }
225 
226     /**
227      * Tokens can be upgraded by calling this function.
228      */
229     function upgrade(uint256 amount) public {
230         UpgradeState state = getUpgradeState();
231         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading, "MYST: token is not in upgrading state");
232 
233         require(amount != 0, "MYST: upgradable amount should be more than 0");
234 
235         address holder = _msgSender();
236 
237         // Burn tokens to be upgraded
238         _burn(holder, amount);
239 
240         // Remember how many tokens we have upgraded
241         _totalUpgraded = _totalUpgraded + amount;
242 
243         // Upgrade agent upgrades/reissues tokens
244         _upgradeAgent.upgradeFrom(holder, amount);
245         emit Upgrade(holder, upgradeAgent(), amount);
246     }
247 
248     function setUpgradeMaster(address newUpgradeMaster) external {
249         require(newUpgradeMaster != address(0x0), "MYST: upgrade master can't be zero address");
250         require(_msgSender() == _upgradeMaster, "MYST: only upgrade master can set new one");
251         _upgradeMaster = newUpgradeMaster;
252 
253         emit UpgradeMasterSet(upgradeMaster());
254     }
255 
256     function setUpgradeAgent(address agent) external {
257         require(_msgSender()== _upgradeMaster, "MYST: only a master can designate the next agent");
258         require(agent != address(0x0), "MYST: upgrade agent can't be zero address");
259         require(getUpgradeState() != UpgradeState.Upgrading, "MYST: upgrade has already begun");
260 
261         _upgradeAgent = IUpgradeAgent(agent);
262         require(_upgradeAgent.isUpgradeAgent(), "MYST: agent should implement IUpgradeAgent interface");
263 
264         // Make sure that token supplies match in source and target
265         require(_upgradeAgent.originalSupply() == totalSupply(), "MYST: upgrade agent should know token's total supply");
266 
267         emit UpgradeAgentSet(upgradeAgent());
268     }
269 
270     function getUpgradeState() public view returns(UpgradeState) {
271         if(address(_upgradeAgent) == address(0x00)) return UpgradeState.WaitingForAgent;
272         else if(_totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
273         else if(totalSupply() == 0) return UpgradeState.Completed;
274         else return UpgradeState.Upgrading;
275     }
276 
277     // -------------- FUNDS RECOVERY --------------
278 
279     address internal _fundsDestination;
280     event FundsRecoveryDestinationChanged(address indexed previousDestination, address indexed newDestination);
281 
282     /**
283      * Setting new destination of funds recovery.
284      */
285     function setFundsDestination(address newDestination) public {
286         require(_msgSender()== _upgradeMaster, "MYST: only a master can set funds destination");
287         require(newDestination != address(0), "MYST: funds destination can't be zero addreess");
288 
289         _fundsDestination = newDestination;
290         emit FundsRecoveryDestinationChanged(_fundsDestination, newDestination);
291     }
292     /**
293      * Getting funds destination address.
294      */
295     function getFundsDestination() public view returns (address) {
296         return _fundsDestination;
297     }
298 
299     /**
300        Transfers selected tokens into `_fundsDestination` address.
301     */
302     function claimTokens(address token) public {
303         require(_fundsDestination != address(0));
304         uint256 amount = IERC20(token).balanceOf(address(this));
305         IERC20(token).transfer(_fundsDestination, amount);
306     }
307 
308     // -------------- HELPERS --------------
309 
310     function _chainID() private view returns (uint256) {
311         uint256 chainID;
312         assembly {
313             chainID := chainid()
314         }
315         return chainID;
316     }
317 
318     // -------------- TESTNET ONLY FUNCTIONS --------------
319 
320     function mint(address _account, uint _amount) public {
321         require(_msgSender()== _upgradeMaster, "MYST: only a master can mint");
322         _mint(_account, _amount);
323     }
324 }
