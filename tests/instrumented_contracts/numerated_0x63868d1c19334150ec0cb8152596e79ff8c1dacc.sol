1 pragma solidity ^0.4.23;
2 
3 /**
4  * Import SafeMath source from OpenZeppelin
5  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6  */
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * ERC 20 token
55  * https://github.com/ethereum/EIPs/issues/20
56  */
57 interface Token {
58 
59     /**
60      * @return total amount of tokens
61      * function totalSupply() public constant returns (uint256 supply);
62      * do not declare totalSupply() here, see https://github.com/OpenZeppelin/zeppelin-solidity/issues/434
63      */
64 
65     /**
66      * @param _owner The address from which the balance will be retrieved
67      * @return The balance
68      */
69     function balanceOf(address _owner) external constant returns (uint256 balance);
70 
71     /**
72      * @notice send `_value` token to `_to` from `msg.sender`
73      * @param _to The address of the recipient
74      * @param _value The amount of token to be transferred
75      * @return Whether the transfer was successful or not
76      */
77     function transfer(address _to, uint256 _value) external returns (bool success);
78 
79     /**
80      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
81      * @param _from The address of the sender
82      * @param _to The address of the recipient
83      * @param _value The amount of token to be transferred
84      * @return Whether the transfer was successful or not
85      */
86     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
87 
88     /**
89      * @notice `msg.sender` approves `_addr` to spend `_value` tokens
90      * @param _spender The address of the account able to transfer the tokens
91      * @param _value The amount of wei to be approved for transfer
92      * @return Whether the approval was successful or not
93      */
94     function approve(address _spender, uint256 _value) external returns (bool success);
95 
96     /**
97      * @param _owner The address of the account owning tokens
98      * @param _spender The address of the account able to transfer the tokens
99      * @return Amount of remaining tokens allowed to spent
100      */
101     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 
106 }
107 
108 
109 /** @title Coinweb (XCOe) contract **/
110 
111 contract Coinweb is Token {
112 
113     using SafeMath for uint256;
114 
115     string public constant name = "Coinweb";
116     string public constant symbol = "XCOe";
117     uint256 public constant decimals = 8;
118     uint256 public constant totalSupply = 2400000000 * 10**decimals;
119     address public founder = 0x51Db57ABe0Fc0393C0a81c0656C7291aB7Dc0fDe; // Founder's address
120     mapping (address => uint256) public balances;
121     mapping (address => mapping (address => uint256)) public allowed;
122 
123     /**
124      * If transfers are locked, only the contract founder can send funds.
125      * Contract starts its lifecycle in a locked transfer state.
126      */
127     bool public transfersAreLocked = true;
128 
129     /**
130      * Construct Coinweb contract.
131      * Set the founder balance as the total supply and emit Transfer event.
132      */
133     constructor() public {
134         balances[founder] = totalSupply;
135         emit Transfer(address(0), founder, totalSupply);
136     }
137 
138     /**
139      * Modifier to check whether transfers are unlocked or the
140      * founder is sending the funds
141      */
142     modifier canTransfer() {
143         require(msg.sender == founder || !transfersAreLocked);
144         _;
145     }
146 
147     /**
148      * Modifier to allow only the founder to perform some contract call.
149      */
150     modifier onlyFounder() {
151         require(msg.sender == founder);
152         _;
153     }
154 
155     function transfer(address _to, uint256 _value) public canTransfer returns (bool) {
156         require(_value <= balances[msg.sender]);
157         balances[msg.sender] = balances[msg.sender].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         emit Transfer(msg.sender, _to, _value);
160         return true;
161     }
162 
163     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool) {
164         require(_to != address(0));
165         require(_value <= balances[_from]);
166         require(_value <= allowed[_from][msg.sender]);
167 
168         balances[_from] = balances[_from].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171         emit Transfer(_from, _to, _value);
172         return true;
173     }
174 
175     function balanceOf(address _owner) public constant returns (uint256 balance) {
176         return balances[_owner];
177     }
178 
179     function approve(address _spender, uint256 _value) public returns (bool success) {
180         allowed[msg.sender][_spender] = _value;
181         emit Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190      * Set transfer locking state. Effectively locks/unlocks token sending.
191      * @param _transfersAreLocked Boolean whether transfers are locked or not
192      * @return Whether the transaction was successful or not
193      */
194     function setTransferLock(bool _transfersAreLocked) public onlyFounder returns (bool) {
195         transfersAreLocked = _transfersAreLocked;
196         return true;
197     }
198 
199     /**
200      * Contract calls revert on public method as it's not supposed to deal with
201      * Ether and should not have payable methods.
202      */
203     function() public {
204         revert();
205     }
206 }