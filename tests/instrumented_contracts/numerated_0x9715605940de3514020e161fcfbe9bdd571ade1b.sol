1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 
6 contract owned {
7         address public owner;
8 
9         function owned() {
10             owner = msg.sender;
11         }
12 
13         modifier onlyOwner {
14             require(msg.sender == owner);
15             _;
16         }
17 
18         // 实现所有权转移
19         function transferOwnership(address newOwner) onlyOwner {
20             owner = newOwner;
21         }
22     }
23 
24 contract TokenERC20 is owned {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 18;  // 18 是建议的默认值
28     uint256 public totalSupply;
29 
30     mapping (address => uint256) public balanceOf;  // 
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37 
38     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);
40         balanceOf[msg.sender] = totalSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43     }
44 
45 
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != 0x0);
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         Transfer(_from, _to, _value);
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     function transfer(address _to, uint256 _value) public {
58         _transfer(msg.sender, _to, _value);
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);     // Check allowance
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
75         tokenRecipient spender = tokenRecipient(_spender);
76         if (approve(_spender, _value)) {
77             spender.receiveApproval(msg.sender, _value, this, _extraData);
78             return true;
79         }
80     }
81 
82     function burn(uint256 _value) public returns (bool success) {
83         require(balanceOf[msg.sender] >= _value);
84         balanceOf[msg.sender] -= _value;
85         totalSupply -= _value;
86         Burn(msg.sender, _value);
87         return true;
88     }
89     
90     function mintToken(address target, uint256 mintedAmount) onlyOwner {
91         balanceOf[target] += mintedAmount;
92         totalSupply += mintedAmount;
93         Transfer(0, owner, mintedAmount);
94         Transfer(owner, target, mintedAmount);
95     }
96 }