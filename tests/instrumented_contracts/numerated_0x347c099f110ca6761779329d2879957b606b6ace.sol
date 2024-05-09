1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title IERC20Token - ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract IERC20Token {
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58 
59     function balanceOf(address _owner) public constant returns (uint256 balance);
60     function transfer(address _to, uint256 _value)  public returns (bool success);
61     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
62     function approve(address _spender, uint256 _value)  public returns (bool success);
63     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 /**
70  * @title ERC20Token - ERC20 base implementation
71  * @dev see https://github.com/ethereum/EIPs/issues/20
72  */
73 contract ERC20Token is IERC20Token {
74 
75     using SafeMath for uint256;
76 
77     
78     mapping (address => uint256) public balances;
79     mapping (address => mapping (address => uint256)) public allowed;
80 
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(balances[msg.sender] >= _value);
84 
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92         require(_to != address(0));
93         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
94 
95         balances[_to] = balances[_to].add(_value);
96         balances[_from] = balances[_from].sub(_value);
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function balanceOf(address _owner) public constant returns (uint256) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) public returns (bool) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public constant returns (uint256) {
113       return allowed[_owner][_spender];
114     }
115 }
116 
117 
118 contract JointToken is ERC20Token {
119 
120     uint256 public constant RewardPoolAmount = 500000000;
121     uint256 public constant ICOInvestorsAmount = 100000000;
122     uint256 public constant EarlyAdoptersAmount = 5000000;
123     uint256 public constant LaunchPartnersAmount = 5000000;
124     uint256 public constant TeamMembersAmount = 5000000;
125     uint256 public constant MarketingDevelopmentAmount = 1000000;
126 
127     uint256 public constant EstimatedICOBonusAmount = 14000000;
128 
129     address public constant RewardPoolAddress = 0xEb1FAef9068b6B8f46b50245eE877dA5b03D98C9;
130     address public constant ICOAddress = 0x29eC21157f19F7822432e87ef504D366c24E1D8B;
131     address public constant EarlyAdoptersAddress = 0x5DD184EC1fB992c158EA15936e57A20C70761f84;
132     address public constant LaunchPartnersAddress = 0x4A1943b2aB647a5150ECEc16D6Bf695f10D94E0E;
133     address public constant TeamMembersAddress = 0x5a5b2715121e762B43D9A657E10AE93A5629Fe28;
134     address public constant MarketingDevelopmentAddress = 0x5E1D0513Bc39fBD6ECd94447e627919Bbf575eC0;
135     
136     uint256 public  decimalPlace;
137 
138 
139     function JointToken() public {
140         name = "JOINT";
141         symbol = "JOINT";
142         decimals = 18;
143 
144         decimalPlace = 10**uint256(decimals);
145         totalSupply = 616000000*decimalPlace;
146         distributeTokens();
147     }
148 
149     function distributeTokens () private {
150         balances[RewardPoolAddress] = (RewardPoolAmount.sub(EstimatedICOBonusAmount)).mul(decimalPlace);
151         balances[ICOAddress] = (ICOInvestorsAmount.add(EstimatedICOBonusAmount)).mul(decimalPlace);
152         balances[EarlyAdoptersAddress] = EarlyAdoptersAmount.mul(decimalPlace);
153         balances[LaunchPartnersAddress] = LaunchPartnersAmount.mul(decimalPlace);
154         balances[TeamMembersAddress] = TeamMembersAmount.mul(decimalPlace);
155         balances[MarketingDevelopmentAddress] = MarketingDevelopmentAmount.mul(decimalPlace);
156     }
157 
158 }