1 pragma solidity ^0.4.16;
2    
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4     
5 contract owned {
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21         
22 contract RoscaERC20 is owned {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;  // 18 是建议的默认值
26     uint256 public totalSupply; 
27 
28     mapping (address => uint256) public balanceOf;  // 
29     mapping (address => mapping (address => uint256)) public allowance;
30     mapping (address => bool) public frozenAccount;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Burn(address indexed from, uint256 value);
34     event FrozenFunds(address target, bool frozen);
35 
36 
37     function RoscaERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
38         totalSupply = initialSupply * 10 ** uint256(decimals);
39         balanceOf[msg.sender] = totalSupply;
40         name = tokenName;
41         symbol = tokenSymbol;
42     }
43 
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         require(!frozenAccount[_from]);
50         require(!frozenAccount[_to]);
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]);     // Check allowance
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     function burn(uint256 _value) public returns (bool success) {
84         require(balanceOf[msg.sender] >= _value);
85         balanceOf[msg.sender] -= _value;
86         totalSupply -= _value;
87         Burn(msg.sender, _value);
88         return true;
89     }
90 
91     function burnFrom(address _from, uint256 _value) public returns (bool success) {
92         require(balanceOf[_from] >= _value);
93         require(_value <= allowance[_from][msg.sender]);
94         balanceOf[_from] -= _value;
95         allowance[_from][msg.sender] -= _value;
96         totalSupply -= _value;
97         Burn(_from, _value);
98         return true;
99     }
100 
101     //Freeze target acocunt || not allow received or transfer
102     function freezeAccount(address target, bool freeze) public onlyOwner {
103         frozenAccount[target] = freeze;
104         FrozenFunds(target, freeze);
105     }
106 }