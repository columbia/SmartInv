1 pragma solidity ^0.4.18;
2 
3 // File: contracts/mockContracts/TestToken.sol
4 
5 /* all this file is based on code from open zepplin
6  * https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token */
7 
8 
9 /**
10  * Standard ERC20 token
11  *
12  * Based on code by FirstBlood:
13  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
14  */
15 
16 
17 /**
18  * Math operations with safety checks
19  */
20 library SafeMath {
21     function mul(uint a, uint b) internal pure returns (uint) {
22         uint c = a * b;
23         require(a == 0 || c / a == b);
24         return c;
25     }
26 
27     function div(uint a, uint b) internal pure returns (uint) {
28         require(b > 0);
29         uint c = a / b;
30         require(a == b * c + a % b);
31         return c;
32     }
33 
34     function sub(uint a, uint b) internal pure returns (uint) {
35         require(b <= a);
36         return a - b;
37     }
38 
39     function add(uint a, uint b) internal pure returns (uint) {
40         uint c = a + b;
41         require(c >= a);
42         return c;
43     }
44 
45     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
46         return a >= b ? a : b;
47     }
48 
49     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
50         return a < b ? a : b;
51     }
52 
53     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a >= b ? a : b;
55     }
56 
57     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
58         return a < b ? a : b;
59     }
60 }
61 
62 
63 ////////////////////////////////////////////////////////////////////////////////
64 
65 /*
66  * ERC20Basic
67  * Simpler version of ERC20 interface
68  * see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20Basic {
71     uint public totalSupply;
72     function balanceOf(address who) public view returns (uint);
73     function transfer(address to, uint value) public returns (bool);
74     event Transfer(address indexed from, address indexed to, uint value);
75 }
76 
77 ////////////////////////////////////////////////////////////////////////////////
78 
79 /*
80  * ERC20 interface
81  * see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84     function allowance(address owner, address spender) public view returns (uint);
85     function transferFrom(address from, address to, uint value) public returns (bool);
86     function approve(address spender, uint value) public returns (bool);
87     event Approval(address indexed owner, address indexed spender, uint value);
88 }
89 
90 ////////////////////////////////////////////////////////////////////////////////
91 
92 /*
93  * Basic token
94  * Basic version of StandardToken, with no allowances
95  */
96 contract BasicToken is ERC20Basic {
97     using SafeMath for uint;
98 
99     mapping(address => uint) balances;
100 
101     /*
102      * Fix for the ERC20 short address attack
103      */
104     modifier onlyPayloadSize(uint size) {
105         if (msg.data.length < size + 4) {
106          revert();
107         }
108         _;
109     }
110 
111     function transfer(address _to, uint _value)  public onlyPayloadSize(2 * 32) returns (bool) {
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     function balanceOf(address _owner) public view returns (uint balance) {
119         return balances[_owner];
120     }
121 }
122 
123 
124 ////////////////////////////////////////////////////////////////////////////////
125 
126 /**
127  * Standard ERC20 token
128  *
129  * https://github.com/ethereum/EIPs/issues/20
130  * Based on code by FirstBlood:
131  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is BasicToken, ERC20 {
134 
135     mapping (address => mapping (address => uint)) allowed;
136 
137     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
138 
139         var _allowance = allowed[_from][msg.sender];
140 
141         // Check is not needed because sub(_allowance, _value) will already revert if this condition is not met
142         if (_value > _allowance) revert();
143 
144         balances[_to] = balances[_to].add(_value);
145         balances[_from] = balances[_from].sub(_value);
146         allowed[_from][msg.sender] = _allowance.sub(_value);
147         Transfer(_from, _to, _value);
148         return true;
149     }
150 
151     function approve(address _spender, uint _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function allowance(address _owner, address _spender) public view returns (uint remaining) {
158         return allowed[_owner][_spender];
159     }
160 }
161 
162 ////////////////////////////////////////////////////////////////////////////////
163 
164 /*
165  * SimpleToken
166  *
167  * Very simple ERC20 Token example, where all tokens are pre-assigned
168  * to the creator. Note they can later distribute these tokens
169  * as they wish using `transfer` and other `StandardToken` functions.
170  */
171 contract TestToken is StandardToken {
172 
173     string public name = "Test";
174     string public symbol = "TST";
175     uint public decimals = 18;
176     uint public INITIAL_SUPPLY = 10**(50+18);
177 
178     function TestToken(string _name, string _symbol, uint _decimals) public {
179         totalSupply = INITIAL_SUPPLY;
180         balances[msg.sender] = INITIAL_SUPPLY;
181         name = _name;
182         symbol = _symbol;
183         decimals = _decimals;
184     }
185 
186     event Burn(address indexed _burner, uint _value);
187 
188     function burn(uint _value) public returns (bool) {
189         balances[msg.sender] = balances[msg.sender].sub(_value);
190         totalSupply = totalSupply.sub(_value);
191         Burn(msg.sender, _value);
192         Transfer(msg.sender, address(0x0), _value);
193         return true;
194     }
195 
196     // save some gas by making only one contract call
197     function burnFrom(address _from, uint256 _value) public returns (bool) {
198         transferFrom( _from, msg.sender, _value );
199         return burn(_value);
200     }
201 }