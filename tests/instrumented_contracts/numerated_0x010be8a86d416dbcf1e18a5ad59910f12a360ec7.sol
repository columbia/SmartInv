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
17     // Balances for trading
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
29     string public constant name = "3D METAMORPHOSIS";
30     string public constant symbol = "MMS";
31     address public owner;
32     address public owner2;
33     uint8 public decimals = 6;
34 
35     // If function has this modifier, only owner can execute this function
36     modifier onlyOwner() {
37         require(msg.sender == owner || msg.sender == owner2);
38         _;
39     }
40 
41 
42 
43 
44     function Token() public {
45         owner = msg.sender;
46         totalSupply = 1000000000000;
47         balances[owner] = totalSupply;
48     }
49 
50     // Change main owner address and transer tokens to new owner
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != owner);
53         balances[newOwner] = balances[owner];
54         balances[owner] = 0;
55         owner = newOwner;
56     }
57 
58     // Chech trade balance of account
59     function balanceOf(address _account) public constant returns (uint256 balance) {
60     return balances[_account];
61     }
62 
63  // Transfer tokens from your account to other account
64     function transfer(address _to, uint _value) public  returns (bool success) {
65         require(_to != 0x0);                               // Prevent transfer to 0x0 address.
66         require(balances[msg.sender] >= _value);           // Check if the sender has enough
67         balances[msg.sender] -= _value;                    // Subtract from the sender
68         balances[_to] += _value;                           // Add the same to the recipient
69         Transfer(msg.sender, _to, _value);
70     return true;
71     }
72 
73    // Transfer tokens from account (_from) to another account (_to)
74     function transferFrom(address _from, address _to, uint256 _amount) public  returns(bool) {
75         require(_amount <= allowed[_from][msg.sender]);
76         if (balances[_from] >= _amount && _amount > 0) {
77             balances[_from] -= _amount;
78             balances[_to] += _amount;
79             allowed[_from][msg.sender] -= _amount;
80             Transfer(_from, _to, _amount);
81             return true;
82         }
83         else {
84             return false;
85             }
86     }
87 
88     function approve(address _spender, uint _value) public  returns (bool success){
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91     return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
95     return allowed[_owner][_spender];
96     }
97 
98     function add_tokens(address _to, uint256 _amount) public onlyOwner {
99         balances[owner] -= _amount;
100         investBalances[_to] += _amount;
101     }
102 
103     // Transfer tokens from investBalance to Balncec for trading
104     function transferToken_toBalance(address _user, uint256 _amount) public onlyOwner {
105         investBalances[_user] -= _amount;
106         balances[_user] += _amount;
107     } 
108 
109     // Transfer toknes from Balncec to investBalance
110     function transferToken_toInvestBalance(address _user, uint256 _amount) public onlyOwner {
111         balances[_user] -= _amount;
112         investBalances[_user] += _amount;
113     }  
114 
115 
116     function addOwner2(address _owner2) public onlyOwner {
117         owner2 = _owner2;
118     }
119 }