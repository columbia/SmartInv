1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 
55 contract UsdPrice {
56     function USD(uint _id) public constant returns (uint256);
57 }
58 
59 
60 contract Ownable {
61     
62     address public owner;
63 
64     /**
65      * The address whcih deploys this contrcat is automatically assgined ownership.
66      * */
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     /**
72      * Functions with this modifier can only be executed by the owner of the contract. 
73      * */
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     event OwnershipTransferred(address indexed from, address indexed to);
80 
81     /**
82     * Transfers ownership to new Ethereum address. This function can only be called by the 
83     * owner.
84     * @param _newOwner the address to be granted ownership.
85     **/
86     function transferOwnership(address _newOwner) public onlyOwner {
87         require(_newOwner != 0x0);
88         emit OwnershipTransferred(owner, _newOwner);
89         owner = _newOwner;
90     }
91 }
92 
93 contract ERC20Basic {
94     uint256 public totalSupply;
95     string public name;
96     string public symbol;
97     uint8 public decimals;
98     function balanceOf(address who) constant public returns (uint256);
99     function transfer(address to, uint256 value) public returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 contract BasicToken is ERC20Basic {
104     
105     using SafeMath for uint256;
106     
107     mapping (address => uint256) internal balances;
108     
109     /**
110     * Returns the balance of the qeuried address
111     *
112     * @param _who The address which is being qeuried
113     **/
114     function balanceOf(address _who) public view returns(uint256) {
115         return balances[_who];
116     }
117     
118     /**
119     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
120     *
121     * @param _to The address of the receiver
122     * @param _value The amount of tokens to send
123     **/
124     function transfer(address _to, uint256 _value) public returns(bool) {
125         require(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         emit Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 }
132 
133 
134 contract ERC20 is ERC20Basic {
135     function allowance(address owner, address spender) constant public returns (uint256);
136     function transferFrom(address from, address to, uint256 value) public  returns (bool);
137     function approve(address spender, uint256 value) public returns (bool);
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 
142 contract StandardToken is BasicToken, ERC20, Ownable {
143     
144     address public MembershipContractAddr = 0x0;
145     
146     mapping (address => mapping (address => uint256)) internal allowances;
147     
148     function changeMembershipContractAddr(address _newAddr) public onlyOwner returns(bool) {
149         require(_newAddr != address(0));
150         MembershipContractAddr = _newAddr;
151     }
152     
153     /**
154     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
155     *
156     * @param _owner The address which is the owner of the tokens
157     * @param _spender The address which has been allowed to spend tokens on the owner's
158     * behalf
159     **/
160     function allowance(address _owner, address _spender) public view returns (uint256) {
161         return allowances[_owner][_spender];
162     }
163     
164     event TransferFrom(address msgSender);
165     /**
166     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
167     * allowed it previously. 
168     *
169     * @param _from The address of the owner
170     * @param _to The address of the recipient 
171     * @param _value The amount of tokens to be sent
172     **/
173     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
174         require(allowances[_from][msg.sender] >= _value || msg.sender == MembershipContractAddr);
175         require(balances[_from] >= _value && _value > 0 && _to != address(0));
176         emit TransferFrom(msg.sender);
177         balances[_from] = balances[_from].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         if(msg.sender != MembershipContractAddr) {
180             allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
181         }
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185     
186     /**
187     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
188     *
189     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
190     * @param _value The amount of tokens to be sent
191     **/
192     function approve(address _spender, uint256 _value) public returns (bool) {
193         require(_spender != 0x0 && _value > 0);
194         if(allowances[msg.sender][_spender] > 0 ) {
195             allowances[msg.sender][_spender] = 0;
196         }
197         allowances[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201 }
202 
203 contract BurnableToken is StandardToken {
204     
205     address public ICOaddr;
206     address public privateSaleAddr;
207     
208     constructor() public {
209         ICOaddr = 0x0;
210         privateSaleAddr = 0x0;
211     }
212     
213     event TokensBurned(address indexed burner, uint256 value);
214     
215     function burnFrom(address _from, uint256 _tokens) public onlyOwner {
216         require(ICOaddr == _from || privateSaleAddr == _from);
217         if(balances[_from] < _tokens) {
218             emit TokensBurned(_from,balances[_from]);
219             emit Transfer(_from, address(0), balances[_from]);
220             balances[_from] = 0;
221             totalSupply = totalSupply.sub(balances[_from]);
222         } else {
223             balances[_from] = balances[_from].sub(_tokens);
224             totalSupply = totalSupply.sub(_tokens);
225             emit TokensBurned(_from, _tokens);
226             emit Transfer(_from, address(0), _tokens);
227         }
228     }
229 }
230 
231 
232 contract AIB is BurnableToken {
233     
234     constructor() public {
235         name = "AI Bank";
236         symbol = "AIB";
237         decimals = 18;
238         totalSupply = 856750000e18;
239         balances[owner] = totalSupply;
240         emit Transfer(address(this), owner, totalSupply);
241     }
242 }
243 
244 
245 contract ICO is Ownable {
246     
247     using SafeMath for uint256;
248     
249     event PurchaseMade(address indexed by, uint256 tokensPurchased, uint256 tokenPricee);
250     event TokenPriceChanged(uint256 oldPrice, uint256 newPrice);
251     
252     UsdPrice public fiat;
253     AIB public AIBToken;
254     
255     uint256 public tokenPrice;
256     uint256 public deadline;
257     uint256 public softCap;
258     uint256 public tokensSold;
259     
260     
261     constructor() public {
262         fiat = UsdPrice(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
263         tokenPrice = 5;
264         deadline = 0;
265         softCap = 40000000e18;
266         tokensSold = 0;
267     }
268     
269     function startICO() public onlyOwner {
270         deadline = now.add(120 days);
271     }
272     
273     
274     /**
275      * Allows the owner of the contract to change the token price
276      * 
277      * @param _newPrice The new price value
278      */
279     function setTokenPrice(uint256 _newPrice) public onlyOwner {
280         require(_newPrice != tokenPrice && _newPrice > 0);
281         emit TokenPriceChanged(tokenPrice, _newPrice);
282         tokenPrice = _newPrice;
283     }
284     
285     
286     /**
287      * Allows the owner of the contract to set the token address
288      * 
289      * @param _addr The token contract address
290      * */
291     function setAIBTokenAddress(address _addr) public onlyOwner {
292         require(_addr != address(0));
293         AIBToken = AIB(_addr);
294     }
295     
296     
297     /**
298      * @return The unit price of the AIB token in ETH. 
299      * */
300     function getTokenPriceInETH() public view returns(uint256) {
301         return fiat.USD(0).mul(tokenPrice);
302     }
303     
304     /**
305      * @return 1 ETH worth of AIB tokens. 
306      * */
307     function getRate() public view returns(uint256) {
308         uint256 e18 = 1e18;
309         return e18.div(getTokenPriceInETH());
310     }
311     
312 
313     /**
314      * Allows investors to buy tokens
315      * 
316      * @param _addr The address of the investor 
317      * */
318     function buyTokens(address _addr) public payable returns(bool){
319         require(_addr != address(0) && msg.value > 0);
320         require(now <= deadline);
321         uint256 toTransfer = msg.value.mul(getRate());
322         AIBToken.transfer(_addr, toTransfer);
323         emit PurchaseMade(_addr, toTransfer, msg.value);
324         tokensSold = tokensSold.add(toTransfer);
325         return true;
326     }
327     
328     
329     function() public payable {
330         buyTokens(msg.sender);
331     }
332     
333     
334     /**
335      * Allows the owner to withdraw all the ETH from the contract if the 
336      * soft cap has been reached
337      * */
338     function withdrawEth() public onlyOwner {
339         require(tokensSold >= softCap);
340         owner.transfer(address(this).balance);
341     }
342     
343 
344     /**
345      * Allows the owner of the contract to withdraw AIB tokens 
346      * 
347      * @param _to The recipient address 
348      * @param _value The total amount of tokens to send
349      * */
350     function withdrawTokens(address _to, uint256 _value) public onlyOwner {
351         require(_to != address(0) && _value > 0);
352         AIBToken.transfer(_to, _value);
353     }
354     
355     
356     /**
357      * Allows the owner to send AIB tokens to investors who pay in currencies 
358      * other than ETH
359      * 
360      * @param _investor The ETH address of the investor 
361      * @param _value The total amount of tokens to send 
362      * */
363     function processOffchainPayment(address _investor, uint256 _value) public onlyOwner {
364         require(_investor != address(0) && _value > 0);
365         AIBToken.transfer(_investor, _value);
366         tokensSold = tokensSold.add(_value);
367         emit PurchaseMade(_investor, _value, 0);
368     }
369     
370 }