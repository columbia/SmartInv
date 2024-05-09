1 // Bubble token air drop smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.18;
4 
5 /**
6  *   @title SafeMath
7  *   @dev Math operations with safety checks that throw on error
8  */
9 
10 library SafeMath {
11 
12   function mul(uint a, uint b) internal constant returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal constant returns(uint) {
22     assert(b > 0);
23     uint c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal constant returns(uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal constant returns(uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 
41 /**
42  *   @title ERC20
43  *   @dev Standart ERC20 token interface
44  */
45 
46 contract ERC20 {
47     uint public totalSupply = 0;
48 
49     mapping(address => uint) balances;
50     mapping(address => mapping (address => uint)) allowed;
51 
52     function balanceOf(address _owner) constant returns (uint);
53     function transfer(address _to, uint _value) returns (bool);
54     function transferFrom(address _from, address _to, uint _value) returns (bool);
55     function approve(address _spender, uint _value) returns (bool);
56     function allowance(address _owner, address _spender) constant returns (uint);
57 
58     event Transfer(address indexed _from, address indexed _to, uint _value);
59     event Approval(address indexed _owner, address indexed _spender, uint _value);
60 
61 }
62 
63 /**
64  *   @title BubbleToneToken
65  *   @dev Universal Bonus Token contract
66  */
67 contract BubbleToneToken is ERC20 {
68     using SafeMath for uint;
69     string public name = "Universal Bonus Token | t.me/bubbletonebot";
70     string public symbol = "UBT";
71     uint public decimals = 18;  
72 
73     // Smart-contract owner address
74     address public owner;
75     
76     //events
77     event Burn(address indexed _from, uint _value);
78     event Mint(address indexed _to, uint _value);
79     event ManagerAdded(address _manager);
80     event ManagerRemoved(address _manager);
81     event Defrosted(uint timestamp);
82     event Frosted(uint timestamp);
83 
84     // Tokens transfer ability status
85     bool public tokensAreFrozen = true;
86 
87     // mapping of user permissions
88     mapping(address => bool) public isManager;
89 
90 
91     // Allows execution by the owner only
92     modifier onlyOwner { 
93         require(msg.sender == owner); 
94         _; 
95     }
96 
97     // Allows execution by the managers only
98     modifier onlyManagers { 
99         require(isManager[msg.sender]); 
100         _; 
101     }
102 
103 
104    /**
105     *   @dev Contract constructor function sets owner address
106     *   @param _owner        owner address
107     */
108     function BubbleToneToken(address _owner) public {
109        owner = _owner;
110        isManager[_owner] = true;
111     }
112 
113    /**
114     *   @dev Get balance of tokens holder
115     *   @param _holder        holder's address
116     *   @return               balance of investor
117     */
118     function balanceOf(address _holder) constant returns (uint) {
119          return balances[_holder];
120     }
121 
122    /**
123     *   @dev Send coins
124     *   throws on any error rather then return a false flag to minimize
125     *   user errors
126     *   @param _to           target address
127     *   @param _amount       transfer amount
128     *
129     *   @return true if the transfer was successful
130     */
131     function transfer(address _to, uint _amount) public returns (bool) {
132         require(!tokensAreFrozen);
133         require(_to != address(0) && _to != address(this));
134         balances[msg.sender] = balances[msg.sender].sub(_amount);
135         balances[_to] = balances[_to].add(_amount);
136         Transfer(msg.sender, _to, _amount);
137         return true;
138     }
139 
140    /**
141     *   @dev An account/contract attempts to get the coins
142     *   throws on any error rather then return a false flag to minimize user errors
143     *
144     *   @param _from         source address
145     *   @param _to           target address
146     *   @param _amount       transfer amount
147     *
148     *   @return true if the transfer was successful
149     */
150     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
151         require(!tokensAreFrozen);
152         balances[_from] = balances[_from].sub(_amount);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
154         balances[_to] = balances[_to].add(_amount);
155         Transfer(_from, _to, _amount);
156         return true;
157      }
158 
159 
160    /**
161     *   @dev Allows another account/contract to spend some tokens on its behalf
162     *   throws on any error rather then return a false flag to minimize user errors
163     *
164     *   also, to minimize the risk of the approve/transferFrom attack vector
165     *   approve has to be called twice in 2 separate transactions - once to
166     *   change the allowance to 0 and secondly to change it to the new allowance
167     *   value
168     *
169     *   @param _spender      approved address
170     *   @param _amount       allowance amount
171     *
172     *   @return true if the approval was successful
173     */
174     function approve(address _spender, uint _amount) public returns (bool) {
175         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
176         allowed[msg.sender][_spender] = _amount;
177         Approval(msg.sender, _spender, _amount);
178         return true;
179     }
180 
181    /**
182     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
183     *
184     *   @param _owner        the address which owns the funds
185     *   @param _spender      the address which will spend the funds
186     *
187     *   @return              the amount of tokens still avaible for the spender
188     */
189     function allowance(address _owner, address _spender) constant returns (uint) {
190         return allowed[_owner][_spender];
191     }
192 
193 
194 
195   /**
196    * @dev Function to add an address to the managers
197    * @param _manager         an address that will be added to managers list
198    */
199     function addManager(address _manager) onlyOwner external {
200         require(!isManager[_manager]);
201         isManager[_manager] = true;
202         ManagerAdded(_manager);
203     }
204 
205   /**
206    * @dev Function to remove an address to the managers
207    * @param _manager         an address that will be removed from managers list
208    */
209     function removeManager(address _manager) onlyOwner external {
210         require(isManager[_manager]);
211         isManager[_manager] = false;
212         ManagerRemoved(_manager);
213     }
214 
215    /**
216     *   @dev Function to enable token transfers
217     */
218     function unfreeze() external onlyOwner {
219        tokensAreFrozen = false;
220        Defrosted(now);
221     }
222 
223 
224    /**
225     *   @dev Function to enable token transfers
226     */
227     function freeze() external onlyOwner {
228        tokensAreFrozen = true;
229        Frosted(now);
230     }
231 
232 
233 
234     /**
235      * @dev Function to batch mint tokens
236      * @param                _holders an array of addresses that will receive the promo tokens.
237      * @param                _amount an array with the amounts of tokens each address will get minted.
238      */
239     function batchMint(
240         address[] _holders, 
241         uint[] _amount) 
242         external
243         onlyManagers {
244         require(_holders.length == _amount.length);
245         for (uint i = 0; i < _holders.length; i++) {
246             require(_mint(_holders[i], _amount[i]));
247         }
248     }
249 
250    /**
251     *   @dev Function to burn Tokens
252     *   @param _holder       token holder address which the tokens will be burnt
253     *   @param _value        number of tokens to burn
254     */
255     function burnTokens(address _holder, uint _value) external onlyManagers {
256         require(balances[_holder] > 0);
257         totalSupply = totalSupply.sub(_value);
258         balances[_holder] = balances[_holder].sub(_value);
259         Burn(_holder, _value);
260     }
261 
262 
263 
264     /** 
265     *   @dev Allows owner to transfer out any accidentally sent ERC20 tokens
266     *
267     *   @param _token        token address
268     *   @param _amount       transfer amount
269     *
270     *
271     */
272     function withdraw(address _token, uint _amount) 
273         external
274         onlyOwner 
275         returns (bool success) {
276         return ERC20(_token).transfer(owner, _amount);
277     }
278 
279    /**
280     *   @dev Function to mint tokens
281     *   @param _holder       beneficiary address the tokens will be issued to
282     *   @param _value        amount of tokens to issue
283     */
284     function _mint(address _holder, uint _value) private returns (bool) {
285         require(_value > 0);
286         require(_holder != address(0) && _holder != address(this));
287         balances[_holder] = balances[_holder].add(_value);
288         totalSupply = totalSupply.add(_value);
289         Transfer(address(0), _holder, _value);
290         return true;
291     }
292 
293 }