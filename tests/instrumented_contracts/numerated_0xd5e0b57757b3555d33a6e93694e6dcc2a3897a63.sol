1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 //- KU.INK
6 contract ERC_20_2 {
7     string public name; 
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     bool public lockAll = false;
12     address public creator;
13     address public owner;
14     address internal newOwner = 0x0;
15 
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18     mapping (address => bool) public frozens;
19 
20     event Transfer(address indexed _from, address indexed _to, uint256 _value);
21     event TransferExtra(address indexed _from, address indexed _to, uint256 _value, bytes _extraData);
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23     event Burn(address indexed _from, uint256 _value);
24     event Offer(uint256 _supplyTM);
25     event OwnerChanged(address _oldOwner, address _newOwner);
26     event FreezeAddress(address indexed _target, bool _frozen);
27 
28     constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
29         name = tokenName;
30         symbol = tokenSymbol;
31         decimals = tokenDecimals;
32         totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);
33         
34         balanceOf[msg.sender] = totalSupply;
35         owner = msg.sender;
36         creator = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner, "unverified owner");
41         _;
42     }
43 	
44     function offer(uint256 _supplyTM) onlyOwner public returns (bool success){
45         require(_supplyTM > 0, "unverified supplyTM");
46 		uint256 tm = _supplyTM * 1000 * 10000 * 10 ** uint256(decimals);
47         totalSupply += tm;
48         balanceOf[msg.sender] += tm;
49         emit Offer(_supplyTM);
50         return true;
51     }
52 
53     function transferOwnership(address _newOwner) onlyOwner public returns (bool success){
54         require(owner != _newOwner, "unverified newOwner");
55         newOwner = _newOwner;
56         return true;
57     }
58     
59     function acceptOwnership() public returns (bool success){
60         require(msg.sender == newOwner && newOwner != 0x0, "unverified newOwner");
61         address oldOwner = owner;
62         owner = newOwner;
63         newOwner = 0x0;
64         emit OwnerChanged(oldOwner, owner);
65         return true;
66     }
67 
68     function setLockAll(bool _lockAll) onlyOwner public returns (bool success){
69         lockAll = _lockAll;
70         return true;
71     }
72 
73     function setFreezeAddress(address _target, bool _freeze) onlyOwner public returns (bool success){
74         frozens[_target] = _freeze;
75         emit FreezeAddress(_target, _freeze);
76         return true;
77     }
78 
79     function _transfer(address _from, address _to, uint256 _value) internal {
80         require(!lockAll, "unverified status");
81         require(_to != 0x0, "unverified to address");
82         require(_value > 0, "unverified value");
83         require(balanceOf[_from] >= _value, "unverified balance");
84         require(!frozens[_from], "unverified from address status"); 
85 
86         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
87         balanceOf[_from] -= _value;
88         balanceOf[_to] += _value;
89 		emit Transfer(_from, _to, _value);
90 
91         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
92     }
93 
94     function transfer(address _to, uint256 _value) public returns (bool success) {
95         _transfer(msg.sender, _to, _value);
96         return true;
97     }
98 	
99     function transferExtra(address _to, uint256 _value, bytes _extraData) public returns (bool success) {
100         _transfer(msg.sender, _to, _value);
101 		emit TransferExtra(msg.sender, _to, _value, _extraData);
102         return true;
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender], "unverified sender address");
107 
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     function _burn(address _from, uint256 _value) internal {
128         require(!lockAll, "unverified status");
129         require(balanceOf[_from] >= _value, "unverified balance");
130         require(!frozens[_from], "unverified from status"); 
131 
132         balanceOf[_from] -= _value;
133         totalSupply -= _value;
134 
135         emit Burn(_from, _value);
136     }
137 
138     function burn(uint256 _value) public returns (bool success) {
139         _burn(msg.sender, _value);
140         return true;
141     }
142 
143     function burnFrom(address _from, uint256 _value) public returns (bool success) {
144         require(_value <= allowance[_from][msg.sender], "unverified balance");
145         allowance[_from][msg.sender] -= _value;
146 
147         _burn(_from, _value);
148         return true;
149     }
150 
151     function() payable public{
152     }
153 }