1 pragma solidity 0.4.26;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public view returns (address) {this;}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public view returns (string) {this;}
20     function symbol() public view returns (string) {this;}
21     function decimals() public view returns (uint8) {this;}
22     function totalSupply() public view returns (uint256) {this;}
23     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
24     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
33 */
34 contract INonStandardERC20 {
35     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
36     function name() public view returns (string) {this;}
37     function symbol() public view returns (string) {this;}
38     function decimals() public view returns (uint8) {this;}
39     function totalSupply() public view returns (uint256) {this;}
40     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
41     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
42 
43     function transfer(address _to, uint256 _value) public;
44     function transferFrom(address _from, address _to, uint256 _value) public;
45     function approve(address _spender, uint256 _value) public;
46 }
47 
48 contract IBancorX {
49     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
50     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
51 }
52 
53 /*
54     Token Holder interface
55 */
56 contract ITokenHolder is IOwned {
57     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
58 }
59 
60 /**
61   * @dev Utilities & Common Modifiers
62 */
63 contract Utils {
64     /**
65       * constructor
66     */
67     constructor() public {
68     }
69 
70     // verifies that an amount is greater than zero
71     modifier greaterThanZero(uint256 _amount) {
72         require(_amount > 0);
73         _;
74     }
75 
76     // validates an address - currently only checks that it isn't null
77     modifier validAddress(address _address) {
78         require(_address != address(0));
79         _;
80     }
81 
82     // verifies that the address is different than this contract address
83     modifier notThis(address _address) {
84         require(_address != address(this));
85         _;
86     }
87 
88 }
89 
90 /**
91   * @dev Provides support and utilities for contract ownership
92 */
93 contract Owned is IOwned {
94     address public owner;
95     address public newOwner;
96 
97     /**
98       * @dev triggered when the owner is updated
99       * 
100       * @param _prevOwner previous owner
101       * @param _newOwner  new owner
102     */
103     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
104 
105     /**
106       * @dev initializes a new Owned instance
107     */
108     constructor() public {
109         owner = msg.sender;
110     }
111 
112     // allows execution by the owner only
113     modifier ownerOnly {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     /**
119       * @dev allows transferring the contract ownership
120       * the new owner still needs to accept the transfer
121       * can only be called by the contract owner
122       * 
123       * @param _newOwner    new contract owner
124     */
125     function transferOwnership(address _newOwner) public ownerOnly {
126         require(_newOwner != owner);
127         newOwner = _newOwner;
128     }
129 
130     /**
131       * @dev used by a new owner to accept an ownership transfer
132     */
133     function acceptOwnership() public {
134         require(msg.sender == newOwner);
135         emit OwnerUpdate(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 /**
142   * @dev We consider every contract to be a 'token holder' since it's currently not possible
143   * for a contract to deny receiving tokens.
144   * 
145   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
146   * the owner to send tokens that were sent to the contract by mistake back to their sender.
147   * 
148   * Note that we use the non standard ERC-20 interface which has no return value for transfer
149   * in order to support both non standard as well as standard token contracts.
150   * see https://github.com/ethereum/solidity/issues/4116
151 */
152 contract TokenHolder is ITokenHolder, Owned, Utils {
153     /**
154       * @dev initializes a new TokenHolder instance
155     */
156     constructor() public {
157     }
158 
159     /**
160       * @dev withdraws tokens held by the contract and sends them to an account
161       * can only be called by the owner
162       * 
163       * @param _token   ERC20 token contract address
164       * @param _to      account to receive the new amount
165       * @param _amount  amount to withdraw
166     */
167     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
168         public
169         ownerOnly
170         validAddress(_token)
171         validAddress(_to)
172         notThis(_to)
173     {
174         INonStandardERC20(_token).transfer(_to, _amount);
175     }
176 }
177 
178 contract AirDropper is TokenHolder {
179     enum State {
180         storeEnabled,
181         storeDisabled,
182         transferEnabled
183     }
184 
185     address public agent;
186     State public state;
187     bytes32 public storedBalancesCRC;
188 
189     mapping (address => uint256) public storedBalances;
190     mapping (address => uint256) public transferredBalances;
191 
192     constructor() TokenHolder() public {
193         state = State.storeEnabled;
194     }
195 
196     function setAgent(address _agent) external ownerOnly {
197         agent = _agent;
198     }
199 
200     function setState(State _state) external ownerOnly {
201         state = _state;
202     }
203 
204     function storeBatch(address[] _targets, uint256[] _amounts) external {
205         bytes32 crc = 0;
206         require(msg.sender == agent && state == State.storeEnabled);
207         uint256 length = _targets.length;
208         require(length == _amounts.length);
209         for (uint256 i = 0; i < length; i++) {
210             address target = _targets[i];
211             uint256 amount = _amounts[i];
212             require(storedBalances[target] == 0);
213             storedBalances[target] = amount;
214             crc ^= keccak256(abi.encodePacked(_targets[i], _amounts[i]));
215         }
216         storedBalancesCRC ^= crc;
217     }
218 
219     function transferEth(IERC20Token _token, address[] _targets, uint256[] _amounts) external {
220         require(msg.sender == agent && state == State.transferEnabled);
221         uint256 length = _targets.length;
222         require(length == _amounts.length);
223         for (uint256 i = 0; i < length; i++) {
224             address target = _targets[i];
225             uint256 amount = _amounts[i];
226             require(storedBalances[target] == amount);
227             require(transferredBalances[target] == 0);
228             require(_token.transfer(target, amount));
229             transferredBalances[target] = amount;
230         }
231     }
232 
233     function transferEos(IBancorX _bancorX, bytes32 _target, uint256 _amount) external {
234         require(msg.sender == agent && state == State.transferEnabled);
235         require(storedBalances[_bancorX] == _amount);
236         require(transferredBalances[_bancorX] == 0);
237         _bancorX.xTransfer("eos", _target, _amount, 0);
238         transferredBalances[_bancorX] = _amount;
239     }
240 }