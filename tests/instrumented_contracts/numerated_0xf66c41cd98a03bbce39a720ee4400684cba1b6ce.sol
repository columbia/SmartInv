1 //standart library for uint
2 pragma solidity ^0.4.21;
3 library SafeMath { 
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0 || b == 0){
6         return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 }
24 
25 contract Ownable {
26 
27   address public owner;
28 
29   address public newOwner;
30 
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   function transferOwnership(address _newOwner) public onlyOwner {
41     require(_newOwner != address(0));
42     newOwner = _newOwner;
43   }
44 
45   function acceptOwnership() public {
46     if (msg.sender == newOwner) {
47       owner = newOwner;
48     }
49   }
50 }
51 
52 contract BidiumToken is Ownable { //ERC - 20 token contract
53   using SafeMath for uint;
54   // Triggered when tokens are transferred.
55   event Transfer(address indexed _from, address indexed _to, uint256 _value);
56 
57   // Triggered whenever approve(address _spender, uint256 _value) is called.
58   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 
60   string public constant symbol = "BIDM";
61   string public constant name = "BIDIUM";
62   uint8 public constant decimals = 4;
63   uint256 _totalSupply = 1000000000 * (10 ** uint(decimals));
64 
65   // Owner of this contract
66   address public owner;
67 
68   // Balances for each account
69   mapping(address => uint256) balances;
70 
71   // Owner of account approves the transfer of an amount to another account
72   mapping(address => mapping (address => uint256)) allowed;
73 
74   function totalSupply() public view returns (uint256) { //standart ERC-20 function
75     return _totalSupply;
76   }
77 
78   function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function
79     return balances[_address];
80   }
81   
82   bool public locked = true;
83   function unlockTransfer () public onlyOwner {
84     locked = false;
85   }
86   
87   //standart ERC-20 function
88   function transfer(address _to, uint256 _amount) public returns (bool success) {
89     require(this != _to);
90     require(!locked);
91     balances[msg.sender] = balances[msg.sender].sub(_amount);
92     balances[_to] = balances[_to].add(_amount);
93     emit Transfer(msg.sender,_to,_amount);
94     return true;
95   }
96 
97   //standart ERC-20 function
98   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
99     require(this != _to);
100     require(!locked);
101     balances[_from] = balances[_from].sub(_amount);
102     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
103     balances[_to] = balances[_to].add(_amount);
104     emit Transfer(_from,_to,_amount);
105     return true;
106   }
107   //standart ERC-20 function
108   function approve(address _spender, uint256 _amount)public returns (bool success) { 
109     allowed[msg.sender][_spender] = _amount;
110     emit Approval(msg.sender, _spender, _amount);
111     return true;
112   }
113 
114   //standart ERC-20 function
115   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
116     return allowed[_owner][_spender];
117   }
118 
119   //Constructor
120   function BidiumToken(address _sale, address _advisors, address _founders, address _reserve) public {
121     require(_founders != address(0) && _advisors != address(0) && _founders != address(0) && _reserve != address(0));
122     owner = msg.sender;
123     balances[_founders] = 30000000* (10 ** uint(decimals));
124     balances[_sale] = 850000000* (10 ** uint(decimals));
125     balances[_advisors] = 20000000* (10 ** uint(decimals));
126     balances[_reserve] = 100000000* (10 ** uint(decimals));
127 
128     emit Transfer(this,_founders,30000000 * (10 ** uint(decimals)));
129     emit Transfer(this,_sale,850000000* (10 ** uint(decimals)));
130     emit Transfer(this,_advisors,20000000* (10 ** uint(decimals)));
131     emit Transfer(this,_reserve,100000000* (10 ** uint(decimals)));
132   }
133 
134   function multiplyTokensSend (address[] _addresses, uint256[] _values) public {
135     require(!locked);
136     uint buffer = 0;
137 
138     for (uint i = 0; i < _addresses.length; i++){
139       balances[_addresses[i]] = balances[_addresses[i]].add(_values[i]);
140       buffer = buffer.add(_values[i]);
141       emit Transfer(msg.sender,_addresses[i],_values[i]);
142     }
143     balances[msg.sender] = balances[msg.sender].sub(buffer);
144   }
145   
146 }