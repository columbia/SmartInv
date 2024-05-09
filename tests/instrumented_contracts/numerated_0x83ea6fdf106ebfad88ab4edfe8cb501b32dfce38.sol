1 pragma solidity ^0.4.11;
2 
3  
4 
5 contract Netinance  {
6 
7  
8 
9     string public name = "Netinance";      //  (token name)
10 
11     string public symbol = "NET";           //  (token symbol)
12 
13     uint256 public decimals = 8;            //   (token digit)
14 
15  
16 
17     mapping (address => uint256) public balanceOf;
18 
19     mapping (address => mapping (address => uint256)) public allowance;
20 
21  
22 
23     uint256 public totalSupply = 25000000 * (10**decimals);   // (total supply)
24 
25     address owner;
26 
27  
28 
29     modifier isOwner {
30 
31         assert(owner == msg.sender);
32 
33         _;
34 
35     }
36 
37     function Netinance () {
38 
39         owner = msg.sender;
40 
41         balanceOf[owner] = totalSupply;
42 
43     }
44 
45  
46 
47     function transfer(address _to, uint256 _value) returns (bool success) {
48 
49         require(balanceOf[msg.sender] >= _value);
50 
51         require(balanceOf[_to] + _value >= balanceOf[_to]);
52 
53         balanceOf[msg.sender] -= _value;
54 
55         balanceOf[_to] += _value;
56 
57         Transfer(msg.sender, _to, _value);
58 
59         return true;
60 
61     }
62 
63  
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66 
67         require(balanceOf[_from] >= _value);
68 
69         require(balanceOf[_to] + _value >= balanceOf[_to]);
70 
71         require(allowance[_from][msg.sender] >= _value);
72 
73         balanceOf[_to] += _value;
74 
75         balanceOf[_from] -= _value;
76 
77         allowance[_from][msg.sender] -= _value;
78 
79         Transfer(_from, _to, _value);
80 
81         return true;
82 
83     }
84 
85  
86 
87     function approve(address _spender, uint256 _value) returns (bool success)
88 
89     {
90 
91         require(_value == 0 || allowance[msg.sender][_spender] == 0);
92 
93         allowance[msg.sender][_spender] = _value;
94 
95         Approval(msg.sender, _spender, _value);
96 
97         return true;
98 
99     }
100 
101    
102 
103     function setName(string _name) isOwner
104 
105     {
106 
107         name = _name;
108 
109     }
110 
111     event Transfer(address indexed _from, address indexed _to, uint256 _value);
112 
113     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 
115 }