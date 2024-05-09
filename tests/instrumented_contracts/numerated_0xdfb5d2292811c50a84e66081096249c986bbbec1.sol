1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         require(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a);
26         return c;
27     }
28 }
29 
30 contract ERC20Basic {
31     uint256 public totalSupply;
32     string public name;
33     string public symbol;
34     uint32 public decimals;
35     function balanceOf(address who) public view returns (uint256);
36     function transfer(address to, uint256 value) public returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41     function allowance(address owner, address spender) public view returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract BasicToken is ERC20Basic {
48     using SafeMath for uint256;
49 
50     mapping(address => uint256) balances;
51 
52 
53 
54     function balanceOf(address _owner) public view returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58 
59 
60 }
61 
62 contract StandardToken is ERC20, BasicToken {
63 
64     mapping (address => mapping (address => uint256)) internal allowed;
65 
66     function approve(address _spender, uint256 _value) public returns (bool) {
67         allowed[msg.sender][_spender] = _value;
68         emit Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) public view returns (uint256) {
73         return allowed[_owner][_spender];
74     }
75 
76     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
77         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
78         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
79         return true;
80     }
81 
82     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
83         uint oldValue = allowed[msg.sender][_spender];
84         if (_subtractedValue > oldValue) {
85             allowed[msg.sender][_spender] = 0;
86         } else {
87             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
88         }
89         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
90         return true;
91     }
92 
93 }
94 
95 contract Ownable {
96     address public owner;
97 
98     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100     function Ownable() public {
101         owner = msg.sender;
102     }
103 
104     modifier onlyOwner() {
105         require(msg.sender == owner);
106         _;
107     }
108 
109     function transferOwnership(address newOwner) public onlyOwner {
110         require( newOwner != address(0) );
111         emit OwnershipTransferred(owner, newOwner);
112         owner = newOwner;
113     }
114 
115 }
116 
117 contract BGXToken is Ownable, StandardToken{
118 
119     address public crowdsaleAddress;
120     bool public initialized = false;
121     uint256 public totalSupplyTmp = 0;
122 
123     uint256 public teamDate;
124     address public teamAddress;
125 
126     modifier onlyCrowdsale {
127         require(
128             msg.sender == crowdsaleAddress
129         );
130         _;
131     }
132 
133     // fix for short address attack
134     modifier onlyPayloadSize(uint size) {
135         require(msg.data.length == size + 4);
136         _;
137     }
138 
139     function BGXToken() public
140     {
141         name                    = "BGX Token";
142         symbol                  = "BGX";
143         decimals                = 18;
144         totalSupply             = 1000000000 ether;
145         balances[address(this)] = totalSupply;
146     }
147 
148 
149     function distribute( address _to, uint256 _value ) public onlyCrowdsale returns( bool )
150     {
151         require(_to != address(0));
152         require(_value <= balances[address(this)]);
153 
154         balances[address(this)] = balances[address(this)].sub(_value);
155         totalSupplyTmp = totalSupplyTmp.add( _value );
156 
157         balances[_to] = balances[_to].add(_value);
158         emit Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     function finally( address _teamAddress ) public onlyCrowdsale returns( bool )
163     {
164         balances[address(this)] = 0;
165         teamAddress = _teamAddress;
166         teamDate = now + 1 years;
167         totalSupply = totalSupplyTmp;
168 
169         return true;
170     }
171 
172     function setCrowdsaleInterface( address _addr) public onlyOwner returns( bool )
173     {
174         require( !initialized );
175 
176         crowdsaleAddress = _addr;
177         initialized = true;
178         return true;
179     }
180 
181     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32)  returns (bool) {
182 
183         if( msg.sender == teamAddress ) require( now >= teamDate );
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191         emit Transfer(_from, _to, _value);
192         return true;
193 
194     }
195 
196     function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
197 
198         if( msg.sender == teamAddress ) require( now >= teamDate );
199 
200         require(_to != address(0));
201         require(_value <= balances[msg.sender]);
202 
203         balances[msg.sender] = balances[msg.sender].sub(_value);
204         balances[_to] = balances[_to].add(_value);
205         emit Transfer(msg.sender, _to, _value);
206         return true;
207 
208     }
209 }