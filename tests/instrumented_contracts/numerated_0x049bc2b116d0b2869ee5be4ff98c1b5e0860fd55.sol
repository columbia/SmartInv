1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * Math operations with safety checks
7  * By OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/contracts/SafeMath.sol
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal returns (uint256) {
11     uint256 c = a * b;
12     assert(a == 0 || c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50 }
51 
52 
53 
54  contract ContractReceiver{
55     function tokenFallback(address _from, uint256 _value, bytes  _data) external;
56 }
57 
58 
59 //Basic ERC23 token, backward compatible with ERC20 transfer function.
60 //Based in part on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
61 contract ERC23BasicToken {
62     using SafeMath for uint256;
63     uint256 public totalSupply;
64     mapping(address => uint256) balances;
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
67 
68     function tokenFallback(address _from, uint256 _value, bytes  _data) external {
69         throw;
70     }
71 
72     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
73 
74         //Standard ERC23 transfer function
75 
76         if(isContract(_to)) {
77             transferToContract(_to, _value, _data);
78         }
79         else {
80             transferToAddress(_to, _value, _data);
81         }
82         return true;
83     }
84 
85     function transfer(address _to, uint256 _value) {
86 
87         //standard function transfer similar to ERC20 transfer with no _data
88         //added due to backwards compatibility reasons
89 
90         bytes memory empty;
91         if(isContract(_to)) {
92             transferToContract(_to, _value, empty);
93         }
94         else {
95             transferToAddress(_to, _value, empty);
96         }
97     }
98 
99     function transferToAddress(address _to, uint256 _value, bytes _data) internal {
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         Transfer(msg.sender, _to, _value, _data);
104     }
105 
106     function transferToContract(address _to, uint256 _value, bytes _data) internal {
107         balances[msg.sender] = balances[msg.sender].sub( _value);
108         balances[_to] = balances[_to].add( _value);
109         ContractReceiver receiver = ContractReceiver(_to);
110         receiver.tokenFallback(msg.sender, _value, _data);
111         Transfer(msg.sender, _to, _value);
112         Transfer(msg.sender, _to, _value, _data);
113     }
114 
115     function balanceOf(address _owner) constant returns (uint256 balance) {
116         return balances[_owner];
117     }
118 
119     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
120     function isContract(address _addr) returns (bool is_contract) {
121           uint256 length;
122           assembly {
123               //retrieve the size of the code on target address, this needs assembly
124               length := extcodesize(_addr)
125           }
126           if(length>0) {
127               return true;
128           }
129           else {
130               return false;
131           }
132     }
133 }
134 
135 
136  // Standard ERC23 token, backward compatible with ERC20 standards.
137  // Based on code by open-zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity.git
138 contract ERC23StandardToken is ERC23BasicToken {
139     mapping (address => mapping (address => uint256)) allowed;
140     event Approval (address indexed owner, address indexed spender, uint256 value);
141 
142     function transferFrom(address _from, address _to, uint256 _value) {
143         var _allowance = allowed[_from][msg.sender];
144 
145         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146         // if (_value > _allowance) throw;
147 
148         balances[_to] = balances[_to].add(_value);
149         balances[_from] = balances[_from].sub(_value);
150         allowed[_from][msg.sender] = _allowance.sub(_value);
151         Transfer(_from, _to, _value);
152     }
153 
154     function approve(address _spender, uint256 _value) {
155 
156         // To change the approve amount you first have to reduce the addresses`
157         //  allowance to zero by calling `approve(_spender, 0)` if it is not
158         //  already 0 to mitigate the race condition described here:
159         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
161 
162         allowed[msg.sender][_spender] = _value;
163         Approval(msg.sender, _spender, _value);
164     }
165 
166     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167         return allowed[_owner][_spender];
168     }
169 
170 }
171 /**
172  * @title Ownable
173  * @dev The Ownable contract has an owner address, and provides basic authorization control
174  * functions, this simplifies the implementation of "user permissions".
175  */
176 contract Ownable {
177   address public owner;
178   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179   /**
180    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
181    * account.
182    */
183   function Ownable() {
184     owner = msg.sender;
185   }
186   /**
187    * @dev Throws if called by any account other than the owner.
188    */
189   modifier onlyOwner() {
190     require(msg.sender == owner);
191     _;
192   }
193   /**
194    * @dev Allows the current owner to transfer control of the contract to a newOwner.
195    * @param newOwner The address to transfer ownership to.
196    */
197   function transferOwnership(address newOwner) onlyOwner public {
198     require(newOwner != address(0));
199     OwnershipTransferred(owner, newOwner);
200     owner = newOwner;
201   }
202 }
203 
204 /**
205  * @title Mintable token
206  * @dev Simple ERC20 Token example, with mintable token creation
207  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
208  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
209  */
210 contract MintableToken is ERC23StandardToken, Ownable {
211   event Mint(address indexed to, uint256 amount);
212   event MintFinished();
213   bool public mintingFinished = false;
214   modifier canMint() {
215     require(!mintingFinished);
216     _;
217   }
218   /**
219    * @dev Function to mint tokens
220    * @param _to The address that will receive the minted tokens.
221    * @param _amount The amount of tokens to mint.
222    * @return A boolean that indicates if the operation was successful.
223    */
224   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
225     totalSupply = totalSupply.add(_amount);
226     balances[_to] = balances[_to].add(_amount);
227     Mint(_to, _amount);
228     Transfer(0x0, _to, _amount);
229     return true;
230   }
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235   function finishMinting() onlyOwner public returns (bool) {
236     mintingFinished = true;
237     MintFinished();
238     return true;
239   }
240 }
241 
242 contract RichClassic is MintableToken { 
243   string public name="RichClassic";
244   string public symbol="RRGC";
245   uint8 public decimals=18;
246 
247 }