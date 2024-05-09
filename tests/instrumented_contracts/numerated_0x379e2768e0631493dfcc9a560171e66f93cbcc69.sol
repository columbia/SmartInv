1 /*
2 This file is part of the NeuroDAO Contract.
3 
4 The NeuroDAO Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The NeuroDAO Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the NeuroDAO Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 */
19 
20 
21 pragma solidity ^0.4.0;
22 
23 contract owned {
24 
25     address public owner;
26     address public newOwner;
27 
28     function owned() payable {
29         owner = msg.sender;
30     }
31     
32     modifier onlyOwner {
33         require(owner == msg.sender);
34         _;
35     }
36 
37     function changeOwner(address _owner) onlyOwner public {
38         require(_owner != 0);
39         newOwner = _owner;
40     }
41     
42     function confirmOwner() public {
43         require(newOwner == msg.sender);
44         owner = newOwner;
45         delete newOwner;
46     }
47 }
48 
49 contract Crowdsale is owned {
50     
51     uint256 public totalSupply;
52     mapping (address => uint256) public balanceOf;
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     function Crowdsale() payable owned() {
57         totalSupply = 21000000;
58         balanceOf[this] = 5000000;
59         balanceOf[owner] = totalSupply - balanceOf[this];
60         Transfer(this, owner, balanceOf[owner]);
61     }
62 
63     function () payable {
64         require(balanceOf[this] > 0);
65         uint256 tokens = 5000 * msg.value / 1000000000000000000;
66         if (tokens > balanceOf[this]) {
67             tokens = balanceOf[this];
68             uint valueWei = tokens * 1000000000000000000 / 5000;
69             msg.sender.transfer(msg.value - valueWei);
70         }
71         require(balanceOf[msg.sender] + tokens > balanceOf[msg.sender]); // overflow
72         require(tokens > 0);
73         balanceOf[msg.sender] += tokens;
74         balanceOf[this] -= tokens;
75         Transfer(this, msg.sender, tokens);
76     }
77 }
78 
79 contract Token is Crowdsale {
80     
81     string  public standard    = 'Token 0.1';
82     string  public name        = 'NeuroDAO';
83     string  public symbol      = "NDAO";
84     uint8   public decimals    = 0;
85 
86     mapping (address => mapping (address => uint256)) public allowed;
87 
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     event Burned(address indexed owner, uint256 value);
90 
91     function Token() payable Crowdsale() {}
92 
93     function transfer(address _to, uint256 _value) public {
94         require(balanceOf[msg.sender] >= _value);
95         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
96         balanceOf[msg.sender] -= _value;
97         balanceOf[_to] += _value;
98         Transfer(msg.sender, _to, _value);
99     }
100     
101     function transferFrom(address _from, address _to, uint256 _value) public {
102         require(balanceOf[_from] >= _value);
103         require(balanceOf[_to] + _value >= balanceOf[_to]); // overflow
104         require(allowed[_from][msg.sender] >= _value);
105         balanceOf[_from] -= _value;
106         balanceOf[_to] += _value;
107         allowed[_from][msg.sender] -= _value;
108         Transfer(_from, _to, _value);
109     }
110 
111     function approve(address _spender, uint256 _value) public {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114     }
115 
116     function allowance(address _owner, address _spender) public constant
117         returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120     
121     function burn(uint256 _value) public {
122         require(balanceOf[msg.sender] >= _value);
123         balanceOf[msg.sender] -= _value;
124         totalSupply -= _value;
125         Burned(msg.sender, _value);
126     }
127 }
128 
129 contract MigrationAgent {
130     function migrateFrom(address _from, uint256 _value);
131 }
132 
133 contract TokenMigration is Token {
134     
135     address public migrationAgent;
136     uint256 public totalMigrated;
137 
138     event Migrate(address indexed from, address indexed to, uint256 value);
139 
140     function TokenMigration() payable Token() {}
141 
142     // Migrate _value of tokens to the new token contract
143     function migrate(uint256 _value) external {
144         require(migrationAgent != 0);
145         require(_value != 0);
146         require(_value <= balanceOf[msg.sender]);
147         balanceOf[msg.sender] -= _value;
148         totalSupply -= _value;
149         totalMigrated += _value;
150         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
151         Migrate(msg.sender, migrationAgent, _value);
152     }
153 
154     function setMigrationAgent(address _agent) external onlyOwner {
155         require(migrationAgent == 0);
156         migrationAgent = _agent;
157     }
158 }
159 
160 contract NeuroDAO is TokenMigration {
161     function NeuroDAO() payable TokenMigration() {}
162     
163     function withdraw() public onlyOwner {
164         owner.transfer(this.balance);
165     }
166     
167     function killMe() public onlyOwner {
168         require(totalSupply == 0);
169         selfdestruct(owner);
170     }
171 }