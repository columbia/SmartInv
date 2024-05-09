1 pragma solidity ^0.4.25;
2 
3 
4 contract Q {
5 
6     uint256 public totalSupply;
7 
8     mapping (address => uint256) public balances;
9     mapping (address => mapping (address => uint256)) public allowed;
10     mapping (address => bool) public centralUsers;
11 
12     string public name;
13     uint8 public decimals;
14     string public symbol;
15     address public owner;
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     constructor(
21         uint256 _initialAmount,
22         string _tokenName,
23         uint8 _decimalUnits,
24         string _tokenSymbol,
25         address [] _centralUsers
26     ) public {
27         balances[msg.sender] = _initialAmount;
28         totalSupply = _initialAmount;
29         name = _tokenName;
30         decimals = _decimalUnits;
31         symbol = _tokenSymbol;
32         owner = msg.sender;
33         for (uint8 i = 0; i< _centralUsers.length; i++){
34             centralUsers[_centralUsers[i]] = true;
35         }
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     modifier onlyCentralUser() {
44         require(centralUsers[msg.sender] == true);
45         _;
46     }
47 
48     function setCentralUser(address user) public onlyOwner {
49         centralUsers[user] = true;
50     }
51 
52     function removeCentralUser(address user) public onlyOwner {
53         centralUsers[user] = false;
54     }
55 
56     function _transfer(address _from, address _to, uint256 _value) internal {
57         require(balances[_from] >= _value);
58         balances[_from] -= _value;
59         balances[_to] += _value;
60         emit Transfer(_from, _to, _value);
61     }
62 
63     function feeCentralTransfer(address _from, address _to, uint256 _value, uint256 _charge) public onlyCentralUser returns (bool success) {
64         // charge
65         
66         // not charge company account
67         if (_from != owner && _charge != 0) {
68             _transfer(_from, owner, _charge);
69         }
70         _value = _value - _charge;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function centralTransfer(address _from, address _to, uint256 _value) public onlyCentralUser returns (bool success) {
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         _transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         uint256 allowance = allowed[_from][msg.sender];
87         require(balances[_from] >= _value && allowance >= _value);
88         balances[_to] += _value;
89         balances[_from] -= _value;
90         allowed[_from][msg.sender] -= _value;
91         emit Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
106         return allowed[_owner][_spender];
107     }
108 }