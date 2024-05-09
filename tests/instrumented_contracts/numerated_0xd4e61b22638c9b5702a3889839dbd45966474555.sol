1 pragma solidity ^0.4.18;
2 
3 
4 contract rik {
5 
6     uint256 constant MAX_UINT256 = 2**256 - 1;
7     uint256 constant MAX = 150000000000000000000000000;
8 
9     uint256 public cost = 2000000000000;
10     
11     uint256 _totalSupply = 500000000000000000000000;
12     
13         event Transfer(address indexed _from, address indexed _to, uint _value);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15  
16     string public name = "Rik FIESTA!";
17     uint8 public decimals = 18;
18     string public symbol = "RIK";
19     
20  
21   address public wallet = 0xe5f0c234DEb1C9C9f4f8d9Fd8ec7A0Cc5cED1cfa;
22   
23    function () external payable {
24    
25         require(msg.sender != address(0));
26     
27         uint256 amnt = (msg.value / cost) * 1000000000000000000;
28     
29         mint(msg.sender, amnt);
30        
31         if (2000000000000 * 2 **(_totalSupply / 1000000000000000000000000) > cost)
32         {
33             cost = 2000000000000 * 2 **(_totalSupply / 1000000000000000000000000);
34         }
35        
36         // maybe event
37     
38         wallet.transfer(msg.value);
39     }
40     
41     function rik() public {
42         balances[msg.sender] = 500000000000000000000000;
43     }
44     
45     
46     function totalSupply() public constant returns (uint)
47     {
48         return _totalSupply;
49     }
50     
51     function mint(address _to, uint256 _value) private returns (bool success) 
52     {
53         require((_totalSupply + _value) <= MAX);
54         balances[_to] += _value;
55        
56         _totalSupply += _value;
57         
58         return true;
59     }
60    
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63 
64         require(balances[msg.sender] >= _value);
65         balances[msg.sender] -= _value;
66         balances[_to] += _value;
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72        
73         uint256 allowance = allowed[_from][msg.sender];
74         require(balances[_from] >= _value && allowance >= _value);
75         balances[_to] += _value;
76         balances[_from] -= _value;
77         if (allowance < MAX_UINT256) {
78             allowed[_from][msg.sender] -= _value;
79         }
80         Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) view public returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89 
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101     
102 
103 }