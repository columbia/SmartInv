1 pragma solidity 0.4.20;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
4 }
5 
6 contract TCTToken {
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;  // 18 是建议的默认值
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;  // 
13     mapping (address => mapping (address => uint256)) public allowance;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     event Burn(address indexed from, uint256 value);
18 
19 
20     function TCTToken(uint256 initialSupply, string tokenName, string tokenSymbol) public {
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
57         if (approve(_spender, _value)) {
58             tokenRecipient(_spender).receiveApproval(msg.sender, _value, this, _extraData);
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