1 pragma solidity ^0.4.18;
2 
3 /// @title Ownable contract
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 /// @title Ownable contract
31 contract Ownable {
32   
33   address public owner;
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   /// @dev Change ownership
46   /// @param newOwner Address of the new owner
47   function transferOwnership(address newOwner) onlyOwner public {
48     require(newOwner != address(0));
49     OwnershipTransferred(owner, newOwner);
50     owner = newOwner;
51   }
52 
53 }
54 
55 /// @title Pausable contract
56 contract Pausable is Ownable {
57 
58   /// Used to pause transfers
59   bool public transferPaused;
60   address public crowdsale;
61   
62   function Pausable() public {
63     transferPaused = false;
64     crowdsale = msg.sender; // or address(0)
65   }
66 
67   /// Crowdsale is the only one allowed to do transfers if transfer is paused
68   modifier onlyCrowdsaleIfPaused() {
69     if (transferPaused) {
70       require(msg.sender == crowdsale);
71     }
72     _;
73   }
74 
75   /// @dev Change crowdsale address reference
76   /// @param newCrowdsale Address of the new crowdsale
77   function changeCrowdsale(address newCrowdsale) onlyOwner public {
78     require(newCrowdsale != address(0));
79     CrowdsaleChanged(crowdsale, newCrowdsale);
80     crowdsale = newCrowdsale;
81   }
82 
83    /// @dev Pause token transfer
84   function pause() public onlyOwner {
85       transferPaused = true;
86       Pause();
87   }
88 
89   /// @dev Unpause token transfer
90   function unpause() public onlyOwner {
91       transferPaused = false;
92       Unpause();
93   }
94 
95   event Pause();
96   event Unpause();
97   event CrowdsaleChanged(address indexed previousCrowdsale, address indexed newCrowdsale);
98 
99 }
100 
101 /// @title ERC20 contract
102 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
103 contract ERC20 {
104   uint public totalSupply;
105   function balanceOf(address who) public constant returns (uint);
106   function transfer(address to, uint value) public returns (bool);
107   event Transfer(address indexed from, address indexed to, uint value);
108   
109   function allowance(address owner, address spender) public constant returns (uint);
110   function transferFrom(address from, address to, uint value) public returns (bool);
111   function approve(address spender, uint value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint value);
113 }
114 
115 /// @title ExtendedToken contract
116 contract ExtendedToken is ERC20, Pausable {
117   using SafeMath for uint;
118 
119   /// Mapping for balances
120   mapping (address => uint) public balances;
121   /// Mapping for allowance
122   mapping (address => mapping (address => uint)) internal allowed;
123 
124   /// @dev Any unsold tokens from ICO will be sent to owner address and burned
125   /// @param _amount Amount of tokens to be burned from owner address
126   /// @return True if successfully burned
127   function burn(uint _amount) public onlyOwner returns (bool) {
128 	  require(balances[msg.sender] >= _amount);     
129     balances[msg.sender] = balances[msg.sender].sub(_amount);
130     totalSupply = totalSupply.sub(_amount);
131     Burn(msg.sender, _amount);
132     return true;
133   }
134 
135   /// @dev Used by transfer function
136   function _transfer(address _from, address _to, uint _value) internal onlyCrowdsaleIfPaused {
137     require(_to != address(0));
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     Transfer(_from, _to, _value);
141   }
142   
143   /// @dev Transfer tokens
144   /// @param _to Address to receive the tokens
145   /// @param _value Amount of tokens to be sent
146   /// @return True if successful
147   function transfer(address _to, uint _value) public returns (bool) {
148     _transfer(msg.sender, _to, _value);
149     return true;
150   }
151   
152   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
153     require(_value <= allowed[_from][msg.sender]);
154     _transfer(_from, _to, _value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     return true;
157   }
158 
159   /// @dev Check balance of an address
160   /// @param _owner Address to be checked
161   /// @return Number of tokens
162   function balanceOf(address _owner) public constant returns (uint balance) {
163     return balances[_owner];
164   }
165 
166   function approve(address _spender, uint _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /// @dev Don't accept ether
194   function () public payable {
195     revert();
196   }
197 
198   /// @dev Claim tokens that have been sent to contract mistakenly
199   /// @param _token Token address that we want to claim
200   function claimTokens(address _token) public onlyOwner {
201     if (_token == address(0)) {
202          owner.transfer(this.balance);
203          return;
204     }
205 
206     ERC20 token = ERC20(_token);
207     uint balance = token.balanceOf(this);
208     token.transfer(owner, balance);
209     ClaimedTokens(_token, owner, balance);
210   }
211 
212   /// Events
213   event Burn(address _from, uint _amount);
214   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
215 
216 }
217 
218 /// @title Cultural Coin Token contract
219 contract CulturalCoinToken is ExtendedToken {
220   string public constant name = "Cultural Coin Token";
221   string public constant symbol = "CC";
222   uint8 public constant decimals = 18;
223   string public constant version = "v1";
224 
225   function CulturalCoinToken() public { 
226     totalSupply = 1500 * 10**24;    // 1500m tokens
227     balances[owner] = totalSupply;  // Tokens will be initially set to the owner account. From there 900m will be sent to Crowdsale
228   }
229 
230 }