1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ParkCoin {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function ParkCoin(uint256 initialSupply, string tokenName, string tokenSymbol) public {
18         totalSupply = initialSupply * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = tokenName;
21         symbol = tokenSymbol;
22     }
23 
24     function _transfer(address _from, address _to, uint _value) internal {
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value > balanceOf[_to]);
28 
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
41         require(_value <= allowance[_from][msg.sender]);
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
53     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
54         public
55         returns (bool success) {
56         tokenRecipient spender = tokenRecipient(_spender);
57         if (approve(_spender, _value)) {
58             spender.receiveApproval(msg.sender, _value, this, _extraData);
59             return true;
60         }
61     }
62 
63     function burn(uint256 _value) public returns (bool success) {
64         require(balanceOf[msg.sender] >= _value);
65         balanceOf[msg.sender] -= _value;
66         totalSupply -= _value;
67         Burn(msg.sender, _value);
68         return true;
69     }
70 
71     function burnFrom(address _from, uint256 _value) public returns (bool success) {
72         require(balanceOf[_from] >= _value);
73         require(_value <= allowance[_from][msg.sender]);
74         balanceOf[_from] -= _value;
75         allowance[_from][msg.sender] -= _value;
76         totalSupply -= _value;
77         Burn(_from, _value);
78         return true;
79     }
80 }