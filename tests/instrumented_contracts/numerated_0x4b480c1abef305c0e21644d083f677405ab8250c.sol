1 pragma solidity ^0.4.17;
2 
3 // StandardToken code from LINK token contract.
4 
5 /**
6  * ERC20Basic
7  * Simpler version of ERC20 interface
8  * see https://github.com/ethereum/EIPs/issues/20
9  */
10 contract ERC20Basic {
11     uint public totalSupply;
12 
13     function balanceOf(address who) constant returns(uint);
14 
15     function transfer(address to, uint value);
16     event Transfer(address indexed from, address indexed to, uint value);
17 }
18 
19 /**
20  * Math operations with safety checks
21  */
22 library SafeMath {
23     function mul(uint a, uint b) internal returns(uint) {
24         uint c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function div(uint a, uint b) internal returns(uint) {
30         assert(b > 0);
31         uint c = a / b;
32         assert(a == b * c + a % b);
33         return c;
34     }
35 
36     function sub(uint a, uint b) internal returns(uint) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint a, uint b) internal returns(uint) {
42         uint c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47     function max64(uint64 a, uint64 b) internal constant returns(uint64) {
48         return a >= b ? a : b;
49     }
50 
51     function min64(uint64 a, uint64 b) internal constant returns(uint64) {
52         return a < b ? a : b;
53     }
54 
55     function max256(uint256 a, uint256 b) internal constant returns(uint256) {
56         return a >= b ? a : b;
57     }
58 
59     function min256(uint256 a, uint256 b) internal constant returns(uint256) {
60         return a < b ? a : b;
61     }
62 
63     function assert(bool assertion) internal {
64         if (!assertion) {
65             throw;
66         }
67     }
68 }
69 
70 
71 /**
72  * Basic token
73  * Basic version of StandardToken, with no allowances
74  */
75 contract BasicToken is ERC20Basic {
76     using SafeMath
77     for uint;
78 
79     mapping(address => uint) balances;
80 
81     /**
82      * Fix for the ERC20 short address attack  
83      */
84     modifier onlyPayloadSize(uint size) {
85         if (msg.data.length < size + 4) {
86             throw;
87         }
88         _;
89     }
90 
91     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95     }
96 
97     function balanceOf(address _owner) constant returns(uint balance) {
98         return balances[_owner];
99     }
100 
101 }
102 
103 
104 /**
105  * ERC20 interface
106  * see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109     function allowance(address owner, address spender) constant returns(uint);
110 
111     function transferFrom(address from, address to, uint value);
112 
113     function approve(address spender, uint value);
114     event Approval(address indexed owner, address indexed spender, uint value);
115 }
116 
117 
118 /**
119  * Standard ERC20 token
120  *
121  * https://github.com/ethereum/EIPs/issues/20
122  * Based on code by FirstBlood:
123  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  */
125 contract StandardToken is BasicToken, ERC20 {
126 
127     mapping(address => mapping(address => uint)) allowed;
128 
129     function transferFrom(address _from, address _to, uint _value) {
130         var _allowance = allowed[_from][msg.sender];
131 
132         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
133         // if (_value > _allowance) throw;
134 
135         balances[_to] = balances[_to].add(_value);
136         balances[_from] = balances[_from].sub(_value);
137         allowed[_from][msg.sender] = _allowance.sub(_value);
138         Transfer(_from, _to, _value);
139     }
140 
141     function approve(address _spender, uint _value) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144     }
145 
146     function allowance(address _owner, address _spender) constant returns(uint remaining) {
147         return allowed[_owner][_spender];
148     }
149 }
150 
151 contract TIP is StandardToken {
152     string public constant symbol = "TIP";
153     string public constant name = "EthereumTipToken";
154     uint8 public constant decimals = 8;
155 
156     uint256 public reservedSupply = 10000000 * 10 ** 8;
157     uint256 public transferAmount = 10000 * 10 ** 8;
158 
159     address public owner;
160 
161     mapping(address => uint256) address_claimed_tokens;
162 
163     function TIP() {
164         owner = msg.sender;
165         totalSupply = 100000000 * 10 ** 8; //100M
166         balances[owner] = 100000000 * 10 ** 8;
167     }
168 
169     modifier onlyOwner() {
170         require(msg.sender == owner);
171         _;
172     }
173 
174     // Default function called when ETH is send to the contract.
175     function() payable {
176         // No ETH transfer allowed.
177         require(msg.value == 0);
178 
179         require(balances[owner] >= reservedSupply);
180 
181         require(address_claimed_tokens[msg.sender] == 0); // return if already claimed
182 
183         balances[owner] -= transferAmount;
184         balances[msg.sender] += transferAmount;
185         address_claimed_tokens[msg.sender] += transferAmount;
186         Transfer(owner, msg.sender, transferAmount);
187     }
188 
189     function distribute(address[] addresses) onlyOwner {
190         for (uint i = 0; i < addresses.length; i++) {
191             if (address_claimed_tokens[addresses[i]] == 0) {
192                 balances[owner] -= transferAmount;
193                 balances[addresses[i]] += transferAmount;
194                 address_claimed_tokens[addresses[i]] += transferAmount;
195                 Transfer(owner, addresses[i], transferAmount);
196             }
197         }
198     }
199 
200 }