1 contract PreICOin {
2   string public constant symbol = "PreICO";
3   string public constant name = "PreICOin";
4   uint8 public constant decimals = 18;
5   uint256 public _totalSupply = 0;
6   bool private workingState = false;
7   bool private transferAllowed = false;
8   address public owner;
9   address private cur_coin;
10   mapping (address => uint256) balances;
11   mapping (address => mapping (address => uint256)) allowed;
12   mapping (address => uint256) private etherClients;
13   event FundsGot(address indexed _sender, uint256 _value);
14   event Transfer(address indexed _from, address indexed _to, uint256 _value);
15   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16   event ContractEnabled();
17   event ContractDisabled();
18   event TransferEnabled();
19   event TransferDisabled();
20   event CurrentCoin(address coin);
21 
22   modifier onlyOwner {
23     require(msg.sender == owner);
24     _;
25   }
26   modifier ownerAndCoin {
27     require((msg.sender == owner)||(msg.sender == cur_coin));
28     _;
29   }
30   modifier workingFlag {
31     require(workingState == true);
32     _;
33   }
34   modifier transferFlag {
35     require(transferAllowed == true);
36     _;
37   }
38 
39   function PreICOin() payable {
40     owner = msg.sender;
41     enableContract();
42   }
43   function kill() public onlyOwner {
44     require(workingState == false);
45     selfdestruct(owner);
46   }
47   function setCurrentCoin(address current) onlyOwner workingFlag {
48     cur_coin = current;
49     CurrentCoin(cur_coin);
50   }
51 
52   //work controller functions
53   function enableContract() onlyOwner {
54     workingState = true;
55     ContractEnabled();
56   }
57   function disableContract() onlyOwner {
58     workingState = false;
59     ContractDisabled();
60   }
61   function contractState() returns (string state) {
62     if (workingState) {
63       state = "Working";
64     }
65     else {
66       state = "Stopped";
67     }
68   }
69   //transfer controller functions
70   function enableTransfer() onlyOwner {
71     transferAllowed = true;
72     TransferEnabled();
73   }
74   function disableTransfer() onlyOwner {
75     transferAllowed = false;
76     TransferDisabled();
77   }
78   function transferState() returns (string state) {
79     if (transferAllowed) {
80       state = "Working";
81     }
82     else {
83       state = "Stopped";
84     }
85   }
86   //token controller functions
87   function generateTokens(address _client, uint256 _amount) ownerAndCoin workingFlag {
88     _totalSupply += _amount;
89     balances[_client] += _amount;
90   }
91   function destroyTokens(address _client, uint256 _amount) ownerAndCoin workingFlag returns (bool state) {
92     if (balances[_client] >= _amount) {
93       balances[_client] -= _amount;
94       _totalSupply -= _amount;
95       return true;
96     }
97     else {
98       return false;
99     }
100   }
101   //send ether function (working)
102   function () workingFlag payable {
103     bool ret = cur_coin.call(bytes4(keccak256("pay(address,uint256)")), msg.sender, msg.value);
104     ret;
105   }
106   function totalSupply() constant workingFlag returns (uint256 totalsupply) {
107     totalsupply = _totalSupply;
108   }
109   //ERC20 Interface
110   function balanceOf(address _owner) constant workingFlag returns (uint256 balance) {
111     return balances[_owner];
112   }
113   function transfer(address _to, uint256 _value) transferFlag workingFlag returns (bool success) {
114     if (balances[msg.sender] >= _value
115       && _value > 0
116       && balances[_to] + _value > balances[_to])
117       {
118         balances[msg.sender] -= _value;
119         balances[_to] += _value;
120         Transfer(msg.sender, _to, _value);
121         return true;
122       }
123       else {
124         return false;
125       }
126   }
127   function transferFrom(address _from, address _to, uint256 _value) transferFlag workingFlag returns (bool success) {
128     if (balances[_from] >= _value
129       && allowed[_from][msg.sender] >= _value
130       && _value > 0
131       && balances[_to] + _value > balances[_to])
132       {
133         balances[msg.sender] -= _value;
134         allowed[_from][msg.sender] -= _value;
135         balances[_to] += _value;
136         Transfer(_from, _to, _value);
137         return true;
138       }
139       else {
140         return false;
141       }
142   }
143   function approve(address _spender, uint256 _value) returns (bool success) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 }