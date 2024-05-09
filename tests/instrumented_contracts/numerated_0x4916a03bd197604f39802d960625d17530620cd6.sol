1 /* ==================================================================== */
2 /* Copyright (c) 2018 The TokenTycoon Project.  All rights reserved.
3 /* 
4 /* https://tokentycoon.io
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.23;
11 
12 contract AccessAdmin {
13     bool public isPaused = false;
14     address public addrAdmin;  
15 
16     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
17 
18     constructor() public {
19         addrAdmin = msg.sender;
20     }  
21 
22 
23     modifier onlyAdmin() {
24         require(msg.sender == addrAdmin);
25         _;
26     }
27 
28     modifier whenNotPaused() {
29         require(!isPaused);
30         _;
31     }
32 
33     modifier whenPaused {
34         require(isPaused);
35         _;
36     }
37 
38     function setAdmin(address _newAdmin) external onlyAdmin {
39         require(_newAdmin != address(0));
40         emit AdminTransferred(addrAdmin, _newAdmin);
41         addrAdmin = _newAdmin;
42     }
43 
44     function doPause() external onlyAdmin whenNotPaused {
45         isPaused = true;
46     }
47 
48     function doUnpause() external onlyAdmin whenPaused {
49         isPaused = false;
50     }
51 }
52 
53 interface TokenRecipient { 
54     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
55 }
56 
57 contract TalentCard is AccessAdmin {
58     uint8 public decimals = 0;
59     uint256 public totalSupply = 1000000000;
60     string public name = "Token Tycoon Talent Card";
61     string public symbol = "TTTC";
62 
63     mapping (address => uint256) balances;
64     mapping (address => mapping(address => uint256)) allowed;
65     /// @dev Trust contract
66     mapping (address => bool) safeContracts;
67     
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71     constructor() public {
72         addrAdmin = msg.sender;
73 
74         balances[this] = totalSupply;
75     }
76 
77     function balanceOf(address _owner) external view returns (uint256) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) public returns (bool) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) external view returns (uint256) {
88         return allowed[_owner][_spender];
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
92         require(_value <= allowed[_from][msg.sender]);
93         allowed[_from][msg.sender] -= _value;
94         return _transfer(_from, _to, _value);
95     }
96 
97     function transfer(address _to, uint256 _value) external returns (bool) {
98         return _transfer(msg.sender, _to, _value);     
99     }
100 
101     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
102         require(_to != address(0));
103         uint256 oldFromVal = balances[_from];
104         require(_value > 0 && oldFromVal >= _value);
105         uint256 oldToVal = balances[_to];
106         uint256 newToVal = oldToVal + _value;
107         require(newToVal > oldToVal);
108         uint256 newFromVal = oldFromVal - _value;
109         balances[_from] = newFromVal;
110         balances[_to] = newToVal;
111 
112         assert((oldFromVal + oldToVal) == (newFromVal + newToVal));
113         emit Transfer(_from, _to, _value);
114 
115         return true;
116     }
117 
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         external
120         returns (bool success) {
121         TokenRecipient spender = TokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 
128     function setSafeContract(address _actionAddr, bool _useful) external onlyAdmin {
129         safeContracts[_actionAddr] = _useful;
130     }
131 
132     function getSafeContract(address _actionAddr) external view onlyAdmin returns(bool) {
133         return safeContracts[_actionAddr];
134     }
135 
136     function safeSendCard(uint256 _amount, address _to) external {
137         require(safeContracts[msg.sender]);
138         require(balances[address(this)] >= _amount);
139         require(_to != address(0));
140 
141         _transfer(address(this), _to, _amount);
142     }
143 }