1 pragma solidity ^0.4.4;
2 
3 contract Token {
4     
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     function balanceOf(address _owner) constant returns (uint256 balance) {}
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10 
11     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {}
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20 }
21 
22 contract StandardToken is Token {
23 
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         } else { return false; }
31     }
32 
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
35             balances[_to] += _value;
36             balances[_from] -= _value;
37             allowed[_from][msg.sender] -= _value;
38             Transfer(_from, _to, _value);
39             return true;
40         } else { return false; }
41     }
42 
43     function balanceOf(address _owner) constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46 
47     function approve(address _spender, uint256 _value) returns (bool success) {
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52 
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
54       return allowed[_owner][_spender];
55     }
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59     uint256 public totalSupply;
60 }
61 
62 contract RefugeCoin is StandardToken {
63 
64     /* Public variables of the token */
65 
66     string public name;                   
67     uint8 public decimals;                
68     string public symbol;                 
69     string public version = 'H1.0'; 
70     address private fundsWallet;
71     uint256 private unitsOneEthCanBuyInPreICO;     
72     uint256 private unitsOneEthCanBuyInFirstICO;     
73     uint256 private unitsOneEthCanBuyInSecondICO;    
74     uint256 public totalEthInWeiForPreIco;  
75     uint256 public totalEthInWeiForFirstIco;  
76     uint256 public totalEthInWeiForSecondIco;
77     uint private PreIcoDeadline;
78     uint private FirstICODeadline;
79     uint private SecondICODeadline;
80     uint256 public totalFirstICOSupply;
81     uint256 public totalSecondICOSupply;
82     uint256 public totalPreICOSupply;
83     function RefugeCoin() {
84         
85         decimals = 18;
86         balances[msg.sender] = 200000000 * 1e18;
87         totalSupply = 200000000 * 1e18;
88         name = "RefugeCoin";
89         symbol = "RFG";
90         fundsWallet = msg.sender;
91         
92         PreIcoDeadline = 1522540799;                              // Until 31/3
93         FirstICODeadline = 1527811199;                            // Until 31/5
94         SecondICODeadline = 1535759999;                           // Until 31/8
95         
96         unitsOneEthCanBuyInPreICO = 2000;
97         unitsOneEthCanBuyInFirstICO = 1250;
98         unitsOneEthCanBuyInSecondICO = 1111;
99         
100         totalPreICOSupply = 6000000 * 1e18;
101         totalFirstICOSupply = 7000000 * 1e18;
102         totalSecondICOSupply = 7000000 * 1e18;
103     }
104 
105     function() payable{
106         uint256 currentValue;
107         uint256 amount;
108         
109         if(PreIcoDeadline > now){
110             
111             currentValue = unitsOneEthCanBuyInPreICO;
112             amount = msg.value * currentValue;
113             if (totalPreICOSupply < amount){
114                 return;
115             }
116             totalPreICOSupply = totalPreICOSupply - amount;
117             totalEthInWeiForPreIco = totalEthInWeiForPreIco + msg.value;
118             
119         }else if(FirstICODeadline > now){
120             
121             currentValue = unitsOneEthCanBuyInFirstICO;
122             amount = msg.value * currentValue;
123             if (totalFirstICOSupply < amount){
124                 return;
125             }
126             totalFirstICOSupply = totalFirstICOSupply - amount;
127             totalEthInWeiForFirstIco = totalEthInWeiForFirstIco + msg.value;
128             
129         }else if(SecondICODeadline > now){
130             
131             currentValue = unitsOneEthCanBuyInSecondICO;
132             amount = msg.value * currentValue;
133             if (totalSecondICOSupply < amount){
134                 return;
135             }
136             totalSecondICOSupply = totalSecondICOSupply - amount;
137             totalEthInWeiForSecondIco = totalEthInWeiForSecondIco + msg.value;
138         }else{
139             return;
140         }
141         
142         
143         
144         if (balances[fundsWallet] < amount) {
145             return;
146         }
147         
148         balances[fundsWallet] = balances[fundsWallet] - amount;
149         balances[msg.sender] = balances[msg.sender] + amount;
150     
151         Transfer(fundsWallet, msg.sender, amount);
152     
153         fundsWallet.transfer(msg.value);
154         
155     }
156 
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160 
161         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
162         return true;
163     }
164 }