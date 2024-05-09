1 pragma solidity ^0.4.4;
2  
3 contract Constants{
4     string constant TOKEN_NAME = "Millionaire Global";
5     string constant TOKEN_SYMBOL = "MGC";
6     uint8 constant DECIMALS = 18;
7     
8     /* TOTAL SUPPLY */
9     uint256 constant TOTAL_SUPPLY = 300000000e18;               //300,000,000
10 }
11 
12 contract ERC20Token {
13 
14     function totalSupply() constant returns (uint256 supply) {}
15 
16     function balanceOf(address _owner) constant returns (uint256 balance) {}
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {}
19 
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22     function approve(address _spender, uint256 _value) returns (bool success) {}
23 
24     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
25 
26     event Transfer(address indexed _from, address indexed _to, uint256 _value);
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29 
30 contract StandardToken is ERC20Token {
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         if (balances[msg.sender] >= _value && _value > 0) {
33             balances[msg.sender] -= _value;
34             balances[_to] += _value;
35             Transfer(msg.sender, _to, _value);
36             return true;
37         } else { return false; }
38     }
39     
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function balanceOf(address _owner) constant returns (uint256 balance) {
51         return balances[_owner];
52     }
53 
54     function approve(address _spender, uint256 _value) returns (bool success) {
55         allowed[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
61       return allowed[_owner][_spender];
62     }
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66     uint256 public totalSupply;
67 }
68  
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, reverts on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     if (_a == 0) {
76       return 0;
77     }
78 
79     uint256 c = _a * _b;
80     require(c / _a == _b);
81 
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
87   */
88   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
89     require(_b > 0); // Solidity only automatically asserts when dividing by 0
90     uint256 c = _a / _b;
91     return c;
92   }
93 
94   /**
95   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
98     require(_b <= _a);
99     uint256 c = _a - _b;
100 
101     return c;
102   }
103 
104   /**
105   * @dev Adds two numbers, reverts on overflow.
106   */
107   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
108     uint256 c = _a + _b;
109     require(c >= _a);
110 
111     return c;
112   }
113 
114   /**
115   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
116   * reverts when dividing by zero.
117   */
118   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b != 0);
120     return a % b;
121   }
122 }
123 
124 contract Ownership {
125   address public owner;
126 
127   event OwnershipRenounced(address indexed previousOwner);
128   event OwnershipTransferred(
129     address indexed previousOwner,
130     address indexed newOwner
131   );
132 
133   /**
134    * @dev The constructor of Ownership sets the original `owner` of the contract to the sender
135    * account.
136    */
137   constructor() public {
138     owner = msg.sender;
139   }
140 
141   /**
142    * @dev Throws if called by any account other than the owner.
143    */
144   modifier onlyOwner() {
145     require(msg.sender == owner);
146     _;
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address _newOwner) public onlyOwner {
154     _transferOwnership(_newOwner);
155   }
156 
157   /**
158    * @dev Transfers control of the contract to a newOwner.
159    * @param _newOwner The address to transfer ownership to.
160    */
161   function _transferOwnership(address _newOwner) internal {
162     require(_newOwner != address(0));
163     emit OwnershipTransferred(owner, _newOwner);
164     owner = _newOwner;
165   }
166 }
167 
168 contract MGCToken is StandardToken, Constants, Ownership {
169     using SafeMath for uint256;
170     /* Public variables of the token */
171 
172     string public name;                   
173     uint8 public decimals;                
174     string public symbol;
175 
176     /* Constructor */
177     constructor() public {
178         //Initialize token information
179         name = TOKEN_NAME;
180         symbol = TOKEN_SYMBOL;
181         decimals = DECIMALS;
182         
183         totalSupply = TOTAL_SUPPLY;                         //Total supply: 300,000,000 tokens
184         
185         owner = msg.sender;
186         
187         balances[owner] = TOTAL_SUPPLY;
188     }
189 
190      /* Fire when user sends ETH to Smart Contract */
191     function() public payable{
192         //Do not receive ETH in this contract
193         revert();
194     }
195 
196     /* Approves and then calls the receiving contract */
197     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200 
201         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
202         return true;
203     }
204 }