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
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 is owned{
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31     mapping (address => bool) public frozenAccount;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     event FrozenFunds(address target, bool frozen);
40 
41     function TokenERC20(
42         uint256 initialSupply,
43         string tokenName,
44         string tokenSymbol
45     ) public {
46         totalSupply = initialSupply * 10 ** uint256(decimals);
47         balanceOf[msg.sender] = totalSupply;
48         name = tokenName;
49         symbol = tokenSymbol;
50     }
51 
52     function _transfer(address _from, address _to, uint _value) internal {
53         require(_to != 0x0);
54         require(balanceOf[_from] >= _value);
55         require(balanceOf[_to] + _value >= balanceOf[_to]);
56         
57         require(!frozenAccount[_from]);
58         require(!frozenAccount[_to]);
59 
60         uint previousBalances = balanceOf[_from] + balanceOf[_to];
61         balanceOf[_from] -= _value;
62         balanceOf[_to] += _value;
63 
64         emit Transfer(_from, _to, _value);
65 
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 
69     function transfer(address _to, uint256 _value) public returns (bool success) {
70         _transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool success) {
82         allowance[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
88         public
89         returns (bool success) {
90         tokenRecipient spender = tokenRecipient(_spender);
91         if (approve(_spender, _value)) {
92             spender.receiveApproval(msg.sender, _value, this, _extraData);
93             return true;
94         }
95     }
96 
97     function burn(uint256 _value) public returns (bool success) {
98         require(balanceOf[msg.sender] >= _value);
99         balanceOf[msg.sender] -= _value;
100         totalSupply -= _value;
101         emit Burn(msg.sender, _value);
102         return true;
103     }
104 
105     function burnFrom(address _from, uint256 _value) public returns (bool success) {
106         require(balanceOf[_from] >= _value);
107         require(_value <= allowance[_from][msg.sender]);
108         balanceOf[_from] -= _value;
109         allowance[_from][msg.sender] -= _value;
110         totalSupply -= _value;
111         emit Burn(_from, _value);
112         return true;
113     }
114 
115     function freezeAccount(address target, bool freeze) onlyOwner public {
116         frozenAccount[target] = freeze;
117         emit FrozenFunds(target, freeze);
118     }
119 }