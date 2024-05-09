1 pragma solidity ^0.4.24;
2  
3 library SafeMath {
4 
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);  
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     uint c = a / b;
13     return c;
14   }
15 
16   function sub(uint a, uint b) internal returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint a, uint b) internal returns (uint) {
22     uint c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 
27 }
28 
29 
30 contract ERC20Basic {
31 
32   uint public totalSupply;
33   function balanceOf(address who) constant returns (uint);
34   function transfer(address to, uint value);
35   event Transfer(address indexed from, address indexed to, uint value);
36   
37   function allowance(address owner, address spender) constant returns (uint);
38   function transferFrom(address from, address to, uint value);
39   function approve(address spender, uint value);
40   event Approval(address indexed owner, address indexed spender, uint value);
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45 
46   using SafeMath for uint;
47     
48   address public owner;
49   
50   mapping(address => uint) balances;
51 
52   //The frozen accounts 
53   mapping (address => bool) public frozenAccount;
54   
55   modifier unFrozenAccount{
56       require(!frozenAccount[msg.sender]);
57       _;
58   }
59   
60   modifier onlyOwner {
61       require(owner == msg.sender);
62       _;  
63   }
64     
65   /// Emitted when the target account is frozen
66   event FrozenFunds(address target, bool frozen);
67   
68 
69   function transfer(address _to, uint _value) unFrozenAccount {
70 	balances[msg.sender] = balances[msg.sender].sub(_value);
71 	balances[_to] = balances[_to].add(_value);
72 	Transfer(msg.sender, _to, _value);
73   }
74 
75   function balanceOf(address _owner) view returns (uint balance) {
76     return balances[_owner];
77   }
78 
79   ///@notice `freeze? Prevent | Allow` `target` from sending & receiving TOKEN preconditions
80   ///@param target Address to be frozen
81   ///@param freeze To freeze the target account or not
82   function freezeAccount(address target, bool freeze) onlyOwner public {
83       frozenAccount[target]=freeze;
84       FrozenFunds(target, freeze);
85     }
86   
87   function accountFrozenStatus(address target) view returns (bool frozen) {
88       return frozenAccount[target];
89   }
90   
91 }
92 
93 
94 contract StandardToken is BasicToken {
95 
96   mapping (address => mapping (address => uint)) allowed;
97 
98   function transferFrom(address _from, address _to, uint _value)  unFrozenAccount {
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check account _from  is not frozen
102     require(!frozenAccount[_from]);
103     
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108   }
109 
110   function approve(address _spender, uint _value) unFrozenAccount {
111     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115   }
116 
117   function allowance(address _owner, address _spender) view returns (uint remaining) {
118     return allowed[_owner][_spender];
119   }
120   
121 }
122 
123 
124 contract BCETFToken is StandardToken {
125     string public name = "BCETF";
126     string public symbol = "BCETF";
127     uint public decimals = 18;
128 	address constant tokenWallet = 0xD38c34e2B6da1fad17648C557fAfe5e561c1A136;
129     /**
130      * CONSTRUCTOR, This address will be : 0x...
131      */
132     function BCETFToken() {
133         owner = msg.sender;
134         totalSupply = 10 * (10 ** 26);
135         balances[tokenWallet] = totalSupply;
136 		emit Transfer(0x0, tokenWallet, totalSupply);
137     }
138 
139     function () public payable {
140         revert();
141     }
142 }