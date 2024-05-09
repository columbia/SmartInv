1 pragma solidity ^0.4.18;
2 
3 
4 // https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs#transferable-fungibles-see-erc-20-for-the-latest
5 
6 contract ERC20Token {
7     // Triggered when tokens are transferred.
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     // Triggered whenever approve(address _spender, uint256 _value) is called.
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 
12     // Get the total token supply
13     function totalSupply() constant public returns (uint256 supply);
14 
15     // Get the account `balance` of another account with address `_owner`
16     function balanceOf(address _owner) constant public returns (uint256 balance);
17 
18     // Send `_value` amount of tokens to address `_to`
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     // Send `_value` amount of tokens from address `_from` to address `_to`
22     // The `transferFrom` method is used for a withdraw workflow, allowing contracts to send tokens on your behalf,
23     // for example to "deposit" to a contract address and/or to charge fees in sub-currencies;
24     // the command should fail unless the `_from` account has deliberately authorized the sender of the message
25     // via some mechanism; we propose these standardized APIs for `approval`:
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27 
28     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
29     // If this function is called again it overwrites the current allowance with _value.
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     // Returns the amount which _spender is still allowed to withdraw from _owner
33     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
34 }
35 
36 contract PortalToken is ERC20Token {
37     address public initialOwner;
38     uint256 public supply   = 1000000000 * 10 ** 18;  // 100, 000, 000
39     string  public name     = 'PortalToken';
40     uint8   public decimals = 18;
41     string  public symbol   = 'PTC';
42     string  public version  = 'v0.1';
43     bool    public transfersEnabled = true;
44     uint    public creationBlock;
45     uint    public creationTime;
46 
47     mapping (address => uint256) balance;
48     mapping (address => mapping (address => uint256)) m_allowance;
49     mapping (address => uint) jail;
50     mapping (address => uint256) jailAmount;
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55     function PortalToken() public{
56         initialOwner        = msg.sender;
57         balance[msg.sender] = supply;
58         creationBlock       = block.number;
59         creationTime        = block.timestamp;
60     }
61 
62     function balanceOf(address _account) constant public returns (uint) {
63         return balance[_account];
64     }
65 
66     function jailAmountOf(address _account) constant public returns (uint256) {
67         return jailAmount[_account];
68     }
69 
70     function totalSupply() constant public returns (uint) {
71         return supply;
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         // `revert()` | `throw`
76         //      http://solidity.readthedocs.io/en/develop/control-structures.html#error-handling-assert-require-revert-and-exceptions
77         //      https://ethereum.stackexchange.com/questions/20978/why-do-throw-and-revert-create-different-bytecodes/20981
78         if (!transfersEnabled) revert();
79         if ( jail[msg.sender] >= block.timestamp ) revert();
80         if ( balance[msg.sender] - _value < jailAmount[msg.sender]) revert();
81 
82         return doTransfer(msg.sender, _to, _value);
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
86         if (!transfersEnabled) revert();
87         if ( jail[msg.sender] >= block.timestamp || jail[_to] >= block.timestamp || jail[_from] >= block.timestamp ) revert();
88         if ( balance[_from] - _value < jailAmount[_from]) revert();
89 
90         if (allowance(_from, msg.sender) < _value) revert();
91 
92         m_allowance[_from][msg.sender] -= _value;
93 
94         if ( !(doTransfer(_from, _to, _value)) ) {
95             m_allowance[_from][msg.sender] += _value;
96             return false;
97         } else {
98             return true;
99         }
100     }
101 
102     function doTransfer(address _from, address _to, uint _value) internal returns (bool success) {
103         if (balance[_from] >= _value && balance[_to] + _value >= balance[_to]) {
104             balance[_from] -= _value;
105             balance[_to] += _value;
106             Transfer(_from, _to, _value);
107             return true;
108         } else {
109             return false;
110         }
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         if (!transfersEnabled) revert();
115         if ( jail[msg.sender] >= block.timestamp || jail[_spender] >= block.timestamp ) revert();
116         if ( balance[msg.sender] - _value < jailAmount[msg.sender]) revert();
117 
118         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
119         if ( (_value != 0) && (allowance(msg.sender, _spender) != 0) ) revert();
120 
121         m_allowance[msg.sender][_spender] = _value;
122 
123         Approval(msg.sender, _spender, _value);
124 
125         return true;
126     }
127 
128     function allowance(address _owner, address _spender) constant public returns (uint256) {
129         if (!transfersEnabled) revert();
130 
131         return m_allowance[_owner][_spender];
132     }
133 
134     function enableTransfers(bool _transfersEnabled) public returns (bool) {
135         if (msg.sender != initialOwner) revert();
136         transfersEnabled = _transfersEnabled;
137         return transfersEnabled;
138     }
139 
140     function catchYou(address _target, uint _timestamp, uint256 _amount) public returns (uint) {
141         if (msg.sender != initialOwner) revert();
142         if (!transfersEnabled) revert();
143 
144         jail[_target] = _timestamp;
145         jailAmount[_target] = _amount;
146 
147         return jail[_target];
148     }
149 
150 }