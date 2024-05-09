1 pragma solidity ^0.4.11;
2 
3 contract ForeignToken {
4   function balanceOf(address _owner) constant returns (uint256);
5   function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 /**
9  * Math operations with safety checks
10  */
11 library SafeMath {
12   function mul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint a, uint b) internal returns (uint) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 
52   function assert(bool assertion) internal {
53     if (!assertion) {
54       throw;
55     }
56   }
57 }
58 
59 contract CardboardUnicorns {
60   using SafeMath for uint;
61   
62   string public name = "HorseWithACheapCardboardHorn";
63   string public symbol = "HWACCH";
64   uint public decimals = 0;
65   uint public totalSupply = 0;
66   mapping(address => uint) balances;
67   mapping (address => mapping (address => uint)) allowed;
68   address public owner = msg.sender;
69 
70   event Transfer(address indexed from, address indexed to, uint value);
71   event Approval(address indexed owner, address indexed spender, uint value);
72   event Minted(address indexed owner, uint value);
73 
74   /**
75    * Fix for the ERC20 short address attack.
76    */
77   modifier onlyPayloadSize(uint size) {
78     if(msg.data.length < size + 4) {
79       throw;
80     }
81     _;
82   }
83   
84   modifier onlyOwner {
85     require(msg.sender == owner);
86     _;
87   }
88   
89   /**
90    * Change ownership of the token
91    */
92   function changeOwner(address _newOwner) onlyOwner {
93     owner = _newOwner;
94   }
95 
96   function withdraw() onlyOwner {
97     owner.transfer(this.balance);
98   }
99   function withdrawForeignTokens(address _tokenContract) onlyOwner {
100     ForeignToken token = ForeignToken(_tokenContract);
101     uint256 amount = token.balanceOf(address(this));
102     token.transfer(owner, amount);
103   }
104 
105   /**
106    * Generate new tokens.
107    * Can only be done by the owner of the contract
108    */
109   function mint(address _who, uint _value) onlyOwner {
110     balances[_who] = balances[_who].add(_value);
111     totalSupply = totalSupply.add(_value);
112     Minted(_who, _value);
113   }
114 
115   /**
116    * Get the token balance of the specified address
117    */
118   function balanceOf(address _who) constant returns (uint balance) {
119     return balances[_who];
120   }
121   
122   /**
123    * Transfer token to another address
124    */
125   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
126     require(_to != address(this)); // Don't send tokens back to the contract!
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130   }
131   
132   
133   /**
134    * Transfer tokens from an different address to another address.
135    * Need to have been granted an allowance to do this before triggering.
136    */
137   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
138     var _allowance = allowed[_from][msg.sender];
139 
140     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
141     // if (_value > _allowance) throw;
142 
143     balances[_to] = balances[_to].add(_value);
144     balances[_from] = balances[_from].sub(_value);
145     allowed[_from][msg.sender] = _allowance.sub(_value);
146     Transfer(_from, _to, _value);
147   }
148   
149   /**
150    * Approve the indicated address to spend the specified amount of tokens on the sender's behalf
151    */
152   function approve(address _spender, uint _value) {
153     // Ensure allowance is zero if attempting to set to a non-zero number
154     // This helps manage an edge-case race condition better: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 
155     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
156     
157     allowed[msg.sender][_spender] = _value;
158     Approval(msg.sender, _spender, _value);
159   }
160   
161   /**
162    * Check how many tokens the indicated address can spend on behalf of the owner
163    */
164   function allowance(address _owner, address _spender) constant returns (uint remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168 }