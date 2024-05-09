1 pragma solidity ^0.4.11;
2 
3 contract IERC20 {
4       function totalSupply() constant returns (uint256 totalSupply);
5       function balanceOf(address _owner) constant returns (uint balance);
6       function transfer(address _to, uint _value) returns (bool success);
7       function transferFrom(address _from, address _to, uint _value) returns (bool success);
8       function approve(address _spender, uint _value) returns (bool success);
9       function allowance(address _owner, address _spender) constant returns (uint remaining);
10      event Transfer(address indexed _from, address indexed _to, uint256 _value);
11      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12  }
13 pragma solidity ^0.4.11;
14 
15 
16 /**
17  * Math operations with safety checks
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
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
60 }
61 
62 contract E93Token is IERC20 {
63     
64         modifier onlyOwner {
65         
66         // ETH93 admin accounts
67         
68         require(msg.sender == 0x3a31AC87092909AF0e01B4d8fC6E03157E91F4bb || msg.sender == 0x44fc32c2a5d18700284cc9e0e2da3ad83e9a6c5d);
69             _;
70         }
71     
72        using SafeMath for uint256;
73        
74        uint public totalSupply; // This is how many tokens are owned by users.
75        
76        uint public maxSupply; // Total number of tokens that can be sold.
77        
78        bool public optionsSet; // Allow the ETH93 admin to set how many ETH93 tokens can be sold and the cost per token only when the crowdsale is opened (this can't be changed after that of course).
79        
80        address public owner = 0x44fc32c2a5d18700284cc9e0e2da3ad83e9a6c5d;
81        string public symbol = "E93";
82        string public name = "ETH93";
83        uint8 public decimals = 18;
84        uint256 public RATE;
85        
86        bool public open;
87        
88        address public e93Contract;
89        
90        mapping(address => uint256) balances;
91        mapping(address => mapping(address => uint256)) allowed;
92        
93        function start (uint _maxSupply, uint _RATE) onlyOwner {
94            // Once this is called the contract can accept Ether for ETH93 tokens. The maxSupply and RATE can only be set the first time this function is called.
95            if (optionsSet == false) {
96                maxSupply = _maxSupply;
97                RATE = _RATE;
98                optionsSet = true;
99            }
100            open = true;
101        }
102        
103        function close() onlyOwner {
104            // Just in case the crowdsale needs to be closed for some reason.
105            open = false;
106        }
107        
108        function setE93ContractAddress(address _e93Contract) onlyOwner {
109            // Once the E93 contract is deployed, set its address here.
110            e93Contract = _e93Contract;
111        }
112        
113        function() payable {
114            
115         // if the msg.sender is the e93contract, funds are being sent here at the end of a lottery - fine. Otherwise give tokens to the sender.
116         if (msg.sender != e93Contract) {
117             createTokens();
118             }
119        }
120        
121        function contractBalance() public constant returns (uint256) {
122            return this.balance;
123        }
124        
125        function withdraw() {
126            // this works out what percent of the maxSupply of tokens belong to the user, and gives that percent of the contract balance to them. Eg. if the user owns 25,000 ETH93 tokens and the maxSupply was set at 75,000, and the contract has 15 Ether in it, then they would get sent 5 Ether for their tokens.
127            uint256 usersPortion = (balances[msg.sender].mul(this.balance)).div(maxSupply);
128            totalSupply = totalSupply.sub(balances[msg.sender]);
129            balances[msg.sender] = 0;
130            msg.sender.transfer(usersPortion);
131        }
132        
133        function checkPayout() constant returns (uint usersPortion) {
134            // See how much Ether the users tokens can be exchanged for.
135            usersPortion = (balances[msg.sender].mul(this.balance)).div(maxSupply);
136            return usersPortion;
137        }
138        
139        function topup() payable {
140            // Topup contract balance without buying tokens.
141        }
142        
143        function createTokens() payable {
144            require(msg.value > 0);
145            if (open != true) revert();
146            uint256 tokens = msg.value.mul(RATE);
147            if (totalSupply.add(tokens) > maxSupply) {
148                // If user wants to buy an amount of tokens that would put the supply above maxSupply, give them the max amount of tokens allowed and refund them anything over that.
149                uint256 amountOver = totalSupply.add(tokens).sub(maxSupply);
150                balances[msg.sender] = balances[msg.sender].add(maxSupply-totalSupply);
151                totalSupply = maxSupply;
152                msg.sender.transfer(amountOver.div(RATE));
153                owner.transfer(msg.value.sub(amountOver.div(RATE)));
154            } else {
155                totalSupply = totalSupply.add(tokens);
156                balances[msg.sender] = balances[msg.sender].add(tokens);
157                owner.transfer(msg.value); // Rather than storing raised Ether in this contract, it's sent straight to to the ETH93 account owner. This is because the only balance in this contract should be from the 1% cut of ETH93 lottery ticket sales in Ether, which ETH93 token holders can claim.
158            }
159        }
160        
161        function totalSupply() constant returns (uint256) {
162            return totalSupply;
163        }
164        
165        function balanceOf (address _owner) constant returns (uint256) {
166            return balances[_owner];
167        }
168        
169        function transfer(address _to, uint256 _value) returns (bool) {
170            require(balances[msg.sender] >= _value && _value > 0);
171            balances[msg.sender] = balances[msg.sender].sub(_value);
172            balances[_to] = balances[_to].add(_value);
173            Transfer(msg.sender, _to, _value);
174            return true;
175        }
176        
177        function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
178            require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
179            balances[_from] = balances[_from].sub(_value);
180            balances[_to] = balances[_to].add(_value);
181            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182            Transfer(_from, _to, _value);
183            return true;
184        }
185        
186        function approve (address _spender, uint256 _value) returns (bool) {
187            allowed[msg.sender][_spender] = _value;
188            Approval(msg.sender, _spender, _value);
189            return true;
190        }
191        
192        function allowance(address _owner, address _spender) constant returns (uint256) {
193            return allowed[_owner][_spender];
194        }
195        
196        event Transfer(address indexed _from, address indexed _to, uint256 _value);
197        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
198 
199 }