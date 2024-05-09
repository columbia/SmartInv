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
50         owner = msg.sender;
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
75 contract Hellob is ERC20Interface, OwnerHelper
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
89     function Hellob() public
90     {
91         name = "DANCLE";
92         decimals = 18;
93         symbol = "DNCL";
94         owner = msg.sender;
95         
96         totalSupply = 2000000000 * E18; // totalSupply
97         
98         balances[msg.sender] = totalSupply;
99     }
100  
101     function totalSupply() constant public returns (uint) 
102     {
103         return totalSupply;
104     }
105     
106     function balanceOf(address _who) constant public returns (uint) 
107     {
108         return balances[_who];
109     }
110     
111     function transfer(address _to, uint _value) public returns (bool) 
112     {
113         require(balances[msg.sender] >= _value);
114         require(tokenLock == false);
115         
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         
119         Transfer(msg.sender, _to, _value);
120         
121         return true;
122     }
123     
124     function approve(address _spender, uint _value) public returns (bool)
125     {
126         require(balances[msg.sender] >= _value);
127         approvals[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         
130         return true;
131     }
132     
133     function allowance(address _owner, address _spender) constant public returns (uint) 
134     {
135         return approvals[_owner][_spender];
136     }
137     
138     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
139     {
140         require(balances[_from] >= _value);
141         require(approvals[_from][msg.sender] >= _value);        
142         require(tokenLock == false);
143         
144         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to]  = balances[_to].add(_value);
147         
148         Transfer(_from, _to, _value);
149         
150         return true;
151     }
152 }