1 pragma solidity ^0.4.18;
2 contract Hurify {
3 /* Public variables of the token */
4 string public name = "Hurify Token";                  // Token Name
5 string public symbol = "HUR";                         // Token symbol
6 uint public decimals = 18;                            // Token Decimal Point
7 address public owner;                                 // Owner of the Token Contract
8 uint256 totalHurify;                                  // Total Token for the Crowdsale
9 uint256 totalToken;                                   // The current total token supply.
10 bool public hault = false;                            // Crowdsale State
11  /* This creates an array with all balances */
12 mapping (address => uint256) balances;
13 mapping (address => mapping (address => uint256)) allowed;
14 /* This generates a public event on the blockchain that will notify clients */
15 event Transfer(address indexed from, address indexed to, uint256 value);
16 /* This notifies clients about the refund amount */
17  event Burn(address _from, uint256 _value);
18  event Approval(address _from, address _to, uint256 _value);
19 /* Initializes contract with initial supply tokens to the creator of the contract */
20 function Hurify (
21   address _hurclan
22   ) public {
23    owner = msg.sender;                                            // Assigning owner address.
24    balances[msg.sender] = 212500000 * (10 ** decimals);            // Assigning Total Token balance to owner
25    totalHurify = 273125000 * (10 ** decimals);
26    balances[_hurclan] = safeAdd(balances[_hurclan], 53125000 * (10 ** decimals));
27 }
28 function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 modifier onlyPayloadSize(uint size) {
39    require(msg.data.length >= size + 4) ;
40    _;
41 }
42 modifier onlyowner {
43   require (owner == msg.sender);
44   _;
45 }
46 ///@notice Alter the Total Supply.
47 function tokensup(uint256 _value) onlyowner public{
48   totalHurify = safeAdd(totalHurify, _value * (10 ** decimals));
49   balances[owner] = safeAdd(balances[owner], _value * (10 ** decimals));
50 }
51 ///@notice Transfer tokens based on type
52 function hurifymint( address _client, uint _value, uint _type) onlyowner public {
53   uint numHur;
54   require(totalToken <= totalHurify);
55   if(_type == 1){
56       numHur = _value * 6000 * (10 ** decimals);
57   }
58   else if (_type == 2){
59       numHur = _value * 5000 * (10 ** decimals);
60   }
61   balances[owner] = safeSub(balances[owner], numHur);
62   balances[_client] = safeAdd(balances[_client], numHur);
63   totalToken = safeAdd(totalToken, numHur);
64   Transfer(owner, _client, numHur);
65 }
66 ///@notice Transfer token with only value
67 function hurmint( address _client, uint256 _value) onlyowner public {
68   require(totalToken <= totalHurify);
69   uint256 numHur = _value * ( 10 ** decimals);
70   balances[owner] = safeSub(balances[owner], numHur);
71   balances[_client] = safeAdd(balances[_client], numHur);
72   totalToken = safeAdd(totalToken, numHur);
73   Transfer(owner, _client, numHur);
74 }
75 //Default assumes totalSupply can't be over max (2^256 - 1).
76 //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check requireit doesn't wrap.
77 //Replace the if with this one instead.
78 function transfer(address _to, uint256 _value) public returns (bool success) {
79     require(!hault);
80     require(balances[msg.sender] >= _value);
81     balances[msg.sender] = safeSub(balances[msg.sender],_value);
82     balances[_to] = safeAdd(balances[_to], _value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85 }
86 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87       if (balances[_from] < _value || allowed[_from][msg.sender] < _value) {
88           // Balance or allowance too low
89           revert();
90       }
91       require(!hault);
92       balances[_to] = safeAdd(balances[_to], _value);
93       balances[_from] = safeSub(balances[_from],_value);
94       allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value);
95       Transfer(_from, _to, _value);
96       return true;
97 }
98 /// @dev Sets approved amount of tokens for spender. Returns success.
99 /// @param _spender Address of allowed account.
100 /// @param _value Number of approved tokens.
101 /// @return Returns success of function call.
102 function approve(address _spender, uint256 _value)
103     public
104     returns (bool)
105 {
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109 }
110 /// @dev Returns number of allowed tokens for given address.
111 /// @param _owner Address of token owner.
112 /// @param _spender Address of token spender.
113 /// @return Returns remaining allowance for spender.
114 function allowance(address _owner, address _spender)
115     constant
116     public
117     returns (uint256)
118 {
119     return allowed[_owner][_spender];
120 }
121 /// @notice Returns balance of HUR Tokens.
122 /// @param _from Balance for Address.
123 function balanceOf(address _from) public view returns (uint balance) {
124     return balances[_from];
125   }
126 
127 ///@notice Returns the Total Number of HUR Tokens.
128 function totalSupply() public view returns (uint Supply){
129   return totalHurify;
130 }
131 /// @notice Pause the crowdsale
132 function pauseable() public onlyowner {
133     hault = true;
134   }
135 /// @notice Unpause the crowdsale
136 function unpause() public onlyowner {
137     hault = false;
138 }
139 
140 /// @notice Remove `_value` tokens from the system irreversibly
141 function burn(uint256 _value) onlyowner public returns (bool success) {
142     require (balances[msg.sender] >= _value);                                          // Check if the sender has enough
143     balances[msg.sender] = safeSub(balances[msg.sender], _value);                      // Subtract from the sender
144     totalHurify = safeSub(totalHurify, _value);                                        // Updates totalSupply
145     Burn(msg.sender, _value);
146     return true;
147 }
148 }