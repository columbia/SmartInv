1 pragma solidity ^0.4.12;
2 
3 contract testeot {
4     
5     // totalSupply = maximum 210000 Coins with 18 decimals;   
6     uint256 public totalSupply = 210000000000000000000000;
7     uint256 public availableSupply= 210000000000000000000000;
8     uint256 public circulatingSupply = 0;  	
9     uint8   public decimals = 18;
10     //   
11     string  public standard = 'ERC20 Token';
12     string  public name = 'testeot';
13     string  public symbol = 'testeot';            
14     uint256 public crowdsalePrice = 100;                          	
15     uint256 public crowdsaleClosed = 0;                 
16     address public daoMultisig = msg.sender;
17     address public owner = msg.sender;  
18 
19     mapping (address => uint256) balances;
20     mapping (address => mapping (address => uint256)) allowed;	
21 	
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
24     
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             Transfer(msg.sender, _to, _value);
30             return true;
31         } else { return false; }
32     }
33 
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
35         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
36             balances[_to] += _value;
37             balances[_from] -= _value;
38             allowed[_from][msg.sender] -= _value;
39             Transfer(_from, _to, _value);
40             return true;
41         } else { return false; }
42     }
43 
44     function balanceOf(address _owner) constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function approve(address _spender, uint256 _value) returns (bool success) {
49         allowed[msg.sender][_spender] = _value;
50         Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57 	
58     modifier onlyOwner {
59         if (msg.sender != owner) throw;
60         _;
61     }
62 	
63     function transferOwnership(address newOwner) onlyOwner {
64         owner = newOwner;
65     }	
66 	
67     function () payable {
68         if (crowdsaleClosed > 0) throw;		
69         if (msg.value == 0) {
70           throw;
71         }		
72         Transfer(msg.sender, daoMultisig, msg.value);		
73         uint token = msg.value * crowdsalePrice;		
74 		availableSupply = totalSupply - circulatingSupply;
75         if (token > availableSupply) {
76           throw;
77         }		
78         circulatingSupply += token;
79         balances[msg.sender] += token;
80     }
81 	
82     function setPrice(uint256 newSellPrice) onlyOwner {
83         crowdsalePrice = newSellPrice;
84     }
85 	
86     function stoppCrowdsale(uint256 newStoppSign) onlyOwner {
87         crowdsaleClosed = newStoppSign;
88     }		
89 
90     function setMultisigAddress(address newMultisig) onlyOwner {
91         daoMultisig = newMultisig;
92     }	
93 	
94 }