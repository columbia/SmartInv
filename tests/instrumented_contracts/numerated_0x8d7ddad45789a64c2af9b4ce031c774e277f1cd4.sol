1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract MBLToken {
6     string public name = "Marble";
7     string public symbol = "MBL";
8     uint256 public decimals = 18;
9     uint256 public totalSupply = 100*1000*1000*10**decimals;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Burn(address indexed from, uint256 value);
17 
18     function MBLToken() public {
19         balanceOf[msg.sender] = totalSupply;                
20     }
21 
22 
23     function _transfer(address _from, address _to, uint _value) internal {
24         require(_to != 0x0);
25         require(balanceOf[_from] >= _value);
26         require(balanceOf[_to] + _value > balanceOf[_to]);
27         uint previousBalances = balanceOf[_from] + balanceOf[_to];
28         balanceOf[_from] -= _value;
29         balanceOf[_to] += _value;
30         emit Transfer(_from, _to, _value);
31         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
32     }
33 
34     function balanceOf(address _tokenOwner) external view returns (uint balance) {
35         return balanceOf[_tokenOwner];
36     }
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
42         require(_value <= allowance[_from][msg.sender]);     
43         allowance[_from][msg.sender] -= _value;
44         _transfer(_from, _to, _value);
45         return true;
46     }
47 
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
65 
66     function burn(uint256 _value) public returns (bool success) {
67         require(balanceOf[msg.sender] >= _value);   
68         balanceOf[msg.sender] -= _value;            
69         totalSupply -= _value;                      
70         emit Burn(msg.sender, _value);
71         return true;
72     }
73 
74 
75     function burnFrom(address _from, uint256 _value) public returns (bool success) {
76         require(balanceOf[_from] >= _value);                
77         require(_value <= allowance[_from][msg.sender]);    
78         balanceOf[_from] -= _value;                         
79         allowance[_from][msg.sender] -= _value;             
80         totalSupply -= _value;                              
81         emit Burn(_from, _value);
82         return true;
83     }
84 }