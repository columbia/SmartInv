1 pragma solidity ^0.4.16;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract TokenERC20 {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 4; 
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;  // 
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     event Burn(address indexed from, uint256 value);
15 
16 
17     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = tokenName;
21         symbol = tokenSymbol;
22     }
23 
24 
25     function _transfer(address _from, address _to, uint _value) internal {
26         require(_to != 0x0);
27         require(balanceOf[_from] >= _value);
28         require(balanceOf[_to] + _value > balanceOf[_to]);
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from] -= _value;
31         balanceOf[_to] += _value;
32         Transfer(_from, _to, _value);
33         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34     }
35 
36     function transfer(address _to, uint256 _value) public {
37         _transfer(msg.sender, _to, _value);
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41         require(_value <= allowance[_from][msg.sender]);     // Check allowance
42         allowance[_from][msg.sender] -= _value;
43         _transfer(_from, _to, _value);
44         return true;
45     }
46 
47     function approve(address _spender, uint256 _value) public
48         returns (bool success) {
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