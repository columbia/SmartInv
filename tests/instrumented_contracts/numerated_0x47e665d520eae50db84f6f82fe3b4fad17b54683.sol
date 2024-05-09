1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 
17     // ʵ������Ȩת��
18     function transferOwnership(address newOwner) onlyOwner {
19         owner = newOwner;
20     }
21 }
22 
23 
24 contract TokenERC20 is owned {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 6;  // 18 �ǽ����Ĭ��ֵ
28     uint256 public totalSupply;
29     address public centralMinter;
30 
31     mapping (address => uint256) public balanceOf;  // 
32     mapping (address => mapping (address => uint256)) public allowance;
33     mapping (address => bool) public frozenAccount;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     event FrozenFunds(address target, bool frozen);
40 
41     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46         
47         if(centralMinter != 0 ) owner = centralMinter;
48     }
49 
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         require(_to != 0x0);
53         require(balanceOf[_from] >= _value);
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         balanceOf[_from] -= _value;
57         balanceOf[_to] += _value;
58         Transfer(_from, _to, _value);
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public {
63         require(!frozenAccount[msg.sender]);
64         _transfer(msg.sender, _to, _value);
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) onlyOwner returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     // Check allowance
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) onlyOwner
75         returns (bool success) {
76         require(!frozenAccount[msg.sender]);
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }
88 
89     function burn(uint256 _value) onlyOwner returns (bool success) {
90         require(balanceOf[msg.sender] >= _value);
91         balanceOf[msg.sender] -= _value;
92         totalSupply -= _value;
93         Burn(msg.sender, _value);
94         return true;
95     }
96 
97     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {
98         require(balanceOf[_from] >= _value);
99         require(_value <= allowance[_from][msg.sender]);
100         balanceOf[_from] -= _value;
101         allowance[_from][msg.sender] -= _value;
102         totalSupply -= _value;
103         Burn(_from, _value);
104         return true;
105     }
106     
107     function freezeAccount(address target, bool freeze) onlyOwner {
108     frozenAccount[target] = freeze;
109     FrozenFunds(target, freeze);
110     }
111 
112 }