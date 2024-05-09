1 pragma solidity ^0.4.18;
2 
3 contract EIP20Interface {
4 
5     function balanceOf(address _owner) public view returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13     event Burn(address indexed _from, uint256 _value);
14     event FrozenFunds(address target, bool frozen);
15 }
16 
17 contract TokenContract is EIP20Interface {
18     
19     uint256 constant MAX_UINT256 = 2**256 - 1;
20     address public owner;
21 
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     function () payable public {
28     }
29 
30     uint256 public totalSupply;
31     string public name;
32     uint8 public decimals = 18;
33     string public symbol;
34 
35     function TokenContract(
36         uint256 _initialAmount,
37         string _tokenName,
38         uint8 _decimalUnits,
39         string _tokenSymbol
40         ) public {
41         owner = msg.sender;   
42         balances[msg.sender] = _initialAmount;
43         totalSupply = _initialAmount;
44         name = _tokenName;
45         decimals = _decimalUnits;
46         symbol = _tokenSymbol;
47     }
48 
49     function transfer(address _to, uint256 _value) public returns (bool success) {
50         require(!frozen[msg.sender]);
51         require(balances[msg.sender] >= _value);
52         balances[msg.sender] -= _value;
53         balances[_to] += _value;
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(!frozen[msg.sender]);
60         require(!frozen[_from]);
61         uint256 allowance = allowed[_from][msg.sender];
62         require(balances[_from] >= _value && allowance >= _value);
63         balances[_to] += _value;
64         balances[_from] -= _value;
65         if (allowance < MAX_UINT256) {
66             allowed[_from][msg.sender] -= _value;
67         }
68         Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function balanceOf(address _owner) view public returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success) {
77         require(!frozen[msg.sender]);
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     function burn(uint256 _value) public returns (bool success) {
88         require(!frozen[msg.sender]);
89         require(balances[msg.sender] >= _value);
90         balances[msg.sender] -= _value;
91         totalSupply -= _value;
92         Burn(msg.sender, _value);
93         return true;
94     }
95 
96     function transferOwnership(address _newOwner) public onlyOwner { 
97         owner = _newOwner; 
98     }
99 
100     function withdraw() public onlyOwner {
101         owner.transfer(this.balance);
102     }
103 
104     function mintToken(address _target, uint256 _amount) public onlyOwner {
105         balances[_target] += _amount;
106         totalSupply += _amount;
107         Transfer(0, owner, _amount);
108         if (_target != owner) {
109             Transfer(owner, _target, _amount);
110         }
111     }
112 
113     function freezeAccount(address _target, bool _freeze) public onlyOwner {
114         frozen[_target] = _freeze;
115         FrozenFunds(_target, _freeze);
116     }
117 
118     mapping (address => uint256) balances;
119     mapping (address => mapping (address => uint256)) allowed;
120     mapping (address => bool) frozen;
121 }