1 pragma solidity ^ 0.4 .2;
2 contract Token {
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8     address public owner;
9     address[] public users;
10     bytes32 public filehash;
11     
12     mapping(address => uint256) public balanceOf;
13     mapping(address => mapping(address => uint256)) public allowance;
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     modifier onlyOwner() {
17         if (owner != msg.sender) {
18             throw;
19         } else {
20             _;
21         }
22     }
23 
24     function Token() {
25         owner = 0x7F325a2d8365385e4B189b708274526899c17453;
26        // filehash = 0x26be3f796356cf26183f91fea302911533808f5ee8f58cad05c03249a1b96997;
27         address firstOwner = owner;
28         balanceOf[firstOwner] = 100000000;
29         totalSupply = 100000000;
30         name = 'Cryptonian';
31         symbol = 'crypt';
32         decimals = 8;
33         msg.sender.send(msg.value);
34         users.push(0x7F325a2d8365385e4B189b708274526899c17453);
35     }
36 
37     function transfer(address _to, uint256 _value) {
38         if (balanceOf[msg.sender] < _value) throw;
39         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
40         balanceOf[msg.sender] -= _value;
41         balanceOf[_to] += _value;
42         Transfer(msg.sender, _to, _value);
43         bool userExists = false;
44         uint memberCount = users.length;
45         for (uint i = 0; i < memberCount; i++) {
46             if (users[i] == _to) {
47                 userExists = true;
48             }
49         }
50         if (userExists == false) {
51             users.push(_to);
52         }
53     }
54 
55     function approve(address _spender, uint256 _value) returns(bool success) {
56         allowance[msg.sender][_spender] = _value;
57         return true;
58     }
59 
60     function collectExcess() onlyOwner {
61         owner.send(this.balance - 2100000);
62     }
63 
64     function liquidate(address newOwner) onlyOwner {
65         uint sellAmount = msg.value;
66         uint memberCount = users.length;
67         owner = newOwner;
68         for (uint i = 0; i < memberCount; i++) {
69             liquidateUser(users[i], sellAmount);
70         }
71     }
72 
73     function liquidateUser(address user, uint sentValue) onlyOwner {
74         uint userBalance = balanceOf[user] * 10000000;
75         uint userPercentage = userBalance / totalSupply;
76         uint etherAmount = (sentValue * userPercentage) / 10000000;
77         if (user.send(etherAmount)) {
78             balanceOf[user] = 0;
79         }
80     }
81 
82     function issueDividend() onlyOwner {
83         uint sellAmount = msg.value;
84         uint memberCount = users.length;
85         for (uint i = 0; i < memberCount; i++) {
86             sendDividend(users[i], sellAmount);
87         }
88     }
89 
90     function sendDividend(address user, uint sentValue) onlyOwner {
91         uint userBalance = balanceOf[user] * 10000000;
92         uint userPercentage = userBalance / totalSupply;
93         uint etherAmount = (sentValue * userPercentage) / 10000000;
94         if (user.send(etherAmount)) {}
95     }
96 
97     function() {}
98 }