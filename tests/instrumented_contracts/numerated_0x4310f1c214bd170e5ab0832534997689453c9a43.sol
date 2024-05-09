1 /**
2  *  DickheadCash contract
3  */
4 
5 pragma solidity 0.4.15;
6 
7 
8 contract ERC20TokenInterface {
9 
10     /// @return The total amount of tokens
11     function totalSupply() constant returns (uint256 supply);
12 
13     /// @param _owner The address from which the balance will be retrieved
14     /// @return The balance
15     function balanceOf(address _owner) constant public returns (uint256 balance);
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of tokens to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) public returns (bool success);
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44 }
45 
46 
47 contract DickheadCash is ERC20TokenInterface {
48 
49     string public constant name = "DickheadCash";
50     string public constant symbol = "DICK";
51     uint256 public constant decimals = 0;
52     uint256 public totalTokens = 1 * (10 ** decimals);
53     uint8 public constant MAX_TRANSFERS = 7;
54 
55     mapping (address => bool) public received;
56     mapping (address => uint8) public transfers;
57     mapping (address => uint256) public balances;
58     mapping (address => mapping (address => uint256)) public allowed;
59 
60 
61     function DickheadCash() {
62         balances[msg.sender] = totalTokens;
63         received[msg.sender] = true;
64     }
65 
66     function totalSupply() constant returns (uint256) {
67         return totalTokens;
68     }
69 
70     function transfersRemaining() returns (uint8) {
71         return MAX_TRANSFERS - transfers[msg.sender];
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         if (_value > 1) return false;
76         if (transfers[msg.sender] >= MAX_TRANSFERS) return false;
77         if (received[_to]) return false;
78         if (received[msg.sender]) {
79             balances[_to] = _value;
80             transfers[msg.sender]++;
81             if (!received[_to]) received[_to] = true;
82             totalTokens += _value;
83             Transfer(msg.sender, _to, _value);
84             return true;
85         }
86         return false;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90         return false;
91     }
92 
93     function balanceOf(address _owner) constant public returns (uint256) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool) {
98         return false;
99     }
100 
101     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
102         return 0;
103     }
104 
105 }