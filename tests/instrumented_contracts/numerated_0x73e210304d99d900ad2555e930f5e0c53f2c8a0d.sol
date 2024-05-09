1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title ERC20Interface
6  * @dev ERC20 interface
7  */
8 contract ERC20Interface {
9     function totalSupply() public constant returns (uint256) {}
10     function balanceOf(address _owner) public constant returns (uint256 balance) {}
11     function transfer(address _to, uint256 _value) public returns (bool success) {}
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
13     function approve(address _spender, uint256 _value) public returns (bool success) {}
14     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 /**
20  * @title StandardToken
21  * @dev ERC20 implementation
22  */
23 contract StandardToken is ERC20Interface {
24 
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     uint256 public totalSupply;
29 
30     function balanceOf(address _owner) public constant returns (uint256 balance) {
31         return balances[_owner];
32     }
33 
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balances[_to] + _value >= balances[_to]);
37         require(_to != 0x0);
38         if (balances[msg.sender] >= _value && _value > 0) {
39             balances[msg.sender] -= _value;
40             balances[_to] += _value;
41             emit Transfer(msg.sender, _to, _value);
42             return true;
43         } else { return false; }
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(balances[_to] + _value >= balances[_to]);
48         require(_to != 0x0);
49         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
50             balances[_to] += _value;
51             balances[_from] -= _value;
52             allowed[_from][msg.sender] -= _value;
53             emit Transfer(_from, _to, _value);
54             return true;
55         } else { return false; }
56     }
57 
58     
59     function approve(address _spender, uint256 _value) public returns (bool success) {
60         allowed[msg.sender][_spender] = _value;
61         emit Approval(msg.sender, _spender, _value);
62         return true;
63     }
64 
65     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
66       return allowed[_owner][_spender];
67     }
68 
69     
70 }
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 contract SafeMath {
77     function mul(uint a, uint b) internal pure returns (uint) {
78         uint c = a * b;
79         assert(a == 0 || c / a == b);
80         return c;
81     }
82 
83     function div(uint a, uint b) internal pure returns (uint) {
84         assert(b > 0);
85         uint c = a / b;
86         assert(a == b * c + a % b);
87         return c;
88     }
89 
90     function sub(uint a, uint b) internal pure returns (uint) {
91         assert(b <= a);
92         return a - b;
93     }
94 
95     function add(uint a, uint b) internal pure returns (uint) {
96         uint c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 
101     function pow(uint a, uint b) internal pure returns (uint) {
102         uint c = a ** b;
103         assert(c >= a);
104         return c;
105     }
106 }
107 
108 /**
109  * @title Ownable
110  * @dev The Ownable contract provides basic authorization control
111  */
112 contract Ownable {
113   address public owner;
114 
115   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
116 
117   constructor() public {
118     owner = msg.sender;
119   }
120 
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   function transferOwnership(address newOwner) public onlyOwner {
127     require(newOwner != address(0));
128     emit OwnershipTransferred(owner, newOwner);
129     owner = newOwner;
130   }
131 
132 }
133 
134 /**
135  * @title BaseToken
136  * @dev BaseToken Token Smart Contract
137  */
138 contract BaseToken is StandardToken, SafeMath, Ownable {
139 
140     function withDecimals(uint number, uint decimals)
141         internal
142         pure
143         returns (uint)
144     {
145         return mul(number, pow(10, decimals));
146     }
147 
148 }
149 
150 /**
151  * @title ApproveAndCallFallBack
152  * @dev Contract function to receive approval and execute function in one call, borrowed from MiniMeToken
153  */
154 contract ApproveAndCallFallBack {
155     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
156 }
157 
158 /**
159  * @title Dainet
160  * @dev Dainet Token Smart Contract
161  */
162 contract Dainet is BaseToken {
163 
164     string public name;
165     uint8 public decimals;
166     string public symbol;
167     string public version = '1.5';
168     uint256 public unitsPerEth;
169     uint256 public maxDainSell;
170     uint256 public totalEthPos;
171     uint256 public minimalEthPos;
172     uint256 public minEthAmount;
173 
174     constructor() public {
175         name = "Dainet";
176         symbol = "DAIN";
177         decimals = 18;   
178 
179         totalSupply = withDecimals(1300000000, decimals); 
180 
181         maxDainSell = withDecimals(845000000, decimals); 
182         unitsPerEth = 2000;
183         minEthAmount = withDecimals(5, (18-2)); 
184 
185         balances[msg.sender] = totalSupply;
186         emit Transfer(address(0), msg.sender, totalSupply);
187     }
188 
189     function() public payable{
190         uint256 amount = mul(msg.value, unitsPerEth);
191         require(balances[owner] >= amount);
192         require(balances[owner] >= maxDainSell);
193         require(msg.value >= minEthAmount);
194 
195         balances[owner] = sub(balances[owner], amount);
196         maxDainSell = sub(maxDainSell, amount);
197         balances[msg.sender] = add(balances[msg.sender], amount);
198         emit Transfer(owner, msg.sender, amount);
199         totalEthPos = add(totalEthPos, msg.value);
200 
201         owner.transfer(msg.value);
202     }
203 
204     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
205         allowed[msg.sender][spender] = tokens;
206         emit Approval(msg.sender, spender, tokens);
207         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
208         return true;
209     }
210 
211     function changeUnitsPerEth(uint256 newValue) public onlyOwner {
212         unitsPerEth = newValue;
213     }
214 
215     // ------------------------------------------------------------------------
216     // Owner can transfer out any accidentally sent ERC20 tokens
217     // ------------------------------------------------------------------------
218     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
219         return ERC20Interface(tokenAddress).transfer(owner, tokens);
220     }
221 }