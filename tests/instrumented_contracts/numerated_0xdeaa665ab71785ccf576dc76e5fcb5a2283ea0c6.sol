1 pragma solidity ^0.5.8;
2 
3 //Change the contract name to your token name
4 contract YEARNYFINETWORK {
5     // Name your custom token
6     string public constant name = "YEARNYFI.NETWORK";
7 
8     // Name your custom token symbol
9     string public constant symbol = "YNI";
10 
11     uint8 public constant decimals = 18;
12     
13     // Contract owner will be your Link account
14     address public owner;
15 
16     address public treasury;
17 
18     uint256 public totalSupply;
19 
20     mapping (address => mapping (address => uint256)) private allowed;
21     mapping (address => uint256) private balances;
22 
23     event Approval(address indexed tokenholder, address indexed spender, uint256 value);
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     constructor() public {
28         owner = msg.sender;
29 
30         // Add your wallet address here which will contain your total token supply
31         treasury = address(0xD982633b51b5b255d261fd222f269ac9fC9313B9);
32 
33         // Set your total token supply (default 18000)
34         totalSupply = 18000 * 10**uint(decimals);
35 
36         balances[treasury] = totalSupply;
37         emit Transfer(address(0), treasury, totalSupply);
38     }
39 
40     function () external payable {
41         revert();
42     }
43 
44     function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
45         return allowed[_tokenholder][_spender];
46     }
47 
48     function approve(address _spender, uint256 _value) public returns (bool) {
49         require(_spender != address(0));
50         require(_spender != msg.sender);
51 
52         allowed[msg.sender][_spender] = _value;
53 
54         emit Approval(msg.sender, _spender, _value);
55 
56         return true;
57     }
58 
59     function balanceOf(address _tokenholder) public view returns (uint256 balance) {
60         return balances[_tokenholder];
61     }
62 
63     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
64         require(_spender != address(0));
65         require(_spender != msg.sender);
66 
67         if (allowed[msg.sender][_spender] <= _subtractedValue) {
68             allowed[msg.sender][_spender] = 0;
69         } else {
70             allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
71         }
72 
73         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
74 
75         return true;
76     }
77 
78     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
79         require(_spender != address(0));
80         require(_spender != msg.sender);
81         require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);
82 
83         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
84 
85         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86 
87         return true;
88     }
89 
90     function transfer(address _to, uint256 _value) public returns (bool) {
91         require(_to != msg.sender);
92         require(_to != address(0));
93         require(_to != address(this));
94         require(balances[msg.sender] - _value <= balances[msg.sender]);
95         require(balances[_to] <= balances[_to] + _value);
96         require(_value <= transferableTokens(msg.sender));
97 
98         balances[msg.sender] = balances[msg.sender] - _value;
99         balances[_to] = balances[_to] + _value;
100 
101         emit Transfer(msg.sender, _to, _value);
102 
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_from != address(0));
108         require(_from != address(this));
109         require(_to != _from);
110         require(_to != address(0));
111         require(_to != address(this));
112         require(_value <= transferableTokens(_from));
113         require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
114         require(balances[_from] - _value <= balances[_from]);
115         require(balances[_to] <= balances[_to] + _value);
116 
117         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
118         balances[_from] = balances[_from] - _value;
119         balances[_to] = balances[_to] + _value;
120 
121         emit Transfer(_from, _to, _value);
122 
123         return true;
124     }
125 
126     function transferOwnership(address _newOwner) public {
127         require(msg.sender == owner);
128         require(_newOwner != address(0));
129         require(_newOwner != address(this));
130         require(_newOwner != owner);
131 
132         address previousOwner = owner;
133         owner = _newOwner;
134 
135         emit OwnershipTransferred(previousOwner, _newOwner);
136     }
137 
138     function transferableTokens(address holder) public view returns (uint256) {
139         return balanceOf(holder);
140     }
141 }