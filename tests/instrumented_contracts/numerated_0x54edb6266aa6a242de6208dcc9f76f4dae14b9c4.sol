1 pragma solidity ^0.4.21;
2 
3 contract ERC20Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  *
53  * Contract source taken from Open Zeppelin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/v1.4.0/contracts/ownership/Ownable.sol
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62     * account.
63     */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77     * @dev Allows the current owner to transfer control of the contract to a newOwner.
78     * @param newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 }
86 
87 library SafeMathLib {
88     //
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93         uint256 c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     //
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         assert(b > 0 && a > 0);
101         // Solidity automatically throws when dividing by 0
102         uint256 c = a / b;
103         return c;
104     }
105 
106     //
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         assert(b <= a);
109         return a - b;
110     }
111 
112     //
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         assert(c >= a && c >= b);
116         return c;
117     }
118 }
119 
120 contract StandardToken is ERC20Token {
121     using SafeMathLib for uint;
122 
123     mapping(address => uint256) balances;
124     mapping(address => mapping(address => uint256)) allowed;
125 
126     //
127     event Transfer(address indexed from, address indexed to, uint256 value);
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 
130     //
131     function transfer(address _to, uint256 _value) public returns (bool success) {
132         require(_value > 0 && balances[msg.sender] >= _value);
133 
134         balances[msg.sender] = balances[msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         Transfer(msg.sender, _to, _value);
137         return true;
138     }
139 
140     //
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
142         require(_value > 0 && balances[_from] >= _value);
143         require(allowed[_from][msg.sender] >= _value);
144 
145         balances[_to] = balances[_to].add(_value);
146         balances[_from] = balances[_from].sub(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     //
153     function balanceOf(address _owner) public constant returns (uint256 balance) {
154         return balances[_owner];
155     }
156 
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162 
163     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166 }
167 
168 contract UJC is StandardToken, Ownable {
169 
170     string public nickName="游者链";
171     string public name = "U Journey";
172     string public symbol = "UJC";
173     uint256 public decimals = 18;
174     uint256 public INITIAL_SUPPLY = (50) * (10 ** 8) * (10 ** 18);//50
175 
176     function UJC(){
177         totalSupply = INITIAL_SUPPLY;
178         balances[msg.sender] = totalSupply;
179     }
180 
181     function() public payable {
182         revert();
183     }
184 
185 }