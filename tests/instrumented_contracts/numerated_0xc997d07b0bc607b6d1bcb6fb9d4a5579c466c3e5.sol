1 pragma solidity ^0.4.8;
2 
3 contract tokenRecipient { 
4     
5     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
6     
7 }
8 
9 contract FlipToken {
10     
11     //~ Hashes for lookups
12     mapping (address => uint256) public balanceOf;
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     //~ Events
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     //~ Setup
19     string public standard = 'FLIP';
20     string public name = "Flip";
21     string public symbol = "FLIP";
22     uint8 public decimals = 0;
23     uint256 public totalSupply = 15000000;
24 
25     //~ Init we set totalSupply
26     function FlipToken() {
27         balanceOf[msg.sender] = totalSupply;
28     }
29 
30     //~~ Methods based on Token.sol from Ethereum Foundation
31     //~ Transfer FLIP
32     function transfer(address _to, uint256 _value) {
33         if (_to == 0x0) throw;                               
34         if (balanceOf[msg.sender] < _value) throw;           
35         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
36         balanceOf[msg.sender] -= _value;                   
37         balanceOf[_to] += _value;                           
38         Transfer(msg.sender, _to, _value);                   
39     }
40 
41     function approve(address _spender, uint256 _value) returns (bool success) {
42         allowance[msg.sender][_spender] = _value;
43         return true;
44     }
45 
46     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
47         tokenRecipient spender = tokenRecipient(_spender);
48         if (approve(_spender, _value)) {
49             spender.receiveApproval(msg.sender, _value, this, _extraData);
50             return true;
51         }
52     }        
53 
54     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
55         if (_to == 0x0) throw;                                
56         if (balanceOf[_from] < _value) throw;                 
57         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
58         if (_value > allowance[_from][msg.sender]) throw;     
59         balanceOf[_from] -= _value;                           
60         balanceOf[_to] += _value;                            
61         allowance[_from][msg.sender] -= _value;
62         Transfer(_from, _to, _value);
63         return true;
64     }
65 }