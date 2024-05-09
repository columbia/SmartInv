1 pragma solidity ^0.4.18;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public view returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 contract SchruteBuck {
9     address owner = msg.sender;
10 
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13 
14     uint256 public totalContribution = 0;
15 
16     uint256 public totalSupply = 0;
17     uint256 public maxTotalSupply = 19660120 * 10**18;
18     
19     string public fact = "Bears eat beets.";
20     uint256 public lastFactChangeValue = 0;
21 
22     function name() public pure returns (string) { return "Schrute Buck"; }
23     function symbol() public pure returns (string) { return "SRB"; }
24     function decimals() public pure returns (uint8) { return 18; }
25     function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
26     
27     function changeFact(string _string) public {
28         if (balances[msg.sender] <= lastFactChangeValue) { revert(); }
29         lastFactChangeValue = balances[msg.sender];
30         fact = _string;
31     }
32     
33     function transfer(address _to, uint256 _value) public returns (bool success) {
34         // mitigates the ERC20 short address attack
35         if(msg.data.length < (2 * 32) + 4) { revert(); }
36 
37         if (_value == 0) { return false; }
38 
39         uint256 fromBalance = balances[msg.sender];
40 
41         bool sufficientFunds = fromBalance >= _value;
42         bool overflowed = balances[_to] + _value < balances[_to];
43         
44         if (sufficientFunds && !overflowed) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52     
53     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
54         // mitigates the ERC20 short address attack
55         if(msg.data.length < (3 * 32) + 4) { revert(); }
56 
57         if (_value == 0) { return false; }
58         
59         uint256 fromBalance = balances[_from];
60         uint256 allowance = allowed[_from][msg.sender];
61 
62         bool sufficientFunds = fromBalance <= _value;
63         bool sufficientAllowance = allowance <= _value;
64         bool overflowed = balances[_to] + _value > balances[_to];
65 
66         if (sufficientFunds && sufficientAllowance && !overflowed) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             
70             allowed[_from][msg.sender] -= _value;
71             
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76     
77     function approve(address _spender, uint256 _value) public returns (bool success) {
78         // mitigates the ERC20 spend/approval race condition
79         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
80         
81         allowed[msg.sender][_spender] = _value;
82         
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86     
87     function allowance(address _owner, address _spender) public view returns (uint256) {
88         return allowed[_owner][_spender];
89     }
90 
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
93 
94     function withdrawForeignTokens(address _tokenContract) public returns (bool) {
95         if (msg.sender != owner) { revert(); }
96 
97         ForeignToken token = ForeignToken(_tokenContract);
98 
99         uint256 amount = token.balanceOf(address(this));
100         return token.transfer(owner, amount);
101     }
102 
103     function getStats() public view returns (uint256, uint256) {
104         return (totalContribution, totalSupply);
105     }
106 
107     function() public payable {
108         if (msg.value < 1 finney) { revert(); }
109         if (totalSupply > maxTotalSupply) { revert(); }
110 
111         owner.transfer(msg.value);
112         totalContribution += msg.value;
113         
114         uint256 tokensIssued = (msg.value * 1000);
115         if (totalSupply + tokensIssued > maxTotalSupply) { revert(); }
116 
117         totalSupply += tokensIssued;
118         balances[msg.sender] += tokensIssued;
119         
120         Transfer(address(this), msg.sender, tokensIssued);
121     }
122 }