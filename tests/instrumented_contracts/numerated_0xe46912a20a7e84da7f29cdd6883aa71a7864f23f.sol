1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC223ReceivingContract {
28     function tokenFallback(address _from, uint256 _value, bytes _data) public;
29 }
30 
31 contract ERC20ERC223 {
32   uint256 public totalSupply;
33   function balanceOf(address _owner) public constant returns (uint256);
34   function transfer(address _to, uint256 _value) public returns (bool);
35   function transfer(address _to, uint256 _value, bytes _data) public returns (bool);
36   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
37   function approve(address _spender, uint256 _value) public returns (bool success);
38   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
39   
40   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value);
41   event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data);
42   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 }
44 
45 contract Deco is ERC20ERC223 {
46 
47   using SafeMath for uint256;
48 
49   string public constant name = "Deco";
50   string public constant symbol = "DEC";
51   uint8 public constant decimals = 18;
52   
53   uint256 public constant totalSupply = 6*10**26; // 600,000,000. 000,000,000,000,000,000 units
54     
55   // Accounts
56   
57   mapping(address => Account) private accounts;
58   
59   struct Account {
60     uint256 balance;
61     mapping(address => uint256) allowed;
62     mapping(address => bool) isAllowanceAuthorized;
63   }  
64   
65   // Fix for the ERC20 short address attack.
66   // http://vessenes.com/the-erc20-short-address-attack-explained/
67   modifier onlyPayloadSize(uint256 size) {
68     require(msg.data.length >= size + 4);
69      _;
70   }
71 
72   // Initialization
73 
74   function Deco() {
75     accounts[msg.sender].balance = totalSupply;
76     Transfer(this, msg.sender, totalSupply);
77   }
78 
79   // Balance
80 
81   function balanceOf(address _owner) constant returns (uint256) {
82     return accounts[_owner].balance;
83   }
84 
85   // Transfers
86 
87   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) returns (bool) {
88     performTransfer(msg.sender, _to, _value, "");
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function transfer(address _to, uint256 _value, bytes _data) onlyPayloadSize(2 * 32) returns (bool) {
94     performTransfer(msg.sender, _to, _value, _data);
95     Transfer(msg.sender, _to, _value, _data);
96     return true;
97   }
98 
99   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) returns (bool) {
100     require(hasApproval(_from, msg.sender));
101     uint256 _allowed = accounts[_from].allowed[msg.sender];    
102     performTransfer(_from, _to, _value, "");    
103     accounts[_from].allowed[msg.sender] = _allowed.sub(_value);
104     Transfer(_from, _to, _value);
105     return true;
106   }
107 
108   function performTransfer(address _from, address _to, uint256 _value, bytes _data) private returns (bool) {
109     require(_to != 0x0);
110     accounts[_from].balance = accounts[_from].balance.sub(_value);    
111     accounts[_to].balance = accounts[_to].balance.add(_value);
112     if (isContract(_to)) {
113       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
114       receiver.tokenFallback(_from, _value, _data);
115     }    
116     return true;
117   }
118 
119   function isContract(address _to) private constant returns (bool) {
120     uint256 codeLength;
121     assembly {
122       codeLength := extcodesize(_to)
123     }
124     return codeLength > 0;
125   }
126 
127   // Approval & Allowance
128   
129   function approve(address _spender, uint256 _value) returns (bool) {
130     require(msg.sender != _spender);
131     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     if ((_value != 0) && (accounts[msg.sender].allowed[_spender] != 0)) {
133       revert();
134       return false;
135     }
136     accounts[msg.sender].allowed[_spender] = _value;
137     accounts[msg.sender].isAllowanceAuthorized[_spender] = true;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
143     return accounts[_owner].allowed[_spender];
144   }
145 
146   function hasApproval(address _owner, address _spender) constant returns (bool) {        
147     return accounts[_owner].isAllowanceAuthorized[_spender];
148   }
149 
150   function removeApproval(address _spender) {    
151     delete(accounts[msg.sender].allowed[_spender]);
152     accounts[msg.sender].isAllowanceAuthorized[_spender] = false;
153   }
154 
155 }