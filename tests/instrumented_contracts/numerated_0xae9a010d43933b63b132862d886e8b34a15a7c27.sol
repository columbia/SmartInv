1 pragma solidity ^0.4.16;
2 // Create by Tiny熊
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 
22 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
23 
24 // 10000000000, "HuiLian Token","HKDH"
25 contract HKDHToken is owned {
26     // Public variables of the token
27     string public name;
28     string public symbol;
29     uint8 public decimals = 2;
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35     mapping (address => bool) public frozenAccount;
36 
37     /* This generates a public event on the blockchain that will notify clients */
38     event FrozenFunds(address target, bool frozen);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Burn(address indexed from, uint256 value);
42 
43     function HKDHToken(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);
48         balanceOf[msg.sender] = totalSupply;
49         name = tokenName;
50         symbol = tokenSymbol;
51     }
52 
53     /**
54      * Internal transfer, only can be called by this contract
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         require(_to != 0x0);
58         require(balanceOf[_from] >= _value);
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60 
61         require(!frozenAccount[_from]);
62         require(!frozenAccount[_to]); 
63 
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         balanceOf[_from] -= _value;
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     function transfer(address _to, uint256 _value) public {
72         _transfer(msg.sender, _to, _value);
73     }
74 
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     // Check allowance
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83 
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
91         public
92         returns (bool success) {
93         tokenRecipient spender = tokenRecipient(_spender);
94         if (approve(_spender, _value)) {
95             spender.receiveApproval(msg.sender, _value, this, _extraData);
96             return true;
97         }
98     }
99 
100     function freezeAccount(address target, bool freeze) onlyOwner public {
101         frozenAccount[target] = freeze;
102         FrozenFunds(target, freeze);
103     }
104 
105     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
106         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
107         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
108         totalSupply -= _value;                              // Update totalSupply
109         Burn(_from, _value);
110         return true;
111     }
112 }