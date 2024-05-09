1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37     constructor(
38         uint256 initialSupply,
39         string memory tokenName,
40         string memory tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46     }
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         require(_to != address(0x0));
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         emit Transfer(_from, _to, _value);
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60         _transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         emit Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
79         public
80         returns (bool success) {
81         tokenRecipient spender = tokenRecipient(_spender);
82         if (approve(_spender, _value)) {
83             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
84             return true;
85         }
86     }
87 
88     function burn(uint256 _value) public returns (bool success) {
89         require(balanceOf[msg.sender] >= _value);
90         balanceOf[msg.sender] -= _value;
91         totalSupply -= _value;
92         emit Burn(msg.sender, _value);
93         return true;
94     }
95 
96     function burnFrom(address _from, uint256 _value) public returns (bool success) {
97         require(balanceOf[_from] >= _value);
98         require(_value <= allowance[_from][msg.sender]);
99         balanceOf[_from] -= _value;
100         allowance[_from][msg.sender] -= _value;
101         totalSupply -= _value;
102         emit Burn(_from, _value);
103         return true;
104     }
105 }
106 
107 contract HKDCToken is owned, TokenERC20 {
108     mapping (address => bool) public frozenAccount;
109 
110     event FrozenFunds(address target, bool frozen);
111 
112     constructor(
113         uint256 initialSupply,
114         string memory tokenName,
115         string memory tokenSymbol
116     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
117 
118     function _transfer(address _from, address _to, uint _value) internal {
119         require (_to != address(0x0));
120         require (balanceOf[_from] >= _value);
121         require (balanceOf[_to] + _value >= balanceOf[_to]);
122         require(!frozenAccount[_from]);
123         require(!frozenAccount[_to]);
124         balanceOf[_from] -= _value;
125         balanceOf[_to] += _value;
126         emit Transfer(_from, _to, _value);
127     }
128 
129     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
130         balanceOf[target] += mintedAmount;
131         totalSupply += mintedAmount;
132         emit Transfer(address(0), address(this), mintedAmount);
133         emit Transfer(address(this), target, mintedAmount);
134     }
135 
136     function freezeAccount(address target, bool freeze) onlyOwner public {
137         frozenAccount[target] = freeze;
138         emit FrozenFunds(target, freeze);
139     }
140 }