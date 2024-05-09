1 pragma solidity ^0.4.18;
2 
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
23 
24   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
25     if (b == 0){
26       return 1;
27     }
28     uint256 c = a**b;
29     assert (c >= a);
30     return c;
31   }
32 }
33 
34 //it's contract name:
35 
36 contract YourCustomTokenJABACO{ //ERC - 20 token contract
37   using SafeMath for uint;
38   // Triggered when tokens are transferred.
39   event Transfer(address indexed _from, address indexed _to, uint256 _value);
40 
41   // Triggered whenever approve(address _spender, uint256 _value) is called.
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44 
45   // It's nessesary ERC-20 parameters
46   string public constant symbol = "JABAS";
47   string public constant name = "JABATOKENS";
48   uint8 public constant decimals = 4;
49   uint256 _totalSupply = 10000000000;
50  
51 
52   // Owner of this contract
53   address public owner;
54 
55   // Balances for each account
56   mapping(address => uint256) balances;
57 
58   // Owner of account approves the transfer of an amount to another account
59   mapping(address => mapping (address => uint256)) allowed;
60 
61   function totalSupply() public view returns (uint256) { //standart ERC-20 function
62     return _totalSupply;
63   }
64 
65   function balanceOf(address _address) public view returns (uint256 balance) {//standart ERC-20 function
66     return balances[_address];
67   }
68   
69   //standart ERC-20 function
70   function transfer(address _to, uint256 _amount) public returns (bool success) {
71     balances[msg.sender] = balances[msg.sender].sub(_amount);
72     balances[_to] = balances[_to].add(_amount);
73     Transfer(msg.sender,_to,_amount);
74     return true;
75   }
76 
77   //standart ERC-20 function
78   function transferFrom(address _from, address _to, uint256 _amount) public returns(bool success){
79     balances[_from] = balances[_from].sub(_amount);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
81     balances[_to] = balances[_to].add(_amount);
82     Transfer(_from,_to,_amount);
83     return true;
84   }
85   //standart ERC-20 function
86   function approve(address _spender, uint256 _amount)public returns (bool success) { 
87     allowed[msg.sender][_spender] = _amount;
88     Approval(msg.sender, _spender, _amount);
89     return true;
90   }
91 
92   //standart ERC-20 function
93   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
94     return allowed[_owner][_spender];
95   }
96 
97   //Constructor
98   function YourCustomTokenJABACO() public {
99     owner = msg.sender;
100     balances[msg.sender] = _totalSupply;
101     Transfer(this,msg.sender,_totalSupply);
102   } 
103 }