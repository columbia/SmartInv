1 pragma solidity ^0.4.9;
2 
3  /*
4  * Contract that is working with ERC223 tokens
5  */
6  
7 contract ContractReceiver {
8     function tokenFallback(address _from, uint _value, bytes _data) public;
9 } 
10 
11  /**
12  * ERC223 token by Dexaran
13  *
14  * https://github.com/Dexaran/ERC223-tokens
15  */
16  
17  
18  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
19 contract SafeMath {
20     uint256 constant public MAX_UINT256 =
21     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
22 
23     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
24         if (x > MAX_UINT256 - y) throw;
25         return x + y;
26     }
27 
28     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
29         if (x < y) throw;
30         return x - y;
31     }
32 
33     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
34         if (y == 0) return 0;
35         if (x > MAX_UINT256 / y) throw;
36         return x * y;
37     }
38 }
39  
40 contract CoinvestToken is SafeMath {
41     
42     address public maintainer;
43     address public icoContract; // icoContract is needed to allow it to transfer tokens during crowdsale.
44     uint256 public lockupEndTime; // lockupEndTime is needed to determine when users may start transferring.
45     
46     bool public ERC223Transfer_enabled = false;
47     bool public Transfer_data_enabled = false;
48     bool public Transfer_nodata_enabled = true;
49 
50     event Transfer(address indexed from, address indexed to, uint value, bytes data);
51     event ERC223Transfer(address indexed from, address indexed to, uint value, bytes data);
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed _from, address indexed _spender, uint indexed _amount);
54 
55     mapping(address => uint) balances;
56 
57     // Owner of account approves the transfer of an amount to another account
58     mapping(address => mapping (address => uint256)) allowed;
59   
60 
61     string public constant symbol = "COIN";
62     string public constant name = "Coinvest COIN Token";
63     
64     uint8 public constant decimals = 18;
65     uint256 public totalSupply = 107142857 * (10 ** 18);
66     
67     /**
68      * @dev Set owner and beginning balance.
69      * @param _lockupEndTime The time at which the token may be traded.
70     **/
71     function CoinvestToken(uint256 _lockupEndTime)
72       public
73     {
74         balances[msg.sender] = totalSupply;
75         lockupEndTime = _lockupEndTime;
76         maintainer = msg.sender;
77     }
78   
79   
80     // Function that is called when a user or another contract wants to transfer funds .
81     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) transferable returns (bool success) {
82       
83         if(isContract(_to)) {
84             if (balanceOf(msg.sender) < _value) throw;
85             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
86             balances[_to] = safeAdd(balanceOf(_to), _value);
87             assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));
88             if(Transfer_data_enabled)
89             {
90                 Transfer(msg.sender, _to, _value, _data);
91             }
92             if(Transfer_nodata_enabled)
93             {
94                 Transfer(msg.sender, _to, _value);
95             }
96             if(ERC223Transfer_enabled)
97             {
98                 ERC223Transfer(msg.sender, _to, _value, _data);
99             }
100             return true;
101         }
102         else {
103             return transferToAddress(_to, _value, _data);
104         }
105     }
106 
107     function ERC20transfer(address _to, uint _value, bytes _data) transferable returns (bool success) {
108         bytes memory empty;
109         return transferToAddress(_to, _value, empty);
110     }
111 
112     // Function that is called when a user or another contract wants to transfer funds .
113     function transfer(address _to, uint _value, bytes _data) transferable returns (bool success) {
114         if(isContract(_to)) {
115             return transferToContract(_to, _value, _data);
116         }
117         else {
118             return transferToAddress(_to, _value, _data);
119         }
120     }
121   
122     // Standard function transfer similar to ERC20 transfer with no _data .
123     // Added due to backwards compatibility reasons .
124     function transfer(address _to, uint _value) transferable returns (bool success) {
125       
126         //standard function transfer similar to ERC20 transfer with no _data
127         //added due to backwards compatibility reasons
128         bytes memory empty;
129         if(isContract(_to)) {
130             return transferToContract(_to, _value, empty);
131         }
132         else {
133             return transferToAddress(_to, _value, empty);
134         }
135     }
136 
137     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
138     function isContract(address _addr) public returns (bool is_contract) {
139         uint length;
140         assembly {
141             //retrieve the size of the code on target address, this needs assembly
142             length := extcodesize(_addr)
143         }
144         return (length>0);
145     }
146 
147     //function that is called when transaction target is an address
148     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
149         if (balanceOf(msg.sender) < _value) throw;
150         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
151         balances[_to] = safeAdd(balanceOf(_to), _value);
152         if(Transfer_data_enabled)
153         {
154             Transfer(msg.sender, _to, _value, _data);
155         }
156         if(Transfer_nodata_enabled)
157         {
158             Transfer(msg.sender, _to, _value);
159         }
160         if(ERC223Transfer_enabled)
161         {
162             ERC223Transfer(msg.sender, _to, _value, _data);
163         }
164         return true;
165     }
166   
167     //function that is called when transaction target is a contract
168     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
169         if (balanceOf(msg.sender) < _value) throw;
170         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
171         balances[_to] = safeAdd(balanceOf(_to), _value);
172         ContractReceiver receiver = ContractReceiver(_to);
173         receiver.tokenFallback(msg.sender, _value, _data);
174         if(Transfer_data_enabled)
175         {
176             Transfer(msg.sender, _to, _value, _data);
177         }
178         if(Transfer_nodata_enabled)
179         {
180             Transfer(msg.sender, _to, _value);
181         }
182         if(ERC223Transfer_enabled)
183         {
184             ERC223Transfer(msg.sender, _to, _value, _data);
185         }
186         return true;
187     }
188 
189 
190     function balanceOf(address _owner) constant returns (uint balance) {
191         return balances[_owner];
192     }
193     
194     function totalSupply() constant returns (uint256) {
195         return totalSupply;
196     }
197 
198     /**
199      * @dev An allowed address can transfer tokens from another's address.
200      * @param _from The owner of the tokens to be transferred.
201      * @param _to The address to which the tokens will be transferred.
202      * @param _amount The amount of tokens to be transferred.
203     **/
204     function transferFrom(address _from, address _to, uint _amount)
205       external
206       transferable
207     returns (bool success)
208     {
209         require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);
210 
211         allowed[_from][msg.sender] -= _amount;
212         balances[_from] -= _amount;
213         balances[_to] += _amount;
214         bytes memory empty;
215         
216         Transfer(_from, _to, _amount, empty);
217         return true;
218     }
219 
220     /**
221      * @dev Approves a wallet to transfer tokens on one's behalf.
222      * @param _spender The wallet approved to spend tokens.
223      * @param _amount The amount of tokens approved to spend.
224     **/
225     function approve(address _spender, uint256 _amount) 
226       external
227       transferable // Protect from unlikely maintainer-receiver trickery
228     {
229         require(balances[msg.sender] >= _amount);
230         
231         allowed[msg.sender][_spender] = _amount;
232         Approval(msg.sender, _spender, _amount);
233     }
234     
235     /**
236      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
237     **/
238     function token_escape(address _tokenContract)
239       external
240       only_maintainer
241     {
242         CoinvestToken lostToken = CoinvestToken(_tokenContract);
243         
244         uint256 stuckTokens = lostToken.balanceOf(address(this));
245         lostToken.transfer(maintainer, stuckTokens);
246     }
247 
248     /**
249      * @dev Allow maintainer to set the ico contract for transferable permissions.
250     **/
251     function setIcoContract(address _icoContract)
252       external
253       only_maintainer
254     {
255         require(icoContract == 0);
256         icoContract = _icoContract;
257     }
258 
259     /**
260      * @dev Allowed amount for a user to spend of another's tokens.
261      * @param _owner The owner of the tokens approved to spend.
262      * @param _spender The address of the user allowed to spend the tokens.
263     **/
264     function allowance(address _owner, address _spender) 
265       external
266       constant 
267     returns (uint256) 
268     {
269         return allowed[_owner][_spender];
270     }
271     
272     function adjust_ERC223Transfer(bool _value) only_maintainer
273     {
274         ERC223Transfer_enabled = _value;
275     }
276     
277     function adjust_Transfer_nodata(bool _value) only_maintainer
278     {
279         Transfer_nodata_enabled = _value;
280     }
281     
282     function adjust_Transfer_data(bool _value) only_maintainer
283     {
284         Transfer_data_enabled = _value;
285     }
286     
287     modifier only_maintainer
288     {
289         assert(msg.sender == maintainer);
290         _;
291     }
292     
293     /**
294      * @dev Allows the current maintainer to transfer maintenance of the contract to a new maintainer.
295      * @param newMaintainer The address to transfer ownership to.
296      */
297     function transferMaintainer(address newMaintainer) only_maintainer public {
298         require(newMaintainer != address(0));
299         maintainer = newMaintainer;
300     }
301     
302     modifier transferable
303     {
304         if (block.timestamp < lockupEndTime) {
305             require(msg.sender == maintainer || msg.sender == icoContract);
306         }
307         _;
308     }
309     
310 }