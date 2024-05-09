1 pragma solidity >=0.4.24;
2 
3 library SafeMath {
4     function add(
5         uint256 a,
6         uint256 b)
7         internal
8         pure
9         returns(uint256 c)
10     {
11         c = a + b;
12         require(c >= a);
13     }
14 
15     function sub(
16         uint256 a,
17         uint256 b)
18         internal
19         pure
20         returns(uint256 c)
21     {
22         require(b <= a);
23         c = a - b;
24     }
25 
26     function mul(
27         uint256 a,
28         uint256 b)
29         internal
30         pure
31         returns(uint256 c) {
32         c = a * b;
33         require(a == 0 || c / a == b);
34     }
35     
36      function div(
37         uint256 a,
38         uint256 b)
39         internal
40         pure
41         returns(uint256 c) {
42         require(b > 0);
43         c = a / b;
44     }
45 }
46 
47 interface IERC20 {
48     // ERC20 Optional Views
49     function name() external view returns (string memory);
50 
51     function symbol() external view returns (string memory);
52 
53     function decimals() external view returns (uint8);
54 
55     // Views
56     function totalSupply() external view returns (uint);
57 
58     function balanceOf(address owner) external view returns (uint);
59 
60     function allowance(address owner, address spender) external view returns (uint);
61 
62     // Mutative functions
63     function transfer(address to, uint value) external returns (bool);
64 
65     function approve(address spender, uint value) external returns (bool);
66 
67     function transferFrom(
68         address from,
69         address to,
70         uint value
71     ) external returns (bool);
72 
73     // Events
74     event Transfer(address indexed from, address indexed to, uint value);
75 
76     event Approval(address indexed owner, address indexed spender, uint value);
77 }
78 
79 
80 // https://docs.synthetix.io/contracts/source/contracts/owned
81 contract Owned {
82     address public owner;
83     address public nominatedOwner;
84 
85     constructor(address _owner) public {
86         require(_owner != address(0), "Owner address cannot be 0");
87         owner = _owner;
88         emit OwnerChanged(address(0), _owner);
89     }
90 
91     function nominateNewOwner(address _owner) external onlyOwner {
92         nominatedOwner = _owner;
93         emit OwnerNominated(_owner);
94     }
95 
96     function acceptOwnership() external {
97         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
98         emit OwnerChanged(owner, nominatedOwner);
99         owner = nominatedOwner;
100         nominatedOwner = address(0);
101     }
102 
103     modifier onlyOwner {
104         _onlyOwner();
105         _;
106     }
107 
108     function _onlyOwner() private view {
109         require(msg.sender == owner, "Only the contract owner may perform this action");
110     }
111 
112     event OwnerNominated(address newOwner);
113     event OwnerChanged(address oldOwner, address newOwner);
114 }
115 
116 contract Pausable is Owned {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122   modifier whenNotPaused() {
123     require(!paused);
124     _;
125   }
126 
127   modifier whenPaused() {
128     require(paused);
129     _;
130   }
131 
132   function pause() onlyOwner whenNotPaused public {
133     paused = true;
134     emit Pause();
135   }
136 
137   function unpause() onlyOwner whenPaused public {
138     paused = false;
139     emit Unpause();
140   }
141 }
142 
143 
144 
145 
146 pragma solidity >=0.4.24;
147 
148 contract IDODistribution is Owned, Pausable {
149     
150     using SafeMath for uint;
151 
152     /**
153      * @notice Authorised address able to call batchDeposit
154      */
155     address public authority;
156 
157     /**
158      * @notice Address of ERC20 token
159      */
160     address public erc20Address;
161 
162 
163     mapping(address => uint) balances;
164     mapping(address => uint) counts;
165 
166     uint public totalSupply;
167 
168     constructor(
169         address _owner,
170         address _authority
171     ) public Owned(_owner) {
172         authority = _authority;
173     }
174 
175     function balanceOf(address _address) public view returns (uint) {
176         return balances[_address];
177     }
178 
179     function depositNumberOf(address _address) public view returns (uint) {
180         return counts[_address];
181     }
182 
183     // ========== EXTERNAL SETTERS ==========
184 
185     function setTokenAddress(address _erc20Address) public onlyOwner {
186         erc20Address = _erc20Address;
187     }
188 
189     /**
190      * @notice Set the address of the contract authorised to call distributeReward()
191      * @param _authority Address of the authorised calling contract.
192      */
193     function setAuthority(address _authority) public onlyOwner {
194         authority = _authority;
195     }
196 
197     function batchDeposit(address[] destinations, uint[] amounts) public returns (bool) {
198         require(msg.sender == authority, "Caller is not authorized");
199         require(erc20Address != address(0), "erc20 token address is not set");
200         require(destinations.length == amounts.length, "length of inputs not match");
201 
202         // we don't need check amount[i] > 0 or destinations != 0x0 because they cannot claim anyway
203         uint amount = 0;
204         for (uint i = 0; i < amounts.length; i++) {
205             amount = amount.add(amounts[i]);
206             balances[destinations[i]] =  balances[destinations[i]].add(amounts[i]);
207             counts[destinations[i]] += 1;
208         }
209 
210         totalSupply = totalSupply.add(amount);
211 
212         emit TokenDeposit(amount);
213         return true;
214     }
215 
216     function claim() public whenNotPaused returns (bool) {
217         require(erc20Address != address(0), "erc20 token address is not set");
218         require(balances[msg.sender] > 0, "account balance is zero");
219 
220         uint _amount = balances[msg.sender];
221         require(
222             IERC20(erc20Address).balanceOf(address(this)) >= _amount,
223             "This contract does not have enough tokens to distribute"
224         );
225 
226         balances[msg.sender] = 0;
227         IERC20(erc20Address).transfer(msg.sender, _amount);
228         totalSupply = totalSupply.sub(_amount);
229 
230         emit UserClaimed(msg.sender, _amount);
231         return true;
232     }
233 
234     /* ========== Events ========== */
235     event TokenDeposit(uint _amount);
236     event UserClaimed(address _address, uint _amount);
237 }