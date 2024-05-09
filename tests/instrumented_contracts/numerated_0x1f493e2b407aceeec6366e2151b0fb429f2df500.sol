1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return 返回token的发行量
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner 查询以太坊地址token余额
9     /// @return The balance 返回余额
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice msg.sender（交易发送者）发送 _value（一定数量）的 token 到 _to（接受者）  
13     /// @param _to 接收者的地址
14     /// @param _value 发送token的数量
15     /// @return 是否成功
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice 发送者 发送 _value（一定数量）的 token 到 _to（接受者）  
19     /// @param _from 发送者的地址
20     /// @param _to 接收者的地址
21     /// @param _value 发送的数量
22     /// @return 是否成功
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice 发行方 批准 一个地址发送一定数量的token
26     /// @param _spender 需要发送token的地址
27     /// @param _value 发送token的数量
28     /// @return 是否成功
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner 拥有token的地址
32     /// @param _spender 可以发送token的地址
33     /// @return 还允许发送的token的数量
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     /// 发送Token事件
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     /// 批准事件
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //默认token发行量不能超过(2^256 - 1)
45         //如果你不设置发行量，并且随着时间的发型更多的token，需要确保没有超过最大值，使用下面的 if 语句
46         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //向上面的方法一样，如果你想确保发行量不超过最大值
57         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83     uint256 public totalSupply;
84 }
85 contract TIC is StandardToken { 
86 
87     string public name;                  
88     uint8 public decimals;              
89     string public symbol;                 
90     string public version = '1.0'; 
91     uint256 public Rate;     
92     uint256 public totalEthInWei;      
93     address public fundsWallet;         
94     address public CandyBox;
95     address public TeamBox;
96 
97 
98     function TIC(
99         ) {
100         CandyBox = 0x94eE12284824C91dB533d4745cD02098d7284460;
101         TeamBox = 0xfaDB28B22b1b5579f877c78098948529175F81Eb;
102         totalSupply = 6000000000000000000000000000;                   
103         balances[msg.sender] = 5091000000000000000000000000;             
104         balances[CandyBox] = 9000000000000000000000000;  
105         balances[TeamBox] = 900000000000000000000000000;
106         name = "TIC";                                        
107         decimals = 18;                                  
108         symbol = "TIC";                                            
109         Rate = 50000;                                      
110         fundsWallet = msg.sender;                                   
111     }
112     
113     function setCurrentRate(uint256 _rate) public {
114         if(msg.sender != fundsWallet) { throw; }
115         Rate = _rate;
116     }    
117 
118     function setCurrentVersion(string _ver) public {
119         if(msg.sender != fundsWallet) { throw; }
120         version = _ver;
121     }  
122 
123     function() payable{
124  
125         totalEthInWei = totalEthInWei + msg.value;
126   
127         uint256 amount = msg.value * Rate;
128 
129         require(balances[fundsWallet] >= amount);
130 
131 
132         balances[fundsWallet] = balances[fundsWallet] - amount;
133 
134         balances[msg.sender] = balances[msg.sender] + amount;
135 
136 
137         Transfer(fundsWallet, msg.sender, amount); 
138 
139  
140         fundsWallet.transfer(msg.value);                               
141     }
142 
143 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
148         return true;
149     }
150 }