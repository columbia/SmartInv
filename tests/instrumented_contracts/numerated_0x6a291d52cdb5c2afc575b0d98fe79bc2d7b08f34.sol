1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipients3dp{ function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract DPToken{
6   string public name = "3DP-Token";
7   string public symbol = "3DP";
8   uint8 public  decimals = 2;
9   uint256 public totalSupply=30000000000;
10   
11   mapping (address => uint256) public balanceOf;
12   mapping (address => mapping (address => uint256)) public allowance;
13   event Transfer(address indexed from, address indexed to, uint256 value);
14   event Burn(address indexed from, uint256 value);
15     function DPToken(
16         uint256 initialSupply,
17         string tokenName,
18         string tokenSymbol
19     ) public {
20         totalSupply = 30000000000;  
21         balanceOf[msg.sender] = totalSupply;
22         name = tokenName;                   
23         symbol = tokenSymbol;               
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
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);     // Check allowance
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public
49         returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51         return true;
52     }
53 
54     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
55         public
56         returns (bool success) {
57         tokenRecipients3dp spender = tokenRecipients3dp(_spender);
58         if (approve(_spender, _value)) {
59             spender.receiveApproval(msg.sender, _value, this, _extraData);
60             return true;
61         }
62     }
63 
64     function burn(uint256 _value) public returns (bool success) {
65         require(balanceOf[msg.sender] >= _value);   
66         balanceOf[msg.sender] -= _value;            
67         totalSupply -= _value;                      
68         Burn(msg.sender, _value);
69         return true;
70     }
71 
72     function burnFrom(address _from, uint256 _value) public returns (bool success) {
73         require(balanceOf[_from] >= _value);              
74         require(_value <= allowance[_from][msg.sender]);  
75         balanceOf[_from] -= _value;                       
76         allowance[_from][msg.sender] -= _value;           
77         totalSupply -= _value;                            
78         Burn(_from, _value);
79         return true;
80     }
81 }