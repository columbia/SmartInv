1 pragma solidity ^0.4;
2 
3 
4 contract ERC20 {
5    uint public totalSupply;
6    function balanceOf(address _account) public constant returns (uint balance);
7    function transfer(address _to, uint _value) public returns (bool success);
8    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
9    function approve(address _spender, uint _value) public returns (bool success);
10    function allowance(address _owner, address _spender) public constant returns (uint remaining);
11    event Transfer(address indexed _from, address indexed _to, uint _value);
12    event Approval(address indexed _owner, address indexed _spender, uint _value);
13 }
14 
15 
16 contract Token is ERC20 {
17 
18     mapping(address => uint256) public balances;
19 
20     
21     mapping(address => uint256) public investBalances;
22 
23     mapping(address => mapping (address => uint)) allowed;
24 
25     // Total amount of supplied tokens
26     uint256 public totalSupply;
27 
28     // Information about token
29     string public constant name = "MMS";
30     string public constant symbol = "MMS";
31     address public owner;
32     address public owner2;
33     address public owner3;
34     uint public decimals = 18;
35 
36     // If function has this modifier, only owner can execute this function
37     modifier onlyOwner() {
38         require(msg.sender == owner || msg.sender == owner2 || msg.sender == owner3);
39         _;
40     }
41 
42 
43 
44 
45     function Token() public {
46         totalSupply = 10000000000000000000000000;
47         owner = 0x1FC11ac635e89c228765f3e6aEe0970D9aFf2BF5;
48         owner2 = 0x4AB9AA258369438bC146b26af02F6E3568009D92;
49         balances[owner] = totalSupply;
50     }
51 
52     // Change main owner address and transer tokens to new owner
53     function transferOwnership(address newOwner) public onlyOwner {
54         require(newOwner != owner);
55         balances[newOwner] = balances[owner];
56         balances[owner] = 0;
57         owner = newOwner;
58     }
59 
60     // Chech trade balance of account
61     function balanceOf(address _account) public constant returns (uint256 balance) {
62     return balances[_account];
63     }
64 
65  // Transfer tokens from your account to other account
66     function transfer(address _to, uint _value) public  returns (bool success) {
67         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
68         require(balances[msg.sender] >= _value);           // Check if the sender has enough
69         balances[msg.sender] -= _value;                    // Subtract from the sender
70         balances[_to] += _value;                           // Add the same to the recipient
71         Transfer(msg.sender, _to, _value);
72     return true;
73     }
74 
75    // Transfer tokens from account (_from) to another account (_to)
76     function transferFrom(address _from, address _to, uint256 _amount) public  returns(bool) {
77         require(_amount <= allowed[_from][msg.sender]);
78         if (balances[_from] >= _amount && _amount > 0) {
79             balances[_from] -= _amount;
80             balances[_to] += _amount;
81             allowed[_from][msg.sender] -= _amount;
82             Transfer(_from, _to, _amount);
83             return true;
84         }
85         else {
86             return false;
87             }
88     }
89 
90     function approve(address _spender, uint _value) public  returns (bool success){
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93     return true;
94     }
95 
96     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
97     return allowed[_owner][_spender];
98     }
99 
100     function add_tokens(address _to, uint256 _amount) public onlyOwner {
101         balances[owner] -= _amount;
102         investBalances[_to] += _amount;
103     }
104 
105     // Transfer tokens from investBalance to Balncec for trading
106     function transferToken_toBalance(address _user, uint256 _amount) public onlyOwner {
107         investBalances[_user] -= _amount;
108         balances[_user] += _amount;
109     } 
110 
111     // Transfer toknes from Balncec to investBalance
112     function transferToken_toInvestBalance(address _user, uint256 _amount) public onlyOwner {
113         balances[_user] -= _amount;
114         investBalances[_user] += _amount;
115     }  
116 
117 
118     function changeOwner3(address _owner3) public onlyOwner {
119         owner3 = _owner3;
120     }
121 }