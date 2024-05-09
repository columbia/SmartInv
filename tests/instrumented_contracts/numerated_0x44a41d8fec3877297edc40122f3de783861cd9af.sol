1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 8;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Burn(address indexed from, uint256 value);
15 
16     function TokenERC20(
17         uint256 initialSupply,
18         string tokenName,
19         string tokenSymbol,
20         address tokenHolder
21     ) public {
22         totalSupply = initialSupply * 10 ** uint256(decimals);
23         balanceOf[tokenHolder] = totalSupply;
24         name = tokenName;
25         symbol = tokenSymbol;
26     }
27 
28     function _transfer(address _from, address _to, uint _value) internal {
29         require(_to != 0x0);
30         require(balanceOf[_from] >= _value);
31         require(balanceOf[_to] + _value > balanceOf[_to]);
32         uint previousBalances = balanceOf[_from] + balanceOf[_to];
33         balanceOf[_from] -= _value;
34         balanceOf[_to] += _value;
35         Transfer(_from, _to, _value);
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38 
39     function transfer(address _to, uint256 _value) public {
40         _transfer(msg.sender, _to, _value);
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require(_value <= allowance[_from][msg.sender]);
45         allowance[_from][msg.sender] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) public
51         returns (bool success) {
52         allowance[msg.sender][_spender] = _value;
53         return true;
54     }
55 
56     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
57         public
58         returns (bool success) {
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