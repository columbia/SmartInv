1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18     event Burn(address indexed from, uint256 value);
19 
20     function TokenERC20(
21         uint256 initialSupply,
22         string tokenName,
23         string tokenSymbol
24     ) public {
25         tokenName = 'Meritocratic Token';
26         tokenSymbol = 'MRC';
27         initialSupply = 1000000000 * 10 ** uint256(decimals);
28         totalSupply = initialSupply;
29         balanceOf[msg.sender] = totalSupply;
30         name = tokenName;
31         symbol = tokenSymbol;
32     }
33 
34 
35     function _transfer(address _from, address _to, uint _value) internal {
36         require(_to != 0x0);
37 
38         require(balanceOf[_from] >= _value);
39 
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41 
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43 
44         balanceOf[_from] -= _value;
45 
46         balanceOf[_to] += _value;
47         emit Transfer(_from, _to, _value);
48 
49         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
50     }
51 
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         _transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         require(_value <= allowance[_from][msg.sender]);
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65 
66 
67     function approve(address _spender, uint256 _value) public
68         returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74 
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76         public
77         returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85 
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);
88         balanceOf[msg.sender] -= _value;
89         totalSupply -= _value;
90         emit Burn(msg.sender, _value);
91         return true;
92     }
93 
94 
95     function burnFrom(address _from, uint256 _value) public returns (bool success) {
96         require(balanceOf[_from] >= _value);
97         require(_value <= allowance[_from][msg.sender]);
98         balanceOf[_from] -= _value;
99         allowance[_from][msg.sender] -= _value;
100         totalSupply -= _value;
101         emit Burn(_from, _value);
102         return true;
103     }
104 }