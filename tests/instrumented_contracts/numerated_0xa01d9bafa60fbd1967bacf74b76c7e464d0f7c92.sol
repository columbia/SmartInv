1 pragma solidity ^0.4.12;
2 
3 contract ElevenOfTwelve {
4     
5     // totalSupply = Maximum is 210000 Coins with 18 decimals;
6     // Only 1/100 of the maximum bitcoin supply.
7     // Nur 1/100 vom maximalen Bitcoin Supply.
8     // ElevenOfTwelve IS A VERY SEXY COIN :-)
9     // Buy and get rich!
10 
11     uint256 public totalSupply = 210000000000000000000000;
12     uint256 public availableSupply= 210000000000000000000000;
13     uint256 public circulatingSupply = 0;  	
14     uint8   public decimals = 18;
15   
16     string  public standard = 'ERC20 Token';
17     string  public name = 'ElevenOfTwelve';
18     string  public symbol = '11of12';            
19     uint256 public crowdsalePrice = 100;                          	
20     uint256 public crowdsaleClosed = 0;                 
21     address public daoMultisig = msg.sender;
22     address public owner = msg.sender;  
23 
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;	
26 	
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
29     
30     function transfer(address _to, uint256 _value) returns (bool success) {
31         if (balances[msg.sender] >= _value && _value > 0) {
32             balances[msg.sender] -= _value;
33             balances[_to] += _value;
34             Transfer(msg.sender, _to, _value);
35             return true;
36         } else { return false; }
37     }
38 
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         } else { return false; }
47     }
48 
49     function balanceOf(address _owner) constant returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58 
59     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
60       return allowed[_owner][_spender];
61     }
62 	
63     modifier onlyOwner {
64         if (msg.sender != owner) throw;
65         _;
66     }
67 	
68     function transferOwnership(address newOwner) onlyOwner {
69         owner = newOwner;
70     }	
71 	
72     function () payable {
73         if (crowdsaleClosed > 0) throw;		
74         if (msg.value == 0) {
75           throw;
76         }		
77         if (!daoMultisig.send(msg.value)) {
78           throw;
79         }		
80         uint token = msg.value * crowdsalePrice;		
81 		availableSupply = totalSupply - circulatingSupply;
82         if (token > availableSupply) {
83           throw;
84         }		
85         circulatingSupply += token;
86         balances[msg.sender] += token;
87     }
88 	
89     function setPrice(uint256 newSellPrice) onlyOwner {
90         crowdsalePrice = newSellPrice;
91     }
92 	
93     function stoppCrowdsale(uint256 newStoppSign) onlyOwner {
94         crowdsaleClosed = newStoppSign;
95     }		
96 
97     function setMultisigAddress(address newMultisig) onlyOwner {
98         daoMultisig = newMultisig;
99     }	
100 	
101 }