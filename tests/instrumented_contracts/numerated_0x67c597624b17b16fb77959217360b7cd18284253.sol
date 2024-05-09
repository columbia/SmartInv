1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.5.17;
4 
5 library SafeMath {
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
56 /******************************************/
57 /*       Benchmark starts here          */
58 /******************************************/
59 
60 contract Benchmark {
61 
62     using SafeMath for uint256;
63 
64     address public rebaseOracle;       // Used for authentication
65     address public owner;              // Used for authentication
66     address public newOwner;
67 
68     uint8 public decimals;
69     uint256 public totalSupply;
70     string public name;
71     string public symbol;
72 
73     uint256 private constant MAX_UINT256 = ~uint256(0);   // (2^256) - 1
74     uint256 private constant MAXSUPPLY = ~uint128(0);  // (2^128) - 1
75 
76     uint256 private totalAtoms;
77     uint256 private atomsPerMolecule;
78 
79     mapping (address => uint256) private atomBalances;
80     mapping (address => mapping (address => uint256)) private allowedMolecules;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     event LogRebase(uint256 _totalSupply);
85     event LogNewRebaseOracle(address _rebaseOracle);
86     event OwnershipTransferred(address indexed _from, address indexed _to);
87 
88     constructor(address allocationsContract) public
89     {
90         decimals = 9;                               // decimals  
91         totalSupply = 75000000*10**9;                // initialSupply
92         name = "Benchmark";                         // Set the name for display purposes
93         symbol = "MARK";                            // Set the symbol for display purposes
94 
95         owner = msg.sender;
96         totalAtoms = MAX_UINT256 - (MAX_UINT256 % totalSupply);     // totalAtoms is a multiple of totalSupply so that atomsPerMolecule is an integer.
97         atomBalances[allocationsContract] = totalAtoms;
98         atomsPerMolecule = totalAtoms.div(totalSupply);
99 
100         emit Transfer(address(0), allocationsContract, totalSupply);
101     }
102 
103     /**
104      * @param newRebaseOracle The address of the new oracle for rebasement (used for authentication).
105      */
106     function setRebaseOracle(address newRebaseOracle) external {
107         require(msg.sender == owner, "Can only be executed by owner.");
108         rebaseOracle = newRebaseOracle;
109 
110         emit LogNewRebaseOracle(rebaseOracle);
111     }
112 
113     /**
114      * @dev Propose a new owner.
115      * @param _newOwner The address of the new owner.
116      */
117     function transferOwnership(address _newOwner) public
118     {
119         require(msg.sender == owner, "Can only be executed by owner.");
120         require(_newOwner != address(0), "0x00 address not allowed.");
121         newOwner = _newOwner;
122     }
123 
124     /**
125      * @dev Accept new owner.
126      */
127     function acceptOwnership() public
128     {
129         require(msg.sender == newOwner, "Sender not authorized.");
130         emit OwnershipTransferred(owner, newOwner);
131         owner = newOwner;
132         newOwner = address(0);
133     }
134 
135     /**
136      * @dev Notifies Benchmark contract about a new rebase cycle.
137      * @param supplyDelta The number of new molecule tokens to add into or remove from circulation.
138      * @param increaseSupply Whether to increase or decrease the total supply.
139      * @return The total number of molecules after the supply adjustment.
140      */
141     function rebase(uint256 supplyDelta, bool increaseSupply) external returns (uint256) {
142         require(msg.sender == rebaseOracle, "Can only be executed by rebaseOracle.");
143         
144         if (supplyDelta == 0) {
145             emit LogRebase(totalSupply);
146             return totalSupply;
147         }
148 
149         if (increaseSupply == true) {
150             totalSupply = totalSupply.add(supplyDelta);
151         } else {
152             totalSupply = totalSupply.sub(supplyDelta);
153         }
154 
155         if (totalSupply > MAXSUPPLY) {
156             totalSupply = MAXSUPPLY;
157         }
158 
159         atomsPerMolecule = totalAtoms.div(totalSupply);
160 
161         emit LogRebase(totalSupply);
162         return totalSupply;
163     }
164 
165     /**
166      * @param who The address to query.
167      * @return The balance of the specified address.
168      */
169     function balanceOf(address who) public view returns (uint256) {
170         return atomBalances[who].div(atomsPerMolecule);
171     }
172 
173     /**
174      * @dev Transfer tokens to a specified address.
175      * @param to The address to transfer to.
176      * @param value The amount to be transferred.
177      * @return True on success, false otherwise.
178      */
179     function transfer(address to, uint256 value) public returns (bool) {
180         require(to != address(0),"Invalid address.");
181         require(to != address(this),"Molecules contract can't receive MARK.");
182 
183         uint256 atomValue = value.mul(atomsPerMolecule);
184 
185         atomBalances[msg.sender] = atomBalances[msg.sender].sub(atomValue);
186         atomBalances[to] = atomBalances[to].add(atomValue);
187 
188         emit Transfer(msg.sender, to, value);
189         return true;
190     }
191 
192     /**
193      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
194      * @param owner_ The address which owns the funds.
195      * @param spender The address which will spend the funds.
196      * @return The number of tokens still available for the spender.
197      */
198     function allowance(address owner_, address spender) public view returns (uint256) {
199         return allowedMolecules[owner_][spender];
200     }
201 
202     /**
203      * @dev Transfer tokens from one address to another.
204      * @param from The address you want to send tokens from.
205      * @param to The address you want to transfer to.
206      * @param value The amount of tokens to be transferred.
207      */
208     function transferFrom(address from, address to, uint256 value) public returns (bool) {
209         require(to != address(0),"Invalid address.");
210         require(to != address(this),"Molecules contract can't receive MARK.");
211 
212         allowedMolecules[from][msg.sender] = allowedMolecules[from][msg.sender].sub(value);
213 
214         uint256 atomValue = value.mul(atomsPerMolecule);
215         atomBalances[from] = atomBalances[from].sub(atomValue);
216         atomBalances[to] = atomBalances[to].add(atomValue);
217         
218         emit Transfer(from, to, value);
219         return true;
220     }
221 
222     /**
223      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
224      * msg.sender. This method is included for ERC20 compatibility.
225      * IncreaseAllowance and decreaseAllowance should be used instead.
226      * @param spender The address which will spend the funds.
227      * @param value The amount of tokens to be spent.
228      */
229     function approve(address spender, uint256 value) public returns (bool) {
230         allowedMolecules[msg.sender][spender] = value;
231 
232         emit Approval(msg.sender, spender, value);
233         return true;
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner has allowed to a spender.
238      * This method should be used instead of approve() to avoid the double approval vulnerability.
239      * @param spender The address which will spend the funds.
240      * @param addedValue The amount of tokens to increase the allowance by.
241      */
242     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
243         allowedMolecules[msg.sender][spender] = allowedMolecules[msg.sender][spender].add(addedValue);
244 
245         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
246         return true;
247     }
248 
249     /**
250      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
251      * @param spender The address which will spend the funds.
252      * @param subtractedValue The amount of tokens to decrease the allowance by.
253      */
254     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
255         uint256 oldValue = allowedMolecules[msg.sender][spender];
256         if (subtractedValue >= oldValue) {
257             allowedMolecules[msg.sender][spender] = 0;
258         } else {
259             allowedMolecules[msg.sender][spender] = oldValue.sub(subtractedValue);
260         }
261         emit Approval(msg.sender, spender, allowedMolecules[msg.sender][spender]);
262         return true;
263     }
264 }