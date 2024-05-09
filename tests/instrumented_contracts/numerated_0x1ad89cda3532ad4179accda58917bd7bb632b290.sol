1 pragma solidity ^0.4.11;
2 
3 contract EOTCoin {
4     
5     // totalSupply = maximum 210000 Coins with 18 decimals;   
6     uint256 public totalSupply = 210000000000000000000000;	
7     uint8   public decimals = 18;    
8     string  public standard = 'ERC20 Token';
9     string  public name = '11of12Coin';
10     string  public symbol = 'EOT';
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
57     modifier onlyOwner {
58         if (msg.sender != owner) throw;
59         _;
60     }
61 	
62     function transferOwnership(address newOwner) onlyOwner {
63         owner = newOwner;
64     }	
65 	
66     function () payable {
67         if (crowdsaleClosed > 0) throw;		
68         if (msg.value == 0) {
69           throw;
70         }		
71         if (!multisig.send(msg.value)) {
72           throw;
73         }		
74         uint token = msg.value * price;		
75 		availableSupply = totalSupply - circulatingSupply;
76         if (token > availableSupply) {
77           throw;
78         }		
79         circulatingSupply += token;
80         balances[msg.sender] += token;
81     }
82 	
83     function setPrice(uint256 newSellPrice) onlyOwner {
84         price = newSellPrice;
85     }
86 	
87     function stoppCrowdsale(uint256 newStoppSign) onlyOwner {
88         crowdsaleClosed = newStoppSign;
89     }		
90 
91     function setMultisigAddress(address newMultisig) onlyOwner {
92         multisig = newMultisig;
93     }	
94 	
95 }