1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
6         c = a + b;
7         require(c >= a);
8     }
9 
10     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
11         require(b <= a);
12         c = a - b;
13     }
14 }
15 
16 
17 contract ERC20Interface {
18     function totalSupply() public view returns (uint256);
19     function balanceOf(address tokenOwner) public view returns (uint256);
20     function allowance(address tokenOwner, address spender) public view returns (uint256);
21     function transfer(address to, uint256 tokens) public returns (bool);
22     function approve(address spender, uint256 tokens) public returns (bool);
23     function transferFrom(address from, address to, uint256 tokens) public returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 tokens);
26     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // Owned contract
32 // ----------------------------------------------------------------------------
33 contract Owned {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed _from, address indexed _to);
37 
38     function Owned() public {
39         owner = msg.sender;
40     }
41 
42     function transferOwnership(address _newOwner) public {
43         require(msg.sender == owner);
44         owner = _newOwner;
45     }
46 }
47 
48 
49 contract MigrationAgent {
50     function migrateFrom(address _from, uint256 _value) public;
51 }
52 
53 
54 contract CHFToken is ERC20Interface, Owned, SafeMath {
55 
56     string constant public symbol = "CHFT";
57     string constant public name = "CHF-Token";
58     uint8 constant public decimals = 18;
59 
60     //SNB M3: 2018-01, 1036.941 Mrd. CHF
61     uint256 public totalSupply = 1036941000000 * 10**uint256(decimals);
62     address public migrationAgent = address(0);
63     uint256 public totalMigrated = 0;
64 
65     mapping(address => uint256) public balances;
66     mapping(address => mapping(address => uint256)) public allowed;
67 
68     event Migrate(address indexed _from, address indexed _to, uint256 _value);
69 
70     function CHFToken() public {
71         balances[msg.sender] = totalSupply;
72         Transfer(address(0), msg.sender, totalSupply);
73     }
74 
75     function () public payable {
76         revert();
77     }
78 
79     function totalSupply() public view returns (uint256) {
80         return totalSupply;
81     }
82 
83     function balanceOf(address _tokenOwner) public view returns (uint256) {
84         return balances[_tokenOwner];
85     }
86 
87     function transfer(address _to, uint256 _tokens) public returns (bool) {
88         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
89         balances[_to] = safeAdd(balances[_to], _tokens);
90         Transfer(msg.sender, _to, _tokens);
91         return true;
92     }
93 
94     function bulkTransfer(address[] _tos, uint256[] _tokens) public returns (bool) {
95 
96         for (uint i = 0; i < _tos.length; i++) {
97             require(transfer(_tos[i], _tokens[i]));
98         }
99 
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _tokens) public returns (bool) {
104         allowed[msg.sender][_spender] = _tokens;
105         Approval(msg.sender, _spender, _tokens);
106         return true;
107     }
108 
109     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool) {
110         balances[_from] = safeSub(balances[_from], _tokens);
111         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _tokens);
112         balances[_to] = safeAdd(balances[_to], _tokens);
113         Transfer(_from, _to, _tokens);
114         return true;
115     }
116 
117     function allowance(address _tokenOwner, address _spender) public view returns (uint256) {
118         return allowed[_tokenOwner][_spender];
119     }
120 
121     /**
122     * @dev migrate functionality
123     */
124     function migrate(uint256 _value) public {
125 
126         require(migrationAgent != address(0));
127         require(_value > 0);
128         require(_value <= balances[msg.sender]);
129 
130         balances[msg.sender] = safeSub(balances[msg.sender], _value);
131         totalSupply = safeSub(totalSupply, _value);
132         totalMigrated = safeAdd(totalMigrated, _value);
133 
134         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
135         Migrate(msg.sender, migrationAgent, _value);
136     }
137 
138     /**
139     * @dev migrate functionality
140     */
141     function setMigrationAgent(address _agent) public {
142         require(msg.sender == owner);        
143         require(migrationAgent == address(0));
144 
145         migrationAgent = _agent;
146     }
147 }