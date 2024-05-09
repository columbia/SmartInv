1 pragma solidity ^0.4.24;
2 
3 /*
4     Copyright 2018, Vicent Nos
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 
19 
20  */
21 
22 
23 
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 contract Ownable {
55     address public owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () internal {
60       owner = msg.sender;
61     }
62 
63     modifier onlyOwner() {
64         require(msg.sender == owner);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 
76 //////////////////////////////////////////////////////////////
77 //                                                          //
78 //  Alt Index, Open End Crypto Fund ERC20                    //
79 //                                                          //
80 //////////////////////////////////////////////////////////////
81 
82 contract ALXERC20 is Ownable {
83 
84     using SafeMath for uint256;
85 
86 
87     mapping (address => uint256) public balances;
88 
89     mapping (address => mapping (address => uint256)) internal allowed;
90 
91     mapping (address => mapping (uint256 => timeHold)) internal requestWithdraws;
92    
93  
94 
95     struct timeHold{
96         uint256[] amount;
97         uint256[] time;
98         uint256 length;
99     }
100    
101    function requestOfAmount(address addr, uint256 n) public view returns(uint256){
102      return requestWithdraws[addr][n].amount[0];   
103     }   
104    
105     function requestOfTime(address addr, uint256 n) public view returns(uint256){
106      return requestWithdraws[addr][n].time[0];   
107     }  
108     
109     uint256 public roundCounter=0;
110     
111     /* Public variables for the ERC20 token */
112     string public constant standard = "ERC20 ALX";
113     uint8 public constant decimals = 8; // hardcoded to be a constant
114     uint256 public totalSupply;
115     string public name;
116     string public symbol;
117 
118     uint256 public transactionFee = 1;
119 
120     uint256 public icoEnd=0;
121     
122     event Transfer(address indexed from, address indexed to, uint256 value);
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 
125 
126     function balanceOf(address _owner) public view returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130 
131     function setTransactionFee(uint256 _value) public onlyOwner{
132       transactionFee=_value;
133  
134     }
135 
136     function setIcoEnd(uint256 _value) public onlyOwner{
137       icoEnd=_value;
138  
139     }
140 
141     function transfer(address _to, uint256 _value) public returns (bool) {
142 
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145         require(block.timestamp>icoEnd);
146         // SafeMath.sub will throw if there is not enough balance.
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148 
149         uint256 fee=(_value*transactionFee)/1000;
150  
151         delete requestWithdraws[msg.sender][roundCounter];
152 
153         balances[_to] = balances[_to].add(_value-fee);
154         balances[owner]=balances[owner].add(fee);
155         
156         emit Transfer(msg.sender, _to, _value-fee);
157         emit Transfer(msg.sender, owner, fee);
158         return true;
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162         require(_to != address(0));
163         require(_value <= balances[_from]);
164         require(_value <= allowed[_from][msg.sender]);
165         require(block.timestamp>icoEnd);
166         balances[_from] = balances[_from].sub(_value);
167 
168         uint256 fee=(_value*transactionFee)/1000;
169 
170         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171 
172         delete requestWithdraws[msg.sender][roundCounter];
173         delete requestWithdraws[_from][roundCounter];
174 
175         balances[_to] = balances[_to].add(_value-fee);
176         balances[owner]=balances[owner].add(fee);
177         
178         emit Transfer(_from, _to, _value-fee);
179         emit Transfer(_from, owner, fee);
180         return true;
181     }
182 
183     function approve(address _spender, uint256 _value) public returns (bool) {
184         allowed[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     function allowance(address _owner, address _spender) public view returns (uint256) {
190         return allowed[_owner][_spender];
191     }
192 
193     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196         return true;
197     }
198 
199     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200         uint oldValue = allowed[msg.sender][_spender];
201         if (_subtractedValue > oldValue) {
202             allowed[msg.sender][_spender] = 0;
203         } else {
204             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205         }
206         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210     /* Approve and then communicate the approved contract in a single tx */
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
212         tokenRecipient spender = tokenRecipient(_spender);
213 
214         if (approve(_spender, _value)) {
215             spender.receiveApproval(msg.sender, _value, this, _extraData);
216             return true;
217         }
218     }
219 }
220 
221 
222 interface tokenRecipient {
223     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;
224 }
225 
226 
227 contract ALX is ALXERC20 {
228 
229     // Contract variables and constants
230 
231 
232     uint256 public tokenPrice = 30000000000000000;
233     uint256 public tokenAmount=0;
234 
235     // constant to simplify conversion of token amounts into integer form
236     uint256 public tokenUnit = uint256(10)**decimals;
237 
238     uint256 public holdTime;
239     uint256 public holdMax;
240     uint256 public maxSupply;
241 
242     //Declare logging events
243     event LogDeposit(address sender, uint amount);
244 
245 
246 
247     uint256 public withdrawFee = 1;
248 
249     /* Initializes contract with initial supply tokens to the creator of the contract */
250         constructor (
251             
252             uint256 initialSupply,
253             string contractName,
254             string tokenSymbol,
255             uint256 contractHoldTime,
256             uint256 contractHoldMax,
257             
258             address contractOwner
259 
260         ) public {
261 
262 
263         totalSupply = initialSupply;  // Update total supply
264         name = contractName;             // Set the name for display purposes
265         symbol = tokenSymbol;         // Set the symbol for display purposes
266         holdTime=contractHoldTime;
267         holdMax=contractHoldMax;
268         
269         owner=contractOwner;
270         balances[contractOwner]= balances[contractOwner].add(totalSupply);
271 
272     }
273 
274     function () public payable {
275         buy();   // Allow to buy tokens sending ether directly to contract
276     }
277 
278 
279     function deposit() external payable onlyOwner returns(bool success) {
280         // Check for overflows;
281         //executes event to reflect the changes
282         emit LogDeposit(msg.sender, msg.value);
283 
284         return true;
285     }
286 
287 
288     function setWithdrawFee(uint256 _value) public onlyOwner{
289       withdrawFee=_value;
290  
291     }
292     
293 
294 
295     function withdrawReward() external {
296 
297         uint i = 0;
298         uint256 ethAmount = 0;
299 
300         uint256 tokenM=0;
301         
302         if (block.timestamp -  requestWithdraws[msg.sender][roundCounter].time[i] > holdTime && block.timestamp -  requestWithdraws[msg.sender][roundCounter].time[i] < holdMax){
303                 ethAmount += tokenPrice * requestWithdraws[msg.sender][roundCounter].amount[i];
304                 tokenM +=requestWithdraws[msg.sender][roundCounter].amount[i];
305         }
306     
307         ethAmount=ethAmount/tokenUnit;
308         require(ethAmount > 0);
309 
310         emit LogWithdrawal(msg.sender, ethAmount);
311 
312         totalSupply = totalSupply.sub(tokenM);
313 
314         delete requestWithdraws[msg.sender][roundCounter];
315 
316         uint256 fee=ethAmount*withdrawFee/1000;
317 
318         balances[msg.sender] = balances[msg.sender].sub(tokenM);
319 
320         msg.sender.transfer(ethAmount-fee);
321         owner.transfer(fee);
322 
323     }
324 
325      
326     function withdraw(uint256 amount) public onlyOwner{ 
327         msg.sender.transfer(amount);
328     }
329 
330     function setPrice(uint256 _value) public onlyOwner{
331       tokenPrice=_value;
332       roundCounter++;
333 
334     }
335 
336 
337 
338     event LogWithdrawal(address receiver, uint amount);
339 
340     function requestWithdraw(uint256 value) public {
341       require(value <= balances[msg.sender]);
342 
343       delete requestWithdraws[msg.sender][roundCounter];
344 
345       requestWithdraws[msg.sender][roundCounter].amount.push(value);
346       requestWithdraws[msg.sender][roundCounter].time.push(block.timestamp);
347       requestWithdraws[msg.sender][roundCounter].length++;
348       //executes event ro register the changes
349 
350     }
351     
352     uint256 public minPrice=250000000000000000;
353     
354     function setMinPrice(uint256 value) public onlyOwner{
355         minPrice=value;
356     }
357 
358     function buy() public payable {
359         require(msg.value>=minPrice);
360         tokenAmount = (msg.value * tokenUnit) / tokenPrice ;  // calculates the amount
361         
362         transferBuy(msg.sender, tokenAmount);
363         owner.transfer(msg.value);
364     }
365 
366     function transferBuy(address _to, uint256 _value) internal returns (bool) {
367         require(_to != address(0));
368 
369         // SafeMath.add will throw if there is not enough balance.
370         totalSupply = totalSupply.add(_value);
371         
372         uint256 teamAmount=_value*100/1000;
373 
374         totalSupply = totalSupply.add(teamAmount);
375 
376 
377 
378         balances[_to] = balances[_to].add(_value);
379         balances[owner] = balances[owner].add(teamAmount);
380 
381         emit Transfer(this, _to, _value);
382         emit Transfer(this, owner, teamAmount);
383         return true;
384 
385     }
386 }