1 pragma solidity ^0.4.24;
2 
3 /*
4  * Government Token (GOVT) ERC20
5  *
6  * See https://thegovernment.network/
7  */
8 
9 library SafeMath {
10     function mul(uint a, uint b) internal pure returns (uint) {
11         uint c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint a, uint b) internal pure returns (uint) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint a, uint b) internal pure returns (uint) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint a, uint b) internal pure returns (uint) {
29         uint c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 
34     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
35         return a >= b ? a : b;
36     }
37 
38     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
39         return a < b ? a : b;
40     }
41 
42     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
43         return a >= b ? a : b;
44     }
45 
46     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
47         return a < b ? a : b;
48     }
49 }
50 
51 contract GovToken {
52     using SafeMath for uint;
53 
54     string  public name = "GovToken";
55     string  public symbol = "GOVT";
56     string  public standard = "GovToken v1.0";
57     uint256 public totalSupply = 125000000 ether; // 125,000,000 GOVT
58     uint    public decimals = 18;
59     mapping(address => uint256) public balances;
60     mapping(address => mapping(address => uint256)) public allowance;
61 
62     // Events
63     event Transfer(
64         address indexed _from,
65         address indexed _to,
66         uint256 _value
67     );
68     event Approval(
69         address indexed _owner,
70         address indexed _spender,
71         uint256 _value
72     );
73 
74     // Fix for the ERC20 short address attack.
75     modifier onlyPayloadSize(uint size) {
76         if(msg.data.length < size + 4) {
77             revert();
78         }
79         _;
80     }
81 
82     // Constructor
83     constructor() public {
84         balances[msg.sender] = totalSupply;
85         emit Transfer(0x00, msg.sender, totalSupply);
86     }
87 
88     // Transfer
89     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
90         require(balances[msg.sender] >= _value);
91 
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94 
95         emit Transfer(msg.sender, _to, _value);
96 
97         return true;
98     }
99 
100     // Check the balance
101     function balanceOf(address _owner) public constant returns (uint balance) {
102         return balances[_owner];
103     }
104 
105     // Approve for another address
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         // To change the approve amount you first have to reduce the addresses`
108         //  allowance to zero by calling `approve(_spender, 0)` if it is not
109         //  already 0 to mitigate the race condition described here:
110         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111         if ((_value != 0) && (allowance[msg.sender][_spender] != 0)) revert();
112 
113         allowance[msg.sender][_spender] = _value;
114 
115         emit Approval(msg.sender, _spender, _value);
116 
117         return true;
118     }
119 
120     // Check approved allowance
121     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
122         return allowance[_owner][_spender];
123     }
124 
125     // Transfer from approved funds
126     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool success) {
127         require(_value <= balances[_from]);
128         require(_value <= allowance[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132 
133         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
134 
135         emit Transfer(_from, _to, _value);
136 
137         return true;
138     }
139 
140     // Default function - prevents accidental money loss by sending ether to the contract
141     function () payable public {
142         revert();
143     }
144 
145 }