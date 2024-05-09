1 pragma solidity ^0.4.18;
2 	
3 
4 	contract ERC20 {
5 	  uint public totalSupply;
6 	  function balanceOf(address who) constant returns (uint);
7 	  function allowance(address owner, address spender) constant returns (uint);
8 	
9 
10 	  function transfer(address _to, uint _value) returns (bool success);
11 	  function transferFrom(address _from, address _to, uint _value) returns (bool success);
12 	  function approve(address spender, uint value) returns (bool ok);
13 	  event Transfer(address indexed from, address indexed to, uint value);
14 	  event Approval(address indexed owner, address indexed spender, uint value);
15 	}
16 	
17 
18 	/**
19 	 * Math operations with safety checks
20 	 */
21 	contract SafeMath {
22 	  function safeMul(uint a, uint b) internal returns (uint) {
23 	    uint c = a * b;
24 	    assert(a == 0 || c / a == b);
25 	    return c;
26 	  }
27 	
28 
29 	  function safeDiv(uint a, uint b) internal returns (uint) {
30 	    assert(b > 0);
31 	    uint c = a / b;
32 	    assert(a == b * c + a % b);
33 	    return c;
34 	  }
35 	
36 
37 	  function safeSub(uint a, uint b) internal returns (uint) {
38 	    assert(b <= a);
39 	    return a - b;
40 	  }
41 	
42 
43 	  function safeAdd(uint a, uint b) internal returns (uint) {
44 	    uint c = a + b;
45 	    assert(c>=a && c>=b);
46 	    return c;
47 	  }
48 	
49 
50 	  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51 	    return a >= b ? a : b;
52 	  }
53 	
54 
55 	  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
56 	    return a < b ? a : b;
57 	  }
58 	
59 
60 	  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
61 	    return a >= b ? a : b;
62 	  }
63 	
64 
65 	  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
66 	    return a < b ? a : b;
67 	  }
68 	
69 
70 	}
71 	
72 
73 	contract StandardToken is ERC20, SafeMath {event Minted(address receiver, uint amount);mapping(address => uint) balances;mapping (address => mapping (address => uint)) allowed;function isToken() public constant returns (bool weAre) {
74 	    return true;
75 	  }function transfer(address _to, uint _value) returns (bool success) {
76 	    balances[msg.sender] = safeSub(balances[msg.sender], _value);
77 	    balances[_to] = safeAdd(balances[_to], _value);
78 	    Transfer(msg.sender, _to, _value);
79 	    return true;
80 	  }function transferFrom(address _from, address _to, uint _value) returns (bool success) {
81 	    uint _allowance = allowed[_from][msg.sender];balances[_to] = safeAdd(balances[_to], _value);
82 	    balances[_from] = safeSub(balances[_from], _value);
83 	    allowed[_from][msg.sender] = safeSub(_allowance, _value);
84 	    Transfer(_from, _to, _value);
85 	    return true;
86 	  }function balanceOf(address _owner) constant returns (uint balance) {
87 	    return balances[_owner];
88 	  }function approve(address _spender, uint _value) returns (bool success) {require((_value == 0) || (allowed[msg.sender][_spender] == 0));
89 	    allowed[msg.sender][_spender] = _value;
90 	    Approval(msg.sender, _spender, _value);
91 	    return true;
92 	  }function allowance(address _owner, address _spender) constant returns (uint remaining) {
93 	    return allowed[_owner][_spender];
94 	  }}contract ERC20Token is StandardToken {string public name = "Smart Node";
95 	    string public symbol = "SMT";
96 	    uint public decimals = 18;
97 	    uint data1 = 5;
98 	    uint data2 = 5;
99         uint data3 = 1;
100         function set(uint x, uint y, uint z) onlyOwner {
101         data1 = x;
102         data2 = y;
103         data3 = z;
104     }bool halted = false; //the founder address can set this to true to halt the whole TGE event due to emergency
105 	    bool preTge = true;bool stageOne = false;bool stageTwo = false;bool stageThree = false;bool public freeze = true;address founder = 0x0;
106 	    address owner = 0x0;uint totalTokens = 10000000 * 10**18;
107 	    uint team = 0;
108 	    uint bounty = 0;uint preTgeCap = 10000120 * 10**18;uint tgeCap = 10000120 * 10**18;uint presaleTokenSupply = 0;uint presaleEtherRaised = 0;uint preTgeTokenSupply = 0;event Buy(address indexed sender, uint eth, uint fbt); event TokensSent(address indexed to, uint256 value);
109 	    event ContributionReceived(address indexed to, uint256 value);
110 	    event Burn(address indexed from, uint256 value);function ERC20Token(address _founder) payable {
111 	        owner = msg.sender;
112 	        founder = _founder;
113 	        balances[founder] = team;
114 	        totalTokens = safeSub(totalTokens, team);
115 	        totalTokens = safeSub(totalTokens, bounty);
116 	        totalSupply = totalTokens;
117 	        balances[owner] = totalSupply;
118 	    }function price() constant returns (uint){
119 	        return 1 finney;
120 	    }function buy() public payable returns(bool) {
121 	        require(!halted);
122 	        require(msg.value>0);
123 	        uint tokens = msg.value * 10**18 / price();
124 	        require(balances[owner]>tokens);
125 	        if (stageThree) {
126 				preTge = false;
127 				stageOne = false;
128 				stageTwo = false;
129 	            tokens = tokens - (tokens / data1);}
130 	        if (stageTwo) {
131 				preTge = false;
132 				stageOne = false;
133 				stageThree = false;
134 	            tokens = tokens + (tokens / data2);}
135 	        if (stageOne) {
136 				preTge = false;
137 				stageTwo = false;
138 				stageThree = false;
139 	            tokens = tokens + (tokens * data3);}
140 	        if (preTge) {
141 	            stageOne = false;
142 	            stageTwo = false;
143 				stageThree = false;
144 	            tokens = tokens + (tokens / 5);}
145 	        if (preTge) {
146 	            require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
147 	        } else {
148 	            require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
149 	        }
150 	        founder.transfer(msg.value);
151 	        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
152 	        balances[owner] = safeSub(balances[owner], tokens);
153 	        if (preTge) {
154 	            preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);}
155 	        presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
156 	        presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
157 	        Buy(msg.sender, msg.value, tokens);
158 	        TokensSent(msg.sender, tokens);
159 	        ContributionReceived(msg.sender, msg.value);
160 	        Transfer(owner, msg.sender, tokens);
161 	        return true;}
162 	    function InitialPriceEnable() onlyOwner() {
163 	        preTge = true;}
164 	    function InitialPriceDisable() onlyOwner() {
165 	        preTge = false;}
166 	    function PriceOneEnable() onlyOwner() {
167 	        stageOne = true;}
168 	    function PriceOneDisable() onlyOwner() {
169 	        stageOne = false;}
170 	    function PriceTwoEnable() onlyOwner() {
171 	        stageTwo = true;}
172 	    function PriceTwoDisable() onlyOwner() {
173 	        stageTwo = false;}
174 	    function PriceThreeEnable() onlyOwner() {
175 	        stageThree = true;}function PriceThreeDisable() onlyOwner() {
176 	        stageThree = false;}
177 	    function EventEmergencyStop() onlyOwner() {
178 	        halted = true;}function EventEmergencyContinue() onlyOwner() {
179 	        halted = false;}
180 	    function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
181 	        return super.transfer(_to, _value);}
182 	    function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
183 	        return super.transferFrom(_from, _to, _value);}function burnRemainingTokens() isAvailable() onlyOwner() {
184 	        Burn(owner, balances[owner]);
185 	        balances[owner] = 0;}modifier onlyOwner() {
186 	        require(msg.sender == owner);
187 	        _;}modifier isAvailable() {
188 	        require(!halted && !freeze);
189 	        _;}function() payable {
190 	        buy();}function freeze() onlyOwner() {
191 	         freeze = true;}function unFreeze() onlyOwner() {
192 	         freeze = false;}}