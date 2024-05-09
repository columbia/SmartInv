1 pragma solidity ^0.4.7;
2 contract Investment{
3     /** the owner of the contract, C4C */
4     address owner;
5     /** List of all investors. */
6     address[] public investors;
7     /** The investors's balances. */
8     mapping(address => uint) public balances;
9     /** The total amount raised. */
10     uint public amountRaised;
11     /** The index of the investor currentlz being paid out. */
12     uint public investorIndex;
13     /** The return rates (factors) per interval (in raised Ether). */
14     uint[] public rates;
15     uint[] public limits;
16     /** indicates if ne investments are accepted */
17     bool public closed;
18     /** Notifies listeners that a new investment was undertaken */
19     event NewInvestment(address investor, uint amount);
20     /** Notifies listeners that ether was returned to the investors */
21     event Returned(uint amount);
22 
23     
24     function Investment(){
25         owner = msg.sender;
26         limits= [0, 1000000000000000000000, 4000000000000000000000, 10000000000000000000000];
27         rates= [15, 14, 13,12];//1 decimal
28     }
29     
30     /**
31      * Adds new investors to the list and calculates the balance according to the current rate.
32      * Minimum value: 1 ETH.
33      * */
34      function invest() payable{
35         if (closed) throw;
36         if (msg.value < 1 ether) throw;
37         if (balances[msg.sender]==0){//new investor
38             investors.push(msg.sender);
39         }
40         balances[msg.sender] += calcReturnValue(msg.value, amountRaised); 
41         amountRaised += msg.value;
42         NewInvestment(msg.sender, msg.value);
43      }
44      
45      /**
46       * call invest() whenever ether is sent to the contract
47       * */
48      function() payable{
49          invest();
50      }
51      
52      /**
53       * calcultes the return value depending on the amount raised, limits and rates
54       * @param value : the investment value
55       * @param amRa : the amount raised
56       * */
57      function calcReturnValue(uint value, uint amRa) internal returns (uint){
58          if(amRa >= limits[limits.length-1]) return value/10*rates[limits.length-1];
59          for(uint i = limits.length-2; i >= 0; i--){
60              if(amRa>=limits[i]){
61                 uint newAmountRaised = amRa+value;
62                 if(newAmountRaised>limits[i+1]){
63                     uint remainingVal=newAmountRaised-limits[i+1];
64                     return (value-remainingVal)/10 * rates[i] + calcReturnValue(remainingVal, limits[i+1]);
65                 }  
66                 else
67                     return value/10*rates[i];
68              }
69          }
70      }
71      
72      /**
73       * Enables the owner to withdraw the funds
74       * */
75      function withdraw(){
76          if(msg.sender==owner){
77              msg.sender.send(this.balance);
78          }
79      }
80      
81      /**
82       * called to pay the investor
83       * */
84      function returnInvestment() payable{
85         returnInvestmentRecursive(msg.value);
86         Returned(msg.value);
87      }
88      
89      /**
90       * sends the given value to the next investor(s) in the list
91       * */
92      function returnInvestmentRecursive(uint value) internal{
93         if (investorIndex>=investors.length || value==0) return;
94         else if(value<=balances[investors[investorIndex]]){
95             balances[investors[investorIndex]]-=value;
96             if(!investors[investorIndex].send(value)) throw; 
97         } 
98         else if(balances[investors[investorIndex]]>0){
99             uint val = balances[investors[investorIndex]];
100             balances[investors[investorIndex]]=0;
101             if(!investors[investorIndex].send(val)) throw;
102             investorIndex++;
103             returnInvestmentRecursive(value-val);
104         } 
105         else{
106             investorIndex++;
107             returnInvestmentRecursive(value);
108         }
109      }
110      
111      function getNumInvestors() constant returns(uint){
112          return investors.length;
113      }
114      
115      /** do not accept any more investments */
116      function close(){
117          if(msg.sender==owner)
118             closed=true;
119      }
120      
121      /** allow investments */
122      function open(){
123          if(msg.sender==owner)
124             closed=false;
125      }
126 }