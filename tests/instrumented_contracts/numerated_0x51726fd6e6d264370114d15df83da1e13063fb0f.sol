1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract ERC_20_2 {
6     string public name; 
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10     bool public lockAll = false;
11     address public creator;
12     address public owner;
13     address internal newOwner = 0x0;
14 
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17     mapping (address => bool) public frozens;
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event TransferExtra(address indexed _from, address indexed _to, uint256 _value, bytes _extraData);
21     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
22     event Burn(address indexed _from, uint256 _value);
23     event Offer(uint256 _supplyTM);
24     event OwnerChanged(address _oldOwner, address _newOwner);
25     event FreezeAddress(address indexed _target, bool _frozen);
26 
27     constructor(uint256 initialSupplyHM, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
28         name = tokenName;
29         symbol = tokenSymbol;
30         decimals = tokenDecimals;
31         totalSupply = initialSupplyHM * 10000 * 10000 * 10 ** uint256(decimals);
32         
33         balanceOf[msg.sender] = totalSupply;
34         owner = msg.sender;
35         creator = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner, "unverified owner");
40         _;
41     }
42 	
43     function offer(uint256 _supplyTM) onlyOwner public returns (bool success){
44         require(_supplyTM > 0, "unverified supplyTM");
45 		uint256 tm = _supplyTM * 1000 * 10000 * 10 ** uint256(decimals);
46         totalSupply += tm;
47         balanceOf[msg.sender] += tm;
48         emit Offer(_supplyTM);
49         return true;
50     }
51 
52     function transferOwnership(address _newOwner) onlyOwner public returns (bool success){
53         require(owner != _newOwner, "unverified newOwner");
54         newOwner = _newOwner;
55         return true;
56     }
57     
58     function acceptOwnership() public returns (bool success){
59         require(msg.sender == newOwner && newOwner != 0x0, "unverified newOwner");
60         address oldOwner = owner;
61         owner = newOwner;
62         newOwner = 0x0;
63         emit OwnerChanged(oldOwner, owner);
64         return true;
65     }
66 
67     function setLockAll(bool _lockAll) onlyOwner public returns (bool success){
68         lockAll = _lockAll;
69         return true;
70     }
71 
72     function setFreezeAddress(address _target, bool _freeze) onlyOwner public returns (bool success){
73         frozens[_target] = _freeze;
74         emit FreezeAddress(_target, _freeze);
75         return true;
76     }
77 
78     function _transfer(address _from, address _to, uint256 _value) internal {
79         require(!lockAll, "unverified status");
80         require(_to != 0x0, "unverified to address");
81         require(_value > 0, "unverified value");
82         require(balanceOf[_from] >= _value, "unverified balance");
83         require(!frozens[_from], "unverified from address status"); 
84 
85         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
86         balanceOf[_from] -= _value;
87         balanceOf[_to] += _value;
88 		emit Transfer(_from, _to, _value);
89 
90         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
91     }
92 
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         _transfer(msg.sender, _to, _value);
95         return true;
96     }
97 	
98     function transferExtra(address _to, uint256 _value, bytes _extraData) public returns (bool success) {
99         _transfer(msg.sender, _to, _value);
100 		emit TransferExtra(msg.sender, _to, _value, _extraData);
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender], "unverified sender address");
106 
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
119         tokenRecipient spender = tokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125 
126     function _burn(address _from, uint256 _value) internal {
127         require(!lockAll, "unverified status");
128         require(balanceOf[_from] >= _value, "unverified balance");
129         require(!frozens[_from], "unverified from status"); 
130 
131         balanceOf[_from] -= _value;
132         totalSupply -= _value;
133 
134         emit Burn(_from, _value);
135     }
136 
137     function burn(uint256 _value) public returns (bool success) {
138         _burn(msg.sender, _value);
139         return true;
140     }
141 
142     function burnFrom(address _from, uint256 _value) public returns (bool success) {
143         require(_value <= allowance[_from][msg.sender], "unverified balance");
144         allowance[_from][msg.sender] -= _value;
145 
146         _burn(_from, _value);
147         return true;
148     }
149 
150     function() payable public{
151     }
152 }