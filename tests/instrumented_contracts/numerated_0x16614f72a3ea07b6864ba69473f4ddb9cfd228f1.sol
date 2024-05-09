1 pragma solidity ^0.4.24;
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
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46     }
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         require(_to != 0x0);
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
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function burn(uint256 _value) public returns (bool success) {
73         require(balanceOf[msg.sender] >= _value);
74         balanceOf[msg.sender] -= _value;
75         totalSupply -= _value;
76         emit Burn(msg.sender, _value);
77         return true;
78     }
79 
80     function burnFrom(address _from, uint256 _value) public returns (bool success) {
81         require(balanceOf[_from] >= _value);
82         require(_value <= allowance[_from][msg.sender]);
83         balanceOf[_from] -= _value;
84         allowance[_from][msg.sender] -= _value;
85         totalSupply -= _value;
86         emit Burn(_from, _value);
87         return true;
88     }
89 }
90 
91 contract AdvancedToken is owned, TokenERC20 {
92 
93     uint256 public sellPrice;
94     uint256 public buyPrice;
95 
96     mapping (address => bool) public frozenAccount;
97 
98     event FrozenFunds(address target, bool frozen);
99 
100     constructor() TokenERC20(1000000000, "BigcoinStarToken", "BST") public {}
101 
102     function _transfer(address _from, address _to, uint _value) internal {
103         require (_to != 0x0);
104         require (balanceOf[_from] >= _value);
105         require (balanceOf[_to] + _value >= balanceOf[_to]);
106         require (!frozenAccount[_from]);
107         require (!frozenAccount[_to]);
108         balanceOf[_from] -= _value;
109         balanceOf[_to] += _value;
110         emit Transfer(_from, _to, _value);
111     }
112 
113 
114     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
115         balanceOf[target] += mintedAmount;
116         totalSupply += mintedAmount;
117         emit Transfer(0, this, mintedAmount);
118         emit Transfer(this, target, mintedAmount);
119     }
120 
121 
122     function freezeAccount(address target, bool freeze) onlyOwner public {
123         frozenAccount[target] = freeze;
124         emit FrozenFunds(target, freeze);
125     }
126 }