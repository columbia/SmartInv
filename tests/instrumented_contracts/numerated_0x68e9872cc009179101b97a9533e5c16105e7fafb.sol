1 // Bond Film Platform Token smart contract.
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
64  *   @title BondToken
65  *   @dev Bond Film Platform token contract
66  */
67 contract BondToken is ERC20 {
68     using SafeMath for uint;
69     string public name = "Bond Film Platform";
70     string public symbol = "BFP";
71     uint public decimals = 18;
72 
73     // Ico contract address
74     address public owner;
75     address public controller;
76     address public airDropManager;
77     
78     event LogBuyForInvestor(address indexed investor, uint value, string txHash);
79     event Burn(address indexed from, uint value);
80     event Mint(address indexed to, uint value);
81     
82     // Tokens transfer ability status
83     bool public tokensAreFrozen = true;
84 
85     // Allows execution by the owner only
86     modifier onlyOwner { 
87         require(msg.sender == owner); 
88         _; 
89     }
90 
91     // Allows execution by the controller only
92     modifier onlyController { 
93         require(msg.sender == controller); 
94         _; 
95     }
96 
97     // Allows execution by the air drop manager only
98     modifier onlyAirDropManager { 
99         require(msg.sender == airDropManager); 
100         _; 
101     }
102 
103    /**
104     *   @dev Contract constructor function sets Ico address
105     *   @param _owner        owner address
106     *   @param _controller   controller address
107     *   @param _airDropManager  air drop manager address
108     */
109     function BondToken(address _owner, address _controller, address _airDropManager) public {
110        owner = _owner;
111        controller = _controller;
112        airDropManager = _airDropManager; 
113     }
114 
115    /**
116     *   @dev Function to mint tokens
117     *   @param _holder       beneficiary address the tokens will be issued to
118     *   @param _value        number of tokens to issue
119     */
120     function mint(address _holder, uint _value) 
121         private
122         returns (bool) {
123         require(_value > 0);
124         balances[_holder] = balances[_holder].add(_value);
125         totalSupply = totalSupply.add(_value);
126         Transfer(address(0), _holder, _value);
127         return true;
128     }
129 
130 
131    /**
132     *   @dev Function for handle token issues
133     *   @param _holder       beneficiary address the tokens will be issued to
134     *   @param _value        number of tokens to issue
135     */
136     function mintTokens(
137         address _holder, 
138         uint _value) 
139         external 
140         onlyOwner {
141         require(mint(_holder, _value));
142         Mint(_holder, _value);
143     }
144 
145    /**
146     *   @dev Function to issues tokens for investors
147     *   @param _holder     address the tokens will be issued to
148     *   @param _value        number of BFP tokens
149     *   @param _txHash       transaction hash of investor's payment
150     */
151     function buyForInvestor(
152         address _holder, 
153         uint _value, 
154         string _txHash
155     ) 
156         external 
157         onlyController {
158         require(mint(_holder, _value));
159         LogBuyForInvestor(_holder, _value, _txHash);
160     }
161 
162 
163 
164     /**
165      * @dev Function to batch mint tokens
166      * @param _to An array of addresses that will receive the minted tokens.
167      * @param _amount An array with the amounts of tokens each address will get minted.
168      * @return A boolean that indicates whether the operation was successful.
169      */
170     function batchDrop(
171         address[] _to, 
172         uint[] _amount) 
173         external
174         onlyAirDropManager {
175         require(_to.length == _amount.length);
176         for (uint i = 0; i < _to.length; i++) {
177             require(_to[i] != address(0));
178             require(mint(_to[i], _amount[i]));
179         }
180     }
181 
182 
183    /**
184     *   @dev Function to enable token transfers
185     */
186     function unfreeze() external onlyOwner {
187        tokensAreFrozen = false;
188     }
189 
190 
191    /**
192     *   @dev Function to enable token transfers
193     */
194     function freeze() external onlyOwner {
195        tokensAreFrozen = true;
196     }
197 
198    /**
199     *   @dev Burn Tokens
200     *   @param _holder       token holder address which the tokens will be burnt
201     *   @param _value        number of tokens to burn
202     */
203     function burnTokens(address _holder, uint _value) external onlyOwner {
204         require(balances[_holder] > 0);
205         totalSupply = totalSupply.sub(_value);
206         balances[_holder] = balances[_holder].sub(_value);
207         Burn(_holder, _value);
208     }
209 
210    /**
211     *   @dev Get balance of tokens holder
212     *   @param _holder        holder's address
213     *   @return               balance of investor
214     */
215     function balanceOf(address _holder) constant returns (uint) {
216          return balances[_holder];
217     }
218 
219    /**
220     *   @dev Send coins
221     *   throws on any error rather then return a false flag to minimize
222     *   user errors
223     *   @param _to           target address
224     *   @param _amount       transfer amount
225     *
226     *   @return true if the transfer was successful
227     */
228     function transfer(address _to, uint _amount) public returns (bool) {
229         require(!tokensAreFrozen);
230         balances[msg.sender] = balances[msg.sender].sub(_amount);
231         balances[_to] = balances[_to].add(_amount);
232         Transfer(msg.sender, _to, _amount);
233         return true;
234     }
235 
236    /**
237     *   @dev An account/contract attempts to get the coins
238     *   throws on any error rather then return a false flag to minimize user errors
239     *
240     *   @param _from         source address
241     *   @param _to           target address
242     *   @param _amount       transfer amount
243     *
244     *   @return true if the transfer was successful
245     */
246     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
247         require(!tokensAreFrozen);
248         balances[_from] = balances[_from].sub(_amount);
249         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
250         balances[_to] = balances[_to].add(_amount);
251         Transfer(_from, _to, _amount);
252         return true;
253      }
254 
255 
256    /**
257     *   @dev Allows another account/contract to spend some tokens on its behalf
258     *   throws on any error rather then return a false flag to minimize user errors
259     *
260     *   also, to minimize the risk of the approve/transferFrom attack vector
261     *   approve has to be called twice in 2 separate transactions - once to
262     *   change the allowance to 0 and secondly to change it to the new allowance
263     *   value
264     *
265     *   @param _spender      approved address
266     *   @param _amount       allowance amount
267     *
268     *   @return true if the approval was successful
269     */
270     function approve(address _spender, uint _amount) public returns (bool) {
271         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
272         allowed[msg.sender][_spender] = _amount;
273         Approval(msg.sender, _spender, _amount);
274         return true;
275     }
276 
277    /**
278     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
279     *
280     *   @param _owner        the address which owns the funds
281     *   @param _spender      the address which will spend the funds
282     *
283     *   @return              the amount of tokens still avaible for the spender
284     */
285     function allowance(address _owner, address _spender) constant returns (uint) {
286         return allowed[_owner][_spender];
287     }
288 
289         /** 
290     *   @dev Allows owner to transfer out any accidentally sent ERC20 tokens
291     *
292     *   @param tokenAddress  token address
293     *   @param tokens        transfer amount
294     *
295     *
296     */
297     function transferAnyTokens(address tokenAddress, uint tokens) 
298         public
299         onlyOwner 
300         returns (bool success) {
301         return ERC20(tokenAddress).transfer(owner, tokens);
302     }
303 }