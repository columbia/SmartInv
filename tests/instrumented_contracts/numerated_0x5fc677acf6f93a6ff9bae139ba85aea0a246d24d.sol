1 pragma solidity ^0.4.15;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal constant returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37   function balanceOf(address who) constant returns (uint256);
38   function transfer(address to, uint256 value) returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40   function allowance(address owner, address spender) constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) returns (bool);
42   function approve(address spender, uint256 value) returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44     
45 }
46 
47 
48 contract BasicToken is ERC20 {
49     using SafeMath for uint256;
50 
51     mapping(address => uint256) balances;
52     mapping (address => mapping (address => uint256)) allowed;
53 
54     /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59 
60     function transfer(address _to, uint256 _value) returns (bool) {
61         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62             balances[msg.sender] = balances[msg.sender].sub(_value);
63             balances[_to] = balances[_to].add(_value);
64             Transfer(msg.sender, _to, _value);
65             return true;
66         }else {
67             return false;
68         }
69     }
70     
71 
72     /**
73    * @dev Transfer tokens from one address to another
74    * @param _from address The address which you want to send tokens from
75    * @param _to address The address which you want to transfer to
76    * @param _value uint256 the amout of tokens to be transfered
77    */
78 
79     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
80       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81         uint256 _allowance = allowed[_from][msg.sender];
82         allowed[_from][msg.sender] = _allowance.sub(_value);
83         balances[_to] = balances[_to].add(_value);
84         balances[_from] = balances[_from].sub(_value);
85         Transfer(_from, _to, _value);
86         return true;
87       } else {
88         return false;
89       }
90 }
91 
92 
93     /**
94   * @dev Gets the balance of the specified address.
95   * @param _owner The address to query the the balance of. 
96   * @return An uint256 representing the amount owned by the passed address.
97   */
98 
99     function balanceOf(address _owner) constant returns (uint256 balance) {
100     return balances[_owner];
101   }
102 
103   function approve(address _spender, uint256 _value) returns (bool) {
104 
105     // To change the approve amount you first have to reduce the addresses`
106     //  allowance to zero by calling `approve(_spender, 0)` if it is not
107     //  already 0 to mitigate the race condition described here:
108     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
109     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110 
111     allowed[msg.sender][_spender] = _value;
112     Approval(msg.sender, _spender, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Function to check the amount of tokens that an owner allowed to a spender.
118    * @param _owner address The address which owns the funds.
119    * @param _spender address The address which will spend the funds.
120    * @return A uint256 specifing the amount of tokens still avaible for the spender.
121    */
122   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126 
127 }
128 
129 contract HRAToken is BasicToken {
130 
131     using SafeMath for uint256;
132 
133     string public name = "HERA";                                //name of the token
134     string public symbol = "HRA";                               //symbol of the token
135     uint8 public decimals = 10;                                 //decimals
136     uint256 public initialSupply = 30000000 * 10**10;           //total supply of Tokens
137 
138     //variables
139     uint256 public totalAllocatedTokens;                         //variable to keep track of funds allocated
140     uint256 public tokensAllocatedToCrowdFund;                   //funds allocated to crowdfund
141 
142     //addresses
143     address public founderMultiSigAddress;                      //Multi sign address of founder
144     address public crowdFundAddress;                            //Address of crowdfund contract
145 
146     //events
147     event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
148     
149     //modifierss
150 
151     modifier nonZeroAddress(address _to){
152         require(_to != 0x0);
153         _;
154     }
155 
156     modifier onlyFounders(){
157         require(msg.sender == founderMultiSigAddress);
158         _;
159     }
160 
161     modifier onlyCrowdfund(){
162         require(msg.sender == crowdFundAddress);
163         _;
164     }
165 
166     //creation of token contract
167     function HRAToken(address _crowdFundAddress, address _founderMultiSigAddress) {
168         crowdFundAddress = _crowdFundAddress;
169         founderMultiSigAddress = _founderMultiSigAddress;
170 
171         // Assigned balances to crowdfund
172         balances[crowdFundAddress] = initialSupply;
173     }
174 
175     //function to keep track of the total token allocation
176     function changeTotalSupply(uint256 _amount) onlyCrowdfund {
177         totalAllocatedTokens += _amount;
178     }
179 
180     //function to change founder Multisig wallet address
181     function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
182         founderMultiSigAddress = _newFounderMultiSigAddress;
183         ChangeFoundersWalletAddress(now, founderMultiSigAddress);
184     }
185 
186 }
187 
188 contract HRACrowdfund {
189     
190     using SafeMath for uint256;
191 
192     HRAToken public token;                                    // Token contract reference
193     
194     address public founderMulSigAddress;                      // Founders multisig address
195     uint256 public exchangeRate;                              // Use to find token value against one ether
196     uint256 public ethRaised;                                 // Counter to track the amount raised
197     bool private tokenDeployed = false;                       // Flag to track the token deployment -- only can be set once
198     uint256 public tokenSold;                                 // Counter to track the amount of token sold
199     uint256 public manualTransferToken;                       // Counter to track the amount of manually tranfer token
200     uint256 public tokenDistributeInDividend;                 // Counter to track the amount of token shared to investors
201     uint8 internal EXISTS = 1;                                // Flag to track the existing investors
202     uint8 internal NEW = 0;                                   // Flag to track the non existing investors
203 
204     address[] public investors;                               // Investors address 
205 
206     mapping (address => uint8) internal previousInvestor;
207     //events
208     event ChangeFounderMulSigAddress(address indexed _newFounderMulSigAddress , uint256 _timestamp);
209     event ChangeRateOfToken(uint256 _timestamp, uint256 _newRate);
210     event TokenPurchase(address indexed _beneficiary, uint256 _value, uint256 _amount);
211     event AdminTokenSent(address indexed _to, uint256 _value);
212     event SendDividend(address indexed _to , uint256 _value, uint256 _timestamp);
213     
214     //Modifiers
215     modifier onlyfounder() {
216         require(msg.sender == founderMulSigAddress);
217         _;
218     }
219 
220     modifier nonZeroAddress(address _to) {
221         require(_to != 0x0);
222         _;
223     }
224 
225     modifier onlyPublic() {
226         require(msg.sender != founderMulSigAddress);
227         _;
228     }
229 
230     modifier nonZeroEth() {
231         require(msg.value != 0);
232         _;
233     }
234 
235     modifier isTokenDeployed() {
236         require(tokenDeployed == true);
237         _;
238     }
239     
240     // Constructor to initialize the local variables 
241     function HRACrowdfund(address _founderMulSigAddress) {
242         founderMulSigAddress = _founderMulSigAddress;
243         exchangeRate = 320;
244     }
245    
246    // Attach the token contract, can only be done once   
247     function setToken(address _tokenAddress) nonZeroAddress(_tokenAddress) onlyfounder {
248          require(tokenDeployed == false);
249          token = HRAToken(_tokenAddress);
250          tokenDeployed = true;
251     }
252     
253     // Function to change the exchange rate
254     function changeExchangeRate(uint256 _rate) onlyfounder returns (bool) {
255         if(_rate != 0){
256             exchangeRate = _rate;
257             ChangeRateOfToken(now,_rate);
258             return true;
259         }
260         return false;
261     }
262     
263     // Function to change the founders multisig address
264     function ChangeFounderWalletAddress(address _newAddress) onlyfounder nonZeroAddress(_newAddress) {
265          founderMulSigAddress = _newAddress;
266          ChangeFounderMulSigAddress(founderMulSigAddress,now);
267     }
268 
269     // Buy token function 
270     function buyTokens (address _beneficiary)
271     onlyPublic
272     nonZeroAddress(_beneficiary)
273     nonZeroEth
274     isTokenDeployed
275     payable
276     public
277     returns (bool)
278     {
279         uint256 amount = (msg.value.mul(exchangeRate)).div(10 ** 8);
280        
281         require(checkExistence(_beneficiary));
282 
283         if (token.transfer(_beneficiary, amount)) {
284             fundTransfer(msg.value);
285             previousInvestor[_beneficiary] = EXISTS;
286             ethRaised = ethRaised.add(msg.value);
287             tokenSold = tokenSold.add(amount);
288             token.changeTotalSupply(amount); 
289             TokenPurchase(_beneficiary, msg.value, amount);
290             return true;
291         }
292         return false;
293     }
294 
295     // Function to send token to user address
296     function sendToken (address _to, uint256 _value)
297     onlyfounder 
298     nonZeroAddress(_to) 
299     isTokenDeployed
300     returns (bool)
301     {
302         if (_value == 0)
303             return false;
304 
305         require(checkExistence(_to));
306         
307         uint256 _tokenAmount= _value * 10 ** uint256(token.decimals());
308 
309         if (token.transfer(_to, _tokenAmount)) {
310             previousInvestor[_to] = EXISTS;
311             manualTransferToken = manualTransferToken.add(_tokenAmount);
312             token.changeTotalSupply(_tokenAmount); 
313             AdminTokenSent(_to, _tokenAmount);
314             return true;
315         }
316         return false;
317     }
318     
319     // Function to check the existence of investor
320     function checkExistence(address _beneficiary) internal returns (bool) {
321          if (token.balanceOf(_beneficiary) == 0 && previousInvestor[_beneficiary] == NEW) {
322             investors.push(_beneficiary);
323         }
324         return true;
325     }
326     
327     // Function to calculate the percentage of token share to the existing investors
328     function provideDividend(uint256 _dividend) 
329     onlyfounder 
330     isTokenDeployed
331     {
332         uint256 _supply = token.totalAllocatedTokens();
333         uint256 _dividendValue = _dividend.mul(10 ** uint256(token.decimals()));
334         for (uint8 i = 0 ; i < investors.length ; i++) {
335             
336             uint256 _value = ((token.balanceOf(investors[i])).mul(_dividendValue)).div(_supply);
337             dividendTransfer(investors[i], _value);
338         }
339     }
340     
341     // Function to send the calculated tokens amount to the investor
342     function dividendTransfer(address _to, uint256 _value) private {
343         if (token.transfer(_to,_value)) {
344             token.changeTotalSupply(_value);
345             tokenDistributeInDividend = tokenDistributeInDividend.add(_value);
346             SendDividend(_to,_value,now);
347         }
348     }
349     
350     // Function to transfer the funds to founders account
351     function fundTransfer(uint256 _funds) private {
352         founderMulSigAddress.transfer(_funds);
353     }
354     
355     // Crowdfund entry
356     // send ether to the contract address
357     function () payable {
358         buyTokens(msg.sender);
359     }
360 
361 }