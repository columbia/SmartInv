1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract TokenERC20 {    string public name;    string public symbol;
8     uint8 public decimals = 18;  // 18 是建议的默认值
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;  // 
12     mapping (address => mapping (address => uint256)) public allowance;
13     
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     
16     event Burn(address indexed from, uint256 value);
17 
18 
19     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
20         totalSupply = initialSupply * 10 ** uint256(decimals);
21         balanceOf[msg.sender] = totalSupply;
22         name = tokenName;
23         symbol = tokenSymbol;
24     }
25 
26 
27     function _transfer(address _from, address _to, uint _value) internal {
28         require(_to != 0x0);
29         require(balanceOf[_from] >= _value);
30         require(balanceOf[_to] + _value > balanceOf[_to]);        
31         uint previousBalances = balanceOf[_from] + balanceOf[_to];
32         balanceOf[_from] -= _value;
33         balanceOf[_to] += _value;
34         Transfer(_from, _to, _value);
35         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
36     }
37 
38     function transfer(address _to, uint256 _value) public {
39         _transfer(msg.sender, _to, _value);
40     }
41 
42     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
43         require(_value <= allowance[_from][msg.sender]);     // Check allowance
44         allowance[_from][msg.sender] -= _value;
45         _transfer(_from, _to, _value);        return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         allowance[msg.sender][_spender] = _value;        
50         return true;
51     }
52 
53     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
54         tokenRecipient spender = tokenRecipient(_spender);        
55         if (approve(_spender, _value)) {
56             spender.receiveApproval(msg.sender, _value, this, _extraData);            
57             return true;
58         }
59     }
60 
61     function burn(uint256 _value) public returns (bool success) {
62         require(balanceOf[msg.sender] >= _value);
63         balanceOf[msg.sender] -= _value;
64         totalSupply -= _value;
65         Burn(msg.sender, _value);       
66         return true;
67     }
68 
69     function burnFrom(address _from, uint256 _value) public returns (bool success) {
70         require(balanceOf[_from] >= _value);
71         require(_value <= allowance[_from][msg.sender]);
72         balanceOf[_from] -= _value;
73         allowance[_from][msg.sender] -= _value;
74         totalSupply -= _value;
75         Burn(_from, _value);        
76         return true;
77     }
78 }