1 pragma solidity ^0.4.20;
2 
3 interface ERC20Token {
4 
5     function totalSupply() constant external returns (uint256 supply);
6 
7     function balanceOf(address _owner) constant external returns (uint256 balance);
8 
9     function transfer(address _to, uint256 _value) external returns (bool success);
10 
11     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
12 
13     function approve(address _spender, uint256 _value) external returns (bool success);
14 
15     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 }
20 
21 contract Token is ERC20Token{
22     mapping (address => uint256) balances;
23     mapping (address => mapping (address => uint256)) allowed;
24 
25     uint256 public totalSupply;
26 
27     function balanceOf(address _owner) constant external returns (uint256 balance) {
28         return balances[_owner];
29     }
30 
31     function transfer(address _to, uint256 _value) external returns (bool success) {
32         if(msg.data.length < (3 * 32) + 4) { revert(); }
33         
34         if (balances[msg.sender] >= _value && _value > 0) {
35             balances[msg.sender] -= _value;
36             balances[_to] += _value;
37             Transfer(msg.sender, _to, _value);
38             return true;
39         } else { return false; }
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
43         if(msg.data.length < (3 * 32) + 4) { revert(); }
44         
45         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
46             balances[_to] += _value;
47             balances[_from] -= _value;
48             allowed[_from][msg.sender] -= _value;
49             Transfer(_from, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function approve(address _spender, uint256 _value) external returns (bool success) {
55         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
56         
57         allowed[msg.sender][_spender] = _value;
58         Approval(msg.sender, _spender, _value);
59         return true;
60     }
61 
62     function allowance(address _owner, address _spender) constant external returns (uint256 remaining) {
63         return allowed[_owner][_spender];
64     }
65 
66     function totalSupply() constant external returns (uint256 supply){
67         return totalSupply;
68     }
69 }
70 
71 contract DIUToken is Token{
72     address owner = msg.sender;
73     bool private paused = false;
74     
75     string public name;
76     string public symbol;
77     uint8 public decimals;
78     uint256 public unitsOneEthCanBuy;
79     uint256 public totalEthInWei;
80     address public fundsWallet;
81 
82     uint256 public ethRaised;
83     uint256 public tokenFunded;
84     
85     modifier onlyOwner{
86         require(msg.sender == owner);
87         _;
88     }
89     
90     modifier whenNotPause{
91         require(!paused);
92         _;
93     }
94 
95     function DIUToken() {
96         balances[msg.sender] = 100000000 * 1000000000000000000;
97         totalSupply = 100000000 * 1000000000000000000;
98         name = "D!U";
99         decimals = 18;
100         symbol = "D!U";
101         unitsOneEthCanBuy = 100;
102         fundsWallet = msg.sender;
103         tokenFunded = 0;
104         ethRaised = 0;
105         paused = false;
106     }
107 
108     function() payable whenNotPause{
109         if (msg.value >= 10 finney){
110             totalEthInWei = totalEthInWei + msg.value;
111             uint256 amount = msg.value * unitsOneEthCanBuy;
112             if (balances[fundsWallet] < amount) {
113                 return;
114             }
115             
116             ethRaised = ethRaised + msg.value;
117             tokenFunded = tokenFunded + amount + ethRaised;
118     
119             balances[fundsWallet] = balances[fundsWallet] - amount - ethRaised;
120             balances[msg.sender] = balances[msg.sender] + amount + ethRaised;
121     
122             Transfer(fundsWallet, msg.sender, amount);
123         }
124         
125         fundsWallet.transfer(msg.value);
126     }
127 
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131 
132         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {
133             revert();
134         }
135 
136         return true;
137     }
138     
139     function pauseContract(bool) external onlyOwner{
140         paused = true;
141     }
142     
143     function unpauseContract(bool) external onlyOwner{
144         paused = false;
145     }
146     
147     function getStats() external constant returns (uint256, uint256, bool) {
148         return (ethRaised, tokenFunded, paused);
149     }
150 
151 }