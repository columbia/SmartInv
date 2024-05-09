1 pragma solidity ^0.4.8;
2 
3 /// @title Link Token. This Token will remain the cornerstone of the entire organization. It will have an Ethereum address and from the moment that address is publish until the end, it will remain the same, and should. The Token should be as simple as it possibly can be and should not be able to terminate. It's state remains so that those who control their Tokens will continue to do so.
4 /// @author Riaan F Venter~ RFVenter~ <msg@rfv.io>
5 
6 
7 /*
8  * ERC20Basic
9  * Simpler version of ERC20 interface
10  * see https://github.com/ethereum/EIPs/issues/20
11  */
12 contract ERC20Basic {
13   uint public totalSupply;
14   function balanceOf(address who) constant returns (uint);
15   function transfer(address to, uint value);
16   event Transfer(address indexed from, address indexed to, uint value);
17 }
18 
19 /**
20  * Math operations with safety checks
21  */
22 library SafeMath {
23   function mul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint a, uint b) internal returns (uint) {
30     assert(b > 0);
31     uint c = a / b;
32     assert(a == b * c + a % b);
33     return c;
34   }
35 
36   function sub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 
70 
71 /*
72  * Basic token
73  * Basic version of StandardToken, with no allowances
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint;
77 
78   mapping(address => uint) balances;
79 
80   /*
81    * Fix for the ERC20 short address attack  
82    */
83   modifier onlyPayloadSize(uint size) {
84      if(msg.data.length < size + 4) {
85        throw;
86      }
87      _;
88   }
89 
90   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   function balanceOf(address _owner) constant returns (uint balance) {
97     return balances[_owner];
98   }
99   
100 }
101 
102 
103 /*
104  * ERC20 interface
105  * see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) constant returns (uint);
109   function transferFrom(address from, address to, uint value);
110   function approve(address spender, uint value);
111   event Approval(address indexed owner, address indexed spender, uint value);
112 }
113 
114 
115 /**
116  * Standard ERC20 token
117  *
118  * https://github.com/ethereum/EIPs/issues/20
119  * Based on code by FirstBlood:
120  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is BasicToken, ERC20 {
123 
124   mapping (address => mapping (address => uint)) allowed;
125 
126   function transferFrom(address _from, address _to, uint _value) {
127     var _allowance = allowed[_from][msg.sender];
128 
129     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
130     // if (_value > _allowance) throw;
131 
132     balances[_to] = balances[_to].add(_value);
133     balances[_from] = balances[_from].sub(_value);
134     allowed[_from][msg.sender] = _allowance.sub(_value);
135     Transfer(_from, _to, _value);
136   }
137 
138   function approve(address _spender, uint _value) {
139     allowed[msg.sender][_spender] = _value;
140     Approval(msg.sender, _spender, _value);
141   }
142 
143   function allowance(address _owner, address _spender) constant returns (uint remaining) {
144     return allowed[_owner][_spender];
145   }
146 }
147 
148 /*
149  * Ownable
150  *
151  * Base contract with an owner.
152  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
153  */
154 contract Ownable {
155   address public owner;
156 
157   function Ownable() {
158     owner = msg.sender;
159   }
160 
161   modifier onlyOwner() {
162     if (msg.sender != owner) {
163       throw;
164     }
165     _;
166   }
167 
168   function transferOwnership(address newOwner) onlyOwner {
169     if (newOwner != address(0)) {
170       owner = newOwner;
171     }
172   }
173 
174 }
175 
176 
177 contract LinkToken is StandardToken, Ownable {
178 
179     string public   name =           "Link Platform";    // Name of the Token
180     string public   symbol =         "LNK";              // ERC20 compliant Token code
181     uint public     decimals =       18;                 // Token has 18 digit precision
182     uint public     totalSupply;    			         // Total supply
183 
184     function mint(address _spender, uint _value)
185         onlyOwner {
186 
187         balances[_spender] += _value;
188         totalSupply += _value;
189     }
190 }