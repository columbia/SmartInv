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
38     uint256 public supply   = 1000000000 * 10 ** 18;  // 1,000,000,000
39     string  public name     = 'PortalToken';
40     uint8   public decimals = 18;
41     string  public symbol   = 'PORTAL';
42     string  public version  = 'v0.2';
43     uint    public creationBlock;
44     uint    public creationTime;
45 
46     mapping (address => uint256) balance;
47     mapping (address => mapping (address => uint256)) m_allowance;
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52     function PortalToken() public{
53         initialOwner        = msg.sender;
54         balance[msg.sender] = supply;
55         creationBlock       = block.number;
56         creationTime        = block.timestamp;
57     }
58 
59     function balanceOf(address _account) constant public returns (uint) {
60         return balance[_account];
61     }
62 
63     function totalSupply() constant public returns (uint) {
64         return supply;
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         // `revert()` | `throw`
69         //      http://solidity.readthedocs.io/en/develop/control-structures.html#error-handling-assert-require-revert-and-exceptions
70         //      https://ethereum.stackexchange.com/questions/20978/why-do-throw-and-revert-create-different-bytecodes/20981
71         return doTransfer(msg.sender, _to, _value);
72     }
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75         if (allowance(_from, msg.sender) < _value) revert();
76 
77         m_allowance[_from][msg.sender] -= _value;
78 
79         if ( !(doTransfer(_from, _to, _value)) ) {
80             m_allowance[_from][msg.sender] += _value;
81             return false;
82         } else {
83             return true;
84         }
85     }
86 
87     function doTransfer(address _from, address _to, uint _value) internal returns (bool success) {
88         if (balance[_from] >= _value && balance[_to] + _value >= balance[_to]) {
89             balance[_from] -= _value;
90             balance[_to] += _value;
91             emit Transfer(_from, _to, _value);
92             return true;
93         } else {
94             return false;
95         }
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100         if ( (_value != 0) && (allowance(msg.sender, _spender) != 0) ) revert();
101 
102         m_allowance[msg.sender][_spender] = _value;
103 
104         emit Approval(msg.sender, _spender, _value);
105 
106         return true;
107     }
108 
109     function allowance(address _owner, address _spender) constant public returns (uint256) {
110         return m_allowance[_owner][_spender];
111     }
112 
113 }