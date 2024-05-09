1 pragma solidity ^0.4.8;
2     
3    // ----------------------------------------------------------------------------------------------
4    // Sample fixed supply token contract
5    // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6    // ----------------------------------------------------------------------------------------------
7     
8    // ERC Token Standard #20 Interface
9    // https://github.com/ethereum/EIPs/issues/20
10   contract TokenERC20 {
11       // Get the total token supply
12       function totalSupply() constant returns (uint256 totalSupply);
13    
14       // Get the account balance of another account with address _owner
15       function balanceOf(address _owner) constant returns (uint256 balance);
16    
17       // Send _value amount of tokens to address _to
18       function transfer(address _to, uint256 _value) returns (bool success);
19   
20       // Send _value amount of tokens from address _from to address _to
21       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
22    
23       // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
24      // If this function is called again it overwrites the current allowance with _value.
25       // this function is required for some DEX functionality
26       function approve(address _spender, uint256 _value) returns (bool success);
27    
28      // Returns the amount which _spender is still allowed to withdraw from _owner
29     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30   
31      // Triggered when tokens are transferred.
32      event Transfer(address indexed _from, address indexed _to, uint256 _value);
33    
34      // Triggered whenever approve(address _spender, uint256 _value) is called.
35       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36   }
37    
38   contract Avarice is TokenERC20 {
39      string public constant symbol = "AVARICE";
40       string public constant name = "Avarice Token";
41       uint8 public constant decimals = 18;
42       uint256 _totalSupply = 50000000;
43       
44       // Owner of this contract
45      address public owner;
46    
47       // Balances for each account
48       mapping(address => uint256) balances;
49    
50       // Owner of account approves the transfer of an amount to another account
51     mapping(address => mapping (address => uint256)) allowed;
52    
53       // Functions with this modifier can only be executed by the owner
54       modifier onlyOwner() {
55           if (msg.sender != owner) {
56               throw;
57          }
58           _;
59       }
60   
61      // Constructor
62       function FixedSupplyToken() {
63          owner = msg.sender;
64           balances[owner] = _totalSupply;
65      }
66    
67       function totalSupply() constant returns (uint256 totalSupply) {
68           totalSupply = _totalSupply;
69       }
70   
71       // What is the balance of a particular account?
72       function balanceOf(address _owner) constant returns (uint256 balance) {
73          return balances[_owner];
74       }
75   
76      // Transfer the balance from owner's account to another account
77       function transfer(address _to, uint256 _amount) returns (bool success) {
78           if (balances[msg.sender] >= _amount 
79               && _amount > 0
80               && balances[_to] + _amount > balances[_to]) {
81               balances[msg.sender] -= _amount;
82              balances[_to] += _amount;
83               Transfer(msg.sender, _to, _amount);
84              return true;
85          } else {
86             return false;
87          }
88      }
89  
90       function transferFrom(
91           address _from,
92          address _to,
93           uint256 _amount
94      ) returns (bool success) {
95          if (balances[_from] >= _amount
96             && allowed[_from][msg.sender] >= _amount
97              && _amount > 0
98              && balances[_to] + _amount > balances[_to]) {
99              balances[_from] -= _amount;
100              allowed[_from][msg.sender] -= _amount;
101             balances[_to] += _amount;
102              Transfer(_from, _to, _amount);
103              return true;
104          } else {
105             return false;
106          }
107      }
108   
109 
110      function approve(address _spender, uint256 _amount) returns (bool success) {
111          allowed[msg.sender][_spender] = _amount;
112          Approval(msg.sender, _spender, _amount);
113          return true;
114      }
115   
116      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
117          return allowed[_owner][_spender];
118      }
119   }