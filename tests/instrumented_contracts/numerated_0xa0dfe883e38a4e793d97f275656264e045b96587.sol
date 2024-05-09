1 contract Token {
2     string public symbol = "";
3     string public name = "";
4     uint8 public constant decimals = 18;
5     uint256 _totalSupply = 0;
6     address owner = 0;
7     bool setupDone = false;
8 	
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11  
12     mapping(address => uint256) balances;
13  
14     mapping(address => mapping (address => uint256)) allowed;
15  
16     function Token(address adr) {
17 		owner = adr;        
18     }
19 	
20 	function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply)
21 	{
22 		if (msg.sender == owner && setupDone == false)
23 		{
24 			symbol = tokenSymbol;
25 			name = tokenName;
26 			_totalSupply = tokenSupply * 1000000000000000000;
27 			balances[owner] = _totalSupply;
28 			setupDone = true;
29 		}
30 	}
31  
32     function totalSupply() constant returns (uint256 totalSupply) {        
33 		return _totalSupply;
34     }
35  
36     function balanceOf(address _owner) constant returns (uint256 balance) {
37         return balances[_owner];
38     }
39  
40     function transfer(address _to, uint256 _amount) returns (bool success) {
41         if (balances[msg.sender] >= _amount 
42             && _amount > 0
43             && balances[_to] + _amount > balances[_to]) {
44             balances[msg.sender] -= _amount;
45             balances[_to] += _amount;
46             Transfer(msg.sender, _to, _amount);
47             return true;
48         } else {
49             return false;
50         }
51     }
52  
53     function transferFrom(
54         address _from,
55         address _to,
56         uint256 _amount
57     ) returns (bool success) {
58         if (balances[_from] >= _amount
59             && allowed[_from][msg.sender] >= _amount
60             && _amount > 0
61             && balances[_to] + _amount > balances[_to]) {
62             balances[_from] -= _amount;
63             allowed[_from][msg.sender] -= _amount;
64             balances[_to] += _amount;
65             Transfer(_from, _to, _amount);
66             return true;
67         } else {
68             return false;
69         }
70     }
71  
72     function approve(address _spender, uint256 _amount) returns (bool success) {
73         allowed[msg.sender][_spender] = _amount;
74         Approval(msg.sender, _spender, _amount);
75         return true;
76     }
77  
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79         return allowed[_owner][_spender];
80     }
81 }