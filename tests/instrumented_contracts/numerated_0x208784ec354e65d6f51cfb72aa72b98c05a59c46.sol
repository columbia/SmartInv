1 pragma solidity ^0.4.14;
2 
3 
4 // https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs#transferable-fungibles-see-erc-20-for-the-latest
5 
6 
7 contract ERC20Token {
8     // Triggered when tokens are transferred.
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     // Triggered whenever approve(address _spender, uint256 _value) is called.
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13     // Get the total token supply
14     function totalSupply() constant returns (uint256 supply);
15 
16     // Get the account `balance` of another account with address `_owner`
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     // Send `_value` amount of tokens to address `_to`
20     function transfer(address _to, uint256 _value) returns (bool success);
21 
22     // Send `_value` amount of tokens from address `_from` to address `_to`
23     // The `transferFrom` method is used for a withdraw workflow, allowing contracts to send tokens on your behalf, 
24     // for example to "deposit" to a contract address and/or to charge fees in sub-currencies; 
25     // the command should fail unless the `_from` account has deliberately authorized the sender of the message 
26     // via some mechanism; we propose these standardized APIs for `approval`:
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
28 
29     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
30     // If this function is called again it overwrites the current allowance with _value.
31     function approve(address _spender, uint256 _value) returns (bool success);
32 
33     // Returns the amount which _spender is still allowed to withdraw from _owner
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
35 }
36 
37 
38 contract DeepCoinToken is ERC20Token {
39     address public initialOwner;
40 
41     uint256 public supply = 100000000 * 60 * 10 ** 18;  // 6000, 000, 000
42     string  public name = "Deepfin Coin";
43 
44     uint8   public decimals = 18;
45 
46     string  public symbol = 'DFC';
47 
48     string  public version = 'v0.1';
49 
50     bool    public transfersEnabled = true;
51 
52     uint    public creationBlock;
53 
54     uint    public creationTime;
55 
56     mapping (address => uint256) balance;
57 
58     mapping (address => mapping (address => uint256)) m_allowance;
59 
60     mapping (address => uint) jail;
61 
62     event Transfer(address indexed _from, address indexed _to, uint256 _value);
63 
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66     function DeepCoinToken() {
67         initialOwner = msg.sender;
68         balance[msg.sender] = supply;
69         creationBlock = block.number;
70         creationTime = block.timestamp;
71     }
72 
73     function balanceOf(address _account) constant returns (uint) {
74         return balance[_account];
75     }
76 
77     function totalSupply() constant returns (uint) {
78         return supply;
79     }
80 
81     function transfer(address _to, uint256 _value) returns (bool success) {
82         // `revert()` | `throw`
83         //      http://solidity.readthedocs.io/en/develop/control-structures.html#error-handling-assert-require-revert-and-exceptions
84         //      https://ethereum.stackexchange.com/questions/20978/why-do-throw-and-revert-create-different-bytecodes/20981
85         if (!transfersEnabled) revert();
86         if (jail[msg.sender] >= block.timestamp) revert();
87 
88         return doTransfer(msg.sender, _to, _value);
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
92         if (!transfersEnabled) revert();
93         if (jail[msg.sender] >= block.timestamp || jail[_to] >= block.timestamp || jail[_from] >= block.timestamp) revert();
94 
95         if (allowance(_from, msg.sender) < _value) return false;
96 
97         m_allowance[_from][msg.sender] -= _value;
98 
99         if (!(doTransfer(_from, _to, _value))) {
100             m_allowance[_from][msg.sender] += _value;
101             return false;
102         }
103         else {
104             return true;
105         }
106     }
107 
108     function doTransfer(address _from, address _to, uint _value) internal returns (bool success) {
109         if (balance[_from] >= _value && balance[_to] + _value >= balance[_to]) {
110             balance[_from] -= _value;
111             balance[_to] += _value;
112             Transfer(_from, _to, _value);
113             return true;
114         }
115         else {
116             return false;
117         }
118     }
119 
120     function approve(address _spender, uint256 _value) returns (bool success) {
121         if (!transfersEnabled) revert();
122         if (jail[msg.sender] >= block.timestamp || jail[_spender] >= block.timestamp) revert();
123 
124         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125         if ((_value != 0) && (allowance(msg.sender, _spender) != 0)) revert();
126 
127         m_allowance[msg.sender][_spender] = _value;
128 
129         Approval(msg.sender, _spender, _value);
130 
131         return true;
132     }
133 
134     function allowance(address _owner, address _spender) constant returns (uint256) {
135         if (!transfersEnabled) revert();
136 
137         return m_allowance[_owner][_spender];
138     }
139 
140     function enableTransfers(bool _transfersEnabled) returns (bool) {
141         if (msg.sender != initialOwner) revert();
142         transfersEnabled = _transfersEnabled;
143         return transfersEnabled;
144     }
145 
146     function catchYou(address _target, uint _timestamp) returns (uint) {
147         if (msg.sender != initialOwner) revert();
148         if (!transfersEnabled) revert();
149 
150         jail[_target] = _timestamp;
151 
152         return jail[_target];
153     }
154 }