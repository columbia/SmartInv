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
58     mapping(address => uint256) internal balances;
59     mapping (address => mapping (address => uint256)) internal allowed;
60     function balanceOf(address _who) public view returns (uint256);
61     function transfer(address _to, uint256 _value) public returns (bool);
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
63     function approve(address _spender, uint256 _value) public returns (bool);
64     function allowance(address _owner, address _spender) public view returns (uint256);
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 // File: contracts/token/BKchain.sol
70 
71 contract BKchain is ERC20 {
72     using SafeMath for uint256;
73     
74     address public admin;
75     string public constant name = "BKchain";
76     string public constant symbol = "BTKC";
77     uint8 public constant decimals = 18;
78     uint256 public totalSupply;
79 
80 
81     mapping(address => bool) internal blacklist;
82     event Burn(address indexed from, uint256 value);
83 
84     // Disables/enables token transfers, for migration to platform mainnet
85     // true = Can not transfers
86     // false = Can transfer
87     bool public checkTokenLock = false;
88 
89     // Allows execution by the ico only
90     modifier adminOnly {
91         require(msg.sender == admin);
92         _;
93     }
94 
95     modifier transferable {
96         require(msg.sender == admin || !checkTokenLock);
97         _;
98     }
99 
100     function BKchain(uint256 _initialSupply) public {
101         balances[msg.sender] = _initialSupply.mul(1e18);
102         totalSupply = _initialSupply.mul(1e18);
103         admin = msg.sender;
104     }
105 
106     
107     // _block
108     // True : Can not Transfer
109     // false : Can Transfer
110     function blockTransfer(bool _block) external adminOnly {
111         checkTokenLock = _block;
112     }
113 
114 
115     // _inBlackList
116     // True : Can not Transfer
117     // false : Can Transfer
118     function updateBlackList(address _addr, bool _inBlackList) external adminOnly{
119         blacklist[_addr] = _inBlackList;
120     }
121     
122 
123     function isInBlackList(address _addr) public view returns(bool){
124         return blacklist[_addr];
125     }
126     
127     function balanceOf(address _who) public view returns(uint256) {
128         return balances[_who];
129     }
130 
131     function transfer(address _to, uint256 _amount) public transferable returns(bool) {
132         require(_to != address(0));
133         require(_to != address(this));
134         require(_amount > 0);
135         require(_amount <= balances[msg.sender]);
136         require(blacklist[msg.sender] == false);
137         require(blacklist[_to] == false);
138 
139         balances[msg.sender] = balances[msg.sender].sub(_amount);
140         balances[_to] = balances[_to].add(_amount);
141         Transfer(msg.sender, _to, _amount);
142         return true;
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _amount) public transferable returns(bool) {
146         require(_to != address(0));
147         require(_to != address(this));
148         require(_amount <= balances[_from]);
149         require(_amount <= allowed[_from][msg.sender]);
150         require(blacklist[_from] == false);
151         require(blacklist[_to] == false);
152 
153         balances[_from] = balances[_from].sub(_amount);
154         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
155         balances[_to] = balances[_to].add(_amount);
156         Transfer(_from, _to, _amount);
157         return true;
158     }
159 
160     function approve(address _spender, uint256 _amount) public returns(bool) {
161         // reduce spender's allowance to 0 then set desired value after to avoid race condition
162         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
163         allowed[msg.sender][_spender] = _amount;
164         Approval(msg.sender, _spender, _amount);
165         return true;
166     }
167 
168     function allowance(address _owner, address _spender) public view returns(uint256) {
169         return allowed[_owner][_spender];
170     }
171     
172     function burn(uint256 _amount) public transferable returns (bool) {
173         require(_amount > 0);
174         require(balances[msg.sender] >= _amount);
175         
176         totalSupply = totalSupply.sub(_amount);
177         balances[msg.sender] = balances[msg.sender].sub(_amount);
178         Burn(msg.sender, _amount);
179         return true;
180     }
181 
182     function burnFrom(address _from, uint256 _amount)public transferable returns (bool) {
183         require(_amount > 0);
184         require(balances[_from] >= _amount);
185         require(allowed[_from][msg.sender]  >= _amount);
186         
187         totalSupply = totalSupply.sub(_amount);
188         balances[_from] = balances[_from].sub(_amount);
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
190         Burn(_from, _amount);
191         return true;
192     }
193 
194 }