1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'V-KITA' token contract
5 // Symbol      : KITA
6 // Name        : V-KITA
7 // Decimals    : 8
8 //
9 // 2019 | By V-KITA IDTeam
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b > 0);
23         uint256 c = a / b;
24         assert(a == b * c + a % b);
25         return a / b;
26     }
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract VKITAToken {
39     using SafeMath for uint256;
40     address owner = msg.sender;
41     string public symbol;
42     string public  name;
43     uint8 public decimals;
44     uint _totalSupply;
45 
46     // Balances for each account
47     mapping (address => uint256) public balanceOf;
48     // Owner of account approves the transfer of an amount to another account
49     mapping (address => mapping (address => uint256)) public allowance;
50     
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     constructor() public {
55         symbol = "KITA";
56         name = "V-KITA";
57         decimals = 8;
58         _totalSupply = 45000000 * 9**uint(decimals);
59         balanceOf[owner] = _totalSupply;
60         emit Transfer(address(0), owner, _totalSupply);
61     }
62     function totalSupply() public view returns (uint) {
63         return _totalSupply.sub(balanceOf[address(0)]);
64     }
65     function balanceOf(address _owner) constant public returns (uint256) {
66         return balanceOf[_owner];
67     }
68 
69     // Transfer the balance from owner's account to another account
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(_to != address(this));
72         require(_value <= balanceOf[msg.sender]);
73         balanceOf[msg.sender] = balanceOf[msg.sender].sub (_value);
74         balanceOf[_to] = balanceOf[_to].add (_value);
75         emit Transfer(msg.sender, _to, _value);
76         return true;
77     }
78     // A contract attempts to get the coins   
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_to != address(this));
81         require(_value <= balanceOf[_from]);
82         require(_value <= allowance[_from][msg.sender]);
83         balanceOf[_from] = balanceOf[_from].sub (_value);
84         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub (_value);
85         balanceOf[_to] = balanceOf[_to].add (_value);
86         emit Transfer(_from, _to, _value);
87         return true;
88     }
89      // Allow another contract to spend some tokens in your behalf
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91     require((_value == 0) || (allowance[msg.sender][_spender] == 0));
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95     function allowance(address _owner, address _spender) constant public returns (uint256) {
96         return allowance[_owner][_spender];
97     }
98 }