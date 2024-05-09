1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 contract TokenERC20 {
19     string public name;
20     string public symbol;
21     uint8 public decimals = 18;
22     uint256 public totalSupply;
23 
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     event Burn(address indexed from, uint256 value);
30 
31     function TokenERC20(
32         uint256 initialSupply,
33         string tokenName,
34         string tokenSymbol
35     ) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         balanceOf[msg.sender] = totalSupply;
38         name = tokenName;
39         symbol = tokenSymbol;
40     }
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 
80     function burn(uint256 _value) public returns (bool success) {
81         require(balanceOf[msg.sender] >= _value);
82         balanceOf[msg.sender] -= _value;
83         totalSupply -= _value;
84         emit Burn(msg.sender, _value);
85         return true;
86     }
87 
88     function burnFrom(address _from, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);
90         require(_value <= allowance[_from][msg.sender]);
91         balanceOf[_from] -= _value;
92         allowance[_from][msg.sender] -= _value;
93         totalSupply -= _value;
94         emit Burn(_from, _value);
95         return true;
96     }
97 }
98 
99 contract MyAdvancedToken is owned, TokenERC20 {
100 
101     uint256 public sellPrice;
102     uint256 public buyPrice;
103 
104     mapping (address => bool) public frozenAccount;
105 
106     event FrozenFunds(address target, bool frozen);
107 
108     function MyAdvancedToken(
109         uint256 initialSupply,
110         string tokenName,
111         string tokenSymbol
112     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
113 
114     function _transfer(address _from, address _to, uint _value) internal {
115         require (_to != 0x0);
116         require (balanceOf[_from] >= _value);
117         require (balanceOf[_to] + _value > balanceOf[_to]);
118         require(!frozenAccount[_from]);
119         require(!frozenAccount[_to]);
120         balanceOf[_from] -= _value;
121         balanceOf[_to] += _value;
122         emit Transfer(_from, _to, _value);
123     }
124 
125     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
126         balanceOf[target] += mintedAmount;
127         totalSupply += mintedAmount;
128         emit Transfer(0, this, mintedAmount);
129         emit Transfer(this, target, mintedAmount);
130     }
131 
132     function freezeAccount(address target, bool freeze) onlyOwner public {
133         frozenAccount[target] = freeze;
134         emit FrozenFunds(target, freeze);
135     }
136 }