1 pragma solidity ^0.5.17;
2 
3 
4 //      ::::::::  :::            :::      ::::::::  :::    :::      ::::::::::: ::::::::  :::    ::: :::::::::: ::::    :::    
5 //    :+:    :+: :+:          :+: :+:   :+:    :+: :+:    :+:          :+:    :+:    :+: :+:   :+:  :+:        :+:+:   :+:     
6 //   +:+        +:+         +:+   +:+  +:+        +:+    +:+          +:+    +:+    +:+ +:+  +:+   +:+        :+:+:+  +:+      
7 //  +#+        +#+        +#++:++#++: +#++:++#++ +#++:++#++          +#+    +#+    +:+ +#++:++    +#++:++#   +#+ +:+ +#+       
8 // +#+        +#+        +#+     +#+        +#+ +#+    +#+          +#+    +#+    +#+ +#+  +#+   +#+        +#+  +#+#+#        
9 //#+#    #+# #+#        #+#     #+# #+#    #+# #+#    #+#          #+#    #+#    #+# #+#   #+#  #+#        #+#   #+#+#         
10 //########  ########## ###     ###  ########  ###    ###          ###     ########  ###    ### ########## ###    ####         
11 
12 //
13 
14 contract ClashToken {
15     
16     string public constant name = "Clash Token";
17 
18     string public constant symbol = "SCT";
19 
20     uint8 public constant decimals = 18;
21     
22     
23     address public owner;
24 
25     address public treasury;
26 
27     uint256 public totalSupply;
28 
29     mapping (address => mapping (address => uint256)) private allowed;
30     mapping (address => uint256) private balances;
31 
32     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     constructor() public {
37         owner = msg.sender;
38 
39         
40         treasury = address(0xf1DE6B3b09C6d0fF017A7dE45fA582766B9eECA8);
41 
42         
43         totalSupply = 10000000 * 10**uint(decimals);
44 
45         balances[treasury] = totalSupply;
46         emit Transfer(address(0), treasury, totalSupply);
47     }
48 
49     function () external payable {
50         revert();
51     }
52 
53     function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
54         return allowed[_tokenholder][_spender];
55     }
56 
57     function approve(address _spender, uint256 _value) public returns (bool) {
58         require(_spender != address(0));
59         require(_spender != msg.sender);
60 
61         allowed[msg.sender][_spender] = _value;
62 
63         emit Approval(msg.sender, _spender, _value);
64 
65         return true;
66     }
67 
68     function balanceOf(address _tokenholder) public view returns (uint256 balance) {
69         return balances[_tokenholder];
70     }
71 
72     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
73         require(_spender != address(0));
74         require(_spender != msg.sender);
75 
76         if (allowed[msg.sender][_spender] <= _subtractedValue) {
77             allowed[msg.sender][_spender] = 0;
78         } else {
79             allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
80         }
81 
82         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
83 
84         return true;
85     }
86 
87     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
88         require(_spender != address(0));
89         require(_spender != msg.sender);
90         require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);
91 
92         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
93 
94         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95 
96         return true;
97     }
98 
99     function transfer(address _to, uint256 _value) public returns (bool) {
100         require(_to != msg.sender);
101         require(_to != address(0));
102         require(_to != address(this));
103         require(balances[msg.sender] - _value <= balances[msg.sender]);
104         require(balances[_to] <= balances[_to] + _value);
105         require(_value <= transferableTokens(msg.sender));
106 
107         balances[msg.sender] = balances[msg.sender] - _value;
108         balances[_to] = balances[_to] + _value;
109 
110         emit Transfer(msg.sender, _to, _value);
111 
112         return true;
113     }
114 
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116         require(_from != address(0));
117         require(_from != address(this));
118         require(_to != _from);
119         require(_to != address(0));
120         require(_to != address(this));
121         require(_value <= transferableTokens(_from));
122         require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
123         require(balances[_from] - _value <= balances[_from]);
124         require(balances[_to] <= balances[_to] + _value);
125 
126         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
127         balances[_from] = balances[_from] - _value;
128         balances[_to] = balances[_to] + _value;
129 
130         emit Transfer(_from, _to, _value);
131 
132         return true;
133     }
134 
135     function transferOwnership(address _newOwner) public {
136         require(msg.sender == owner);
137         require(_newOwner != address(0));
138         require(_newOwner != address(this));
139         require(_newOwner != owner);
140 
141         address previousOwner = owner;
142         owner = _newOwner;
143 
144         emit OwnershipTransferred(previousOwner, _newOwner);
145     }
146 
147     function transferableTokens(address holder) public view returns (uint256) {
148         return balanceOf(holder);
149     }
150 }