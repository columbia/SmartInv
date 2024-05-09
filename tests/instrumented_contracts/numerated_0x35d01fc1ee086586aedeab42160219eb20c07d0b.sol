1 pragma solidity ^0.4.16; 
2     contract owned {
3         address public owner;
4 
5         function owned() {
6             owner = msg.sender;
7         }
8 
9         modifier onlyOwner {
10             require(msg.sender == owner);
11             _;
12         }
13 
14         function transferOwnership(address newOwner) onlyOwner {
15             owner = newOwner;
16         }
17     }
18 		
19 	contract Crowdsale is owned {
20     
21     uint256 public totalSupply;
22     mapping (address => uint256) public balanceOf;
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     function Crowdsale() payable owned() {
27         totalSupply = 400000000;
28         balanceOf[this] = 400000000;
29     }
30 
31     function () payable {
32         require(balanceOf[this] > 0);
33         uint256 tokens = 1000000 * msg.value / 1000000000000000000;
34         if (tokens > balanceOf[this]) {
35             tokens = balanceOf[this];
36             uint valueWei = tokens * 1000000000000000000 / 1000000;
37             msg.sender.transfer(msg.value - valueWei);
38         }
39         require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]); // overflow
40         require(tokens > 0);
41         balanceOf[msg.sender] += tokens;
42         balanceOf[this] -= tokens;
43         Transfer(this, msg.sender, tokens);
44     }
45 }
46 
47 contract Token is Crowdsale {
48     
49    
50     string  public name        = 'Minedozer';
51     string  public symbol      = "MDZ";
52     uint8   public decimals    = 0;
53 
54     mapping (address => mapping (address => uint256)) public allowed;
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     event Burned(address indexed owner, uint256 value);
58 
59     function Token() payable Crowdsale() {}
60 
61     function transfer(address _to, uint256 _value) public {
62         require(balanceOf[msg.sender] >= _value);
63         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
64         balanceOf[msg.sender] -= _value;
65         balanceOf[_to] += _value;
66         Transfer(msg.sender, _to, _value);
67     }
68     
69     function transferFrom(address _from, address _to, uint256 _value) public {
70         require(balanceOf[_from] >= _value);
71         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
72         require(allowed[_from][msg.sender] >= _value);
73         balanceOf[_from] -= _value;
74         balanceOf[_to] += _value;
75         allowed[_from][msg.sender] -= _value;
76         Transfer(_from, _to, _value);
77     }
78 
79     function approve(address _spender, uint256 _value) public {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82     }
83 
84     function allowance(address _owner, address _spender) public constant
85         returns (uint256 remaining) {
86         return allowed[_owner][_spender];
87     }
88     
89     function burn(uint256 _value) public {
90         require(balanceOf[msg.sender] >= _value);
91         balanceOf[msg.sender] -= _value;
92         totalSupply -= _value;
93         Burned(msg.sender, _value);
94     }
95 }
96 contract MigrationAgent {
97     function migrateFrom(address _from, uint256 _value);
98 }
99 
100 contract TokenMigration is Token {
101     
102     address public migrationAgent;
103     uint256 public totalMigrated;
104 
105     event Migrate(address indexed from, address indexed to, uint256 value);
106 
107     function TokenMigration() payable Token() {}
108 
109     // Migrate _value of tokens to the new token contract
110     function migrate(uint256 _value) external {
111         require(migrationAgent != 0);
112         require(_value != 0);
113         require(_value <= balanceOf[msg.sender]);
114         balanceOf[msg.sender] -= _value;
115         totalSupply -= _value;
116         totalMigrated += _value;
117         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
118         Migrate(msg.sender, migrationAgent, _value);
119     }
120 
121     function setMigrationAgent(address _agent) external onlyOwner {
122         require(migrationAgent == 0);
123         migrationAgent = _agent;
124     }
125 }
126 
127 contract Minedozer is TokenMigration {
128     function Minedozer() payable TokenMigration() {}
129     
130     function withdraw() public onlyOwner {
131         owner.transfer(this.balance);
132     }
133     
134     function killMe() public onlyOwner {
135         require(totalSupply == 0);
136         selfdestruct(owner);
137     }
138 }