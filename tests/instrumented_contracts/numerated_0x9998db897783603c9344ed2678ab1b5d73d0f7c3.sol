1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender)
12         public view returns (uint256);
13 
14     function transferFrom(address from, address to, uint256 value)
15         public returns (bool);
16 
17     function approve(address spender, uint256 value) public returns (bool);
18     event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22     );
23 }
24 
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a / b;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     uint256 totalSupply_;
62 
63     function totalSupply() public view returns (uint256) {
64         return totalSupply_;
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         require(_value <= balances[msg.sender]);
70 
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         emit Transfer(msg.sender, _to, _value);
74         return true;
75     }
76   
77     function balanceOf(address _owner) public view returns (uint256) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86     mapping (address => mapping (address => uint256)) internal allowed;
87 
88     function transferFrom(
89         address _from,
90         address _to,
91         uint256 _value
92     )
93         public
94         returns (bool)
95     {
96         require(_to != address(0));
97         require(_value <= balances[_from]);
98         require(_value <= allowed[_from][msg.sender]);
99 
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107 
108     function approve(address _spender, uint256 _value) public returns (bool) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114 
115     function allowance(
116         address _owner,
117         address _spender
118     )
119     public
120     view
121     returns (uint256)
122     {
123         return allowed[_owner][_spender];
124     }
125 
126 
127     function increaseApproval(
128         address _spender,
129         uint _addedValue
130     )
131     public
132     returns (bool)
133     {
134         allowed[msg.sender][_spender] = (
135         allowed[msg.sender][_spender].add(_addedValue));
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140 
141     function decreaseApproval(
142         address _spender,
143         uint _subtractedValue
144     )
145         public
146         returns (bool)
147     {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         } else {
152             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153         }
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158 }
159 
160 
161 contract IGTToken is StandardToken {
162     string public constant name = "IGT Token";
163     string public constant symbol = "IGTT";
164     uint32 public constant decimals = 18;
165     uint256 public INITIAL_SUPPLY = 21000000 * 1 ether;
166     address public CrowdsaleAddress;
167     uint256 public soldTokens;
168     bool public lockTransfers = true;
169 
170     function getSoldTokens() public view returns (uint256) {
171         return soldTokens;
172     }
173 
174 
175   
176   
177     constructor(address _CrowdsaleAddress) public {
178     
179         CrowdsaleAddress = _CrowdsaleAddress;
180         totalSupply_ = INITIAL_SUPPLY;
181         balances[msg.sender] = INITIAL_SUPPLY;      
182     }
183   
184     modifier onlyOwner() {
185         require(msg.sender == CrowdsaleAddress);
186         _;
187     }
188 
189     function setSoldTokens(uint256 _value) public onlyOwner {
190         soldTokens = _value;
191     }
192 
193     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
194         require (balances[_from] >= _value);
195         balances[_from] = balances[_from].sub(_value);
196         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);
197         emit Transfer(_from, CrowdsaleAddress, _value);
198         return true;
199     }
200 
201 
202      // Override
203     function transfer(address _to, uint256 _value) public returns(bool){
204         if (msg.sender != CrowdsaleAddress){
205             require(!lockTransfers, "Transfers are prohibited");
206         }
207         return super.transfer(_to,_value);
208     }
209 
210      // Override
211     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
212         if (msg.sender != CrowdsaleAddress){
213             require(!lockTransfers, "Transfers are prohibited");
214         }
215         return super.transferFrom(_from,_to,_value);
216     }
217 
218     function lockTransfer(bool _lock) public onlyOwner {
219         lockTransfers = _lock;
220     }
221 
222     function() external payable {
223         // The token contract don`t receive ether
224         revert();
225     }  
226 }