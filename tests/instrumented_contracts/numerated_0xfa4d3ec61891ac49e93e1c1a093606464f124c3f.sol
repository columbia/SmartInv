1 pragma solidity 0.4.18;
2 
3 
4 contract iERC223Token {
5     function transfer(address to, uint value, bytes data) public returns (bool ok);
6     function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
7 }
8 
9 contract ERC223Receiver {
10     function tokenFallback( address _origin, uint _value, bytes _data) public returns (bool ok);
11 }
12 
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   function Ownable() public {
25     owner = msg.sender;
26   }
27 
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) onlyOwner public {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 
51 contract iERC20Token {
52     uint256 public totalSupply = 0;
53     /// @param _owner The address from which the balance will be retrieved
54     /// @return The balance
55     function balanceOf(address _owner) public view returns (uint256 balance);
56 
57     /// @notice send `_value` token to `_to` from `msg.sender`
58     /// @param _to The address of the recipient
59     /// @param _value The amount of token to be transferred
60     /// @return Whether the transfer was successful or not
61     function transfer(address _to, uint256 _value) public returns (bool success);
62 
63     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
64     /// @param _from The address of the sender
65     /// @param _to The address of the recipient
66     /// @param _value The amount of token to be transferred
67     /// @return Whether the transfer was successful or not
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
69 
70     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
71     /// @param _spender The address of the account able to transfer the tokens
72     /// @param _value The amount of tokens to be approved for transfer
73     /// @return Whether the approval was successful or not
74     function approve(address _spender, uint256 _value) public returns (bool success);
75 
76     /// @param _owner The address of the account owning tokens
77     /// @param _spender The address of the account able to transfer the tokens
78     /// @return Amount of remaining tokens allowed to spent
79     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
80 
81     event Transfer(address indexed _from, address indexed _to, uint256 _value);
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 
85 contract StandardToken is iERC20Token {
86 
87     using SafeMath for uint256;
88     mapping(address => uint) balances;
89     mapping (address => mapping (address => uint)) allowed;
90 
91     function transfer(address _to, uint _value) public returns (bool success) {
92         require(_to != address(0));
93         require(_value <= balances[msg.sender]);
94 
95         // SafeMath.sub will throw if there is not enough balance.
96         balances[msg.sender] = balances[msg.sender].sub(_value);
97         balances[_to] = balances[_to].add(_value);
98         Transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
103         require(_to != address(0));
104         require(_value <= balances[_from]);
105         require(_value <= allowed[_from][msg.sender]);
106 
107         balances[_from] = balances[_from].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
110         Transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint balance) {
115         return balances[_owner];
116     }
117 
118     function approve(address _spender, uint _value) public returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121         return true;
122     }
123 
124     function allowance(address _owner, address _spender) public view returns (uint remaining) {
125         return allowed[_owner][_spender];
126     }
127 
128    /**
129    * approve should be called when allowed[_spender] == 0. To increment
130    * allowed value is better to use this function to avoid 2 calls (and wait until
131    * the first transaction is mined)
132    * From MonolithDAO Token.sol
133    */
134     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
135         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
136         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
141         uint oldValue = allowed[msg.sender][_spender];
142         if (_subtractedValue > oldValue) {
143             allowed[msg.sender][_spender] = 0;
144         } else {
145             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
146         }
147         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148         return true;
149     }
150 
151 }
152 
153 
154 contract FreezableToken is iERC223Token, StandardToken, Ownable {
155 
156     event ContractTransfer(address indexed _from, address indexed _to, uint _value, bytes _data);
157 
158     bool public freezed;
159 
160     modifier canTransfer(address _transferer) {
161         require(owner == _transferer || !freezed);
162         _;
163     }
164 
165     function FreezableToken() public {
166         freezed = true;
167     }
168 
169     function transfer(address _to, uint _value, bytes _data) canTransfer(msg.sender)
170         public
171         canTransfer(msg.sender)
172         returns (bool success) {
173         //filtering if the target is a contract with bytecode inside it
174         require(super.transfer(_to, _value)); // do a normal token transfer
175         if (isContract(_to)) {
176             require(contractFallback(msg.sender, _to, _value, _data));
177         }
178         return true;
179     }
180 
181     function transferFrom(address _from, address _to, uint _value, bytes _data) public canTransfer(msg.sender) returns (bool success) {
182         require(super.transferFrom(_from, _to, _value)); // do a normal token transfer
183         if (isContract(_to)) {
184             require(contractFallback(_from, _to, _value, _data));
185         }
186         return true;
187     }
188 
189     function transfer(address _to, uint _value) canTransfer(msg.sender) public canTransfer(msg.sender) returns (bool success) {
190         return transfer(_to, _value, new bytes(0));
191     }
192 
193     function transferFrom(address _from, address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
194         return transferFrom(_from, _to, _value, new bytes(0));
195     }
196 
197     //function that is called when transaction target is a contract
198     function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool) {
199         ContractTransfer(_origin, _to, _value, _data);
200         ERC223Receiver reciever = ERC223Receiver(_to);
201         require(reciever.tokenFallback(_origin, _value, _data));
202         return true;
203     }
204 
205     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
206     function isContract(address _addr) private view returns (bool is_contract) {
207         uint length;
208         assembly { length := extcodesize(_addr) }
209         return length > 0;
210     }
211 
212     function unfreeze() public onlyOwner returns (bool){
213         freezed = false;
214         return true;
215     }
216 }
217 
218 contract JCOINToken is FreezableToken {
219 
220     string public constant name = 'JCOIN';
221     string public constant symbol = 'JCO';
222     uint8 public constant decimals = 18;
223     uint256 public constant totalSupply = 21000000 * (10 ** uint256(decimals));
224 
225     function JCOINToken() public {
226         balances[msg.sender]  = totalSupply;
227     }
228 }
229 
230 
231 library SafeMath {
232   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233     if (a == 0) {
234       return 0;
235     }
236     uint256 c = a * b;
237     assert(c / a == b);
238     return c;
239   }
240 
241   function div(uint256 a, uint256 b) internal pure returns (uint256) {
242     // assert(b > 0); // Solidity automatically throws when dividing by 0
243     uint256 c = a / b;
244     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245     return c;
246   }
247 
248   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249     assert(b <= a);
250     return a - b;
251   }
252 
253   function add(uint256 a, uint256 b) internal pure returns (uint256) {
254     uint256 c = a + b;
255     assert(c >= a);
256     return c;
257   }
258 }