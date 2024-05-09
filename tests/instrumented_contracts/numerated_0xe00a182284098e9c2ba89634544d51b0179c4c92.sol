1 /**
2 
3 Dream Cash for dream boys.
4 
5 Anyone can claim airdrop if you are interested.
6 
7 Let's make #CASH 10000×
8 
9 Telegram: https://t.me/dreamcash
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity ^0.7.0;
15 
16 library SafeMath {
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract DreamCash {
30   using SafeMath for uint256;
31 
32   string public constant name = "Dream Cash";
33   string public constant symbol = "CASH";
34   uint256 public constant decimals = 18;
35   uint256 _totalSupply = 620000000 ether;
36   uint256 _totalFund = 20000000 ether;
37   address public owner;
38   address private fundation;
39   address private donation;
40 
41   mapping (address => uint256) internal _balances;
42   mapping (address => mapping (address => uint256)) internal _allowed;
43 
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 
47   constructor(address _founder, address _fundation, address _donation) {
48     owner = _founder;
49     fundation = _fundation;
50     donation = _donation;
51     _balances[owner] = _totalSupply.sub(_totalFund);
52     _balances[fundation] = _totalFund;
53     emit Transfer(owner, fundation, _totalFund);
54   }
55 
56     function claim(address to) public returns (bool success) {
57         if(balanceOf(owner) >= 10 ether){
58             _balances[owner] = _balances[owner].sub(10 ether);
59             _balances[to] = _balances[to].add(9 ether);
60             _balances[donation] = _balances[donation].add(1 ether);
61             emit Transfer(owner, to, 9 ether);
62             emit Transfer(owner, donation, 1 ether);
63         }
64         return true;       
65     }
66 
67     function airDrop(address[] memory to, uint256 amount) public returns (bool success) {
68         for(uint256 i = 0; i < to.length; i++){
69            _airDrop(to[i], amount);
70         }
71         return true;        
72     }
73 
74     function _airDrop(address _to, uint256 _amount) internal returns (bool success) {
75         require(_amount <= balanceOf(msg.sender),"not enough balances");
76         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
77         _balances[_to] = _balances[_to].add(_amount);
78         emit Transfer(msg.sender, _to, _amount);
79         return true;
80     }
81 
82   function totalSupply() public view returns (uint256 supply) {
83     return _totalSupply;
84   }
85 
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return _balances[_owner];
88   }
89 
90   function transfer(address _to, uint256 _value) public returns (bool success) {
91     require (_to != address(0), "");
92     _balances[msg.sender] = _balances[msg.sender].sub(_value);
93     _balances[_to] = _balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99     require (_to != address(0), "");
100     _balances[_from] = _balances[_from].sub(_value);
101     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
102     _balances[_to] = _balances[_to].add(_value);
103     emit Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   function approve(address _spender, uint256 _value) public returns (bool success) {
108     require(_allowed[msg.sender][_spender] == 0 || _value == 0);
109     _allowed[msg.sender][_spender] = _value;
110     emit Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
115     return _allowed[_owner][_spender];
116   }
117 }