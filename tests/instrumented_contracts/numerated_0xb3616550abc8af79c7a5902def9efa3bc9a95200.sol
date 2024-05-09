1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external;
5 }
6 
7 contract owned {
8     address public owner;
9     address public newOwner;
10 
11     event OwnershipTransferred(address indexed _from, address indexed _to);
12 
13     constructor() owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) onlyOwner public returns (bool success) {
23         newOwner = _newOwner;
24         return true;
25     }
26 
27     function acceptOwnership() public returns (bool success) {
28         require(msg.sender == newOwner);
29         owner = newOwner;
30         emit OwnershipTransferred(owner, newOwner);
31         newOwner = address(0);
32         return true;
33     }
34 }
35 
36 contract TokenERC20 is owned {
37     string public name = 'Telex';
38     string public symbol = 'TLX';
39     uint8 public decimals = 8;
40     uint public totalSupply = 2000000000000000;
41 
42     mapping (address => uint) public balanceOf;
43     mapping (address => mapping (address => uint)) public allowance;
44     mapping (address => bool) public frozenAccount;
45 
46     event Transfer(address indexed from, address indexed to, uint value);
47     event Approval(address indexed _owner, address indexed _spender, uint _value);
48     event FrozenFunds(address indexed target, bool frozen);
49 
50     constructor() TokenERC20() public {
51         balanceOf[msg.sender] = totalSupply;
52     }
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55         require(_to != 0x0);
56         require(balanceOf[_from] >= _value);
57         require(balanceOf[_to] + _value > balanceOf[_to]);
58         if (msg.sender != owner) {
59           require(!frozenAccount[msg.sender]);
60           require(!frozenAccount[_from]);
61           require(!frozenAccount[_to]);
62         }
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];
64         balanceOf[_from] -= _value;
65         balanceOf[_to] += _value;
66         emit Transfer(_from, _to, _value);
67         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
68     }
69 
70     function _multipleTransfer(address _from, address[] addresses, uint[] amounts) internal {
71         for (uint i=0; i<addresses.length; i++) {
72             address _to = addresses[i];
73             uint _value = amounts[i];
74             _transfer(_from, _to, _value);
75         }
76     }
77 
78     function transfer(address _to, uint _value) public returns (bool success) {
79         _transfer(msg.sender, _to, _value);
80         return true;
81     }
82 
83     function multipleTransfer(address[] addresses, uint[] amounts) public returns (bool success) {
84         _multipleTransfer(msg.sender, addresses, amounts);
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
89         if (msg.sender != owner) {
90             require(allowance[_from][msg.sender] >= _value);
91             allowance[_from][msg.sender] -= _value;
92         }
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint _value) public returns (bool success) {
98         allowance[msg.sender][_spender] = _value;
99         emit Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
104         tokenRecipient spender = tokenRecipient(_spender);
105         if (approve(_spender, _value)) {
106             spender.receiveApproval(msg.sender, _value, this, _extraData);
107             return true;
108         }
109     }
110 
111     function freezeAccount(address target, bool freeze) onlyOwner public returns (bool success) {
112         frozenAccount[target] = freeze;
113         emit FrozenFunds(target, freeze);
114         return true;
115     }
116 }