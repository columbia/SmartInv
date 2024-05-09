1 contract Token {
2     string public symbol = "WJT";
3     string public name = "Wojak Token";
4     uint8 public constant decimals = 18;
5     uint256 _totalSupply = 0;
6     uint nextHalvingDate = 1577836800; //01 Jan 2020
7 	uint initialMintReward = 320000000000000000000000; //320,000 coins
8 	uint mintReward = initialMintReward;
9 	uint mintCalls = 0;
10    
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13  
14     mapping(address => uint256) balances;
15  
16     mapping(address => mapping (address => uint256)) allowed;
17  
18     function totalSupply() constant returns (uint256 totalSupply) {        
19         return _totalSupply;
20     }
21  
22     function balanceOf(address _owner) constant returns (uint256 balance) {
23         return balances[_owner];
24     }
25  
26     function transfer(address _to, uint256 _amount) returns (bool success) {
27         if (balances[msg.sender] >= _amount
28             && _amount > 0
29             && balances[_to] + _amount > balances[_to]) {
30             balances[msg.sender] -= _amount;
31             balances[_to] += _amount;
32             Transfer(msg.sender, _to, _amount);
33             return true;
34         } else {
35             return false;
36         }
37     }
38  
39     function transferFrom(
40         address _from,
41         address _to,
42         uint256 _amount
43     ) returns (bool success) {
44         if (balances[_from] >= _amount
45             && allowed[_from][msg.sender] >= _amount
46             && _amount > 0
47             && balances[_to] + _amount > balances[_to]) {
48             balances[_from] -= _amount;
49             allowed[_from][msg.sender] -= _amount;
50             balances[_to] += _amount;
51             Transfer(_from, _to, _amount);
52             return true;
53         } else {
54             return false;
55         }
56     }
57  
58     function approve(address _spender, uint256 _amount) returns (bool success) {
59         allowed[msg.sender][_spender] = _amount;
60         Approval(msg.sender, _spender, _amount);
61         return true;
62     }
63  
64     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
65         return allowed[_owner][_spender];
66     }
67 	
68 	function Mint() {
69 		if (now > nextHalvingDate)
70 		{
71 			mintReward = mintReward / 2;
72 			nextHalvingDate = nextHalvingDate + 31536000; //+ 1 year
73 		}
74 		balances[msg.sender] += mintReward;
75 		_totalSupply += mintReward;
76 		Transfer(this, msg.sender, mintReward);
77 		mintCalls += 1;
78 	}
79 	
80 	function NextHalvingDate() constant returns(uint256) { return nextHalvingDate;}
81 	function InitialMintReward() constant returns(uint256) { return initialMintReward;}
82 	function MintReward() constant returns(uint256) { return mintReward;}
83 	function MintCalls() constant returns(uint256) { return mintCalls;}
84 }