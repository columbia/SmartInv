1 pragma solidity ^0.4.13;
2 
3 contract Receiver {
4   function tokenFallback(address from, uint value, bytes data);
5 }
6 
7 contract ERC20 {
8   uint public totalSupply;
9   function balanceOf(address who) public constant returns (uint);
10   function allowance(address owner, address spender) public constant returns (uint);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transferFrom(address from, address to, uint value) public returns (bool ok);
14   function approve(address spender, uint value) public returns (bool ok);
15   event Transfer(address indexed from, address indexed to, uint value);
16   event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 contract SafeMath {
20   function safeMul(uint a, uint b) internal returns (uint) {
21     uint c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function safeDiv(uint a, uint b) internal returns (uint) {
27     assert(b > 0);
28     uint c = a / b;
29     assert(a == b * c + a % b);
30     return c;
31   }
32 
33   function safeSub(uint a, uint b) internal returns (uint) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint a, uint b) internal returns (uint) {
39     uint c = a + b;
40     assert(c>=a && c>=b);
41     return c;
42   }
43 
44   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a >= b ? a : b;
46   }
47 
48   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a < b ? a : b;
50   }
51 
52   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a >= b ? a : b;
54   }
55 
56   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a < b ? a : b;
58   }
59 
60   function assert(bool assertion) internal {
61     if (!assertion) {
62       revert();
63     }
64   }
65 }
66 
67 contract StandardToken is ERC20, SafeMath {
68   event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);
69 
70   event Minted(address receiver, uint amount);
71 
72   mapping(address => uint) balances;
73 
74   mapping (address => mapping (address => uint)) allowed;
75 
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length != size + 4) {
78        revert();
79      }
80      _;
81   }
82 
83   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
84       bytes memory _empty;
85 
86       return transfer(_to, _value, _empty);
87   }
88 
89   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
90     balances[msg.sender] = safeSub(balances[msg.sender], _value);
91     balances[_to] = safeAdd(balances[_to], _value);
92     Transfer(msg.sender, _to, _value, _data);
93     Transfer(msg.sender, _to, _value);
94 
95     if (isContract(_to)) {
96       Receiver(_to).tokenFallback(msg.sender, _value, _data);
97     }
98 
99     return true;
100   }
101 
102   function isContract( address _addr ) private returns (bool) {
103     uint length;
104     _addr = _addr;
105     assembly { length := extcodesize(_addr) }
106     return (length > 0);
107   }
108 
109   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
110     uint _allowance = allowed[_from][msg.sender];
111 
112     balances[_to] = safeAdd(balances[_to], _value);
113     balances[_from] = safeSub(balances[_from], _value);
114     allowed[_from][msg.sender] = safeSub(_allowance, _value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   function balanceOf(address _owner) public constant returns (uint balance) {
120     return balances[_owner];
121   }
122 
123   function approve(address _spender, uint _value) public returns (bool success) {
124 
125     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
126 
127     allowed[msg.sender][_spender] = _value;
128     Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
133     return allowed[_owner][_spender];
134   }
135 }
136 
137 
138 
139 contract BurnableToken is StandardToken {
140 
141   address public constant BURN_ADDRESS = 0;
142 
143   event Burned(address burner, uint burnedAmount);
144 
145   function burn(uint burnAmount) public {
146     address burner = msg.sender;
147     balances[burner] = safeSub(balances[burner], burnAmount);
148     totalSupply = safeSub(totalSupply, burnAmount);
149     Burned(burner, burnAmount);
150   }
151 }
152 
153 
154 contract ReferralWeToken is BurnableToken {
155 
156   string public name;
157   string public symbol;
158   uint public decimals;
159   address public owner;
160 
161   modifier onlyOwner() {
162     if(msg.sender != owner) revert();
163     _;
164   }
165 
166   function transferOwnership(address newOwner) public onlyOwner {
167     if (newOwner != address(0)) {
168       owner = newOwner;
169     }
170   }
171 
172   function ReferralWeToken(address _owner, uint _totalSupply) public {
173     name = "refwttoken";
174     symbol = "RefWT";
175     decimals = 0;
176     totalSupply = _totalSupply;
177 
178     balances[_owner] = totalSupply;
179 
180     owner = _owner;
181   }
182 }