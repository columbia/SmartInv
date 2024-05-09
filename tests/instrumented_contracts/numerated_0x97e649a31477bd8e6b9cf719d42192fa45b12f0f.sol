1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient{
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5    }
6     contract TokenERC20{                                       
7     string public name;
8     string public symbol;
9     uint8 public decimals =6;  
10     uint256 public totalSupply;     
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;    
13     event Transfer(address indexed from, address indexed to, uint256 value);    
14     event Burn(address indexed from, uint256 value);
15 
16     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
17         totalSupply = initialSupply * 10 ** uint256(decimals);   
18         balanceOf[msg.sender] = totalSupply;                     
19         name = tokenName;                                        
20         symbol = tokenSymbol;                                    
21     }
22 
23     function _transfer(address _from, address _to, uint _value) internal {  
24         require(_to != 0x0);                                                
25         require(balanceOf[_from] >= _value);                                
26         require(balanceOf[_to] + _value > balanceOf[_to]);                 
27         uint previousBalances = balanceOf[_from] + balanceOf[_to];          
28         balanceOf[_from] -= _value;                                         
29         balanceOf[_to] += _value;
30         Transfer(_from, _to, _value);                                       
31         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
32     }
33 
34     function transfer(address _to, uint256 _value) public {
35         _transfer(msg.sender, _to, _value);
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
39         require(_value <= allowance[_from][msg.sender]);     
40         allowance[_from][msg.sender] -= _value;
41         _transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         return true;
48     }
49 
50     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
51         tokenRecipient spender = tokenRecipient(_spender);
52         if (approve(_spender, _value)) {
53             spender.receiveApproval(msg.sender, _value, this, _extraData);
54             return true;
55         }
56     }
57 
58     function burn(uint256 _value) public returns (bool success) {
59         require(balanceOf[msg.sender] >= _value);
60         // Check if the sender has enough
61         balanceOf[msg.sender] -= _value;
62          // Subtract from the sender
63         totalSupply -= _value;             
64         Burn(msg.sender, _value);
65         return true;
66     }
67 
68     function burnFrom(address _from, uint256 _value) public returns (bool success) {
69         require(balanceOf[_from] >= _value);                 
70         require(_value <= allowance[_from][msg.sender]);    
71         balanceOf[_from] -= _value;                         
72         allowance[_from][msg.sender] -= _value;              
73         totalSupply -= _value;                               
74         Burn(_from, _value);
75         return true;
76     }
77 }