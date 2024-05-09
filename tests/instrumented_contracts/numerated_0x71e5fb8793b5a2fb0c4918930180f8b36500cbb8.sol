1 pragma solidity ^0.5.1;
2 
3 contract transferable { function transfer(address to, uint256 value) public returns (bool); }
4 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public; }
5 
6 contract ElectricToken {
7     string public name = "Electric Token";
8     string public symbol = "ETR";
9     uint8 public decimals = 8;
10     address public owner;
11     uint256 public _totalSupply = 30000000000000000;
12 
13     mapping (address => uint256) public balances;
14     mapping (address => mapping (address => uint256)) public allowances;
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value);
17     event Burn(address indexed from, uint256 value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     constructor() public {
21         balances[msg.sender] = _totalSupply;
22         owner = msg.sender;
23         emit Transfer(address(0x0), msg.sender, _totalSupply);
24     }
25 
26     function balanceOf(address _owner) public view returns (uint256 balance) {
27         return balances[_owner];
28     }
29 
30     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
31         return allowances[_owner][_spender];
32     }
33 
34     function totalSupply() public view returns (uint256 supply) {
35         return _totalSupply;
36     }
37 
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         if (_to == address(0x0)) return false;
40         if (balances[msg.sender] < _value) return false;
41         if (balances[_to] + _value < balances[_to]) return false;
42         balances[msg.sender] -= _value;
43         balances[_to] += _value;
44         emit Transfer(msg.sender, _to, _value);
45         return true;
46     }
47 
48     function approve(address _spender, uint256 _value) public returns (bool success) {
49         allowances[msg.sender][_spender] = _value;
50         emit Approval(msg.sender, _spender, _value);
51         return true;
52     }
53 
54     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
55         tokenRecipient spender = tokenRecipient(_spender);
56         if (approve(_spender, _value)) {
57             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
58             return true;
59         }
60     }        
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         if (_to == address(0x0)) return false;
64         if (balances[_from] < _value) return false;
65         if (balances[_to] + _value < balances[_to]) return false;
66         if (_value > allowances[_from][msg.sender]) return false;
67         balances[_from] -= _value;
68         balances[_to] += _value;
69         allowances[_from][msg.sender] -= _value;
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function burn(uint256 _value) public returns (bool success) {
75         if (balances[msg.sender] < _value) return false;
76         balances[msg.sender] -= _value;
77         _totalSupply -= _value;
78         emit Burn(msg.sender, _value);
79         return true;
80     }
81 
82     function burnFrom(address _from, uint256 _value) public returns (bool success) {
83         if (balances[_from] < _value) return false;
84         if (_value > allowances[_from][msg.sender]) return false;
85         balances[_from] -= _value;
86         _totalSupply -= _value;
87         emit Burn(_from, _value);
88         return true;
89     }
90 
91     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
92         return transferable(tokenAddress).transfer(owner, tokens);
93     }
94 }