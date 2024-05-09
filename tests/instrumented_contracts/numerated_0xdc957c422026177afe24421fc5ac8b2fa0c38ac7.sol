1 pragma solidity ^0.4.16;
2 
3 contract HgcToken {
4 
5     string public name = "Happy Guess Chain Coin";
6     string public symbol = "HGCC";
7     uint256 public decimals = 6;
8 
9     uint256 constant initSupplyUnits = 2100000000000000;
10 
11     uint256 public totalSupply = 0;
12     bool public stopped = false;
13 
14     address owner = 0x0;
15 
16     struct Account{
17         uint256 available;
18         uint256 frozen;
19     }
20 
21     mapping (address => Account) public accounts;
22     mapping (address => mapping (address => uint256)) public allowance;
23 
24     modifier isOwner {
25         assert(owner == msg.sender);
26         _;
27     }
28 
29     modifier isRunning {
30         assert (!stopped);
31         _;
32     }
33 
34     modifier validAddress {
35         assert(0x0 != msg.sender);
36         _;
37     }
38 
39     function HgcToken() public {
40         owner = msg.sender ;
41         totalSupply = initSupplyUnits;
42 
43         Account memory account = Account({
44             available:totalSupply,
45             frozen:0
46             });
47 
48         accounts[owner] = account;
49         emit Transfer(0x0, owner, initSupplyUnits);
50     }
51 
52     function totalSupply() public constant returns (uint256 supply) {
53         return totalSupply;
54     }
55 
56     function balanceOf(address _owner) public constant returns (uint256 balance){
57         return balanceFor(accounts[_owner]);
58     }
59 
60     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
61         Account storage accountFrom = accounts[msg.sender] ;
62         require(accountFrom.available >= _value);
63 
64         Account storage accountTo = accounts[_to] ;
65         uint256 count = balanceFor(accountFrom) + balanceFor(accountTo) ;
66         require(accountTo.available + _value >= accountTo.available);
67 
68         accountFrom.available -= _value;
69         accountTo.available += _value;
70 
71         require(count == balanceFor(accountFrom) + balanceFor(accountTo)) ;
72         emit Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
77         Account storage accountFrom = accounts[_from] ;
78         require(accountFrom.available >= _value);
79 
80         Account storage accountTo = accounts[_to] ;
81         require(accountTo.available + _value >= accountTo.available);
82         require(allowance[_from][msg.sender] >= _value);
83 
84         uint256 count = balanceFor(accountFrom) + balanceFor(accountTo) ;
85 
86         accountTo.available += _value;
87         accountFrom.available -= _value;
88 
89         allowance[_from][msg.sender] -= _value;
90 
91         require(count == balanceFor(accountFrom) + balanceFor(accountTo)) ;
92         emit Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
97         require(_value == 0 || allowance[msg.sender][_spender] == 0);
98         allowance[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 
106     function balanceFor(Account box) internal pure returns (uint256 balance){
107         return box.available + box.frozen ;
108     }
109 
110     function stop() public isOwner isRunning{
111         stopped = true;
112     }
113 
114     function start() public isOwner {
115         stopped = false;
116     }
117 
118     function setName(string _name) public isOwner {
119         name = _name;
120     }
121 
122     function burn(uint256 _value) public isRunning {
123         Account storage account = accounts[msg.sender];
124         require(account.available >= _value);
125         account.available -= _value ;
126 
127         Account storage systemAccount = accounts[0x0] ;
128         systemAccount.available += _value;
129 
130         emit Transfer(msg.sender, 0x0, _value);
131     }
132 
133     function frozen(address targetAddress , uint256 value) public isOwner returns (bool success){
134         Account storage account = accounts[targetAddress];
135 
136         require(value > 0 && account.available >= value);
137 
138         uint256 count = account.available + account.frozen;
139 
140         account.available -= value;
141         account.frozen += value;
142 
143         require(count == account.available + account.frozen);
144 
145         return true;
146     }
147 
148     function unfrozen(address targetAddress, uint256 value) public isOwner returns (bool success){
149         Account storage account = accounts[targetAddress];
150 
151         require(value > 0 && account.frozen >= value);
152 
153         uint256 count = account.available + account.frozen;
154 
155         account.available += value;
156         account.frozen -= value;
157 
158         require(count == account.available + account.frozen);
159 
160         return true;
161     }
162 
163     function accountOf(address targetAddress) public isOwner constant returns (uint256 available, uint256 locked){
164         Account storage account = accounts[targetAddress];
165         return (account.available, account.frozen);
166     }
167 
168     function accountOf() public constant returns (uint256 available, uint256 locked){
169         Account storage account = accounts[msg.sender];
170         return (account.available, account.frozen);
171     }
172 
173 }