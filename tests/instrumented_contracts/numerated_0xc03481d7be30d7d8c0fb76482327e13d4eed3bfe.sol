1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract IMigrationContract {
4     function migrate(address addr, uint256 nas) public returns (bool success);
5 }
6 
7 library SafeMath {
8     function add(uint256 x, uint256 y) internal pure returns(uint256) {
9         uint256 z = x + y;
10         assert((z >= x) && (z >= y));
11         return z;
12     }
13 
14     function sub(uint256 x, uint256 y) internal pure returns(uint256) {
15         assert(x >= y);
16         uint256 z = x - y;
17         return z;
18     }
19 
20     function mul(uint256 x, uint256 y) internal pure returns(uint256) {
21         uint256 z = x * y;
22         assert((x == 0)||(z/x == y));
23         return z;
24     }
25 }
26 
27 contract Token {
28     uint256 public totalSupply;
29     function balanceOf(address _owner) public view returns (uint256 balance);
30     function transfer(address _to, uint256 _value) public returns (bool success);
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32     function approve(address _spender, uint256 _value) public returns (bool success);
33     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 /// ERC 20 token
39 contract StandardToken is Token {
40     using SafeMath for uint256;
41     
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         require(_to != address(0x0), "_to == 0");
44         require(balances[msg.sender] >= _value, "not enough to pay");
45 
46         balances[msg.sender] = balances[msg.sender].sub(_value);
47         balances[_to] = balances[_to].add(_value);
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         require(_from != address(0x0), "_from == 0");
54         require(_to != address(0x0), "_to == 0");
55         require((balances[_from] >= _value && allowed[_from][msg.sender] >= _value), "not enough to pay");
56 
57         balances[_to] = balances[_to].add(_value);
58         balances[_from] = balances[_from].sub(_value);
59         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         require(_spender != address(0x0), "_spender == 0");
70 
71         allowed[msg.sender][_spender] = _value;
72         emit Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 }
83 
84 contract BitDiskToken is StandardToken {
85 
86     // metadata
87     string  public constant name = "BitDisk";
88     string  public constant symbol = "BTD";
89     uint8 public constant decimals = 18;
90     string  public version = "1.0";
91 
92     // contracts
93     address public ethFundDeposit;              // deposit address for ETH for BTD team
94     address public newContractAddr;
95 
96     uint256 public tokenMigrated = 0;           // total migrated tokens
97 
98     // events
99     event AllocateToken(address indexed _to, uint256 _value);
100     event IssueToken(address indexed _to, uint256 _value);
101     event IncreaseSupply(uint256 _value);
102     event DecreaseSupply(uint256 _value);
103     event Migrate(address indexed _to, uint256 _value);
104     event CreateBTD(address indexed _to, uint256 _value);
105 
106     function formatDecimals(uint256 _value) internal pure returns (uint256) {
107         return _value * (10 ** uint256(decimals));
108     }
109 
110     // constructor
111     constructor() public {
112         ethFundDeposit = msg.sender;
113 
114         totalSupply = formatDecimals(2800 * (10 ** 6)); // // two billion and one hundred million and never raised
115         balances[msg.sender] = totalSupply;
116         emit CreateBTD(ethFundDeposit, totalSupply);
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == ethFundDeposit, "auth fail"); 
121         _;
122     }
123 
124     /// new owner
125     function changeOwner(address _newFundDeposit) external onlyOwner {
126         require(_newFundDeposit != address(0x0), "error addr");
127         require(_newFundDeposit != ethFundDeposit, "not changed");
128 
129         ethFundDeposit = _newFundDeposit;
130     }
131 
132     /// update token
133     function setMigrateContract(address _newContractAddr) external onlyOwner {
134         require(_newContractAddr != address(0x0), "error addr");
135         require(_newContractAddr != newContractAddr, "not changed");
136 
137         newContractAddr = _newContractAddr;
138     }
139 
140     function migrate() external {
141         require(newContractAddr != address(0x0), "no newContractAddr");
142 
143         uint256 tokens = balances[msg.sender];
144         require(tokens != 0, "no tokens to migrate");
145 
146         balances[msg.sender] = 0;
147         tokenMigrated = tokenMigrated.add(tokens);
148 
149         IMigrationContract newContract = IMigrationContract(newContractAddr);
150         require(newContract.migrate(msg.sender, tokens), "migrate fail");
151 
152         emit Migrate(msg.sender, tokens);
153     }
154 
155     function withdrawEther(uint256 amount) external {
156         require(msg.sender == ethFundDeposit, "not owner");
157         msg.sender.transfer(amount);
158     }
159 	
160 	// can accept ether
161     function() external payable {
162     }
163 }