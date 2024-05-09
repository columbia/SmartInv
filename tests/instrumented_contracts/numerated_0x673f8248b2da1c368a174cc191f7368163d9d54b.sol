1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal pure returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function add(uint a, uint b) internal pure returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return c;
19     }
20 }
21 
22 contract TrueGymCoin {
23     using SafeMath for uint;
24     // Public variables of the token
25     string constant public standard = "ERC20";
26     string constant public name = "True Gym Coin";
27     string constant public symbol = "TGC";
28     uint8 constant public decimals = 18;
29     uint _totalSupply = 1626666667e18;
30 
31     address public generatorAddr;
32     address public icoAddr;
33     address public preicoAddr;
34     address public privatesellAddr;
35     address public companyAddr;
36     address public teamAddr;
37     address public bountyAddr;
38 
39     // Array with all balances
40     mapping (address => uint) balances;
41     mapping (address => mapping (address => uint)) allowed;
42 
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed _owner, address indexed spender, uint value);
45     event Burned(uint amount);
46 
47     function balanceOf(address _owner) public view returns (uint balance) {
48         return balances[_owner];
49     }
50 
51     // Returns the amount which _spender is still allowed to withdraw from _owner
52     function allowance(address _owner, address _spender) private view returns (uint remaining) {
53         return allowed[_owner][_spender];
54     }
55 
56     // Get the total token supply
57     function totalSupply() public view returns (uint totSupply) {
58         totSupply = _totalSupply;
59     }
60 
61     // Initializes contract with supply defined in constants
62     constructor(address _generatorAddr, address _icoAddr, address _preicoAddr, address _privatesellAddr, address _companyAddr, address _teamAddr, address _bountyAddr) public {
63         balances[_generatorAddr] = 1301333334e18; // 80%
64         balances[_icoAddr] = 130133333e18; // 8%
65         balances[_preicoAddr] = 65066666e18; // 4%
66         balances[_privatesellAddr] = 48800000e18; // 3%
67         balances[_companyAddr] = 48800000e18; // 3%
68         balances[_teamAddr] = 16266667e18; // 1%
69         balances[_bountyAddr] = 16266667e18; // 1%
70     }
71 
72     // Send some of your tokens to a given address
73     function transfer(address _to, uint _value) public payable {
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         emit Transfer(msg.sender, _to, _value);
77     }
78 
79     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
80 
81         uint _allowed = allowed[_from][msg.sender];
82         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
83         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
84         allowed[_from][msg.sender] = _allowed.sub(_value);
85         emit Transfer(_from, _to, _value);
86         return true;
87     }
88 
89     // Approve the passed address to spend the specified amount of tokens
90     // on behalf of msg.sender.
91     function approve(address _spender, uint _value) public returns (bool) {
92         //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
94         allowed[msg.sender][_spender] = _value;
95         emit Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function burn(uint _value) public {
100         balances[msg.sender].sub(_value);
101         _totalSupply.sub(_value);
102         emit Burned(_value);
103     }
104 
105 }