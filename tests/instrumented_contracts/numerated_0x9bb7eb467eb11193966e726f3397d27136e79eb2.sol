1 pragma solidity ^0.4.8;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract TMN {
6     string public standard = 'ERC20';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19 
20     function TMN() {
21         totalSupply = 4955000000000;
22         balanceOf[msg.sender] = totalSupply;                                     
23         name = 'Transmission';                                   
24         symbol = 'TMN';                          
25         decimals = 4;                            
26     }
27 
28     function transfer(address _to, uint256 _value) {
29         if (balanceOf[msg.sender] < _value) throw;           
30         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
31         balanceOf[msg.sender] -= _value;                     
32         balanceOf[_to] += _value;                            
33         Transfer(msg.sender, _to, _value);                  
34     }
35 
36     function approve(address _spender, uint256 _value)
37         returns (bool success) {
38         allowance[msg.sender][_spender] = _value;
39         return true;
40     }
41 
42     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
43         returns (bool success) {
44         tokenRecipient spender = tokenRecipient(_spender);
45         if (approve(_spender, _value)) {
46             spender.receiveApproval(msg.sender, _value, this, _extraData);
47             return true;
48         }
49     }        
50 
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         if (balanceOf[_from] < _value) throw;                
53         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
54         if (_value > allowance[_from][msg.sender]) throw;   
55         balanceOf[_from] -= _value;                          
56         balanceOf[_to] += _value;                            
57         allowance[_from][msg.sender] -= _value;
58         Transfer(_from, _to, _value);
59         return true;
60     }
61 
62     function () {
63         throw;
64     }
65 }