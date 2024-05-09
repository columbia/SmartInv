1 pragma solidity ^0.4.24;
2 
3 //____________________________________________________________________________________
4 //
5 //  Welcome to Steganograph!
6 //____________________________________________________________________________________|
7 
8 
9 
10 contract Steganograph
11 {
12 
13 
14     address     owner = 0x12C3Fd99ab45Bd806128E96062dc5A6C273d8AF6;
15 
16 
17     string      public standard = 'Token 0.1';
18     string      public name = 'Steganograph'; 
19     string      public symbol = 'PHY';
20     uint8       public decimals = 3; 
21     uint256     public totalSupply = 1168000000000;
22     
23 
24     mapping (address => uint256) balances;  
25     mapping (address => mapping (address => uint256)) allowed;
26 
27 
28     modifier ownerOnly() 
29     {
30         require(msg.sender == owner);
31         _;
32     }       
33 
34 
35     // We might change the token name only in case of emergency
36     // ____________________________________________________________________________________
37     function changeName(string _name) public ownerOnly returns(bool success) 
38     {
39 
40         name = _name;
41         emit NameChange(name);
42 
43         return true;
44     }
45 
46 
47     // We might change the token symbol only in case of emergency
48     // ____________________________________________________________________________________
49     function changeSymbol(string _symbol) public ownerOnly returns(bool success) 
50     {
51 
52         symbol = _symbol;
53         emit SymbolChange(symbol);
54 
55         return true;
56     }
57 
58 
59     // Use it to get your real PHY balance
60     // ____________________________________________________________________________________
61     function balanceOf(address _owner) public constant returns(uint256 tokens) 
62     {
63 
64         return balances[_owner];
65     }
66     
67 
68     // Use it to transfer PHY to another address
69     // ____________________________________________________________________________________
70     function transfer(address _to, uint256 _value) public returns(bool success)
71     { 
72 
73         require(_value > 0 && balances[msg.sender] >= _value);
74 
75 
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         emit Transfer(msg.sender, _to, _value);
79 
80         return true;
81     }
82 
83 
84     // How much someone allows you to transfer from his/her address
85     // ____________________________________________________________________________________
86     function canTransferFrom(address _owner, address _spender) public constant returns(uint256 tokens) 
87     {
88 
89         require(_owner != 0x0 && _spender != 0x0);
90         
91 
92         if (_owner == _spender)
93         {
94             return balances[_owner];
95         }
96         else 
97         {
98             return allowed[_owner][_spender];
99         }
100     }
101 
102     
103     // Transfer allowed amount of PHY tokens from another address
104     // ____________________________________________________________________________________
105     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) 
106     {
107 
108         require(_value > 0 && _from != 0x0 &&
109                 allowed[_from][msg.sender] >= _value && 
110                 balances[_from] >= _value);
111                 
112 
113         balances[_from] -= _value;
114         allowed[_from][msg.sender] -= _value;
115         balances[_to] += _value;    
116         emit Transfer(_from, _to, _value);
117 
118         return true;
119     }
120 
121     
122     // Allow someone transfer PHY tokens from your address
123     // ____________________________________________________________________________________
124     function approve(address _spender, uint256 _value) public returns(bool success)  
125     {
126 
127         require(_spender != 0x0 && _spender != msg.sender);
128 
129 
130         allowed[msg.sender][_spender] = _value;
131         emit Approval(msg.sender, _spender, _value);
132 
133         return true;
134     }
135 
136 
137     // Token constructor
138     // ____________________________________________________________________________________
139     constructor() public
140     {
141         owner = msg.sender;
142         balances[owner] = totalSupply;
143         emit TokenDeployed(totalSupply);
144     }
145 
146 
147     // ====================================================================================
148     //
149     // List of all events
150 
151     event NameChange(string _name);
152     event SymbolChange(string _symbol);
153     event Transfer(address indexed _from, address indexed _to, uint256 _value);
154     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
155     event TokenDeployed(uint256 _totalSupply);
156 
157 }