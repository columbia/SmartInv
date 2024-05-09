1 pragma solidity ^0.4.16;
2 //pragma experimental ABIEncoderV2;
3 
4 contract HgcToken {
5 
6     string public name = "Hello Hello Coins";
7     string public symbol = "ZZZHHC";
8     uint256 public decimals = 6;
9 
10     uint256 constant initSupplyUnits = 21000000000000000;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     address owner = 0x0;
16 
17     struct Account{
18         uint256 available;
19         uint256 frozen;
20     }
21 
22     mapping (address => Account) public accounts;
23     mapping (address => mapping (address => uint256)) public allowance;
24 
25     modifier isOwner {
26         assert(owner == msg.sender);
27         _;
28     }
29 
30     modifier isRunning {
31         assert (!stopped);
32         _;
33     }
34 
35     modifier validAddress {
36         assert(0x0 != msg.sender);
37         _;
38     }
39 
40     function HgcToken() public {
41         owner = msg.sender ;
42         totalSupply = initSupplyUnits;
43 
44         Account memory account = Account({
45             available:totalSupply,
46             frozen:0
47             });
48 
49         accounts[owner] = account;
50         emit Transfer(0x0, owner, initSupplyUnits);
51     }
52 
53     function totalSupply() public constant returns (uint256 supply) {
54         return totalSupply;
55     }
56 
57     function balanceOf(address _owner) public constant returns (uint256 balance){
58         return balanceFor(accounts[_owner]);
59     }
60 
61     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
62         Account storage accountFrom = accounts[msg.sender] ;
63         require(accountFrom.available >= _value);
64 
65         Account storage accountTo = accounts[_to] ;
66         uint256 count = balanceFor(accountFrom) + balanceFor(accountTo) ;
67         require(accountTo.available + _value >= accountTo.available);
68 
69         accountFrom.available -= _value;
70         accountTo.available += _value;
71 
72         require(count == balanceFor(accountFrom) + balanceFor(accountTo)) ;
73         emit Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
78         Account storage accountFrom = accounts[_from] ;
79         require(accountFrom.available >= _value);
80 
81         Account storage accountTo = accounts[_to] ;
82         require(accountTo.available + _value >= accountTo.available);
83         require(allowance[_from][msg.sender] >= _value);
84 
85         uint256 count = balanceFor(accountFrom) + balanceFor(accountTo) ;
86 
87         accountTo.available += _value;
88         accountFrom.available -= _value;
89 
90         allowance[_from][msg.sender] -= _value;
91 
92         require(count == balanceFor(accountFrom) + balanceFor(accountTo)) ;
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
98         require(_value == 0 || allowance[msg.sender][_spender] == 0);
99         allowance[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107     function balanceFor(Account box) internal pure returns (uint256 balance){
108         return box.available + box.frozen ;
109     }
110 
111     function stop() public isOwner isRunning{
112         stopped = true;
113     }
114 
115     function start() public isOwner {
116         stopped = false;
117     }
118 
119     function setName(string _name) public isOwner {
120         name = _name;
121     }
122 
123     function burn(uint256 _value) public isRunning {
124         Account storage account = accounts[msg.sender];
125         require(account.available >= _value);
126         account.available -= _value ;
127 
128         Account storage systemAccount = accounts[0x0] ;
129         systemAccount.available += _value;
130 
131         emit Transfer(msg.sender, 0x0, _value);
132     }
133 
134     function frozen(address targetAddress , uint256 value) public isOwner returns (bool success){
135         Account storage account = accounts[targetAddress];
136 
137         require(value > 0 && account.available >= value);
138 
139         uint256 count = account.available + account.frozen;
140 
141         account.available -= value;
142         account.frozen += value;
143 
144         require(count == account.available + account.frozen);
145 
146         return true;
147     }
148 
149     function unfrozen(address targetAddress, uint256 value) public isOwner returns (bool success){
150         Account storage account = accounts[targetAddress];
151 
152         require(value > 0 && account.frozen >= value);
153 
154         uint256 count = account.available + account.frozen;
155 
156         account.available += value;
157         account.frozen -= value;
158 
159         require(count == account.available + account.frozen);
160 
161         return true;
162     }
163 
164     function accountOf(address targetAddress) public isOwner constant returns (uint256 available, uint256 locked){
165         Account storage account = accounts[targetAddress];
166         return (account.available, account.frozen);
167     }
168 
169     function accountOf() public constant returns (uint256 available, uint256 locked){
170         Account storage account = accounts[msg.sender];
171         return (account.available, account.frozen);
172     }
173 
174     function kill() public isOwner {
175         selfdestruct(owner);
176     }
177 
178 }