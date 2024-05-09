1 // Welcome to Reserve Token.
2 //
3 
4 
5 pragma solidity ^0.4.0;
6 
7 
8 contract ReserveToken {
9 
10     address public tank; //SBC - The tank of the contract
11     uint256 public tankAllowance = 0;
12     uint256 public tankOut = 0;
13     uint256 public valueOfContract = 0;
14     string public name;         //Name of the contract
15     string public symbol;       //Symbol of the contract
16     uint8 public decimals = 18;      //The amount of decimals
17 
18     uint256 public totalSupply; //The current total supply.
19     uint256 public maxSupply = uint256(0) - 10; //We let the max amount be the most the variable can handle. well... basically.
20     uint256 public tankImposedMax = 100000000000000000000000; //SBC - 10 million maximum tokens at first
21     uint256 public priceOfToken;    //The current price of a token
22     uint256 public divForSellBack = 2; //SBC - The split for when a sell back occurs
23     uint256 public divForTank = 200; //SBC - 20=5%. 100=1% 1000=.1% The amount given to the Abby.
24     uint256 public divForPrice = 200; //SBC - The rate in which we grow. 2x this is our possible spread.
25     uint256 public divForTransfer = 2; //SBC - The rate in which we grow. 2x this is our possible spread.
26     uint256 public firstTTax = 10000; //SBC - The amount added to cost of transfer if firstTTaxAmount
27     uint256 public firstTTaxAmount = 10000; //SBC - The sender amount must be greater than this amount.
28     uint256 public secondTTax = 20000; //SBC -
29     uint256 public secondTTaxAmount = 20000; //SBC
30     uint256 public minTokens = 100;     //SBC  - minimum amount of tickets a person may mixssxnt at once
31     uint256 public maxTokens = 1000;    //SBC -max amount of tickets a person may mint at once
32     uint256 public coinprice; //This is calculated on the fly in the sellprice. This is the last buy price. not the current.
33 
34     //Standard Token
35     mapping(address => uint256) public balances;
36     mapping(address => mapping(address => uint256)) public allowed;
37 
38 
39 
40     // Triggered when tokens are transferred.
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42 
43     // Triggered whenever approve(address _spender, uint256 _value) is called.
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 
46 
47     function ReserveToken() payable public {
48         name = "Reserve Token";
49         //Setting the name of the contract
50         symbol = "RSRV";
51         //Setting the symbol
52         tank = msg.sender;
53         //setting the tank
54         priceOfToken = 1 szabo;
55     }
56 
57     function MintTokens() public payable {
58         //Just some requirements for BuyTokens -- The Tank needs no requirements. (Tank is still subjected to fees)
59         address inAddress = msg.sender;
60         uint256 inMsgValue = msg.value;
61 
62         if (inAddress != tank) {
63             require(inMsgValue > 1000); //The minimum money supplied
64             require(inMsgValue > priceOfToken * minTokens); //The minimum amount of tokens you can buy
65             require(inMsgValue < priceOfToken * maxTokens); //The maximum amount of tokens.
66         }
67 
68 
69         //Add the incoming tank allowance to tankAllowance
70         tankAllowance += (inMsgValue / divForTank);
71         //add to the value of contact the incoming value - what the tank got.
72         valueOfContract += (inMsgValue - (inMsgValue / divForTank));
73         //new coins are equalal to teh new value of contract divided by the current price of token
74         uint256 newcoins = ((inMsgValue - (inMsgValue / divForTank)) * 1 ether) / (priceOfToken);
75 
76 
77 
78          //Ensure that we dont go over the max the tank has set.
79         require(totalSupply + newcoins < maxSupply);
80         //Ensure that we don't go oever the maximum amount of coins.
81         require(totalSupply + newcoins < tankImposedMax);
82 
83         
84 
85         //Update use balance, total supply, price of token.
86         totalSupply += newcoins;
87         priceOfToken += valueOfContract / (totalSupply / 1 ether) / divForPrice;
88         balances[inAddress] += newcoins;
89     }
90 
91     function BurnAllTokens() public {
92         address inAddress = msg.sender;
93         uint256 theirBalance = balances[inAddress];
94         //Get their balance without any crap code
95         require(theirBalance > 0);
96         //Make sure that they have enough money to cover this.
97         balances[inAddress] = 0;
98         //Remove the amount now, for re entry prevention
99         coinprice = valueOfContract / (totalSupply / 1 ether);
100         //Updating the coin price (buy back price)
101         uint256 amountGoingOut = coinprice * (theirBalance / 1 ether); //amount going out in etheruem
102         //We convert amount going out to amount without divforTank
103         uint256 tankAmount = (amountGoingOut / divForTank); //The amount going to the tank
104         amountGoingOut = amountGoingOut - tankAmount; //the new amount for our going out without the tank
105         //Amount going out minus theW
106         tankAllowance += (tankAmount - (tankAmount / divForSellBack)); //Give
107         //Add the the tank allowance, here we are functionally making the coin worth more.
108         valueOfContract -= amountGoingOut + (tankAmount / divForSellBack); //VOC = ago - (tankAmount left after tankAllowance)
109         //Updating the new value of our contract. what we will have after the transfer
110         msg.sender.transfer(amountGoingOut);
111         //Transfer the money
112         totalSupply -= theirBalance;
113 
114     }
115 
116     function BurnTokens(uint256 _amount) public {
117         address inAddress = msg.sender;
118         uint256 theirBalance = balances[inAddress];
119         //Get their balance without any crap code
120         require(_amount <= theirBalance);
121         //Make sure that they have enough money to cover this.
122         balances[inAddress] -= _amount;
123         //Remove the amount now, for re entry prevention
124         coinprice = valueOfContract / (totalSupply / 1 ether);
125         //Updating the coin price (buy back price)
126         uint256 amountGoingOut = coinprice * (_amount / 1 ether); //amount going out in etheruem
127         //We convert amount going out to amount without divforTank
128         uint256 tankAmount = (amountGoingOut / divForTank); //The amount going to the tank
129         amountGoingOut = amountGoingOut - tankAmount; //the new amount for our going out without the tank
130         //Amount going out minus theW
131         tankAllowance += (tankAmount - (tankAmount / divForSellBack)); //Give
132         //Add the the tank allowance, here we are functionally making the coin worth more.
133         valueOfContract -= amountGoingOut + (tankAmount / divForSellBack); //VOC = ago - (tankAmount left after tankAllowance)
134         //Updating the new value of our contract. what we will have after the transfer
135         msg.sender.transfer(amountGoingOut);
136         //Transfer the money
137         totalSupply -= _amount;
138 
139     }
140 
141     function CurrentCoinPrice() view public returns (uint256) {
142         uint256 amountGoingOut = valueOfContract / (totalSupply / 1 ether);
143         //We convert amount going out to amount without divforTank
144         uint256 tankAmount = (amountGoingOut / divForTank); //The amount going to the tank
145         return amountGoingOut - tankAmount; //the new amount for our going out without the tank
146     }
147 
148 
149     function TankWithdrawSome(uint256 _amount) public {
150         address inAddress = msg.sender;
151         require(inAddress == tank);
152         //Require person to be the tank
153 
154         //if our allowance is greater than the value of the contract then the contract must be empty.
155         if (tankAllowance < valueOfContract) {
156             require(_amount <= tankAllowance - tankOut);
157         }
158 
159         //Require the amount to be less than the amount for tank0.
160 
161         tankOut += _amount;
162         //Adding in new tank withdraw.
163         tank.transfer(_amount);
164         //transfering amount to tank's balance.
165     }
166 
167     //This is an ethereum withdraw for the tank.
168     function TankWithdrawAll() public {
169         address inAddress = msg.sender;
170         require(inAddress == tank);
171         //Require person to be the tank
172 
173         //if our allowance is greater than the value of the contract then the contract must be empty.
174         if (tankAllowance < valueOfContract) {
175             require(tankAllowance - tankOut > 0); //Tank allowance - tankout = whats left for tank. and it must be over zero
176         }
177 
178         //Require the amount to be less than the amount for tank0.
179 
180         tankOut += tankAllowance - tankOut; //We give whats left to our tankout makeing whats left zero. so tank cant double withdraw.
181         //Adding in new tank withdraw.
182         tank.transfer(tankAllowance - tankOut);
183         //transfering amount to tank's balance.
184     }
185 
186 
187 
188 
189 
190     function TankDeposit() payable public {
191         address inAddress = msg.sender;
192         uint256 inValue = msg.value;
193 
194         require(inAddress == tank);
195         //require the person to be a the tank
196 
197         if (inValue < tankOut) {
198             tankOut -= inValue;
199             // We cant underflow here because it has to be less.
200         }
201         else
202         {
203             //Add the excess to the contract value
204             valueOfContract += (inValue - tankOut) * 1 ether;
205             //We DO NOT INCREASE ALLOWANCE, we only allow the tank to go to zero.
206             tankOut = 0;
207 
208         }
209     }
210 
211 
212     // What is the balance of a particular account?
213     function balanceOf(address _owner) public constant returns (uint256 balance) {
214         return balances[_owner];
215     }
216 
217     function transferFee(uint256 _amount) view internal returns (uint256){
218         //If Amount is above the tax amount return the tax
219         if (_amount > secondTTaxAmount)
220             return secondTTax;
221 
222         if (_amount > firstTTaxAmount)
223             return firstTTax;
224     }
225 
226     // Transfer the balance from tank's account to another account
227     function transfer(address _to, uint256 _amount) public returns (bool success) {
228         //variables we are working with.
229         uint256 fromBalance = balances[msg.sender];
230         uint256 toBalance = balances[_to];
231         uint256 tFee = transferFee(_amount);
232 
233 
234         //Require the balance be greater than the amount + fee
235         require(fromBalance >= _amount + tFee);
236         //Require the amount ot be greater than 0.
237         require(_amount > 0);
238         //Require the toBalance to be greater than the current amount. w
239         require(toBalance + _amount > toBalance);
240 
241         balances[msg.sender] -= _amount + tFee;
242         balances[_to] += _amount;
243         balances[tank] += tFee / divForTransfer;
244         totalSupply -= tFee - (tFee / divForTransfer);
245 
246         emit Transfer(msg.sender, _to, _amount);
247         //Create Event
248 
249         return true;
250     }
251 
252 
253 
254 
255     // Send _value amount of tokens from address _from to address _to
256     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
257     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
258     // fees in sub-currencies; the command should fail unless the _from account has
259     // deliberately authorized the sender of the message via some mechanism; we propose
260     // these standardized APIs for approval:
261     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
262         uint256 fromBalance = balances[_from];  //The current balance of from
263         uint256 toBalance = balances[_to];      //The current blance for to
264         uint256 tFee = transferFee(_amount);    //The transaction fee that will be accociated with this transaction
265 
266         //Require the from balance to have more than the amount they want to send + the current fee
267         require(fromBalance >= _amount + tFee);
268         //Require the allowed balance to be greater than that amount as well.
269         require(allowed[_from][msg.sender] >= _amount + tFee);
270         //Require the current amount to be greater than 0.
271         require(_amount > 0);
272         //Require the to balance to gain an amount. protect against under and over flows
273         require(toBalance + _amount > toBalance);
274 
275         //Update from balance, allowed balance, to balance, tank balance, total supply. create Transfer event.
276         balances[_from] -= _amount + tFee;
277         allowed[_from][msg.sender] -= _amount + tFee;
278         balances[_to] += _amount;
279         balances[tank] += tFee / divForTransfer;
280         totalSupply -= tFee - (tFee / divForTransfer);
281         emit Transfer(_from, _to, _amount);
282 
283         return true;
284     }
285 
286 
287 
288     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
289     // If this function is called again it overwrites the current allowance with _value.
290     function approve(address _spender, uint256 _amount) public returns (bool success) {
291         allowed[msg.sender][_spender] = _amount;
292         emit Approval(msg.sender, _spender, _amount);
293         return true;
294     }
295 
296 
297 
298     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
299         return allowed[_owner][_spender];
300     }
301 
302      function GrabUnallocatedValue() public {
303          address inAddress = msg.sender;
304          require(inAddress == tank);
305          //Sometimes someone sends money straight to the contract but that isn't recorded in the value of teh contract.
306          //So here we allow tank to withdraw those extra funds
307          address walletaddress = this;
308          if (walletaddress.balance * 1 ether > valueOfContract) {
309             tank.transfer(walletaddress.balance - (valueOfContract / 1 ether));
310          }
311     }
312 
313 
314     function TankTransfer(address _NewTank) public {
315         address inAddress = msg.sender;
316         require(inAddress == tank);
317         tank = _NewTank;
318     }
319 
320     function SettankImposedMax(uint256 _input) public {
321          address inAddress = msg.sender;
322          require(inAddress == tank);
323          tankImposedMax = _input;
324     }
325 
326     function SetdivForSellBack(uint256 _input) public {
327          address inAddress = msg.sender;
328          require(inAddress == tank);
329          divForSellBack = _input;
330     }
331 
332     function SetdivForTank(uint256 _input) public {
333          address inAddress = msg.sender;
334          require(inAddress == tank);
335          divForTank = _input;
336     }
337 
338     function SetdivForPrice(uint256 _input) public {
339          address inAddress = msg.sender;
340          require(inAddress == tank);
341          divForPrice = _input;
342     }
343 
344     function SetfirstTTax(uint256 _input) public {
345          address inAddress = msg.sender;
346          require(inAddress == tank);
347          firstTTax = _input;
348     }
349 
350     function SetfirstTTaxAmount(uint256 _input) public {
351          address inAddress = msg.sender;
352          require(inAddress == tank);
353          firstTTaxAmount = _input;
354     }
355 
356     function SetsecondTTax(uint256 _input) public {
357          address inAddress = msg.sender;
358          require(inAddress == tank);
359          secondTTax = _input;
360     }
361 
362     function SetsecondTTaxAmount(uint256 _input) public {
363          address inAddress = msg.sender;
364          require(inAddress == tank);
365          secondTTaxAmount = _input;
366     }
367 
368     function SetminTokens(uint256 _input) public {
369          address inAddress = msg.sender;
370          require(inAddress == tank);
371          minTokens = _input;
372     }
373 
374     function SetmaxTokens(uint256 _input) public {
375          address inAddress = msg.sender;
376          require(inAddress == tank);
377          maxTokens = _input;
378     }
379 
380     function SetdivForTransfer(uint256 _input) public {
381          address inAddress = msg.sender;
382          require(inAddress == tank);
383          divForTransfer = _input;
384     }
385 
386 
387 
388 }