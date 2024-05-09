1 pragma solidity ^0.4.18;
2 
3 // author: KK Coin team
4 
5 contract ERC20Standard {
6     // Get the total token supply
7     function totalSupply() public constant returns (uint256 _totalSupply);
8  
9     // Get the account balance of another account with address _owner
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11  
12     // Send _value amount of tokens to address _to
13     function transfer(address _to, uint256 _value) public returns (bool success);
14     
15     // transfer _value amount of token approved by address _from
16     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
17 
18     // approve an address with _value amount of tokens
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 
21     // get remaining token approved by _owner to _spender
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23   
24     // Triggered when tokens are transferred.
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26  
27     // Triggered whenever approve(address _spender, uint256 _value) is called.
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 contract KKToken is ERC20Standard {
32     string public constant symbol = "KK";
33     string public constant name = "KKCOIN";
34     uint256 public constant decimals = 8;
35 
36     uint256 public _totalSupply = 10 ** 18; // equal to 10^10 KK
37 
38     // Owner of this contract
39     address public owner;
40 
41     // Balances KK for each account
42     mapping(address => uint256) private balances;
43 
44     // Owner of account approves the transfer of an amount to another account
45     mapping(address => mapping (address => uint256)) private allowed;
46 
47     /// @dev Constructor
48     function KKToken() public {
49         owner = msg.sender;
50         balances[owner] = _totalSupply;
51         Transfer(0x0, owner, _totalSupply);
52     }
53 
54     /// @return Total supply
55     function totalSupply() public constant returns (uint256) {
56         return _totalSupply;
57     }
58 
59     /// @return Account balance
60     function balanceOf(address _addr) public constant returns (uint256) {
61         return balances[_addr];
62     }
63 
64     /// @return Transfer status
65     function transfer(address _to, uint256 _amount) public returns (bool) {
66         if ( (balances[msg.sender] >= _amount) &&
67              (_amount >= 0) && 
68              (balances[_to] + _amount > balances[_to]) ) {  
69 
70             balances[msg.sender] -= _amount;
71             balances[_to] += _amount;
72             Transfer(msg.sender, _to, _amount);
73             return true;
74         } else {
75             return false;
76         }
77     }
78 
79     // Send _value amount of tokens from address _from to address _to
80     // these standardized APIs for approval:
81     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
82         if (balances[_from] >= _amount
83             && allowed[_from][msg.sender] >= _amount
84             && _amount > 0
85             && balances[_to] + _amount > balances[_to]) {
86             balances[_from] -= _amount;
87             allowed[_from][msg.sender] -= _amount;
88             balances[_to] += _amount;
89             Transfer(_from, _to, _amount);
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
97     // If this function is called again it overwrites the current allowance with _value.
98     function approve(address _spender, uint256 _amount) public returns (bool success) {
99         allowed[msg.sender][_spender] = _amount;
100         Approval(msg.sender, _spender, _amount);
101         return true;
102     }
103 
104     // get allowance
105     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
106         return allowed[_owner][_spender];
107     }
108 }