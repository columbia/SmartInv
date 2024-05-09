1 pragma solidity >0.5.0;
2 // ------------------------------------------------------------------------
3 // TEN Token by Tentech Group OU Limited.
4 // An ERC20 standard
5 //
6 // author: Tentech Group Team
7 // contact: Jason Nguyen jason.ng@tentech.io
8 //--------------------------------------------------------------------------
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67     
68     function max(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a>b) return a;
70         return b;
71     }
72 }
73 contract ERC20RcvContract { 
74     function tokenFallback(address _from, uint _value) public;
75 }
76 
77 contract ERC20  {
78 
79     using SafeMath for uint;
80 
81     /// @notice check if the address  `_addr` is a contract or not
82     /// @param _addr The address of the recipient
83     function isContract(address _addr) private view returns (bool) {
84         uint length;
85          assembly {
86              //retrieve the size of the code on target address, this needs assembly
87              length := extcodesize(_addr)
88          }
89          return (length>0);
90     }
91  
92     /// @notice send `_value` token to `_to` from `msg.sender`
93     /// @param _to The address of the recipient
94     /// @param _value The amount of token to be transferred
95     function transfer(address _to, uint _value) public returns (bool){
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         if(isContract(_to)) {
100             ERC20RcvContract receiver = ERC20RcvContract(_to);
101             receiver.tokenFallback(msg.sender, _value);
102         }
103         emit Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint _value) public returns (bool){
108 
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112 
113         if(isContract(_to)) {
114             ERC20RcvContract receiver = ERC20RcvContract(_to);
115             receiver.tokenFallback(msg.sender, _value);
116         }
117         emit Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     function balanceOf(address _owner) public view returns (uint balance) {
122         return balances[_owner];
123     }
124 
125     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
126     /// @param _spender The address of the account able to transfer the tokens
127     /// @param _value The amount of wei to be approved for transfer
128     /// @return Whether the approval was successful or not
129     function approve(address _spender, uint _value) public returns (bool){
130         allowed[msg.sender][_spender] = _value;
131         emit Approval(msg.sender, _spender, _value);
132         return true;
133     }
134 
135     /// @param _owner The address of the account owning tokens
136     /// @param _spender The address of the account able to transfer the tokens
137     /// @return Amount of remaining tokens allowed to spent
138     function allowance(address _owner, address _spender) public view returns (uint remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142     mapping (address => uint) balances;
143     mapping (address => mapping (address => uint)) allowed;
144     uint public totalSupply;
145 
146     event Transfer(address indexed _from, address indexed _to, uint _value);
147     event Approval(address indexed _owner, address indexed _spender, uint _value);
148 }
149 
150 contract TenToken is ERC20 { 
151 
152     string public symbol="GDEM";       
153     string public name ="TEN Token";
154 
155     uint8 public decimals=6;          
156     address public walletOwner;
157 
158     constructor() public 
159     {
160         totalSupply = 10**9 * (10**6);  //1 Billion token
161         balances[msg.sender] = totalSupply;               
162         walletOwner = msg.sender;
163         // [EPI20 standard] https://eips.ethereum.org/EIPS/eip-20
164         // A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
165         emit Transfer(0x0000000000000000000000000000000000000000, walletOwner, totalSupply);
166     }
167 
168     // Receice Ether in exchange for tokens 
169     function() external payable {
170         revert();
171     }
172 }