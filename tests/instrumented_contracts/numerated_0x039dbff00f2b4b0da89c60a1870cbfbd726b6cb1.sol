1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     string public name;         //世界佛福链 WORLD FOFU BLOCKCHAIN
7     string public symbol;
8     uint8 public decimals = 18;  
9     uint256 public totalSupply;  
10 
11     mapping (address => uint256) public balanceOf; 
12 
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     event Burn(address indexed from, uint256 value);
18 
19 
20     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
21         totalSupply = initialSupply * 10 ** uint256(decimals);
22         balanceOf[msg.sender] = totalSupply;
23         name = tokenName;
24         symbol = tokenSymbol;
25     }
26 
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
44         require(_value <= allowance[_from][msg.sender]);     // Check allowance
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
56     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
57         tokenRecipient spender = tokenRecipient(_spender);
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