1 /*
2     Created by MART SOLUTION LIMITED
3     Website https://martcoin.io/
4 */
5 
6 pragma solidity ^0.4.18;
7 
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 contract TokenERC20 {
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31 
32     uint256 public totalSupply;
33 
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Burn(address indexed from, uint256 value);
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
55         require(balanceOf[_to] + _value > balanceOf[_to]);
56         uint previousBalances = balanceOf[_from] + balanceOf[_to];
57         balanceOf[_from] -= _value;
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
61     }
62 
63     function transfer(address _to, uint256 _value) public {
64         _transfer(msg.sender, _to, _value);
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         return true;
78     }
79 
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89 
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);
92         balanceOf[msg.sender] -= _value;
93         totalSupply -= _value;
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) public returns (bool success) {
99         require(balanceOf[_from] >= _value);
100         require(_value <= allowance[_from][msg.sender]);
101         balanceOf[_from] -= _value;
102         allowance[_from][msg.sender] -= _value;
103         totalSupply -= _value;
104         Burn(_from, _value);
105         return true;
106     }
107 }
108 
109 contract Martcoin is owned, TokenERC20 {
110     string public name = "Martcoin";
111     string public symbol = "MART";
112     uint public decimals = 18;
113     uint public INITIAL_SUPPLY = 29000000;
114 
115     mapping (address => bool) public frozenAccount;
116 
117     event FrozenFunds(address target, bool frozen);
118 
119     function Martcoin(
120         uint256 initialSupply,
121         string tokenName,
122         string tokenSymbol
123     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
124 
125     function _transfer(address _from, address _to, uint _value) internal {
126         require (_to != 0x0);
127         require (balanceOf[_from] >= _value);
128         require (balanceOf[_to] + _value > balanceOf[_to]);
129         require(!frozenAccount[_from]);
130         require(!frozenAccount[_to]);
131         balanceOf[_from] -= _value;
132         balanceOf[_to] += _value;
133         Transfer(_from, _to, _value);
134     }
135 
136     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
137         balanceOf[target] += mintedAmount;
138         totalSupply += mintedAmount;
139         Transfer(0, this, mintedAmount);
140         Transfer(this, target, mintedAmount);
141     }
142 
143     function freezeAccount(address target, bool freeze) onlyOwner public {
144         frozenAccount[target] = freeze;
145         FrozenFunds(target, freeze);
146     }
147 }