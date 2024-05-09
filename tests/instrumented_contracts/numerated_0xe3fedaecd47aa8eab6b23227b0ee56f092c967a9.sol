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
37 contract PrimasToken is ERC20Token {
38     address public initialOwner;
39     uint256 public supply   = 100000000 * 10 ** 18;  // 100, 000, 000
40     string  public name     = 'Primas';
41     uint8   public decimals = 18;
42     string  public symbol   = 'PST';
43     string  public version  = 'v0.1';
44     bool    public transfersEnabled = true;
45     uint    public creationBlock;
46     uint    public creationTime;
47     
48     mapping (address => uint256) balance;
49     mapping (address => mapping (address => uint256)) m_allowance;
50     mapping (address => uint) jail;
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 
55     function PrimasToken() {
56         initialOwner        = msg.sender;
57         balance[msg.sender] = supply;
58         creationBlock       = block.number;
59         creationTime        = block.timestamp;
60     }
61 
62     function balanceOf(address _account) constant returns (uint) {
63         return balance[_account];
64     }
65 
66     function totalSupply() constant returns (uint) {
67         return supply;
68     }
69 
70     function transfer(address _to, uint256 _value) returns (bool success) {
71         // `revert()` | `throw`
72         //      http://solidity.readthedocs.io/en/develop/control-structures.html#error-handling-assert-require-revert-and-exceptions
73         //      https://ethereum.stackexchange.com/questions/20978/why-do-throw-and-revert-create-different-bytecodes/20981
74         if (!transfersEnabled) revert();
75         if ( jail[msg.sender] >= block.timestamp ) revert();
76         
77         return doTransfer(msg.sender, _to, _value);
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
81         if (!transfersEnabled) revert();
82         if ( jail[msg.sender] >= block.timestamp || jail[_to] >= block.timestamp || jail[_from] >= block.timestamp ) revert();
83             
84         if (allowance(_from, msg.sender) < _value) return false;
85         
86         m_allowance[_from][msg.sender] -= _value;
87         
88         if ( !(doTransfer(_from, _to, _value)) ) {
89             m_allowance[_from][msg.sender] += _value;
90             return false;
91         } else {
92             return true;
93         }
94     }
95 
96     function doTransfer(address _from, address _to, uint _value) internal returns (bool success) {
97         if (balance[_from] >= _value && balance[_to] + _value >= balance[_to]) {
98             balance[_from] -= _value;
99             balance[_to] += _value;
100             Transfer(_from, _to, _value);
101             return true;
102         } else {
103             return false;
104         }
105     }
106     
107     function approve(address _spender, uint256 _value) returns (bool success) {
108         if (!transfersEnabled) revert();
109         if ( jail[msg.sender] >= block.timestamp || jail[_spender] >= block.timestamp ) revert();
110 
111         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112         if ( (_value != 0) && (allowance(msg.sender, _spender) != 0) ) revert();
113         
114         m_allowance[msg.sender][_spender] = _value;
115 
116         Approval(msg.sender, _spender, _value);
117 
118         return true;
119     }
120     
121     function allowance(address _owner, address _spender) constant returns (uint256) {
122         if (!transfersEnabled) revert();
123 
124         return m_allowance[_owner][_spender];
125     }
126     
127     function enableTransfers(bool _transfersEnabled) returns (bool) {
128         if (msg.sender != initialOwner) revert();
129         transfersEnabled = _transfersEnabled;
130         return transfersEnabled;
131     }
132 
133     function catchYou(address _target, uint _timestamp) returns (uint) {
134         if (msg.sender != initialOwner) revert();
135         if (!transfersEnabled) revert();
136 
137         jail[_target] = _timestamp;
138 
139         return jail[_target];
140     }
141 
142 }