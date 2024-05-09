1 pragma solidity ^0.4.6;
2 
3 contract ASWCoin {
4     
5     // totalSupply = maximum 210000 with 18 decimals;   
6     uint256 public supply = 210000000000000000000000;  
7     uint8   public decimals = 18;    
8     string  public standard = 'ERC20 Token';
9     string  public name = "ASWCoin";
10     string  public symbol = "ASW";
11     uint256 public circulatingSupply = 0;   
12     uint256 availableSupply;              
13     uint256 price= 1;                          	
14     uint256 crowdsaleClosed = 0;                 
15     address multisig = msg.sender;
16     address owner = msg.sender;  
17 
18     mapping (address => uint256) balances;
19     mapping (address => mapping (address => uint256)) allowed;	
20 	
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
23 
24     function totalSupply() constant returns (uint256 supply) {
25         supply = supply;
26     }
27     
28     function transfer(address _to, uint256 _value) returns (bool success) {
29         if (balances[msg.sender] >= _value && _value > 0) {
30             balances[msg.sender] -= _value;
31             balances[_to] += _value;
32             Transfer(msg.sender, _to, _value);
33             return true;
34         } else { return false; }
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             Transfer(_from, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function balanceOf(address _owner) constant returns (uint256 balance) {
48         return balances[_owner];
49     }
50 
51     function approve(address _spender, uint256 _value) returns (bool success) {
52         allowed[msg.sender][_spender] = _value;
53         Approval(msg.sender, _spender, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 	
61     modifier onlyOwner {
62         if (msg.sender != owner) throw;
63         _;
64     }
65 	
66     function transferOwnership(address newOwner) onlyOwner {
67         owner = newOwner;
68     }	
69 	
70     function () payable {
71         if (crowdsaleClosed > 0) throw;		
72         if (msg.value == 0) {
73           throw;
74         }		
75         if (!multisig.send(msg.value)) {
76           throw;
77         }		
78         uint token = msg.value * price;		
79 		availableSupply = supply - circulatingSupply;
80         if (token > availableSupply) {
81           throw;
82         }		
83         circulatingSupply += token;
84         balances[msg.sender] += token;
85     }
86 	
87     function setPrice(uint256 newSellPrice) onlyOwner {
88         price = newSellPrice;
89     }
90 	
91     function stoppCrowdsale(uint256 newStoppSign) onlyOwner {
92         crowdsaleClosed = newStoppSign;
93     }		
94 
95     function setMultisigAddress(address newMultisig) onlyOwner {
96         multisig = newMultisig;
97     }	
98 	
99 }