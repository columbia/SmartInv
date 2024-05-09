1 pragma solidity 0.4.26;
2 
3 // File: bancor-contracts/solidity/contracts/utility/interfaces/IOwned.sol
4 
5 /*
6     Owned contract interface
7 */
8 contract IOwned {
9     // this function isn't abstract since the compiler emits automatically generated getter functions as external
10     function owner() public view returns (address) {this;}
11 
12     function transferOwnership(address _newOwner) public;
13     function acceptOwnership() public;
14 }
15 
16 // File: bancor-contracts/solidity/contracts/utility/Owned.sol
17 
18 /**
19   * @dev Provides support and utilities for contract ownership
20 */
21 contract Owned is IOwned {
22     address public owner;
23     address public newOwner;
24 
25     /**
26       * @dev triggered when the owner is updated
27       * 
28       * @param _prevOwner previous owner
29       * @param _newOwner  new owner
30     */
31     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
32 
33     /**
34       * @dev initializes a new Owned instance
35     */
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     // allows execution by the owner only
41     modifier ownerOnly {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     /**
47       * @dev allows transferring the contract ownership
48       * the new owner still needs to accept the transfer
49       * can only be called by the contract owner
50       * 
51       * @param _newOwner    new contract owner
52     */
53     function transferOwnership(address _newOwner) public ownerOnly {
54         require(_newOwner != owner);
55         newOwner = _newOwner;
56     }
57 
58     /**
59       * @dev used by a new owner to accept an ownership transfer
60     */
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnerUpdate(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 // File: bancor-contracts/solidity/contracts/utility/Utils.sol
70 
71 /**
72   * @dev Utilities & Common Modifiers
73 */
74 contract Utils {
75     /**
76       * constructor
77     */
78     constructor() public {
79     }
80 
81     // verifies that an amount is greater than zero
82     modifier greaterThanZero(uint256 _amount) {
83         require(_amount > 0);
84         _;
85     }
86 
87     // validates an address - currently only checks that it isn't null
88     modifier validAddress(address _address) {
89         require(_address != address(0));
90         _;
91     }
92 
93     // verifies that the address is different than this contract address
94     modifier notThis(address _address) {
95         require(_address != address(this));
96         _;
97     }
98 
99 }
100 
101 // File: bancor-contracts/solidity/contracts/token/interfaces/IERC20Token.sol
102 
103 /*
104     ERC20 Standard Token interface
105 */
106 contract IERC20Token {
107     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
108     function name() public view returns (string) {this;}
109     function symbol() public view returns (string) {this;}
110     function decimals() public view returns (uint8) {this;}
111     function totalSupply() public view returns (uint256) {this;}
112     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
113     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
114 
115     function transfer(address _to, uint256 _value) public returns (bool success);
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
117     function approve(address _spender, uint256 _value) public returns (bool success);
118 }
119 
120 // File: bancor-contracts/solidity/contracts/utility/interfaces/ITokenHolder.sol
121 
122 /*
123     Token Holder interface
124 */
125 contract ITokenHolder is IOwned {
126     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
127 }
128 
129 // File: bancor-contracts/solidity/contracts/token/interfaces/INonStandardERC20.sol
130 
131 /*
132     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
133 */
134 contract INonStandardERC20 {
135     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
136     function name() public view returns (string) {this;}
137     function symbol() public view returns (string) {this;}
138     function decimals() public view returns (uint8) {this;}
139     function totalSupply() public view returns (uint256) {this;}
140     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
141     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
142 
143     function transfer(address _to, uint256 _value) public;
144     function transferFrom(address _from, address _to, uint256 _value) public;
145     function approve(address _spender, uint256 _value) public;
146 }
147 
148 // File: bancor-contracts/solidity/contracts/utility/TokenHolder.sol
149 
150 /**
151   * @dev We consider every contract to be a 'token holder' since it's currently not possible
152   * for a contract to deny receiving tokens.
153   * 
154   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
155   * the owner to send tokens that were sent to the contract by mistake back to their sender.
156   * 
157   * Note that we use the non standard ERC-20 interface which has no return value for transfer
158   * in order to support both non standard as well as standard token contracts.
159   * see https://github.com/ethereum/solidity/issues/4116
160 */
161 contract TokenHolder is ITokenHolder, Owned, Utils {
162     /**
163       * @dev initializes a new TokenHolder instance
164     */
165     constructor() public {
166     }
167 
168     /**
169       * @dev withdraws tokens held by the contract and sends them to an account
170       * can only be called by the owner
171       * 
172       * @param _token   ERC20 token contract address
173       * @param _to      account to receive the new amount
174       * @param _amount  amount to withdraw
175     */
176     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
177         public
178         ownerOnly
179         validAddress(_token)
180         validAddress(_to)
181         notThis(_to)
182     {
183         INonStandardERC20(_token).transfer(_to, _amount);
184     }
185 }
186 
187 // File: bancor-contracts/solidity/contracts/bancorx/interfaces/IBancorX.sol
188 
189 contract IBancorX {
190     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
191     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
192 }
193 
194 // File: contracts\AirDropper.sol
195 
196 contract AirDropper is TokenHolder {
197     enum State {
198         storeEnabled,
199         storeDisabled,
200         transferEnabled
201     }
202 
203     address public agent;
204     State public state;
205     bytes32 public storedBalancesCRC;
206 
207     mapping (address => uint256) public storedBalances;
208     mapping (address => uint256) public transferredBalances;
209 
210     constructor() TokenHolder() public {
211         state = State.storeEnabled;
212     }
213 
214     function setAgent(address _agent) external ownerOnly {
215         agent = _agent;
216     }
217 
218     function setState(State _state) external ownerOnly {
219         state = _state;
220     }
221 
222     function storeBatch(address[] _targets, uint256[] _amounts) external {
223         bytes32 crc = 0;
224         require(msg.sender == agent && state == State.storeEnabled);
225         uint256 length = _targets.length;
226         require(length == _amounts.length);
227         for (uint256 i = 0; i < length; i++) {
228             address target = _targets[i];
229             uint256 amount = _amounts[i];
230             require(storedBalances[target] == 0);
231             storedBalances[target] = amount;
232             crc ^= keccak256(abi.encodePacked(_targets[i], _amounts[i]));
233         }
234         storedBalancesCRC ^= crc;
235     }
236 
237     function transferEth(IERC20Token _token, address[] _targets, uint256[] _amounts) external {
238         require(msg.sender == agent && state == State.transferEnabled);
239         uint256 length = _targets.length;
240         require(length == _amounts.length);
241         for (uint256 i = 0; i < length; i++) {
242             address target = _targets[i];
243             uint256 amount = _amounts[i];
244             require(storedBalances[target] == amount);
245             require(transferredBalances[target] == 0);
246             require(_token.transfer(target, amount));
247             transferredBalances[target] = amount;
248         }
249     }
250 
251     function transferEos(IBancorX _bancorX, bytes32 _target, uint256 _amount) external {
252         require(msg.sender == agent && state == State.transferEnabled);
253         require(storedBalances[_bancorX] == _amount);
254         require(transferredBalances[_bancorX] == 0);
255         _bancorX.xTransfer("eos", _target, _amount, 0);
256         transferredBalances[_bancorX] = _amount;
257     }
258 }
