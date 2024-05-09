1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b); 
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b; 
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   
32 }
33 
34 
35 contract Owner {
36     address public owner;
37     modifier onlyOwner { 
38       require(msg.sender == owner);
39      _;
40     }
41     function Owner() public { owner = msg.sender; }
42 }
43 
44 contract ERC20Basic {
45   uint256 public totalSupply;
46   function balanceOf(address who) public constant returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract DefensorWallet is ERC20, Owner{
59 
60   using SafeMath for uint;
61   string public name;
62   string public symbol;
63   uint8 public decimals;
64   mapping(address => uint256) balances;
65   mapping (address => mapping (address => uint256)) allowed;
66 
67   struct FrozenToken {
68     bool isFrozenAll;
69     uint256 amount;
70     uint256 unfrozenDate;
71   }
72   mapping(address => FrozenToken) frozenTokens;
73 
74   event FrozenAccount(address target,bool freeze);
75   event FrozenAccountToken(address target,uint256 amount,uint256 unforzenDate);
76 
77   function DefensorWallet(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits) public {
78     balances[msg.sender] = initialSupply;
79     totalSupply = initialSupply;
80     name = tokenName;
81     decimals = decimalUnits;
82     symbol = tokenSymbol;
83   }
84 
85   function changeOwner(address newOwner) onlyOwner public {
86     owner = newOwner;
87   }
88 
89   function freezeAccount(address target,bool freeze) onlyOwner public {
90       frozenTokens[target].isFrozenAll = freeze;
91       FrozenAccount(target, freeze);
92   }
93 
94   function isAccountFreeze(address target) public constant returns (bool) {
95     return frozenTokens[target].isFrozenAll;
96   }
97 
98   function freezeAccountToken(address target,uint256 amount,uint256 date)  onlyOwner public {
99       require(amount > 0);
100       require(date > now);
101       frozenTokens[target].amount = amount;
102       frozenTokens[target].unfrozenDate = date;
103 
104       FrozenAccountToken(target,amount,date);
105   }
106 
107   function freezeAccountOf(address target) public view returns (uint256,uint256) {
108     return (frozenTokens[target].unfrozenDate,frozenTokens[target].amount);
109   }
110 
111   function transfer(address to,uint256 value) public returns (bool) {
112     require(msg.sender != to);
113     require(value > 0);
114     require(balances[msg.sender] >= value);
115     require(frozenTokens[msg.sender].isFrozenAll != true);
116 
117     if (frozenTokens[msg.sender].unfrozenDate > now) {
118         require(balances[msg.sender] - value >= frozenTokens[msg.sender].amount);
119     }
120 
121     balances[msg.sender] = balances[msg.sender].sub(value);
122     balances[to] = balances[to].add(value);
123     Transfer(msg.sender,to,value);
124 
125     return true;
126   }
127 
128   function balanceOf(address addr) public constant returns (uint256) {
129     return balances[addr];
130   }
131 
132   function allowance(address owner, address spender) public constant returns (uint256) {
133     return allowed[owner][spender];
134   }
135 
136   function transferFrom(address from, address to, uint256 value) public returns (bool) {
137     require (balances[from] >= value);
138     var _allowance = allowed[from][msg.sender];
139     require (_allowance >= value);
140     
141     balances[to] = balances[to].add(value);
142     balances[from] = balances[from].sub(value);
143     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
144     Transfer(from, to, value);
145     return true;
146   }
147 
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   function kill() onlyOwner public {
155     selfdestruct(owner);
156   }
157 }