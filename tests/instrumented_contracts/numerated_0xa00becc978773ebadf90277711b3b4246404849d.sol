1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 contract Haltable is Ownable {
47   bool public halted = false;
48 
49   modifier stopInEmergency {
50     require(!halted);
51     _;
52   }
53 
54   modifier stopNonOwnersInEmergency {
55     require((msg.sender==owner) || !halted);
56     _;
57   }
58 
59   modifier onlyInEmergency {
60     require(halted);
61     _;
62   }
63 
64   // called by the owner on emergency, triggers stopped state
65   function halt() external onlyOwner {
66     halted = true;
67   }
68 
69   // called by the owner on end of emergency, returns to normal state
70   function unhalt() external onlyOwner onlyInEmergency {
71     halted = false;
72   }
73 
74 }
75 
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return c;
88   }
89 
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 
103 contract Token {
104     /* This is a slight change to the ERC20 base standard.
105     function totalSupply() constant returns (uint256 supply);
106     is replaced with:
107     uint256 public totalSupply;
108     This automatically creates a getter function for the totalSupply.
109     This is moved to the base contract since public getter functions are not
110     currently recognised as an implementation of the matching abstract
111     function by the compiler.
112     */
113     /// total amount of tokens
114     uint256 public totalSupply;
115 
116     /// @param _owner The address from which the balance will be retrieved
117     /// @return The balance
118     function balanceOf(address _owner) public constant returns (uint256 balance);
119 
120     /// @notice send `_value` token to `_to` from `msg.sender`
121     /// @param _to The address of the recipient
122     /// @param _value The amount of token to be transferred
123     /// @return Whether the transfer was successful or not
124     function transfer(address _to, uint256 _value) public returns (bool success);
125 
126     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
127     /// @param _from The address of the sender
128     /// @param _to The address of the recipient
129     /// @param _value The amount of token to be transferred
130     /// @return Whether the transfer was successful or not
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
132 
133     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
134     /// @param _spender The address of the account able to transfer the tokens
135     /// @param _value The amount of tokens to be approved for transfer
136     /// @return Whether the approval was successful or not
137     function approve(address _spender, uint256 _value) public returns (bool success);
138 
139     /// @param _owner The address of the account owning tokens
140     /// @param _spender The address of the account able to transfer the tokens
141     /// @return Amount of remaining tokens allowed to spent
142     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }
147 
148 contract TakeProfitToken is Token, Haltable {
149     using SafeMath for uint256;
150 
151 
152     string constant public name = "TakeProfit";
153     uint8 constant public decimals = 8;
154     string constant public symbol = "XTP";       
155     string constant public version = "1.1";
156 
157 
158     uint256 constant public UNIT = uint256(10)**decimals;
159     uint256 public totalSupply = 10**8 * UNIT;
160 
161     uint256 constant MAX_UINT256 = 2**256 - 1; // Used for allowance: this value mean infinite allowance
162 
163     function TakeProfitToken() public {
164         balances[owner] = totalSupply;
165     }
166 
167 
168     function transfer(address _to, uint256 _value) public stopInEmergency returns (bool success) {
169         require(_to != address(0));
170         require(balances[msg.sender] >= _value);
171         balances[msg.sender] = balances[msg.sender].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         Transfer(msg.sender, _to, _value);
174         return true;
175     }
176 
177     function transferFrom(address _from, address _to, uint256 _value) public stopInEmergency returns (bool success) {
178         require(_to != address(0));
179         uint256 allowance = allowed[_from][msg.sender];
180         require(balances[_from] >= _value && allowance >= _value);
181         balances[_to] = balances[_to].add(_value);
182         balances[_from] = balances[_from].sub(_value);
183         if (allowance < MAX_UINT256) {
184             allowed[_from][msg.sender] = allowance.sub(_value);
185         }
186         Transfer(_from, _to, _value);
187         return true;
188     }
189 
190     function balanceOf(address _owner) constant public returns (uint256 balance) {
191         return balances[_owner];
192     }
193 
194     function approve(address _spender, uint256 _value) public stopInEmergency returns (bool success) {
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
201       return allowed[_owner][_spender];
202     }
203 
204     mapping (address => uint256) balances;
205     mapping (address => mapping (address => uint256)) allowed;
206 }