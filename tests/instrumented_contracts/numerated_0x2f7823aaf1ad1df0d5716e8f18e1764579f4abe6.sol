1 pragma solidity ^0.4.19;
2 
3 contract EIP20Interface {
4     uint256 public totalSupply;
5 
6     function balanceOf(address _owner) public view returns (uint256 balance);
7 
8     function transfer(address _to, uint256 _value) public returns (bool success);
9 
10     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
11 
12     function approve(address _spender, uint256 _value) public returns (bool success);
13 
14     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
17     
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20     event Burn(address indexed burner, uint256 value);
21 }
22 
23 contract EIP20 is EIP20Interface {
24     uint256 constant private MAX_UINT256 = 2**256 - 1;
25 
26     mapping (address => uint256) public balances;
27     mapping (address => mapping (address => uint256)) public allowed;
28     mapping (address => uint256) public admins;
29     address private owner;
30     string public name;
31     uint8 public decimals;
32     string public symbol;
33     uint8 public transfers;
34 
35     function EIP20() public {
36         balances[msg.sender] = 5174000;
37         totalSupply = 5174000;
38         name = "GoldStyxCoin";
39         decimals = 0;
40         symbol = "GSXC";
41         owner = msg.sender;
42     }
43     
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45 
46         require(transfers != 0);
47         
48         require( admins[msg.sender] == 1 || now > 1522799999 );
49         
50         require(_to != address(0));
51         
52         require(balances[msg.sender] >= _value);
53         
54         balances[msg.sender] -= _value;
55         
56         balances[_to] += _value;
57         
58         Transfer(msg.sender, _to, _value);
59         
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64 
65         require(transfers != 0);
66         
67         require( admins[msg.sender] == 1 || now > 1522799999 );
68         
69         require(_to != address(0));
70         
71         uint256 allowance = allowed[_from][msg.sender];
72         
73         require(balances[_from] >= _value && allowance >= _value);
74         
75         balances[_from] -= _value;
76         
77         balances[_to] += _value;
78         
79         if (allowance < MAX_UINT256) {
80             allowed[_from][msg.sender] -= _value;
81         }
82         
83         Transfer(_from, _to, _value);
84         
85         return true;
86     }
87 
88     function balanceOf(address _owner) public view returns (uint256 balance) {
89         return balances[_owner]; 
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         
95         Approval(msg.sender, _spender, _value);
96         
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
101         return allowed[_owner][_spender];
102     }   
103     
104     function burn(uint256 _value) public {
105         require(msg.sender == owner);
106         
107         require(_value <= balances[msg.sender]);
108         
109         address burner = msg.sender;
110         
111         balances[burner] -= _value;
112         
113         totalSupply -= _value;
114         
115         Burn(burner, _value);
116     }
117     
118     function transfersOnOff(uint8 _value) public {
119         require(msg.sender == owner);
120         
121         transfers = _value;
122     }
123     
124     function admin(address _admin, uint8 _value) public {
125         require(msg.sender == owner);
126         
127         admins[_admin] = _value;
128     }
129 }