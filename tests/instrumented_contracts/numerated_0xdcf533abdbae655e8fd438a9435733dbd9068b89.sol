1 pragma solidity ^0.4.15;
2 
3 contract SolidusToken {
4 
5     address owner = msg.sender;
6 
7     bool public purchasingAllowed = true;
8 
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) allowed;
11 
12     uint256 public totalContribution = 0;
13     uint256 public totalSupply = 0;
14     uint256 public totalBalancingTokens = 0;
15     uint256 public tokenMultiplier = 600;
16 
17     function name() constant returns (string) { return "Solidus"; }
18     function symbol() constant returns (string) { return "SOL"; }
19     function decimals() constant returns (uint8) { return 18; }
20     
21     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
22     
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         require(_to != 0x0);                               
25         require(balances[msg.sender] >= _value);           
26         require(balances[_to] + _value > balances[_to]); 
27         balances[msg.sender] -= _value;                     
28         balances[_to] += _value;                            
29         Transfer(msg.sender, _to, _value);                  
30         return true;
31     }
32     
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
34         require(_to != 0x0);                                
35         require(balances[_from] >= _value);                 
36         require(balances[_to] + _value > balances[_to]);  
37         require(_value <= allowed[_from][msg.sender]);    
38         balances[_from] -= _value;                        
39         balances[_to] += _value;                          
40         allowed[_from][msg.sender] -= _value;
41         Transfer(_from, _to, _value);
42         return true;
43     }
44     
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         if (_value != 0 && allowed[msg.sender][_spender] != 0) {return false;}
47         
48         allowed[msg.sender][_spender] = _value;
49         Approval(msg.sender, _spender, _value);
50         return true;
51     }
52     
53     function allowance(address _owner, address _spender) constant returns (uint256) {
54         return allowed[_owner][_spender];
55     }
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60     function enablePurchasing() {
61         require(msg.sender == owner);
62         purchasingAllowed = true;
63     }
64 
65     function disablePurchasing() {
66         require(msg.sender == owner);
67         purchasingAllowed = false;
68     }
69 
70     function getStats() constant returns (uint256, uint256, uint256, uint256, bool) {
71         return (totalContribution, totalSupply, totalBalancingTokens, tokenMultiplier, purchasingAllowed);
72     }
73 
74     function halfMultiplier() {
75         require(msg.sender == owner);
76         tokenMultiplier /= 2;
77     }
78 
79     function burn(uint256 _value) returns (bool success) {
80         require(msg.sender == owner);
81         require(balances[msg.sender] > _value);
82         balances[msg.sender] -= _value;
83         totalBalancingTokens -= _value;
84         totalSupply -= _value;  
85         return true;
86     }
87 
88     function() payable {
89         require(purchasingAllowed);
90         
91         if (msg.value == 0) {return;}
92 
93         owner.transfer(msg.value);
94         totalContribution += msg.value;
95 
96         uint256 tokensIssued = (msg.value * tokenMultiplier);
97         
98         totalSupply += tokensIssued*2;
99         totalBalancingTokens += tokensIssued;
100 
101         balances[msg.sender] += tokensIssued;
102         balances[owner] += tokensIssued;
103         
104         Transfer(address(this), msg.sender, tokensIssued);
105     }
106 }