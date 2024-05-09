1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 /**
30 * @title Contract that will work with ERC223 tokens.
31 */
32 
33 contract ERC223ReceivingContract{
34     /**
35      * @dev Standard ERC223 function that will handle incoming token transfers.
36      *
37      * @param _from  Token sender address.
38      * @param _value Amount of tokens.
39      * @param _data  Transaction metadata.
40      */
41     function tokenFallback(address _from, uint _value, bytes _data) public;
42 }
43 
44 contract ERC20Basic {
45     uint public totalSupply;
46     function balanceOf(address who) public constant returns (uint);
47     function transfer(address to, uint value) public;
48     event Transfer(address indexed from, address indexed to, uint value);
49 }
50 
51 contract ERC20 is ERC20Basic {
52     function allowance(address owner, address spender) public constant returns (uint);
53     function transferFrom(address from, address to, uint value) public;
54     function approve(address spender, uint value) public;
55     event Approval(address indexed owner, address indexed spender, uint value);
56 }
57 
58 contract BasicToken is ERC20Basic {
59     using SafeMath for uint;
60 
61     mapping(address => uint) balances;
62 
63     modifier onlyPayloadSize(uint size) {
64         require(msg.data.length >= size + 4);
65         _;
66     }
67 
68     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public {
69         uint codeLength;
70         bytes memory empty;
71 
72         assembly {
73             codeLength := extcodesize(_to)
74         }
75 
76 
77         balances[msg.sender] = balances[msg.sender].sub(_value);
78         balances[_to] = balances[_to].add(_value);
79 
80         if(codeLength > 0) {
81             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
82             receiver.tokenFallback(msg.sender, _value, empty);
83         }
84 
85         emit Transfer(msg.sender, _to, _value);
86     }
87 
88     function balanceOf(address _owner) public constant returns (uint balance) {
89         return balances[_owner];
90     }
91 
92 }
93 
94 contract StandardToken is BasicToken, ERC20 {
95 
96     mapping (address => mapping (address => uint)) allowed;
97 
98     function transferFrom(address _from, address _to, uint _value) public {
99         uint256 _allowance = allowed[_from][msg.sender];
100         uint codeLength;
101         bytes memory empty;
102 
103         assembly {
104             codeLength := extcodesize(_to)
105         }
106 
107         balances[_to] = balances[_to].add(_value);
108         balances[_from] = balances[_from].sub(_value);
109         allowed[_from][msg.sender] = _allowance.sub(_value);
110 
111         if(codeLength>0) {
112             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
113             receiver.tokenFallback(msg.sender, _value, empty);
114         }
115 
116         emit Transfer(_from, _to, _value);
117     }
118 
119     function approve(address _spender, uint _value) public {
120         allowed[msg.sender][_spender] = _value;
121         emit Approval(msg.sender, _spender, _value);
122     }
123 
124     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
125         return allowed[_owner][_spender];
126     }
127 
128 }
129 
130 contract BurnableToken is StandardToken {
131 
132     function burn(uint _value) public {
133         require(_value > 0);
134         address burner = msg.sender;
135         balances[burner] = balances[burner].sub(_value);
136         totalSupply = totalSupply.sub(_value);
137         emit Burn(burner, _value);
138     }
139 
140     event Burn(address indexed burner, uint indexed value);
141 
142 }
143 
144 contract ETY is BurnableToken {
145 
146     string public name = "Etherty Token";
147     string public symbol = "ETY";
148     uint public decimals = 18;
149     uint constant TOKEN_LIMIT = 240 * 1e6 * 1e18;
150 
151     address public ico;
152 
153     bool public tokensAreFrozen = true;
154 
155     function ETY(address _ico) public {
156         ico = _ico;
157     }
158 
159     function mint(address _holder, uint _value) external {
160         require(msg.sender == ico);
161         require(_value != 0);
162         require(totalSupply + _value <= TOKEN_LIMIT);
163 
164         balances[_holder] += _value;
165         totalSupply += _value;
166         emit Transfer(0x0, _holder, _value);
167     }
168 
169     function burn(uint _value) public {
170         require(msg.sender == ico);
171         super.burn(_value);
172     }
173 
174     function unfreeze() external {
175         require(msg.sender == ico);
176         tokensAreFrozen = false;
177     }
178 
179     function transfer(address _to, uint _value) public {
180         require(!tokensAreFrozen);
181         super.transfer(_to, _value);
182     }
183 
184     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public {
185         require(!tokensAreFrozen);
186         super.transferFrom(_from, _to, _value);
187     }
188 
189     function approve(address _spender, uint _value) public {
190         require(!tokensAreFrozen);
191         super.approve(_spender, _value);
192     }
193 }