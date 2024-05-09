1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;  
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
45         _transfer(_from, _to, _value);
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value) public
50         returns (bool success) {
51         allowance[msg.sender][_spender] = _value;
52         return true;
53     }
54     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
55         tokenRecipient spender = tokenRecipient(_spender);
56         if (approve(_spender, _value)) {
57             spender.receiveApproval(msg.sender, _value, this, _extraData);
58             return true;
59         }
60     }
61 
62     function burn(uint256 _value) public returns (bool success) {
63         require(balanceOf[msg.sender] >= _value);
64         balanceOf[msg.sender] -= _value;
65         totalSupply -= _value;
66         Burn(msg.sender, _value);
67         return true;
68     }
69 
70     function burnFrom(address _from, uint256 _value) public returns (bool success) {
71         require(balanceOf[_from] >= _value);
72         require(_value <= allowance[_from][msg.sender]);
73         balanceOf[_from] -= _value;
74         allowance[_from][msg.sender] -= _value;
75         totalSupply -= _value;
76         Burn(_from, _value);
77         return true;
78     }
79 }