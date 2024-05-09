1 pragma solidity ^0.4.20;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256)
6     {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9 
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256)
14     {
15         uint256 c = a / b;
16 
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256)
21     {
22         assert(b <= a);
23 
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256)
28     {
29         uint256 c = a + b;
30         assert(c >= a);
31 
32         return c;
33     }
34 }
35 
36 contract OwnerHelper
37 {
38     address public owner;
39     
40     event OwnerTransferPropose(address indexed _from, address indexed _to);
41 
42     modifier onlyOwner
43     {
44         require(msg.sender == owner);
45         _;
46 }
47 
48     function OwnerHelper() public
49     {
50     	owner = msg.sender;
51     }
52 
53     function transferOwnership(address _to) onlyOwner public
54     {
55         require(_to != owner);
56         require(_to != address(0x0));
57         owner = _to;
58         OwnerTransferPropose(owner, _to);
59     }
60 }
61 
62 contract ERC20Interface
63 {
64     event Transfer( address indexed _from, address indexed _to, uint _value);
65     event Approval( address indexed _owner, address indexed _spender, uint _value);
66     
67     function totalSupply() constant public returns (uint _supply);
68     function balanceOf( address _who ) constant public returns (uint _value);
69     function transfer( address _to, uint _value) public returns (bool _success);
70     function approve( address _spender, uint _value ) public returns (bool _success);
71     function allowance( address _owner, address _spender ) constant public returns (uint _allowance);
72     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
73 }
74 
75 contract ChainTree is ERC20Interface, OwnerHelper
76 {
77     using SafeMath for uint256;
78     
79     string public name;
80     uint public decimals;
81     string public symbol;
82     uint public totalSupply;
83     uint private E18 = 1000000000000000000;
84 
85     bool public tokenLock = false;
86     mapping (address => uint) public balances;
87     mapping (address => mapping ( address => uint )) public approvals;
88     
89     function ChainTree(string _name, uint _decimals, string _symbol, uint _totalSupply, address _to) public
90     {
91         name = _name;
92         decimals = _decimals;
93         symbol = _symbol;
94         totalSupply = _totalSupply * E18;
95         balances[_to] = totalSupply;
96     }
97  
98     function totalSupply() constant public returns (uint) 
99     {
100         return totalSupply;
101     }
102     
103     function balanceOf(address _who) constant public returns (uint) 
104     {
105         return balances[_who];
106     }
107     
108     function transfer(address _to, uint _value) public returns (bool) 
109     {
110         require(balances[msg.sender] >= _value);
111         require(tokenLock == false);
112         
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         
116         Transfer(msg.sender, _to, _value);
117         
118         return true;
119     }
120     
121     function approve(address _spender, uint _value) public returns (bool)
122     {
123         require(balances[msg.sender] >= _value);
124         approvals[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126         
127         return true;
128     }
129     
130     function allowance(address _owner, address _spender) constant public returns (uint) 
131     {
132         return approvals[_owner][_spender];
133     }
134     
135     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
136     {
137         require(balances[_from] >= _value);
138         require(approvals[_from][msg.sender] >= _value);        
139         require(tokenLock == false);
140         
141         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
142         balances[_from] = balances[_from].sub(_value);
143         balances[_to]  = balances[_to].add(_value);
144         
145         Transfer(_from, _to, _value);
146         
147         return true;
148     }
149 }