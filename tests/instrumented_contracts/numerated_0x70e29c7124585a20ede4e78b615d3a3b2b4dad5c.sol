1 pragma solidity ^0.4.18;
2 
3 contract Owner {
4     address public owner;
5     modifier onlyOwner { 
6       require(msg.sender == owner);
7      _;
8     }
9     function Owner() public { owner = msg.sender; }
10 }
11 
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public constant returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract DefensorWallet is ERC20, Owner {
27 
28   string public name;
29   string public symbol;
30   uint8 public decimals;
31   mapping(address => uint256) balances;
32   mapping (address => mapping (address => uint256)) allowed;
33 
34   struct FrozenToken {
35     bool isFrozenAll;
36     uint256 amount;
37     uint256 unfrozenDate;
38   }
39   mapping(address => FrozenToken) frozenTokens;
40 
41   event FrozenAccount(address target,bool freeze);
42   event FrozenAccountToken(address target,uint256 amount,uint256 unforzenDate);
43 
44   function DefensorWallet(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits) public {
45     balances[msg.sender] = initialSupply;
46     totalSupply = initialSupply;
47     name = tokenName;
48     decimals = decimalUnits;
49     symbol = tokenSymbol;
50   }
51 
52   function changeOwner(address newOwner) onlyOwner public {
53     owner = newOwner;
54   }
55 
56   function freezeAccount(address target,bool freeze) onlyOwner public {
57       frozenTokens[target].isFrozenAll = freeze;
58       FrozenAccount(target, freeze);
59   }
60 
61   function isAccountFreeze(address target) public constant returns (bool) {
62     return frozenTokens[target].isFrozenAll;
63   }
64 
65   function freezeAccountToken(address target,uint256 amount,uint256 date)  onlyOwner public {
66       require(amount > 0);
67       require(date > now);
68       frozenTokens[target].amount = amount;
69       frozenTokens[target].unfrozenDate = date;
70 
71       FrozenAccountToken(target,amount,date);
72   }
73 
74   function freezeAccountOf(address target) public view returns (uint256,uint256) {
75     return (frozenTokens[target].unfrozenDate,frozenTokens[target].amount);
76   }
77 
78   function transfer(address to,uint256 value) public returns (bool) {
79     require(msg.sender != to);
80     require(value > 0);
81     require(balances[msg.sender] >= value);
82     require(frozenTokens[msg.sender].isFrozenAll != true);
83 
84     if (frozenTokens[msg.sender].unfrozenDate > now) {
85         require(balances[msg.sender] - value >= frozenTokens[msg.sender].amount);
86     }
87 
88     balances[msg.sender] -= value;
89     balances[to] += value;
90     Transfer(msg.sender,to,value);
91 
92     return true;
93   }
94 
95   function balanceOf(address addr) public constant returns (uint256) {
96     return balances[addr];
97   }
98 
99   function allowance(address owner, address spender) public constant returns (uint256) {
100     return allowed[owner][spender];
101   }
102 
103   function transferFrom(address from, address to, uint256 value) public returns (bool) {
104     require (balances[from] >= value);
105     var _allowance = allowed[from][msg.sender];
106     require (_allowance >= value);
107     
108     balances[to] += value;
109     balances[from] -= value;
110     allowed[from][msg.sender] -= value;
111     Transfer(from, to, value);
112     return true;
113   }
114 
115   function approve(address _spender, uint256 _value) public returns (bool) {
116     allowed[msg.sender][_spender] = _value;
117     Approval(msg.sender, _spender, _value);
118     return true;
119   }
120 
121   function kill() onlyOwner public {
122     selfdestruct(owner);
123   }
124 }