1 /**
2  EMC United Co. Inc.
3 */
4 
5 pragma solidity 0.4.11;
6 
7 contract SafeMath {
8 
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14   function safeSub(uint a, uint b) internal returns (uint) {
15     assert(b <= a);
16     return a - b;
17   }
18   function safeAdd(uint a, uint b) internal returns (uint) {
19     uint c = a + b;
20     assert(c>=a && c>=b);
21     return c;
22   }
23 
24   // mitigate short address attack
25   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
26   // TODO: doublecheck implication of >= compared to ==
27   modifier onlyPayloadSize(uint numWords) {
28      assert(msg.data.length >= numWords * 32 + 4);
29      _;
30   }
31 
32 }
33 
34 
35 contract Token { // ERC20 standard
36 
37     function balanceOf(address _owner) constant returns (uint256 balance);
38     function transfer(address _to, uint256 _value) returns (bool success);
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
40     function approve(address _spender, uint256 _value) returns (bool success);
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45 }
46 
47 
48 contract StandardToken is Token, SafeMath {
49 
50     uint256 public totalSupply;
51 
52     // TODO: update tests to expect throw
53     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {
54         require(_to != address(0));
55         require(balances[msg.sender] >= _value && _value > 0);
56         balances[msg.sender] = safeSub(balances[msg.sender], _value);
57         balances[_to] = safeAdd(balances[_to], _value);
58         Transfer(msg.sender, _to, _value);
59 
60         return true;
61     }
62 
63     // TODO: update tests to expect throw
64     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
65         require(_to != address(0));
66         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
67         balances[_from] = safeSub(balances[_from], _value);
68         balances[_to] = safeAdd(balances[_to], _value);
69         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
70         Transfer(_from, _to, _value);
71 
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     // To change the approve amount you first have to reduce the addresses'
80     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
81     //  already 0 to mitigate the race condition described here:
82     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
84         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87 
88         return true;
89     }
90 
91     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success) {
92         require(allowed[msg.sender][_spender] == _oldValue);
93         allowed[msg.sender][_spender] = _newValue;
94         Approval(msg.sender, _spender, _newValue);
95 
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105 
106 }
107 
108 
109 /*------------------------------------
110 Eight Made Coin
111  SYMBOL : EMC
112  decimal : 8 
113  issue amount :  9,500,000,000 
114 --------------------------------------*/
115 
116 contract EMC  is StandardToken { 
117 
118     /* Public variables of the token */
119 
120     /*
121     NOTE:
122     The following variables are choice vanities. One does not have to include them.
123     They allow one to customise the token contract & in no way influences the core functionality.
124     Some wallets/interfaces might not even bother to look at this information.
125     */
126     string public name;                   // Token Name  token issued 
127     uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
128     string public symbol;                 // An identifier: eg SBX, XPR etc..
129     string public version = 'C1.0'; 
130     uint256 public unitsOneEthCanBuy;     // How many units of your coin can be bought by 1 ETH?
131     uint256 public totalEthInWei;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
132     address public fundsWallet;           // Where should the raised ETH go?
133 
134     // This is a constructor function 
135     // which means the following function name has to match the contract name declared above
136 
137     function EMC() {                        //** funtion name **/
138         balances[msg.sender] = 950000000000000000;          //** Give the creator all initial tokens. This is set to 1000 for example. If you want your initial tokens to be X and your decimal is 5, set this value to X * 100000. (coinchel )
139         totalSupply = 950000000000000000;               //** Update total supply (1000 for example) 
140         name = "Eight Made Coin";                       //** Set the name for display purposes 
141         decimals = 8 ;                                  // Amount of decimals for display purposes
142         symbol = "EMC";                                // Set the symbol for display purposes 
143         unitsOneEthCanBuy = 10;                         // Set the price of your token for the ICO 
144         fundsWallet = msg.sender;                       // The owner of the contract gets ETH
145     }
146 
147 
148     function() payable{
149         totalEthInWei = totalEthInWei + msg.value;
150         uint256 amount = msg.value * unitsOneEthCanBuy;
151         require(balances[fundsWallet] >= amount);
152 
153         balances[fundsWallet] = balances[fundsWallet] - amount;
154         balances[msg.sender] = balances[msg.sender] + amount;
155 
156         Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
157 
158         //Transfer ether to fundsWallet
159         fundsWallet.transfer(msg.value);                               
160     }
161 
162     /* Approves and then calls the receiving contract */
163     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166 
167         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
168         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
169         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
170         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
171         return true;
172     }
173 }