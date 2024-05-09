1 pragma solidity ^0.4.25;
2 
3 
4 contract T {
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
19     // 8888800000000,"center for digital finacial assets",8,"T", ["0x72F720B4fa62F0d12EF58F2E460272548C897c5a","0x27e04E00B3A092CF7B943C31d3DC1b292f1B41e9"]
20 
21 
22     constructor(
23         uint256 _initialAmount,
24         string _tokenName,
25         uint8 _decimalUnits,
26         string _tokenSymbol,
27         address [] _centralUsers
28     ) public {
29         balances[msg.sender] = _initialAmount;
30         totalSupply = _initialAmount;
31         name = _tokenName;
32         decimals = _decimalUnits;
33         symbol = _tokenSymbol;
34         owner = msg.sender;
35         for (uint8 i = 0; i< _centralUsers.length; i++){
36             centralUsers[_centralUsers[i]] = true;
37         }
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     modifier onlyCentralUser() {
46         require(centralUsers[msg.sender] == true);
47         _;
48     }
49 
50     function setCentralUser(address user) public onlyOwner {
51         centralUsers[user] = true;
52     }
53 
54     function removeCentralUser(address user) public onlyOwner {
55         centralUsers[user] = false;
56     }
57 
58     function _transfer(address _from, address _to, uint256 _value) internal {
59         require(balances[_from] >= _value);
60         balances[_from] -= _value;
61         balances[_to] += _value;
62         emit Transfer(_from, _to, _value);
63     }
64 
65     function feeCentralTransfer(address _from, address _to, uint256 _value, uint256 _charge) public onlyCentralUser returns (bool success) {
66         // charge
67 
68         // not charge company account
69         if (_from != owner && _charge != 0) {
70             _transfer(_from, owner, _charge);
71         }
72         _value = _value - _charge;
73         _transfer(_from, _to, _value);
74         return true;
75     }
76 
77     function centralTransfer(address _from, address _to, uint256 _value) public onlyCentralUser returns (bool success) {
78         _transfer(_from, _to, _value);
79         return true;
80     }
81 
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         _transfer(msg.sender, _to, _value);
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         uint256 allowance = allowed[_from][msg.sender];
89         require(balances[_from] >= _value && allowance >= _value);
90         balances[_to] += _value;
91         balances[_from] -= _value;
92         allowed[_from][msg.sender] -= _value;
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         emit Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }
110 }