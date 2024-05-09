1 pragma solidity ^0.4.17;
2 
3 contract Cofounded {
4   mapping (address => uint) public cofounderIndices;
5   address[] public cofounders;
6 
7 
8   /// @dev restrict execution to one of original cofounder addresses
9   modifier restricted () {
10     uint cofounderIndex = cofounderIndices[msg.sender];
11     require(msg.sender == cofounders[cofounderIndex]);
12     _;
13   }
14 
15   /// @notice creates the Cofounded contract instance
16   /// @dev adds up to cofounders.
17   ///      also adds  the deployment address as a cofounder
18   function Cofounded (address[] contractCofounders) public {
19     cofounders.push(msg.sender);
20     
21     for (uint8 x = 0; x < contractCofounders.length; x++) {
22       address cofounder = contractCofounders[x];
23 
24       bool isValidUniqueCofounder =
25         cofounder != address(0) &&
26         cofounder != msg.sender &&
27         cofounderIndices[cofounder] == 0;
28 
29             
30       // NOTE: solidity as of 0.4.20 does not have an
31       // undefined or null-like value
32       // thusly mappings return the default value of the value type
33       // for an unregistered key value
34       // an address which doesn't exist will return 0
35       // which is actually the index of the address of the first
36       // cofounder
37       if (isValidUniqueCofounder) {
38         uint256 cofounderIndex = cofounders.push(cofounder) - 1;
39         cofounderIndices[cofounder] = cofounderIndex;
40       }
41     }
42   }
43 
44   /// @dev get count of cofounders
45   function getCofounderCount () public constant returns (uint256) {
46     return cofounders.length;
47   }
48 
49   /// @dev get list of cofounders
50   function getCofounders () public constant returns (address[]) {
51     return cofounders;
52   }
53 }
54 
55 interface ERC20 {
56 
57   // Required methods
58   function transfer (address to, uint256 value) public returns (bool success);
59   function transferFrom (address from, address to, uint256 value) public returns (bool success);
60   function approve (address spender, uint256 value) public returns (bool success);
61   function allowance (address owner, address spender) public constant returns (uint256 remaining);
62   function balanceOf (address owner) public constant returns (uint256 balance);
63   // Events
64   event Transfer (address indexed from, address indexed to, uint256 value);
65   event Approval (address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 
69 /// @title Interface for contracts conforming to ERC-165: Pseudo-Introspection, or standard interface detection
70 /// @author Mish Ochu
71 interface ERC165 {
72   /// @dev true iff the interface is supported
73   function supportsInterface(bytes4 interfaceID) external constant returns (bool);
74 }
75 contract InterfaceSignatureConstants {
76   bytes4 constant InterfaceSignature_ERC165 =
77     bytes4(keccak256('supportsInterface(bytes4)'));
78 
79   bytes4 constant InterfaceSignature_ERC20 =
80     bytes4(keccak256('totalSupply()')) ^
81     bytes4(keccak256('balanceOf(address)')) ^
82     bytes4(keccak256('transfer(address,uint256)')) ^
83     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
84     bytes4(keccak256('approve(address,uint256)')) ^
85     bytes4(keccak256('allowance(address,address)'));
86 
87   bytes4 constant InterfaceSignature_ERC20_PlusOptions = 
88     bytes4(keccak256('name()')) ^
89     bytes4(keccak256('symbol()')) ^
90     bytes4(keccak256('decimals()')) ^
91     bytes4(keccak256('totalSupply()')) ^
92     bytes4(keccak256('balanceOf(address)')) ^
93     bytes4(keccak256('transfer(address,uint256)')) ^
94     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
95     bytes4(keccak256('approve(address,uint256)')) ^
96     bytes4(keccak256('allowance(address,address)'));
97 }
98 
99 /// @title an original cofounder based ERC-20 compliant token
100 /// @author Mish Ochu
101 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
102 //http://solidity.readthedocs.io/en/develop/contracts.html#arguments-for-base-constructors
103 contract OriginalToken is Cofounded, ERC20, ERC165, InterfaceSignatureConstants {
104     bool private hasExecutedCofounderDistribution;
105     struct Allowance {
106       uint256 amount;
107       bool    hasBeenPartiallyWithdrawn;
108     }
109 
110     //***** Apparently Optional *****/
111     /// @dev returns the name of the token
112     string public constant name = 'Original Crypto Coin';
113     /// @dev returns the symbol of the token (e.g. 'OCC')
114     string public constant symbol = 'OCC';
115     /// @dev returns the number of decimals the tokens use
116     uint8 public constant decimals = 18;
117     //**********/
118 
119     /// @dev  returns the total token supply
120     /// @note implemented as a state variable with an automatic (compiler provided) getter
121     ///       instead of a constant (view/readonly) function.
122     uint256 public totalSupply = 100000000000000000000000000000;
123 
124     mapping (address => uint256) public balances;
125     // TODO: determine if the gas cost for handling the race condition
126     //       (outlined here: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729)
127     //       is cheaper this way (or this way: https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol#L221-L225)
128     mapping (address => mapping (address => Allowance)) public allowances;
129 
130   /// @dev creates the token
131   /// NOTE  passes tokenCofounders to base contract
132   /// see   Cofounded
133   function OriginalToken (address[] tokenCofounders,
134                           uint256 cofounderDistribution) Cofounded(tokenCofounders) public { 
135 
136     if (hasExecutedCofounderDistribution ||
137         cofounderDistribution == 0 || 
138         totalSupply < cofounderDistribution) revert();
139 
140     hasExecutedCofounderDistribution = true;
141     uint256 initialSupply = totalSupply;
142 
143     // divvy up initial token supply accross cofounders
144     // TODO: ensure each cofounder gets an equal base distribution
145 
146     for (uint8 x = 0; x < cofounders.length; x++) {
147       address cofounder = cofounders[x];
148 
149       initialSupply -= cofounderDistribution;
150       // there should be some left over for the airdrop campaign
151       // otherwise don't create this contract
152       if (initialSupply < cofounderDistribution) revert();
153       balances[cofounder] = cofounderDistribution;
154     }
155 
156     balances[msg.sender] += initialSupply;
157   }
158 
159   function transfer (address to, uint256 value) public returns (bool) {
160     return transferBalance (msg.sender, to, value);
161   }
162 
163   function transferFrom (address from, address to, uint256 value) public returns (bool success) {
164     Allowance storage allowance = allowances[from][msg.sender];
165     if (allowance.amount < value) revert();
166 
167     allowance.hasBeenPartiallyWithdrawn = true;
168     allowance.amount -= value;
169 
170     if (allowance.amount == 0) {
171       delete allowances[from][msg.sender];
172     }
173 
174     return transferBalance(from, to, value);
175   }
176 
177   event ApprovalDenied (address indexed owner, address indexed spender);
178 
179   // TODO: test with an unintialized Allowance struct
180   function approve (address spender, uint256 value) public returns (bool success) {
181     Allowance storage allowance = allowances[msg.sender][spender];
182 
183     if (value == 0) {
184       delete allowances[msg.sender][spender];
185       Approval(msg.sender, spender, value);
186       return true;
187     }
188 
189     if (allowance.hasBeenPartiallyWithdrawn) {
190       delete allowances[msg.sender][spender];
191       ApprovalDenied(msg.sender, spender);
192       return false;
193     } else {
194       allowance.amount = value;
195       Approval(msg.sender, spender, value);
196     }
197 
198     return true;
199   }
200 
201   // TODO: compare gas cost estimations between this and https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol#L39-L45
202   function transferBalance (address from, address to, uint256 value) private returns (bool) {
203     // don't burn these tokens
204     if (to == address(0) || from == to) revert();
205     // match spec and emit events on 0 value
206     if (value == 0) {
207       Transfer(msg.sender, to, value);
208       return true;
209     }
210 
211     uint256 senderBalance = balances[from];
212     uint256 receiverBalance = balances[to];
213     if (senderBalance < value) revert();
214     senderBalance -= value;
215     receiverBalance += value;
216     // overflow check (altough one could use https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol)
217     if (receiverBalance < value) revert();
218 
219     balances[from] = senderBalance;
220     balances[to] = receiverBalance;
221 
222     Transfer(from, to, value);
223     return true;
224   }
225 
226  
227   // TODO: test with an unintialized Allowance struct
228   function allowance (address owner, address spender) public constant returns (uint256 remaining) {
229     return allowances[owner][spender].amount;
230   }
231 
232   function balanceOf (address owner) public constant returns (uint256 balance) {
233     return balances[owner];
234   }
235 
236   function supportsInterface (bytes4 interfaceID) external constant returns (bool) {
237     return ((interfaceID == InterfaceSignature_ERC165) ||
238             (interfaceID == InterfaceSignature_ERC20)  ||
239             (interfaceID == InterfaceSignature_ERC20_PlusOptions));
240   }
241 }