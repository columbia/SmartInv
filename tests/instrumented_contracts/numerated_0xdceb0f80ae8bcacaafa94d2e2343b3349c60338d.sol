1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  *  @title ERC223 Interface of the Bether Token currently deployed on the Ethereum main net.
6  */
7 contract BetherERC223Interface {
8     /** 
9      *  @dev The total amount of Bether available
10      */
11     uint256 public totalSupply;
12 
13     /** 
14      *  @dev Provides access to check how much Bether the _owner allowed the _spender to use.
15      *  @param _owner Address that owns the Bether.
16      *  @param _spender Address that wants to transfer the _owner's Bether.
17      *  @return remaining The amount of Bether that _owner allowed _spender to transfer (in Wei).
18      */
19     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
20 
21     /** 
22      *  @dev Allows the Bether holder to authorize _spender to transfer the holder's Bether (in Wei).
23      *  @param _spender The address that will be allowed to transfer _value amount of the holders Bether.
24      *  @param _value The amount of Bether that _spender is allowed to transfer on behalf of the holder.
25      *  @return _approved Whether the approval was successful or not.
26      */
27     function approve(address _spender, uint256 _value) public returns (bool _approved);
28 
29     /** 
30      *  @dev Checks the amount of Bether the _address holds.
31      *  @param _address The address the balance of which is to be checked.
32      *  @return balance The Bether balance of _address (in Wei).
33      */
34     function balanceOf(address _address) public constant returns (uint256 balance);
35 
36     /**
37      *  @dev Gets the amount of decimal points Bether supports.
38      *  @return _decimals The amount of decimal points Bether supports.
39      */
40     function decimals() public constant returns (uint8 _decimals);
41 
42     /**
43      *  @dev Gets the name of the token.
44      *  @return _name The name of the token.
45      */
46     function name() public constant returns (string _name);
47 
48     /**
49      *  @dev Gets the symbol of the token.
50      *  @return _symbol The symbol of the token.
51      */
52     function symbol() public constant returns (string _symbol);
53 
54     /**
55      *  @dev Transfers Bether.
56      *  @param _to The target address to which Bether will be sent from the caller.
57      *  @param _value The amount of Bether to send (in Wei).
58      *  @return _sent Whether the transfer was successful or not.
59      */
60     function transfer(address _to, uint256 _value) public returns (bool _sent);
61 
62     /**
63      *  @dev Transfers Bether.
64      *  @param _to The target address to which Bether will be sent from the caller.
65      *  @param _value The amount of Bether to send (in Wei).
66      *  @param _data TODO: What is this?
67      *  @return _sent Whether the transfer was successful or not.
68      */
69     function transfer(address _to, uint256 _value, bytes _data) public returns (bool _sent);
70 
71     /**
72      *  @dev Transfers Bether.
73      *  @param _from The address from which Bether will be sent (Requires approval via the approve() method).
74      *  @param _to The target address to which Bether will be sent.
75      *  @param _value The amount of Bether to send (in Wei).
76      *  @return _sent Whether the transfer was successful or not.
77      */
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _sent);
79 }
80 
81 
82  /*
83  * Contract that is working with ERC223 tokens. Implementing the tokenFallback function in a way that doesn't throw an error enables
84  * the contract to receive ERC223 tokens. Making it an empty function is enough to enable receiving of tokens. The default
85  * implementation of tokenFallback ALWAYS throws an error. This is to prevent random contracts from ending up with ERC223
86  * tokens but not having the functionality to send them away.
87  * https://github.com/ethereum/EIPs/issues/223
88  */
89 
90 /** @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens. */
91 contract ERC223ReceivingContract {
92 
93     /** 
94      *  @dev Function that is called when a user or another contract wants to transfer funds.
95      *  @param _from Transaction initiator, analogue of msg.sender.
96      *  @param _value Number of tokens to transfer.
97      *  @param _data Data containig a function signature and/or parameters.
98      */
99     function tokenFallback(address _from, uint256 _value, bytes _data) public;
100 }
101 
102 
103 /**
104     The DepositContract only has a single purpose and that is to forward all Bether and Ether
105     to the BalanceManager contract, which created it. It serves as an aggregator.
106     Every user has one DepositContract, meaning when the funds arrive to the BalanceManager,
107     we know which user sent them (it depends on which DepositContract forwarded the funds).
108 */
109 contract DepositContract is ERC223ReceivingContract {
110 
111     /** @dev The BalanceManager to which funds will be transfered. */
112     BalanceManager public balanceManager;
113 
114     /** @dev The Bether token itself. Only this token will be forwarded, others will be aborted. */
115     BetherERC223Interface public betherToken;
116 
117     /**
118         @dev Basic constructor.
119         @param balanceManagerAddress The address of the BalanceManager to forward funds to.
120         @param betherTokenAddress The address of the token that is to be forwarded.
121     */
122     constructor(address balanceManagerAddress, address betherTokenAddress) public {
123         balanceManager = BalanceManager(balanceManagerAddress);
124         betherToken = BetherERC223Interface(betherTokenAddress);
125     }
126 
127     /**
128         @dev Fallback payable function, which forwards all Ether to the BalanceManager.
129     */
130     function () public payable {
131         require(address(balanceManager).send(msg.value));
132     }
133 
134 
135     /** 
136         @dev Function that is called by the ERC223 token contract when tokens are sent to
137         this contract.
138         @param _value Number of tokens (in wei) that have been sent.
139      */
140     function tokenFallback(address, uint256 _value, bytes) public {
141         require(msg.sender == address(betherToken));
142         require(betherToken.transfer(address(balanceManager), _value));
143     }
144 }
145 
146 
147 /**
148     The BalanceManager is a contract that aggregates Bether and Ether that users deposit into our
149     platform via DepositContracts. It is also responsible for applying an exchange rate for received
150     Ether.
151 */
152 contract BalanceManager is ERC223ReceivingContract {
153 
154     /** @dev The BalanceManager to which funds will be transfered. */
155     BetherERC223Interface public betherToken;
156 
157     /** @dev Current exchange rate (amount of Bether that is given for each Ether) */
158     uint256 public betherForEther;
159 
160     /** @dev The address of the Admin. The Admin wallet is fully authorized to control this contract */
161     address public adminWallet;
162 
163     /**
164         @dev The Operator wallet has a subset of the privileges of the Admin wallet. It can send Bether
165         and change the exchange rate.
166     */
167     address public operatorWallet;
168 
169     /** @dev Basic constructor populates the storage variables.    */
170     constructor(address betherTokenAddress, address _adminWallet, address _operatorWallet) public {
171         betherToken = BetherERC223Interface(betherTokenAddress);
172         adminWallet = _adminWallet;
173         operatorWallet = _operatorWallet;
174     }
175 
176 
177 
178     /***********************************************************************************************************/
179     /** Security and Privilege Control *************************************************************************/
180 
181     /** @dev Modifier for ensuring only the Admin wallet can call a function. */
182     modifier adminLevel {
183         require(msg.sender == adminWallet);
184         _;
185     }
186 
187     /** @dev Modifier for ensuring only the Admin and Operator wallets can call a function. */
188     modifier operatorLevel {
189         require(msg.sender == operatorWallet || msg.sender == adminWallet);
190         _;
191     }
192     
193     /** @dev Setter for the Admin wallet. */
194     function setAdminWallet(address _adminWallet) public adminLevel {
195         adminWallet = _adminWallet;
196     }
197 
198     /** @dev Setter for the Operator wallet. */
199     function setOperatorWallet(address _operatorWallet) public adminLevel {
200         operatorWallet = _operatorWallet;
201     }
202 
203 
204 
205     /***********************************************************************************************************/
206     /** Token Receiving and Exchanging *************************************************************************/
207 
208     /** @dev Setter for the exchange rate. */
209     function setBetherForEther(uint256 _betherForEther) public operatorLevel {
210         betherForEther = _betherForEther;
211     }
212 
213     /** 
214         @dev This event is used to track which account deposited how much Bether.
215         @param depositContractAddress The address from whence the Bether arrived.
216         @param amount The amount of Bether (in wei) that arrived.
217     */
218     event DepositDetected(address depositContractAddress, uint256 amount);
219     
220     /**
221         @dev Payable callback function. This is triggered when Ether is sent to
222         this contract. It applies the exchange rate to the Ether and emits an
223         event, logging the deposit.
224     */
225     function () public payable {
226         uint256 etherValue = msg.value;
227         require(etherValue > 0);
228         uint256 betherValue = etherValue * betherForEther;
229         require(betherValue / etherValue == betherForEther);
230         emit DepositDetected(msg.sender, betherValue);
231     }
232 
233     /** 
234         @dev Function that is called by the ERC223 token contract when tokens are sent to
235         this contract.
236         @param _from Transaction initiator, analogue of msg.sender.
237         @param _value Number of tokens (in wei) that have been sent.
238      */
239     function tokenFallback(address _from, uint256 _value, bytes) public {
240         require(msg.sender == address(betherToken));
241         emit DepositDetected(_from, _value);
242     }
243 
244 
245 
246     /***********************************************************************************************************/
247     /** Token Transfering **************************************************************************************/
248 
249     /**
250         @dev Function sends 'amount' of Bether (in wei) from this contract to
251         the 'target' address.
252     */
253     function sendBether(address target, uint256 amount) public operatorLevel {
254         require(betherToken.transfer(target, amount));
255     }
256 
257     /**
258         @dev Function sends 'amount' of Ether (in wei) from this contract to
259         the 'target' address. This function can only be triggered by the Admin
260         wallet, since we only support one-way exchange.
261     */
262     function sendEther(address target, uint256 amount) public adminLevel {
263         require(target.send(amount));
264     }
265 
266 
267 
268     /***********************************************************************************************************/
269     /** Deployment of Deposit Contracts ************************************************************************/
270 
271     /** @dev This event is used to track down the addresses of newly deployed DepositContracts. */
272     event NewDepositContract(address depositContractAddress);
273 
274     /**
275         @dev Function deploys 'amount' DepositContracts with this contract set as their
276         DepositManager.
277         @param amount Amount of DepositContracts to Deploy.
278     */
279     function deployNewDepositContracts(uint256 amount) public {
280         for (uint256 i = 0; i < amount; i++) {
281             address newContractAddress = new DepositContract(address(this), address(betherToken));
282             emit NewDepositContract(newContractAddress);
283         }
284     }
285 
286     /***********************************************************************************************************/
287 }