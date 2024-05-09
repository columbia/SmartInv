1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract eXMR {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 12;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function eXMR() public {
19         balanceOf[msg.sender] = 18400000000000000000;
20         totalSupply = 18400000000000000000;                      
21         name = "eMONERO";                                  
22         decimals = 12;                            
23         symbol = "eXMR";           
24     }
25 
26     function _transfer(address _from, address _to, uint _value) internal {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33         Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41 
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= allowance[_from][msg.sender]);     // Check allowance
44         allowance[_from][msg.sender] -= _value;
45         _transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value) public
50         returns (bool success) {
51         allowance[msg.sender][_spender] = _value;
52         return true;
53     }
54 
55     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
56         public
57         returns (bool success) {
58         tokenRecipient spender = tokenRecipient(_spender);
59         if (approve(_spender, _value)) {
60             spender.receiveApproval(msg.sender, _value, this, _extraData);
61             return true;
62         }
63     }
64 
65     function burn(uint256 _value) public returns (bool success) {
66         require(balanceOf[msg.sender] >= _value); 
67         balanceOf[msg.sender] -= _value;           
68         totalSupply -= _value;                     
69         Burn(msg.sender, _value);
70         return true;
71     }
72 
73     function burnFrom(address _from, uint256 _value) public returns (bool success) {
74         require(balanceOf[_from] >= _value);                
75         require(_value <= allowance[_from][msg.sender]);    
76         balanceOf[_from] -= _value;                         
77         allowance[_from][msg.sender] -= _value;             
78         totalSupply -= _value;                              
79         Burn(_from, _value);
80         return true;
81     }
82 }