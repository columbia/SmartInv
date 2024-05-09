1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4     address public owner;
5 
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10     /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     /**
19    * @dev Throws if called by any account other than the owner.
20    */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(0));
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34     }
35 
36 }
37 
38 contract NoboToken is Ownable {
39 
40     using SafeMath for uint256;
41 
42     string public name;
43     string public symbol;
44     uint8 public decimals;
45     uint256 totalSupply_;
46 
47     constructor() public {
48         name = "Nobotoken";
49         symbol = "NBX";
50         decimals = 18;
51         totalSupply_ = 0;
52     }
53 
54     // -----------------------------------------------------------------------
55     // ------------------------- GENERAL ERC20 -------------------------------
56     // -----------------------------------------------------------------------
57     event Transfer(
58         address indexed _from,
59         address indexed _to,
60         uint256 _value
61     );
62     event Approval(
63         address indexed _owner,
64         address indexed _spender,
65         uint256 _value
66     );
67 
68     /*
69     * @dev tracks token balances of users
70     */
71     mapping (address => uint256) balances;
72 
73     /*
74     * @dev transfer token for a specified address
75     */
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(_to != address(0));
78         require(_value <= balances[msg.sender]);
79 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /*
87     * @dev total number of tokens in existence
88     */
89     function totalSupply() public view returns (uint256) {
90         return totalSupply_;
91     }
92     /*
93     * @dev gets the balance of the specified address.
94     */
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99 
100 
101     // -----------------------------------------------------------------------
102     // ------------------------- ALLOWANCE RELEATED --------------------------
103     // -----------------------------------------------------------------------
104 
105     /*
106     * @dev tracks the allowance an address has from another one
107     */
108     mapping (address => mapping (address => uint256)) internal allowed;
109 
110     /*
111     * @dev transfers token from one address to another, must have allowance
112     */
113     function transferFrom(
114         address _from,
115         address _to,
116         uint256 _value
117     )
118         public
119         returns (bool success)
120     {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124 
125         balances[_from] = balances[_from].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128         emit Transfer(_from, _to, _value);
129         return true;
130     }
131 
132     /*
133     * @dev gives allowance to spender, works together with transferFrom
134     */
135     function approve(
136         address _spender,
137         uint256 _value
138     )
139         public
140         returns (bool success)
141     {
142         allowed[msg.sender][_spender] = _value;
143         emit Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147     /*
148     * @dev used to increase the allowance a spender has
149     */
150     function increaseApproval(
151         address _spender,
152         uint _addedValue
153     )
154         public
155         returns (bool success)
156     {
157         allowed[msg.sender][_spender] =
158             allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     /*
164     * @dev used to decrease the allowance a spender has
165     */
166     function decreaseApproval(
167         address _spender,
168         uint _subtractedValue
169     )
170         public
171         returns (bool success)
172     {
173         uint oldValue = allowed[msg.sender][_spender];
174         if (_subtractedValue > oldValue) {
175             allowed[msg.sender][_spender] = 0;
176         } else {
177             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178         }
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182 
183     /*
184     * @dev used to check what allowance a spender has from the owner
185     */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190         public
191         view
192         returns (uint256 remaining)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     // -----------------------------------------------------------------------
198     //--------------------------- MINTING RELEATED ---------------------------
199     // -----------------------------------------------------------------------
200     /*
201     * @title Mintable token
202     * @dev instead of another contract, all mintable functionality goes here
203     */
204     event Mint(
205         address indexed to,
206         uint256 amount
207     );
208     event MintFinished();
209 
210     /*
211     * @dev signifies whether or not minting process is over
212     */
213     bool public mintingFinished = false;
214 
215     modifier canMint() {
216         require(!mintingFinished);
217         _;
218     }
219 
220 
221     /*
222     * @dev minting of tokens, restricted to owner address (crowdsale)
223     */
224     function mint(
225         address _to,
226         uint256 _amount
227     )
228         public
229         onlyOwner
230         canMint
231         returns (bool success)
232     {
233         totalSupply_ = totalSupply_.add(_amount);
234         balances[_to] = balances[_to].add(_amount);
235         emit Mint(_to, _amount);
236         emit Transfer(address(0), _to, _amount);
237         return true;
238     }
239 
240     /*
241     * @dev Function to stop minting new tokens.
242     */
243     function finishMinting() onlyOwner canMint public returns (bool success) {
244         mintingFinished = true;
245         emit MintFinished();
246         return true;
247     }
248 }
249 
250 library SafeMath {
251 
252     /**
253     * @dev Multiplies two numbers, throws on overflow.
254     */
255     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
256         if (a == 0) {
257             return 0;
258         }
259         c = a * b;
260         assert(c / a == b);
261         return c;
262     }
263 
264     /**
265     * @dev Integer division of two numbers, truncating the quotient.
266     */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         // assert(b > 0); // Solidity automatically throws when dividing by 0
269         // uint256 c = a / b;
270         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
271         return a / b;
272     }
273 
274     /**
275     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
276     */
277     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
278         assert(b <= a);
279         return a - b;
280     }
281 
282     /**
283     * @dev Adds two numbers, throws on overflow.
284     */
285     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
286         c = a + b;
287         assert(c >= a);
288         return c;
289     }
290 }