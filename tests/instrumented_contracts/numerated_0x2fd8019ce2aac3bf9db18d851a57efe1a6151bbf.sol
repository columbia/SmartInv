1 pragma solidity ^0.4.8;
2 
3 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract OPL {
6     string public standard = 'ERC20';
7     string public version = 'v0.1';
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     uint256 public totalSupply;
12 
13 
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20 
21     function OPL() {
22         balanceOf[msg.sender] = 10000000;             
23         totalSupply = 10000000;                        
24         name = 'OnPlace Inc. Token';                                   
25         symbol = 'OPL';                          
26         decimals = 0;                            
27     }
28 
29     function transfer(address _to, uint256 _value) {
30         if (balanceOf[msg.sender] < _value) throw;           
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
32         balanceOf[msg.sender] -= _value;                     
33         balanceOf[_to] += _value;                            
34         Transfer(msg.sender, _to, _value);                  
35     }
36 
37     function approve(address _spender, uint256 _value)
38         returns (bool success) {
39         allowance[msg.sender][_spender] = _value;
40         return true;
41     }
42 
43     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
44         returns (bool success) {
45         tokenRecipient spender = tokenRecipient(_spender);
46         if (approve(_spender, _value)) {
47             spender.receiveApproval(msg.sender, _value, this, _extraData);
48             return true;
49         }
50     }        
51 
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balanceOf[_from] < _value) throw;                
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
55         if (_value > allowance[_from][msg.sender]) throw;   
56         balanceOf[_from] -= _value;                          
57         balanceOf[_to] += _value;                            
58         allowance[_from][msg.sender] -= _value;
59         Transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function () {
64         throw;
65     }
66 }