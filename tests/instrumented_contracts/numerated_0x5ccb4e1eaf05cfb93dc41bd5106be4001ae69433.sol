1 pragma solidity ^0.4.11;
2 
3 contract EXA {
4     string public constant symbol = "EXA.COM";
5     string public constant name = "example.com";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = (10 ** 8) * (10 ** 18);
8 
9     address public owner;
10 
11     // Balances for each account
12     mapping(address => uint256) balances;
13     // Owner of account approves the transfer of an amount to another account
14     mapping(address => mapping (address => uint256)) allowed;
15 
16     // Constructor
17     function EXA() public {
18         owner = msg.sender;
19         balances[owner] = _totalSupply;
20     }
21 
22     // Send back ether sent to me
23     function () public {
24         revert();
25     }
26 
27     function totalSupply() constant public returns (uint256) {
28         return _totalSupply;
29     }
30 
31     // What is the balance of a particular account?
32     function balanceOf(address _owner) constant public returns (uint256 balance) {
33         return balances[_owner];
34     }
35 
36     // Transfer the balance from owner's account to another account
37     function transfer(address _to, uint256 _amount) public returns (bool success) {
38         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
39             balances[msg.sender] -= _amount;
40             balances[_to] += _amount;
41             Transfer(msg.sender, _to, _amount);
42             return true;
43         } else {
44             return false;
45         }
46     }
47 
48     // Send _value amount of tokens from address _from to address _to
49     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
50     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
51     // fees in sub-currencies; the command should fail unless the _from account has
52     // deliberately authorized the sender of the message via some mechanism; we propose
53     // these standardized APIs for approval:
54     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
55         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
56             balances[_from] -= _amount;
57             allowed[_from][msg.sender] -= _amount;
58             balances[_to] += _amount;
59             Transfer(_from, _to, _amount);
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
67     // If this function is called again it overwrites the current allowance with _value.
68     function approve(address _spender, uint256 _amount) public returns (bool success) {
69         allowed[msg.sender][_spender] = _amount;
70         Approval(msg.sender, _spender, _amount);
71         return true;
72     }
73 
74     // Returns the amount which _spender is still allowed to withdraw from _owner
75     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 }