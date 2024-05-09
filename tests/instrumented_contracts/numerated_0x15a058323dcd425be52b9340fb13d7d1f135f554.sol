1 pragma solidity ^0.4.11;
2 
3 //defines the contract (this is the entire program basically)
4 
5 contract TeaToken {
6     //Definition section. To the non-devs, define means "tell the compiler this concept exists and if I mention it later this is what im talking about" 
7 
8     //please note that define does not mean fill with data, that happens later on. Im merely telling the computer these variables exist so it doesnt get confused later.
9 
10     uint256 public pricePreSale = 1000000 wei;                       //this is how much each token costs
11 
12     uint256 public priceStage1 = 2000000 wei;         
13 
14     uint256 public priceStage2 = 4000000 wei;         
15 
16     uint256 tea_tokens;
17 
18     mapping(address => uint256) public balanceOf;               //this is used to measure how much money some wallet just sent us
19 
20     bool public crowdsaleOpen = true;                               //this is a true-false statement that tells the program whether or not the crowdsale is still going. Unlike the others, this one actually does have data saved to it via the = false;
21 
22     string public name = "TeaToken";                             //this is the name of the token, what normies will see in their Ether Wallets
23 
24     string public symbol = "TEAT";
25 
26     uint256 public decimals = 8;
27 
28     uint256 durationInMinutes = 10080;              // one week
29 
30     uint256 public totalAmountOfTeatokensCreated = 0;
31 
32     uint256 public totalAmountOfWeiCollected = 0;
33 
34     uint256 public preSaleDeadline = now + durationInMinutes * 1 minutes;         //how long until the crowdsale ends
35 
36     uint256 public icoStage1Deadline = now + (durationInMinutes * 2) * 1 minutes;         //how long until the crowdsale ends
37 
38     uint256 deadmanSwitchDeadline = now + (durationInMinutes * 4) * 1 minutes;         //how long until the crowdsale ends
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     event Payout(address indexed to, uint256 value);
43 
44     //How the cost of each token works. There are no floats in ethereum. A float is a decimal place number for the non-devs. So in order to do less than one ether you have to define it in subunits. 1000 finney is one ether, and 1000 szabo is one finney. So 1 finney will buy you 10 TeaTokens, or one ETH will buy you 10,000 TeaTokens. This means one TeaToken during presale will cost exactly 100 szabo.
45 
46     //1 szabo is a trillion wei
47 
48     //definitions for disbursement
49 
50     address address1 = 0xa1288081489C16bA450AfE33D1E1dF97D33c85fC;//prog
51     address address2 = 0x2DAAf6754DbE3714C0d46ACe2636eb43671034D6;//undiscolsed
52     address address3 = 0x86165fd44C96d4eE1e7038D27301E9804D908f0a;//ariana
53     address address4 = 0x18555e00bDAEd991f30e530B47fB1c21F93F0389;//biz
54     address address5 = 0xB64BD3310445562802f18e188Bf571D479105029;//potato
55     address address6 = 0x925F937721E56d06401FC4D191F411382127Df83;//ugly
56     address address7 = 0x13688Dd97616f85A363d715509529cFdfe489663;//architectl
57     address address8 = 0xC89dB702363E8a100a4b04fDF41c9Dfee572627B;//johnny
58     address address9 = 0xB11b98305e4d55610EB18C480477A6984Aa7f7e2;//thawk
59     address address10 = 0xb2Ef8eae3ADdB4E66268b49467eeA64F6cD937cf;//danielt
60     address address11 = 0x46e8180a477349013434e191E63f2AFD645fd153;//drschultz
61     address address12 = 0xC7b32902a15c02F956F978E9F5A3e43342266bf2;//nos
62     address address13 = 0xA0b43B97B66a84F3791DE513cC8a35213325C1Ba;//bigmoney
63     address address14 = 0xAEe620D07c16c92A7e8E01C096543048ab591bf9;//dinkin
64     
65 
66     address[] adds = [address1, address2, address3, address4, address5, address6, address7, address8, address9, address10, address11, address12, address13, address14];
67     uint numAddresses = adds.length;
68     uint sendValue;
69 
70     //controller addresses
71     //these are the addresses of programmanon, ariana and bizraeli. We can use these to control the contract.
72     address controllerAddress1 = 0x86165fd44C96d4eE1e7038D27301E9804D908f0a;//ari
73     address controllerAddress2 = 0xa1288081489C16bA450AfE33D1E1dF97D33c85fC;//prog
74     address controllerAddress3 = 0x18555e00bDAEd991f30e530B47fB1c21F93F0389;//biz
75 
76     /* The function without name is the default function that is called whenever anyone sends funds to a contract. The keyword payable makes sure that this contract can recieve money. */
77 
78 
79 
80     function () payable {
81 
82 
83 
84         //if (crowdsaleOpen) throw;     //throw means reject the transaction. This will prevent people from accidentally sending money to a crowdsale that is already closed.
85         require(crowdsaleOpen);
86 
87         uint256 amount = msg.value;                            //measures how many ETH coins they sent us (the message) and stores it as an integer called "amount"
88         //presale
89 
90         if (now <= preSaleDeadline){
91         tea_tokens = (amount / pricePreSale);  
92         //stage 1
93 
94         }else if (now <= icoStage1Deadline){
95         tea_tokens = (amount / priceStage1);  
96         //stage 2
97         }else{
98         tea_tokens = (amount / priceStage2);                        //calculates their total amount of tokens bought
99         }
100 
101         totalAmountOfWeiCollected += amount;                        //this keeps track of overall profits collected
102         totalAmountOfTeatokensCreated += (tea_tokens/100000000);    //this keeps track of the planetary supply of TEA
103         balanceOf[msg.sender] += tea_tokens;                        //this adds the reward to their total.
104     }
105 
106 //this is how we get our money out. It can only be activated after the deadline currently.
107 
108     function safeWithdrawal() {
109 
110         //this checks to see if the sender is actually authorized to trigger the withdrawl. The sender must be the beneficiary in this case or it wont work.
111         //the now >= deadline*3 line acts as a deadman switch, ensuring that anyone in the world can trigger the fund release after the specified time
112 
113         require(controllerAddress1 == msg.sender || controllerAddress2 == msg.sender || controllerAddress3 == msg.sender || now >= deadmanSwitchDeadline);
114         require(this.balance > 0);
115 
116         uint256 sendValue = this.balance / numAddresses;
117         for (uint256 i = 0; i<numAddresses; i++){
118 
119                 //for the very final address, send the entire remaining balance instead of the divisor. This is to prevent remainders being left behind.
120 
121                 if (i == numAddresses-1){
122 
123                 Payout(adds[i], this.balance);
124 
125                 if (adds[i].send(this.balance)){}
126 
127                 }
128                 else Payout(adds[i], sendValue);
129                 if (adds[i].send(sendValue)){}
130             }
131 
132     }
133 
134     //this is used to turn off the crowdsale during stage 3. It can also be used to shut down all crowdsales permanently at any stage. It ends the ICO no matter what.
135 
136 
137 
138     function endCrowdsale() {
139         //this checks to see if the sender is actually authorized to trigger the withdrawl. The sender must be the beneficiary in this case or it wont work.
140 
141         require(controllerAddress1 == msg.sender || controllerAddress2 == msg.sender || controllerAddress3 == msg.sender || now >= deadmanSwitchDeadline);
142         //shuts down the crowdsale
143         crowdsaleOpen = false;
144     }
145     /* Allows users to send tokens to each other, to act as money */
146     //this is the part of the program that allows exchange between the normies. 
147     //This has nothing to do with the actual contract execution, this is so people can trade it back and fourth with each other and exchanges.
148     //Without this section the TeaTokens would be trapped in their account forever, unable to move.
149 
150     function transfer(address _to, uint256 _value) {
151 
152         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
153 
154         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows. If someone sent like 500 googolplex tokens it would actually go back to zero again because of an overflow. Computerized integers can only store so many numbers before they run out of room for more. This prevents that from causing a problem. Fun fact: this shit right here is what caused the Y2K bug everyone was panicking about back in 1999
155 
156         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
157 
158         balanceOf[_to] += _value;                            // Add the same to the recipient
159 
160         /* Notify anyone listening that this transfer took place */
161         Transfer(msg.sender, _to, _value);
162     }
163 }