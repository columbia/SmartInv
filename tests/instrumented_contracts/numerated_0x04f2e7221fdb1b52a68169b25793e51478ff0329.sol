1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8   uint public totalSupply;
9 
10   function balanceOf(address _owner) constant public returns (uint balance);
11   function transfer(address _to, uint _value) public returns (bool success);
12   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
13   function approve(address _spender, uint _value) public returns (bool success);
14   function allowance(address _owner, address _spender) constant public returns (uint remaining);
15 
16   event Transfer(address indexed _from, address indexed _to, uint value);
17   event Approval(address indexed _owner, address indexed _spender, uint value);
18 }
19 
20 library SafeMath {
21    function mul(uint a, uint b) internal pure returns (uint) {
22      if (a == 0) {
23         return 0;
24       }
25 
26       uint c = a * b;
27       assert(c / a == b);
28       return c;
29    }
30 
31    function sub(uint a, uint b) internal pure returns (uint) {
32       assert(b <= a);
33       return a - b;
34    }
35 
36    function add(uint a, uint b) internal pure returns (uint) {
37       uint c = a + b;
38       assert(c >= a);
39       return c;
40    }
41 
42   function div(uint a, uint b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 }
49 
50 contract StandardToken is ERC20 {
51     using SafeMath for uint;
52 
53     mapping (address => uint) balances;
54     mapping (address => mapping (address => uint)) allowed;
55 
56     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool) {
57         if (balances[msg.sender] >= _value
58             && _value > 0
59             && _to != msg.sender
60             && _to != address(0)
61           ) {
62             balances[msg.sender] = balances[msg.sender].sub(_value);
63             balances[_to] = balances[_to].add(_value);
64 
65             Transfer(msg.sender, _to, _value);
66             return true;
67         }
68 
69         return false;
70     }
71 
72     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
73         if (balances[_from] >= _value
74             && allowed[_from][msg.sender] >= _value
75             && _value > 0
76             && _from != _to
77           ) {
78             balances[_to]   = balances[_to].add(_value);
79             balances[_from] = balances[_from].sub(_value);
80             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81             Transfer(_from, _to, _value);
82             return true;
83         }
84 
85         return false;
86     }
87 
88     function balanceOf(address _owner) constant public returns (uint) {
89         return balances[_owner];
90     }
91 
92     function allowance(address _owner, address _spender) constant public returns (uint) {
93         return allowed[_owner][_spender];
94     }
95 
96     function approve(address _spender, uint _value) public returns (bool) {
97         require(_spender != address(0));
98         // needs to be called twice -> first set to 0, then increase to another amount
99         // this is to avoid race conditions
100         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
101 
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
108         // useless operation
109         require(_spender != address(0));
110 
111         // perform operation
112         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114         return true;
115     }
116 
117     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
118         // useless operation
119         require(_spender != address(0));
120 
121         uint oldValue = allowed[msg.sender][_spender];
122         if (_subtractedValue > oldValue) {
123             allowed[msg.sender][_spender] = 0;
124         } else {
125             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
126         }
127 
128         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129         return true;
130     }
131 
132     modifier onlyPayloadSize(uint _size) {
133         require(msg.data.length >= _size + 4);
134         _;
135     }
136 }
137 
138 contract Cappasity is StandardToken {
139 
140     // Constants
141     // =========
142     string public constant name = "Cappasity";
143     string public constant symbol = "CAPP";
144     uint8 public constant decimals = 2;
145     uint public constant TOKEN_LIMIT = 10 * 1e9 * 1e2; // 10 billion tokens, 2 decimals
146 
147     // State variables
148     // ===============
149     address public manager;
150 
151     // Block token transfers until ICO is finished.
152     bool public tokensAreFrozen = true;
153 
154     // Allow/Disallow minting
155     bool public mintingIsAllowed = true;
156 
157     // events for minting
158     event MintingAllowed();
159     event MintingDisabled();
160 
161     // Freeze/Unfreeze assets
162     event TokensFrozen();
163     event TokensUnfrozen();
164 
165     // Constructor
166     // ===========
167     function Cappasity(address _manager) public {
168         manager = _manager;
169     }
170 
171     // Fallback function
172     // Do not allow to send money directly to this contract
173     function() payable public {
174         revert();
175     }
176 
177     // ERC20 functions
178     // =========================
179     function transfer(address _to, uint _value) public returns (bool) {
180         require(!tokensAreFrozen);
181         return super.transfer(_to, _value);
182     }
183 
184     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
185         require(!tokensAreFrozen);
186         return super.transferFrom(_from, _to, _value);
187     }
188 
189     function approve(address _spender, uint _value) public returns (bool) {
190         require(!tokensAreFrozen);
191         return super.approve(_spender, _value);
192     }
193 
194     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195         require(!tokensAreFrozen);
196         return super.increaseApproval(_spender, _addedValue);
197     }
198 
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200         require(!tokensAreFrozen);
201         return super.decreaseApproval(_spender, _subtractedValue);
202     }
203 
204     // PRIVILEGED FUNCTIONS
205     // ====================
206     modifier onlyByManager() {
207         require(msg.sender == manager);
208         _;
209     }
210 
211     // Mint some tokens and assign them to an address
212     function mint(address _beneficiary, uint _value) external onlyByManager {
213         require(_value != 0);
214         require(totalSupply.add(_value) <= TOKEN_LIMIT);
215         require(mintingIsAllowed == true);
216 
217         balances[_beneficiary] = balances[_beneficiary].add(_value);
218         totalSupply = totalSupply.add(_value);
219     }
220 
221     // Disable minting. Can be enabled later, but TokenAllocation.sol only does that once.
222     function endMinting() external onlyByManager {
223         require(mintingIsAllowed == true);
224         mintingIsAllowed = false;
225         MintingDisabled();
226     }
227 
228     // Enable minting. See TokenAllocation.sol
229     function startMinting() external onlyByManager {
230         require(mintingIsAllowed == false);
231         mintingIsAllowed = true;
232         MintingAllowed();
233     }
234 
235     // Disable token transfer
236     function freeze() external onlyByManager {
237         require(tokensAreFrozen == false);
238         tokensAreFrozen = true;
239         TokensFrozen();
240     }
241 
242     // Allow token transfer
243     function unfreeze() external onlyByManager {
244         require(tokensAreFrozen == true);
245         tokensAreFrozen = false;
246         TokensUnfrozen();
247     }
248 }