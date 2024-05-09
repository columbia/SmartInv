1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4     
5     address public owner;
6 
7     event OwnershipTransferred(address from, address to);
8 
9     function Ownable() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         require(_newOwner != 0x0);
20         OwnershipTransferred(owner, _newOwner);
21         owner = _newOwner;
22     }
23 
24 }
25 
26 library SafeMath {
27     
28     function mul(uint256 a, uint256 b) internal  returns (uint256) {
29         uint256 c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal returns (uint256) {
35         uint256 c = a / b;
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal returns (uint256) {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 contract ERC20 {
52     uint256 public totalSupply;
53     uint8 public decimals;
54     string public name;
55     string public symbol;
56     function balanceOf(address who) constant public returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     function allowance(address owner, address spender) constant public returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public  returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract SHNZ is ERC20, Ownable {
66     
67     using SafeMath for uint256;
68     
69     uint256 private tokensSold;
70     
71     mapping (address => uint256) balances;
72     mapping (address => mapping (address => uint256)) allowances;
73   
74     event TokensIssued(address from, address to, uint256 amount);
75 
76     function SHNZ() public {
77         totalSupply = 1000000000000000000;
78         decimals = 8;
79         name = "ShizzleNizzle";
80         symbol = "SHNZ";
81         balances[this] = totalSupply;
82     }
83 
84     function balanceOf(address _addr) public constant returns (uint256) {
85         return balances[_addr];
86     }
87 
88     function transfer(address _to, uint256 _amount) public returns (bool) {
89         require(balances[msg.sender] >= _amount);
90         balances[msg.sender] = balances[msg.sender].sub(_amount);
91         balances[_to] = balances[_to].add(_amount);
92         Transfer(msg.sender, _to, _amount);
93         return true;
94     }
95     
96     function approve(address _spender, uint256 _amount) public returns (bool) {
97         allowances[msg.sender][_spender] = _amount;
98         Approval(msg.sender, _spender, _amount);
99         return true;
100     }
101     
102     function allowance(address _owner, address _spender) public constant returns (uint256) {
103         return allowances[_owner][_spender];
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
107         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
108         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
109         balances[_from] = balances[_from].sub(_amount);
110         balances[_to] = balances[_to].add(_amount);
111         Transfer(_from, _to, _amount);
112         return true;
113     }
114     
115     function issueTokens(address _to, uint256 _amount) public onlyOwner {
116         require(_to != 0x0 && _amount > 0);
117         if (balances[this] <= _amount) {
118             balances[_to] = balances[_to].add(balances[this]);
119             Transfer(0x0, _to, balances[this]);
120             balances[this] = 0;
121         } else {
122             balances[this] = balances[this].sub(_amount);
123             balances[_to] = balances[_to].add(_amount);
124             Transfer(0x0, _to, _amount);
125         }
126     }
127 
128     function getTotalSupply() public constant returns (uint256) {
129         return totalSupply;
130     }
131 }
132 
133 contract TokenSale is Ownable {
134 
135     using SafeMath for uint256;
136 
137     uint256 public rate;
138     uint256 public ETHcap;
139     uint256 public totalRaised;
140     SHNZ public token;
141 
142 
143     function TokenSale() public {
144         token = new SHNZ();
145         ETHcap = 589811999999971700000000;
146         rate = 1695455501075;
147         owner = 0x7e826E85CbA4d3AAaa1B484f53BE01D10F527Fd6;
148     }
149 
150     function() public payable {
151         buyTokens(msg.sender);
152     }
153 
154     function buyTokens(address _beneficiary) public payable {
155         require(_beneficiary != 0x0 && totalRaised < ETHcap);
156         totalRaised = totalRaised.add(msg.value);
157         uint256 weiAmount = msg.value;
158         if (totalRaised > ETHcap) {
159             msg.sender.transfer(totalRaised.sub(ETHcap));
160             weiAmount = weiAmount.sub(totalRaised.sub(ETHcap));
161             totalRaised = totalRaised.sub(totalRaised.sub(ETHcap));
162         }
163         token.issueTokens(msg.sender, weiAmount.mul(rate).div(1000000000000000000));
164         forwardFunds(weiAmount);
165     }
166 
167     function forwardFunds(uint256 _amount) internal {
168         owner.transfer(_amount);
169     }
170     
171     function issueTokens(address _beneficiary, uint256 _amount) onlyOwner {
172         require(_beneficiary != 0x0 && _amount > 0);
173         token.issueTokens(_beneficiary, _amount.mul(100000000));
174         ETHcap = ETHcap.sub(_amount.mul(100000000000000000000000000).div(rate));
175     }
176 }