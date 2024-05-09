1 pragma solidity ^0.4.16;
2 
3 // Copyright 2017. box.la authors.
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/issues/20
6 contract BOX {
7     string public constant symbol = "BOX";
8     string public constant name = "BOX Token";
9     uint8 public constant decimals = 18;
10     uint256 _totalSupply = (10 ** 8) * (10 ** 18);
11 
12     address public owner;
13 
14     // Balances for each account
15     mapping(address => uint256) balances;
16     // Owner of account approves the transfer of an amount to another account
17     mapping(address => mapping (address => uint256)) allowed;
18 
19     // Constructor
20     function BOX() public {
21         owner = msg.sender;
22         balances[owner] = _totalSupply;
23     }
24 
25     // Send back ether sent to me
26     function () public {
27         revert();
28     }
29 
30     function totalSupply() constant public returns (uint256) {
31         return _totalSupply;
32     }
33     
34     // What is the balance of a particular account?
35     function balanceOf(address _owner) constant public returns (uint256 balance) {
36         return balances[_owner];
37     }
38 
39     // Transfer the balance from owner's account to another account
40     function transfer(address _to, uint256 _amount) public returns (bool success) {
41         if (balances[msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
42             balances[msg.sender] -= _amount;
43             balances[_to] += _amount;
44             Transfer(msg.sender, _to, _amount);
45             return true;
46         } else {
47             return false;
48         }
49     }
50 
51     // Send _value amount of tokens from address _from to address _to
52     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
53     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
54     // fees in sub-currencies; the command should fail unless the _from account has
55     // deliberately authorized the sender of the message via some mechanism; we propose
56     // these standardized APIs for approval:
57     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
58         if (balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount > 0 && balances[_to] + _amount > balances[_to]) {
59             balances[_from] -= _amount;
60             allowed[_from][msg.sender] -= _amount;
61             balances[_to] += _amount;
62             Transfer(_from, _to, _amount);
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
70     // If this function is called again it overwrites the current allowance with _value.
71     function approve(address _spender, uint256 _amount) public returns (bool success) {
72         allowed[msg.sender][_spender] = _amount;
73         Approval(msg.sender, _spender, _amount);
74         return true;
75     }
76 
77     // Returns the amount which _spender is still allowed to withdraw from _owner
78     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }