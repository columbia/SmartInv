1 pragma solidity ^0.4.8;
2 contract ERC20Interface {
3     // Get the total token supply
4     function totalSupply() constant returns (uint256 totalSupply);
5  
6     // Get the account balance of another account with address _owner
7     function balanceOf(address _owner) constant returns (uint256 balance);
8  
9     // Send _value amount of tokens to address _to
10     function transfer(address _to, uint256 _value) returns (bool success);
11  
12     // Send _value amount of tokens from address _from to address _to
13     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
14  
15     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
16     // If this function is called again it overwrites the current allowance with _value.
17     // this function is required for some DEX functionality
18     function approve(address _spender, uint256 _value) returns (bool success);
19  
20     // Returns the amount which _spender is still allowed to withdraw from _owner
21     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
22  
23     // Triggered when tokens are transferred.
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25  
26     // Triggered whenever approve(address _spender, uint256 _value) is called.
27     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
28 }
29  
30 contract FixedSupplyToken is ERC20Interface {
31     string public constant symbol = "SVC21C";
32     string public constant name = "Super Value Coupon";
33     uint8 public constant decimals = 18;
34     uint256 _totalSupply = 125000000 * 1000000000000000000; //42million * 10^18;
35     
36     // Owner of this contract
37     address public owner;
38  
39     // Balances for each account
40     mapping(address => uint256) balances;
41  
42     // Owner of account approves the transfer of an amount to another account
43     mapping(address => mapping (address => uint256)) allowed;
44  
45     // Functions with this modifier can only be executed by the owner
46     modifier onlyOwner() {
47         if (msg.sender != owner) {
48             throw;
49         }
50         _;
51     }
52  
53     // Constructor
54     function FixedSupplyToken() {
55         owner = msg.sender;
56         balances[owner] = _totalSupply;
57     }
58  
59     function totalSupply() constant returns (uint256 totalSupply) {
60         totalSupply = _totalSupply;
61     }
62  
63     // What is the balance of a particular account?
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67  
68     // Transfer the balance from owner's account to another account
69     function transfer(address _to, uint256 _amount) returns (bool success) {
70         if (balances[msg.sender] >= _amount 
71             && _amount > 0
72             && balances[_to] + _amount > balances[_to]) {
73             balances[msg.sender] -= _amount;
74             balances[_to] += _amount;
75             Transfer(msg.sender, _to, _amount);
76             return true;
77         } else {
78             return false;
79         }
80     }
81  
82     // Send _value amount of tokens from address _from to address _to
83     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
84     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
85     // fees in sub-currencies; the command should fail unless the _from account has
86     // deliberately authorized the sender of the message via some mechanism; we propose
87     // these standardized APIs for approval:
88     function transferFrom(
89         address _from,
90         address _to,
91         uint256 _amount
92     ) returns (bool success) {
93         if (balances[_from] >= _amount
94             && allowed[_from][msg.sender] >= _amount
95             && _amount > 0
96             && balances[_to] + _amount > balances[_to]) {
97             balances[_from] -= _amount;
98             allowed[_from][msg.sender] -= _amount;
99             balances[_to] += _amount;
100             Transfer(_from, _to, _amount);
101             return true;
102         } else {
103             return false;
104         }
105     }
106  
107     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
108     // If this function is called again it overwrites the current allowance with _value.
109     function approve(address _spender, uint256 _amount) returns (bool success) {
110         allowed[msg.sender][_spender] = _amount;
111         Approval(msg.sender, _spender, _amount);
112         return true;
113     }
114  
115 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
116 			return allowed[_owner][_spender];
117 		}
118 }