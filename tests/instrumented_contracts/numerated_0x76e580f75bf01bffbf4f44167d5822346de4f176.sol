1 pragma solidity ^0.4.6;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 
6 contract WillieWatts {
7 
8     string public standard = 'Token 0.1';
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     function WillieWatts(
20         string tokenName,
21         string tokenSymbol
22         ) {              
23         totalSupply = 0;                        
24         name = tokenName;   
25         symbol = tokenSymbol;   
26         decimals = 0;  
27     }
28 
29 
30     /* Send coins */
31     function transfer(address _to, uint256 _value) {
32         if (balanceOf[msg.sender] < _value) throw;          
33         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
34         balanceOf[msg.sender] -= _value;                 
35         balanceOf[_to] += _value;                    
36         Transfer(msg.sender, _to, _value);             
37     }
38 
39 
40     function approve(address _spender, uint256 _value)
41         returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 
46 
47     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
48         returns (bool success) {
49         tokenRecipient spender = tokenRecipient(_spender);
50         if (approve(_spender, _value)) {
51             spender.receiveApproval(msg.sender, _value, this, _extraData);
52             return true;
53         }
54     }        
55 
56     /* A contract attempts to get the coins */
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
59         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
60         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
61         balanceOf[_from] -= _value;                          // Subtract from the sender
62         balanceOf[_to] += _value;                            // Add the same to the recipient
63         allowance[_from][msg.sender] -= _value;
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function refund(uint256 _value) returns (bool success) {
69       uint256 etherValue = (_value * 1 ether) / 1000;
70 
71       if(balanceOf[msg.sender] < _value) throw;   
72       if(!msg.sender.send(etherValue)) throw;
73       
74       balanceOf[msg.sender] -= _value;
75       totalSupply -= _value;
76       Transfer(msg.sender, this, _value);
77       return true;
78     }
79     
80     function() payable {
81       uint256 tokenCount = (msg.value * 1000) / 1 ether ;
82 
83       balanceOf[msg.sender] += tokenCount;
84       totalSupply += tokenCount;
85       Transfer(this, msg.sender, tokenCount);
86     }
87 }