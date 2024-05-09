1 pragma solidity ^0.4.0;
2 
3 
4 contract TTC {
5     
6     
7     // function balanceOf(address _owner) public view returns (uint256 balance);
8     // function transfer(address _to, uint256 _value) public returns (bool success);
9     // function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     // function approve(address _spender, uint256 _value) public returns (bool success);
11     // function allowance(address _owner, address _spender) public view returns (uint256 remaining);
12     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14     
15     uint256 constant private MAX_UINT256 = 2**256 - 1;
16     mapping (address => uint256) public balances;
17     mapping (address => mapping (address => uint256)) public allowed;
18     
19     string public name;                   //fancy name: eg Simon Bucks
20     string public symbol;                 //An identifier: eg SBX
21     uint8 public decimals;                //How many decimals to show.
22     
23     uint256 public totalSupply;
24     
25     address admin;
26     mapping (address => bool) admin_list;
27 
28     function TTC(
29         uint256 _initialAmount,
30         string _tokenName,
31         uint8 _decimalUnits,
32         string _tokenSymbol
33     ) public {
34         admin = msg.sender;
35         admin_list[admin] = true;
36         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
37         totalSupply = _initialAmount;                        // Update total supply
38         name = _tokenName;                                   // Set the name for display purposes
39         decimals = _decimalUnits;                            // Amount of decimals for display purposes
40         symbol = _tokenSymbol;                               // Set the symbol for display purposes
41     }
42 
43     
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         require(balances[msg.sender] >= _value);
46         balances[msg.sender] -= _value;
47         balances[_to] += _value;
48         emit Transfer(msg.sender, _to, _value);
49         return true;
50     }
51 
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
53         uint256 allowance = allowed[_from][msg.sender];
54         require(balances[_from] >= _value && allowance >= _value);
55         balances[_to] += _value;
56         balances[_from] -= _value;
57         if (allowance < MAX_UINT256) {
58             allowed[_from][msg.sender] -= _value;
59         }
60         emit Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function balanceOf(address _owner) public view returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) public returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         emit Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
75         return allowed[_owner][_spender];
76     }   
77     
78     function admin_setAdmin(address _target,bool _isAdmin) public returns (bool success) {
79         require(msg.sender == admin);
80         admin_list[_target] = _isAdmin;
81         return true;
82     }
83     
84     function admin_transfer(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(admin_list[msg.sender]);
86         require(balances[_from] >= _value);
87         balances[_from] -= _value;
88         balances[_to] += _value;
89         emit Transfer(_from, _to, _value);
90         return true;
91     }
92     
93 }