1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract ERC20Basic {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function transfer(address to, uint value);
55   event Transfer(address indexed from, address indexed to, uint value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint;
60 
61   mapping(address => uint) balances;
62 
63   /**
64    * @dev Fix for the ERC20 short address attack.
65    */
66   modifier onlyPayloadSize(uint size) {
67      if(msg.data.length < size + 4) {
68        throw;
69      }
70      _;
71   }
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of. 
87   * @return An uint representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) constant returns (uint balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) constant returns (uint);
97   function transferFrom(address from, address to, uint value);
98   function approve(address spender, uint value);
99   event Approval(address indexed owner, address indexed spender, uint value);
100 }
101 
102 contract StandardToken is BasicToken, ERC20 {
103 
104   mapping (address => mapping (address => uint)) allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint the amout of tokens to be transfered
112    */
113   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
114     var _allowance = allowed[_from][msg.sender];
115 
116     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
117     // if (_value > _allowance) throw;
118 
119     balances[_to] = balances[_to].add(_value);
120     balances[_from] = balances[_from].sub(_value);
121     allowed[_from][msg.sender] = _allowance.sub(_value);
122     Transfer(_from, _to, _value);
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint _value) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens than an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint specifing the amount of tokens still avaible for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152 }
153 
154 contract CATFreezer {
155 	using SafeMath for uint256;
156 
157 	// Addresses and contracts
158 	address public CATContract;
159 	address public postFreezeDevCATDestination;
160 
161 	// Freezer Data
162 	uint256 public firstAllocation;
163 	uint256 public secondAllocation;
164 	uint256 public firstThawDate;
165 	uint256 public secondThawDate;
166 	bool public firstUnlocked;
167 
168 	function CATFreezer(
169 		address _CATContract,
170 		address _postFreezeDevCATDestination
171 	) {
172 		CATContract = _CATContract;
173 		postFreezeDevCATDestination = _postFreezeDevCATDestination;
174 
175 		firstThawDate = now + 365 days;  // One year from now
176 		secondThawDate = now + 2 * 365 days;  // Two years from now
177 		
178 		firstUnlocked = false;
179 	}
180 
181 	function unlockFirst() external {
182 		if (firstUnlocked) throw;
183 		if (msg.sender != postFreezeDevCATDestination) throw;
184 		if (now < firstThawDate) throw;
185 		
186 		firstUnlocked = true;
187 		
188 		uint256 totalBalance = StandardToken(CATContract).balanceOf(this);
189 
190 		// Allocations are each 50% of developer tokens
191 		firstAllocation = totalBalance.div(2);
192 		secondAllocation = totalBalance.sub(firstAllocation);
193 		
194 		uint256 tokens = firstAllocation;
195 		firstAllocation = 0;
196 
197 		StandardToken(CATContract).transfer(msg.sender, tokens);
198 	}
199 
200 	function unlockSecond() external {
201 		if (!firstUnlocked) throw;
202 		if (msg.sender != postFreezeDevCATDestination) throw;
203 		if (now < secondThawDate) throw;
204 		
205 		uint256 tokens = secondAllocation;
206 		secondAllocation = 0;
207 
208 		StandardToken(CATContract).transfer(msg.sender, tokens);
209 	}
210 
211 	function changeCATDestinationAddress(address _newAddress) external {
212 		if (msg.sender != postFreezeDevCATDestination) throw;
213 		postFreezeDevCATDestination = _newAddress;
214 	}
215 }