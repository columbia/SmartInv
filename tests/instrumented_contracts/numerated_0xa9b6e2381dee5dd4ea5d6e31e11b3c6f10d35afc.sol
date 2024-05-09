1 pragma solidity ^0.4.17;
2 
3 //Slightly modified SafeMath library - includes a min function
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function min(uint a, uint b) internal pure returns (uint256) {
30     return a < b ? a : b;
31   }
32 }
33 
34 //Swap interface- descriptions can be found in TokenToTokenSwap.sol
35 interface TokenToTokenSwap_Interface {
36   function CreateSwap(uint _amount_a, uint _amount_b, bool _sender_is_long, address _senderAdd) public payable;
37   function EnterSwap(uint _amount_a, uint _amount_b, bool _sender_is_long, address _senderAdd) public;
38   function createTokens() public;
39 }
40 
41 
42 //Swap factory functions - descriptions can be found in Factory.sol
43 interface Factory_Interface {
44   function createToken(uint _supply, address _party, bool _long, uint _start_date) public returns (address created, uint token_ratio);
45   function payToken(address _party, address _token_add) public;
46   function deployContract(uint _start_date) public payable returns (address created);
47    function getBase() public view returns(address _base1, address base2);
48   function getVariables() public view returns (address oracle_addr, uint swap_duration, uint swap_multiplier, address token_a_addr, address token_b_addr);
49 }
50 
51 
52 //This is the basic wrapped Ether contract. 
53 //All money deposited is transformed into ERC20 tokens at the rate of 1 wei = 1 token
54 contract Wrapped_Ether {
55 
56   using SafeMath for uint256;
57 
58   /*Variables*/
59 
60   //ERC20 fields
61   string public name = "Wrapped Ether";
62   uint public total_supply;
63 
64 
65   //ERC20 fields
66   mapping(address => uint) balances;
67   mapping(address => mapping (address => uint)) allowed;
68 
69   /*Events*/
70 
71   event Transfer(address indexed _from, address indexed _to, uint _value);
72   event Approval(address indexed _owner, address indexed _spender, uint _value);
73   event StateChanged(bool _success, string _message);
74 
75   /*Functions*/
76 
77   //This function creates tokens equal in value to the amount sent to the contract
78   function CreateToken() public payable {
79     require(msg.value > 0);
80     balances[msg.sender] = balances[msg.sender].add(msg.value);
81     total_supply = total_supply.add(msg.value);
82   }
83 
84   /*
85   * This function 'unwraps' an _amount of Ether in the sender's balance by transferring Ether to them
86   *
87   * @param "_amount": The amount of the token to unwrap
88   */
89   function withdraw(uint _value) public {
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     total_supply = total_supply.sub(_value);
92     msg.sender.transfer(_value);
93   }
94 
95   //Returns the balance associated with the passed in _owner
96   function balanceOf(address _owner) public constant returns (uint bal) { return balances[_owner]; }
97 
98   /*
99   * Allows for a transfer of tokens to _to
100   *
101   * @param "_to": The address to send tokens to
102   * @param "_amount": The amount of tokens to send
103   */
104   function transfer(address _to, uint _amount) public returns (bool success) {
105     if (balances[msg.sender] >= _amount
106     && _amount > 0
107     && balances[_to] + _amount > balances[_to]) {
108       balances[msg.sender] = balances[msg.sender].sub(_amount);
109       balances[_to] = balances[_to].add(_amount);
110       Transfer(msg.sender, _to, _amount);
111       return true;
112     } else {
113       return false;
114     }
115   }
116 
117   /*
118   * Allows an address with sufficient spending allowance to send tokens on the behalf of _from
119   *
120   * @param "_from": The address to send tokens from
121   * @param "_to": The address to send tokens to
122   * @param "_amount": The amount of tokens to send
123   */
124   function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
125     if (balances[_from] >= _amount
126     && allowed[_from][msg.sender] >= _amount
127     && _amount > 0
128     && balances[_to] + _amount > balances[_to]) {
129       balances[_from] = balances[_from].sub(_amount);
130       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
131       balances[_to] = balances[_to].add(_amount);
132       Transfer(_from, _to, _amount);
133       return true;
134     } else {
135       return false;
136     }
137   }
138 
139   //Approves a _spender an _amount of tokens to use
140   function approve(address _spender, uint _amount) public returns (bool success) {
141     allowed[msg.sender][_spender] = _amount;
142     Approval(msg.sender, _spender, _amount);
143     return true;
144   }
145 
146   //Returns the remaining allowance of tokens granted to the _spender from the _owner
147   function allowance(address _owner, address _spender) public view returns (uint remaining) { return allowed[_owner][_spender]; }
148 }
149 
150 //The User Contract enables the entering of a deployed swap along with the wrapping of Ether.  This contract was specifically made for drct.decentralizedderivatives.org to simplify user metamask calls
151 contract UserContract{
152   TokenToTokenSwap_Interface swap;
153   Wrapped_Ether token;
154   Factory_Interface factory;
155 
156   address public factory_address;
157   address owner;
158 
159   function UserContract() public {
160       owner = msg.sender;
161   }
162 
163   //The _swapAdd is the address of the deployed contract created from the Factory contract.
164   //_amounta and _amountb are the amounts of token_a and token_b (the base tokens) in the swap.  For wrapped Ether, this is wei.
165   //_premium is a base payment to the other party for taking the other side of the swap
166   // _isLong refers to whether the sender is long or short the reference rate
167   //Value must be sent with Initiate and Enter equivalent to the _amounta(in wei) and the premium, and _amountb respectively
168 
169   function Initiate(address _swapadd, uint _amounta, uint _amountb, uint _premium, bool _isLong) payable public returns (bool) {
170     require(msg.value == _amounta + _premium);
171     swap = TokenToTokenSwap_Interface(_swapadd);
172     swap.CreateSwap.value(_premium)(_amounta, _amountb, _isLong, msg.sender);
173     address token_a_address;
174     address token_b_address;
175     (token_a_address,token_b_address) = factory.getBase();
176     token = Wrapped_Ether(token_a_address);
177     token.CreateToken.value(msg.value)();
178     bool success = token.transfer(_swapadd,msg.value);
179     return success;
180   }
181 
182   function Enter(uint _amounta, uint _amountb, bool _isLong, address _swapadd) payable public returns(bool){
183     require(msg.value ==_amountb);
184     swap = TokenToTokenSwap_Interface(_swapadd);
185     swap.EnterSwap(_amounta, _amountb, _isLong,msg.sender);
186     address token_a_address;
187     address token_b_address;
188     (token_a_address,token_b_address) = factory.getBase();
189     token = Wrapped_Ether(token_b_address);
190     token.CreateToken.value(msg.value)();
191     bool success = token.transfer(_swapadd,msg.value);
192     swap.createTokens();
193     return success;
194 
195   }
196 
197 
198   function setFactory(address _factory_address) public {
199       require (msg.sender == owner);
200     factory_address = _factory_address;
201     factory = Factory_Interface(factory_address);
202   }
203 }