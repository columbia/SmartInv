1 contract ERC20Interface {
2 
3     string public constant name = "CCTV";
4     string public constant symbol = "ZY";
5     uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
6 
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 pragma solidity ^0.4.16;
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;  // 18 是建议的默认值
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;  // 
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35 
36     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);
38         balanceOf[msg.sender] = totalSupply;
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42 
43 
44     function _transfer(address _from, address _to, uint _value) internal {
45         require(_to != 0x0);
46         require(balanceOf[_from] >= _value);
47         require(balanceOf[_to] + _value > balanceOf[_to]);
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         balanceOf[_from] -= _value;
50         balanceOf[_to] += _value;
51         Transfer(_from, _to, _value);
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53     }
54 
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
60         require(_value <= allowance[_from][msg.sender]);     // Check allowance
61         allowance[_from][msg.sender] -= _value;
62         _transfer(_from, _to, _value);
63         return true;
64     }
65 
66     function approve(address _spender, uint256 _value) public
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         return true;
70     }
71 
72     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
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
84         Burn(msg.sender, _value);
85         return true;
86     }
87 
88     function burnFrom(address _from, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);
90         require(_value <= allowance[_from][msg.sender]);
91         balanceOf[_from] -= _value;
92         allowance[_from][msg.sender] -= _value;
93         totalSupply -= _value;
94         Burn(_from, _value);
95         return true;
96     }
97 }