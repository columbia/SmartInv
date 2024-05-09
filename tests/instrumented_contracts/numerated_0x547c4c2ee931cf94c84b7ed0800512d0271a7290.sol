1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-23
3 */
4 
5 pragma solidity 0.4.18;
6 
7 // File: contracts/util/SafeMath.sol
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 // File: contracts/token/ERC20.sol
56 
57 /**
58  *   @title ERC20
59  *   @dev Standart ERC20 token interface
60  */
61 contract ERC20 {
62     mapping(address => uint256) internal balances;
63     mapping (address => mapping (address => uint256)) internal allowed;
64     function balanceOf(address _who) public view returns (uint256);
65     function transfer(address _to, uint256 _value) public returns (bool);
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
67     function approve(address _spender, uint256 _value) public returns (bool);
68     function allowance(address _owner, address _spender) public view returns (uint256);
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 }
72 
73 // File: contracts/token/COINPIGGY.sol
74 
75 contract COINPIGGY is ERC20 {
76     using SafeMath for uint256;
77     
78     address public admin;
79     string public constant name = "COINPIGGY";
80     string public constant symbol = "CPGY";
81     uint8 public constant decimals = 18;
82     uint256 public totalSupply;
83 
84 
85     mapping(address => bool) internal blacklist;
86     event Burn(address indexed from, uint256 value);
87 
88     // Disables/enables token transfers, for migration to platform mainnet
89     // true = Can not transfers
90     // false = Can transfer
91     bool public checkTokenLock = false;
92 
93     // Allows execution by the ico only
94     modifier adminOnly {
95         require(msg.sender == admin);
96         _;
97     }
98 
99     modifier transferable {
100         require(msg.sender == admin || !checkTokenLock);
101         _;
102     }
103 
104     function COINPIGGY(uint256 _initialSupply) public {
105         balances[msg.sender] = _initialSupply.mul(1e18);
106         totalSupply = _initialSupply.mul(1e18);
107         admin = msg.sender;
108     }
109 
110     
111     // _block
112     // True : Can not Transfer
113     // false : Can Transfer
114     function blockTransfer(bool _block) external adminOnly {
115         checkTokenLock = _block;
116     }
117 
118 
119     // _inBlackList
120     // True : Can not Transfer
121     // false : Can Transfer
122     function updateBlackList(address _addr, bool _inBlackList) external adminOnly{
123         blacklist[_addr] = _inBlackList;
124     }
125     
126 
127     function isInBlackList(address _addr) public view returns(bool){
128         return blacklist[_addr];
129     }
130     
131     function balanceOf(address _who) public view returns(uint256) {
132         return balances[_who];
133     }
134 
135     function transfer(address _to, uint256 _amount) public transferable returns(bool) {
136         require(_to != address(0));
137         require(_to != address(this));
138         require(_amount > 0);
139         require(_amount <= balances[msg.sender]);
140         require(blacklist[msg.sender] == false);
141         require(blacklist[_to] == false);
142 
143         balances[msg.sender] = balances[msg.sender].sub(_amount);
144         balances[_to] = balances[_to].add(_amount);
145         Transfer(msg.sender, _to, _amount);
146         return true;
147     }
148 
149     function transferFrom(address _from, address _to, uint256 _amount) public transferable returns(bool) {
150         require(_to != address(0));
151         require(_to != address(this));
152         require(_amount <= balances[_from]);
153         require(_amount <= allowed[_from][msg.sender]);
154         require(blacklist[_from] == false);
155         require(blacklist[_to] == false);
156 
157         balances[_from] = balances[_from].sub(_amount);
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
159         balances[_to] = balances[_to].add(_amount);
160         Transfer(_from, _to, _amount);
161         return true;
162     }
163 
164     function approve(address _spender, uint256 _amount) public returns(bool) {
165         // reduce spender's allowance to 0 then set desired value after to avoid race condition
166         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
167         allowed[msg.sender][_spender] = _amount;
168         Approval(msg.sender, _spender, _amount);
169         return true;
170     }
171 
172     function allowance(address _owner, address _spender) public view returns(uint256) {
173         return allowed[_owner][_spender];
174     }
175     
176     function burn(uint256 _amount) public transferable returns (bool) {
177         require(_amount > 0);
178         require(balances[msg.sender] >= _amount);
179         
180         totalSupply = totalSupply.sub(_amount);
181         balances[msg.sender] = balances[msg.sender].sub(_amount);
182         Burn(msg.sender, _amount);
183         return true;
184     }
185 
186     function burnFrom(address _from, uint256 _amount)public transferable returns (bool) {
187         require(_amount > 0);
188         require(balances[_from] >= _amount);
189         require(allowed[_from][msg.sender]  >= _amount);
190         
191         totalSupply = totalSupply.sub(_amount);
192         balances[_from] = balances[_from].sub(_amount);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194         Burn(_from, _amount);
195         return true;
196     }
197 
198 }