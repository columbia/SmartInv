1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 //Singapore MediaFOX  foundation-MFA
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 8;  
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;  
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20 
21     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);
23         balanceOf[msg.sender] = totalSupply;
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
27 
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value > balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         Transfer(_from, _to, _value);
37         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
38     }
39 
40     function transfer(address _to, uint256 _value) public returns (bool) {
41         _transfer(msg.sender, _to, _value);
42         return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46         require(_value <= allowance[_from][msg.sender]);     
47         allowance[_from][msg.sender] -= _value;
48         _transfer(_from, _to, _value);
49         return true;
50     }
51 
52     function approve(address _spender, uint256 _value) public
53         returns (bool success) {
54         allowance[msg.sender][_spender] = _value;
55         return true;
56     }
57 
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
59         tokenRecipient spender = tokenRecipient(_spender);
60         if (approve(_spender, _value)) {
61             spender.receiveApproval(msg.sender, _value, this, _extraData);
62             return true;
63         }
64     }
65 
66     function burn(uint256 _value) public returns (bool success) {
67         require(balanceOf[msg.sender] >= _value);
68         balanceOf[msg.sender] -= _value;
69         totalSupply -= _value;
70         Burn(msg.sender, _value);
71         return true;
72     }
73 
74     function burnFrom(address _from, uint256 _value) public returns (bool success) {
75         require(balanceOf[_from] >= _value);
76         require(_value <= allowance[_from][msg.sender]);
77         balanceOf[_from] -= _value;
78         allowance[_from][msg.sender] -= _value;
79         totalSupply -= _value;
80         Burn(_from, _value);
81         return true;
82     }
83 }