1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.5.9;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath
19 {
20 
21     /**
22      * @dev Returns the multiplication of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `*` operator.
26      *
27      * Requirements:
28      *
29      * - Multiplication cannot overflow.
30      */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256)
32     	{
33 		uint256 c = a * b;
34 		assert(a == 0 || c / a == b);
35 
36 		return c;
37   	}
38 
39     /**
40      * @dev Returns the integer division of two unsigned integers. Reverts on
41      * division by zero. The result is rounded towards zero.
42      *
43      * Counterpart to Solidity's `/` operator. Note: this function uses a
44      * `revert` opcode (which leaves remaining gas untouched) while Solidity
45      * uses an invalid opcode to revert (consuming all remaining gas).
46      *
47      * Requirements:
48      *
49      * - The divisor cannot be zero.
50      */
51   	function div(uint256 a, uint256 b) internal pure returns (uint256)
52 	{
53 		uint256 c = a / b;
54 
55 		return c;
56   	}
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      *
66      * - Subtraction cannot overflow.
67      */
68   	function sub(uint256 a, uint256 b) internal pure returns (uint256)
69 	{
70 		assert(b <= a);
71 
72 		return a - b;
73   	}
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85   	function add(uint256 a, uint256 b) internal pure returns (uint256)
86 	{
87 		uint256 c = a + b;
88 		assert(c >= a);
89 
90 		return c;
91   	}
92 }
93 
94 /**
95  * @dev Contract module which provides a basic access control mechanism, where
96  * there is an account (an owner) that can be granted exclusive access to
97  * specific functions.
98  *
99  * By default, the owner account will be the one that deploys the contract. This
100  * can later be changed with {transferOwnership}.
101  *
102  * This module is used through inheritance. It will make available the modifier
103  * `onlyOwner`, which can be applied to your functions to restrict their use to
104  * the owner.
105  */
106 contract OwnerHelper
107 {
108   	address public owner;
109 
110   	event ChangeOwner(address indexed _from, address indexed _to);
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115   	modifier onlyOwner
116 	{
117 		require(msg.sender == owner);
118 		_;
119   	}
120   	
121   	constructor() public
122 	{
123 		owner = msg.sender;
124   	}
125 
126     /**
127      * @dev Transfers ownership of the contract to a new account (`newOwner`).
128      * Can only be called by the current owner.
129      */  	
130   	function transferOwnership(address _to) onlyOwner public
131   	{
132     	require(_to != owner);
133     	require(_to != address(0x0));
134 
135         address from = owner;
136       	owner = _to;
137   	    
138       	emit ChangeOwner(from, _to);
139   	}
140 }
141 
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP.
145  */
146 contract ERC20Interface
147 {
148     event Transfer( address indexed _from, address indexed _to, uint _value);
149     event Approval( address indexed _owner, address indexed _spender, uint _value);
150     
151     function totalSupply() view public returns (uint _supply);
152     function balanceOf( address _who ) public view returns (uint _value);
153     function transfer( address _to, uint _value) public returns (bool _success);
154     function approve( address _spender, uint _value ) public returns (bool _success);
155     function allowance( address _owner, address _spender ) public view returns (uint _allowance);
156     function transferFrom( address _from, address _to, uint _value) public returns (bool _success);
157 }
158 
159 // Top Module
160 contract CINDToken is ERC20Interface, OwnerHelper
161 {
162     using SafeMath for uint;
163     
164     string public name;
165     uint public decimals;
166     string public symbol;
167     
168     uint constant private E18 = 1000000000000000000;
169 
170     uint public totalTokenSupply;
171 
172     
173     mapping (address => uint) public balances;
174     mapping (address => mapping ( address => uint )) public approvals;
175     mapping (address => bool) private blackAddress; // unLock : false, Lock : true
176       
177     bool public tokenLock = false;
178     
179     constructor() public
180     {
181         name        = "CINDRUM";
182         decimals    = 18;
183         symbol      = "CIND";
184         
185         totalTokenSupply = 5000000000 * E18;
186         balances[owner] = totalTokenSupply;
187     }
188 
189     function totalSupply() view public returns (uint) 
190     {
191         return totalTokenSupply;
192     }
193     
194     function balanceOf(address _who) view public returns (uint) 
195     {
196         return balances[_who];
197     }
198     
199     function transfer(address _to, uint _value) public returns (bool) 
200     {
201         require(isTransferable() == true);
202         require(balances[msg.sender] >= _value);
203         
204         balances[msg.sender] = balances[msg.sender].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         
207         emit Transfer(msg.sender, _to, _value);
208         
209         return true;
210     }
211     
212     function approve(address _spender, uint _value) public returns (bool)
213     {
214         require(isTransferable() == true);
215         require(balances[msg.sender] >= _value);
216         
217         approvals[msg.sender][_spender] = _value;
218         
219         emit Approval(msg.sender, _spender, _value);
220         
221         return true; 
222     }
223     
224     function allowance(address _owner, address _spender) view public returns (uint) 
225     {
226         return approvals[_owner][_spender];
227     }
228 
229     function transferFrom(address _from, address _to, uint _value) public returns (bool) 
230     {
231         require(isTransferable() == true);
232         require(balances[_from] >= _value);
233         require(approvals[_from][msg.sender] >= _value);
234         
235         approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
236         balances[_from] = balances[_from].sub(_value);
237         balances[_to]  = balances[_to].add(_value);
238         
239         emit Transfer(_from, _to, _value);
240         
241         return true;
242     }
243 
244     function isTransferable() private view returns (bool)
245     {
246         if(tokenLock == false)
247         {
248             if (blackAddress[msg.sender]) // true is Locked
249             {
250                 return false;
251             } else {
252                 return true;
253             }
254         }
255         return false;
256     }
257     
258     function setTokenUnlock() onlyOwner public
259     {
260         require(tokenLock == true);        
261         tokenLock = false;
262     }
263     
264     function setTokenLock() onlyOwner public
265     {
266         require(tokenLock == false);
267         tokenLock = true;
268     }
269 
270     function lock(address who) onlyOwner public {
271         
272         blackAddress[who] = true;
273     }
274     
275     function unlock(address who) onlyOwner public {
276         
277         blackAddress[who] = false;
278     }
279     
280     function isLocked(address who) public view returns(bool) {
281         
282         return blackAddress[who];
283     }
284 }