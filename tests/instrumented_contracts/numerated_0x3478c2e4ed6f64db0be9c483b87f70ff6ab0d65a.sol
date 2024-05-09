1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/interface/IBasicMultiToken.sol
39 
40 contract IBasicMultiToken is ERC20 {
41     event Bundle(address indexed who, address indexed beneficiary, uint256 value);
42     event Unbundle(address indexed who, address indexed beneficiary, uint256 value);
43 
44     function tokensCount() public view returns(uint256);
45     function tokens(uint256 _index) public view returns(ERC20);
46     function allTokens() public view returns(ERC20[]);
47     function allDecimals() public view returns(uint8[]);
48     function allBalances() public view returns(uint256[]);
49     function allTokensDecimalsBalances() public view returns(ERC20[], uint8[], uint256[]);
50 
51     function bundleFirstTokens(address _beneficiary, uint256 _amount, uint256[] _tokenAmounts) public;
52     function bundle(address _beneficiary, uint256 _amount) public;
53 
54     function unbundle(address _beneficiary, uint256 _value) public;
55     function unbundleSome(address _beneficiary, uint256 _value, ERC20[] _tokens) public;
56 
57     function denyBundling() public;
58     function allowBundling() public;
59 }
60 
61 // File: contracts/interface/IMultiToken.sol
62 
63 contract IMultiToken is IBasicMultiToken {
64     event Update();
65     event Change(address indexed _fromToken, address indexed _toToken, address indexed _changer, uint256 _amount, uint256 _return);
66 
67     function getReturn(address _fromToken, address _toToken, uint256 _amount) public view returns (uint256 returnAmount);
68     function change(address _fromToken, address _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256 returnAmount);
69 
70     function allWeights() public view returns(uint256[] _weights);
71     function allTokensDecimalsBalancesWeights() public view returns(ERC20[] _tokens, uint8[] _decimals, uint256[] _balances, uint256[] _weights);
72 
73     function denyChanges() public;
74 }
75 
76 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
77 
78 /**
79  * @title Ownable
80  * @dev The Ownable contract has an owner address, and provides basic authorization control
81  * functions, this simplifies the implementation of "user permissions".
82  */
83 contract Ownable {
84   address public owner;
85 
86 
87   event OwnershipRenounced(address indexed previousOwner);
88   event OwnershipTransferred(
89     address indexed previousOwner,
90     address indexed newOwner
91   );
92 
93 
94   /**
95    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
96    * account.
97    */
98   constructor() public {
99     owner = msg.sender;
100   }
101 
102   /**
103    * @dev Throws if called by any account other than the owner.
104    */
105   modifier onlyOwner() {
106     require(msg.sender == owner);
107     _;
108   }
109 
110   /**
111    * @dev Allows the current owner to relinquish control of the contract.
112    */
113   function renounceOwnership() public onlyOwner {
114     emit OwnershipRenounced(owner);
115     owner = address(0);
116   }
117 
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param _newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address _newOwner) public onlyOwner {
123     _transferOwnership(_newOwner);
124   }
125 
126   /**
127    * @dev Transfers control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function _transferOwnership(address _newOwner) internal {
131     require(_newOwner != address(0));
132     emit OwnershipTransferred(owner, _newOwner);
133     owner = _newOwner;
134   }
135 }
136 
137 // File: contracts/registry/IDeployer.sol
138 
139 contract IDeployer is Ownable {
140     function deploy(bytes data) external returns(address mtkn);
141 }
142 
143 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
144 
145 /**
146  * @title Pausable
147  * @dev Base contract which allows children to implement an emergency stop mechanism.
148  */
149 contract Pausable is Ownable {
150   event Pause();
151   event Unpause();
152 
153   bool public paused = false;
154 
155 
156   /**
157    * @dev Modifier to make a function callable only when the contract is not paused.
158    */
159   modifier whenNotPaused() {
160     require(!paused);
161     _;
162   }
163 
164   /**
165    * @dev Modifier to make a function callable only when the contract is paused.
166    */
167   modifier whenPaused() {
168     require(paused);
169     _;
170   }
171 
172   /**
173    * @dev called by the owner to pause, triggers stopped state
174    */
175   function pause() onlyOwner whenNotPaused public {
176     paused = true;
177     emit Pause();
178   }
179 
180   /**
181    * @dev called by the owner to unpause, returns to normal state
182    */
183   function unpause() onlyOwner whenPaused public {
184     paused = false;
185     emit Unpause();
186   }
187 }
188 
189 // File: contracts/registry/MultiTokenNetwork.sol
190 
191 contract MultiTokenNetwork is Pausable {
192 
193     event NewMultitoken(address indexed mtkn);
194     event NewDeployer(uint256 indexed index, address indexed oldDeployer, address indexed newDeployer);
195 
196     address[] public multitokens;
197     mapping(uint256 => IDeployer) public deployers;
198 
199     function multitokensCount() public view returns(uint256) {
200         return multitokens.length;
201     }
202 
203     function allMultitokens() public view returns(address[]) {
204         return multitokens;
205     }
206 
207     function allWalletBalances(address wallet) public view returns(uint256[]) {
208         uint256[] memory balances = new uint256[](multitokens.length);
209         for (uint i = 0; i < multitokens.length; i++) {
210             balances[i] = ERC20(multitokens[i]).balanceOf(wallet);
211         }
212         return balances;
213     }
214 
215     function deleteMultitoken(uint index) public onlyOwner {
216         require(index < multitokens.length, "deleteMultitoken: index out of range");
217         if (index != multitokens.length - 1) {
218             multitokens[index] = multitokens[multitokens.length - 1];
219         }
220         multitokens.length -= 1;
221     }
222 
223     function denyBundlingMultitoken(uint index) public onlyOwner {
224         IBasicMultiToken(multitokens[index]).denyBundling();
225     }
226 
227     function allowBundlingMultitoken(uint index) public onlyOwner {
228         IBasicMultiToken(multitokens[index]).allowBundling();
229     }
230 
231     function denyChangesMultitoken(uint index) public onlyOwner {
232         IMultiToken(multitokens[index]).denyChanges();
233     }
234 
235     function setDeployer(uint256 index, IDeployer deployer) public onlyOwner whenNotPaused {
236         require(deployer.owner() == address(this), "setDeployer: first set MultiTokenNetwork as owner");
237         emit NewDeployer(index, deployers[index], deployer);
238         deployers[index] = deployer;
239     }
240 
241     function deploy(uint256 index, bytes data) public whenNotPaused {
242         address mtkn = deployers[index].deploy(data);
243         multitokens.push(mtkn);
244         emit NewMultitoken(mtkn);
245     }
246 }