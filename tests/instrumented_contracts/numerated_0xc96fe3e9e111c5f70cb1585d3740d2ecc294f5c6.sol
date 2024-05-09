1 pragma solidity ^0.4.20;
2 
3 
4 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
5 
6 contract Token{
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) public constant returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12 
13     function approve(address _spender, uint256 _value) public returns (bool success);
14 
15     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     event Burn(address indexed from, uint256 value);
20 }
21 
22 contract HammerChain is Token {
23 
24     address  owner;  // owner address
25     address INCENTIVE_POOL_ADDR = 0x0;
26     address FOUNDATION_POOL_ADDR = 0xE4ae52AeC7359c145f4aEeBEFA59fC6F181a4e43;
27     address COMMUNITY_POOL_ADDR = 0x611C1e09589d658c6881B3966F42bEA84d0Fab82;
28     address FOUNDERS_POOL_ADDR = 0x59556f481FF8d1f0C55926f981070Aa8f767922b;
29 
30     bool releasedFoundation = false;
31     bool releasedCommunity = false;
32     uint256  timeIncentive = 0x0;
33     uint256 limitIncentive=0x0;
34     uint256 timeFounders= 0x0;
35     uint256 limitFounders=0x0;
36 
37     string public name;                 //HRC name 
38     uint8 public decimals;              //token decimals with HRC
39     string public symbol;               //token symbol with HRC
40 
41     mapping (address => uint256) balances;
42     mapping (address => mapping (address => uint256)) allowed;
43 
44     modifier onlyOwner { 
45         require(msg.sender == owner);
46         _;
47     }
48 
49 
50     function HammerChain() public {
51         owner = msg.sender;
52         uint8 _decimalUnits = 18; // 18 decimals is the strongly suggested default, avoid changing it
53         totalSupply = 512000000 * 10 ** uint256(_decimalUnits); // iniliatized total supply token
54         balances[msg.sender] = totalSupply; 
55 
56         name = "HammerChain";
57         decimals = _decimalUnits;
58         symbol = "HRC";
59     }
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         // default is totalSupply not of out (2^256 - 1).
63         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
64         require(_to != 0x0);
65         balances[msg.sender] -= _value;
66         balances[_to] += _value;
67         emit Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         require(_to != 0x0);
73         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
74         balances[_to] += _value;
75         balances[_from] -= _value; 
76         allowed[_from][msg.sender] -= _value;
77         emit Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool success)   
86     { 
87         allowed[msg.sender][_spender] = _value;
88         emit Approval(msg.sender, _spender, _value);
89         return true;
90     }
91 
92     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
93         return allowed[_owner][_spender];//allow _spender from _owner send out token
94     }
95 
96     function sendIncentive() onlyOwner public{
97         require(limitIncentive < totalSupply/2);
98         if (timeIncentive < now){
99             if (timeIncentive == 0x0){
100                 transfer(INCENTIVE_POOL_ADDR,totalSupply/10);
101                 limitIncentive += totalSupply/10;
102             }
103             else{
104                 transfer(INCENTIVE_POOL_ADDR,totalSupply/20);
105                 limitIncentive += totalSupply/20;
106             }
107             timeIncentive = now + 365 days;
108         }
109     }
110 
111     function sendFounders() onlyOwner public{
112         require(limitFounders < totalSupply/20);
113         if (timeFounders== 0x0 || timeFounders < now){
114             transfer(FOUNDERS_POOL_ADDR,totalSupply/100);
115             timeFounders = now + 365 days;
116             limitFounders += totalSupply/100;
117         }
118     }
119 
120     function sendFoundation() onlyOwner public{
121         require(releasedFoundation == false);
122         transfer(FOUNDATION_POOL_ADDR,totalSupply/4);
123         releasedFoundation = true;
124     }
125 
126 
127     function sendCommunity() onlyOwner public{
128         require(releasedCommunity == false);
129         transfer(COMMUNITY_POOL_ADDR,totalSupply/5);
130         releasedCommunity = true;
131     }
132 
133     function setINCENTIVE_POOL_ADDR(address addr) onlyOwner public{
134         INCENTIVE_POOL_ADDR = addr;
135     }
136 
137     function transferOwnership(address newOwner) onlyOwner public {
138         owner = newOwner;
139     }
140 
141     function burn(uint256 _value) public returns (bool success) {
142         require(balances[msg.sender] >= _value);   // Check if the sender has enough
143         balances[msg.sender] -= _value;            // Subtract from the sender
144         totalSupply -= _value;                      // Updates totalSupply
145         emit Burn(msg.sender, _value);
146         return true;
147     }
148 
149     function burnFrom(address _from, uint256 _value) public returns (bool success) {
150         require(balances[_from] >= _value);                // Check if the targeted balance is enough
151         require(_value <= allowed[_from][msg.sender]);    // Check allowed
152         balances[_from] -= _value;                         // Subtract from the targeted balance
153         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
154         totalSupply -= _value;                              // Update totalSupply
155         emit Burn(_from, _value);
156         return true;
157     }
158 
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
160         tokenRecipient spender = tokenRecipient(_spender);
161         if (approve(_spender, _value)) {
162             spender.receiveApproval(msg.sender, _value, this, _extraData);
163             return true;
164         }
165         return false;
166     }
167 
168 }