1 pragma solidity ^0.4.15;
2 
3 /* TODO: change this to an interface definition as soon as truffle accepts it. See https://github.com/trufflesuite/truffle/issues/560 */
4 contract ITransferable {
5     function transfer(address _to, uint256 _value) public returns (bool success);
6 }
7 
8 /**
9 @title PLAY Token
10 
11 ERC20 Token with additional mint functionality.
12 A "controller" (initialized to the contract creator) has exclusive permission to mint.
13 The controller address can be changed until locked.
14 
15 Implementation based on https://github.com/ConsenSys/Tokens
16 */
17 contract PlayToken {
18     uint256 public totalSupply = 0;
19     string public name = "PLAY";
20     uint8 public decimals = 18;
21     string public symbol = "PLY";
22     string public version = '1';
23 
24     address public controller;
25     bool public controllerLocked = false;
26 
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) allowed;
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 
33     modifier onlyController() {
34         require(msg.sender == controller);
35         _;
36     }
37 
38     /** @dev constructor */
39     function PlayToken(address _controller) {
40         controller = _controller;
41     }
42 
43     /** Sets a new controller address if the current controller isn't locked */
44     function setController(address _newController) onlyController {
45         require(! controllerLocked);
46         controller = _newController;
47     }
48 
49     /** Locks the current controller address forever */
50     function lockController() onlyController {
51         controllerLocked = true;
52     }
53 
54     /**
55     Creates new tokens for the given receiver.
56     Can be called only by the contract creator.
57     */
58     function mint(address _receiver, uint256 _value) onlyController {
59         balances[_receiver] += _value;
60         totalSupply += _value;
61         // (probably) recommended by the standard, see https://github.com/ethereum/EIPs/pull/610/files#diff-c846f31381e26d8beeeae24afcdf4e3eR99
62         Transfer(0, _receiver, _value);
63     }
64 
65     function transfer(address _to, uint256 _value) returns (bool success) {
66         /* Additional Restriction: don't accept token payments to the contract itself and to address 0 in order to avoid most
67          token losses by mistake - as is discussed in https://github.com/ethereum/EIPs/issues/223 */
68         require((_to != 0) && (_to != address(this)));
69 
70         require(balances[msg.sender] >= _value);
71         balances[msg.sender] -= _value;
72         balances[_to] += _value;
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
79         balances[_to] += _value;
80         balances[_from] -= _value;
81         allowed[_from][msg.sender] -= _value;
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) constant returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint256 _value) returns (bool success) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 
100     /* Approves and then calls the receiving contract */
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104 
105         /* call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
106         receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
107         it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead. */
108         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
109         return true;
110     }
111 
112     /**
113     Withdraws tokens held by the contract to a given account.
114     Motivation: see https://github.com/ethereum/EIPs/issues/223#issuecomment-317987571
115     */
116     function withdrawTokens(ITransferable _token, address _to, uint256 _amount) onlyController {
117         _token.transfer(_to, _amount);
118     }
119 }
120 
121 /**
122 @title Contract for the Play4Privacy application.
123 
124 Persists games played (represented by a hash) and distributes PLAY tokens to players and to a pool per game.
125 This contract does not accept Ether payments.
126 */
127 contract P4PGame {
128     address public owner;
129     address public pool;
130     PlayToken playToken;
131     bool public active = true;
132 
133     event GamePlayed(bytes32 hash, bytes32 boardEndState);
134     event GameOver();
135 
136     modifier onlyOwner() {
137         require(msg.sender == owner);
138         _;
139     }
140 
141     modifier onlyIfActive() {
142         require(active);
143         _;
144     }
145 
146     /**
147     @dev Constructor
148 
149     Creates a contract for the associated PLAY Token.
150     */
151     function P4PGame(address _tokenAddr, address _poolAddr) {
152         owner = msg.sender;
153         playToken = PlayToken(_tokenAddr);
154         pool = _poolAddr;
155     }
156 
157     /** Proxy function for Token */
158     function setTokenController(address _controller) onlyOwner {
159         playToken.setController(_controller);
160     }
161 
162     /** Proxy function for Token */
163     function lockTokenController() onlyOwner {
164         playToken.lockController();
165     }
166 
167     /** Sets the address of the contract to which all generated tokens are duplicated. */
168     function setPoolContract(address _pool) onlyOwner {
169         pool = _pool;
170     }
171 
172     /** Persists proof of the game state and final board eternally
173     @param hash a reference to an offchain data record of the game end state (can contain arbitrary details).
174     @param board encoded bitmap of the final state of the Go board
175     */
176     function addGame(bytes32 hash, bytes32 board) onlyOwner onlyIfActive {
177         GamePlayed(hash, board);
178     }
179 
180     /** Distributes tokens for playing
181     @param receivers array of addresses to which PLAY tokens are distributed.
182     @param amounts array specifying the amount of tokens per receiver. Needs to have the same size as the receivers array.
183 
184     It's the callers responsibility to limit the array sizes such that the transaction doesn't run out of gas
185     */
186     function distributeTokens(address[] receivers, uint16[] amounts) onlyOwner onlyIfActive {
187         require(receivers.length == amounts.length);
188         var totalAmount = distributeTokensImpl(receivers, amounts);
189         payoutPool(totalAmount);
190     }
191 
192     /** Disables the contract
193     Once this is called, no more games can be played and no more tokens distributed.
194     This also implies that no more PLAY tokens can be minted since this contract has exclusive permission to do so
195     - assuming that this contract is locked as controller in the Token contract.
196     */
197     function shutdown() onlyOwner {
198         active = false;
199         GameOver();
200     }
201 
202     function getTokenAddress() constant returns(address) {
203         return address(playToken);
204     }
205 
206     // ######### INTERNAL FUNCTIONS ##########
207 
208     /**
209     Redeems PLAY tokens to the given set of receivers by invoking mint() of the associated token contract.
210 
211     @return the total amount of tokens payed out
212     */
213     function distributeTokensImpl(address[] receivers, uint16[] amounts) internal returns(uint256) {
214         uint256 totalAmount = 0;
215         for (uint i = 0; i < receivers.length; i++) {
216             // amounts are converted to the token base unit (including decimals)
217             playToken.mint(receivers[i], uint256(amounts[i]) * 1e18);
218             totalAmount += amounts[i];
219         }
220         return totalAmount;
221     }
222 
223     /** Commits one token for every token generated to the pool (batched) */
224     function payoutPool(uint256 amount) internal {
225         require(pool != 0);
226         playToken.mint(pool, amount * 1e18);
227     }
228 }