1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 library SafeMaths {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      */
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a, "SafeMath: addition overflow");
13 
14         return c;
15     }
16 
17     /**
18      * @dev Returns the subtraction of two unsigned integers, reverting on
19      * overflow (when the result is negative).
20      */
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a, "SafeMath: subtraction overflow");
23         uint256 c = a - b;
24 
25         return c;
26     }
27 
28     /**
29      * @dev Returns the multiplication of two unsigned integers, reverting on
30      * overflow.
31      */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the integer division of two unsigned integers. Reverts on
45      * division by zero. The result is rounded towards zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b > 0, "SafeMath: division by zero");
49         uint256 c = a / b;
50 
51         return c;
52     }
53 
54 }
55 
56 contract Memefund {
57 
58     using SafeMaths for uint256;
59 
60     address public rebaseOracle;       // Used for authentication
61     address public owner;              // Used for authentication
62     address public newOwner;
63 
64     uint8 public decimals;
65     uint256 public totalSupply;
66     string public name;
67     string public symbol;
68 
69     uint256 private constant MAX_UINT256 = ~uint256(0);   // (2^256) - 1
70     uint256 private constant MAXSUPPLY = ~uint128(0);  // (2^128) - 1
71 
72     uint256 private totalAtoms;
73     uint256 private atomsPerMolecule;
74 
75     mapping (address => uint256) private atomBalances;
76     mapping (address => mapping (address => uint256)) private allowedMolecules;
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     event LogRebase(uint256 _totalSupply);
81     event LogNewRebaseOracle(address _rebaseOracle);
82     event OwnershipTransferred(address indexed _from, address indexed _to);
83 
84     constructor() public
85     {
86         decimals = 9;                               // decimals  
87         totalSupply = 100000000*10**9;                // initialSupply
88         name = "Memefund";                         // Set the name for display purposes
89         symbol = "MFUND";                            // Set the symbol for display purposes
90 
91         owner = msg.sender;
92         totalAtoms = MAX_UINT256 - (MAX_UINT256 % totalSupply);     // totalAtoms is a multiple of totalSupply so that atomsPerMolecule is an integer.
93         atomBalances[msg.sender] = totalAtoms;
94         atomsPerMolecule = totalAtoms.div(totalSupply);
95 
96         emit Transfer(address(0), msg.sender, totalSupply);
97     }
98 
99     /**
100      * @param newRebaseOracle The address of the new oracle for rebasement (used for authentication).
101      */
102     function setRebaseOracle(address newRebaseOracle) external {
103         require(msg.sender == owner, "Can only be executed by owner.");
104         rebaseOracle = newRebaseOracle;
105 
106         emit LogNewRebaseOracle(rebaseOracle);
107     }
108 
109     /**
110      * @dev Propose a new owner.
111      * @param _newOwner The address of the new owner.
112      */
113     function transferOwnership(address _newOwner) public
114     {
115         require(msg.sender == owner, "Can only be executed by owner.");
116         require(_newOwner != address(0), "0x00 address not allowed.");
117         newOwner = _newOwner;
118     }
119 
120     /**
121      * @dev Accept new owner.
122      */
123     function acceptOwnership() public
124     {
125         require(msg.sender == newOwner, "Sender not authorized.");
126         emit OwnershipTransferred(owner, newOwner);
127         owner = newOwner;
128         newOwner = address(0);
129     }
130 
131     /**
132      * @dev Notifies Benchmark contract about a new rebase cycle.
133      * @param supplyDelta The number of new molecule tokens to add into or remove from circulation.
134      * @param increaseSupply Whether to increase or decrease the total supply.
135      * @return The total number of molecules after the supply adjustment.
136      */
137     function rebase(uint256 supplyDelta, bool increaseSupply) external returns (uint256) {
138         require(msg.sender == rebaseOracle, "Can only be executed by rebaseOracle.");
139         
140         if (supplyDelta == 0) {
141             emit LogRebase(totalSupply);
142             return totalSupply;
143         }
144 
145         if (increaseSupply == true) {
146             totalSupply = totalSupply.add(supplyDelta);
147         } else {
148             totalSupply = totalSupply.sub(supplyDelta);
149         }
150 
151         if (totalSupply > MAXSUPPLY) {
152             totalSupply = MAXSUPPLY;
153         }
154 
155         atomsPerMolecule = totalAtoms.div(totalSupply);
156 
157         emit LogRebase(totalSupply);
158         return totalSupply;
159     }
160 
161     /**
162      * @param who The address to query.
163      * @return The balance of the specified address.
164      */
165     function balanceOf(address who) public view returns (uint256) {
166         return atomBalances[who].div(atomsPerMolecule);
167     }
168 
169     /**
170      * @dev Transfer tokens to a specified address.
171      * @param to The address to transfer to.
172      * @param value The amount to be transferred.
173      * @return True on success, false otherwise.
174      */
175     function transfer(address to, uint256 value) public returns (bool) {
176         require(to != address(0),"Invalid address.");
177         require(to != address(this),"Molecules contract can't receive MARK.");
178 
179         uint256 atomValue = value.mul(atomsPerMolecule);
180 
181         atomBalances[msg.sender] = atomBalances[msg.sender].sub(atomValue);
182         atomBalances[to] = atomBalances[to].add(atomValue);
183 
184         emit Transfer(msg.sender, to, value);
185         return true;
186     }
187 
188     /**
189      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
190      * @param owner_ The address which owns the funds.
191      * @param spender The address which will spend the funds.
192      * @return The number of tokens still available for the spender.
193      */
194     function allowance(address owner_, address spender) public view returns (uint256) {
195         return allowedMolecules[owner_][spender];
196     }
197 
198     /**
199      * @dev Transfer tokens from one address to another.
200      * @param from The address you want to send tokens from.
201      * @param to The address you want to transfer to.
202      * @param value The amount of tokens to be transferred.
203      */
204     function transferFrom(address from, address to, uint256 value) public returns (bool) {
205         require(to != address(0),"Invalid address.");
206         require(to != address(this),"Molecules contract can't receive MARK.");
207 
208         allowedMolecules[from][msg.sender] = allowedMolecules[from][msg.sender].sub(value);
209 
210         uint256 atomValue = value.mul(atomsPerMolecule);
211         atomBalances[from] = atomBalances[from].sub(atomValue);
212         atomBalances[to] = atomBalances[to].add(atomValue);
213         
214         emit Transfer(from, to, value);
215         return true;
216     }
217 
218     /**
219      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
220      * msg.sender. This method is included for ERC20 compatibility.
221      * IncreaseAllowance and decreaseAllowance should be used instead.
222      * @param spender The address which will spend the funds.
223      * @param value The amount of tokens to be spent.
224      */
225     function approve(address spender, uint256 value) public returns (bool) {
226         allowedMolecules[msg.sender][spender] = value;
227 
228         emit Approval(msg.sender, spender, value);
229         return true;
230     }
231 
232     /**
233      * @dev Increase the amount of tokens that an owner has allowed to a spender.
234      * This method should be used instead of approve() to avoid the double approval vulnerability.
235      * @param spender The address which will spend the funds.
236      * @param addedValue The amount of tokens to increase the allowance by.
237      */
238     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
239         allowedMolecules[msg.sender][spender] = allowedMolecules[msg.sender][spender].add(addedValue);
240 
241         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
242         return true;
243     }
244 
245     /**
246      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
247      * @param spender The address which will spend the funds.
248      * @param subtractedValue The amount of tokens to decrease the allowance by.
249      */
250     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
251         uint256 oldValue = allowedMolecules[msg.sender][spender];
252         if (subtractedValue >= oldValue) {
253             allowedMolecules[msg.sender][spender] = 0;
254         } else {
255             allowedMolecules[msg.sender][spender] = oldValue.sub(subtractedValue);
256         }
257         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
258         return true;
259     }
260 }