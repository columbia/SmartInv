1 pragma solidity ^0.4.8;
2 
3 /// @title ERC20 Token
4 /// @author Melonport AG <team@melonport.com>
5 /// @notice Original taken from https://github.com/ethereum/EIPs/issues/20
6 /// @notice Checked against integer overflow
7 contract ERC20 {
8 
9     function transfer(address _to, uint256 _value) returns (bool success) {
10         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
11             balances[msg.sender] -= _value;
12             balances[_to] += _value;
13             Transfer(msg.sender, _to, _value);
14             return true;
15         } else { return false; }
16     }
17 
18     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
19         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
20             balances[_to] += _value;
21             balances[_from] -= _value;
22             allowed[_from][msg.sender] -= _value;
23             Transfer(_from, _to, _value);
24             return true;
25         } else { return false; }
26     }
27 
28     function balanceOf(address _owner) constant returns (uint256 balance) {
29         return balances[_owner];
30     }
31 
32     function approve(address _spender, uint256 _value) returns (bool success) {
33         allowed[msg.sender][_spender] = _value;
34         Approval(msg.sender, _spender, _value);
35         return true;
36     }
37 
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
39         return allowed[_owner][_spender];
40     }
41 
42     mapping (address => uint256) balances;
43 
44     mapping (address => mapping (address => uint256)) allowed;
45 
46     uint256 public totalSupply;
47 
48     address public owner;
49 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 
53     modifier onlyowner(address _requester) {
54         if (_requester != owner) {
55             throw;
56         }
57         _;
58     }
59 
60     event Mint(address indexed _owner, uint256 _value, uint256 _totalSupply);
61     event Burn(address indexed _owner, uint256 _value, uint256 _totalSupply);
62     event ChangeOwner(address indexed _oldOwner, address indexed _newOwner);
63 
64     function ERC20() {
65         owner = msg.sender;
66     }
67 
68     function mint(uint _value) onlyowner(msg.sender) {
69         if (balances[owner] + _value < balances[owner]) {
70             // overflow
71             throw;
72         }
73         balances[owner] += _value;
74         totalSupply += _value;
75         Mint(owner, _value, totalSupply);
76     }
77 
78     function burn(uint _value) onlyowner(msg.sender) {
79         if (balances[owner] < _value) {
80             throw;
81         }
82         balances[owner] -= _value;
83         totalSupply -= _value;
84         Burn(owner, _value, totalSupply);
85     }
86 
87     function changeOwner(address _owner) onlyowner(msg.sender) {
88         owner = _owner;
89         ChangeOwner(msg.sender, owner);
90     }
91 
92 }