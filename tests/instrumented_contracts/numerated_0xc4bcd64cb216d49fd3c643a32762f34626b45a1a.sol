1 pragma solidity 0.4.18;
2 
3 // File: contracts/util/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, throws on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 // File: contracts/token/ERC20.sol
52 
53 /**
54  *   @title ERC20
55  *   @dev Standart ERC20 token interface
56  */
57 contract ERC20 {
58     uint256 public totalSupply = 0;
59     mapping(address => uint256) internal balances;
60     mapping (address => mapping (address => uint256)) internal allowed;
61     function balanceOf(address _who) public view returns (uint256);
62     function transfer(address _to, uint256 _value) public returns (bool);
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
64     function approve(address _spender, uint256 _value) public returns (bool);
65     function allowance(address _owner, address _spender) public view returns (uint256);
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }
69 
70 // File: contracts/token/CosmoCoin.sol
71 
72 contract CosmoCoin is ERC20 {
73     using SafeMath for uint256;
74 
75     string public constant name = "CosmoCoin";
76     string public constant symbol = "COSM";
77     uint8 public constant decimals = 18;
78 
79     // Ico contract address
80     address public ico;
81     address public admin;
82     event Mint(address indexed to, uint256 value);
83     event Burn(address indexed from, uint256 value);
84 
85     // Disables/enables token transfers, for migration to platform mainnet
86     bool public tokensAreFrozen = true;
87 
88     // Allows execution by the ico only
89     modifier icoOnly {
90         require(msg.sender == ico || msg.sender == admin);
91         _;
92     }
93 
94     modifier tokenUnfrozen {
95         require(msg.sender == ico || msg.sender == admin || !tokensAreFrozen);
96         _;
97     }
98 
99     function CosmoCoin(address _ico, address _admin) public {
100         ico = _ico;
101         admin = _admin;
102     }
103 
104     function mintTokens(address _beneficiary, uint256 _value) external icoOnly {
105         require(_beneficiary != address(0));
106         require(_value > 0);
107         balances[_beneficiary] = balances[_beneficiary].add(_value);
108         totalSupply = totalSupply.add(_value);
109         Mint(_beneficiary, _value);
110         Transfer(0x0, _beneficiary, _value);
111     }
112 
113     function defrostTokens() external icoOnly {
114         tokensAreFrozen = false;
115     }
116 
117     function frostTokens() external icoOnly {
118         tokensAreFrozen = true;
119     }
120 
121     function burnTokens(address _investor, uint256 _value) external icoOnly {
122         require(_value > 0);
123         require(balances[_investor] >= _value);
124         totalSupply = totalSupply.sub(_value);
125         balances[_investor] = balances[_investor].sub(_value);
126         Burn(_investor, _value);
127     }
128 
129     function balanceOf(address _who) public view returns(uint256) {
130         return balances[_who];
131     }
132 
133     function transfer(address _to, uint256 _amount) public tokenUnfrozen returns(bool) {
134         require(_to != address(0));
135         require(_to != address(this));
136         require(_amount > 0);
137         require(_amount <= balances[msg.sender]);
138 
139         balances[msg.sender] = balances[msg.sender].sub(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _amount) public tokenUnfrozen returns(bool) {
146         require(_to != address(0));
147         require(_to != address(this));
148         require(_amount <= balances[_from]);
149         require(_amount <= allowed[_from][msg.sender]);
150 
151         balances[_from] = balances[_from].sub(_amount);
152         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
153         balances[_to] = balances[_to].add(_amount);
154         Transfer(_from, _to, _amount);
155         return true;
156     }
157 
158     function approve(address _spender, uint256 _amount) public returns(bool) {
159         // reduce spender's allowance to 0 then set desired value after to avoid race condition
160         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
161         allowed[msg.sender][_spender] = _amount;
162         Approval(msg.sender, _spender, _amount);
163         return true;
164     }
165 
166     function allowance(address _owner, address _spender) public view returns(uint256) {
167         return allowed[_owner][_spender];
168     }
169 }