1 /**
2  *Submitted for verification at Etherscan.io on 2018-04-20
3 */
4 
5 pragma solidity >=0.4.25 <0.6.0;
6 
7 
8 // https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs#transferable-fungibles-see-erc-20-for-the-latest
9 
10 contract ERC20Token {
11     // Triggered when tokens are transferred.
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     // Triggered whenever approve(address _spender, uint256 _value) is called.
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     // Get the total token supply
17     function totalSupply() view public returns (uint256 supply);
18 
19     // Get the account `balance` of another account with address `_owner`
20     function balanceOf(address _owner) view public returns (uint256 balance);
21 
22     // Send `_value` amount of tokens to address `_to`
23     function transfer(address _to, uint256 _value) public returns (bool success);
24 
25     // Send `_value` amount of tokens from address `_from` to address `_to`
26     // The `transferFrom` method is used for a withdraw workflow, allowing contracts to send tokens on your behalf,
27     // for example to "deposit" to a contract address and/or to charge fees in sub-currencies;
28     // the command should fail unless the `_from` account has deliberately authorized the sender of the message
29     // via some mechanism; we propose these standardized APIs for `approval`:
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 
32     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
33     // If this function is called again it overwrites the current allowance with _value.
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     // Returns the amount which _spender is still allowed to withdraw from _owner
37     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
38 }
39 
40 contract TSNOcoin is ERC20Token {
41     address public initialOwner;
42     uint256 public supply   = 5000000000 * 10 ** 18;  // 5,000,000,000
43     string  public name     = 'TSNOToken';
44     uint8   public decimals = 18;
45     string  public symbol   = 'TSNO';
46     string  public version  = 'v0.1';
47     uint    public creationBlock;
48     uint    public creationTime;
49 
50     mapping (address => uint256) balance;
51     mapping (address => mapping (address => uint256)) m_allowance;
52 
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 
56     constructor() public{
57         initialOwner        = msg.sender;
58         balance[msg.sender] = supply;
59         creationBlock       = block.number;
60         creationTime        = block.timestamp;
61     }
62 
63     function balanceOf(address _account) view public returns (uint) {
64         return balance[_account];
65     }
66 
67     function totalSupply() view public returns (uint) {
68         return supply;
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         // `revert()` | `throw`
73         //      http://solidity.readthedocs.io/en/develop/control-structures.html#error-handling-assert-require-revert-and-exceptions
74         //      https://ethereum.stackexchange.com/questions/20978/why-do-throw-and-revert-create-different-bytecodes/20981
75         return doTransfer(msg.sender, _to, _value);
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         if (allowance(_from, msg.sender) < _value) revert();
80 
81         m_allowance[_from][msg.sender] -= _value;
82 
83         if ( !(doTransfer(_from, _to, _value)) ) {
84             m_allowance[_from][msg.sender] += _value;
85             return false;
86         } else {
87             return true;
88         }
89     }
90 
91     function doTransfer(address _from, address _to, uint _value) internal returns (bool success) {
92         if (balance[_from] >= _value && balance[_to] + _value >= balance[_to]) {
93             balance[_from] -= _value;
94             balance[_to] += _value;
95             emit Transfer(_from, _to, _value);
96             return true;
97         } else {
98             return false;
99         }
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104         if ( (_value != 0) && (allowance(msg.sender, _spender) != 0) ) revert();
105 
106         m_allowance[msg.sender][_spender] = _value;
107 
108         emit Approval(msg.sender, _spender, _value);
109 
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) view public returns (uint256) {
114         return m_allowance[_owner][_spender];
115     }
116 
117 }